local _, AQSELF = ...

local debug = AQSELF.debug
local clone = AQSELF.clone
local diff = AQSELF.diff
local L = AQSELF.L
local GetItemLink = AQSELF.GetItemLink
local GetItemEquipLoc = AQSELF.GetItemEquipLoc

local GetSlotID = AQSELF.GetSlotID
local player = AQSELF.player

-- 设置菜单初始化
function AQSELF.suitInit()

    
    local p = CreateFrame("ScrollFrame", nil, UIParent, "UIPanelScrollFrameTemplate")
    local f = CreateFrame("Frame", nil, p)

    AQSELF.suitOption = f
    f.checkbox = {}
    f.dropdown = {
        [63] = {},
        [64] = {}
    }

    p.name = L["Suit for 63+"]
    p.parent = "AutoEquip"

    function updateSuit60(  )
        for k,v in pairs(AQSELF.gearSlots) do
            AQSV.suit[60][v] = GetSlotID(v)
        end
    end

    function AQSELF.changeSuit(boss)

        if not AQSV.enableSuit then
            return
        end

        -- 如果目标等级相同，不更换
        if AQSV.currentSuit == boss then
            return
        end

        print(L["prefix"].." "..L["Suit "..L[boss]])

        --如果之前是60，缓存起来
        if AQSV.currentSuit == 60 then
            updateSuit60()
        end

        AQSV.currentSuit = boss

         for k,v in pairs(AQSELF.gearSlots) do

            -- 判断当前栏是否需要更换
            wipe(AQSELF.empty5)
            local waitId = AQSELF.empty5

            waitId[63] = AQSV.suit[63][v]
            waitId[64] = AQSV.suit[64][v]

            -- print(AQSV.suit[63][17])
            -- 需要换装的栏位
            if waitId[63] > 0 or waitId[64] > 0 then

                local slotId = GetSlotID(v)

                -- 需要换上指定装备
                if boss > 60 and waitId[boss] > 0 then
                    -- 跟当前装备的id不同时
                    if slotId ~= waitId[boss] then

                        -- if v ==13 or v == 14 then
                            -- 避免被马上换下
                            AQSELF.equipWait(waitId[boss], v)
                        -- else
                        --     EquipItemByName(waitId[boss], v)
                        -- end
                    end
                else
                    -- 需要换回普通装备
                    if AQSV.suit[60][v] > 0 then

                        -- 如果当前套装是双手武器，则副手不换
                        if v == 17 and GetItemEquipLoc(AQSV.suit[boss][16]) == "INVTYPE_2HWEAPON" then

                        else

                            local order = 0

                            if v == 12 or v == 14 or v == 17 then
                                -- 保存60装备，只能取到item id，因此判断多槽位，如果id一样，则取到第二个
                                if AQSV.suit[60][v] == AQSV.suit[60][v-1] then
                                    order = 100000
                                end

                            end

                            AQSELF.equipByID(AQSV.suit[60][v] + order, v)

                        end

                        if AQSELF.slotFrames[v] then
                            AQSELF.cancelLocker( v )
                        end
                    end
                end

            elseif boss == 60 then
                 if v == 17 and GetItemEquipLoc(GetSlotID(16)) == "INVTYPE_2HWEAPON" then
                    AQSELF.equipByID(AQSV.suit[boss][v], v)
                else
                    -- AQSV.suit[boss][v] = 0
                end
            end
        end
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

            if key == "hideBackdrop" then
                AQSELF.hideBackdrop()
            end
        end)

        f.checkbox[key] = b
    end


    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["#Autosave current inventories to Suit "..L[60]])
        t:SetPoint("TOPLEFT", f, 52, -58)
    end

    buildCheckbox(L["Equip customized suit when you target lv.63 elite and lv.?? boss"], "enableSuit", -25)
    buildCheckbox(L["Automatic equip Suit "..L[60].." when you leave combat"], "enableAutoSuit60", -75)
    buildCheckbox(L["Equip Suit "..L[60].." when you target enemy under lv.63"], "enableTargetSuit60", -100)

    do
        local l = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        l:SetText(L["Suit "..L[63]])
        l:SetPoint("TOPLEFT", f, 25, -155)
    end

    do
        local l = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        l:SetText(L["Suit "..L[64]])
        l:SetPoint("TOPLEFT", f, 259, -155)
    end

    function DropDown_Initialize(self,level)
        level = level or 1;
        if (level == 1) then
         for k, v in pairs(self.items) do
           local info = UIDropDownMenu_CreateInfo();
           -- info.hasArrow = true; -- creates submenu
           info.text = GetItemLink(v);
           info.value = v

            local index = self.index
            local key = k
            local boss = self.boss

           info.func = function( frame )

                AQSV.suit[boss][index] = v
                UIDropDownMenu_SetSelectedValue(f.dropdown[boss][index], v, 0)
                UIDropDownMenu_SetText(f.dropdown[boss][index], GetItemLink(v)) 
            end

           UIDropDownMenu_AddButton(info, level);
         end 
        end
    end

    function buildLine( boss, v, k, height )
        local dropdown = CreateFrame("Frame", nil, f, "UIDropDownMenuTemplate")
        local left = 7

        if boss == 64 then
            left = 240
        end

        dropdown:SetPoint("TOPLEFT", left, height)
        -- 保存当前选项序号
        dropdown.index = k
        dropdown.items = v
        dropdown.boss = boss
        -- 缓存到父框架中，供后续调用
        f.dropdown[boss][k] = dropdown

        UIDropDownMenu_SetButtonWidth(dropdown, 205)
        UIDropDownMenu_Initialize(dropdown, DropDown_Initialize)

        UIDropDownMenu_SetSelectedValue(dropdown, AQSV.suit[boss][k], 0)
        UIDropDownMenu_SetText(dropdown, GetItemLink(AQSV.suit[boss][k])) 
        
        
        UIDropDownMenu_SetWidth(dropdown, 200)
        UIDropDownMenu_JustifyText(dropdown, "LEFT")
    end

    local height = -150
    local lastHeight = 0

    for k,v in pairs(AQSELF.items) do

        if AQSV.suit[63][k] == nil then
            AQSV.suit[63][k] = 0
        end

        if AQSV.suit[64][k] == nil then
            AQSV.suit[64][k] = 0
        end

         if AQSV.suit[60][k] == nil then
            AQSV.suit[60][k] = 0
        end

        local heightK = k

        if heightK > 4 then
            heightK = heightK -1
        end

        local l = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        l:SetText(AQSELF.slotToName[k])
        l:SetPoint("TOPLEFT", f, 490, height - heightK*35)

        buildLine(63, v, k, height + 5 - heightK*35)
        buildLine(64, v, k, height + 5 - heightK*35)

        -- 保存最后一个下拉框的位置
        lastHeight = height - heightK*35
    end


    f:SetAllPoints(p)
    p:SetScrollChild(f)
    f:SetSize(1000, -lastHeight)

    InterfaceOptions_AddCategory(p)
    -- 最后加载帮助页面
    InterfaceOptions_AddCategory(AQSELF.helpOption)

    -- 运行两遍才行
    -- InterfaceOptionsFrame_OpenToCategory("AutoEquip");
    -- InterfaceOptionsFrame_OpenToCategory("AutoEquip");
end