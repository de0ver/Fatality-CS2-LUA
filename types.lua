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

--- @class context
context = {};

--- @class notification_system
--- @field add fun(notification);
notification_system = {};

--- @class control
control = {};

--- @class checkbox
--- @field get_value fun();
--- @field get fun();
--- @field set_value fun(val: boolean);
checkbox = {};

--- @class control_id

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
