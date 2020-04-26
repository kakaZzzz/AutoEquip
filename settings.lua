
-- 设置菜单初始化
function settingInit()

    local f = CreateFrame("Frame", nil, UIParent)
    f.name = "AutoEquip"
    -- 缓存主动饰品下拉框
    f.dropdown = {}
    -- 缓存常驻饰品下拉框
    f.resident = {}

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
        t:SetText(L["AutoEquip "]..version)
        t:SetPoint("TOPLEFT", f, 25, -20)
    end

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["Usable Trinkets:"])
        t:SetPoint("TOPLEFT", f, 25, -235)
    end

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["If you get a new trinket (include take it from bank)."])
        t:SetPoint("TOPLEFT", f, 135, -180)

        local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
        b:SetText(L["Reload UI"])
        b:SetWidth(100)
        b:SetHeight(30)
        b:SetPoint("TOPLEFT", f, 23, -170)
        b:SetScript("OnClick", function(self)
            debug("rl")
            C_UI.Reload()
        end)
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
         for k, v in ipairs(trinkets) do
           local info = UIDropDownMenu_CreateInfo();
           -- info.hasArrow = true; -- creates submenu
           info.text = GetItemLink(v);
           info.value = v

            local index = self.index
            local key = k

           info.func = function( frame )
                -- 选中现有饰品则无效
                if v ~= AQSV.slot13 and v ~= AQSV.slot14 then
                    UIDropDownMenu_SetSelectedValue(f.resident[index], v, 0)
                    UIDropDownMenu_SetText(f.resident[index], GetItemLink(v)) 
                    -- 更新数据
                    AQSV["slot"..(12+index)] = v
                end
            end
           UIDropDownMenu_AddButton(info, level);
         end
        end
    end

    -- 构建两个饰品组
    function buildDropdownGroup()
        for k,v in ipairs(AQSV.usable) do
            local dropdown = CreateFrame("Frame", nil, f, "UIDropDownMenuTemplate");
            dropdown:SetPoint("TOPLEFT", 100, -(230 + k*35))
            -- 保存当前选项序号
            dropdown.index = k
            -- 缓存到父框架中，供后续调用
            f.dropdown[k] = dropdown

            local l = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
            l:SetText(L["No. "]..k)
            l:SetPoint("TOPLEFT", f, 25, -(235 + k*35))

            -- 保存最后一个下拉框的位置
            lastHeight = -(235 + k*35)

            UIDropDownMenu_SetButtonWidth(dropdown, 205)
            UIDropDownMenu_Initialize(dropdown, DropDown_Initialize)
            UIDropDownMenu_SetSelectedValue(dropdown, v, 0)
            
            UIDropDownMenu_SetText(dropdown, GetItemLink(v)) 
            
            
            UIDropDownMenu_SetWidth(dropdown, 200)
            UIDropDownMenu_JustifyText(dropdown, "LEFT")
        end

        -- 没有主动饰品的情况
        if #AQSV.usable == 0 then
            local l = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
            l:SetText(L["*Don't have suitable trinkets.*"]..k)
            l:SetPoint("TOPLEFT", f, 25, -(235 + 35))

            lastHeight = -(235 + 35)
        end

        do
            local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
            t:SetText(L["Resident Trinkets:"] )
            t:SetPoint("TOPLEFT", f, 25, lastHeight - 45)
        end

        for k=1, 2 do
            local dropdown = CreateFrame("Frame", nil, f, "UIDropDownMenuTemplate");
            dropdown:SetPoint("TOPLEFT", 100, lastHeight-(40 + k*35))
            dropdown.index = k

            f.resident[k] = dropdown

            local l = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
            l:SetText(L["Slot "]..k)
            l:SetPoint("TOPLEFT", f, 25, lastHeight-(45 + k*35))

            UIDropDownMenu_SetButtonWidth(dropdown, 205)
            UIDropDownMenu_Initialize(dropdown, Resident_Trinket_Initialize)

            local seleted = AQSV["slot"..(12+k)]
            UIDropDownMenu_SetSelectedValue(dropdown, seleted, 0)
            UIDropDownMenu_SetText(dropdown, GetItemLink(seleted)) 
            
            
            UIDropDownMenu_SetWidth(dropdown, 200)
            UIDropDownMenu_JustifyText(dropdown, "LEFT")
        end
    end

    function buildCheckbox(text, key, pos)
        local b = CreateFrame("CheckButton", nil, f, "UICheckButtonTemplate")
        b:SetPoint("TOPLEFT", f, 20, pos)
        b:SetChecked(AQSV[key])

        b.text = b:CreateFontString(nil, "OVERLAY", "GameFontNormal")
        b.text:SetPoint("LEFT", b, "RIGHT", 0, 1)
        b.text:SetText(text)
        b:SetScript("OnClick", function()
            AQSV[key] = not AQSV[key]
            b:SetChecked(AQSV[key])
        end)
    end

    buildCheckbox(L["Enable"].." <"..player..">", "enable", -60)
    buildCheckbox(L["enable_battleground"], "enableBattleground", -85)
    buildCheckbox(L["enable_carrot"], "enableCarrot", -110)
    buildCheckbox(L["Disable Slot 2"], "disableSlot14", -135)

    buildDropdownGroup()
    InterfaceOptions_AddCategory(f)

    -- 运行两遍才行
    -- InterfaceOptionsFrame_OpenToCategory("AutoEquip");
    -- InterfaceOptionsFrame_OpenToCategory("AutoEquip");
end