local logs = gui.checkbox(gui.control_id('enable_logs'));
local console_logs = gui.checkbox(gui.control_id('console_logs'));
local c_logs = gui.make_control('Notify Logs', logs);
local c_con_logs = gui.make_control('Console Logs', console_logs);
local group = gui.ctx:find('lua>elements a');
group:reset();

group:add(c_logs);
group:add(c_con_logs);

local function createNotify(title, body, texture)
    return gui.notify:add(
        gui.notification(
            title,
            body,
            texture
        )
    );
end

local hitgroup = {
	[0] = 'generic',
	[1] = 'head',
	[2] = 'chest',
	[3] = 'stomach',
	[4] = 'left arm',
	[5] = 'right arm',
	[6] = 'left leg',
	[7] = 'right leg'
};

setmetatable(hitgroup, {
    __index = function(_, key)
        return key;
    end
});

local weapon_name = {
	['ak47'] = 'AK-47',
    ['aug'] = 'AUG',
    ['awp'] = 'AWP',
    ['bizon'] = 'PP-Bizon',
    ['c4'] = 'C4',
    ['cz75a'] = 'CZ75-Auto',
    ['deagle'] = 'Desert Eagle',
    ['decoy'] = 'Decoy',
    ['elite'] = 'Dual Berettas',
    ['famas'] = 'FAMAS',
    ['fists'] = 'Bare Hands',
    ['fiveseven'] = 'Five-SeveN',
    ['flashbang'] = 'Flashbang',
    ['g3sg1'] = 'G3SG1',
    ['galilar'] = 'Galil AR',
    ['glock'] = 'Glock-18',
    ['hammer'] = 'Hammer',
    ['healthshot'] = 'Healthshot',
    ['hkp2000'] = 'P2000',
    ['incgrenade'] = 'Molotov',
    ['knife'] = 'Knife',
    ['m249'] = 'M249',
    ['m4a1'] = 'M4A4',
    ['m4a1_silencer'] = 'M4A1-S',
    ['mac10'] = 'MAC-10',
    ['mag7'] = 'MAG-7',
    ['molotov'] = 'Molotov',
    ['mp5sd'] = 'MP5-SD',
    ['mp7'] = 'MP7',
    ['mp9'] = 'MP9',
    ['negev'] = 'Negev',
    ['nova'] = 'Nova',
    ['p250'] = 'P250',
    ['p90'] = 'P90',
    ['revolver'] = 'R8 Revolver',
    ['sawedoff'] = 'Sawed-Off',
    ['scar20'] = 'SCAR-20',
    ['sg556'] = 'SG 553',
    ['smokegrenade'] = 'Smoke',
    ['ssg08'] = 'SSG 08',
    ['taser'] = 'Zeus',
    ['tec9'] = 'Tec-9',
    ['ump45'] = 'UMP-45',
    ['usp_silencer'] = 'USP-S',
    ['xm1014'] = 'XM1014',
	['hegrenade'] = 'HE Grenade',
	['inferno'] = 'Fire'
};

setmetatable(weapon_name, {
    __index = function(_, key)
        return 'undefined';
    end
});

local fuck_valve = {
	['weapon_revolver'] = 'R8 Revolver',
	['weapon_usp_silencer'] = 'USP-S',
	['weapon_m4a1_silencer'] = 'M4A1-S',
	['weapon_mp5sd'] = 'MP5-SD',
	['weapon_cz75a'] = 'CZ75-Auto'
};

setmetatable(fuck_valve, {
    __index = function(_, key)
        return key;
    end
});

local bomb_events = {
	['bomb_beginplant'] = ' Began planting the bomb',
	['bomb_abortplant'] = ' Cancelled planting the bomb',
	['bomb_planted'] = ' Planted the bomb',
	['bomb_defused'] = ' Defused the bomb',
	['bomb_exploded'] = ' Exploded the bomb'
};

setmetatable(bomb_events, {
    __index = function(_, key)
        return key;
    end
});

local round_events = {
	['round_start'] = {'Round started!', 'Buy weapons and FIGHT!!!'},
	['round_end'] = {'Round end.', 'Better luck next time.'}
};

setmetatable(round_events, {
    __index = function(_, key)
        return {key, 'undefined'};
    end
});

local function bomb_logs(event, console, notify)
	local userid = 'undefined';
	
	if event:get_controller('userid') ~= nil then
		userid = event:get_controller('userid'):get_name();
	end
	
	local message = '<'..
		userid..
		'>'..
		bomb_events[event:get_name()];
	
	if console then
		print(message);
	end
	
	if notify then
		createNotify(
			'<'..userid..'>',
			bomb_events[event:get_name()],
			draw.textures['icon_visuals']
		);
	end
end

local function hit_logs(event, console, notify)
	local weapon = 'undefined';
	local event_weapon = 'undefined';
	local attacker_weapon = 'undefined';

	if event:get_string('weapon') ~= nil then
		event_weapon = event:get_string('weapon');
	end

	if event:get_pawn_from_id('attacker') ~= nil then
		attacker_weapon = event:get_pawn_from_id('attacker'):get_active_weapon():get_data().name;
	end
	
	
	if weapon_name[event_weapon] ~= 'undefined' and fuck_valve[attacker_weapon] == attacker_weapon then
		weapon = weapon_name[event_weapon];
	else 
		weapon = fuck_valve[attacker_weapon];
	end
	
	local userid = 'undefined';
	
	if event:get_controller('userid') ~= nil then
		userid = event:get_controller('userid'):get_name();
	end
	
	local message = 'Hit <'
		..userid..
		'> for '
		..event:get_int('dmg_health')..
		' ('
		..event:get_int('health')..
		') hp in '
		..hitgroup[event:get_int('hitgroup')]..
		' with '
		..weapon;
	
	if console then
		print(message);
	end
	
	if notify then
		createNotify(
			'Hit!',
			message,
			draw.textures['icon_rage']
		);
	end
end

local function hurt_logs(event, console, notify)
	local attacker = 'undefined';
	
	if event:get_controller('attacker') ~= nil then
		attacker = event:get_controller('attacker'):get_name();
	end
	
	local message = 'Hurt by <'
		..attacker..
		'> for '
		..event:get_int('dmg_health')..
		' ('
		..event:get_int('health')..
		') hp in '
		..hitgroup[event:get_int('hitgroup')]..
		' with '
		..weapon_name[event:get_string('weapon')];
	
	if console then
		print(message);
	end
	
	if notify then
		createNotify(
			'Hurt!',
			message,
			draw.textures['icon_legit']
		);
	end
end

local function round_logs(event, console, notify)
	local event_name = event:get_name();
	local message = round_events[event_name];

	if event:get_string('message') ~= nil then
		if string.find(event:get_string('message'), '_Terrorists') then
			message[2] = 'Terrorists win!';
		elseif string.find(event:get_string('message'), '_CTs_') then
			message[2] = 'Counter-Terrorists win!';
		end
	end

	if console then
		print(message[1]..message[2]);
	end
	
	if notify then
		createNotify(
			message[1],
			message[2],
			draw.textures['icon_visuals']
		);
	end
end

local function on_event(event)
	local l = logs:get_value():get();
	local c = console_logs:get_value():get();
	local e = event:get_name();

	if l or c then
		if e == 'player_hurt' then
			if event:get_controller('attacker') == entities.get_local_controller() then
				return hit_logs(event, c, l);
			elseif event:get_controller('userid') == entities.get_local_controller() then
				return hurt_logs(event, c, l);
			end
		end
		
		if string.find(e, 'round_') then
			return round_logs(event, c, l);
		end
		 
		if string.find(e, 'bomb_') then
			return bomb_logs(event, c, l);
		end
	end
end

mods.events:add_listener('round_end');

events.event:add(on_event);