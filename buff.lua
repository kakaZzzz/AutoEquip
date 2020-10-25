
local _, SELFAQ = ...

local debug = SELFAQ.debug
local clone = SELFAQ.clone
local diff = SELFAQ.diff
local L = SELFAQ.L
local player = SELFAQ.player
local GetItemTexture = SELFAQ.GetItemTexture

function SELFAQ.createBuffIcon()

	if SELFAQ.buff ~= nil then
		return
	end

	-- 注册事件的frame
	local timerf = CreateFrame("Frame")
	timerf.TimeSinceLastUpdate = 0
	-- 函数执行间隔时间
	timerf.Interval = 0.2
	timerf:SetScript("OnUpdate", SELFAQ.onBuffChanged)
	
	-- 选择BUTTON类似，才能触发鼠标事件
	local f = CreateFrame("Button", "AutoEquip_Buff", UIParent)
	SELFAQ.buff = f

	f:SetFrameStrata("HIGH")
	f:SetWidth(40)
	f:SetHeight(40)
	f:SetScale(AQSV.buffZoom)

	f:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", edgeFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 2});
	f:SetBackdropBorderColor(0,0,0,0.9);

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
	-- 取消边框
	texture:SetTexCoord(0.07, 0.93, 0.07, 0.93)
	texture:SetAllPoints(f)

	f.texture = texture

	local text = f:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	text:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
	text:SetText(L["Buff Alert"])
	-- text:SetShadowColor(0, 0, 0, 1)
	-- text:SetShadowOffset(1, -1)
    text:SetPoint("CENTER", f, 2, 0)

    f.drag = text

	local menuFrame = CreateFrame("Frame", nil, f, "UIDropDownMenuTemplate")

	local menu = {}

	menu[1] = {}
	menu[1]["text"] = L[" Lock frame"]
	menu[1]["checked"] = AQSV.buffLocked
	menu[1]["func"] = function()
		AQSV.buffLocked = not AQSV.buffLocked
		SELFAQ.lockBuff()
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
		if AQSV.buffLocked then
			if not UnitAffectingCombat("player") then
				CancelUnitBuff("player", f.spellIndex)
			end
		else
			EasyMenu(menu, menuFrame, "cursor", 0 , 0, "MENU")
		end
	end)

	f:SetScript("OnEnter", function(self)
		SELFAQ.showBuffTooltip()
	end)

	f:SetScript("OnLeave", function(self)
		SELFAQ.hideTooltip()
	end)

	-- 定位判断
	SELFAQ.lockBuff()

	-- 实现拖动
	f:SetScript("OnDragStart", f.StartMoving)
	f:SetScript("OnDragStop", f.StopMovingOrSizing)

  	f:SetFrameLevel(2)

  	-- 初始化位置
	f:SetPoint(AQSV.pointBuff, AQSV.xBuff, AQSV.yBuff)

	if AQSV.enableBuff then
		f:Show()
	else
		f:Hide()
	end

	for k,v in pairs(AQSV.usableItems) do
        for k1,v1 in pairs(v) do

            local spellName = GetItemSpell(v1)

            if spellName and not tContains(SELFAQ.buffs, spellName) then
                tinsert(SELFAQ.buffs, spellName)
            end

        end
    end

    -- debug(SELFAQ.buffs)

end

function SELFAQ.lockBuff()

	SELFAQ.buff.menuList[1]["checked"] = AQSV.buffLocked
	
	-- SELFAQ.buff:EnableMouse(not AQSV.buffLocked)
	SELFAQ.buff:EnableMouse(true)
	SELFAQ.buff:SetMovable(not AQSV.buffLocked)
	SELFAQ.buff:RegisterForDrag("LeftButton")

	SELFAQ.f.checkbox["buffLocked"]:SetChecked(AQSV.buffLocked)

	if AQSV.buffLocked then
		SELFAQ.buff.drag:Hide()
		SELFAQ.buff:Hide()
		-- SELFAQ.buff:SetAlpha(0)
		SELFAQ.buff:SetBackdropColor(0,0,0,0)
	else
		SELFAQ.buff.drag:Show()
		SELFAQ.buff:Show()
		-- SELFAQ.buff:SetAlpha(1)
		SELFAQ.buff:SetBackdropColor(0,0,0,1)
	end
end

function SELFAQ.onBuffChanged(self, elapsed)

	if not AQSV.enableBuff then
		SELFAQ.buff:Hide()
		return
	end

	self.TimeSinceLastUpdate = self.TimeSinceLastUpdate + elapsed;  

    if (self.TimeSinceLastUpdate > self.Interval) then
    	-- 重新计时
        self.TimeSinceLastUpdate = 0

		local index = 1
		local find = false
		local name, icon, count, debuffType, duration, expire = UnitBuff("player", index)

		while name do
			if tContains(SELFAQ.buffs, name) then
				name = nil
				find = true
			else
				index = index + 1
				name, icon, count, debuffType, duration, expire = UnitBuff("player", index)
			end
		end

		if find then
			SELFAQ.buff.spellIndex = index

			local buffTime = math.floor(expire - GetTime())
			if buffTime > 60 then
				buffTime = math.ceil(buffTime / 60).."m"
			end
			SELFAQ.buff.texture:SetTexture(icon)
			SELFAQ.buff:Show()
			SELFAQ.buff.buffTime:SetText(buffTime)
			if count > 0 then
				SELFAQ.buff.count:SetText(count)
			end
		else
			SELFAQ.buff.spellIndex = nil
			SELFAQ.buff.texture:SetTexture()
			SELFAQ.buff.count:SetText()
			if AQSV.buffLocked then
				SELFAQ.buff:Hide()
			end
			SELFAQ.buff.buffTime:SetText()
		end
	end
end

function SELFAQ.showBuffTooltip()

	if not AQSV.buffLocked then

		local tooltip = _G["GameTooltip"]
	    tooltip:ClearLines()


		tooltip:SetOwner(SELFAQ.buff, "ANCHOR_NONE")
		tooltip:SetPoint("BOTTOM", SELFAQ.buff, "TOP" )
		-- tooltip:SetPoint("BOTTOMLEFT",button,0,-20)
		
		tooltip:AddLine(SELFAQ.color("00FF00",L["Auto-detect trinket buff"]))
		tooltip:AddLine(SELFAQ.color("FFFFFF",L["Unlock:"]))
		tooltip:AddLine(L["Right-Click: Lock Position"])
		tooltip:AddLine(L["Left-Drag: Move Frame"])
		tooltip:AddLine(SELFAQ.color("FFFFFF",L["Locked:"]))
		tooltip:AddLine(L["Right-Click: Cancel Aura"])
		
	    tooltip:Show()
	end

end
