

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

local function suit_to_uno(suit)
	suit = string.lower(suit)
	return suit == 'hearts' and 'red' or suit == 'spades' and 'blue' or suit == 'clubs' and 'green' or suit == 'diamonds' and 'yellow' or 'n/a'
end

function recalc_suitrank()
	SMODS.change_base(G.suitrank.card, G.suitrank.suit, G.suitrank.rank)
	G.suitrank.suitconfig.name = localize(G.suitrank.suit, 'suits_plural')
	G.suitrank.rankconfig.name = localize(G.suitrank.rank, 'ranks')
	for _, k in pairs({"color", "outline_color", "level_color", "text_color"}) do
		if not G.suitrank.suitconfig[k] then
			G.suitrank.suitconfig[k] = {}
		end
		if not G.suitrank.rankconfig[k] then
			G.suitrank.rankconfig[k] = {}
		end
	end
	for i = 1, 4 do
		G.suitrank.suitconfig.color[i] = G.C.SUITS[G.suitrank.suit][i]
		G.suitrank.suitconfig.outline_color[i] = darken(G.C.SUITS[G.suitrank.suit], 0.3)[i]
		G.suitrank.suitconfig.level_color[i] = G.C.HAND_LEVELS[number_format(G.GAME.suits[G.suitrank.suit].level)][i]
		G.suitrank.suitconfig.text_color[i] = lighten(G.C.SUITS[G.suitrank.suit], 0.6)[i]
		G.suitrank.rankconfig.color[i] = darken(G.C.SECONDARY_SET.Tarot, 0.3)[i]
		G.suitrank.rankconfig.outline_color[i] = darken(G.C.SECONDARY_SET.Tarot, 0.65)[i]
		G.suitrank.rankconfig.level_color[i] = G.C.HAND_LEVELS[number_format(G.GAME.ranks[G.suitrank.rank].level)][i]
		G.suitrank.rankconfig.text_color[i] = lighten(G.C.SECONDARY_SET.Tarot, 0.6)[i]
	end
	G.suitrank.suitconfig.level = localize('k_level_prefix')..number_format(G.GAME.suits[G.suitrank.suit].level)
	G.suitrank.suitconfig.count = jl.countsuit()[G.suitrank.suit] or 0
	G.suitrank.suitconfig.chips = "+"..number_format(G.GAME.suits[G.suitrank.suit].chips)
	G.suitrank.suitconfig.mult = "+"..number_format(G.GAME.suits[G.suitrank.suit].mult)
	G.suitrank.rankconfig.level = localize('k_level_prefix')..number_format(G.GAME.ranks[G.suitrank.rank].level)
	G.suitrank.rankconfig.count = jl.countrank()[G.suitrank.rank] or 0
	G.suitrank.rankconfig.chips = "+"..number_format(G.GAME.ranks[G.suitrank.rank].chips)
	G.suitrank.rankconfig.mult = "+"..number_format(G.GAME.ranks[G.suitrank.rank].mult)
end

local lurr = level_up_rank

function level_up_rank(card, rank, instant, amount, dontautoclear)
    amount = to_big(amount or 1)
	if not instant then
		update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=rank .. 's',chips = G.GAME.ranks[rank].chips, mult = G.GAME.ranks[rank].mult, level=G.GAME.ranks[rank].level})
	end
	if lurr then lurr(card, rank, instant, amount) end
    G.GAME.ranks[rank].level = math.max(G.GAME.ranks[rank].level + amount, 0)
    G.GAME.ranks[rank].chips = math.max(G.GAME.ranks[rank].chips + (G.GAME.ranks[rank].l_chips * amount), 0)
    G.GAME.ranks[rank].mult = math.max(G.GAME.ranks[rank].mult + (G.GAME.ranks[rank].l_mult * amount), 0)
	manage_level_colour(G.GAME.ranks[rank].level)
	if amount > to_big(0) then
		add_malice(15 * amount)
	end
    if not instant then
		if (G.SETTINGS.FASTFORWARD or 0) > 0 then
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
				play_sound('tarot1')
				if card then card:juice_up(0.8, 0.5) end
				G.TAROT_INTERRUPT_PULSE = true
				return true end }))
			update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {chips = G.GAME.ranks[rank].chips, mult = G.GAME.ranks[rank].mult, level=G.GAME.ranks[rank].level, StatusText = true})
		else
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
				play_sound('tarot1')
				if card then card:juice_up(0.8, 0.5) end
				G.TAROT_INTERRUPT_PULSE = true
				return true end }))
			update_hand_text({delay = 0}, {mult = G.GAME.ranks[rank].mult, StatusText = true})
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
				play_sound('tarot1')
				if card then card:juice_up(0.8, 0.5) end
				return true end }))
			update_hand_text({delay = 0}, {chips = G.GAME.ranks[rank].chips, StatusText = true})
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
				play_sound('tarot1')
				if card then card:juice_up(0.8, 0.5) end
				G.TAROT_INTERRUPT_PULSE = nil
				return true end }))
			update_hand_text({sound = 'button', volume = 0.7, pitch = 0.9, delay = 0}, {level=G.GAME.ranks[rank].level})
		end
        delay(1.3)
		if not dontautoclear then jl.ch() end
    end
end

local luhr = level_up_hand
function level_up_hand(card, hand, instant, amount, no_astronomy, no_astronomy_omega, no_jokers)
	amount = to_big(amount)
	if not no_astronomy and to_big(amount) > to_big(0) then
			if May.hv('astronomy', 9) then
				amount = amount * 5
			elseif May.hv('astronomy', 8) then
				amount = amount * 2
			end
		end
	if to_big(amount) > to_big(0) then
		if #SMODS.find_card('j_jen_guilduryn') > 0 and hand ~= jl.favhand() then
			for k, v in ipairs(G.jokers.cards) do
				if (G.SETTINGS.STATUSTEXT or 0) < 1 and v.gc and v:gc().key == 'j_jen_guilduryn' then
					card_eval_status_text(v, 'extra', nil, nil, nil, {message = 'Redirected!', colour = G.C.MONEY})
					break
				end
			end
			hand = jl.favhand()
			if not instant then
				jl.th(hand)
			end
		end
	end
	luhr(card, hand, instant, amount)
	if to_big(amount) > to_big(0) then
		add_malice(25 * amount)
	end
	manage_level_colour(G.GAME.hands[hand].level)
	if not no_jokers then
		jl.jokers({jen_lving = true, lvs = amount, lv_hand = hand, lv_instant = instant, card = card})
	end
	if to_big(amount) < to_big(0) and May.hv('astronomy', 11) and not no_astronomy then
	        local refund = math.abs(amount) / 4
	        local fav = jl.favhand()
	        if May.config.verbose_astronomicon then jl.th(fav) end
	        fastlv(card, fav, not May.config.verbose_astronomicon, refund, true)
	    end
	    if to_big(amount) > to_big(0) and May.hv('astronomy', 12) and not no_astronomy then
	        local dividend = amount / 10
	        local fav = jl.favhand()
	        if May.config.verbose_astronomicon then jl.th(fav) end
	        fastlv(card, fav, not May.config.verbose_astronomicon, dividend, true)
	    end
		if May.hv('astronomy', 13) and to_big(amount) >= to_big(1) and not no_astronomy_omega then
			local pos = jl.handpos(hand)
			--local edi = ((card or {}).edition or {}).key or 'e_base'
			--if edi == 'e_negative' then edi = 'e_base' end
			--if not a13_sum[edi] then a13_sum[edi] = {} end
			if G.handlist[pos + 1] then
				--if not astronomyomega_cumulative[G.handlist[pos + 1]] then astronomyomega_cumulative[G.handlist[pos + 1]] = 0 end
				if May.config.verbose_astronomicon_omega then jl.th(G.handlist[pos + 1]) end
				fastlv(card, G.handlist[pos + 1], not May.config.verbose_astronomicon_omega, amount / 2, true)
			end
		end
	--[[if card then
		if card.base then
			if card.base.value and G.GAME.ranks[card.base.value] and card.base.suit and G.GAME.suits[card.base.suit] then
				level_up_rank(card, card.base.value, instant, amount, true, true)
				level_up_suit(card, card.base.suit, instant, amount, true)
			end
		end
	end]]
end

SMODS.ConsumableType {
	key = 'may_uno',
	collection_rows = {7, 7, 7},
	primary_colour = G.C.CHIPS,
	secondary_colour = HEX('ff0000'),
	default = 'c_may_uno_null',
	loc_txt = {
		collection = 'UNO Cards',
		name = 'UNO'
	},
	shop_rate = 2
}

SMODS.Atlas {
	key = 'mayuno',
	px = 71,
	py = 95,
	path = May.config.texture_pack .. '/c_may_uno.png'
}

SMODS.Atlas {
	key = 'maybooster',
	px = 71,
	py = 95,
	path = May.config.texture_pack .. '/p_may_boosters.png'
}

SMODS.Atlas {
	key = 'maybuttons',
	px = 32,
	py = 32,
	path = May.config.texture_pack .. '/may_ui_buttons.png'
}


local uno_data = {
	values = {
		'2', '3', '4', '5', '6', '7', '8', '9', '10', 'Jack', 'Queen', 'King', 'Ace'
	},
	colours = {
		Red = 'Hearts',
		Blue = 'Spades',
		Green = 'Clubs',
		Yellow = 'Diamonds'
	}
}

SMODS.Consumable {
	key = 'uno_uno',
	loc_txt = {
		name = 'UNO',
		text = {
			'Level up {C:attention}all ranks',
			'and {C:hearts}s{C:spades}u{C:clubs}i{C:diamonds}t{C:attention}s{} by {C:attention}1',
			spriter('MillieAmp, based on sprites by maywalter666 and from the UNO game for the GBA')
		}
	},
	set = 'Spectral',
	pos = { x = 2, y = 4 },
	cost = 3,
	hidden = true,
	unlocked = true,
	discovered = true,
	soul_set = 'may_uno',
	soul_rate = .05,
	atlas = 'mayuno',
	ignore_kudaai = true,
	can_use = function(self, card)
		return jl.canuse()
	end,
	can_mass_use = true,
	use = function(self, card, area, copier)
		delay(1)
		play_sound_q('may_uno')
		jl.a('UNO!', 2, 1, G.C.MONEY)
		Q(function() if card then card:juice_up(0.8, 0.5) end return true end)
		delay(2)
		jl.h('All Ranks & Suits', '...', '...', '')
		delay(.5)
		if (G.SETTINGS.FASTFORWARD or 0) < 1 then
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
				play_sound('tarot1')
				if card then card:juice_up(0.8, 0.5) end
			return true end }))
			jl.hc('+', true)
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
				play_sound('tarot1')
				if card then card:juice_up(0.8, 0.5) end
			return true end }))
			jl.hm('+', true)
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
				play_sound('tarot1')
				if card then card:juice_up(0.8, 0.5) end
			return true end }))
			jl.hlv('+1')
			play_sound_q('button', 0.9, 0.7)
		else
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
				play_sound('tarot1')
				if card then card:juice_up(0.8, 0.5) end
			return true end }))
			jl.h('All Ranks & Suits', '+', '+', '+1', true)
		end
		delay(1)
		for a, b in ipairs(uno_data.values) do
			level_up_rank(card, b, true, 1)
		end
		for c, d in pairs(uno_data.colours) do
			level_up_suit(card, d, true, 1)
		end
		jl.ch()
	end,
	bulk_use = function(self, card, area, copier, number)
		delay(1)
		play_sound_q('may_uno')
		jl.a('UNO!', 2, 1, G.C.MONEY)
		Q(function() if card then card:juice_up(0.8, 0.5) end return true end)
		delay(2)
		jl.h('All Ranks & Suits', '...', '...', '')
		delay(.5)
		if (G.SETTINGS.FASTFORWARD or 0) < 1 then
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
				play_sound('tarot1')
				if card then card:juice_up(0.8, 0.5) end
			return true end }))
			jl.hc('+', true)
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
				play_sound('tarot1')
				if card then card:juice_up(0.8, 0.5) end
			return true end }))
			jl.hm('+', true)
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
				play_sound('tarot1')
				if card then card:juice_up(0.8, 0.5) end
			return true end }))
			jl.hlv('+' .. number)
			play_sound_q('button', 0.9, 0.7)
		else
			G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
				play_sound('tarot1')
				if card then card:juice_up(0.8, 0.5) end
			return true end }))
			jl.h('All Ranks & Suits', '+', '+', '+' .. number, true)
		end
		delay(1)
		for a, b in ipairs(uno_data.values) do
			level_up_rank(card, b, true, number)
		end
		for c, d in pairs(uno_data.colours) do
			level_up_suit(card, d, true, number)
		end
		jl.ch()
	end
}

for a, b in ipairs(uno_data.values) do
	for c, d in pairs(uno_data.colours) do
		SMODS.Consumable {
			key = 'uno_' .. string.lower(c) .. string.lower(b),
			loc_txt = {
				name = c .. ' ' .. b,
				text = {
					'Level up {C:attention}' .. b .. 's{} and {C:' .. string.lower(d) .. '}' .. d,
					'{C:attention}' .. b .. 's{C:inactive} | {V:1}lvl.#1#{} : {X:chips,C:white}+#2#{} & {X:mult,C:white}+#3#',
					'{C:' .. string.lower(d) .. '}' .. d .. '{C:inactive} | {V:2}lvl.#4#{} : {X:chips,C:white}+#5#{} & {X:mult,C:white}+#6#',
					spriter('MillieAmp, based on sprites by maywalter666')
				}
			},
			set = 'may_uno',
			pos = { x = (a - 1) % 10, y = (d == 'Hearts' and 0 or d == 'Spades' and 1 or d == 'Clubs' and 2 or d == 'Diamonds' and 3 or 0) + (a > 10 and 5 or 0) },
			cost = b == 'Ace' and 3 or 2,
			unlocked = true,
			discovered = true,
			atlas = 'mayuno',
			ignore_kudaai = true,
			can_mass_use = true,
			loc_vars = function(self, info_queue, center)
				if not G.GAME or not (G.GAME or {}).suits or not (G.GAME or {}).ranks then
					return {
						vars = {
							1,
							May.config.rank_leveling[b].chips,
							May.config.rank_leveling[b].mult,
							1,
							May.config.suit_leveling[d].chips,
							May.config.suit_leveling[d].mult,
							colours = {
								G.C.UI.TEXT_DARK,
								G.C.UI.TEXT_DARK
							}
						},
					}
				end
				return {
					vars = {
						G.GAME.ranks[b].level,
						G.GAME.ranks[b].l_chips,
						G.GAME.ranks[b].l_mult,
						G.GAME.suits[d].level,
						G.GAME.suits[d].l_chips,
						G.GAME.suits[d].l_mult,
						colours = {
							G.GAME.ranks[b].level <= to_big(7200) and G.C.HAND_LEVELS['!' .. number_format(G.GAME.ranks[b].level)] or G.C.HAND_LEVELS[number_format(G.GAME.ranks[b].level)] or G.C.UI.TEXT_DARK,
							G.GAME.suits[d].level <= to_big(7200) and G.C.HAND_LEVELS['!' .. number_format(G.GAME.suits[d].level)] or G.C.HAND_LEVELS[number_format(G.GAME.suits[d].level)] or G.C.UI.TEXT_DARK
						}
					},
				}
			end,
			can_use = function(self, card)
				return jl.canuse()
			end,
			use = function(self, card, area, copier)
				level_up_rank(card, b, nil, 1, true)
				level_up_suit(card, d, nil, 1)
			end,
			bulk_use = function(self, card, area, copier, number)
				level_up_rank(card, b, nil, number, true)
				level_up_suit(card, d, nil, number)
			end
		}
	end
end

for k, v in pairs(uno_data.colours) do
	SMODS.Consumable {
		key = 'uno_' .. string.lower(k) .. 'drawtwo',
		loc_txt = {
			name = k .. ' Draw Two',
			text = {
				'Creates {C:attention}2 {C:' .. string.lower(v) .. '}' .. k,
				'{C:attention}numerical {C:uno}UNO{} cards',
				mayoverflow,
				spriter('MillieAmp, based on sprites by maywalter666')
			}
		},
		set = 'may_uno',
		pos = { x = 3, y = k == 'Red' and 5 or k == 'Blue' and 6 or k == 'Green' and 7 or k == 'Yellow' and 8 or 5 },
		cost = 4,
		unlocked = true,
		discovered = true,
		atlas = 'mayuno',
		ignore_kudaai = true,
		can_mass_use = true,
		can_use = function(self, card)
			return jl.canuse()
		end,
		use = function(self, card, area, copier)
			if not card.already_used_once then
				card.already_used_once = true
				for i = 1, 2 do
					G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
							play_sound('may_draw')
							local card2 = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, 'c_may_uno_' .. string.lower(k) .. string.lower(pseudorandom_element(uno_data.values, pseudoseed('unodrawtwo_' .. string.lower(k)))), 'unodrawtwo_' .. string.lower(k))
							--[[if card.edition then
								card2:set_edition(card.edition, true)
							end]]
							card2:add_to_deck()
							G.consumeables:emplace(card2)
							card:juice_up(0.3, 0.5)
						return true
					end }))
				end
				Q(function() Q(function() if card then card.already_used_once = nil end return true end) return true end)
				delay(0.6)
			end
		end,
		bulk_use = function(self, card, area, copier, number)
			if not card.already_used_once then
				local quota = 2 * number
				card.already_used_once = true
				if quota > 40 then
					for i = 1, quota do
						local card2 = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, 'c_may_uno_' .. string.lower(k) .. string.lower(pseudorandom_element(uno_data.values, pseudoseed('unodrawtwo' .. string.lower(k)))), 'unodrawtwo_' .. string.lower(k))
						--[[if card.edition then
							card2:set_edition(card.edition, true)
						end]]
						card2:add_to_deck()
						G.consumeables:emplace(card2)
						card:juice_up(0.3, 0.5)
					end
				else
					for i = 1, quota do
						G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
								play_sound('may_draw')
								local card2 = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, 'c_may_uno_' .. string.lower(k) .. string.lower(pseudorandom_element(uno_data.values, pseudoseed('unodrawtwo' .. string.lower(k)))), 'unodrawtwo_' .. string.lower(k))
								--[[if card.edition then
									card2:set_edition(card.edition, true)
								end]]
								card2:add_to_deck()
								G.consumeables:emplace(card2)
								card:juice_up(0.3, 0.5)
							return true
						end }))
					end
				end
				Q(function() Q(function() if card then card.already_used_once = nil end return true end) return true end)
				delay(0.6)
			end
		end
	}
	
	SMODS.Consumable {
		key = 'uno_' .. string.lower(k) .. 'skip',
		loc_txt = {
			name = k .. ' Skip',
			text = {
				'{C:' .. string.lower(v) .. '}' .. v .. '{C:red} siphons{} up to{C:attention} half a level',
				'from {C:attention}all{} of the {C:attention}other{} suits',
				spriter('MillieAmp, based on sprites by maywalter666')
			}
		},
		set = 'may_uno',
		pos = { x = 4, y = k == 'Red' and 5 or k == 'Blue' and 6 or k == 'Green' and 7 or k == 'Yellow' and 8 or 5 },
		cost = 4,
		unlocked = true,
		discovered = true,
		atlas = 'mayuno',
		ignore_kudaai = true,
		can_mass_use = true,
		can_use = function(self, card)
			return jl.canuse()
		end,
		use = function(self, card, area, copier)
			jl.h('Other Ranks & Suits', '...', '...', '')
			if (G.SETTINGS.FASTFORWARD or 0) < 1 then
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
					play_sound('tarot1')
					if card then card:juice_up(0.8, 0.5) end
				return true end }))
				jl.hc('-', true)
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
					play_sound('tarot1')
					if card then card:juice_up(0.8, 0.5) end
				return true end }))
				jl.hm('-', true)
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
					play_sound('tarot1')
					if card then card:juice_up(0.8, 0.5) end
				return true end }))
				jl.hlv('-0~0.5')
				play_sound_q('button', 0.9, 0.7)
			else
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
					play_sound('tarot1')
					if card then card:juice_up(0.8, 0.5) end
				return true end }))
				jl.h('Other Ranks & Suits', '-', '-', '-0~0.5', true)
			end
			delay(1.3)
			local siphoned = to_big(0)
			for a, b in pairs(uno_data.colours) do
				if b ~= v then
					local to_siphon = to_big(math.max(0, math.min(G.GAME.suits[b].level, 0.5)))
					siphoned = siphoned + to_siphon
					level_up_suit(card, b, true, -to_siphon)
				end
			end
			level_up_suit(card, v, nil, siphoned)
		end,
		bulk_use = function(self, card, area, copier, number)
			jl.h('Other Ranks & Suits', '...', '...', '')
			if (G.SETTINGS.FASTFORWARD or 0) < 1 then
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
					play_sound('tarot1')
					if card then card:juice_up(0.8, 0.5) end
				return true end }))
				jl.hc('-', true)
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
					play_sound('tarot1')
					if card then card:juice_up(0.8, 0.5) end
				return true end }))
				jl.hm('-', true)
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
					play_sound('tarot1')
					if card then card:juice_up(0.8, 0.5) end
				return true end }))
				jl.hlv('-0~' .. (number / 2))
				play_sound_q('button', 0.9, 0.7)
			else
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.9, func = function()
					play_sound('tarot1')
					if card then card:juice_up(0.8, 0.5) end
				return true end }))
				jl.h('Other Ranks & Suits', '-', '-', '-0~' .. (number / 2), true)
			end
			delay(1.3)
			local siphoned = to_big(0)
			for a, b in pairs(uno_data.colours) do
				if b ~= v then
					local to_siphon = to_big(math.max(0, math.min(G.GAME.suits[b].level, number / 2)))
					siphoned = siphoned + to_siphon
					level_up_suit(card, b, true, -to_siphon)
				end
			end
			level_up_suit(card, v, nil, siphoned)
		end
	}
	
	SMODS.Consumable {
		key = 'uno_' .. string.lower(k) .. 'reverse',
		loc_txt = {
			name = k .. ' Reverse',
			text = {
				'Swap the level of {C:' .. string.lower(v) .. '}' .. v,
				'with the level of the {C:attention}highest',
				'level among the {C:attention}other suits{},',
				'then {C:attention}level up both suits by 1',
				spriter('MillieAmp, based on sprites by maywalter666')
			}
		},
		set = 'may_uno',
		pos = { x = 5, y = k == 'Red' and 5 or k == 'Blue' and 6 or k == 'Green' and 7 or k == 'Yellow' and 8 or 5 },
		cost = 4,
		unlocked = true,
		discovered = true,
		atlas = 'mayuno',
		ignore_kudaai = true,
		can_mass_use = true,
		can_use = function(self, card)
			return jl.canuse()
		end,
		use = function(self, card, area, copier)
			local selected = v
			local highest = to_big(0)
			for a, b in pairs(uno_data.colours) do
				if b ~= v then
					if G.GAME.suits[b].level > highest then
						highest = G.GAME.suits[b].level
						selected = b
					end
				end
			end
			delay(.5)
			local level1 = G.GAME.suits[v].level
			local level2 = G.GAME.suits[selected].level
			if level1 ~= level2 then
				Q(function() card:juice_up(0.3, 0.5); play_sound('tarot1'); return true end)
				delay(.25)
				play_sound_q('may_misc1')
				card:speak('Swapped!')
				level_up_suit(card, v, nil, level2 - level1, true)
				level_up_suit(card, selected, nil, level1 - level2, true)
				Q(function() card:juice_up(0.3, 0.5); play_sound('tarot2'); return true end)
			else
				card:speak('No change!')
				Q(function() card:juice_up(0.3, 0.5); play_sound('tarot1'); return true end)
			end
			delay(.25)
			play_sound_q('may_misc1', 1.15)
			level_up_suit(card, selected, nil, 1, true)
			level_up_suit(card, v, nil, 1)
		end,
		bulk_use = function(self, card, area, copier, number)
			local selected = v
			local highest = to_big(0)
			for a, b in pairs(uno_data.colours) do
				if b ~= v then
					if G.GAME.suits[b].level > highest then
						highest = G.GAME.suits[b].level
						selected = b
					end
				end
			end
			delay(.5)
			local level1 = G.GAME.suits[v].level
			local level2 = G.GAME.suits[selected].level
			if level1 ~= level2 and number / 2 ~= math.ceil(number / 2) then
				Q(function() card:juice_up(0.3, 0.5); play_sound('tarot1'); return true end)
				delay(.25)
				play_sound_q('may_misc1')
				card:speak('Swapped!')
				level_up_suit(card, v, nil, level2 - level1, true)
				level_up_suit(card, selected, nil, level1 - level2, true)
				Q(function() card:juice_up(0.3, 0.5); play_sound('tarot2'); return true end)
			else
				card:speak('No change!')
				Q(function() card:juice_up(0.3, 0.5); play_sound('tarot1'); return true end)
			end
			delay(.25)
			play_sound_q('may_misc1', 1.15)
			level_up_suit(card, selected, nil, number, true)
			level_up_suit(card, v, nil, number)
		end
	}
end

SMODS.Consumable {
	key = 'uno_wild',
	loc_txt = {
		name = 'Wild',
		text = {
			'Level up {C:attention}all {C:hearts}s{C:spades}u{C:clubs}i{C:diamonds}t{C:attention}s',
			'by {C:attention}#1#{}, plus {C:attention}another #1#',
			'for {C:attention}each playing card',
			'in deck that {C:attention}has the relative suit',
			'{C:inactive}({C:hearts}#2#{C:inactive}, {C:spades}#3#{C:inactive}, {C:clubs}#4#{C:inactive}, {C:diamonds}#5#{C:inactive})',
			spriter('MillieAmp, based on sprites by maywalter666')
		}
	},
	config = {levels = 0.1},
	set = 'may_uno',
	pos = { x = 0, y = 4 },
	cost = 3,
	unlocked = true,
	discovered = true,
	atlas = 'mayuno',
	ignore_kudaai = true,
	can_mass_use = true,
    loc_vars = function(self, info_queue, center)
		local suits = jl.countsuit()
		if type(suits) ~= 'table' then suits = {} end
        return {vars = {((center or {}).ability or {}).levels or 0.1, suits.Hearts or 0, suits.Spades or 0, suits.Clubs or 0, suits.Diamonds or 0}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		for k, v in pairs(jl.countsuit()) do
			level_up_suit(card, k, nil, v * card.ability.levels, true)
		end
		jl.ch()
	end,
	bulk_use = function(self, card, area, copier, number)
		for k, v in pairs(jl.countsuit()) do
			level_up_suit(card, k, nil, v * card.ability.levels * number, true)
		end
		jl.ch()
	end
}

SMODS.Consumable {
	key = 'uno_drawfour',
	loc_txt = {
		name = 'Wild Draw Four',
		text = {
			'Create {C:attention}4{} random {C:uno}UNO{}',
			'cards and level up {C:attention}all {C:hearts}s{C:spades}u{C:clubs}i{C:diamonds}t{C:attention}s',
			'by {C:attention}#1#{}, plus {C:attention}another #1#',
			'for {C:attention}each playing card',
			'in deck that {C:attention}has the relative suit',
			'{C:inactive}({C:hearts}#2#{C:inactive}, {C:spades}#3#{C:inactive}, {C:clubs}#4#{C:inactive}, {C:diamonds}#5#{C:inactive})',
			mayoverflow,
			spriter('MillieAmp, based on sprites by maywalter666')
		}
	},
	config = {levels = 0.05},
	set = 'may_uno',
	pos = { x = 1, y = 4 },
	cost = 5,
	unlocked = true,
	discovered = true,
	atlas = 'mayuno',
	ignore_kudaai = true,
	can_mass_use = true,
    loc_vars = function(self, info_queue, center)
		local suits = jl.countsuit()
		if type(suits) ~= 'table' then suits = {} end
        return {vars = {((center or {}).ability or {}).levels or 0.05, suits.Hearts or 0, suits.Spades or 0, suits.Clubs or 0, suits.Diamonds or 0}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		for k, v in pairs(jl.countsuit()) do
			level_up_suit(card, k, nil, v * card.ability.levels, true)
		end
		jl.ch()
			if not card.already_used_once then
				card.already_used_once = true
				for i = 1, 4 do
					G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
							play_sound('may_draw')
							local card2 = create_card('may_uno', G.consumeables, nil, nil, nil, nil, nil, 'unodrawfour')
							--[[if card.edition then
								card2:set_edition(card.edition, true)
							end]]
							card2:add_to_deck()
							G.consumeables:emplace(card2)
							card:juice_up(0.3, 0.5)
						return true
					end }))
				end
				Q(function() Q(function() if card then card.already_used_once = nil end return true end) return true end)
				delay(0.6)
			end
	end,
	bulk_use = function(self, card, area, copier, number)
		for k, v in pairs(jl.countsuit()) do
			level_up_suit(card, k, nil, v * card.ability.levels * number, true)
		end
			if not card.already_used_once then
				card.already_used_once = true
				for i = 1, 4 * number do
					G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
							play_sound('may_draw')
							local card2 = create_card('may_uno', G.consumeables, nil, nil, nil, nil, nil, 'unodrawfour')
							--[[if card.edition then
								card2:set_edition(card.edition, true)
							end]]
							card2:add_to_deck()
							G.consumeables:emplace(card2)
							card:juice_up(0.3, 0.5)
						return true
					end }))
				end
				Q(function() Q(function() if card then card.already_used_once = nil end return true end) return true end)
				delay(0.6)
			end
		jl.ch()
	end
}

SMODS.Consumable {
	key = 'uno_wild_paint',
	loc_txt = {
		name = 'Wild Paint',
		text = {
			'Level up {C:attention}all {C:hearts}s{C:spades}u{C:clubs}i{C:diamonds}t{C:attention}s',
			'by {C:attention}#1#{}, plus {C:attention}another #1#',
			'for {C:attention}each playing card',
			'in deck that {C:attention}has the relative suit{},',
			'and create a {C:attention}Draw Two{} of relative colours',
			'for {C:attention}every 2 occurrences{} of that suit',
			'{C:inactive}({C:hearts}#2#{C:inactive}, {C:spades}#3#{C:inactive}, {C:clubs}#4#{C:inactive}, {C:diamonds}#5#{C:inactive})',
			spriter('MillieAmp, based on sprites by jenwalter666')
		}
	},
	config = {levels = 0.01},
	set = 'Spectral',
	pos = { x = 3, y = 4 },
	cost = 5,
	hidden = true,
	unlocked = true,
	discovered = true,
	soul_set = 'may_uno',
	atlas = 'mayuno',
	ignore_kudaai = true,
	can_mass_use = true,
    loc_vars = function(self, info_queue, center)
		local suits = jl.countsuit()
		if type(suits) ~= 'table' then suits = {} end
        return {vars = {((center or {}).ability or {}).levels or 0.01, suits.Hearts or 0, suits.Spades or 0, suits.Clubs or 0, suits.Diamonds or 0}}
    end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
		for k, v in pairs(jl.countsuit()) do
			level_up_suit(card, k, nil, v * card.ability.levels, true)
				if v / 2 > 1 then
					G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
							play_sound('may_draw')
							local card2 = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, 'c_may_uno_' .. suit_to_uno(k) .. 'drawtwo', 'uno_paint')
							if math.floor(v / 2) > 1 then
								card2:setQty(math.floor(v / 2))
								card2:create_stack_display()
							end
							card2:add_to_deck()
							G.consumeables:emplace(card2)
							card:juice_up(0.3, 0.5)
						return true
					end }))
				end
			delay(0.6)
		end
		jl.ch()
	end,
	bulk_use = function(self, card, area, copier, number)
		for k, v in pairs(jl.countsuit()) do
			level_up_suit(card, k, nil, v * card.ability.levels * number, true)
				if v / 2 > 1 then
					G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
							play_sound('may_draw')
							local card2 = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, 'c_may_uno_' .. suit_to_uno(k) .. 'drawtwo', 'uno_paint')
							card2:setQty(math.floor(v / 2) * number)
							card2:create_stack_display()
							card2:add_to_deck()
							G.consumeables:emplace(card2)
							card:juice_up(0.3, 0.5)
						return true
					end }))
				end
			delay(0.6)
		end
		jl.ch()
	end
}

SMODS.Consumable {
	key = 'uno_null',
	loc_txt = {
		name = 'Null',
		text = {
			'Does nothing',
			spriter('MillieAmp, based on sprites by maywalter666')
		}
	},
	set = 'may_uno',
	pos = { x = 9, y = 9 },
	cost = 1,
	unlocked = true,
	discovered = true,
	atlas = 'mayuno',
	can_mass_use = true,
	in_pool = function() return false end,
	can_use = function(self, card)
		return jl.canuse()
	end,
	use = function(self, card, area, copier)
	end,
	bulk_use = function(self, card, area, copier, number)
	end
}


for i = 1, 4 do
	SMODS.Booster{
		key = 'unopack' .. i,
		loc_txt = {
			name = 'UNO Pack',
			text = {
				'Choose {C:attention}#1#{} of up to',
				'{C:attention}#2# {C:uno}UNO{} cards to',
				'be used immediately',
				spriter('ocksie')
			}
		},
		atlas = 'maybooster',
		pos = {x = i-1, y = 1},
		weight = 1,
		cost = 4,
		config = {extra = 3, choose = 1},
		discovered = true,
		loc_vars = function(self, info_queue, card)
			return { vars = {card.ability.choose, card.ability.extra} }
		end,
		ease_background_colour = function(self)
			ease_background_colour{new_colour = HEX(i == 1 and 'ED1C24' or i == 2 and '0072BC' or i == 3 and '50AA44' or i == 4 and 'FFDE16' or 'ED1C24'), special_colour = HEX('000000'), contrast = 5}
		end,
		create_UIBox = function(self)
			local _size = SMODS.OPENED_BOOSTER.ability.extra
			G.pack_cards = CardArea(
				G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
				math.max(1,math.min(_size,5))*G.CARD_W*1.1,
				1.05*G.CARD_H, 
				{card_limit = _size, type = 'consumeable', highlight_limit = 1})

			local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
				{n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
					{n=G.UIT.R, config={align = "cm"}, nodes={
					{n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
						{n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
							{n=G.UIT.O, config={object = G.pack_cards}},}}}}}},
				{n=G.UIT.R, config={align = "cm"}, nodes={}},
				{n=G.UIT.R, config={align = "tm"}, nodes={
					{n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
					{n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
						UIBox_dyn_container({
							{n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
								{n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
									{n=G.UIT.O, config={object = DynaText({string = {'UNO Pack '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
								{n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
									{n=G.UIT.O, config={object = DynaText({string = {localize('k_choose') .. ' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
									{n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}}},}}
						}),}},
					{n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
						{n=G.UIT.R,config={minh =0.2}, nodes={}},
						{n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
							{n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}}}}}}}}
			return t
		end,
        create_card = function(self, card, i)
            return {set = 'may_uno', area = G.pack_cards, skip_materialize = true, soulable = true, key_append = 'uno'}
        end
	}
end

for i = 1, 2 do
	SMODS.Booster{
		key = 'jumbounopack' .. i,
		loc_txt = {
			name = 'Jumbo UNO Pack',
			text = {
				'Choose {C:attention}#1#{} of up to',
				'{C:attention}#2# {C:uno}UNO{} cards to',
				'be used immediately',
				spriter('ocksie')
			}
		},
		atlas = 'maybooster',
		pos = {x = i-1, y = 2},
		weight = 1,
		cost = 6,
		config = {extra = 5, choose = 1},
		discovered = true,
		loc_vars = function(self, info_queue, card)
			return { vars = {card.ability.choose, card.ability.extra} }
		end,
		ease_background_colour = function(self)
			ease_background_colour{new_colour = HEX(i == 1 and 'ED1C24' or i == 2 and '0072BC' or 'ED1C24'), special_colour = HEX('000000'), contrast = 5}
		end,
		create_UIBox = function(self)
			local _size = SMODS.OPENED_BOOSTER.ability.extra
			G.pack_cards = CardArea(
				G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
				math.max(1,math.min(_size,5))*G.CARD_W*1.1,
				1.05*G.CARD_H, 
				{card_limit = _size, type = 'consumeable', highlight_limit = 1})

			local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
				{n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
					{n=G.UIT.R, config={align = "cm"}, nodes={
					{n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
						{n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
							{n=G.UIT.O, config={object = G.pack_cards}},}}}}}},
				{n=G.UIT.R, config={align = "cm"}, nodes={}},
				{n=G.UIT.R, config={align = "tm"}, nodes={
					{n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
					{n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
						UIBox_dyn_container({
							{n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
								{n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
									{n=G.UIT.O, config={object = DynaText({string = {'UNO Pack '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
								{n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
									{n=G.UIT.O, config={object = DynaText({string = {localize('k_choose') .. ' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
									{n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}}},}}
						}),}},
					{n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
						{n=G.UIT.R,config={minh =0.2}, nodes={}},
						{n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
							{n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}}}}}}}}
			return t
		end,
        create_card = function(self, card, i)
            return {set = 'may_uno', area = G.pack_cards, skip_materialize = true, soulable = true, key_append = 'uno'}
        end
	}
end

for i = 1, 2 do
	SMODS.Booster{
		key = 'megaunopack' .. i,
		loc_txt = {
			name = 'Mega UNO Pack',
			text = {
				'Choose {C:attention}#1#{} of up to',
				'{C:attention}#2# {C:uno}UNO{} cards to',
				'be used immediately',
				spriter('ocksie')
			}
		},
		atlas = 'maybooster',
		pos = {x = i+1, y = 2},
		weight = .25,
		cost = 8,
		config = {extra = 5, choose = 2},
		discovered = true,
		loc_vars = function(self, info_queue, card)
			return { vars = {card.ability.choose, card.ability.extra} }
		end,
		ease_background_colour = function(self)
			ease_background_colour{new_colour = HEX('2a2a2a'), special_colour = HEX('000000'), contrast = 5}
		end,
		create_UIBox = function(self)
			local _size = SMODS.OPENED_BOOSTER.ability.extra
			G.pack_cards = CardArea(
				G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
				math.max(1,math.min(_size,5))*G.CARD_W*1.1,
				1.05*G.CARD_H, 
				{card_limit = _size, type = 'consumeable', highlight_limit = 1})

			local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
				{n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
					{n=G.UIT.R, config={align = "cm"}, nodes={
					{n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
						{n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
							{n=G.UIT.O, config={object = G.pack_cards}},}}}}}},
				{n=G.UIT.R, config={align = "cm"}, nodes={}},
				{n=G.UIT.R, config={align = "tm"}, nodes={
					{n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
					{n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
						UIBox_dyn_container({
							{n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
								{n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
									{n=G.UIT.O, config={object = DynaText({string = {'UNO Pack '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
								{n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
									{n=G.UIT.O, config={object = DynaText({string = {localize('k_choose') .. ' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
									{n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}}},}}
						}),}},
					{n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
						{n=G.UIT.R,config={minh =0.2}, nodes={}},
						{n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
							{n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}}}}}}}}
			return t
		end,
        create_card = function(self, card, i)
            return {set = 'may_uno', area = G.pack_cards, skip_materialize = true, soulable = true, key_append = 'uno'}
        end
	}
end

for i = 1, 2 do
	SMODS.Booster{
		key = 'miniunopack' .. i,
		loc_txt = {
			name = 'Mini UNO Pack',
			text = {
				'Choose {C:attention}#1#{} of up to',
				'{C:attention}#2# {C:uno}UNO{} cards to',
				'be used immediately',
				spriter('ocksie')
			}
		},
		atlas = 'maybooster',
		pos = {x = i-1, y = 3},
		weight = .8,
		cost = 2,
		config = {extra = 2, choose = 1},
		discovered = true,
		loc_vars = function(self, info_queue, card)
			return { vars = {card.ability.choose, card.ability.extra} }
		end,
		ease_background_colour = function(self)
			ease_background_colour{new_colour = HEX(i == 1 and 'FFDE16' or i == 2 and '50AA44' or 'FFDE16'), special_colour = HEX('000000'), contrast = 5}
		end,
		create_UIBox = function(self)
			local _size = SMODS.OPENED_BOOSTER.ability.extra
			G.pack_cards = CardArea(
				G.ROOM.T.x + 9 + G.hand.T.x, G.hand.T.y,
				math.max(1,math.min(_size,5))*G.CARD_W*1.1,
				1.05*G.CARD_H, 
				{card_limit = _size, type = 'consumeable', highlight_limit = 1})

			local t = {n=G.UIT.ROOT, config = {align = 'tm', r = 0.15, colour = G.C.CLEAR, padding = 0.15}, nodes={
				{n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR,r=0.15, padding = 0.1, minh = 2, shadow = true}, nodes={
					{n=G.UIT.R, config={align = "cm"}, nodes={
					{n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
						{n=G.UIT.C, config={align = "cm", r=0.2, colour = G.C.CLEAR, shadow = true}, nodes={
							{n=G.UIT.O, config={object = G.pack_cards}},}}}}}},
				{n=G.UIT.R, config={align = "cm"}, nodes={}},
				{n=G.UIT.R, config={align = "tm"}, nodes={
					{n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={}},
					{n=G.UIT.C,config={align = "tm", padding = 0.05}, nodes={
						UIBox_dyn_container({
							{n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 4}, nodes={
								{n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
									{n=G.UIT.O, config={object = DynaText({string = {'UNO Pack '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.7, maxw = 4, pop_in = 0.5})}}}},
								{n=G.UIT.R,config={align = "bm", padding = 0.05}, nodes={
									{n=G.UIT.O, config={object = DynaText({string = {localize('k_choose') .. ' '}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}},
									{n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'pack_choices'}}, colours = {G.C.WHITE},shadow = true, rotate = true, bump = true, spacing =2, scale = 0.5, pop_in = 0.7})}}}},}}
						}),}},
					{n=G.UIT.C,config={align = "tm", padding = 0.05, minw = 2.4}, nodes={
						{n=G.UIT.R,config={minh =0.2}, nodes={}},
						{n=G.UIT.R,config={align = "tm",padding = 0.2, minh = 1.2, minw = 1.8, r=0.15,colour = G.C.GREY, one_press = true, button = 'skip_booster', hover = true,shadow = true, func = 'can_skip_booster'}, nodes = {
							{n=G.UIT.T, config={text = localize('b_skip'), scale = 0.5, colour = G.C.WHITE, shadow = true, focus_args = {button = 'y', orientation = 'bm'}, func = 'set_button_pip'}}}}}}}}}}}}
			return t
		end,
        create_card = function(self, card, i)
            return {set = 'may_uno', area = G.pack_cards, skip_materialize = true, soulable = true, key_append = 'uno'}
        end
	}
end

local mcp = Moveable.calculate_parrallax
function Moveable:calculate_parrallax()
	if self.no_parallax then
		self.shadow_parrallax = {x = 0, y = 0}
	end
	return mcp(self)
end
function ui_suits_ranks()
	if not G.suitrank then
		G.suitrank = {}
	end
	if G.suitrank.card then
		G.suitrank.card:remove()
	end
	if not G.suitrank.rank or not G.suitrank.suit or not is_valid_suit_rank(G.suitrank.suit, G.suitrank.rank) then
		for i = 1, #SMODS.Rank.obj_buffer do
			local r = SMODS.Rank.obj_buffer[i]
			for j = 1, #SMODS.Suit.obj_buffer do
				local s = SMODS.Suit.obj_buffer[j]
				if is_valid_suit_rank(s, r) then
					G.suitrank.suit = s
					G.suitrank.rank = r
					break
				end
			end
		end
	end
	G.suitrank.card = Card(0,0,1.5*G.CARD_W,1.5*G.CARD_H,G.P_CARDS.S_A,G.P_CENTERS.c_base)
	G.suitrank.card.ambient_tilt = 0
	G.suitrank.card.states.hover.can = false
	G.suitrank.card.hover_tilt = 0
	G.suitrank.card.no_parallax = true
	G.suitrank.card.shadow = false
	if not G.suitrank.suitconfig then
		G.suitrank.suitconfig = {}
	end
	if not G.suitrank.rankconfig then
		G.suitrank.rankconfig = {}
	end
	recalc_suitrank()

	--A bunch of local functions to define core nodes, so as to make the code easier to read
	local function sr_name(type)
		return {n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR, r = 0.2,}, nodes = {
			{n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.suitrank[type.."config"], ref_value = "name"}}, scale = 0.8, shadow = true, colours = {G.C.WHITE}})}},
		}}
	end
	local function sr_level(type)
		return {n=G.UIT.R, config={align = "cr", colour = G.C.CLEAR}, nodes={
			{n=G.UIT.R, config={align = "cm", padding = 0.05, r = 0.1, colour = G.suitrank[type.."config"].level_color, minw = 1.7, outline = 0.8, outline_colour = G.suitrank[type.."config"].outline_color}, nodes={
				{n=G.UIT.T, config={ref_table = G.suitrank[type.."config"], ref_value = "level", scale = 0.5, colour = G.C.UI.TEXT_DARK}}
			}}
		}}
	end
	local function sr_count(type)
		return {{n=G.UIT.C, config={align = "cl"}, nodes={
			{n=G.UIT.T, config={text = '#', scale = 0.45, colour = G.C.WHITE, shadow = true}}
		  }},
		{n=G.UIT.C, config={align = "cm", padding = 0.05, colour = G.suitrank[type.."config"].outline_color,r = 0.1, minw = 0.9}, nodes={
		  {n=G.UIT.T, config={ref_table = G.suitrank[type.."config"], ref_value = "count", scale = 0.45, colour = G.suitrank[type.."config"].text_color, shadow = true}},
		}}}
	end

	local function sr_values(type)
		return {n=G.UIT.R, config={align = "cr"}, nodes={
			{n=G.UIT.C, config={align = "cm", padding = 0.03, r = 0.1, colour = G.C.CHIPS, minw = 0.8}, nodes={
				{n=G.UIT.T, config={ref_table = G.suitrank[type.."config"], ref_value = "chips", scale = 0.45, colour = G.C.UI.TEXT_LIGHT}},
			}},{n=G.UIT.B, config = {w=0.1,h=0.1}},
			{n=G.UIT.C, config={align = "cm", padding = 0.03, r = 0.1, colour = G.C.MULT, minw = 0.8}, nodes={
				{n=G.UIT.T, config={ref_table = G.suitrank[type.."config"], ref_value = "mult", scale = 0.45, colour = G.C.UI.TEXT_LIGHT}}
			}},
		}}
	end

	local function sr_hand(type)
		return {n=G.UIT.R, config={align = "cm", colour = G.suitrank[type.."config"].color, minw = 7, minh = 2, r = 0.2, outline = 1, outline_colour = G.suitrank[type.."config"].outline_color, padding = 0.3}, nodes = {
			{n = G.UIT.C, config={align = "cl", colour = G.C.CLEAR, r = 0.2, padding = 0.03, minw = 3.5}, nodes = {
				sr_name(type),
				{n=G.UIT.R, config={align = "cl", colour = G.C.CLEAR, r = 0.2}, nodes = {
					sr_count(type)[1],
					sr_count(type)[2],
				}}
			}},
			{n = G.UIT.C, config={align = "cr", colour = G.C.CLEAR,  r = 0.2, padding = 0.03, minw = 3.5}, nodes = {
				sr_level(type),
				sr_values(type),
			}},
		}}
	end

	local function sr_card()
		return {n=G.UIT.C, config={align = "cm", colour = G.C.CLEAR, }, nodes={
			{n = G.UIT.R, config = {minw=2, minh=1.5, colour = G.C.CLEAR, padding = 0.15, align = "bm"}, nodes = {
				UIBox_button_w_sprite({
					colour = G.C.CLEAR,
					button = "inc_sr_rank",
					sprite = Sprite(0, 0, 1, 1,  G.ASSET_ATLAS["may_maybuttons"], {x = 0, y = 0}),
					scale = 0.6,
					minw = 1,
				})
			}},
			{n = G.UIT.R, config = {minw=2, minh=1.5, colour = G.C.CLEAR, padding = 0.15}, nodes = {
				{n=G.UIT.C, config={align = "cr", colour = G.C.CLEAR, }, nodes={
					UIBox_button_w_sprite({
						colour = G.C.CLEAR,
						button = "dec_sr_suit",
						sprite = Sprite(0, 0, 1, 1,  G.ASSET_ATLAS["may_maybuttons"], {x = 3, y = 0}),
						scale = 0.6,
						minw = 1,
					})
				}},
				{n=G.UIT.B, config = {w=0.15,h=0.15}}, --I have no idea why this is off center by default
				{n=G.UIT.C, config={minw=2.5, align = "cm", colour = G.C.CLEAR, }, nodes={
					{n=G.UIT.O, config={colour = G.C.BLUE, object = G.suitrank.card, hover = false, can_collide = false}},
				}},
				{n=G.UIT.C, config={align = "cl", colour = G.C.CLEAR, }, nodes={
					UIBox_button_w_sprite({
						colour = G.C.CLEAR,
						button = "inc_sr_suit",
						sprite = Sprite(0, 0, 1, 1,  G.ASSET_ATLAS["may_maybuttons"], {x = 1, y = 0}),
						scale = 0.6,
						minw = 1,
					})
				}},
			}},
			{n = G.UIT.R, config = {minw=2, minh=1.5, colour = G.C.CLEAR, padding = 0.15, align = "tm"}, nodes = {
				UIBox_button_w_sprite({
					colour = G.C.CLEAR,
					button = "dec_sr_rank",
					sprite = Sprite(0, 0, 1, 1,  G.ASSET_ATLAS["may_maybuttons"], {x = 2, y = 0}),
					scale = 0.6,
					minw = 1,
				})
			}},
		}}
	end

	return {
		n = G.UIT.ROOT,
		config = { align = "cm", minw = 3, padding = 0.1, r = 0.1, colour = G.C.CLEAR },
		nodes = {
			{n=G.UIT.R, config={align = "cm", colour = G.C.CLEAR, }, nodes={
				sr_card(),
				{n=G.UIT.C, config={align = "cm", colour = G.C.CLEAR, minw = 6, padding = 0.3 }, nodes={
					sr_hand("suit"),
					sr_hand("rank"),
				}}
			}}
		}
	}
end

G.FUNCS.current_suits_ranks = function(e)
	G.SETTINGS.paused = true
	G.FUNCS.overlay_menu{definition = ui_suits_ranks()}
end

return init