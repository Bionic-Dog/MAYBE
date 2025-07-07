--to think they took it down literally the day i was about to donate a shitton of money to the ko-fi dude :sob:

maxArrow = 2.5e4

--Incantation.DelayStacking = Incantation.DelayStacking + 5

local maxfloat = 1.7976931348623157e308

local function checkerboard_text(txt)
	local str = ''
	local chars = jl.string_to_table(txt)
	local osc = false
	for i = 1, #chars do
		osc = not osc
		str = str .. '{X:' .. (osc and 'black' or 'inactive') .. ',C:' .. (osc and 'white' or 'black') .. '}' .. chars[i]
		if i == #chars then
			str = str .. '{}'
		end
	end
	return str
end


local edited_default_colours = false
SMODS.current_mod.optional_features = {
	retrigger_joker = true,
	post_trigger = true,
}

--COMMON STRINGS
local mayoverflow = '{C:inactive,s:0.65}(Does not require room, but may overflow)'
local redeemprev = '{s:0.75}Also redeems {C:attention,s:0.75}previous tier for free{s:0.75} if not yet acquired'

--INITIAL STUFF

local CFG = SMODS.current_mod.config

SMODS.Atlas {
	key = "modicon",
	path = "maybe_avatar.png",
	px = 34,
	py = 34
}



May = {
	config = {
		texture_pack = 'default',
		show_credits = true,
		show_captions = true,
		show_lore = true,
		shop_size_buff = 3,
		shop_voucher_count_buff = 2,
		shop_booster_pack_count_buff = 2,
		consumable_slot_count_buff = 18,
		suit_leveling = {
			Hearts = {
				chips = 1,
				mult = 5
			},
			Clubs = {
				chips = 5,
				mult = 1
			},
			Diamonds = {
				chips = 2,
				mult = 4
			},
			Spades = {
				chips = 4,
				mult = 2
			}
		},
		rank_leveling = {
			['2'] = {
				chips = 13,
				mult = 1
			},
			['3'] = {
				chips = 12,
				mult = 1
			},
			['4'] = {
				chips = 11,
				mult = 1
			},
			['5'] = {
				chips = 10,
				mult = 2
			},
			['6'] = {
				chips = 9,
				mult = 2
			},
			['7'] = {
				chips = 8,
				mult = 2
			},
			['8'] = {
				chips = 7,
				mult = 3
			},
			['9'] = {
				chips = 6,
				mult = 3
			},
			['10'] = {
				chips = 5,
				mult = 3
			},
			Jack = {
				chips = 4,
				mult = 4
			},
			Queen = {
				chips = 3,
				mult = 5
			},
			King = {
				chips = 2,
				mult = 6
			},
			Ace = {
				chips = 25,
				mult = 7
			},
		},
	},
}

local function faceart(artist)
	return (May.config.texture_pack == 'default' and May.config.show_credits) and ('{C:dark_edition,s:0.7,E:2}Floating sprite by : ' .. artist) or ''
end

local function origin(world)
	return (May.config.texture_pack == 'default' and May.config.show_credits) and ('{C:cry_exotic,s:0.7,E:2}Origin : ' .. world)
end

local function au(world)
	return (May.config.texture_pack == 'default' and May.config.show_credits) and ('{C:cry_blossom,s:0.7,E:2}A.U. : ' .. world)
end

local function spriter(artist)
	return (May.config.texture_pack == 'default' and May.config.show_credits) and ('{C:dark_edition,s:0.7,E:2}Sprite by : ' .. artist)
end

local function caption(cap)
	return May.config.show_captions and ('{C:caption,s:0.7,E:1}' .. cap) or ''
end

local function lore(txt)
	return May.config.show_lore and ('{C:lore,s:0.7,E:2}' .. txt) or ''
end



if May.config.HQ_vanillashaders then
    local background_shader = NFS.read(SMODS.current_mod.path..'assets/shaders/background.fs')
    local splash_shader = NFS.read(SMODS.current_mod.path..'assets/shaders/splash.fs')
    local flame_shader = NFS.read(SMODS.current_mod.path..'assets/shaders/flame.fs')
    G.SHADERS['background'] = love.graphics.newShader(background_shader)
    G.SHADERS['splash'] = love.graphics.newShader(splash_shader)
    G.SHADERS['flame'] = love.graphics.newShader(flame_shader)
end

local evalcard_ref = eval_card
function eval_card(card, context)
	if card.playing_card and jl.sc(context) then
		if card.edition and card.edition.jen_wee then
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_upgrade_ex'), colour = G.C.FILTER})
			card.ability.wee_upgrades = (card.ability.wee_upgrades or 0) + (G.GAME.weeck and 3 or 1)
			card.ability.perma_bonus = (card.ability.perma_bonus or 0) + ((((card.ability.name or '') == 'Stone Card' or card.config.center.no_rank) and 25 or card:get_id() == 2 and 60 or (card:get_id() * 3)) * (G.GAME.weeck and 3 or 1))
			card_eval_status_text(card, 'extra', nil, nil, nil, {message = number_format(card.ability.perma_bonus), colour = G.C.CHIPS})
		end
		if card.gc and card:gc().set == 'Colour' and May.hv('colour', 1) then
			trigger_colour_end_of_round(card)
		end
	end
	return evalcard_ref(card, context)
end

local function calculate_scalefactor(text)
	local size = 0.9
	local font = G.LANG.font
	local max_text_width = 2 - 2 * 0.05 - 4 * 0.03 * size - 2 * 0.03
	local calced_text_width = 0
	for _, c in utf8.chars(text) do
		local tx = font.FONT:getWidth(c) * (0.33 * size) * G.TILESCALE * font.FONTSCALE + 2.7 * 1 * G.TILESCALE * font.FONTSCALE
		calced_text_width = calced_text_width + tx / (G.TILESIZE * G.TILESCALE)
	end
	local scale_fac = calced_text_width > max_text_width and max_text_width / calced_text_width or 1
	return scale_fac
end

--borrowed from older version of cryptid
local smcmb = SMODS.create_mod_badges
function SMODS.create_mod_badges(obj, badges)
	smcmb(obj, badges)
	if obj and obj.misc_badge then
		local scale_fac = {}
		local scale_fac_len = 1
		if obj.misc_badge and obj.misc_badge.text then
			for i = 1, #obj.misc_badge.text do
				local calced_scale = calculate_scalefactor(obj.misc_badge.text[i])
				scale_fac[i] = calced_scale
				scale_fac_len = math.min(scale_fac_len, calced_scale)
			end
		end
		local ct = {}
		for i = 1, #obj.misc_badge.text do
			ct[i] = {
				string = obj.misc_badge.text[i]
			}
		end
		badges[#badges + 1] = {
			n = G.UIT.R,
			config = { align = "cm" },
			nodes = {
				{
					n = G.UIT.R,
					config = {
						align = "cm",
						colour = obj.misc_badge and obj.misc_badge.colour or G.C.RED,
						r = 0.1,
						minw = 2/scale_fac_len,
						minh = 0.36,
						emboss = 0.05,
						padding = 0.03 * 0.9,
					},
					nodes = {
						{ n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
						{
							n = G.UIT.O,
							config = {
								object = DynaText({
									string = ct or "ERROR",
									colours = { obj.misc_badge and obj.misc_badge.text_colour or G.C.WHITE },
									silent = true,
									float = true,
									shadow = true,
									offset_y = -0.03,
									spacing = 1,
									scale = 0.33 * 0.9,
								}),
							},
						},
						{ n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
					},
				},
			},
		}
	end
	
end

--https://gist.github.com/efrederickson/4080372
local map = { 
    I = 1,
    V = 5,
    X = 10,
    L = 50,
    C = 100, 
    D = 500, 
    M = 1000,
}
local numbers_roman = { 1, 5, 10, 50, 100, 500, 1000 }
local chars_roman = { "I", "V", "X", "L", "C", "D", "M" }
function roman(s)
    s = tonumber(s)
    if not s or s ~= s then error"Unable to convert to number" end
    if s == math.huge then error"Unable to convert infinity" end
    s = math.floor(s)
    if s <= 0 then return s end
	local ret = ""
        for i = #numbers_roman, 1, -1 do
        local num = numbers_roman[i]
        while s - num >= 0 and s > 0 do
            ret = ret .. chars_roman[i]
            s = s - num
        end
        --for j = i - 1, 1, -1 do
        for j = 1, i - 1 do
            local n2 = numbers_roman[j]
            if s - (num - n2) >= 0 and s < num and s > 0 and num - n2 ~= n2 then
                ret = ret .. chars_roman[j] .. chars_roman[i]
                s = s - (num - n2)
                break
            end
        end
    end
    return ret
end
function unroman(s)
    s = s:upper()
    local ret = 0
    local i = 1
    while i <= s:len() do
        local c = s:sub(i, i)
        if c ~= " " then
            local m = map[c] or error("Unknown Roman Numeral '" .. c .. "'")
            
            local next = s:sub(i + 1, i + 1)
            local nextm = map[next]
            
            if next and nextm then
                if nextm > m then 
                    ret = ret + (nextm - m)
                    i = i + 1
                else
                    ret = ret + m
                end
            else
                ret = ret + m
            end
        end
        i = i + 1
    end
    return ret
end

local function hsv(h, s, v)
    if s <= 0 then return v,v,v end
    h = h*6
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0, 0, 0
    if h < 1 then
        r, g, b = c, x, 0
    elseif h < 2 then
        r, g, b = x, c, 0
    elseif h < 3 then
        r, g, b = 0, c, x
    elseif h < 4 then
        r, g, b = 0, x, c
    elseif h < 5 then
        r, g, b = x, 0, c
    else
        r, g, b = c, 0, x
    end
    return r+m, g+m, b+m
end

function manage_level_colour(level, force)
	local new_colour = G.C.WHITE
	level = to_big(level)
	if not G.C.HAND_LEVELS[number_format(level)] or force then 
		if level >= to_big(1e300) ^ 16 then
			new_colour = G.C.jen_RGB
		elseif level >= to_big(1e200) ^ 8 then
			new_colour = G.C.CRY_ASCENDANT
		elseif level >= to_big(1e150) ^ 4 then
			new_colour = G.C.CRY_VERDANT
		elseif level >= to_big(1e110) ^ 2 then
			new_colour = G.C.CRY_TWILIGHT
		elseif level >= to_big(1e75) ^ 1.5 then
			new_colour = G.C.CRY_EMBER
		elseif level >= to_big(1e40) ^ 1.25 then
			new_colour = G.C.CRY_AZURE
		elseif level >= to_big(1e30) ^ 1.125 then
			new_colour = G.C.CRY_BLOSSOM
		elseif level >= to_big(1e20) then
			new_colour = G.C.CRY_EXOTIC
		elseif level >= to_big(1e10) then
			new_colour = G.C.EDITION
		elseif level > to_big(7200) then
			new_colour = G.C.DARK_EDITION
		elseif level >= to_big(1) then
			local lv_num = to_number(level)
			local r, g, b = hsv(0.05 * lv_num, 0.05 * math.ceil(lv_num / 360), 1)
			local r2, g2, b2 = hsv(0.05 * lv_num, 0.05 * math.ceil(lv_num / 360), 0.05 * math.ceil(lv_num / 360))
			new_colour = {r, b, g, 1}
			if not G.C.HAND_LEVELS['!' .. number_format(level)] then G.C.HAND_LEVELS['!' .. number_format(level)] = {r2, b2, g2, 1} end
		end
		G.C.HAND_LEVELS[number_format(level)] = new_colour
	end
	if #G.C.HAND_LEVELS > 1e4 and G.GAME then
		local colours_still_in_use = {}
		for k, v in pairs(G.GAME.hands) do
			local str = number_format(to_big(v.level))
			if G.C.HAND_LEVELS[str] then
				colours_still_in_use[str] = true
			end
		end
		for k, v in pairs(G.GAME.ranks) do
			local str = number_format(to_big(v.level))
			if G.C.HAND_LEVELS[str] then
				colours_still_in_use[str] = true
			end
		end
		for k, v in pairs(G.GAME.suits) do
			local str = number_format(to_big(v.level))
			if G.C.HAND_LEVELS[str] then
				colours_still_in_use[str] = true
			end
		end
		for k, v in pairs(G.C.HAND_LEVELS) do
			if not colours_still_in_use[k] and k ~= '0' and k ~= '1' and k ~= '2' and k ~= '3' and k ~= '4' and k ~= '5' and k ~= '6' and k ~= '7' then
				G.C.HAND_LEVELS[k] = nil
			end
		end
	end
	return new_colour
end



function May.hiddencard(card)
	if type(card) ~= 'table' then return false end
	if not G.GAME then return false end
	return (((card.name or '') == 'Black Hole' or (card.name or '') == 'The Soul' or card.hidden) and not G.GAME.obsidian) or card.hidden2
end

function May.overpowered(rarity)
	if type(rarity) == 'number' then return false end
	return jl.bf(rarity, May.overpowered_rarities)
end

function Card:speak(text, col)
	if type(text) == 'table' then text = text[math.random(#text)] end
	card_eval_status_text(self, 'extra', nil, nil, nil, {message = text, colour = col or G.C.FILTER})
end

local random_editions = {
	'foil',
	'holo',
	'polychrome',
	'jen_chromatic',
	'jen_polygloss',
	'jen_gilded',
	'jen_sequin',
	'jen_laminated',
	'jen_ink',
	'jen_prismatic',
	'jen_watered',
	'jen_sepia',
	'jen_reversed',
	'jen_diplopia',
	'cry_gold',
	'cry_mosaic',
	'cry_oversat',
	'cry_astral',
	'cry_blur',
	'may_forgotten',
	'may_investment'
}

SMODS.Sound({key = 'blink', path = 'blink.ogg'})



local card_draw_ref = Card.draw
function Card:draw(layer)
	local CEN = self.gc and self:gc()
	if CEN then
		self.was_in_pack_area = G.pack_cards and self.area and self.area == G.pack_cards
		if (self.facing or '') == 'front' then
			if self.config then
				
				--WHEN JOHN FUCKING BLINKS:tm:

				if CEN.key == 'j_may_john' and math.random(200) == 1 then
					self.john_glitch = math.random(10, 20)
					if self.children then
						--print('plink')
						play_sound('button', 4, 0.125)
						if self.children.center then
							self.children.center:set_sprite_pos({x = 0, y = 1})
						end
						if self.children.floating_sprite then
							self.children.floating_sprite:set_sprite_pos({x = 1, y = 1})
						end
					end
				elseif self.john_glitch then
					if self.john_glitch <= 1 then
						if self.children then
							if self.children.center then
								self.children.center:set_sprite_pos({x = 0, y = 0})
							end
							if self.children.floating_sprite then
								self.children.floating_sprite:set_sprite_pos({x = 1, y = 0})
							end
						end
						self.john_glitch = nil
					else
						self.john_glitch = self.john_glitch - 1
					end
				end
				if not self.john_glitch == nil then
					if self.john_glitch > 0  then
					self.john_blink = true
					else
						self.john_blink = false
					end
				end

			end
		end
	end
	CEN = nil
    card_draw_ref(self, layer)
end

if not IncantationAddons then
	IncantationAddons = {
		Stacking = {},
		Dividing = {},
		BulkUse = {},
		StackingIndividual = {},
		DividingIndividual = {},
		BulkUseIndividual = {}
	}
end

if not AurinkoAddons then
	AurinkoAddons = {}
end


G.FUNCS.isomeganumenabled = function(e)
	if Big and Big.arrow then
		return true
	end
	return false
end

local function play_sound_q(sound, per, vol)
	G.E_MANAGER:add_event(Event({
		func = function()
			play_sound(sound,per,vol)
			return true
		end
	}))
end

local final_operations = {
	[-2] = {'/', 'IMPORTANT'},
	[-1] = {'-', 'GREY'},
	[0] = {'+', 'UI_CHIPS'},
	[1] = {'X', 'UI_MULT'},
	[2] = {'^', {0.8, 0.45, 0.85, 1}},
	[3] = {'^^', 'DARK_EDITION'},
	[4] = {'^^^', 'CRY_EXOTIC'},
	[5] = {'^^^^', 'CRY_EMBER'},
	[6] = {'^^^^^', 'CRY_ASCENDANT'},
}

local sumcache_limit = 100

local chipmult_sum_cache = {}

function get_chipmult_sum(chips, mult)
	chips = chips or 0
	mult = mult or 0
	if #chipmult_sum_cache > sumcache_limit then
		for i = 1, sumcache_limit do
			table.remove(chipmult_sum_cache)
		end
	end
	local op = get_final_operator()
	if to_big(chips) == to_big(0) or to_big(mult) == to_big(0) then
		chips = 0
		mult = 0
		op = 0
	end
	local sum
	for k, v in ipairs(chipmult_sum_cache) do
		if v.oper == op and v.c == to_big(chips) and v.m == to_big(mult) then
			return v.result
		end
	end
	if op > 2 then
		sum = to_big(chips):arrow(math.min(maxArrow, op - 1), to_big(mult))
	elseif op == 2 then
		sum = to_big(chips) ^ to_big(mult)
	elseif op == 1 then
		sum = to_big(chips) * to_big(mult)
	elseif op == -1 then
		sum = to_big(chips) - to_big(mult)
	elseif op <= -2 then
		sum = to_big(chips) / to_big(mult)
	else
		sum = to_big(chips) + to_big(mult)
	end
	table.insert(chipmult_sum_cache, {oper = op, c = chips, m = mult, result = sum})
	return sum
end

function update_operator_display()
	local op = get_final_operator()
	local txt = ''
	local col = G.C.WHITE
	if not final_operations[op] then
		txt = '{' .. number_format(op-1) .. '}'
		col = G.C.may_RGB
	else
		txt = final_operations[op][1]
		col = type(final_operations[op][2]) == 'table' and final_operations[op][2] or G.C[final_operations[op][2]]
	end
	Q(function()
		play_sound('button', 1.1, 0.65)
		G.hand_text_area.op.config.text = txt
		G.hand_text_area.op.config.text_drawable:set(txt)
		G.hand_text_area.op.UIBox:recalculate()
		G.hand_text_area.op.config.colour = col
		G.hand_text_area.op:juice_up(0.8, 0.5)
	return true end)
end

function update_operator_display_custom(txt, col)
	Q(function()
		play_sound('button', 1.1, 0.65)
		G.hand_text_area.op.config.text = txt
		G.hand_text_area.op.config.text_drawable:set(txt)
		G.hand_text_area.op.UIBox:recalculate()
		G.hand_text_area.op.config.colour = (col or G.C.UI_MULT)
		G.hand_text_area.op:juice_up(0.8, 0.5)
	return true end)
end

function get_final_operator_offset()
	if not G.GAME then return 0 end
	if not G.GAME.finaloperator then G.GAME.finaloperator = 1 end
	if not G.GAME.finaloperator_offset then G.GAME.finaloperator_offset = 0 end
	return math.max(-1, G.GAME.finaloperator_offset)
end

function get_final_operator(absolute)
	if not G.GAME then return 0 end
	if not G.GAME.finaloperator then G.GAME.finaloperator = 1 end
	if not G.GAME.finaloperator_offset then G.GAME.finaloperator_offset = 0 end
	return math.max(0, math.min(maxArrow + 1, G.GAME.finaloperator + (absolute and 0 or get_final_operator_offset())))
end

function set_final_operator(value)
	G.GAME.finaloperator = math.min(math.max(value, 0), maxArrow + 1)
	update_operator_display()
end

function set_final_operator_offset(value)
	G.GAME.finaloperator_offset = math.min(math.max(value, -1), maxArrow)
	update_operator_display()
end

function change_final_operator(mod)
	set_final_operator(get_final_operator(true) + mod)
end

function offset_final_operator(mod)
	set_final_operator_offset(get_final_operator_offset() + mod)
end

function set_dollars(mod)
	mod = to_big(mod or 0)
	Q(function()
		local dollar_UI = G.HUD:get_UIE_by_ID('dollar_text_UI')
		local text = '='..localize('$')
		local col = G.C.FILTER
        G.GAME.dollars = mod
        dollar_UI.config.object:update()
        G.HUD:recalculate()
        attention_text({
          text = text..number_format(mod),
          scale = 0.8, 
          hold = 0.7,
          cover = dollar_UI.parent,
          cover_colour = col,
          align = 'cm',
          })
        play_sound('coin1')
	return true end)
end

local edr = ease_dollars
function ease_dollars(mod, instant, force_update)
	if to_big((G.GAME.dollars + mod ~= G.GAME.dollars and math.abs(mod))) > to_big((G.GAME.dollars / 1e6)) or force_update then
		edr(mod,instant)
		local should_clamp = jl.invalid_number(number_format(G.GAME.dollars)) or to_big(G.GAME.dollars) > to_big(1e100) or to_big(G.GAME.dollars) < to_big(-1e100)
		if should_clamp then
			G.GAME.dollars = jl.invalid_number(number_format(G.GAME.dollars)) and to_big(1e100) or to_big(math.min(math.max(G.GAME.dollars, -1e100), 1e100))
			ease_dollars(0, true, true)
		end
	end
end

local function change_blind_size(newsize, instant, silent)
	newsize = to_big(newsize)
	G.GAME.blind.chips = newsize
	local chips_UI = G.hand_text_area.blind_chips
	if instant then
		G.GAME.blind.chip_text = number_format(newsize)
		G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips)
		G.HUD_blind:recalculate() 
		chips_UI:juice_up()
		if not silent then play_sound('chips2') end
	else
		G.E_MANAGER:add_event(Event({func = function()
			G.GAME.blind.chip_text = number_format(newsize)
			G.FUNCS.blind_chip_UI_scale(G.hand_text_area.blind_chips)
			G.HUD_blind:recalculate() 
			chips_UI:juice_up()
			if not silent then play_sound('chips2') end
		return true end }))
	end
end

function card_status_text(card, text, xoffset, yoffset, colour, size, DELAY, juice, jiggle, align, sound, volume, pitch, trig, F)
	if (DELAY or 0) <= 0 then
		if F and type(F) == 'function' then F(card) end
		attention_text({
			text = text,
			scale = size or 1, 
			hold = 0.7,
			backdrop_colour = colour or (G.C.FILTER),
			align = align or 'bm',
			major = card,
			offset = {x = xoffset or 0, y = yoffset or (-0.05*G.CARD_H)}
		})
		if sound then
			play_sound(sound, pitch or (0.9 + (0.2*math.random())), volume or 1)
		end
		if juice then
			if type(juice) == 'table' then
				card:juice_up(juice[1], juice[2])
			elseif type(juice) == 'number' and juice ~= 0 then
				card:juice_up(juice, juice / 6)
			end
		end
		if jiggle then
			G.ROOM.jiggle = G.ROOM.jiggle + jiggle
		end
	else
		G.E_MANAGER:add_event(Event({
			trigger = trig,
			delay = DELAY,
			func = function()
				if F and type(F) == 'function' then F(card) end
				attention_text({
					text = text,
					scale = size or 1, 
					hold = 0.7 + (DELAY or 0),
					backdrop_colour = colour or (G.C.FILTER),
					align = align or 'bm',
					major = card,
					offset = {x = xoffset or 0, y = yoffset or (-0.05*G.CARD_H)}
				})
				if sound then
					play_sound(sound, pitch or (0.9 + (0.2*math.random())), volume or 1)
				end
				if juice then
					if type(juice) == 'table' then
						card:juice_up(juice[1], juice[2])
					elseif type(juice) == 'number' and juice ~= 0 then
						card:juice_up(juice, juice / 6)
					end
				end
				if jiggle then
					G.ROOM.jiggle = G.ROOM.jiggle + jiggle
				end
				return true
			end
		}))
	end
end

local cacsr = CardArea.change_size
function CardArea:change_size(mod, silent)
	cacsr(self, mod)
	if not silent then self:announce_sizechange(mod) end
end

function CardArea:announce_sizechange(mod, set)
	if (mod or 0) ~= 0 then
		G.E_MANAGER:add_event(Event({
			trigger = 'immediate',
			func = function()
				mod = mod or 0
				local text = 'Max +'
				local col = G.C.GREEN
				if set then
					text = 'Max ='
					col = G.C.FILTER
				elseif mod < 0 then
					text = 'Max -'
					col = G.C.RED
				end
				attention_text({
					text = text..tostring(math.abs(mod)),
					scale = 1, 
					hold = 1,
					cover = self,
					cover_colour = col,
					align = 'cm',
				})
				play_sound('highlight2', 0.715, 0.2)
				play_sound('generic1')
				return true
			end
		}))
		delay(0.5)
	end
end

function CardArea:change_size_absolute(mod, silent)
	self.config.card_limit = self.config.card_limit + (mod or 0)
	if not silent then self:announce_sizechange(mod) end
end

function CardArea:set_size_absolute(mod, silent)
	self.config.card_limit = (mod or self.config.card_limit)
	if not silent then self:announce_sizechange(mod, true) end
end

function CardArea:announce_highlightchange(mod)
	if (mod or 0) ~= 0 then
		G.E_MANAGER:add_event(Event({
			trigger = 'immediate',
			func = function()
				mod = mod or 0
				local text = 'Highlights +'
				local col = G.C.PURPLE
				if mod < 0 then
					text = 'Highlights -'
					col = G.C.FILTER
				end
				attention_text({
					text = text..tostring(math.abs(mod)),
					scale = 1, 
					hold = 1,
					cover = self,
					cover_colour = col,
					align = 'cm',
				})
				play_sound('highlight2', 0.715, 0.2)
				play_sound('generic1')
				return true
			end
		}))
		delay(0.5)
	end
end

function CardArea:change_max_highlight(mod, silent)
	self.config.highlighted_limit = self.config.highlighted_limit + (mod or 0)
	if not silent then self:announce_highlightchange(mod) end
end

function ease_winante(mod)
	G.E_MANAGER:add_event(Event({
		trigger = 'immediate',
		func = function()
			local ante_UI = G.hand_text_area.ante
			mod = mod or 0
			local text = 'Max'
			local col = G.C.PURPLE
			if mod < 0 then
				text = text .. ' -'
				col = G.C.GREEN
			else
				text = text .. ' +'
			end
			ante_UI.config.object:update()
			G.GAME.win_ante=G.GAME.win_ante+mod
			G.HUD:recalculate()
			attention_text({
				text = text..tostring(math.abs(mod)),
				scale = 0.6, 
				hold = 0.9,
				cover = ante_UI.parent,
				cover_colour = col,
				align = 'cm',
			})
			play_sound('highlight2', 0.4, 0.2)
			play_sound('generic1')
			return true
		end
	}))
end



local function multante(number)
	--local targetante = math.abs(G.GAME.round_resets.ante * (2 ^ (number or 1)))
	if G.GAME.round_resets.ante < 1 then
		ease_ante(math.abs(G.GAME.round_resets.ante) + 1)
	else
		ease_ante(math.min(1e308, G.GAME.round_resets.ante * (2 ^ (number or 1)) - G.GAME.round_resets.ante))
	end
	--[[if G.GAME.win_ante < targetante then
		G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.1, func = function()
			ease_winante(targetante - G.GAME.win_ante)
		return true end }))
	end]]
end

local function hsv(h, s, v)
    if s <= 0 then return v,v,v end
    h = h*6
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0, 0, 0
    if h < 1 then
        r, g, b = c, x, 0
    elseif h < 2 then
        r, g, b = x, c, 0
    elseif h < 3 then
        r, g, b = 0, c, x
    elseif h < 4 then
        r, g, b = 0, x, c
    elseif h < 5 then
        r, g, b = x, 0, c
    else
        r, g, b = c, 0, x
    end
    return r+m, g+m, b+m
end

local misc_done = false

local game_updateref = Game.update
function Game:update(dt)
	
	game_updateref(self, dt)
	if G.GAME then
		if G.GAME.modifiers then
			if not G.GAME.modifiers.may_initialise_buffs then
				G.GAME.modifiers.may_initialise_buffs = true
				G.GAME.modifiers.cry_booster_packs = (G.GAME.modifiers.cry_booster_packs or 2) + May.config.shop_booster_pack_count_buff
				change_shop_size(May.config.shop_size_buff)
				SMODS.change_voucher_limit(May.config.shop_voucher_count_buff)
			end
		end
	end
	if G.GAME then
		
		May.john_active = #SMODS.find_card('j_may_john') > 0
		
	end
end

local secret = {
	colour = G.C.BLACK,
	text_colour = G.C.EDITION,
	text = {
		'Secret'
	}
}

local milliefriend = {
	colour = HEX('ff8800'),
	text_colour = G.C.WHITE,
	text = {
		'Friends of Millie Series'
	}
}

--MISCELLANEOUS

local function abletouseabilities()
	return jl.canuse() and not jl.booster()
end

--CONSUMABLE TYPES



local shaders = {
	'forgotten',
	'forgottenv2',
	'investment',
}


for k, v in pairs(shaders) do
	SMODS.Shader({key = v, path = v .. '.fs'})
	SMODS.Sound({key = 'e_' .. v, path = 'e_' .. v .. '.ogg'})
end

local cs = Card.calculate_seal
function Card:calculate_seal(context)
	local tbl = cs(self, context)
	if tbl then
		if context.repetition and ((self.ability or {}).set or 'Joker') ~= 'Joker' then
			if self.edition then
				if self.edition.retriggers then
					tbl.repetitions = (tbl.repetitions or 0) + self.edition.retriggers
					tbl.message = tbl.message or localize('k_again_ex')
					tbl.card = tbl.card or self
					return {
						message = localize('k_again_ex'),
						repetitions = self.edition.retriggers,
						card = self
					}
				end
			end
		end
		return tbl
	end
end

--JOKER ATLASES
local atlases = {
	--'mesa',
	'gluttony',
	'guhadeen',
	'yatta',
	'shareholders',
	'shower',
	'sacrificial',
	'john',
	'sally',
	'robotmaster',
	'asabove',
	'hemispheres',
	'gigi',
	'capsulejoker',
}

for k, v in pairs(atlases) do
	SMODS.Atlas {
		key = 'may' .. v,
		px = 71,
		py = 95,
		path = May.config.texture_pack .. '/j_may_' .. v .. '.png'
	}
end


local function faceinplay()
	if not G.play then return 0 end
	if not G.play.cards then return 0 end
	local qty = 0
	for k, v in pairs(G.play.cards) do
		if v:is_face() then qty = qty + 1 end
	end
	return qty
end



-- MY NEW SHIT YEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA


SMODS.Atlas {
	key = 'mayacc2',
	px = 71,
	py = 95,
	path = May.config.texture_pack .. '/c_may_acc2.png'
}

SMODS.Atlas {
	key = 'maygacha',
	px = 71,
	py = 95,
	path = May.config.texture_pack .. '/c_may_gachapons.png'
}

SMODS.Atlas {
	key = 'maygacha2',
	px = 71,
	py = 95,
	path = May.config.texture_pack .. '/c_may_extragachapons.png'
}

--EDITIONS

SMODS.Edition({
    key = "forgotten",
    loc_txt = {
        name = "Forgotten",
        label = "Forgotten",
        text = {
            "{C:attention}Reduce{} the size of the {C:attention}current Blind",
            "by {C:attention}4%{} when this card scores or is triggered",
			'{C:dark_edition,s:0.7,E:2}Shader by : idfk lol'
        }
    },
    discovered = true,
    unlocked = true,
    shader = 'forgottenv2',
    config = {chips = -25, mult = 33},
	sound = {
		sound = 'may_e_forgotten',
		per = 1,
		vol = 0.6
	},
    in_shop = true,
    weight = 8,
    extra_cost = 2,
    apply_to_float = false,
    loc_vars = function(self)
        return {vars = {self.config.chips, self.config.mult}}
    end,
	calculate = function(self, card, context)
		if context.edition and context.cardarea == G.jokers and context.joker_main then
			if (G.SETTINGS.FASTFORWARD or 0) < 1 and (G.SETTINGS.STATUSTEXT or 0) < 2 then
					card_status_text(card, '-4% Blind Size', nil, 0.05*card.T.h, G.C.FILTER, 0.75, 1, 0.6, nil, 'bm', 'generic1')
				end
				change_blind_size(to_big(G.GAME.blind.chips) / to_big(1.04), (G.SETTINGS.FASTFORWARD or 0) > 1, (G.SETTINGS.FASTFORWARD or 0) > 1)
				return nil, true
		end
		if context.cardarea == G.play and context.main_scoring then
			if (G.SETTINGS.FASTFORWARD or 0) < 1 and (G.SETTINGS.STATUSTEXT or 0) < 2 then
					card_status_text(card, '-4% Blind Size', nil, 0.05*card.T.h, G.C.FILTER, 0.75, 1, 0.6, nil, 'bm', 'generic1')
				end
				change_blind_size(to_big(G.GAME.blind.chips) / to_big(1.04), (G.SETTINGS.FASTFORWARD or 0) > 1, (G.SETTINGS.FASTFORWARD or 0) > 1)
				return nil, true
		end
	end
})

SMODS.Edition({
    key = "investment",
    loc_txt = {
        name = "Investment",
        label = "Investment",
        text = {
            "Grants {X:money,C:white}x1.2{} upon",
            "scoring or being triggered",
			"{C:inactive,s:0.8}(will currently give +{}{C:money,s:0.8}$#1#{}{C:inactive,s:0.8}){}",
			'{C:dark_edition,s:0.7,E:2}Shader by :',
			'{C:dark_edition,s:0.7,E:2}stupxd, modified by MillieAmp',
        }
    },
    discovered = true,
    unlocked = true,
    shader = 'investment',
    config = {chips = -25, mult = 33},
	sound = {
		sound = 'may_e_investment',
		per = 1,
		vol = 0.6
	},
    in_shop = true,
    weight = 8,
    extra_cost = 2,
    apply_to_float = false,
    loc_vars = function(self, info_queue, center)
        return {vars = {((G.GAME or {}).dollars or 0) * 0.25}}
    end,
	calculate = function(self, card, context)
		if context.edition and context.cardarea == G.jokers and context.joker_main then
			if (G.SETTINGS.FASTFORWARD or 0) < 1 and (G.SETTINGS.STATUSTEXT or 0) < 2 then
					card_status_text(card, 'Cha-ching!', nil, 0.05*card.T.h, G.C.FILTER, 0.75, 1, 0.6, nil, 'bm', 'generic1')
				end
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
						ease_dollars(G.GAME.dollars * 0.2)
					return true
				end}))
				
				return nil, true
		end
		if context.cardarea == G.play and context.main_scoring then
			if (G.SETTINGS.FASTFORWARD or 0) < 1 and (G.SETTINGS.STATUSTEXT or 0) < 2 then
					card_status_text(card, 'Cha-ching!', nil, 0.05*card.T.h, G.C.FILTER, 0.75, 1, 0.6, nil, 'bm', 'generic1')
				end
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
						ease_dollars(G.GAME.dollars * 0.2)
					return true
				end}))
				return nil, true
		end

		if context.using_consumeable then
			if (G.SETTINGS.FASTFORWARD or 0) < 1 and (G.SETTINGS.STATUSTEXT or 0) < 2 then
					card_status_text(card, 'Cha-ching!', nil, 0.05*card.T.h, G.C.FILTER, 0.75, 1, 0.6, nil, 'bm', 'generic1')
				end
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
						ease_dollars(G.GAME.dollars * 0.2)
					return true
				end}))
				return nil, true
		end
	end
})

--fiiiiine jen ill do my unos in my global file :|






--CONSUMABLES

--CAPSULES YAY
init_capsules = SMODS.load_file("other/capsules.lua")
init_capsules()

--UNOS YAY



--OTHER CONSUMABLES YAY
init_consumables = SMODS.load_file("other/consumables.lua")
init_consumables()


--JOKERS
init_jokers = SMODS.load_file("other/jokers.lua")
init_jokers()
init_legendary = SMODS.load_file("other/legendary.lua")
init_legendary()
init_exotic = SMODS.load_file("other/exotic.lua")
init_exotic()





--YEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

