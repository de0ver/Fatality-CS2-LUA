if ffi == nil then
    return gui.notify:add(gui.notification('WARNING!', 'TURN ON ALLOW INSECURE IN LUA AND RELOAD SCRIPT!', draw.textures['icon_close']));
end

local GetModuleHandleA = ffi.cast('uint64_t(__stdcall*)(const char*)', utils.find_export('kernel32.dll', 'GetModuleHandleA'));
local GetProcAddress   = ffi.cast("uint64_t(__stdcall*)(uint64_t, const char*)", utils.find_export("kernel32.dll", "GetProcAddress"));

local engine2 = GetModuleHandleA('engine2.dll');
local client = GetModuleHandleA('client.dll');
local tier0 = GetModuleHandleA('tier0.dll');

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

    struct CGlobalVarsBase
    {
        float m_flRealTime; //0x0000
        int32_t m_iFrameCount; //0x0004
        float m_flAbsoluteFrameTime; //0x0008
        float m_flAbsoluteFrameStartTimeStdDev; //0x000C
        int32_t m_nMaxClients; //0x0010
        char pad_0014[28]; //0x0014
        float m_flIntervalPerTick; //0x0030
        float m_flCurrentTime; //0x0034
        float m_flCurrentTime2; //0x0038
        char pad_003C[20]; //0x003C
        int32_t m_nTickCount; //0x0050
        char pad_0054[292]; //0x0054
        uint64_t m_uCurrentMap; //0x0178
        uint64_t m_uCurrentMapName; //0x0180
    }; //Size: 0x0188

    typedef struct {
        uintptr_t m_hSkyMaterial; // CStrongHandle<InfoForResourceTypeIMaterial2>
        uintptr_t m_hSkyMaterialLightingOnly; // CStrongHandle<InfoForResourceTypeIMaterial2>
        bool m_bStartDisabled; // bool
        uintptr_t m_vTintColor; // Color
        uintptr_t m_vTintColorLightingOnly; // Color
        float m_flBrightnessScale; // float32
        int m_nFogType; // int32
        float m_flFogMinStart; // float32
        float m_flFogMinEnd; // float32
        float m_flFogMaxStart; // float32
        float m_flFogMaxEnd; // float32
        bool m_bEnabled; // bool
    } C_EnvSky;

    typedef struct {
        int32_t m_nSmokeEffectTickBegin; // int32 = 0x1210
        uint8_t m_bDidSmokeEffect; // bool = 0x1214
        int32_t m_nRandomSeed; // int32 = 0x1218
        Vector m_vSmokeColor; // Vector = 0x121C
        Vector m_vSmokeDetonationPos; // Vector = 0x1228
        int m_VoxelFrameData; // C_NetworkUtlVectorBase<uint8> = 0x1238
        int32_t m_nVoxelFrameDataSize; // int32 = 0x1250
        int32_t m_nVoxelUpdate; // int32 = 0x1254
        uint8_t m_bSmokeVolumeDataReceived; // bool = 0x1258
        uint8_t m_bSmokeEffectSpawned; // bool = 0x1259
    } C_SmokeGrenadeProjectile;

    typedef struct {
        uint8_t r;
        uint8_t g;
        uint8_t b;
        uint8_t a;
    } Color;
]]

if ffi.cast('int*', engine2 + engine2_dll.dwBuildNumber)[0] ~= 14059 then
    return gui.notify:add(gui.notification('LUA Outdated!', 'Wait until developer update this...', draw.textures['icon_close']));
end


local Msg = ffi.cast('void(__fastcall*)(const char*, ...)', utils.find_export('tier0.dll', 'Msg'));
local ConMsg = ffi.cast('void(__cdecl*)(const char*, ...)', GetProcAddress(tier0, 'ConMsg')); -- crash on use
local ConColorMsg = ffi.cast('void(__cdecl*)(const Color*, const char*, ...)', GetProcAddress(tier0, '?ConColorMsg@@YAXAEBVColor@@PEBDZZ'));

local function SkyBoxChanger(entity)
    local dwNetworkGameClient = ffi.cast('uintptr_t*', engine2 + engine2_dll.dwNetworkGameClient)[0];

    ffi.cast('int*', dwNetworkGameClient + engine2_dll.dwNetworkGameClient_deltaTick)[0] = -1;
end

local function SmokeColorChanger(entity)
    local grenade_color = ffi.cast('Vector*', entity + 0x121C)[0];

    grenade_color.x = 255;
    grenade_color.y = 100;
    grenade_color.z = 255;

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

        if ffi.string(ffi.cast('char*', m_designerName)) == 'env_sky' then
            -- SkyBoxChanger(C_BaseEntity);
        end

        if ffi.string(ffi.cast('char*', m_designerName)) == 'smokegrenade_projectile' then
            SmokeColorChanger(C_BaseEntity);
        end

        ::continue::
    end
end


-- readEntities();

events.present_queue:add(readEntities);