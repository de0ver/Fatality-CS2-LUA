local logs = gui.checkbox(gui.control_id('enable_logs'));
local row = gui.make_control('Notify Logs', logs);
local group = gui.ctx:find('lua>elements a');
group:add(row);

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

local function bomb_logs(event)
	local userid = 'undefined';
	
	if event:get_controller('userid'):get_name() ~= nil then
		userid = event:get_controller('userid'):get_name();
	end
	
	local message = '<'..
		userid..
		'>'..
		bomb_events[event:get_name()];
		
	print(message);
	
	return gui.notify:add(gui.notification(
		'<'..
		userid..
		'>',
		bomb_events[event:get_name()], 
		draw.textures['icon_visuals']));
end

local function hit_logs(event)
	local weapon = 'undefined';
	
	if weapon_name[event:get_string('weapon')] ~= 'undefined' and 
		fuck_valve[event:get_pawn_from_id('attacker'):get_active_weapon():get_data().name] == event:get_pawn_from_id('attacker'):get_active_weapon():get_data().name then
		weapon = weapon_name[event:get_string('weapon')];
	else 
		weapon = fuck_valve[event:get_pawn_from_id('attacker'):get_active_weapon():get_data().name];
	end
	
	local userid = 'undefined';
	
	if event:get_controller('userid'):get_name() ~= nil then
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
		
	print(message);
		
	return gui.notify:add(gui.notification(
		'Hit!',
		message,
		draw.textures['icon_rage']));
end

local function hurt_logs(event)
	local attacker = 'undefined';
	
	if event:get_controller('attacker'):get_name() ~= nil then
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
		
	print(message);
	
	return gui.notify:add(gui.notification(
		'Hurt!', 
		message, 
		draw.textures['icon_legit']));
end

local function round_logs(event)
	return gui.notify:add(gui.notification(
		'Round started!', 
		'Buy weapons and FIGHT!!!', 
		draw.textures['icon_visuals']));
end

local function on_event(event)
	if logs:get_value():get() then
		if event:get_name() == 'player_hurt' then
			if event:get_controller('attacker') == entities.get_local_controller() then
				return hit_logs(event);
			elseif event:get_controller('userid') == entities.get_local_controller() then
				return hurt_logs(event);
			end
		end
		
		if event:get_name() == 'round_start' then
			return round_logs(event);
		end
		 
		if string.find(event:get_name(), 'bomb_') then
			return bomb_logs(event);
		end
	end
end

events.event:add(on_event);