local _, SELFAQ = ...

local debug = SELFAQ.debug
local clone = SELFAQ.clone
local diff = SELFAQ.diff
local L = SELFAQ.L
local GetItemLink = SELFAQ.GetItemLink
local GetItemEquipLoc = SELFAQ.GetItemEquipLoc

local GetSlotID = SELFAQ.GetSlotID
local player = SELFAQ.player

-- 设置菜单初始化
function SELFAQ.suitInit()

    if SELFAQ.suitOption ~= nil then
        return
    end
    
    local p = CreateFrame("ScrollFrame", nil, UIParent, "UIPanelScrollFrameTemplate")
    local f = CreateFrame("Frame", nil, p)

    SELFAQ.suitOption = f
    f.checkbox = {}
    f.dropdown = {
        [63] = {},
        [64] = {},
        [60] = {}
    }

    p.name = L["Suit for 63+"]
    p.parent = "AutoEquip"


    function SELFAQ.updateMembersTarget()

        if not AQSV.enableSuit then
            return
        end

        if not AQSV.enableMembersTarget then
            return
        end

        if not SELFAQ.inInstance() then
            return
        end

        if not UnitInRaid("player") then
            return
        end

        local count = 0
        local level63 = 0
        local level64 = 0

        -- print(SELFAQ.needSuit)
        
        if UnitInRaid("player") then

            for i=1,MAX_RAID_MEMBERS  do
                
                local name = GetRaidRosterInfo(i)
                local target = "raid"..i.."target"

                -- 如果有成员
                if name and GetUnitName(target) and not UnitIsDead(target)  then

                    count = count + 1

                    local level = UnitLevel(target)

                    if level == 63 and not UnitIsFriend("player", target)  then
                    -- if level == 60 or level == 62 or level == 61 then
                       level63 = level63 + 1
                   end
                    
                    if level == -1 and not string.find(AQSV.ignoreBoss, GetUnitName(target)) then
                    -- elseif level == 61 then
                        level64 = level64 + 1
                    end

                end

            end

        end


        -- local ratio63 = 0
        -- local ratio64 = 0

        -- if level63 > 0 then
        --     ratio63 = level63 / count
        -- end
        
        -- if level64 >0 then
        --     ratio64 = level64 / count
        -- end

        -- 团队里有一定人数目标为xx，才切换

        if level63 > AQSV.raidTargetThreshold and level63 > level64 then
                SELFAQ.needSuit = 63
        end

        if level64 > AQSV.raidTargetThreshold and level64 > level63 then
                SELFAQ.needSuit = 64
        end


    end

    function SELFAQ.checkAndFireChangeSuit(target)

        local level = UnitLevel(target)

        if level == 0 then
            return false
        end

        local boss = 60

        if level == 63 then
        -- if level == 60 or level == 62 or level == 61 then
            boss = 63
        elseif level == -1 then
        -- elseif level == 61 then
            boss = 64
        end


        if boss == 60 and not AQSV.enableTargetSuit60 then
            return
        end

        -- print(boss,UnitAffectingCombat("player"))
        -- 目标为空或者是玩家的情况下，并且目标不是死亡状态，不做更换
        if level ~= 0 and not UnitIsDead(target) and SELFAQ.playerCanEquip() then

            if boss < 64 and not UnitIsFriend("player", target) then 
                SELFAQ.needSuit = boss
                return true
            end

            if boss == 64 and not string.find(AQSV.ignoreBoss, GetUnitName(target)) then
                SELFAQ.needSuit = boss
                return true
            end

            return false

        else
            return false
        end

    end

    SELFAQ.bossCount = 0


    function SELFAQ.changeSuit()

        if not AQSV.enableSuit then
            return true
        end

        local boss = SELFAQ.needSuit

        if boss == 0 then
            SELFAQ.bossCount = 0
        else
            SELFAQ.bossCount = SELFAQ.bossCount + 1
        end

        if boss == 0 or boss == AQSV.currentSuit then
            return
        end

        local res = true

        for k,v in pairs(SELFAQ.gearSlots) do

            -- 判断当前栏是否需要更换
            wipe(SELFAQ.empty5)
            local waitId = SELFAQ.empty5

            waitId[63] = AQSV.suit[63][v]
            waitId[64] = AQSV.suit[64][v]
            local wait60 = AQSV.suit[60][v]
            

            local slotId = GetSlotID(v)

            -- print(AQSV.suit[63][17])
            -- 需要换装的栏位
            if waitId[63] > 0 or waitId[64] > 0 then

                -- 需要换上指定装备
                if boss > 60 and waitId[boss] > 0 then
                    -- 跟当前装备的id不同时
                    if slotId ~= waitId[boss] then

                        local zonetext = GetSubZoneText() == "" and GetZoneText() or GetSubZoneText()

                        if v == 15 and SELFAQ.isNefNest() then

                        else
                            SELFAQ.equipWait(waitId[boss], v, false)
                        end
                    end
                end

            end
            
            if waitId[63] > 0 or waitId[64] > 0 or wait60 > 0 then  
                -- 需要换回普通装备
                if wait60 > 0 and boss == 60 and slotId ~= wait60 then

                    -- 如果当前套装是双手武器，则副手不换
                    if v == 17 and GetItemEquipLoc(AQSV.suit[boss][16]) == "INVTYPE_2HWEAPON" then

                    elseif v == 15 and SELFAQ.isNefNest() then

                    else

                        local order = 0

                        if v == 12 or v == 14 or v == 17 then
                            -- 保存60装备，只能取到item id，因此判断多槽位，如果id一样，则取到第二个
                            if wait60 == AQSV.suit[60][v-1] then
                                order = 100000
                            end

                        end

                        SELFAQ.equipByID(wait60 + order, v, false)

                    end
                    
                end


                -- 解锁受到影响的位置
                if SELFAQ.slotFrames[v] and boss == 60 then
                    SELFAQ.cancelLocker( v )
                end

            elseif boss == 60 then
                 if v == 17 and GetItemEquipLoc(GetSlotID(16)) == "INVTYPE_2HWEAPON" then
                    SELFAQ.equipByID(AQSV.suit[boss][v], v, false)
                else
                    -- AQSV.suit[boss][v] = 0
                end
            end
        end

        -- 检查是否套装更换完成
        for k,v in pairs(AQSV.suit[boss]) do
            local slotId = GetSlotID(k)

            if k == 15 and SELFAQ.isNefNest() then
                
            elseif v > 0 and slotId ~= v then
                res = false
            end
        end

        if res or SELFAQ.bossCount > 3 then

            if AQSV.currentSuit ~= boss then
                SELFAQ.popupInfo(L["Suit "..L[boss]])
                SELFAQ.chatInfo(L["Suit "..L[boss]])
            end

            if SELFAQ.qbs[AQSV.currentSuit] then
                SELFAQ.qbs[AQSV.currentSuit]:UnlockHighlight()
            end
            if SELFAQ.qbs[boss] then
                SELFAQ.qbs[boss]:LockHighlight()
            end

            SELFAQ.needSuit = 0
            AQSV.currentSuit = boss
            SELFAQ.bossCount = 0
        end

        debug(res)
        
        return res
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

            if key == "enableSuit" then  
                SELFAQ.renderQuickButton()
                updateCheckbox()
            end

        end)

        f.checkbox[key] = b
    end
    
    function updateCheckbox()
        
        if AQSV["enableSuit"] then
            f.checkbox["enableMembersTarget"]:Enable()
            f.checkbox["enableTargetSuit60"]:Enable()
            f.checkbox["enableAutoSuit60"]:Enable()
        else
            f.checkbox["enableMembersTarget"]:Disable()
            f.checkbox["enableTargetSuit60"]:Disable()
            f.checkbox["enableAutoSuit60"]:Disable()
        end

    end


    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["#The following options only take effect in instance"])
        t:SetPoint("TOPLEFT", f, 52, -58)
    end

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["#Don't change clock when you are in Nefarian's Lair"])
        t:SetPoint("TOPLEFT", f, 52, -78)
    end

    buildCheckbox(L["[Enable] Equip customized suit when you target lv.63 elite or lv.?? boss"], "enableSuit", -25)
    buildCheckbox(L["Equip suit when more than 1 raid members target lv.63 elite or boss"], "enableMembersTarget", -100)
    buildCheckbox(L["Automatic equip Suit "..L[60].." when you leave combat"], "enableAutoSuit60", -125)
    buildCheckbox(L["Equip Suit "..L[60].." when you target enemy under lv.63"], "enableTargetSuit60", -150)

    updateCheckbox()

    -- 自定义buff
    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        t:SetText(L["Don't equip suit when you target those boss"])
        t:SetPoint("TOPLEFT", f, 25, -190)
    end

    do
        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetText(L["Format - BossName,BossName,BossName"])
        t:SetPoint("TOPLEFT", f, 25, -215)
    end

    do

        local s = CreateFrame("ScrollFrame", nil, f, "UIPanelScrollFrameTemplate") -- or you actual parent instead
        s:SetSize(350,60)
        s:SetPoint("TOPLEFT", f, 26, -240)
        s:SetBackdrop({edgeFile = "Interface/Tooltips/UI-Tooltip-Background", edgeSize = 2});
        s:SetBackdropBorderColor(1,1,1,0.7);
        local e = CreateFrame("EditBox", nil, s)
        e:SetMultiLine(true)
        e:SetFontObject("GameFontHighlight")
        e:SetWidth(350)
        e:SetText(AQSV.ignoreBoss)
        e:SetTextInsets(8,8,8,8)
        e:SetAutoFocus(false)

        s:SetScrollChild(e)

        local b = CreateFrame("Button", nil, f, "GameMenuButtonTemplate")
        b:SetText(L["Submit"])
        b:SetWidth(100)
        b:SetHeight(30)
        b:SetPoint("TOPLEFT", f, 410, -238)
        b:SetScript("OnClick", function(self)
            AQSV.ignoreBoss = e:GetText()
        end)
    end

    do
        local l = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        l:SetText(L["Suit "..L[60]])
        l:SetPoint("TOPLEFT", f, 25, -330)
    end

    do
        local l = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        l:SetText(L["Suit "..L[63]])
        l:SetPoint("TOPLEFT", f, 188, -330)
    end

    do
        local l = f:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        l:SetText(L["Suit "..L[64]])
        l:SetPoint("TOPLEFT", f, 351, -330)
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
            left = 333
        elseif boss == 63 then
            left = 170
        end

        dropdown:SetPoint("TOPLEFT", left, height)
        -- 保存当前选项序号
        dropdown.index = k
        dropdown.items = v
        dropdown.boss = boss
        -- 缓存到父框架中，供后续调用
        f.dropdown[boss][k] = dropdown

        UIDropDownMenu_SetButtonWidth(dropdown, 160)
        UIDropDownMenu_Initialize(dropdown, DropDown_Initialize)
        
        -- 检查保存的装备是否在身上
        -- if not tContains(v, AQSV.suit[boss][k]) then
        --     AQSV.suit[boss][k] = 0
        -- end

        UIDropDownMenu_SetSelectedValue(dropdown, AQSV.suit[boss][k], 0)
        UIDropDownMenu_SetText(dropdown, GetItemLink(AQSV.suit[boss][k])) 
        
        
        UIDropDownMenu_SetWidth(dropdown, 130)
        UIDropDownMenu_JustifyText(dropdown, "LEFT")
    end

    local height = -330
    local lastHeight = 0

    for k,v in pairs(SELFAQ.items) do

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
        l:SetText(SELFAQ.slotToName[k])
        l:SetPoint("TOPLEFT", f, 515, height - heightK*35)

        buildLine(60, v, k, height + 5 - heightK*35)
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
    InterfaceOptions_AddCategory(SELFAQ.helpOption)

    -- 运行两遍才行
    -- InterfaceOptionsFrame_OpenToCategory("AutoEquip");
    -- InterfaceOptionsFrame_OpenToCategory("AutoEquip");
end