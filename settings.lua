local _, AQSELF = ...

local debug = AQSELF.debug
local clone = AQSELF.clone
local diff = AQSELF.diff
local L = AQSELF.L
local GetItemLink = AQSELF.GetItemLink
local player = AQSELF.player

-- 设置菜单初始化
function AQSELF.settingInit()

    
    local p = CreateFrame("ScrollFrame", nil, p, "UIPanelScrollFrameTemplate")
    local f = CreateFrame("Frame", nil, p)
    

    AQSELF.f = f

    p.name = "AutoEquip"
    -- 缓存主动饰品下拉框
    f.dropdown = {}
    -- 缓存常驻饰品下拉框
    f.resident = {}
    -- 缓存单选框
    f.checkbox = {}
    f.pveCheckbox = {}
    f.pvpCheckbox = {}

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
        t:SetText(L["AutoEquip "]..AQSELF.version)
        t:SetPoint("TOPLEFT", f, 25, -20)
    end

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["Usable Trinkets:"])
        t:SetPoint("TOPLEFT", f, 25, AQSELF.lastHeight)
    end

    -- 构建主动饰品组
    function DropDown_Initialize(self,level)
        level = level or 1;
        if (level == 1) then
         for k, v in ipairs(AQSV.usable) do
           local info = UIDropDownMenu_CreateInfo();
           -- info.hasArrow = true; -- creates submenu
           info.text = GetItemLink(v);
           info.value = v

            local index = self.index
            local key = k

           info.func = function( frame )
                -- 选择的不是当前顺序的饰品
                if index ~= key then
                    -- 交换数据table中两个饰品的顺序
                    local value = AQSV.usable[key]
                    AQSV.usable[key] = AQSV.usable[index]
                    AQSV.usable[index] = value

                    -- 根据新的数据table更新选中状态
                    for k,v in ipairs(AQSV.usable) do
                        UIDropDownMenu_SetSelectedValue(f.dropdown[k], v, 0)
                        UIDropDownMenu_SetText(f.dropdown[k], GetItemLink(v)) 
                        f.pveCheckbox[k]:SetChecked(AQSV.pveTrinkets[v])
                        f.pvpCheckbox[k]:SetChecked(AQSV.pvpTrinkets[v])
                    end
                end
            end
           UIDropDownMenu_AddButton(info, level);
         end 
        end
    end

    -- 构建常驻饰品组
    function Resident_Trinket_Initialize(self,level)
        level = level or 1;
        if (level == 1) then
         for k, v in ipairs(AQSELF.trinkets) do
           local info = UIDropDownMenu_CreateInfo();
           -- info.hasArrow = true; -- creates submenu
           info.text = GetItemLink(v);
           info.value = v

            local index = self.index
            local key = k

           info.func = function( frame )
                -- 选中现有饰品则无效
                if v ~= AQSV["slot"..(12+index)] then
                    UIDropDownMenu_SetSelectedValue(f.resident[index], v, 0)
                    UIDropDownMenu_SetText(f.resident[index], GetItemLink(v)) 
                end

                local one = AQSV["slot"..(12+index)]

                -- 如果跟另一个饰品一样，则更换
                if v == AQSV["slot"..(15-index)] then
                    UIDropDownMenu_SetSelectedValue(f.resident[3-index], one, 0)
                    UIDropDownMenu_SetText(f.resident[3-index], GetItemLink(one)) 
                    AQSV["slot"..(15-index)] = one
                end

                AQSV["slot"..(12+index)] = v


                -- if v ~= AQSV.slot13 and v ~= AQSV.slot14 then
                --     UIDropDownMenu_SetSelectedValue(f.resident[index], v, 0)
                --     UIDropDownMenu_SetText(f.resident[index], GetItemLink(v)) 
                --     -- 更新数据
                --     AQSV["slot"..(12+index)] = v
                -- end
            end
           UIDropDownMenu_AddButton(info, level);
         end
        end
    end

    -- 构建两个饰品组
    function buildDropdownGroup()
        local height = 0
        for k,v in ipairs(AQSV.usable) do
            local dropdown = CreateFrame("Frame", nil, f, "UIDropDownMenuTemplate");
            dropdown:SetPoint("TOPLEFT", 100, AQSELF.lastHeight + 5 - k*35)
            -- 保存当前选项序号
            dropdown.index = k
            -- 缓存到父框架中，供后续调用
            f.dropdown[k] = dropdown

            local l = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
            l:SetText(L["No. "]..k)
            l:SetPoint("TOPLEFT", f, 25, AQSELF.lastHeight - k*35)

            -- 保存最后一个下拉框的位置
            height = AQSELF.lastHeight - k*35

            UIDropDownMenu_SetButtonWidth(dropdown, 205)
            UIDropDownMenu_Initialize(dropdown, DropDown_Initialize)
            UIDropDownMenu_SetSelectedValue(dropdown, v, 0)
            
            UIDropDownMenu_SetText(dropdown, GetItemLink(v)) 
            
            
            UIDropDownMenu_SetWidth(dropdown, 200)
            UIDropDownMenu_JustifyText(dropdown, "LEFT")

            -- 后面追加checkbox
            local b = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
            b:SetPoint("TOPLEFT", 350, AQSELF.lastHeight + 7 - k*35)
            b:SetChecked(AQSV.pveTrinkets[v])
            f.pveCheckbox[k] = b

            b.text = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            b.text:SetPoint("LEFT", b, "RIGHT", 0, 0)
            b.text:SetText("PVE")
            b:SetScript("OnClick", function()
                local vaule = UIDropDownMenu_GetSelectedValue(dropdown)
                debug(vaule)
                AQSV.pveTrinkets[vaule] = not AQSV.pveTrinkets[vaule]
                b:SetChecked(AQSV.pveTrinkets[vaule])
            end)

            local b1 = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
            b1:SetPoint("TOPLEFT", 420, AQSELF.lastHeight + 7 - k*35)
            b1:SetChecked(AQSV.pvpTrinkets[v])
            f.pvpCheckbox[k] = b1

            b1.text = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            b1.text:SetPoint("LEFT", b1, "RIGHT", 0, 0)
            b1.text:SetText("PVP")
            b1:SetScript("OnClick", function()
                local vaule = UIDropDownMenu_GetSelectedValue(dropdown)
                debug(vaule)
                AQSV.pvpTrinkets[vaule] = not AQSV.pvpTrinkets[vaule]
                b1:SetChecked(AQSV.pvpTrinkets[vaule])
            end)
        end

        

        -- 没有主动饰品的情况
        if #AQSV.usable == 0 then
            local l = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
            l:SetText(L["<There is no suitable trinkets>"])
            l:SetPoint("TOPLEFT", f, 25, AQSELF.lastHeight - 35)

            height = AQSELF.lastHeight - 35
        end

        AQSELF.lastHeight = height

        do
            local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
            t:SetText(L["Resident Trinkets:"] )
            t:SetPoint("TOPLEFT", f, 25, AQSELF.lastHeight - 45)
        end

        for k=1, 2 do
            local dropdown = CreateFrame("Frame", nil, f, "UIDropDownMenuTemplate");
            dropdown:SetPoint("TOPLEFT", 100, AQSELF.lastHeight-(40 + k*35))
            dropdown.index = k

            f.resident[k] = dropdown

            local l = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
            l:SetText(L["Slot "]..k)
            l:SetPoint("TOPLEFT", f, 25, AQSELF.lastHeight-(45 + k*35))

            UIDropDownMenu_SetButtonWidth(dropdown, 205)
            UIDropDownMenu_Initialize(dropdown, Resident_Trinket_Initialize)

            local seleted = AQSV["slot"..(12+k)]

            if seleted > 0 then
                UIDropDownMenu_SetSelectedValue(dropdown, seleted, 0)
                UIDropDownMenu_SetText(dropdown, GetItemLink(seleted)) 
            else
                UIDropDownMenu_SetText(dropdown, L["<Select a trinket>"]) 
            end
            
            
            UIDropDownMenu_SetWidth(dropdown, 200)
            UIDropDownMenu_JustifyText(dropdown, "LEFT")
        end

        AQSELF.lastHeight = AQSELF.lastHeight-(45 + 2*35)
    end

    function buildCheckbox(text, key, pos, x)

        local posX = 20

        if x ~= nil then
            posX = x
        end

        local b = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
        b:SetPoint("TOPLEFT", f, posX, pos)
        b:SetChecked(AQSV[key])

        b.text = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        b.text:SetPoint("LEFT", b, "RIGHT", 0, 0)
        b.text:SetText(text)
        b:SetScript("OnClick", function()
            AQSV[key] = not AQSV[key]
            b:SetChecked(AQSV[key])

            if key == "enableItemBar" then  
                -- 装备栏的开关
                if not AQSV.enableItemBar then
                    AQSELF.bar:Hide()
                else
                    AQSELF.bar:Show()
                end
            end

            if key == "enableBuff" then  
                -- 装备栏的开关
                if not AQSV.enableBuff then
                    AQSELF.buff:Hide()
                else
                    AQSELF.buff:Show()
                end
            end

            if key == "locked" then
                AQSELF.lockItemBar()
            end

            if key == "buffLocked" then
                AQSELF.lockBuff()
            end
        end)

        f.checkbox[key] = b
    end

    buildCheckbox(L["Enable AutoEquip function"], "enable", -60)

    buildCheckbox(L["Enable Inventory Bar"], "enableItemBar", -85)
    buildCheckbox(L["Lock frame"], "locked", -85, 300)

    buildCheckbox(L["Enable Buff Alert"], "enableBuff", -110)
    buildCheckbox(L["Lock frame"], "buffLocked", -110, 300)

    buildCheckbox(L["Automatic switch to PVP mode in Battleground"], "enableBattleground", -150)
    buildCheckbox(L["enable_carrot"], "enableCarrot", -175)
    buildCheckbox(L["Disable Slot 2"], "disableSlot14", -200)
    buildCheckbox(L["Equip item by priority forcibly even if the item in slot is aviilable"], "forcePriority", -225)
    buildCheckbox(L["Item queue is displayed above the Inventory Bar"], "reverseCooldownUnit", -250)

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["#When the items shown below are different from the actual ones"])
        t:SetPoint("TOPLEFT", f, 135, -295)

        local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
        b:SetText(L["Reload UI"])
        b:SetWidth(100)
        b:SetHeight(30)
        b:SetPoint("TOPLEFT", f, 23, -285)
        b:SetScript("OnClick", function(self)
            debug("rl")
            C_UI.Reload()
        end)
    end

    buildDropdownGroup()

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["Custom Buff Alert:"])
        t:SetPoint("TOPLEFT", f, 25, AQSELF.lastHeight-60)
    end

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["Format - BuffName,BuffName,BuffName"])
        t:SetPoint("TOPLEFT", f, 25, AQSELF.lastHeight - 85)
    end

    do

        local s = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate") -- or you actual parent instead
        s:SetSize(350,80)
        s:SetPoint("TOPLEFT", f, 26, AQSELF.lastHeight - 110)
        s:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 2});
        s:SetBackdropBorderColor(1,1,1,0.7);
        local e = CreateFrame("EditBox", nil, s)
        e:SetMultiLine(true)
        e:SetFontObject("GameFontHighlight")
        e:SetWidth(300)
        -- AQSV.buffNames = nil
        -- print(AQSV.buffNames[2])
        e:SetText(AQSV.buffNames)
        e:SetTextInsets(8,8,8,8)
        e:SetAutoFocus(false)

        s:SetScrollChild(e)

        local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
        b:SetText(L["Submit"])
        b:SetWidth(100)
        b:SetHeight(30)
        b:SetPoint("TOPLEFT", f, 410, AQSELF.lastHeight - 108)
        b:SetScript("OnClick", function(self)
            debug(e:GetText())
            AQSV.buffNames = e:GetText()
        end)
    end

    AQSELF.lastHeight = AQSELF.lastHeight - 160

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["Append Usable Items:"])
        t:SetPoint("TOPLEFT", f, 25, AQSELF.lastHeight-60)
    end

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["Format - ItemID/BuffTime,ItemID/BuffTime"])
        t:SetPoint("TOPLEFT", f, 25, AQSELF.lastHeight - 85)
    end

    do

        local s = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate") -- or you actual parent instead
        s:SetSize(350,80)
        s:SetPoint("TOPLEFT", f, 26, AQSELF.lastHeight - 110)
        s:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 2});
        s:SetBackdropBorderColor(1,1,1,0.7);
        local e = CreateFrame("EditBox", nil, s)
        e:SetMultiLine(true)
        e:SetFontObject("GameFontHighlight")
        e:SetWidth(300)
        -- AQSV.buffNames = nil
        e:SetText(AQSV.additionItems)
        e:SetTextInsets(8,8,8,8)
        e:SetAutoFocus(false)

        s:SetScrollChild(e)

        local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
        b:SetText(L["Submit & Reload UI"])
        b:SetWidth(160)
        b:SetHeight(30)
        b:SetPoint("TOPLEFT", f, 410, AQSELF.lastHeight - 108)
        b:SetScript("OnClick", function(self)
            debug(e:GetText())
            AQSV.additionItems = e:GetText()
            C_UI.Reload()
        end)
    end

    AQSELF.lastHeight = AQSELF.lastHeight - 160

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["Command:"])
        t:SetPoint("TOPLEFT", f, 25, AQSELF.lastHeight - 60)
    end

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["/aq"])
        t:SetPoint("TOPLEFT", f, 25, AQSELF.lastHeight - 85)
    end

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["-- Enable/disable AutoEquip function"])
        t:SetPoint("TOPLEFT", f, 140, AQSELF.lastHeight - 85)
    end

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["/aq settings"])
        t:SetPoint("TOPLEFT", f, 25, AQSELF.lastHeight - 105)
    end

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["-- Open settings"])
        t:SetPoint("TOPLEFT", f, 140, AQSELF.lastHeight - 105)
    end

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["/aq pvp"])
        t:SetPoint("TOPLEFT", f, 25, AQSELF.lastHeight - 125)
    end

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["-- Enable/disable PVP mode manually"])
        t:SetPoint("TOPLEFT", f, 140, AQSELF.lastHeight - 125)
    end

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["/aq unlock"])
        t:SetPoint("TOPLEFT", f, 25, AQSELF.lastHeight - 145)
    end

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["-- Unlock Inventory Bar (AutoEquip function is invalid when locked)"])
        t:SetPoint("TOPLEFT", f, 140, AQSELF.lastHeight - 145)
    end

    AQSELF.lastHeight = AQSELF.lastHeight - 130

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["Tips:"])
        t:SetPoint("TOPLEFT", f, 25, AQSELF.lastHeight - 60)
    end

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["1. Equip item manually through the Inventory Bar will temporarily lock the button."])
        t:SetPoint("TOPLEFT", f, 25, AQSELF.lastHeight - 85)
    end

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["2. Right click or use the '/aq unlock' command will unlock the button."])
        t:SetPoint("TOPLEFT", f, 25, AQSELF.lastHeight - 105)
    end

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["3. Before using item, the button will be unlocked automatically."])
        t:SetPoint("TOPLEFT", f, 25, AQSELF.lastHeight - 125)
    end

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["4. AutoEquip/Inventory Bar/Buff Alert can be enabled/disabled independently."])
        t:SetPoint("TOPLEFT", f, 25, AQSELF.lastHeight - 145)
    end

    AQSELF.lastHeight = AQSELF.lastHeight - 200


    f:SetAllPoints(p)
    p:SetScrollChild(f)
    f:SetSize(1000, -AQSELF.lastHeight)

    InterfaceOptions_AddCategory(p)

    -- 运行两遍才行
    -- InterfaceOptionsFrame_OpenToCategory("AutoEquip");
    -- InterfaceOptionsFrame_OpenToCategory("AutoEquip");
end