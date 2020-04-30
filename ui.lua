
local _, AQSELF = ...

local debug = AQSELF.debug
local clone = AQSELF.clone
local diff = AQSELF.diff
local L = AQSELF.L
local player = AQSELF.player
local GetItemTexture = AQSELF.GetItemTexture

function AQSELF.createItemBar()

	-- 选择BUTTON类似，才能触发鼠标事件
	local f = CreateFrame("Button", "AutoEquip_ItemBar", UIParent)
	AQSELF.bar = f
	AQSELF.list = {}

	f:SetFrameStrata("BACKGROUND")
	f:SetWidth(95)
	f:SetHeight(40)

	-- 可以使用鼠标
	f:EnableMouse(true)

	AQSELF.bar:SetMovable(not AQSV.locked)
	if AQSV.locked then
		-- 关闭拖动，同时不影响右键单击
		AQSELF.bar:RegisterForDrag("")
	else
		AQSELF.bar:RegisterForDrag("LeftButton")
	end

	-- 实现拖动
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)

    local t = f:CreateTexture(nil, "BACKGROUND")
    -- 有材质才能设置颜色和透明度
	t:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
	t:SetVertexColor(0, 0, 0, 0.9)
	-- 尺寸和位置覆盖
	t:SetAllPoints(f)

  	f:SetFrameLevel(1)

	f:SetPoint("CENTER", AQSV.x, AQSV.y)
	f:Show()

	f:RegisterEvent("UNIT_INVENTORY_CHANGED")
	f:SetScript("OnEvent", AQSELF.onInventoryChanged)

	-- 创建右键菜单
	AQSELF.createMenu()

	-- 绘制冷却时间
	f.TimeSinceLastUpdate = 0
	-- 函数执行间隔时间
	f.Interval = 0.2
	f:SetScript("OnUpdate", AQSELF.cooldownUpdate)

	-- 创建按钮
	for k,v in pairs(AQSELF.slots) do
		AQSELF.createItemButton( v, k )
	end
end

function  AQSELF.createMenu()

	local menuFrame = CreateFrame("Frame", nil, AQSELF.bar, "UIDropDownMenuTemplate")

	local menu = {}

	menu[1] = {}
	menu[1]["text"] = L[" Lock"]
	menu[1]["checked"] = AQSV.locked
	menu[1]["func"] = function()
		AQSV.locked = not AQSV.locked
		menu[1]["checked"] = AQSV.locked

		AQSELF.bar:SetMovable(not AQSV.locked)
		if AQSV.locked then
			AQSELF.bar:RegisterForDrag("")
		else
			AQSELF.bar:RegisterForDrag("LeftButton")
		end
	end

	menu[2] = {}
	menu[2]["text"] = L[" Settings"]
	menu[2]["func"] = function()
		InterfaceOptionsFrame_OpenToCategory("AutoEquip");
		InterfaceOptionsFrame_OpenToCategory("AutoEquip");
	end

	menu[3] = {}
	menu[3]["text"] = L[" Close"]
	menu[3]["func"] = function()
		menuFrame:Hide()
	end

	AQSELF.menu = menuFrame

	AQSELF.bar:RegisterForClicks("RightButtonDown");
	AQSELF.bar:SetScript('OnClick', function(self, button)
	    EasyMenu(menu, menuFrame, "cursor", 0 , 0, "MENU")
	end)
end

function AQSELF.createItemButton( slot_id, position )

	local button = CreateFrame("Button", nil, AQSELF.bar, "SecureActionButtonTemplate")
	button:SetSize(40, 40)

	local itemId = GetInventoryItemID("player", slot_id)
	local itemTexture = ""
	if itemId then
		itemTexture = GetItemTexture(itemId)
	end

	button:SetAttribute("type1", "item")
	-- 饰品切换后自动匹配
    button:SetAttribute("slot", slot_id)

  	button:SetFrameLevel(2)
  	-- 高亮材质
  	button:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square", "ADD")
	

    local t = button:CreateTexture(nil, "BACKGROUND")
    -- 贴上物品的材质
	t:SetTexture(itemTexture)
	t:SetAllPoints(button)
	button.texture = t

	-- 文字单独一个frame，因为要盖住冷却动画
	local tf = CreateFrame("Frame", nil, button)
	tf:SetAllPoints(button)
	tf:SetFrameLevel(4)

	local text = tf:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	text:SetFont(STANDARD_TEXT_FONT, 18)
	text:SetShadowColor(0, 0, 0, 1)
	text:SetShadowOffset(1, 1)
    text:SetPoint("TOP", button, 2, 8)
    
    button.text = text

    local cooldown = CreateFrame("Frame", nil, button)
    -- 设0不成功
    cooldown:SetSize(40, 1)
    cooldown:SetPoint("TOP", button, 0, 0)
    cooldown:SetFrameLevel(3)

   	local t1 = cooldown:CreateTexture(nil, "BACKGROUND")
	t1:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
	t1:SetVertexColor(0, 0, 0, 0.7)
	t1:SetAllPoints(cooldown)
	
	button.cooldown = cooldown

	-- 按钮定位
   	button:SetPoint("TOPLEFT", AQSELF.bar, (position - 1) * (40 +3), 0)
   	button:Show()

   	-- 显示tooltip
   	button:SetScript("OnEnter", function(self)
		AQSELF.showTooltip("inventory", slot_id)
	end)
   	button:SetScript("OnLeave", AQSELF.hideTooltip)

   	-- 缓存
   	AQSELF.slotFrames[slot_id] = button
end

-- 更新按钮材质
function AQSELF.updateItemButton( slot_id )
	local itemId = GetInventoryItemID("player", slot_id)
	local button = AQSELF.slotFrames[slot_id]
	local itemTexture = ""
	if itemId then
		itemTexture = GetItemTexture(itemId)
	end

	button.texture:SetTexture(itemTexture)
end

function AQSELF.onInventoryChanged( self, event, arg1 )
	if event == "UNIT_INVENTORY_CHANGED" and arg1 == "player" then
		for k,v in pairs(AQSELF.slots) do
			AQSELF.updateItemButton( v )
		end
	end
end

-- 绘制下方的饰品队列
function AQSELF.createCooldownUnit( item_id, position )
	local f = CreateFrame("Frame", nil, AQSELF.bar)
	f:SetPoint("TOPLEFT", AQSELF.bar, 0 , - 45 - (position - 1) * 22)
	f:SetSize(20, 20)

	local t = f:CreateTexture(nil, "BACKGROUND")
	t:SetTexture(GetItemTexture(item_id))
	t:SetAllPoints(f)

	local text = f:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	text:SetFont(STANDARD_TEXT_FONT, 14)
	text:SetShadowColor(0, 0, 0, 1)
	text:SetShadowOffset(1, 1)
    text:SetPoint("TOP", f, 25, 0)
    text:SetJustifyH("LEFT")

    f.text = text

	f:Show()

	return f
end

function AQSELF.showTooltip( t, arg1, arg2 )
	local tooltip = _G[RGGM_CONSTANTS.ELEMENT_TOOLTIP]
    tooltip:ClearLines()
	tooltip:SetOwner(UIParent)
	GameTooltip_SetDefaultAnchor(tooltip, UIParent)

	if t == "inventory" then
		tooltip:SetInventoryItem("player", arg1)
	elseif t == "bag" then
		tooltip:SetBagItem(arg1, arg2)
	end
	
    tooltip:Show()
end

function AQSELF.hideTooltip()
	local tooltip = _G[RGGM_CONSTANTS.ELEMENT_TOOLTIP]
    tooltip:Hide()
end

function AQSELF.cooldownUpdate( self, elapsed )
	self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed;  

    if (self.TimeSinceLastUpdate > self.Interval) then
    	-- 重新计时
        self.TimeSinceLastUpdate = 0

        -- 计算图标上的冷却时间
    	for k,v in pairs(AQSELF.slots) do
    		local itemId = GetInventoryItemID("player", v)

    		if itemId then
    			-- 获取饰品的冷却状态
			    local start, duration, enable = GetItemCooldown(itemId)
			    -- 剩余冷却时间
			    local rest = math.ceil(duration - GetTime() + start)

			    local button = AQSELF.slotFrames[v]

			    if duration > 0 and rest > 0 then
			    	local text = rest
			    	if rest > 60 then
			    		text = math.ceil(rest/60).."m"
			    	end

			    	button.text:SetText(text)
			    	local height = (rest/duration)*40
			    	button.cooldown:SetHeight(height)
			    else
					button.text:SetText()
					button.cooldown:SetHeight(1)
			    end
    		end
		end

		-- 计算冷却队列
		local queue = clone(AQSV.usable)

	    -- 如果在战场里，执行联盟徽记逻辑
	    if UnitInBattleground("player") then
	        table.insert(queue, 1, AQSELF.pvp)
	    end

	    local slot13Id = GetInventoryItemID("player", 13)
	    local slot14Id = GetInventoryItemID("player", 14)

	    local slotIds = {slot13Id, slot14Id}

	    -- 算出等待换上的饰品
	    local wait = diff(queue, slotIds)

	    -- 根据顺序创建图标，或者使其显示
	    for k,v in pairs(wait) do
	    	if not AQSELF.list[v] then
	    		AQSELF.list[v] = AQSELF.createCooldownUnit(v, k)
	    	else
	    		AQSELF.list[v]:SetPoint("TOPLEFT", AQSELF.bar, 0 , -45 - (k - 1) * 22)
	    		AQSELF.list[v]:Show()
	    	end
	    end

	    for k,v in pairs(AQSELF.list) do
	    	-- 如果已经换上了，隐藏
	    	if not tContains(wait, k) then
	    		v:Hide()
	    	else
	    		-- 获取饰品的冷却状态
			    local start, duration, enable = GetItemCooldown(k)
			    -- 剩余冷却时间
			    local rest = math.ceil(duration - GetTime() + start)

			    -- 在队列中的显示冷却时间
			    if duration > 0 and rest > 0 then
			    	local text = rest
			    	if rest > 60 then
			    		text = math.ceil(rest/60).."m"
			    	end

			    	v.text:SetText(text)
			    else
					v.text:SetText()
			    end
	    	end
	    end
    end
end