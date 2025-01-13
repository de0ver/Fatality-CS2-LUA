local item_name = gui.text_input(gui.control_id('item_name'));
local rare = gui.combo_box(gui.control_id('skin_rare'));
local button = gui.button(gui.control_id('button_fake_open'), 'Fake Unbox');
local stattrak = gui.checkbox(gui.control_id('enable_stattrak'));
local star = gui.checkbox(gui.control_id('enable_star'));
local skin_name = gui.text_input(gui.control_id('skin_name'));

local control_button = gui.make_control('Push Button', button);
local control_checkbox = gui.make_control('Enable StatTrak™?', stattrak);
local control_skin = gui.make_control('Enter Skin: ', skin_name);
local control_star = gui.make_control('Enable Star?', star);
local control_rare = gui.make_control('Choose Rare: ', rare);
local control_name = gui.make_control('Enter Item: ', item_name);

local group = gui.ctx:find('lua>elements a');

group:reset();
group:add(control_name);
group:add(control_skin)
group:add(control_checkbox);
group:add(control_star);
group:add(control_rare);
group:add(control_button);

local symbol = {
    [1] = '',
    [2] = '',
    [4] = ''
}

rare:add(gui.selectable(gui.control_id('rare_red'), 'Red'));
rare:add(gui.selectable(gui.control_id('rare_blue'), 'Blue'));
rare:add(gui.selectable(gui.control_id('rare_pink'), 'Pink'));


button:add_callback(function ()

    if not game.engine:in_game() then
        return gui.notify:add(
            gui.notification(
                'GO TO MAP!', 'Connect to server or smth', 
                draw.textures['icon_close']
            )
        );
    end

    local stattrak_text = ' ';
    local star_text = ' ';

    if stattrak:get_value():get() then
        stattrak_text = 'StatTrak™';
    end

    if star:get_value():get() then
        star_text = '★';
    end

    game.engine:client_cmd(
        string.format(
            'Playerchatwheel CW.NeedQuiet "%s has opened a container and found: %s %s %s %s | %s"', 
            entities:get_local_controller():get_name(),
            symbol[rare:get_value():get():get_raw()],
            star_text,
            stattrak_text,
            item_name.value,
            skin_name.value
        )
    );
    
end);