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

SMODS.Sound({key = 'may_gachapon', path = 'may_gachapon.ogg'})

if May.config.icon_music then
	SMODS.Sound({
		key = "musicGacha",
		path = "musicGacha.ogg",
		pitch = 1,
		select_music_track = function()
			return ((SMODS.OPENED_BOOSTER or {}).ability or {}).gacha_pack and G.booster_pack and not G.booster_pack.REMOVED
		end,
	})
end

SMODS.Atlas {
	key = 'gachapack',
	px = 71,
	py = 95,
	path = May.config.texture_pack .. '/p_may_gachapacks.png'
}

for i = 1, 4 do
	SMODS.Booster{
		key = 'gacha' .. i,
		loc_txt = {
			name = 'Gacha Pack',
			text = {
				'Choose {C:attention}#1#{} of up to',
				'{C:attention}#2# Capsules{} to',
				'add to your deck',
				spriter('MillieAmp')
			}
		},
		atlas = 'gachapack',
		pos = {x = i - 1, y = 0},
		weight = 4,
		cost = 1,
		config = {extra = 2, choose = 1, gacha_pack = true},
		discovered = true,
		loc_vars = function(self, info_queue, card)
			return { vars = {card.ability.choose, card.ability.extra} }
		end,
        ease_background_colour = function(self) ease_background_colour_blind(G.STATES.STANDARD_PACK) end,
        create_UIBox = function(self) return create_UIBox_standard_pack() end,
        particles = function(self)
            G.booster_pack_sparkles = Particles(1, 1, 0,0, {
                timer = 0.015,
                scale = 0.3,
                initialize = true,
                lifespan = 3,
                speed = 0.2,
                padding = -1,
                attach = G.ROOM_ATTACH,
                colours = {G.C.BLACK, G.C.RED},
                fill = true
            })
            G.booster_pack_sparkles.fade_alpha = 1
            G.booster_pack_sparkles:fade(1, 0)
        end,
        create_card = function(self, card, i)
            local _card
            _card = {set = "Capsule", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "ar1"}
            return _card
        end
	}
end

for i = 1, 2 do
	SMODS.Booster{
		key = 'jumbogacha' .. i,
		loc_txt = {
			name = 'Jumbo Gacha Pack',
			text = {
				'Choose {C:attention}#1#{} of up to',
				'{C:attention}#2# Capsules{} to',
				'add to your deck',
				spriter('MillieAmp')
			}
		},
		atlas = 'gachapack',
		pos = {x = i - 1, y = 1},
		weight = .8,
		cost = 2,
		config = {extra = 4, choose = 1, gacha_pack = true},
		discovered = true,
		loc_vars = function(self, info_queue, card)
			return { vars = {card.ability.choose, card.ability.extra} }
		end,
        ease_background_colour = function(self) ease_background_colour_blind(G.STATES.STANDARD_PACK) end,
        create_UIBox = function(self) return create_UIBox_standard_pack() end,
        particles = function(self)
            G.booster_pack_sparkles = Particles(1, 1, 0,0, {
                timer = 0.015,
                scale = 0.3,
                initialize = true,
                lifespan = 3,
                speed = 0.2,
                padding = -1,
                attach = G.ROOM_ATTACH,
                colours = {G.C.BLACK, G.C.RED},
                fill = true
            })
            G.booster_pack_sparkles.fade_alpha = 1
            G.booster_pack_sparkles:fade(1, 0)
        end,
        create_card = function(self, card, i)
            local _card
            _card = {set = "Capsule", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "ar1"}
            return _card
        end
	}
end

for i = 1, 2 do
	SMODS.Booster{
		key = 'megagacha' .. i,
		loc_txt = {
			name = 'Mega Gacha Pack',
			text = {
				'Choose {C:attention}#1#{} of up to',
				'{C:attention}#2# Capsules{} to',
				'add to your deck',
				spriter('MillieAmp')
			}
		},
		atlas = 'gachapack',
		pos = {x = (i - 1)+2, y = 1},
		weight = .5,
		cost = 3,
		config = {extra = 6, choose = 2, gacha_pack = true},
		discovered = true,
		loc_vars = function(self, info_queue, card)
			return { vars = {card.ability.choose, card.ability.extra} }
		end,
        ease_background_colour = function(self) ease_background_colour_blind(G.STATES.STANDARD_PACK) end,
        create_UIBox = function(self) return create_UIBox_standard_pack() end,
        particles = function(self)
            G.booster_pack_sparkles = Particles(1, 1, 0,0, {
                timer = 0.015,
                scale = 0.3,
                initialize = true,
                lifespan = 3,
                speed = 0.2,
                padding = -1,
                attach = G.ROOM_ATTACH,
                colours = {G.C.BLACK, G.C.RED},
                fill = true
            })
            G.booster_pack_sparkles.fade_alpha = 1
            G.booster_pack_sparkles:fade(1, 0)
        end,
        create_card = function(self, card, i)
            local _card
            _card = {set = "Capsule", area = G.pack_cards, skip_materialize = true, soulable = true, key_append = "ar1"}
            return _card
        end
	}
end

--CAPSULES

SMODS.ConsumableType {
	key = 'Capsule',
	collection_rows = {8, 8},
	primary_colour = G.C.CHIPS,
	secondary_colour = G.C.VOUCHER,
	default = 'c_may_cap_tarot',
	loc_txt = {
		collection = 'Capsules',
		name = 'Capsule'
	},
	shop_rate = 3
}

SMODS.UndiscoveredSprite({
    key = "Capsule",
    atlas = "may_lockedgacha",
    path = "may_lockedgacha.png",
    pos = { x = 1, y = 0 },
	soul_pos = { x = 0, y = 0 },
    px = 71,
    py = 95,
  })

SMODS.Consumable {
	key = 'cap_tarot',
	set = 'Capsule',
	loc_txt = {
		name = 'Magic Capsule',
		text = {
			'Grants #1# random {C:tarot}Tarot{} card(s).',
			'{C:inactive}(Must have room)',
			spriter('MillieAmp')
		}
	},
	--set_card_type_badge = spiritcard,
	config = {
      val = 1,
    },
	pos = { x = 1, y = 0 },
	soul_pos = { x = 0, y = 0 },
	cost = 1,
	unlocked = true,
	discovered = true,
	atlas = 'maygacha',
	hidden = false,
	soul_rate = 0.02,
    can_use = function(self, card)
      return #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
    end,
    use = function(self, card, area, copier)
      local used_tarot = copier or card
      for i = 1, math.min(card.ability.val, G.consumeables.config.card_limit - #G.consumeables.cards) do
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
          if G.consumeables.config.card_limit > #G.consumeables.cards then
            play_sound('may_gachapon', 1.25, 0.4)
            local card = create_card("Tarot", G.consumeables, nil, nil, nil, nil, nil, "cap")
            card:add_to_deck()
            G.consumeables:emplace(card)
            used_tarot:juice_up(0.3, 0.5)
          end
          return true end }))
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      return { vars = {card.ability.val} }
    end
}

SMODS.Consumable {
	key = 'cap_planet',
	set = 'Capsule',
	loc_txt = {
		name = 'Astro Capsule',
		text = {
			'Grants #1# random {C:planet}Planet{} card(s).',
			'{C:inactive}(Must have room)',
			spriter('MillieAmp')
		}
	},
	--set_card_type_badge = spiritcard,
	config = {
      val = 1,
    },
	pos = { x = 1, y = 1 },
	soul_pos = { x = 0, y = 1 },
	cost = 1,
	unlocked = true,
	discovered = true,
	atlas = 'maygacha',
	hidden = false,
	soul_rate = 0.02,
    can_use = function(self, card)
      return #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
    end,
    use = function(self, card, area, copier)
      local used_tarot = copier or card
      for i = 1, math.min(card.ability.val, G.consumeables.config.card_limit - #G.consumeables.cards) do
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
          if G.consumeables.config.card_limit > #G.consumeables.cards then
            play_sound('may_gachapon', 1.25, 0.4)
            local card = create_card("Planet", G.consumeables, nil, nil, nil, nil, nil, "cap")
            card:add_to_deck()
            G.consumeables:emplace(card)
            used_tarot:juice_up(0.3, 0.5)
          end
          return true end }))
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      return { vars = {card.ability.val} }
    end
}

SMODS.Consumable {
	key = 'cap_spectral',
	set = 'Capsule',
	loc_txt = {
		name = 'Spook Capsule',
		text = {
			'Grants #1# random {C:spectral}Spectral{} card(s).',
			'{C:inactive}(Must have room)',
			spriter('MillieAmp')
		}
	},
	--set_card_type_badge = spiritcard,
	config = {
      val = 1,
    },
	pos = { x = 1, y = 2 },
	soul_pos = { x = 0, y = 2 },
	cost = 2,
	unlocked = true,
	discovered = true,
	atlas = 'maygacha',
	hidden = false,
	soul_rate = 0.02,
    can_use = function(self, card)
      return #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
    end,
    use = function(self, card, area, copier)
      local used_tarot = copier or card
      for i = 1, math.min(card.ability.val, G.consumeables.config.card_limit - #G.consumeables.cards) do
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
          if G.consumeables.config.card_limit > #G.consumeables.cards then
            play_sound('may_gachapon', 1.25, 0.4)
            local card = create_card("Spectral", G.consumeables, nil, nil, nil, nil, nil, "cap")
            card:add_to_deck()
            G.consumeables:emplace(card)
            used_tarot:juice_up(0.3, 0.5)
          end
          return true end }))
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      return { vars = {card.ability.val} }
    end
}


SMODS.Consumable {
	key = 'cap_code',
	set = 'Capsule',
	loc_txt = {
		name = 'Array Capsule',
		text = {
			'Grants #1# random {C:code}Code{} card(s).',
			'{C:inactive}(Must have room)',
			spriter('MillieAmp')
		}
	},
	--set_card_type_badge = spiritcard,
	config = {
      val = 1,
    },
	pos = { x = 1, y = 3 },
	soul_pos = { x = 0, y = 3 },
	cost = 1,
	unlocked = true,
	discovered = true,
	atlas = 'maygacha',
	hidden = false,
	soul_rate = 0.02,
    can_use = function(self, card)
      return #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
    end,
    use = function(self, card, area, copier)
      local used_tarot = copier or card
      for i = 1, math.min(card.ability.val, G.consumeables.config.card_limit - #G.consumeables.cards) do
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
          if G.consumeables.config.card_limit > #G.consumeables.cards then
            play_sound('may_gachapon', 1.25, 0.4)
            local card = create_card("Code", G.consumeables, nil, nil, nil, nil, nil, "cap")
            card:add_to_deck()
            G.consumeables:emplace(card)
            used_tarot:juice_up(0.3, 0.5)
          end
          return true end }))
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      return { vars = {card.ability.val} }
    end
}


--G.C.BUNCO_VIRTUAL_DARK
if next(SMODS.find_mod("jen")) then
  SMODS.Consumable {
	key = 'cap_token',
	set = 'Capsule',
	loc_txt = {
		name = 'Guest Capsule',
		text = {
			'Grants #1# random {C:attention}Token(s){}.',
			'{C:inactive}(Must have room)',
			spriter('MillieAmp')
		}
	},
	--set_card_type_badge = spiritcard,
	config = {
      val = 1,
    },
	pos = { x = 3, y = 0 },
	soul_pos = { x = 2, y = 0 },
	cost = 2,
	unlocked = true,
	discovered = true,
	atlas = 'maygacha',
	hidden = false,
	soul_rate = 0.02,
    can_use = function(self, card)
      return #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
    end,
    use = function(self, card, area, copier)
      local used_tarot = copier or card
      for i = 1, math.min(card.ability.val, G.consumeables.config.card_limit - #G.consumeables.cards) do
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
          if G.consumeables.config.card_limit > #G.consumeables.cards then
            play_sound('may_gachapon', 1.25, 0.4)
            local card = create_card("jen_tokens", G.consumeables, nil, nil, nil, nil, nil, "cap")
            card:add_to_deck()
            G.consumeables:emplace(card)
            used_tarot:juice_up(0.3, 0.5)
          end
          return true end }))
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      return { vars = {card.ability.val} }
    end
}

SMODS.Consumable {
	key = 'cap_uno',
	set = 'Capsule',
	loc_txt = {
		name = 'Single Capsule',
		text = {
			'Grants #1# random {C:dark_edition}Uno{} card(s).',
			'{C:inactive}(Must have room)',
			spriter('MillieAmp')
		}
	},
	--set_card_type_badge = spiritcard,
	config = {
      val = 1,
    },
	pos = { x = 5, y = 0 },
	soul_pos = { x = 4, y = 0 },
	cost = 2,
	unlocked = true,
	discovered = true,
	atlas = 'maygacha',
	hidden = false,
	soul_rate = 0.02,
    can_use = function(self, card)
      return #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
    end,
    use = function(self, card, area, copier)
      local used_tarot = copier or card
      for i = 1, math.min(card.ability.val, G.consumeables.config.card_limit - #G.consumeables.cards) do
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
          if G.consumeables.config.card_limit > #G.consumeables.cards then
            play_sound('may_gachapon', 1.25, 0.4)
            local card = create_card('jen_uno', G.consumeables, nil, nil, nil, nil, nil, "cap")
            card:add_to_deck()
            G.consumeables:emplace(card)
            used_tarot:juice_up(0.3, 0.5)
          end
          return true end }))
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      return { vars = {card.ability.val} }
    end
}

  


end

--
if next(SMODS.find_mod("Bunco")) then
  SMODS.Consumable {
	key = 'cap_polymino',
	set = 'Capsule',
	loc_txt = {
		name = 'Block Capsule',
		text = {
			'Grants #1# random {C:dark_edition}Polymino(s){}.',
			'{C:inactive}(Must have room)',
			spriter('MillieAmp')
		}
	},
	--set_card_type_badge = spiritcard,
	config = {
      val = 1,
    },
	pos = { x = 3, y = 0 },
	soul_pos = { x = 2, y = 0 },
	cost = 2,
	unlocked = true,
	discovered = true,
	atlas = 'maygacha',
	hidden = false,
	soul_rate = 0.02,
    can_use = function(self, card)
      return #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
    end,
    use = function(self, card, area, copier)
      local used_tarot = copier or card
      for i = 1, math.min(card.ability.val, G.consumeables.config.card_limit - #G.consumeables.cards) do
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
          if G.consumeables.config.card_limit > #G.consumeables.cards then
            play_sound('may_gachapon', 1.25, 0.4)
            local card = create_card("Polymino", G.consumeables, nil, nil, nil, nil, nil, "cap")
            card:add_to_deck()
            G.consumeables:emplace(card)
            used_tarot:juice_up(0.3, 0.5)
          end
          return true end }))
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      return { vars = {card.ability.val} }
    end
  }    
end



--
if next(SMODS.find_mod("MoreFluff")) then
  SMODS.Consumable {
	key = 'cap_color',
	set = 'Capsule',
	loc_txt = {
		name = 'Swatch Capsule',
		text = {
			'Grants #1# random {C:colourcard}Color{} card(s).',
			'{C:inactive}(Must have room)',
			spriter('MillieAmp')
		}
	},
	--set_card_type_badge = spiritcard,
	config = {
      val = 1,
    },
	pos = { x = 5, y = 1 },
	soul_pos = { x = 4, y = 1 },
	cost = 2,
	unlocked = true,
	discovered = true,
	atlas = 'maygacha',
	hidden = false,
	soul_rate = 0.02,
    can_use = function(self, card)
      return #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
    end,
    use = function(self, card, area, copier)
      local used_tarot = copier or card
      for i = 1, math.min(card.ability.val, G.consumeables.config.card_limit - #G.consumeables.cards) do
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
          if G.consumeables.config.card_limit > #G.consumeables.cards then
            play_sound('may_gachapon', 1.25, 0.4)
            local card = create_card("Colour", G.consumeables, nil, nil, nil, nil, nil, "cap")
            card:add_to_deck()
            G.consumeables:emplace(card)
            used_tarot:juice_up(0.3, 0.5)
          end
          return true end }))
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      return { vars = {card.ability.val} }
    end
  }    

  SMODS.Consumable {
	key = 'cap_rotarot',
	set = 'Capsule',
	loc_txt = {
		name = 'Magic Capsule!',
		text = {
			'Grants #1# random {C:rotarot}45-Degree Rotated Tarot{} card(s).',
			'{C:inactive}(Must have room)',
			spriter('MillieAmp')
		}
	},
	--set_card_type_badge = spiritcard,
	config = {
      val = 1,
    },
	pos = { x = 5, y = 2 },
	soul_pos = { x = 4, y = 2 },
	cost = 1,
	unlocked = true,
	discovered = true,
	atlas = 'maygacha',
	hidden = false,
	soul_rate = 0.02,
    can_use = function(self, card)
      return #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
    end,
    use = function(self, card, area, copier)
      local used_tarot = copier or card
      for i = 1, math.min(card.ability.val, G.consumeables.config.card_limit - #G.consumeables.cards) do
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
          if G.consumeables.config.card_limit > #G.consumeables.cards then
            play_sound('may_gachapon', 1.25, 0.4)
            local card = create_card("Rotarot", G.consumeables, nil, nil, nil, nil, nil, "cap")
            card:add_to_deck()
            G.consumeables:emplace(card)
            used_tarot:juice_up(0.3, 0.5)
          end
          return true end }))
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      return { vars = {card.ability.val} }
    end
  }    
end













if next(SMODS.find_mod("GrabBag")) then
  SMODS.Consumable {
	key = 'cap_ephemeral',
	set = 'Capsule',
	loc_txt = {
		name = 'Transient Capsule',
		text = {
			'Grants #1# random {C:dark_edition}Ephemeral{} card(s).',
			'{C:inactive}(Must have room)',
			spriter('MillieAmp')
		}
	},
	--set_card_type_badge = spiritcard,
	config = {
      val = 1,
    },
	pos = { x = 5, y = 3 },
	soul_pos = { x = 4, y = 3 },
	cost = 2,
	unlocked = true,
	discovered = true,
	atlas = 'maygacha',
	hidden = false,
	soul_rate = 0.02,
    can_use = function(self, card)
      return #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
    end,
    use = function(self, card, area, copier)
      local used_tarot = copier or card
      for i = 1, math.min(card.ability.val, G.consumeables.config.card_limit - #G.consumeables.cards) do
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
          if G.consumeables.config.card_limit > #G.consumeables.cards then
            play_sound('may_gachapon', 1.25, 0.4)
            local card = create_card("Ephemeral", G.consumeables, nil, nil, nil, nil, nil, "cap")
            card:add_to_deck()
            G.consumeables:emplace(card)
            used_tarot:juice_up(0.3, 0.5)
          end
          return true end }))
      end
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      return { vars = {card.ability.val} }
    end
  }    
end




--inversionssss
--[[
dependencies = {
        items = {
            "set_entr_inversions"
        }
    },
    config = {
        create = 2
    },
    inversion = "c_magician",
]]


























if next(SMODS.find_mod("entr")) then

  --INVERSE ONESSSS




  SMODS.Consumable {
    key = 'cap_untarot',
    dependencies = {
        items = {
          "set_entr_inversions",
        }
    },
    inversion = "c_may_cap_tarot",
    set = 'Capsule',
    loc_txt = {
      name = 'Trick Capsule',
      text = {
        'Grants #1# random {C:red}Fraud{} card(s).',
        '{C:inactive}(Must have room)',
        spriter('MillieAmp')
      }
    },
    --set_card_type_badge = spiritcard,
    config = {
        val = 1,
      },
    pos = { x = 1, y = 0 },
    soul_pos = { x = 0, y = 0 },
    cost = 1,
    unlocked = true,
    discovered = true,
    atlas = 'maygacha2',
    hidden = true,
    --soul_rate = 0.02,
      can_use = function(self, card)
        return #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
      end,
      use = function(self, card, area, copier)
        local used_tarot = copier or card
        for i = 1, math.min(card.ability.val, G.consumeables.config.card_limit - #G.consumeables.cards) do
          G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            if G.consumeables.config.card_limit > #G.consumeables.cards then
              play_sound('may_gachapon', 1.25, 0.4)
              local card = create_card("Fraud", G.consumeables, nil, nil, nil, nil, nil, "cap")
              card:add_to_deck()
              G.consumeables:emplace(card)
              used_tarot:juice_up(0.3, 0.5)
            end
            return true end }))
        end
        delay(0.6)
      end,
      loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.val} }
      end
  }

  SMODS.Consumable {
    key = 'cap_unplanet',
    dependencies = {
        items = {
          "set_entr_inversions",
        }
    },
    inversion = "c_may_cap_planet",
    set = 'Capsule',
    loc_txt = {
      name = 'Nova Capsule',
      text = {
        'Grants #1# random {C:red}Star{} card(s).',
        '{C:inactive}(Must have room)',
        spriter('MillieAmp')
      }
    },
    --set_card_type_badge = spiritcard,
    config = {
        val = 1,
      },
    pos = { x = 1, y = 1 },
    soul_pos = { x = 0, y = 1 },
    cost = 1,
    unlocked = true,
    discovered = true,
    atlas = 'maygacha2',
    hidden = true,
    --soul_rate = 0.02,
      can_use = function(self, card)
        return #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
      end,
      use = function(self, card, area, copier)
        local used_tarot = copier or card
        for i = 1, math.min(card.ability.val, G.consumeables.config.card_limit - #G.consumeables.cards) do
          G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            if G.consumeables.config.card_limit > #G.consumeables.cards then
              play_sound('may_gachapon', 1.25, 0.4)
              local card = create_card("Star", G.consumeables, nil, nil, nil, nil, nil, "cap")
              card:add_to_deck()
              G.consumeables:emplace(card)
              used_tarot:juice_up(0.3, 0.5)
            end
            return true end }))
        end
        delay(0.6)
      end,
      loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.val} }
      end
  }

  SMODS.Consumable {
    key = 'cap_unspectral',
    dependencies = {
        items = {
          "set_entr_inversions",
        }
    },
    inversion = "c_may_cap_spectral",
    set = 'Capsule',
    loc_txt = {
      name = 'Creepy Capsule',
      text = {
        'Grants #1# random {C:red}Omen{} card(s).',
        '{C:inactive}(Must have room)',
        spriter('MillieAmp')
      }
    },
    --set_card_type_badge = spiritcard,
    config = {
        val = 1,
      },
    pos = { x = 1, y = 2 },
    soul_pos = { x = 0, y = 2 },
    cost = 2,
    unlocked = true,
    discovered = true,
    atlas = 'maygacha2',
    hidden = true,
    --soul_rate = 0.02,
      can_use = function(self, card)
        return #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
      end,
      use = function(self, card, area, copier)
        local used_tarot = copier or card
        for i = 1, math.min(card.ability.val, G.consumeables.config.card_limit - #G.consumeables.cards) do
          G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            if G.consumeables.config.card_limit > #G.consumeables.cards then
              play_sound('may_gachapon', 1.25, 0.4)
              local card = create_card("Omen", G.consumeables, nil, nil, nil, nil, nil, "cap")
              card:add_to_deck()
              G.consumeables:emplace(card)
              used_tarot:juice_up(0.3, 0.5)
            end
            return true end }))
        end
        delay(0.6)
      end,
      loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.val} }
      end
  }


  SMODS.Consumable {
    key = 'cap_uncode',
    dependencies = {
        items = {
          "set_entr_inversions",
        }
    },
    inversion = "c_may_cap_code",
    set = 'Capsule',
    loc_txt = {
      name = 'Prompt Capsule',
      text = {
        'Grants #1# random {C:red}Command{} card(s).',
        '{C:inactive}(Must have room)',
        spriter('MillieAmp')
      }
    },
    --set_card_type_badge = spiritcard,
    config = {
        val = 1,
      },
    pos = { x = 1, y = 3 },
    soul_pos = { x = 0, y = 3 },
    cost = 1,
    unlocked = true,
    discovered = true,
    atlas = 'maygacha2',
    hidden = true,
    --soul_rate = 0.02,
      can_use = function(self, card)
        return #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
      end,
      use = function(self, card, area, copier)
        local used_tarot = copier or card
        for i = 1, math.min(card.ability.val, G.consumeables.config.card_limit - #G.consumeables.cards) do
          G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            if G.consumeables.config.card_limit > #G.consumeables.cards then
              play_sound('may_gachapon', 1.25, 0.4)
              local card = create_card("Command", G.consumeables, nil, nil, nil, nil, nil, "cap")
              card:add_to_deck()
              G.consumeables:emplace(card)
              used_tarot:juice_up(0.3, 0.5)
            end
            return true end }))
        end
        delay(0.6)
      end,
      loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.val} }
      end
  }


  if next(SMODS.find_mod("jen")) then


    local blacklisted_editions = {
    "e_base", -- oops
    --"e_jen_bloodfoil", "e_jen_blood", "e_jen_moire", -- "e_jen_unreal"  --:3
    }


    SMODS.Consumable {
    key = 'cap_untoken',
    dependencies = {
        items = {
          "set_entr_inversions",
        }
    },
    inversion = "c_may_cap_token",
    set = 'Capsule',
    loc_txt = {
      name = 'Gift Capsule',
      text = {
        'Grants #1# random {C:attention}Booster Pack(s){}.',
        '{C:inactive}(Must have room)',
        spriter('MillieAmp')
      }
    },
    --set_card_type_badge = spiritcard,
    config = {
        val = 1,
      },
    pos = { x = 3, y = 2 },
    soul_pos = { x = 2, y = 2 },
    cost = 2,
    unlocked = true,
    discovered = true,
    atlas = 'maygacha2',
    hidden = true,
    soul_set = 'Capsule',
    soul_rate = 0.05,
      can_use = function(self, card)
        return #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
      end,
      use = function(self, card, area, copier)
        local used_tarot = copier or card
        for i = 1, math.min(card.ability.val, G.consumeables.config.card_limit - #G.consumeables.cards) do
          G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            if G.consumeables.config.card_limit > #G.consumeables.cards then
              play_sound('may_gachapon', 1.25, 0.4)
              local card = create_card("Booster", G.consumeables, nil, nil, nil, nil, nil, "cap")
              card:add_to_deck()
              G.consumeables:emplace(card)
              used_tarot:juice_up(0.3, 0.5)
            end
            return true end }))
        end
        delay(0.6)
      end,
      loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.val} }
      end
    }

    SMODS.Consumable {
    key = 'cap_ununo',
    dependencies = {
        items = {
          "set_entr_inversions",
        }
    },
    inversion = "c_may_cap_uno",
    set = 'Capsule',
    loc_txt = {
      name = 'Myriad Capsule',
      text = {
        'Grants #1# random {C:inactive}Nil{}-suited playing card(s){}',
        'with a random enhancement.',
        'Fixed 50% chance to also gain a random edition.',
        'Fixed 50% chance to also gain a random seal.',
        '{C:inactive}(All editions and enhancements weighted equally!)',
        --'{C:inactive}(Must have room)',
        spriter('MillieAmp')
      }
    },
    --set_card_type_badge = spiritcard,
    config = {
        val = 1,
      },
    pos = { x = 3, y = 1 },
    soul_pos = { x = 2, y = 1 },
    cost = 2,
    unlocked = true,
    discovered = true,
    atlas = 'maygacha2',
    hidden = true,
    --soul_rate = 0.02,
      can_use = function(self, card)
        return #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
      end,
      use = function(self, card, area, copier)
        local used_tarot = copier or card
        local target_area = G.hand
            if G.STATE == G.STATES.BLIND_SELECT or G.STATE == G.STATES.ROUND_EVAL then
              target_area = G.deck
            end
            G.E_MANAGER:add_event(Event({
              trigger = 'after',
              delay = 0.7,
              func = function() 
                play_sound('may_gachapon', 1.25, 0.4)
                used_tarot:juice_up(0.3, 0.5)
                local cards = {}
                for i = 1, card.ability.val do
                  cards[i] = true
                  local _suit, _rank = nil, nil
                  _rank = pseudorandom_element({'A', '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K'}, pseudoseed('suitarot'))
                  _suit = "entr_nilsuit"
                  local cen_pool = {}
                  for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                    if v.key ~= 'm_stone' and not v.overrides_base_rank then 
                      cen_pool[#cen_pool+1] = v
                    end
                  end
                  local new = create_playing_card({front = G.P_CARDS[_suit..'_'.._rank], center = pseudorandom_element(cen_pool, pseudoseed('suitarot'))}, target_area, nil, i ~= 1, {G.C.SECONDARY_SET.Rotarot})
                  if jl.chance('myriad_ed', 2, true) then
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
                    new:set_edition(edition, true)
                  end
                  if(jl.chance('myriad_seal', 2, true)) then
                    new:set_seal(
                      SMODS.poll_seal({ guaranteed = true, type_key = "styledcard" }),
                      true,
                      false
                    )
                  end

                end
                playing_card_joker_effects(cards)
                return true end }))

        delay(0.6)
      end,
      loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.val} }
      end
    }
  end


  if next(SMODS.find_mod("MoreFluff")) then
    SMODS.Consumable {
    key = 'cap_uncolor',
    dependencies = {
        items = {
          "set_entr_inversions",
        }
    },
    inversion = "c_may_cap_color",
    set = 'Capsule',
    loc_txt = {
      name = 'Design Capsule',
      text = {
        'Grants #1# random {C:shape}Shape{} card(s).',
        '{C:inactive}(Must have room)',
        spriter('MillieAmp')
      }
    },
    --set_card_type_badge = spiritcard,
    config = {
        val = 1,
      },
    pos = { x = 3, y = 0 },
    soul_pos = { x = 2, y = 0 },
    cost = 2,
    unlocked = true,
    discovered = true,
    atlas = 'maygacha2',
    hidden = true,
    --soul_rate = 0.02,
      can_use = function(self, card)
        return #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
      end,
      use = function(self, card, area, copier)
        local used_tarot = copier or card
        for i = 1, math.min(card.ability.val, G.consumeables.config.card_limit - #G.consumeables.cards) do
          G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            if G.consumeables.config.card_limit > #G.consumeables.cards then
              play_sound('may_gachapon', 1.25, 0.4)
              local card = create_card("Shape", G.consumeables, nil, nil, nil, nil, nil, "cap")
              card:add_to_deck()
              G.consumeables:emplace(card)
              used_tarot:juice_up(0.3, 0.5)
            end
            return true end }))
        end
        delay(0.6)
      end,
      loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.val} }
      end
    }  
  end





end








SMODS.Consumable {
	key = 'cap_recursive',
	set = 'Capsule',
	loc_txt = {
		name = 'Capsule Capsule',
		text = {
			'Grants #1# random {C:rotarot}Capsule(s){}.',
      'Fixed 50% chance to contain an additional copy of itself.',
			'{C:inactive}(Must have room)',
			spriter('MillieAmp')
		}
	},
	--set_card_type_badge = spiritcard,
	config = {
      val = 1,
    },
	pos = { x = 3, y = 2 },
	soul_pos = { x = 2, y = 2 },
	cost = 1,
	unlocked = true,
	discovered = true,
	atlas = 'maygacha',
	hidden = true,
  soul_set = 'Capsule',
	soul_rate = 0.05,
    can_use = function(self, card)
      return #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
    end,
    use = function(self, card, area, copier)
      local used_tarot = copier or card
      for i = 1, math.min(card.ability.val, G.consumeables.config.card_limit - #G.consumeables.cards) do
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
          if G.consumeables.config.card_limit > #G.consumeables.cards then
            play_sound('may_gachapon', 1.25, 0.4)
            local card = create_card("Capsule", G.consumeables, nil, nil, nil, nil, nil, "cap")
            card:add_to_deck()
            G.consumeables:emplace(card)
            used_tarot:juice_up(0.3, 0.5)
          end
          return true end }))
      end
      G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
          if G.consumeables.config.card_limit > #G.consumeables.cards and jl.chance('capcap_duplicate', 2, true) then
            play_sound('may_gachapon', 1.25, 0.4)
            local dupe = copy_card(used_tarot)
						dupe:start_materialize()
						dupe:add_to_deck()
            --card2:add_to_deck()
            G.consumeables:emplace(dupe)
            used_tarot:juice_up(0.3, 0.5)
          end
          return true end }))
      delay(0.6)
    end,
    loc_vars = function(self, info_queue, card)
      return { vars = {card.ability.val} }
    end
}    













return init