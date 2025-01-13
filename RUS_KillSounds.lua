--[[ ~~~~ Lua for Fatality.win CS2 by @de0ver ~~~~ ]]--
--[[ ~~~~~~~~~~ Create Date: 03.01.2025 ~~~~~~~~~~ ]]--

local enable_sounds = gui.checkbox(gui.control_id('enable_sounds'));
local sounds = gui.make_control('Enable Rus Kill Sounds', enable_sounds);

local random_sounds = gui.checkbox(gui.control_id('random_sounds'));
local random = gui.make_control('!TToXyUI_He_Pa6oTaeT!', random_sounds);

local group = gui.ctx:find('lua>elements a');
group:reset();

group:add(sounds);
group:add(random);

local file_type = '.vsnd_c';
local kill_counter = 0;

local sounds = {
    'firstblood',
    'doublekill',
    'tripplekill',
    'ultrakill',
    'rampage',
    'dominate',
    'godlike',
    'holyshit',
    'megakill',
    'wickedsick',
    'unstoppable',
    'monsterkill',
    'killingspree',
};

local random_number = {
    '_v1',
    '_v2',
    '_v3'
}

local function on_kill(event)

    if not random_sounds:get_value():get() then
        kill_counter = kill_counter + 1;

        if kill_counter > #sounds then
            kill_counter = math.random(6, #sounds);
        end
    else
        kill_counter = math.random(1, #sounds);    
    end

    return game.engine:client_cmd('play \\sounds\\'..sounds[kill_counter]..random_number[math.random(1, 3)]..file_type);
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