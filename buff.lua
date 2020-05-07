
local _, AQSELF = ...

local debug = AQSELF.debug
local clone = AQSELF.clone
local diff = AQSELF.diff
local L = AQSELF.L
local player = AQSELF.player
local GetItemTexture = AQSELF.GetItemTexture

function AQSELF.createBuffIcon()
		-- 选择BUTTON类似，才能触发鼠标事件
	local f = CreateFrame("Button", "AutoEquip_Buff", UIParent)
	AQSELF.buff = f

	f:SetFrameStrata("MEDIUM")
	f:SetWidth(40)
	f:SetHeight(40)

	f:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background"});
	f:SetBackdropColor(0,0,0,1);

	-- buff时间倒计时
	local t1 = f:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	t1:SetFont(STANDARD_TEXT_FONT, 18, "OUTLINE")
	-- t1:SetShadowColor(0, 0, 0, 1)
	-- t1:SetShadowOffset(1, -1)
    t1:SetPoint("BOTTOM", f, 2, -24)
    
    f.buffTime = t1

    -- buff层数
    local t2 = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	t2:SetFont(STANDARD_TEXT_FONT, 18, "OUTLINE")
	-- t2:SetShadowColor(0, 0, 0, 1)
	-- t2:SetShadowOffset(1, -1)
    t2:SetPoint("CENTER", f, 2, 0)
    
    f.count = t2

	local texture = f:CreateTexture(nil, "BACKGROUND")
	texture:SetAllPoints(f)

	f.texture = texture

	local text = f:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	text:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
	text:SetText(L["DRAG"])
	-- text:SetShadowColor(0, 0, 0, 1)
	-- text:SetShadowOffset(1, -1)
    text:SetPoint("CENTER", f, 2, 0)

    f.drag = text

	local menuFrame = CreateFrame("Frame", nil, f, "UIDropDownMenuTemplate")

	local menu = {}

	menu[1] = {}
	menu[1]["text"] = L[" Lock"]
	menu[1]["checked"] = AQSV.buffLocked
	menu[1]["func"] = function()
		AQSV.buffLocked = not AQSV.buffLocked
		AQSELF.lockBuff()
		menu[1]["checked"] = AQSV.locked
	end

	menu[2] = {}
	menu[2]["text"] = L[" Close"]
	menu[2]["func"] = function()
		menuFrame:Hide()
	end

	f.menu = menuFrame
	f.menuList = menu

	f:RegisterForClicks("RightButtonDown");
	f:SetScript('OnClick', function(self, button)
	    EasyMenu(menu, menuFrame, "cursor", 0 , 0, "MENU")
	end)

	-- 定位判断
	AQSELF.lockBuff()

	-- 实现拖动
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)

  	f:SetFrameLevel(1)

  	-- 初始化位置
	f:SetPoint(AQSV.pointBuff, AQSV.xBuff, AQSV.yBuff)

	f.TimeSinceLastUpdate = 0
	-- 函数执行间隔时间
	f.Interval = 0.2
	f:SetScript("OnUpdate", AQSELF.onBuffChanged)

	if AQSV.enableBuff then
		f:Show()
	else
		f:Hide()
	end

end

function AQSELF.lockBuff()

	AQSELF.buff.menuList[1]["checked"] = AQSV.buffLocked
	
	AQSELF.buff:EnableMouse(not AQSV.buffLocked)
	AQSELF.buff:SetMovable(not AQSV.buffLocked)
	AQSELF.buff:RegisterForDrag("LeftButton")

	AQSELF.f.checkbox["buffLocked"]:SetChecked(AQSV.buffLocked)

	if AQSV.buffLocked then
		AQSELF.buff.drag:Hide()
		AQSELF.buff:SetAlpha(0)
		AQSELF.buff:SetBackdropColor(0,0,0,0)
	else
		AQSELF.buff.drag:Show()
		AQSELF.buff:SetAlpha(1)
		AQSELF.buff:SetBackdropColor(0,0,0,1)
	end
end

function AQSELF.onBuffChanged(self, elapsed)
	self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed;  

    if (self.TimeSinceLastUpdate > self.Interval) then
    	-- 重新计时
        self.TimeSinceLastUpdate = 0

		local index = 1
		local find = false
		local name, icon, count, debuffType, duration, expire = UnitBuff("player", index)

		while name do
			if string.find(AQSV.buffNames, name) then
				name = nil
				find = true
			else
				index = index + 1
				name, icon, count, debuffType, duration, expire = UnitBuff("player", index)
			end
		end

		if find then
			local buffTime = math.ceil(expire - GetTime())
			if buffTime > 60 then
				buffTime = math.ceil(buffTime / 60).."m"
			end
			AQSELF.buff.texture:SetTexture(icon)
			AQSELF.buff:SetAlpha(1)
			AQSELF.buff.buffTime:SetText(buffTime)
			if count > 0 then
				AQSELF.buff.count:SetText(count)
			end
		else
			AQSELF.buff.texture:SetTexture()
			AQSELF.buff.count:SetText()
			if AQSV.buffLocked then
				AQSELF.buff:SetAlpha(0)
			end
			AQSELF.buff.buffTime:SetText()
		end
	end
end
