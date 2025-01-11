--[[ ~~~~ Lua for Fatality.win CS2 by @de0ver ~~~~ ]]--
--[[ ~~~~~~~~~~ Create Date: 11.01.2025 ~~~~~~~~~~ ]]--

if ffi == nil then
    return gui.notify:add(gui.notification('WARNING!', 'TURN ON ALLOW INSECURE IN LUA AND RELOAD SCRIPT!', draw.textures['icon_close']));
end

local enable_smoke_color = gui.checkbox(gui.control_id('enable_smoke_color'));
local smoke_colorpicker = gui.color_picker(gui.control_id('smoke_colorpicker'));
local control_color = gui.make_control('Enable Smoke Color', enable_smoke_color);
local control_colorpicker = gui.make_control('Custom Color', smoke_colorpicker);

local group = gui.ctx:find('lua>elements a');
group:reset();
group:add(control_color);
group:add(control_colorpicker);

local GetModuleHandleA = ffi.cast('uint64_t(__stdcall*)(const char*)', utils.find_export('kernel32.dll', 'GetModuleHandleA'));

local engine2 = GetModuleHandleA('engine2.dll');
local client = GetModuleHandleA('client.dll');

local engine2_dll = { -- https://github.com/a2x/cs2-dumper/blob/main/output/offsets.hpp
    dwBuildNumber = 0x533BE4;
    dwNetworkGameClient = 0x532CE0;
    dwNetworkGameClient_clientTickCount = 0x368;
    dwNetworkGameClient_deltaTick = 0x27C;
    dwNetworkGameClient_isBackgroundMap = 0x281447;
    dwNetworkGameClient_localPlayer = 0xF0;
    dwNetworkGameClient_maxClients = 0x238;
    dwNetworkGameClient_serverTickCount = 0x36C;
    dwNetworkGameClient_signOnState = 0x228;
    dwWindowHeight = 0x616134;
    dwWindowWidth = 0x616130;
}

local client_dll = {
    dwCSGOInput = 0x1A89350;
    dwEntityList = 0x1A157C8;
    dwGameEntitySystem = 0x1B38F48;
    dwGameEntitySystem_highestEntityIndex = 0x20F0;
    dwGameRules = 0x1A7AF38;
    dwGlobalVars = 0x185DAD8;
    dwGlowManager = 0x1A7B758;
    dwLocalPlayerController = 0x1A65F70;
    dwLocalPlayerPawn = 0x1869D88;
    dwPlantedC4 = 0x1A84FA0;
    dwPrediction = 0x1868B90;
    dwSensitivity = 0x1A7BC58;
    dwSensitivity_sensitivity = 0x40;
    dwViewAngles = 0x1A89720;
    dwViewMatrix = 0x1A7F620;
    dwViewRender = 0x1A7FE30;
    dwWeaponC4 = 0x1A17970;
}

ffi.cdef[[
    typedef struct {
        float x;
        float y;
        float z;
    } Vector;
]]

if ffi.cast('int*', engine2 + engine2_dll.dwBuildNumber)[0] ~= 14059 then
    return gui.notify:add(gui.notification('LUA Outdated!', 'Wait until developer update this...', draw.textures['icon_close']));
end

local function SmokeColorChanger(entity)
    local grenade_color = ffi.cast('Vector*', entity + 0x121C)[0]; -- m_vSmokeColor = 0x121C; // Vector https://github.com/a2x/cs2-dumper/blob/daef095f2f4c18be821cbe35ebf0b0adc132435c/output/client_dll.hpp#L975

    local custom_color = smoke_colorpicker:get_value():get();

    grenade_color.x = custom_color:get_r();
    grenade_color.y = custom_color:get_g();
    grenade_color.z = custom_color:get_b();

end

local function readEntities()
    local dwGameEntitySystem = ffi.cast('uintptr_t*', client + client_dll.dwGameEntitySystem)[0];
    local dwGameEntitySystem_highestEntityIndex = ffi.cast('int*', dwGameEntitySystem + client_dll.dwGameEntitySystem_highestEntityIndex)[0];

    local dwEntityList = ffi.cast('uintptr_t*', client + client_dll.dwEntityList)[0];

    for i = 65, dwGameEntitySystem_highestEntityIndex do    

        local list_entry = ffi.cast('uintptr_t*', dwEntityList + ((8 * bit32.rshift(bit32.band(i, 0x7FFF), 9) + 16)))[0];
        if list_entry == 0 then
            goto continue;
        end
        
        local C_BaseEntity = ffi.cast('uintptr_t*', list_entry + 0x78 * bit32.band(i, 0x1FF))[0];
        if C_BaseEntity == 0 then
            goto continue;
        end

        local m_pEntity = ffi.cast('uintptr_t*', C_BaseEntity + 0x10)[0]; -- CEnitityIdentity* 
        if m_pEntity == 0 then
            goto continue;
        end

        local m_designerName = ffi.cast('uintptr_t*', m_pEntity + 0x20)[0]; -- CEntityIdentity -> m_designerName
        if m_designerName == 0 then
            goto continue
        end

        if ffi.string(ffi.cast('char*', m_designerName)) == 'smokegrenade_projectile' then
            SmokeColorChanger(C_BaseEntity);
        end

        ::continue::
    end
end

if enable_smoke_color:get_value():get() then
    events.present_queue:add(readEntities);
else 
    return;
end
