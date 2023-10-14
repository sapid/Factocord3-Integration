-- This file is heavily adapted from https://github.com/maxsupermanhd/FactoCord-3.0/blob/master/control.lua and https://github.com/maxsupermanhd/FactoCord-3.0/blob/master/control.lua
local function PrintToDiscord(msg)
	localised_print({"", "0000-00-00 00:00:00 [DISCORD] ", msg})
end

local function on_player_joined_game(event)
	local p = game.players[event.player_index];
	PrintToDiscord(":wave: **" .. p.name .. "** joined.");
	if(p.admin == true) then
		p.print(":wave: Welcome admin " .. p.name .. " to server!");
	else
		p.print(":wave: Welcome " .. p.name .. " to server!");
	end
end

local function get_infinite_research_name(name)
	-- gets the name of infinite research (without numbers)
  	return string.match(name, "^(.-)%-%d+$") or name
end

local function on_research_finished(event)
	local research_name = get_infinite_research_name(event.research.name)
	PrintToDiscord(":science_pack: Research finished: " .. research_name .. " " .. (event.research.level or ""))
end

local function on_player_left_game(e)
	local p = game.players[e.player_index];
	local reason
	if event.reason == defines.disconnect_reason.quit then
		reason = "quit"
	elseif event.reason == defines.disconnect_reason.dropped then
		reason = "dropped"
	elseif event.reason == defines.disconnect_reason.reconnect then
		reason = "reconnect"
	elseif event.reason == defines.disconnect_reason.wrong_input then
		reason = "wrong_input"
	elseif event.reason == defines.disconnect_reason.desync_limit_reached then
		reason = "desync_limit_reached"
	elseif event.reason == defines.disconnect_reason.cannot_keep_up then
		reason = "cannot_keep_up"
	elseif event.reason == defines.disconnect_reason.afk then
		reason = "afk"
	elseif event.reason == defines.disconnect_reason.kicked then
		reason = "kicked"
	elseif event.reason == defines.disconnect_reason.kicked_and_deleted then
		reason = "kicked_and_deleted"
	elseif event.reason == defines.disconnect_reason.banned then
		reason = "banned"
	elseif event.reason == defines.disconnect_reason.switching_servers then
		reason = "switching_servers"
	end
	if reason then
		PrintToDiscord(":wave: **" .. p.name .. "** left (" .. reason .. ").")
	else
		PrintToDiscord(":wave: **" .. p.name .. "** left.");
	end
end

local function on_console_chat(e)
		if not e.player_index then
			return
		end
		if game.players[e.player_index].tag == "" then
			if game.players[e.player_index].admin then
				PrintToDiscord('(Admin) <' .. game.players[e.player_index].name .. '> ' .. e.message)
			else
				PrintToDiscord('<' .. game.players[e.player_index].name .. '> ' .. e.message)
			end
		else
			if game.players[e.player_index].admin then
				PrintToDiscord('(Admin) <' .. game.players[e.player_index].name .. '> ' .. game.players[e.player_index].tag .. " " .. e.message)
			else
				PrintToDiscord('<' .. game.players[e.player_index].name .. '> ' .. game.players[e.player_index].tag .. " " .. e.message)
			end
		end
	end



local function on_player_died(event)
	local p = game.players[event.player_index];
	local c = event.cause
	if not c then
		PrintToDiscord(":skull: **" .. p.name .. "** died.");
	else
		local name = "Unknown";
		if c.type == "character" then
			name = c.player.name;
		elseif c.type == "spider-vehicle" then
			if c.entity_label then
				name = {"", c.localised_name, " " , c.entity_label};
			else
				name = {"", "a ", c.localised_name};
			end
		elseif c.type == "locomotive" then
			name = {"", c.localised_name, " " , c.backer_name};
		else
			name = {"", "a ", c.localised_name};
		end
		PrintToDiscord({":skull: ", "**", p.name, "** killed by ", name, "."});
	end
end
local function on_player_kicked(event)
	local p = game.players[event.player_index];
	PrintToDiscord(":warning: **" .. p.name .. "** kicked.");
end
local function on_player_unbanned(event)
	PrintToDiscord(":warning: **" .. event.player_name .. "** unbanned.");
end
local function on_player_unmuted(event)
	local p = game.players[event.player_index];
	PrintToDiscord(":warning: **" .. p.name .. "** unmuted.");
end
local function on_player_banned(event)
	PrintToDiscord(":warning: **" .. event.player_name .. "** banned.");
end
local function on_player_muted(event)
	local p = game.players[event.player_index];
	PrintToDiscord(":warning: **" .. p.name .. "** muted.");
end

local function checkEvolution(e)
	PrintToDiscord(":biohazard: Evolution: " .. string.format("%.4f", game.forces["enemy"].evolution_factor))
end

local logging = {}
logging.events = {
	[defines.events.on_research_finished] = on_research_finished,
	[defines.events.on_player_joined_game] = on_player_joined_game,
	[defines.events.on_player_left_game] = on_player_left_game,
	[defines.events.on_player_died] = on_player_died,
	[defines.events.on_player_kicked] = on_player_kicked,
	[defines.events.on_player_muted] = on_player_muted,
	[defines.events.on_player_unmuted] = on_player_unmuted,
	[defines.events.on_player_banned] = on_player_banned,
	[defines.events.on_player_unbanned] = on_player_unbanned,
	[defines.events.on_console_chat] = on_console_chat,
}

logging.on_nth_tick = {
	[60*60*15] = checkEvolution, -- Every 15 minutes
}

return logging