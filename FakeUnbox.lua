local item_name = gui.text_input(gui.control_id('item_name_F003F829-3692-45B9-860B-0A205D3381B7'));
local rare = gui.combo_box(gui.control_id('skin_rare_BBF28370-B346-4B89-BB4A-15D1A3F8AABA'));
local button = gui.button(gui.control_id('button_fake_open_F4E9C08E-0B27-4F93-B4D4-623AFDDF5045'), 'Fake Unbox');
local stattrak = gui.checkbox(gui.control_id('enable_stattrak_70A5615B-C273-4C7C-A571-7DF05FF895D4'));
local star = gui.checkbox(gui.control_id('enable_star_A848C1FD-B3B3-4D2A-808C-3F6CE2CEDFEC'));
local skin_name = gui.text_input(gui.control_id('skin_name_794E9300-4EF0-400A-B402-F95DAE35FAA1'));

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

rare:add(gui.selectable(gui.control_id('rare_red_250F4963-0EFE-4BC5-8CDF-628908A7F6DA'), 'Red'));
rare:add(gui.selectable(gui.control_id('rare_blue_CC0E055A-4AB9-4499-AEFC-ADC39052F16D'), 'Blue'));
rare:add(gui.selectable(gui.control_id('rare_pink_D9619421-2BED-4B09-BEAD-4874DF4C8B43'), 'Pink'));


button:add_callback(function ()

    if not game.engine:in_game() then
        return gui.notify:add(
            gui.notification(
                'GO TO MAP!', 
                'Connext to server or smth', 
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