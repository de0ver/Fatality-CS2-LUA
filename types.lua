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

--- @class layout
layout = {};

--- @class user_t
--- @field avatar texture;
--- @field username string;
user = {};

-- https://lua.fatality.win/context.html
--- @class context
--- @field find fun(id: string): control;
--- @field user user_t;
context = {};

--- @class notification_system
--- @field add fun(notify: notification);
notification_system = {};

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

-- https://lua.fatality.win/checkbox.html
--- @class checkbox: control
--- @field get_value fun();
--- @field get fun();
--- @field set_value fun(val: boolean);
checkbox = {};

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

--- @class notification
notification = {};

--- @class texture
--- @field is_animated boolean;
--- @field get_size fun(): vec2;
texture = {};

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

--- @class draw
--- @field textures texture;
draw = {};

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