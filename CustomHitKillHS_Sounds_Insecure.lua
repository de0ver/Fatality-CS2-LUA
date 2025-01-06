if utils.find_export('user32.dll', 'MessageBoxA') == 0 then
    gui.notify:add(
        gui.notification(
            'WARNING!', 
            'TURN ON ALLOW INSECURE IN LUA AND RELOAD SCRIPT!', 
            draw.textures['icon_allow_insecure']
        )
    );
end

local hitsound_box = gui.combo_box(gui.control_id('hitsound_box'));
local en_hitsounds = gui.make_control('Hit Sounds', hitsound_box);

local killsound_box = gui.combo_box(gui.control_id('killsound_box'));
local en_killsounds = gui.make_control('Kill Sounds', killsound_box);

local hithssound_box = gui.combo_box(gui.control_id('hithssound_box'));
local en_hithssounds = gui.make_control('Head Hit Sounds', hithssound_box);

local killhssound_box = gui.combo_box(gui.control_id('killhssound_box'));
local en_killhssounds = gui.make_control('Head Kill Sounds', killhssound_box);

local group = gui.ctx:find('lua>elements a');
group:add(en_hitsounds);
group:reset();

group:add(en_killsounds);
group:reset();

group:add(en_hithssounds);
group:reset();

group:add(en_killhssounds);
group:reset();

local sounds_table = {};
local MAX_PATH = 260;
local lpBuffer = ffi.new('char[?]', MAX_PATH);

ffi.cdef[[
    typedef struct {
        uint32_t dwFileAttributes;
        uint32_t ftCreationTimeLow;
        uint32_t ftCreationTimeHigh;
        uint32_t ftLastAccessTimeLow;
        uint32_t ftLastAccessTimeHigh;
        uint32_t ftLastWriteTimeLow;
        uint32_t ftLastWriteTimeHigh;
        uint32_t nFileSizeHigh;
        uint32_t nFileSizeLow;
        uint32_t dwReserved0;
        uint32_t dwReserved1;
        char cFileName[260];
        char cAlternateFileName[14];
    } WIN32_FIND_DATAA;
    
    void* FindFirstFileA(const char* lpFileName, WIN32_FIND_DATAA* lpFindFileData);
    bool FindNextFileA(void* hFindFile, WIN32_FIND_DATAA* lpFindFileData);
    bool FindClose(void* hFindFile);
    unsigned int GetCurrentDirectoryA(unsigned int nBufferLength, char* lpBuffer);
]];

local GetCurrentDirectoryA = ffi.cast('unsigned int(__stdcall*)(unsigned int, char*)', utils.find_export('kernel32.dll', 'GetCurrentDirectoryA'));
local FindFirstFileA = ffi.cast('void*(__stdcall*)(const char*, WIN32_FIND_DATAA*)', utils.find_export('kernel32.dll', 'FindFirstFileA'));
local FindNextFileA = ffi.cast('bool(__stdcall*)(void*, WIN32_FIND_DATAA*)', utils.find_export('kernel32.dll', 'FindNextFileA'));
local FindClose = ffi.cast('bool(__stdcall*)(void*)', utils.find_export('kernel32.dll', 'FindClose'));

GetCurrentDirectoryA(MAX_PATH, lpBuffer);

local cs2_path = ffi.string(lpBuffer);
local cs2_sounds_path = cs2_path:gsub('bin\\win64', 'csgo\\sounds'); -- Counter-Strike Global Offensive\game\bin\win64 -> Counter-Strike Global Offensive\game\csgo\sounds

local function addValueToAllCombo(value)
    hitsound_box:add(gui.selectable(gui.control_id('hit'..value), value));
    killsound_box:add(gui.selectable(gui.control_id('kill'..value), value));
    hithssound_box:add(gui.selectable(gui.control_id('hiths'..value), value));
    killhssound_box:add(gui.selectable(gui.control_id('killhs'..value), value));
end

local function listFiles(path) -- https://vsokovikov.narod.ru/New_MSDN_API/Menage_files/fn_findfirstfile.htm
    local findFileData = ffi.new('WIN32_FIND_DATAA');
    local hFind = FindFirstFileA(path .. '\\*', findFileData);

    if (hFind == -1) then
        return print('Invalid File Handle.');
    end

    local bits = 1;

    addValueToAllCombo('None');
    sounds_table[bits] = 'None';

    repeat
        local cFileName = ffi.string(findFileData.cFileName);
        if cFileName ~= '.' and cFileName ~= '..' and string.find(cFileName, '.vsnd_c') then
            addValueToAllCombo(cFileName);
            bits = bits * 2;
            sounds_table[bits] = cFileName;
        end
    until not FindNextFileA(hFind, findFileData);

    FindClose(hFind);
end

local function onLoadLUA()
    listFiles(cs2_sounds_path);
end

local function cmd(command)
    return game.engine:client_cmd(command);
end

local function on_hit(e, h_hs, h)
    if h_hs and e:get_int('hitgroup') == 1 then
        return cmd('play \\sounds\\'..sounds_table[hithssound_box:get_value():get():get_raw()]);
    elseif h then
        return cmd('play \\sounds\\'..sounds_table[hitsound_box:get_value():get():get_raw()]);
    end
end

local function on_kill(e, k_hs, k)
    if k_hs and e:get_int('hitgroup') == 1 then
        return cmd('play \\sounds\\'..sounds_table[killhssound_box:get_value():get():get_raw()]);
    elseif k then
        return cmd('play \\sounds\\'..sounds_table[killsound_box:get_value():get():get_raw()]);
    end
end

events.event:add(function (e)
    local h = hitsound_box:get_value():get():get_raw() > 1;
    local h_hs = hithssound_box:get_value():get():get_raw() > 1;
    local k = killsound_box:get_value():get():get_raw() > 1;
    local k_hs = killhssound_box:get_value():get():get_raw() > 1;

    if h or h_hs or k or k_hs then
        if e:get_name() == 'player_hurt' then
            if e:get_controller('attacker') == entities.get_local_controller() then
                if not k and not k_hs then
                    return on_hit(e, h_hs, h);
                else
                    if e:get_int('health') > 0 then
                        return on_hit(e, h_hs, h);
                    elseif e:get_int('health') <= 0 then
                        return on_kill(e, k_hs, k);
                    end
                end
            end
        else
            return;
        end
    end
end);

onLoadLUA();