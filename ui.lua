
local _, AQSELF = ...

local debug = AQSELF.debug
local clone = AQSELF.clone
local diff = AQSELF.diff
local L = AQSELF.L
local player = AQSELF.player
local GetItemTexture = AQSELF.GetItemTexture
local otherSlot = AQSELF.otherSlot

function AQSELF.createItemBar()

	-- 选择BUTTON类似，才能触发鼠标事件
	local f = CreateFrame("Button", "AutoEquip_ItemBar", UIParent)
	AQSELF.bar = f
	AQSELF.list = {}
	AQSELF.itemButtons = {}

	local new = {}
	-- 确定装备栏个数
	for k,v in pairs(AQSV.enableItemBarSlot) do
		if v then
			table.insert(new, k)
		end
	end

	table.sort( new )
	AQSELF.slots = AQSELF.merge(AQSELF.slots, new)

	f:SetFrameStrata("MEDIUM")
	f:SetWidth(#AQSELF.slots * (43) + 10)
	f:SetHeight(40)
	f:SetScale(AQSV.barZoom)

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
    f.texture = t
    -- 有材质才能设置颜色和透明度
	t:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
	
	AQSELF.hideBackdrop()

	-- 尺寸和位置覆盖
	t:SetAllPoints(f)

  	f:SetFrameLevel(1)

  	-- 初始化位置
	f:SetPoint(AQSV.point, AQSV.x, AQSV.y)

	-- 换装备时更新按钮


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

	-- 创建PVP标识
	local pvpIcon = CreateFrame("Frame", nil, f)
	pvpIcon:SetSize(20,20)
	pvpIcon:SetPoint("TOPLEFT", f, -23, 0)

	local pvpTexture = pvpIcon:CreateTexture(nil, "BACKGROUND")
	pvpTexture:SetTexture(132147)
	pvpTexture:SetAllPoints(pvpIcon)

	if AQSV.pvpMode then
		pvpIcon:Show()
	else
		pvpIcon:Hide()
	end

	AQSELF.pvpIcon = pvpIcon

	-- 设置里是否启用装备栏
	if AQSV.enableItemBar then
		f:Show()
	else
		f:Hide()
	end

	AQSELF.bindingSlot( )
end

function AQSELF.hideBackdrop(  )
	if AQSV.hideBackdrop then
		AQSELF.bar.texture:SetVertexColor(0, 0, 0, 0)
	else
		AQSELF.bar.texture:SetVertexColor(0, 0, 0, 0.9)
	end
end

function  AQSELF.createMenu()

	local menuFrame = CreateFrame("Frame", nil, AQSELF.bar, "UIDropDownMenuTemplate")

	local menu = {}

	menu[1] = {}
	menu[1]["text"] = " "..L["Enable AutoEquip function"]
	menu[1]["checked"] = AQSV.enable
	menu[1]["func"] = function()
		AQSELF.enableAutoEuquip()
	end

	menu[2] = {}
	menu[2]["text"] = L[" Enable PVP mode"]
	menu[2]["checked"] = AQSV.pvpMode
	menu[2]["func"] = function()
		AQSELF.enablePvpMode()
	end

	menu[3] = {}
	menu[3]["text"] = L[" Settings"]
	menu[3]["func"] = function()
		InterfaceOptionsFrame_OpenToCategory(AQSELF.general);
		InterfaceOptionsFrame_OpenToCategory(AQSELF.general);
	end

	menu[4] = {}
	menu[4]["text"] = L[" Lock frame"]
	menu[4]["checked"] = AQSV.locked
	menu[4]["func"] = function()
		AQSV.locked = not AQSV.locked
		AQSELF.lockItemBar()
	end

	menu[5] = {}
	menu[5]["text"] = L[" Close"]
	menu[5]["func"] = function()
		menuFrame:Hide()
	end

	AQSELF.menu = menuFrame
	AQSELF.menuList = menu

	AQSELF.bar:RegisterForClicks("RightButtonDown");
	AQSELF.bar:SetScript('OnClick', function(self, button)
	    EasyMenu(menu, menuFrame, "cursor", 0 , 0, "MENU")
	end)
end

function AQSELF.lockItemBar()
	
	AQSELF.menuList[4]["checked"] = AQSV.locked

	AQSELF.bar:SetMovable(not AQSV.locked)
	if AQSV.locked then
		AQSELF.bar:RegisterForDrag("")
	else
		AQSELF.bar:RegisterForDrag("LeftButton")
	end

	AQSELF.f.checkbox["locked"]:SetChecked(AQSV.locked)
end

function AQSELF.createItemButton( slot_id, position )

	local button = CreateFrame("Button", "AQBTN"..slot_id, AQSELF.bar, "SecureActionButtonTemplate")
	button:SetSize(40, 40)

	local itemId = GetInventoryItemID("player", slot_id)
	local itemTexture = ""
	if itemId then
		itemTexture = GetItemTexture(itemId)
	else
		_, itemTexture = GetInventorySlotInfo(AQSELF.slotName[slot_id])
	end

	-- 不然会继承parent的按键设置
	button:RegisterForClicks("AnyDown")

	-- 左键触发物品
	button:SetAttribute("type1", "item")
	-- 饰品切换后自动匹配点击功能
    button:SetAttribute("slot", slot_id)

    -- 右键解锁
    button:SetAttribute("type2", "unlockSlot")
    button.unlockSlot = function( ... )
    	AQSELF.cancelLocker(slot_id)
    end

  	button:SetFrameLevel(2)
  	-- 高亮材质
  	button:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square", "ADD")

 --  	button:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 2});
	-- button:SetBackdropBorderColor(0,0,0,0.5);
	-- button:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	

    local t = button:CreateTexture(nil, "BACKGROUND")
    -- 贴上物品的材质
	t:SetTexture(itemTexture)
	t:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	t:SetAllPoints(button)
	button.texture = t

	-- 文字单独一个frame，因为要盖住冷却动画
	local tf = CreateFrame("Frame", nil, button)
	tf:SetAllPoints(button)
	tf:SetFrameLevel(4)

	local text = tf:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	text:SetFont(STANDARD_TEXT_FONT, 18, "OUTLINE")
	-- text:SetShadowColor(0, 0, 0, 1)
	-- text:SetShadowOffset(1, -1)
    text:SetPoint("TOPLEFT", button, 1, 8)
    
    button.text = text

    -- 冷却动画层
    local cooldown = CreateFrame("Frame", nil, button)
    -- 设0不成功
    cooldown:SetSize(40, 1)
    cooldown:SetPoint("TOPLEFT", button, 0, 0)
    cooldown:SetFrameLevel(3)

   	local t1 = cooldown:CreateTexture(nil, "BACKGROUND")
	t1:SetTexture("Interface\\Tooltips\\UI-Tooltip-Background")
	t1:SetVertexColor(0, 0, 0, 0.7)
	t1:SetAllPoints(cooldown)
	
	button.cooldown = cooldown

	-- 饰品队列层
    local wait = CreateFrame("Frame", nil, button)
    -- 设0不成功
    wait:SetSize(20, 20)
    wait:SetPoint("BOTTOMRIGHT", button, 0, 0)
    wait:SetFrameLevel(4)

   	local t2 = wait:CreateTexture(nil, "BACKGROUND")
	t2:SetAllPoints(wait)
	
	button.wait = t2

	-- 锁定层
    local locker = CreateFrame("Frame", nil, button)
    -- 设0不成功
    locker:SetSize(16, 16)
    locker:SetPoint("BOTTOMRIGHT", button, 0, 2)
    locker:SetFrameLevel(4)

   	local t3 = locker:CreateTexture(nil, "BACKGROUND")
	t3:SetAllPoints(locker)
	t3:SetTexture("Interface\\GLUES\\CharacterSelect\\Glues-AddOn-Icons.blp")
	t3:SetTexCoord(0, 0.25, 0, 1)

	if AQSV.slotStatus[slot_id].locked then
		t3:Show()
	else
		t3:Hide()
	end
	
	button.locker = t3

	-- button:RegisterForClicks("RightButtonDown");
	-- button:SetScript('OnClick', function(self, button)
	--     EasyMenu(menu, menuFrame, "cursor", 0 , 0, "MENU")
	-- end)

	-- 按钮定位
   	button:SetPoint("TOPLEFT", AQSELF.bar, (position - 1) * (40 +3), 0)
   	button:Show()

   	-- 显示tooltip
   	button:SetScript("OnEnter", function(self)
		AQSELF.showTooltip("inventory", slot_id)

		-- 更新物品在背包里的位置
		AQSELF.updateItemInBags()

		-- 显示可用饰品的下拉框
		AQSELF.itemDropdownTimestamp = nil

		local index = 1
		local itemId1 = GetInventoryItemID("player", slot_id)
		local itemId2 = GetInventoryItemID("player", otherSlot(slot_id))

		for k,v in pairs(AQSELF.items[slot_id]) do
			if v ~= itemId1 and v ~= itemId2 and v > 0 then
				AQSELF.createItemDropdown(v, 43 * (position - 1), index, slot_id)
				index = index + 1
			elseif AQSELF.itemButtons[v] then
				AQSELF.itemButtons[v]:Hide()
			end
		end

		for k,v in pairs(AQSELF.itemButtons) do
			if v.inSlot ~= slot_id then
				v:Hide()
			end
		end
	end)
   	button:SetScript("OnLeave", function( self )
   		AQSELF.hideTooltip()
   		AQSELF.hideItemDropdown( 0.5 )
   	end)

   	-- 缓存
   	AQSELF.slotFrames[slot_id] = button
end


function AQSELF.hideItemDropdown( delay )
	-- 设置计时
	AQSELF.itemDropdownTimestamp = GetTime()
	AQSELF.itemDropdownDelay =  delay
end

-- 在update里执行
function AQSELF.doHideItemDropdown()
	if AQSELF.itemDropdownTimestamp then
		if GetTime() - AQSELF.itemDropdownTimestamp > AQSELF.itemDropdownDelay then
			for k,v in pairs(AQSELF.itemButtons) do
	   			v:Hide()
	   		end
	   		AQSELF.itemDropdownTimestamp = nil
		end
	end
end

-- 创建饰品下拉框
function AQSELF.createItemDropdown(item_id, x, position, slot_id)

	if item_id == 0 then
		return
	end

	-- 分列，计算位置
	position = position - 1
		
	local newX = math.floor(position / AQSV.itemsPerColumn)
	local newY = position % AQSV.itemsPerColumn + 1

	-- 如果已经创建过物品图层，只修改位置
	if AQSELF.itemButtons[item_id] then
		AQSELF.itemButtons[item_id]:SetPoint("TOPLEFT", AQSELF.bar, x + newX * 43, 5+43 * newY)
		AQSELF.itemButtons[item_id]:Show()
		-- 点击图标是获取正确的slot
		AQSELF.itemButtons[item_id].inSlot = slot_id
		return
	end

	local button

	-- if slot_id == 16 or slot_id == 17 or slot_id == 18 then
	-- 	button = CreateFrame("Button", nil, AQSELF.bar, "SecureActionButtonTemplate")
	-- 	button:SetAttribute("type", "item")
	-- 	-- 饰品切换后自动匹配点击功能
	--     button:SetAttribute("item", item_id)
	-- else
		button = CreateFrame("Button", nil, AQSELF.bar)
	-- end
	
	

	button:SetSize(40, 40)

	local itemTexture = GetItemTexture(item_id)

  	button:SetFrameLevel(100)
  	-- 高亮材质
  	button:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square", "ADD")
	

    local t = button:CreateTexture(nil, "BACKGROUND")
    -- 贴上物品的材质
	t:SetTexture(itemTexture)
	-- 取消边框
	t:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	t:SetAllPoints(button)
	button.texture = t

	-- 文字单独一个frame，因为要盖住冷却动画
	local tf = CreateFrame("Frame", nil, button)
	tf:SetAllPoints(button)
	tf:SetFrameLevel(101)

	local text = tf:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	text:SetFont(STANDARD_TEXT_FONT, 16, "OUTLINE")
	-- text:SetShadowColor(0, 0, 0, 1)
	-- text:SetShadowOffset(1, -1)
    text:SetPoint("TOPLEFT", button, 0,-1)
    text:SetJustifyH("LEFT")
    
    button.text = text

	-- 按钮定位
   	button:SetPoint("TOPLEFT", AQSELF.bar, x + newX * 43, 5+43 * newY)
   	button:Show()

   	button:SetScript("OnEnter", function(self)
   		-- 停掉隐藏下拉框的计时器
		AQSELF.itemDropdownTimestamp = nil

		AQSELF.showTooltip("bag", AQSELF.itemInBags[item_id][1], AQSELF.itemInBags[item_id][2])
	end)
   	button:SetScript("OnLeave", function( self )
   		-- 开启隐藏计时
   		AQSELF.hideItemDropdown( 0.5 )
   		AQSELF.hideTooltip()
   	end)

	button.inSlot = slot_id

   	button:EnableMouse(true)
   	button:RegisterForClicks("AnyDown");
	button:SetScript('OnClick', function(self)

		-- 点击后立即隐藏下拉框
	    for k,v in pairs(AQSELF.itemButtons) do
   			v:Hide()
   		end

        if not AQSELF.playerCanEquip() then
        	-- 缓存起来
        	AQSELF.setWait(item_id, button.inSlot)
            return 
        else
        	-- 立即装备
        	AQSELF.equipWait(item_id, button.inSlot)
        end
       
	end)

   	-- 缓存
   	AQSELF.itemButtons[item_id] = button
end

-- 更新按钮材质
function AQSELF.updateItemButton( slot_id )
	local itemId = GetInventoryItemID("player", slot_id)
	local button = AQSELF.slotFrames[slot_id]
	local itemTexture = ""
	if itemId then
		itemTexture = GetItemTexture(itemId)
	else
		_, itemTexture = GetInventorySlotInfo(AQSELF.slotName[slot_id])
	end

	if button then
		button.texture:SetTexture(itemTexture)
	end
end

function AQSELF.bindingSlot( )
	if UnitAffectingCombat("player") then return end

	for k,v in pairs(AQSELF.slotFrames) do
		ClearOverrideBindings(v)

		local keys = {GetBindingKey("AUTOEQUIP_BUTTON"..k)}

		for k1,v1 in pairs(keys) do

			if v1 and v1 ~= "" then
				SetOverrideBindingClick(v, false, v1, "AQBTN"..k)
			end
		end
	end


end

-- 绘制下方的饰品队列
function AQSELF.createCooldownUnit( item_id, position )
	local f = CreateFrame("Frame", nil, AQSELF.bar)
	-- f:SetPoint("TOPLEFT", AQSELF.bar, 0 , - 43 - (position - 1) * 23)
	f:SetSize(20, 20)

	local t = f:CreateTexture(nil, "BACKGROUND")
	t:SetTexture(GetItemTexture(item_id))
	-- 取消边框
	t:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	t:SetAllPoints(f)

	local text = f:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	text:SetFont(STANDARD_TEXT_FONT, 13, "OUTLINE")
	-- text:SetShadowColor(0, 0, 0, 1)
	-- text:SetShadowOffset(1, -1)
    text:SetPoint("TOP", f, 20, -1)
    text:SetJustifyH("LEFT")

    f.text = text

	f:Show()

	return f
end

function AQSELF.showTooltip( t, arg1, arg2 )
	local tooltip = _G["GameTooltip"]
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
	local tooltip = _G["GameTooltip"]
    tooltip:Hide()
end

function AQSELF.cooldownUpdate( self, elapsed )
	self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed;  

    if (self.TimeSinceLastUpdate > self.Interval) then
    	-- 重新计时
        self.TimeSinceLastUpdate = 0

        AQSELF.doHideItemDropdown()

        -- 计算图标上的冷却时间
    	for k,v in pairs(AQSELF.slots) do
    		local itemId = GetInventoryItemID("player", v)

    		if itemId then
    			-- 获取饰品的冷却状态
			    local start, duration, enable = GetItemCooldown(itemId)
			    -- 剩余冷却时间
			    local rest = duration - GetTime() + start

			    local button = AQSELF.slotFrames[v]

			    if duration > 0 and rest > 0 then
			    	local text = math.floor(rest)
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
			else
				local button = AQSELF.slotFrames[v]
				-- 装备被换下，清空倒计时
				button.text:SetText()
				button.cooldown:SetHeight(1)
    		end
		end

		-- 计算饰品下拉框的冷却时间
		for k,v in pairs(AQSELF.itemButtons) do
			-- if AQSELF.itemButtons[v] then
				-- 获取饰品的冷却状态
			    local start, duration, enable = GetItemCooldown(k)
			    -- 剩余冷却时间
			    local rest = math.floor(duration - GetTime() + start)

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
			-- end
		end

		AQSELF.loopSlots(function(slot_id)

			-- 计算冷却队列
			local queue = AQSELF.buildQueueRealtime(slot_id)

			-- print(queue)

			wipe(AQSELF.empty2)

			local slotIds = AQSELF.empty2

		    slotIds[1] = GetInventoryItemID("player", slot_id)

		    if slot_id == 13 then
		    	slotIds[2] = GetInventoryItemID("player", 14)
		    end

		    -- local slotIds = {slot13Id, slot14Id}

		    -- -- 算出等待换上的饰品
		    local wait = diff(queue, slotIds)

		    if AQSELF.list[slot_id] == nil then
		    	AQSELF.list[slot_id] = {}
		    end

		    -- 根据顺序创建图标，或者使其显示
		    for k,v in pairs(wait) do
		    	if not AQSELF.list[slot_id][v] then
		    		AQSELF.list[slot_id][v] = AQSELF.createCooldownUnit(v, k)
		    	else
		    		-- AQSELF.list[v]:SetPoint("TOPLEFT", AQSELF.bar, 0 , -43 - (k - 1) * 23)
		    		AQSELF.list[slot_id][v]:Show()
		    	end
		    	
		    	local point, relativeTo, relativePoint, xOfs, yOfs = AQSELF.slotFrames[slot_id]:GetPoint()

		    	if AQSV.reverseCooldownUnit then
		    		AQSELF.list[slot_id][v]:SetPoint("TOPLEFT", AQSELF.bar, xOfs , 30 + (k - 1) * 23)
		    	else
		    		AQSELF.list[slot_id][v]:SetPoint("TOPLEFT", AQSELF.bar, xOfs , -43 - (k - 1) * 23)
		    	end
		    	
		    end

		    for k,v in pairs(AQSELF.list[slot_id]) do
		    	-- 如果已经换上了，隐藏
		    	if not tContains(wait, k) then
		    		v:Hide()
		    	else
		    		-- 获取饰品的冷却状态
				    local start, duration, enable = GetItemCooldown(k)
				    -- 剩余冷却时间
				    local rest = math.floor(duration - GetTime() + start)

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

		end)

		

    end
end