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

local guha_flavour = {'Forgotten!', 'Mourned!', 'Spited!', 'Pitchmapped!', 'Spectrogrammed!'}

SMODS.Joker {
	key = 'guhadeen',
	loc_txt = {
		name = 'Guhadeen',
		text = {
			'If a card is discarded card lacks an Edition,',
			'there is a {C:green}#1# in #2#{} chance',
			'for it to become a Forgotten card.',
			lore('Another close friend of Millie\'s.'),
			lore('All she wants is to be remembered.'),
			caption('To forgive is to forget...');
			caption('...and I can remember them clear as day.');
		}
	},
	pos = { x = 0, y = 0 },
	soul_pos = { x = 1, y = 0 },
	config={extra={odds=3}},
	loc_vars=function(self,info_queue,center)
                return {vars={''..(G.GAME and G.GAME.probabilities.normal or 1), center.ability.extra.odds}}
            end,
	cost = 50,
	rarity = 4,
	misc_badge = milliefriend,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false,
	--immutable = true,
	atlas = 'mayguhadeen',
	calculate = function(self, card, context)
        if context.discard and not context.other_card.debuff and
        pseudorandom('guha') < G.GAME.probabilities.normal/card.ability.extra.odds then
            --local card=context.other_card
            if(not context.other_card.edition) then
				context.other_card:set_edition({may_forgotten = true}, true)
				return {
					message = guha_flavour[math.random(#guha_flavour)],
					colour = G.C.RED,
					card = context.other_card,
            	}
			end
        end
    end


	--[[calculate = function(self, card, context)
        if context.discard and not context.other_card.debuff and
        pseudorandom('guhadeen') < G.GAME.probabilities.normal/card.ability.extra.odds then -- the argument of pseudorandom is hashed and only for random seed, so every string is ok
				
			if not (context.card or {}).edition and (context.card or {}) ~= card then
				if not context.card.about_to_turn_forg_from_guha then
					context.card.about_to_turn_forg_from_guha = true
					card_eval_status_text(card, 'extra', nil, nil, nil, {
						message = context.card.ability.name == 'Burger' and 'Bouigah!' or 'Negation!',
						colour = G.C.DARK_EDITION,
					})
					G.E_MANAGER:add_event(Event({
						func = function()
							context.card.about_to_turn_forg_from_guha = nil
							context.card:set_edition({jen_forgotten = true}, true)
							return {
							message = guha_flavour[math.random(#guha_flavour)],
										--repetitions = 88,
										nopeus_again = true,
										colour = G.C.RED,
							card = card,
            				}
						end
					}))
				end
			end


						
            
        end
    end]]
}

local yatta_flavour = {'Candy!', 'CANDY!!', 'cANDY!!!'}

SMODS.Joker{ --yatta
    --name = "{C:chips}Y{}{C:mult}a{}{C:money}t{}{C:mult}t{}{C:chips}a{}",
    key = "yatta",
    config = {
        extra = 18
    },
    loc_txt = {
		name = '{C:chips}Y{}{C:mult}a{}{C:money}t{}{C:mult}t{}{C:chips}a{}',
		text = {
			'{C:attention}Wild Cards{} create a',
			'{C:attention}random {C:dark_edition}Negative{} consumable',
			'when scoring. Grants a {C:dark_edition}Negative{}',
			'{C:tarot}The Lovers{} on being added to the inventory.',
			lore('Crazy, generous, hyper, and loud.'),
			lore('(No wonder Millie loves her so goddamn much.)'),
			caption('Candy candy caNDY, CANDY FOR ALL!!!'),
			faceart('MillieAmp'),
			origin('Dandy\'s World')
		}
	},
    pos = {
        x = 0,
        y = 0
    },
	soul_pos = { x = 1, y = 0 },
    cost = 25,
    rarity = 4,
    blueprint_compat = true,
    eternal_compat = true,
	perishable_compat = false,
	immutable = true,

    enhancement_gate = 'm_wild',
    unlocked = true,
    discovered = true,
    atlas = 'mayyatta',

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.m_wild
        return {vars = {card.ability.extra}}
    end,

	add_to_deck = function(self,card)
		SMODS.add_card({set = 'Tarot', key = 'c_lovers', edition = 'e_negative'})
	end,
	
    calculate = function(self, card, context)
        if context.cardarea == G.play and context.individual and SMODS.get_enhancements(context.other_card)["m_wild"] == true then
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
						--play_sound('jen_draw')
						local card2 = create_card('Consumeables', G.consumeables, nil, nil, nil, nil, nil, 'moon_planet')
						if card.edition then
							card2:set_edition({negative = true}, true)
						end
						card2:add_to_deck()
						G.consumeables:emplace(card2)
						card:juice_up(0.3, 0.5)
					return {
						message = yatta_flavour[math.random(#yatta_flavour)],
						colour = G.C.EDITION,
						card = context.other_card,
            		}
				end }))
        end
    end
}


local gigi_blurbs = {'Yoink!', 'Gimme, gimme!', 'Gotcha!', 'Oh boy what did I get!?', 'Other Toons WISH they had this!',}

SMODS.Joker{ --yatta
    --name = "{C:chips}Y{}{C:mult}a{}{C:money}t{}{C:mult}t{}{C:chips}a{}",
    key = "gigi",
    loc_txt = {
		name = '{C:mult}G{}i{C:mult}g{}i',
		text = {
			'{C:attention}Capsules{} contain #1# more of their respective consumable.',
			'After a boss blind is defeated, grants a free',
			'{C:dark_edition}Jumbo Gacha Pack{}',
			lore('Laid-back and friendly, yet sneaky,'),
			lore('Gigi is a firm believer in finders-keepers.'),
			lore('(...Even if she finds something that doesn\'t belong to her.)'),
			caption('Don\'t look at me! I\'m an innocent bystander!'),
			faceart('MillieAmp'),
			origin('Dandy\'s World')
		}
	},
    pos = {
        x = 0,
        y = 0
    },
	soul_pos = { x = 1, y = 0 },
    cost = 25,
    rarity = 4,
    blueprint_compat = true,
    eternal_compat = true,
	perishable_compat = false,
	immutable = true,

    --enhancement_gate = 'm_wild',
    unlocked = true,
    discovered = true,
    atlas = 'maygigi',

    config = {modifier = 1},
	loc_vars = function(self, info_queue, center)
        return {vars = {center.ability.modifier}}
    end,

	calculate = function(self, card, context)
		if context.end_of_round and context.individual then
			if G.GAME.blind:get_type() == G.GAME.blind.boss then
				card:speak(gigi_blurbs, G.C.SECONDARY_SET.Mult)
				G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
				if G.consumeables.config.card_limit > #G.consumeables.cards then
				--play_sound('may_gachapon', 1.25, 0.4)
				local card = create_card("Booster", G.consumeables, nil, nil, nil, nil, 'p_may_jumbogacha1', "cap")
				card:add_to_deck()
				G.consumeables:emplace(card)
				used_tarot:juice_up(0.3, 0.5)
				end
				return true end }))

			end
		end
	end
}


local csar = Card.set_ability

function Card:set_ability(center,initial,delay_sprites)
	if self and self.gc then
		if self.added_to_deck and self:gc().unchangeable and not self.jen_ignoreunchangeable then
			return false
		end
	end
	csar(self,center,initial,delay_sprites)
	if #SMODS.find_card('j_may_gigi') > 0 and self.gc and self:gc().key ~= 'c_base' and string.sub(self:gc().key, 1, 10) == 'c_may_cap_' then
		local mod = 1
		for k, ponponpon in pairs(SMODS.find_card('j_may_gigi')) do
			mod = mod + (ponponpon.ability.modifier or 1)
		end
		local tbl = {min= mod, max = mod}
				Cryptid.misprintize(self, tbl, nil, true)
	end
end