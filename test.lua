if utils.find_export('user32.dll', 'MessageBoxA') == 0 then
    return gui.notify:add(gui.notification('WARNING!', 'TURN ON ALLOW INSECURE IN LUA AND RELOAD SCRIPT!', draw.textures['icon_close']));
end

local GetModuleHandleA = ffi.cast('uint64_t(__stdcall*)(const char*)', utils.find_export('kernel32.dll', 'GetModuleHandleA'));

local engine2 = GetModuleHandleA('engine2.dll');
local client = GetModuleHandleA('client.dll');

local engine2_dll = { -- https://github.com/a2x/cs2-dumper/blob/main/output/offsets.hpp
    dwBuildNumber = 0x532BE4;
    dwNetworkGameClient = 0x531CE0;
    dwNetworkGameClient_clientTickCount = 0x368;
    dwNetworkGameClient_deltaTick = 0x27C;
    dwNetworkGameClient_isBackgroundMap = 0x281447;
    dwNetworkGameClient_localPlayer = 0xF0;
    dwNetworkGameClient_maxClients = 0x238;
    dwNetworkGameClient_serverTickCount = 0x36C;
    dwNetworkGameClient_signOnState = 0x228;
    dwWindowHeight = 0x615154;
    dwWindowWidth = 0x615150;
}

local client_dll = {
    dwCSGOInput = 0x1A89350;
    dwEntityList = 0x1A146F8;
    dwGameEntitySystem = 0x1B37E48;
    dwGameEntitySystem_highestEntityIndex = 0x20F0;
    dwGameRules = 0x1A7AF38;
    dwGlobalVars = 0x185CA10;
    dwGlowManager = 0x1A7A678;
    dwLocalPlayerController = 0x1A64E90;
    dwLocalPlayerPawn = 0x1868CF8;
    dwPlantedC4 = 0x1A84FA0;
    dwPrediction = 0x1868B90;
    dwSensitivity = 0x1A7BC58;
    dwSensitivity_sensitivity = 0x40;
    dwViewAngles = 0x1A89720;
    dwViewMatrix = 0x1A7F620;
    dwViewRender = 0x1A7FE30;
    dwWeaponC4 = 0x1A17970;
}

if ffi.cast('int*', engine2 + engine2_dll.dwBuildNumber)[0] ~= 14058 then
    return gui.notify:add(gui.notification('LUA Outdated!', 'Wait until developer update this...', draw.textures['icon_close']));
end

local function readEntities()
    local dwEntityList = ffi.cast('uintptr_t', client + client_dll.dwEntityList);
    local dwGameEntitySystem = ffi.cast('uintptr_t*', client + client_dll.dwGameEntitySystem)[0];
    local dwGameEntitySystem_highestEntityIndex = ffi.cast('int*', dwGameEntitySystem + client_dll.dwGameEntitySystem_highestEntityIndex)[0];

    for i = 65, dwGameEntitySystem_highestEntityIndex do
        local list_entry = ffi.cast('uintptr_t*', dwEntityList + 0x8 * (bit.rshift(bit.band(i, 0x7FFF), 0x9) + 0x10))[0];
        if not list_entry then
            goto continue;
        end

        local ent_controller = ffi.cast('uintptr_t*', list_entry + 0x78 * (bit.band(i, 0x1FF)))[0];
        if not ent_controller then
            goto continue;
        end

        local ent = ffi.cast('uintptr_t*', list_entry + 0x10)[0];
        if not ent then
            goto continue;
        end

        local designer_name = ffi.cast('const char*', ent + 0x20);
        if not designer_name then
            goto continue
        else
            print(ffi.string(designer_name));
        end

        --[[
        local team = ffi.cast('int32_t*', ent_controller + 0x3E3)[0];

        print(team);

        local player_pawn = ffi.cast('uint32_t', entity + 0x80C);
        
        local list_entry2 = ffi.cast('uintptr_t', dwEntityList + 0x8 * (bit.rshift(bit.band(player_pawn, 0x7FFF), 0x9) + 0x10));
        if not list_entry2 then
            goto continue;
        end

        local cs_player_pawn = ffi.cast('uintptr_t', list_entry2 + 0x78 * (bit.band(player_pawn, 0x1FF)));
        if not cs_player_pawn then
            goto continue;
        end
        ]]--

        -- print(ffi.cast('int', cs_player_pawn + 0x344));

        ::continue::
    end
end

readEntities();