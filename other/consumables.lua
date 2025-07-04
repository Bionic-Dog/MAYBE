--BASIC SHIT FROM JENS YAAAAAAAAAY

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



SMODS.Consumable {
	key = 'bygones',
	set = 'Spectral',
	loc_txt = {
		name = 'Bygones',
		text = {
			'Applies the Forgotten edition on up to #1# selected cards in your hand.',
			spriter('AnimatedGlitch')
		}
	},
	--set_card_type_badge = spiritcard,
	config = {max_highlighted = 2},
	pos = { x = 0, y = 0 },
	cost = 4,
	unlocked = true,
	discovered = true,
	atlas = 'mayacc2',
	hidden = false,
	soul_rate = 0.02,
    loc_vars = function(self, info_queue, center)
		if not center.edition or (center.edition and not center.edition.may_forgotten) then
			info_queue[#info_queue + 1] = G.P_CENTERS.e_may_forgotten
		end
		return { vars = { center.ability.max_highlighted } }
	end,
	can_use = function(self, card)
		return jl.canuse() and #G.hand.highlighted <= (card.ability.max_highlighted + (card.area == G.hand and 1 or 0)) and #G.hand.highlighted > (card.area == G.hand and 1 or 0)
	end,
	use = function(self, card, area, copier)
		if #G.hand.highlighted > 0 then
			for k, v in pairs(G.hand.highlighted) do
				v:set_edition({may_forgotten = true})
				Q(function() G.hand:remove_from_highlighted(v) return true end)
			end
		end
	end
}


 local blacklisted_editions = {
    "e_base", -- oops
    "e_jen_bloodfoil", "e_jen_blood", "e_jen_moire", -- "e_jen_unreal"
  }

   local blacklisted_enhancements = {
    "m_entr_disavowed", "m_mf_yucky"
  }
--
SMODS.Consumable {
	key = 'inspiration',
	set = 'Spectral',
	loc_txt = {
		name = 'Inspiration',
		text = {
			'For each card held in hand,',
			'there is a {C:green}#1# in #2#{} chance',
			'to apply a {C:dark_edition}completely random{}',
			'{C:edition}Edition{}, {C:edition}Enhancement{}, and/or {C:edition}Seal{}',
			spriter('MillieAmp')
		}
	},
	--set_card_type_badge = spiritcard,
	config={extra={odds=5}},
	pos = { x = 1, y = 0 },
	cost = 6,
	unlocked = true,
	discovered = true,
	atlas = 'mayacc2',
	hidden = false,
	soul_rate = 0.02,
    loc_vars=function(self,info_queue,center)
                return {vars={''..(G.GAME and G.GAME.probabilities.normal or 1), center.ability.extra.odds}}
            end,
	can_use = function(self, card)
		return #G.hand.cards > 0
	end,
	use = function(self, card, area, copier)


		for i = 1, #G.hand.cards do
			local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.15,
				func = function()
					G.hand.cards[i]:flip()
					play_sound("card1", percent)
					G.hand.cards[i]:juice_up(0.3, 0.3)
					return true
				end,
			}))
		end


		for i = 1, #G.hand.cards do
			--G.hand.cards[i]
			


			local CARD = G.hand.cards[i]
			local percent = 0.85 + (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.15,
				func = function()
					CARD:flip()
					
					if pseudorandom('inspiration_roll') < G.GAME.probabilities.normal/card.ability.extra.odds then
						local ed = pseudorandom_element(G.P_CENTER_POOLS.Enhanced)
								while ed.no_doe or G.GAME.banned_keys[ed.key] do
									ed = pseudorandom_element(G.P_CENTER_POOLS.Enhanced)
								end
								CARD:set_ability(ed)
					end
					if pseudorandom('inspiration_roll') < G.GAME.probabilities.normal/card.ability.extra.odds then
						local edition_pool = {}
							for _, ed in pairs(G.P_CENTER_POOLS["Edition"]) do
							for _, bl_ed in pairs(blacklisted_editions) do
								if ed.key == bl_ed then
								goto wof_continue
								end
							end
							edition_pool[#edition_pool + 1] = ed.key
							::wof_continue::
							end
							local edition = pseudorandom_element(edition_pool, pseudoseed("myriad_roll"))
							CARD:set_edition(edition, true)
					end
					if pseudorandom('inspiration_roll') < G.GAME.probabilities.normal/card.ability.extra.odds then
						CARD:set_seal(
							SMODS.poll_seal({ guaranteed = true, type_key = "styledcard" }),
							true,
							false
							)
					end

					play_sound("tarot2", percent)
					CARD:juice_up(0.3, 0.3)
					return true
				end,
			}))


		end	
	end
}


SMODS.Consumable {
	key = 'avarice',
	set = 'Spectral',
	loc_txt = {
		name = 'Avarice',
		text = {
			'Applies Investment on up to #1# selected cards',
			'in your hand, for {C:money}$5{} each.',
			'{C:inactive}Will not apply edition if you have less then {}{C:money}$5{}{C:inactive}!{}',
			spriter('MillieAmp')
		}
	},
	--set_card_type_badge = spiritcard,
	config = {max_highlighted = 4},
	pos = { x = 2, y = 0 },
	cost = 2,
	unlocked = true,
	discovered = true,
	atlas = 'mayacc2',
	hidden = false,
	soul_rate = 0.02,
    loc_vars = function(self, info_queue, center)
		if not center.edition or (center.edition and not center.edition.jen_investment) then
			info_queue[#info_queue + 1] = G.P_CENTERS.e_jen_investment
		end
		return { vars = { center.ability.max_highlighted } }
	end,
	can_use = function(self, card)
		return jl.canuse() and #G.hand.highlighted <= (card.ability.max_highlighted + (card.area == G.hand and 1 or 0)) and #G.hand.highlighted > (card.area == G.hand and 1 or 0)
	end,
	use = function(self, card, area, copier)
		if #G.hand.highlighted > 0 then
			for k, v in pairs(G.hand.highlighted) do
            local card_ref = v
            local cost = 5

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    if G.GAME.dollars >= to_big(cost) then
                        set_dollars(G.GAME.dollars - cost)
                        card_ref:set_edition({may_investment = true})
                        Q(function() G.hand:remove_from_highlighted(card_ref) return true end)
                    else
                    end

                    return true
                end
            }))
        end
		end
	end
}
















return init