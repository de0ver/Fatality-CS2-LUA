--[[ ~~~~ Lua for Fatality.win CS2 by @de0ver ~~~~ ]]--
--[[ ~~~~~~~~~~ Create Date: 02.01.2025 ~~~~~~~~~~ ]]--

-- local enable_sounds = gui.checkbox(gui.control_id('enable_sounds'));
-- local sounds = gui.make_control('Enable Custom Sounds', enable_sounds);

-- [[~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~]]--
local enable_hit = gui.checkbox(gui.control_id('enable_hit'));
local en_hit = gui.make_control('Enable Hit Sound', enable_hit);

local enable_hiths = gui.checkbox(gui.control_id('enable_hiths'));
local en_hiths = gui.make_control('Enable HeadHit Sound', enable_hiths);

local enable_kill = gui.checkbox(gui.control_id('enable_kill'));
local en_kill = gui.make_control('Enable Kill Sound', enable_kill);

local enable_killhs = gui.checkbox(gui.control_id('enable_killhs'));
local en_killhs = gui.make_control('Enable HeadKill Sound', enable_killhs);
-- [[~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~]]--

-- [[~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~]]--
local test_hit = gui.checkbox(gui.control_id('test_hit'));
local hit = gui.make_control('Test Hit Sound', test_hit);

local test_hs = gui.checkbox(gui.control_id('test_hs'));
local head_kill = gui.make_control('Test HeadKill Sound', test_hs);

local test_kill = gui.checkbox(gui.control_id('test_kill'));
local kill = gui.make_control('Test Kill Sound', test_kill);

local test_hshit = gui.checkbox(gui.control_id('test_hshit'));
local head_hit = gui.make_control('Test HeadHit Sound', test_hshit);
-- [[~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~]]--

local group = gui.ctx:find('lua>elements a');

group:add(en_hit);
group:reset();

group:add(en_hiths);
group:reset();

group:add(en_kill);
group:reset();

group:add(en_killhs);
group:reset();

-- group:add(sounds);
-- group:reset();

group:add(hit);
group:reset();

group:add(head_kill);
group:reset();

group:add(kill);
group:reset();

group:add(head_hit);
group:reset();

local file_type = '.vsnd_c';

local sounds = {
    ['hit'] = 'play \\sounds\\hit'..file_type,
    ['kill'] = 'play \\sounds\\kill'..file_type,
    ['head_kill'] = 'play \\sounds\\head_kill'..file_type,
    ['head_hit'] = 'play \\sounds\\head_hit'..file_type
};

local function on_hit(event)
    local sound = nil;

    if event:get_int('hitgroup') == 1 and enable_hiths:get_value():get() then
        sound = sounds['head_hit'];
    elseif enable_hit:get_value():get() then
        sound = sounds['hit'];
    end

    return game.engine:client_cmd(sound);
end

local function on_kill(event)
    local sound = nil;

    if event:get_int('hitgroup') == 1 and enable_killhs:get_value():get() then
        sound = sounds['head_kill'];
    elseif enable_kill:get_value():get() then
        sound = sounds['kill'];
    end

    return game.engine:client_cmd(sound);
end

local function on_event(event)
    local e = event:get_name();

    local h = enable_hit:get_value():get(); -- shitcode because in current api, i cant create input or anything date: 02.01.2025
    local h_s = enable_hiths:get_value():get();
    local k = enable_kill:get_value():get();
    local k_s = enable_killhs:get_value():get();

    if h or h_s or k or k_s then
        if e == 'player_hurt' then
            if event:get_controller('attacker') == entities.get_local_controller() then
                if event:get_int('health') > 0 then
                    return on_hit(event);
                elseif event:get_int('health') <= 0 then
                    return on_kill(event);
                end
            end
        end
    end
end

local function on_present_queue()
    if test_hit:get_value():get() then
        game.engine:client_cmd(sounds['hit']);
        test_hit:set_value(false);
    end

    if test_kill:get_value():get() then
        game.engine:client_cmd(sounds['kill']);
        test_kill:set_value(false);
    end

    if test_hs:get_value():get() then
        game.engine:client_cmd(sounds['head_kill']);
        test_hs:set_value(false);
    end

    if test_hshit:get_value():get() then
        game.engine:client_cmd(sounds['head_hit']);
        test_hshit:set_value(false);
    end
end

mods.events:add_listener('player_death');

events.event:add(on_event);
events.present_queue:add(on_present_queue);