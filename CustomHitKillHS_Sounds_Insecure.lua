local function createNotify(title, body, texture)
    return gui.notify:add(
        gui.notification(
            title,
            body,
            texture
        )
    );
end

if ffi == nil then
    return createNotify('WARNING!', 'TURN ON ALLOW INSECURE IN LUA AND RELOAD SCRIPT!', draw.textures['icon_allow_insecure']);
end

local hitsound_box = gui.combo_box(gui.control_id('hitsound_box'));
local en_hitsounds = gui.make_control('Hit Sounds', hitsound_box);

local killsound_box = gui.combo_box(gui.control_id('killsound_box'));
local en_killsounds = gui.make_control('Kill Sounds', killsound_box);

local hithssound_box = gui.combo_box(gui.control_id('hithssound_box'));
local en_hithssounds = gui.make_control('Head Hit Sounds', hithssound_box);

local killhssound_box = gui.combo_box(gui.control_id('killhssound_box'));
local en_killhssounds = gui.make_control('Head Kill Sounds', killhssound_box);

local open_sounds_path = gui.button(gui.control_id('open_sounds_path'), 'Open!');
local btn_sounds_path = gui.make_control('Open Sounds Folder', open_sounds_path);

local refresh_sounds = gui.button(gui.control_id('refresh_sounds'), 'Refresh');
local btn_refresh_sounds = gui.make_control('Refresh Sounds', refresh_sounds);

local sound_volume = gui.slider(gui.control_id('sound_volume'), 0.0, 100.0, {'%.00f%%'}, 0.1);
local slider_sound_volume = gui.make_control('Sounds Volume', sound_volume);

local group = gui.ctx:find('lua>elements a');
group:reset();

local function createGUI()
    group:add(en_hitsounds);
    group:add(en_killsounds);
    group:add(en_hithssounds);
    group:add(en_killhssounds);
    group:add(slider_sound_volume);
    group:add(btn_sounds_path);
    group:add(btn_refresh_sounds);
end

local sounds_table = {};
local MAX_PATH = 260;
local lpBuffer = ffi.new('char[?]', MAX_PATH);
local sound_link = 'https://raw.githubusercontent.com/de0ver/Fatality-CS2-LUA/refs/heads/main/sounds/other_sounds/roblox.vsnd_c';

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
    int ShellExecuteA(int hwnd, const char* lpOperation, const char* lpFile, const char* lpParameters, const char* lpDirectory, int nShowCmd);
    int URLDownloadToFileA(const char* pCaller, const char* szURL, const char* szFileName, unsigned int dwReserved, int lpfnCB);
    unsigned int GetFileAttributesA(const char* lpFileName);
]];

local GetCurrentDirectoryA = ffi.cast('unsigned int(__stdcall*)(unsigned int, char*)', utils.find_export('kernel32.dll', 'GetCurrentDirectoryA'));
local FindFirstFileA = ffi.cast('void*(__stdcall*)(const char*, WIN32_FIND_DATAA*)', utils.find_export('kernel32.dll', 'FindFirstFileA'));
local FindNextFileA = ffi.cast('bool(__stdcall*)(void*, WIN32_FIND_DATAA*)', utils.find_export('kernel32.dll', 'FindNextFileA'));
local FindClose = ffi.cast('bool(__stdcall*)(void*)', utils.find_export('kernel32.dll', 'FindClose'));
local ShellExecuteA = ffi.cast('int(__stdcall*)(int, const char*, const char*, const char*, const char*, int)', utils.find_export('shell32.dll', 'ShellExecuteA'));
local URLDownloadToFileA = ffi.cast('int(__stdcall*)(const char*, const char*, const char*, unsigned int, int)', utils.find_export('urlmon.dll', 'URLDownloadToFileA'));
local GetFileAttributesA = ffi.cast('unsigned int(__stdcall*)(const char*)', utils.find_export('kernel32.dll', 'GetFileAttributesA'));

GetCurrentDirectoryA(MAX_PATH, lpBuffer);

local cs2_path = ffi.string(lpBuffer);
local cs2_sounds_path = cs2_path:gsub('bin\\win64', 'csgo\\sounds'); -- Counter-Strike Global Offensive\game\bin\win64 -> Counter-Strike Global Offensive\game\csgo\sounds

local function addValueToAllCombo(value)
    hitsound_box:add(gui.selectable(gui.control_id('hit'..value), value));
    killsound_box:add(gui.selectable(gui.control_id('kill'..value), value));
    hithssound_box:add(gui.selectable(gui.control_id('hiths'..value), value));
    killhssound_box:add(gui.selectable(gui.control_id('killhs'..value), value));
end

--[[
local function clearAllCombo(value)
    hitsound_box:remove(hitsound_box:find('hit'..value));
    killsound_box:remove(killsound_box:find('kill'..value));
    hithssound_box:remove(hithssound_box:find('hiths'..value));
    killhssound_box:remove(killhssound_box:find('killhs'..value));
    hitsound_box:reset();
end

local function setValueToAllCombo(value)
    hitsound_box:get_value():get():set_raw(value);
    killsound_box:get_value():get():set_raw(value);
    hithssound_box:get_value():get():set_raw(value);
    killhssound_box:get_value():get():set_raw(value);
end
]]--

local function listFiles(path) -- https://vsokovikov.narod.ru/New_MSDN_API/Menage_files/fn_findfirstfile.htm
    local findFileData = ffi.new('WIN32_FIND_DATAA');
    local hFind = FindFirstFileA(path .. '\\*', findFileData);

    if (hFind == -1) then
        return createNotify('Fail!', 'Invalid File Handle.', draw.textures['icon_close']);
    end

    local bits = 1;
    local max_bits = 2 ^ 32;

    addValueToAllCombo('None');
    sounds_table[bits] = 'None';

    repeat
        local cFileName = ffi.string(findFileData.cFileName);
        if bits <= max_bits and cFileName ~= '.' and cFileName ~= '..' and string.find(cFileName, '.vsnd_c') then
            addValueToAllCombo(cFileName);
            bits = bits * 2;
            sounds_table[bits] = cFileName;
        end
    until not FindNextFileA(hFind, findFileData);

    FindClose(hFind);
end

--[[
local function listFilesRef(path)
    local findFileData = ffi.new('WIN32_FIND_DATAA');
    local hFind = FindFirstFileA(path .. '\\*', findFileData);

    if (hFind == -1) then
        return createNotify('Fail!', 'Invalid File Handle.', draw.textures['icon_close']);
    end
    
    repeat
        local cFileName = ffi.string(findFileData.cFileName);
        if cFileName ~= '.' and cFileName ~= '..' and string.find(cFileName, '.vsnd_c') then
            clearAllCombo(cFileName);
        end
    until not FindNextFileA(hFind, findFileData);

    setValueToAllCombo(1);

    table.clear(sounds_table);

    FindClose(hFind);
end
]]--

local function refreshSounds()
    return createNotify('WIP', 'The current API does not allow to create this. Reload script to refresh...', draw.textures['icon_scripts']);
    -- listFilesRef(cs2_sounds_path);
    -- listFiles(cs2_sounds_path);
end

local function onLoadLUA()
    createGUI();

    if GetFileAttributesA(cs2_sounds_path..'\\roblox.vsnd_c') == 4294967295 then
        if URLDownloadToFileA(nil, sound_link, cs2_sounds_path..'\\roblox.vsnd_c', 0, 0) == 0 then
            createNotify('Success!', 'Downloaded Roblox Sound!', draw.textures['gui_icon_add']);
        else
            createNotify('Fail!', 'Something went wrong!', draw.textures['icon_close']);
        end 
    end

    sound_volume:add_callback(function ()
        return game.engine:client_cmd('snd_toolvolume '..sound_volume:get_value():get() / 100, true);
    end);

    open_sounds_path:add_callback(function ()
        return ShellExecuteA(0, 'open', ffi.string(cs2_sounds_path), nil, nil, 1);
    end);

    refresh_sounds:add_callback(function ()
        return refreshSounds();
    end);

    listFiles(cs2_sounds_path);
end

local function cmd(command)
    return game.engine:client_cmd('play \\sounds\\'..command);
end

local function onHit(e, h_hs, h)
    if h_hs and e:get_int('hitgroup') == 1 then
        return cmd(sounds_table[hithssound_box:get_value():get():get_raw()]);
    elseif h then
        return cmd(sounds_table[hitsound_box:get_value():get():get_raw()]);
    end
end

local function onKill(e, k_hs, k)
    if k_hs and e:get_int('hitgroup') == 1 then
        return cmd(sounds_table[killhssound_box:get_value():get():get_raw()]);
    elseif k then
        return cmd(sounds_table[killsound_box:get_value():get():get_raw()]);
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
                    return onHit(e, h_hs, h);
                else
                    if e:get_int('health') > 0 then
                        return onHit(e, h_hs, h);
                    elseif e:get_int('health') <= 0 then
                        return onKill(e, k_hs, k);
                    end
                end
            end
        else
            return;
        end
    end
end);

onLoadLUA();