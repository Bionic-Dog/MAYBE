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


--mesa
--[[
SMODS.Joker {
	key = 'mesa',
	loc_txt = {
		name = 'Mesa',
		text = {
			'{C:attention}All scored cards{} reduce the {C:attention}current Blind',
			'by {C:attention}2%{} when scored',
			' ',
			lore('He knows not who he is, or was,'),
			lore('but does not let it get him down.'),
			caption('It doesn\'t matter if nobody remembers you.'),
			caption('What matters is that you enjoy life while you can!'),
			faceart('fantomaz'),
			origin('Astros_Not_Awake')
		}
	},
	pos = { x = 0, y = 0 },
	soul_pos = { x = 1, y = 0 },
	cost = 50,
	rarity = 'cry_exotic',
	--misc_badge = sevensins.hydrangea,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	immutable = true,
	atlas = 'maymesa',
    calculate = function(self, card, context)
		if context.cardarea == G.play then
			if context.other_card and jl.scj(context) then
				if (G.SETTINGS.FASTFORWARD or 0) < 1 and (G.SETTINGS.STATUSTEXT or 0) < 2 then
					card_status_text(card, '-2% Blind Size', nil, 0.05*card.T.h, G.C.FILTER, 0.75, 1, 0.6, nil, 'bm', 'generic1')
				end
				change_blind_size(to_big(G.GAME.blind.chips) / to_big(1.02), (G.SETTINGS.FASTFORWARD or 0) > 1, (G.SETTINGS.FASTFORWARD or 0) > 1)
				return nil, true
			end
		end
	end
}]]

SMODS.Joker {
	key = 'gluttony',
	loc_txt = {
		name = 'Nimis',
		text = {
			'If a played hand contains a',
			'{C:attention}Four of a Kind{},',
			'destroy all played cards',
			'after scoring, then gain:',
			'{C:dark_edition}#1#{} Joker slot(s)',
			--'{C:edition}#1#{} Consumable slot,',
			--'{C:attention}#1#{} hand size,',
			--'and {C:attention}#1#{} card selection limit, permanently.',
			lore('They say my hunger\'s a problem...'),
		}
	},
	pos = { x = 0, y = 0 },
	soul_pos = { x = 1, y = 0 },
	config = {extra = {add = 2}},
	loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.add}}
    end,
	cost = 50,
	rarity = 'cry_exotic',
	--misc_badge = sevensins.hydrangea,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	--immutable = true,
	atlas = 'maygluttony',
	calculate = function(self, card, context)
		if context.destroying_card then
			local eval = evaluate_poker_hand(context.full_hand)
			if next(eval["Four of a Kind"]) then
				return not context.destroying_card.ability.eternal
			end
		end
		if context.joker_main and context.poker_hands and next(context.poker_hands["Four of a Kind"]) then
			if G.jokers then
				local additive = card.ability.extra.add
				--G.hand:change_size(additive)
				G.jokers:change_size_absolute(additive)
				--G.consumeables:change_size_absolute(additive)
				--G.hand.config.highlighted_limit = G.hand.config.highlighted_limit
				--+ (card and card.ability.extra.add or self.config.extra.add)
			end
		end
	end,
}

SMODS.Joker{ --sally
    --name = "{C:chips}Y{}{C:mult}a{}{C:money}t{}{C:mult}t{}{C:chips}a{}",
    key = "sally",
    loc_txt = {
		name = 'Sally',
		text = {
			'+{C:attention}#1#{} card slots, +{C:attention}#1#{} voucher slots,',
			'and +{C:attention}#1#{} booster slots in the shop',
			'Shop items cost 33% less',
			lore('The resourceful, kind and motherly shopkeeper of the Sanctum.'),
			lore('(Just don\'t ask where she gets the milk for the carrot cakes.)'),
			caption('Well, howdy! What can I do ya for?'),
			faceart('MillieAmp, based on art by Grepstrash'),
			origin('ATLYSS')
		}
	},
    pos = {
        x = 0,
        y = 0
    },
	soul_pos = { x = 1, y = 0 },
    cost = 50,
    rarity = 'cry_exotic',
    blueprint_compat = true,
    eternal_compat = true,
	perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'maysally',
	immutable = true,
    config = { extra = 4 },
	loc_vars = function(self, info_queue, card)
		return { vars = { (card and card.ability.extra or self.config.extra) } }
	end,
	
    add_to_deck = function(self)
		G.E_MANAGER:add_event(Event({
			func = function()
				G.GAME.backup_discount_percent = G.GAME.backup_discount_percent or G.GAME.discount_percent
				G.GAME.discount_percent = 33
				for k, v in pairs(G.I.CARD) do
					if v.set_cost then
						v:set_cost()
					end
				end
				return true
			end,
		}))
		local mod = math.floor(card and card.ability.extra or self.config.extra)
		SMODS.change_booster_limit(mod)
		G.E_MANAGER:add_event(Event({
			func = function() --card slot
				-- why is this in an event?
				change_shop_size(mod)
				return true
			end,
		}))
		SMODS.change_voucher_limit(mod)
	end,
	remove_from_deck = function(self)
		G.E_MANAGER:add_event(Event({
			func = function()
				G.GAME.discount_percent = G.GAME.backup_discount_percent or 0
				for k, v in pairs(G.I.CARD) do
					if v.set_cost then
						v:set_cost()
					end
				end
				return true
			end,
		}))
		local mod = math.floor(card and card.ability.extra or self.config.extra)
		SMODS.change_booster_limit(-mod)
		G.E_MANAGER:add_event(Event({
			func = function() --card slot
				-- why is this in an event?
				change_shop_size(-mod)
				return true
			end,
		}))
		SMODS.change_voucher_limit(-mod)
	end,
}







local robot_flavour = {
	'GET EQUIPPED WITH: JOKER SLOT', 
	'YOU GOT: JOLLY PAIR', 
	'GET EQUIPPED WITH: NEGATIVE JUDGEMENT',
	'YOU GOT: CRYPTIC CRUSH',
	'GET EQUIPPED WITH: ANOTHER LEAF SHIELD CLONE',
	'YOU GOT: GAME REFERENCE',
	'GET EQUIPPED WITH: GIRL TRANSFORM',
	'YOU GOT: MYSTIC SUMMIT',
}
--[[
if G.jokers then
					local additive = card.ability.extra.add
					G.jokers:change_size_absolute(additive)
					SMODS.add_card({set = 'Tarot', key = 'c_judgement', edition = 'e_negative'})
					return {
						message = robot_flavour[math.random(#robot_flavour)],
						colour = G.C.EDITION,
						card = context.other_card,
            		}
				end
]]

SMODS.Joker {
	key = 'robotmaster',
	loc_txt = {
		name = 'Magister Automaton',
		text = {
			'Upon defeating any Boss Blind,',
			'gain +{C:dark_edition}#1#{} Joker slot,',
			'{C:attention}permanently{}, and create a',
			'{C:dark_edition}Negative{} {C:tarot}Judgement{} card',
		}
	},
	pos = { x = 0, y = 0 },
	soul_pos = { x = 1, y = 0 },
	config = {extra = {add = 1}},
	loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.extra.add}}
    end,
	cost = 50,
	rarity = 'cry_exotic',
	--misc_badge = sevensins.hydrangea,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	--immutable = true,
	atlas = 'mayrobotmaster',
	calculate = function(self, card, context)
            
            if context.end_of_round and not (context.individual or context.repetition or context.blueprint)
            and G.GAME.blind.boss and not card.ability.extra.can_copy then
                local additive = card.ability.extra.add
					G.jokers:change_size_absolute(additive)
					SMODS.add_card({set = 'Tarot', key = 'c_judgement', edition = 'e_negative'})
					return {
						message = robot_flavour[math.random(#robot_flavour)],
						colour = G.C.EDITION,
						card = context.other_card,
            		}
            end
        end,
}







return init