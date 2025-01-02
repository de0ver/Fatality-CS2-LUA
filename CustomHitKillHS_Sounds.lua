local enable_sounds = gui.checkbox(gui.control_id('enable_sounds'));
local sounds = gui.make_control('Enable Custom Sounds', enable_sounds);

local test_hit = gui.checkbox(gui.control_id('test_hit'));
local hit = gui.make_control('Test Hit Sound', test_hit);

local test_hs = gui.checkbox(gui.control_id('test_hs'));
local head_kill = gui.make_control('Test HeadKill Sound', test_hs);

local test_kill = gui.checkbox(gui.control_id('test_kill'));
local kill = gui.make_control('Test Kill Sound', test_kill);

local group = gui.ctx:find('lua>elements a');

group:add(sounds);
group:reset();

group:add(hit);
group:reset();

group:add(head_kill);
group:reset();

group:add(kill);
group:reset();

local file_type = '.vsnd_c';

local sounds = {
    ['hit'] = 'play \\sounds\\hit'..file_type,
    ['kill'] = 'play \\sounds\\kill'..file_type,
    ['head_kill'] = 'play \\sounds\\head_kill'..file_type
};

local function on_hit(event)
    return game.engine:client_cmd(sounds['hit']);
end

local function on_kill(event)
    if event:get_int('hitgroup') == 1 then
        return game.engine:client_cmd(sounds['head_kill']);
    end

    return game.engine:client_cmd(sounds['kill']);
end

local function on_event(event)
    local e = event:get_name();

    if enable_sounds:get_value():get() then
        if e == 'player_hurt' then
            if event:get_controller('attacker') == entities.get_local_controller() then
                if event:get_int('health') > 0 then
                    do return on_hit(event) end;
                elseif event:get_int('health') <= 0 then
                    do return on_kill(event) end;
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
end

mods.events:add_listener('player_death');

events.event:add(on_event);
events.present_queue:add(on_present_queue);