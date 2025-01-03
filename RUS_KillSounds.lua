--[[ ~~~~ Lua for Fatality.win CS2 by @de0ver ~~~~ ]]--
--[[ ~~~~~~~~~~ Create Date: 03.01.2025 ~~~~~~~~~~ ]]--

local enable_sounds = gui.checkbox(gui.control_id('enable_sounds'));
local sounds = gui.make_control('Enable Rus Kill Sounds', enable_sounds);

local random_sounds = gui.checkbox(gui.control_id('random_sounds'));
local random = gui.make_control('!TToXyUI_He_Pa6oTaeT!', random_sounds);

local group = gui.ctx:find('lua>elements a');

group:add(sounds);
group:reset();

group:add(random);
group:reset();

local file_type = '.vsnd_c';
local kill_counter = 0;

local sounds = {
    [6] = 'play \\sounds\\dominate',
    [2] = 'play \\sounds\\doublekill',
    [1] = 'play \\sounds\\firstblood',
    [7] = 'play \\sounds\\godlike',
    [8] = 'play \\sounds\\holyshit',
    [13] = 'play \\sounds\\killingspree',
    [9] = 'play \\sounds\\megakill',
    [12] = 'play \\sounds\\monsterkill',
    [5] = 'play \\sounds\\rampage',
    [3] = 'play \\sounds\\tripplekill',
    [4] = 'play \\sounds\\ultrakill',
    [11] = 'play \\sounds\\unstoppable',
    [10] = 'play \\sounds\\wickedsick'
};

local random_number = {
    [1] = '_v1',
    [2] = '_v2',
    [3] = '_v3'
}

local function on_kill(event)

    if not random_sounds:get_value():get() then
        kill_counter = kill_counter + 1;

        if kill_counter > 13 then
            kill_counter = math.random(6, 13);
        end
    else
        kill_counter = math.random(1, 13);    
    end

    return game.engine:client_cmd(sounds[kill_counter]..random_number[math.random(1, 3)]..file_type);
end

local function on_event(event)
    local e = event:get_name();

    if enable_sounds:get_value():get() then
        if e == 'player_hurt' then
            if event:get_controller('attacker') == entities.get_local_controller() then
                if event:get_int('health') <= 0 then
                    return on_kill(event);
                end
            end
        end

        if e == 'round_start' then
           kill_counter = 0;
        end
    end
end

events.event:add(on_event);