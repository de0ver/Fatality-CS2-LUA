---@diagnostic disable: duplicate-doc-field
--[[ ~~~~ Lua API Snippet for Fatality.win CS2 by @de0ver ~~~~ ]]--
--[[ ~~~~~~~~~~~~~~~~ Create Date: 31.12.2024 ~~~~~~~~~~~~~~~~ ]]--

-- https://lua.fatality.win/gui.html
--- @class gui
--- @field ctx context;
--- @field notify notification_system;
--- @field make_control fun(text: string, c: control): layout;
--- @field checkbox fun(id: control_id): control;
--- @field control_id fun(my_id: string): control_id;
--- @field notification fun(header: string, text: string, ico: texture): notification;
gui = {};

-- https://lua.fatality.win/layout.html
--- @class layout
layout = {};

-- https://lua.fatality.win/group.html
--- @class group
group = {};

-- https://lua.fatality.win/user-t.html
--- @class user_t
--- @field avatar texture;
--- @field username string;
user = {};

-- https://lua.fatality.win/context.html
--- @class context
--- @field user user_t;
context = {};

--- @param id string;
function context:find(id)
    return control;
end

-- https://lua.fatality.win/notification-system.html
--- @class notification_system
notification_system = {};

--- @param notify notification;
function notification_system:add(notify)
    return gui.notification(notify);
end

-- https://lua.fatality.win/notification.html
--- @class notification
-- @field notification fun(header: string, text: string, ico: texture): notification;
notification = {};

-- https://lua.fatality.win/control.html
--- @class control
--- @field id number;
--- @field id_string string;
--- @field is_visible boolean;
--- @field parent control;
--- @field type control_type;
--- @field inactive boolean;
--- @field inactive_text string;
--- @field inactive_color color;
--- @field tooltip string;
--- @field aliases table[string];
--- @field get_hotkey_state fun(): boolean;
--- @field set_visible fun(val: boolean);
--- @field add_callback fun(fun);
--- @field cast fun(): control;
--- @field reset fun();
control = {};


function control:add(layout)
    return layout;
end

-- https://lua.fatality.win/checkbox.html
--- @class checkbox: control
--- @field get_value fun();
--- @field get fun();
--- @field set_value fun(val: boolean);
checkbox = {};

-- https://lua.fatality.win/control-id.html
--- @class control_id: control

-- https://lua.fatality.win/control-type.html#widget
--- @class control_type: control
--- @field default control;
--- @field button control;
--- @field checkbox control;
--- @field child_tab control;
--- @field color_picker control;
--- @field combo_box control;
--- @field control_container control;
--- @field group control;
--- @field hotkey control;
--- @field hsv_slider control;
--- @field label control;
--- @field list control;
--- @field loading control;
--- @field notification_control control;
--- @field popup control;
--- @field selectable control;
--- @field slider control;
--- @field spacer control;
--- @field tab control;
--- @field tabs_layout control;
--- @field weapon_tabs_layout control;
--- @field text_input control;
--- @field toggle_button control;
--- @field window control;
--- @field widget control;
--- @field settings control;
control_type = {};

-- https://lua.fatality.win/texture.html
--- @class texture
--- @field is_animated boolean;
--- @field get_size fun(): vec2;
texture = {};

-- https://lua.fatality.win/vec2.html
--- @class vec2
--- @field x number;
--- @field y number;
--- @field floor fun(): vec2;
--- @field ceil fun(): vec2;
--- @field round fun(): vec2;
--- @field len fun(): number;
--- @field len_sqr fun(): number;
--- @field dist fun(other: vec2): number;
--- @field dist_sqr fun(other: vec2): number;
vec2 = {};

-- https://lua.fatality.win/draw.html
--- @class draw
--- @field adapter adapter;
--- @field frame_time number;
--- @field time number;
--- @field scale number;
--- @field display vec2;
--- @field textures accessor<texture>;
--- @field fonts accessor<font_base>;
--- @field shaders accessor<shader>;
--- @field surface layer;
draw = {};

-- https://lua.fatality.win/adapter.html
--- @class adapter
adapter = {};

--- @return ptr;
function adapter:get_back_buffer()
end

--- @return ptr;
function adapter:get_back_buffer_downsampled()
end

--- @return ptr;
function adapter:get_shared_texture()
end

--- @class ptr
ptr = {};

-- https://lua.fatality.win/rcolor.html
--- @class color: draw
--- @field white fun(): color;
--- @field white_transparent fun(): color;
--- @field black fun(): color;
--- @field black_transparent fun(): color;
--- @field percent fun(p: number, a: number): color;
--- @field gray fun(b: number, a: number): color;
--- @field interpolate fun(a: color, b: color, t: number): color;
--- @field rgba fun(): integer;
--- @field argb fun(): integer;
--- @field bgra fun(): integer;
--- @field abgr fun(): integer;
--- @field darken fun(value: number): color;
--- @field mod_a fun(value: number): color;
-- @field mod_a fun(value: integer): color;
--- @field r fun(value: number): color;
--- @field g fun(value: number): color;
--- @field b fun(value: number): color;
--- @field a fun(value: number): color;
--- @field get_r fun(): integer;
--- @field get_g fun(): integer;
--- @field get_b fun(): integer;
--- @field get_a fun(): integer;
--- @field h fun(): integer;
--- @field s fun(): number;
--- @field v fun(): number;
--- @field hsv fun(hue: integer, saturation: number, brightness: number, alpha: number): color;
color = {};

--- @class cs2_player_controller

--- @class cs2_player_pawn

-- https://lua.fatality.win/events.html
--- @class events
--- @field event event_t;
events = {};

-- https://lua.fatality.win/event-t.html
--- @class event_t
--- @field add fun(status, err);
--- @field remove fun(status, err);
event = {};

-- https://lua.fatality.win/game-event-t.html
--- @class game_event_t
--- @field get_name fun(): string;
--- @field get_bool fun(key: string): boolean;
--- @field get_int fun(key: string): integer;
--- @field get_float fun(key: string): number;
--- @field get_string fun(key: string): string;
--- @field get_controller fun(key: string): cs2_player_controller;
--- @field get_pawn_from_id fun(key: string): cs2_player_pawn;
event = {};


-- https://lua.fatality.win/vector.html
--- @class vector
--- @field x number;
--- @field y number;
--- @field z number;
--- @field is_zero fun(tolerance: number): boolean;
--- @field dist fun(other: vector): number;
--- @field dist_sqr fun(other: vector): number;
--- @field dist_2d fun(other: vector): number;
--- @field dist_2d_sqr fun(other: vector): number;
--- @field cross fun(other: vector): vector;
--- @field is_valid fun(): boolean;
--- @field length fun(): number;
--- @field length_sqr fun(): number;
--- @field length_2d fun(): number;
--- @field length_2d_sqr fun(): number;
--- @field dot fun(other: vector): number;
vector = {};

-- https://lua.fatality.win/entities.html
--- @class entities
--- @field players entity_list_t<cs2_player_pawn>;
--- @field controllers entity_list_t<cs2_player_controller>;
--- @field items entity_list_t<cs2_weapon_base>;
--- @field dropped_items entity_list_t<cs2_weapon_base>;
--- @field projectiles entity_list_t<cs2_grenade_projectile>;
--- @field get_local_pawn fun(): cs2_player_pawn;
--- @field get_local_controller fun(): cs2_player_controller;
entities = {};

-- https://lua.fatality.win/entity-list-t.html
--- @class entity_list_t
entity_list = {};

function entity_list:for_each(entry)
    return entry;
end

function entity_list:for_each_z(entry)
    return entry;
end

-- https://lua.fatality.win/entity-entry-t.html
--- @class entity_entry_t
--- @field entity type;
--- @field had_dataupdate boolean;
--- @field handle chandle<type>;
--- @field avatar texture;
entity_entry = {};

-- https://lua.fatality.win/chandle.html
--- @class chandle
chandle = {};


--- @return <type>
function chandle:get() end

--- @return boolean is_valid
function chandle:valid() end

--- @return boolean
function chandle:is_clientside() end

--- @class mods
--- @field events events_t;
mods = {};

--- @class events_t
events = {};

--- @param name string
function events:add_listener(name)
end

