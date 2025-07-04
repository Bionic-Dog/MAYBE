

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


SMODS.Joker {
	key = 'john',
	loc_txt = {
		name = 'john',
		text = {
			'yuo g et {C:chips}+#1#{}',
			'chisp when you  vlink',
		}
	},
	pos = { x = 0, y = 0 },
	soul_pos = { x = 1, y = 0 },
	config = {extra = {chips = 3000000000}},
	loc_vars = function(self, info_queue, center)
        return {vars = {((center or {}).ability or {}).chips or 3000000000}}
    end,
	cost = 5,
	rarity = 2,
	--misc_badge = sevensins.hydrangea,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	--immutable = true,
	atlas = 'mayjohn',
	calculate = function(self, card, context)
		if card.children.center.sprite_pos.y == 1 then
			--print("plink")
			if context.joker_main then
			return {
				message = localize({ type = "variable", key = "a_chips", vars = { card.ability.extra.chips } }),
				chip_mod = card.ability.extra.chips,
			}
			end
		end
        
    end
}

SMODS.Joker {
	key = 'shareholders',
	loc_txt = {
		name = 'Shareholders',
		text = {
			'If a played hand is a',
			'{C:attention}Royal Flush{},',
			'gain {C:money}+$#1#{}, and',
			'then {X:money,C:white}x#2#{}.',
		}
	},
	pos = { x = 0, y = 0 },
	config = {extra = {mod1 = 10, mod2= 2}},
	loc_vars = function(self, info_queue, center)
        return {vars = {((center or {}).ability or {}).mod1 or 10, ((center or {}).ability or {}).mod2 or 2, }}
    end,
	cost = 5,
	rarity = 2,
	--misc_badge = sevensins.hydrangea,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	--immutable = true,
	atlas = 'mayshareholders',
	calculate = function(self, card, context)
		if context.joker_main and context.poker_hands and G.GAME.current_round.current_hand.handname == "Royal Flush" then
			if G.jokers then
				ease_dollars(self.config.extra.mod1)
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
						ease_dollars((self.config.extra.mod2 - 1) * G.GAME.dollars)
					return true
				end}))
			end
		end
	end,
}

SMODS.Joker{ --shower
    --name = "{C:chips}Y{}{C:mult}a{}{C:money}t{}{C:mult}t{}{C:chips}a{}",
    key = "shower",
    loc_txt = {
		name = 'Hot Shower',
		text = {
			'Each discarded card adds',
			'+{C:chips}#1#{} bonus chips to all other cards.',
			lore('\'Cuz lord knows we all need one.'),
			faceart('MillieAmp, based on a stock photo'),
		}
	},
    pos = {
        x = 0,
        y = 0
    },
    cost = 2,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
	perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'mayshower',
	immutable = false,
    config = { extra = 5 },
	loc_vars = function(self, info_queue, card)
		return { vars = { (card and card.ability.extra or self.config.extra) } }
	end,
	
    calculate = function(self, card, context)
        if context.discard and not context.other_card.debuff then
			for i = 1, #G.hand.cards do
			G.hand.cards[i].ability.perma_bonus = context.other_card.ability.perma_bonus or 0
            G.hand.cards[i].ability.perma_bonus = context.other_card.ability.perma_bonus + card.ability.extra
			G.hand.cards[i]:juice_up(0.3, 0.5)
			end			
        end
    end
}




SMODS.Joker{
    key = "capsulejoker",
    loc_txt = {
		name = 'Capsule Joker',
		text = {
			'Non-{C:dark_edition}Negative{} {C:attention}Capsules{} have a',
			'{C:green}#1# in #2#{} chance to create',
			'a {C:dark_edition}Negative{} copy when used',
			lore('Not a Joker Capsule!'),
			faceart('MillieAmp'),
		}
	},
    pos = {
        x = 1,
        y = 0
    },
	soul_pos = {
        x = 0,
        y = 0
    },
    cost = 3,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
	perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'maycapsulejoker',
	immutable = false,
    config={extra={odds=3}},
	loc_vars=function(self,info_queue,center)
                return {vars={''..(G.GAME and G.GAME.probabilities.normal or 1), center.ability.extra.odds}}
            end,
	
    calculate = function(self, card, context)
        if context.using_consumeable and context.consumeable.ability.set == 'Capsule' and not (context.consumeable.edition or {}).negative then
			
			if pseudorandom('capjoker') < G.GAME.probabilities.normal/card.ability.extra.odds then
				card:juice_up(0.3, 0.5)
				Q(function()
					local dup = copy_card(context.consumeable)
					dup:add_to_deck()
					dup:set_edition({negative = true}, true)
					G.consumeables:emplace(dup)
				return true end, 1)
			else
				card:speak(localize('k_nope_ex'), G.C.RED)
			end

        end
    end
}


SMODS.Joker{
    key = "asabove",
    loc_txt = {
		name = 'As Above...',
		text = {
			'When opening an {C:tarot}Arcana Pack{}',
			'of any kind, add a {C:attention}Magic Capsule{}',
			'to your consumable tray',
			lore('...so below.'),
			faceart('MillieAmp, based on vanilla card art'),
		}
	},
    pos = {
        x = 0,
        y = 0
    },
    cost = 2,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
	perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'mayasabove',
	immutable = true,
}

local cor=Card.open
function Card:open()
	local aboves = #SMODS.find_card('j_may_asabove')
	if self.ability.set == "Booster" and string.find(string.lower(self.ability.name), 'arcana') and aboves > 0 then
		Q(function()
			local card2 = create_card('Capsule', G.consumeables, nil, nil, nil, nil, 'c_may_cap_tarot', 'asabove_cap')
			card2:add_to_deck()
			G.consumeables:emplace(card2)
		return true end)
	end
	return cor(self)
end

SMODS.Joker{
    key = "hemispheres",
    loc_txt = {
		name = 'Hemispheres',
		text = {
			'When opening an {C:planet}Celestial Pack{}',
			'of any kind, add an {C:attention}Astro Capsule{}',
			'to your consumable tray',
			lore('Any planet can a giant gachapon capsule,'),
			lore('if you\'re brave or dumb enough.'),
			faceart('MillieAmp, based on vanilla card art'),
		}
	},
    pos = {
        x = 0,
        y = 0
    },
    cost = 2,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
	perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'mayhemispheres',
	immutable = true,
}


local cor=Card.open
function Card:open()
	local hemis = #SMODS.find_card('j_may_hemispheres')
	if self.ability.set == "Booster" and string.find(string.lower(self.ability.name), 'celestial') and hemis > 0 then
		Q(function()
			local card2 = create_card('Capsule', G.consumeables, nil, nil, nil, nil, 'c_may_cap_planet', 'hemispheres_cap')
			card2:add_to_deck()
			G.consumeables:emplace(card2)
		return true end)
	end
	return cor(self)
end