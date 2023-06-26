--
-- ANCHOR: Loading nodes
--
-- Good book: https://rubenwardy.com/minetest_modding_book/en/index.html

print("MINETEST COMPUTER SYSTEMS VERSION 0.0.0")

-- https://minetest.gitlab.io/minetest/definition-tables/#item-definition
minetest.register_node("mcs:model1", {
    description = "MCS Model 1",
    paramtype2 = "facedir", -- facing player
    groups = { oddly_breakable_by_hand = 1 },
    -- Visual
    drawtype = "mesh",
    --inventory_image = "mymod_tool.png",
    tiles = { "model1_off.png" },
    use_texture_alpha = "clip",
    mesh = "model1.obj",
    -- Crafting
    type = "shaped",
    output = "mcs:model1",
    recipe = {
        { "default:dirt","default:dirt","default:dirt" },
        { "default:dirt","default:dirt","default:dirt" },
        { "default:dirt","default:dirt","default:dirt" },
    },
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        if clicker:is_player() then
            --minetest.chat_send_player(clicker:get_player_name(), "turn on")
            mcs.show_ui_to(clicker:get_player_name())
        end
    end,
    after_place_node = function(pos, placer, itemstack, pointed_thing)
        -- Make sure to check placer
        if placer and placer:is_player() then
            local meta = minetest.get_meta(pos)
            meta:set_string("owner", placer:get_player_name())
        end
    end,
})


-- TODO: sounds = mcs.startup() (with disk and stuff)
-- minetest.chat_send_all("test")
minetest.register_node("mcs:model1_on", {
    description = "MCS Model 1 On",
    paramtype2 = "facedir", -- facing player
    light_source = 6,
    groups = { oddly_breakable_by_hand = 1 },
    drawtype = "mesh",
    tiles = { "model1_on.png" },
    use_texture_alpha = "clip",
    mesh = "model1.obj",
    on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        if clicker:is_player() then
            --minetest.chat_send_player(clicker:get_player_name(), "turn on")
            mcs.show_ui_to(clicker:get_player_name())
        end
    end,
    after_place_node = function(pos, placer, itemstack, pointed_thing)
        -- Make sure to check placer
        if placer and placer:is_player() then
            local meta = minetest.get_meta(pos)
            meta:set_string("owner", placer:get_player_name())
        end
    end,
})

minetest.register_craft({
    type = "shapeless",
    output = "mcs:model1 1",
    recipe = { "default:dirt", "default:stone" },
})

minetest.register_alias("model1", "mcs:model1")

--
-- ANCHOR: Mod itself
--

mcs = {}

function mcs.make_ui(name)
    local text = "MCS Model 1"

    -- NOTE: CRINGE ALERT
    --       textarea needs tl
    local formspec = {
        "formspec_version[4]",
        "size[11,9]",
        "box[1,1;9,7;#000000]",
        "style_type[textarea;font=mono;font_size=20]",
        "textarea[1,1;9,7;;;wdadwawdawdawd]",
        "style_type[label;font=mono;font_size=18]",
        "label[0.375,8.5;", minetest.formspec_escape(text), "]",
        "style_type[button;bgcolor=red]",
        "button[9.1,8.1;0.8,0.8;;]"
    }

    -- table.concat is faster than string concatenation - `..`
    return table.concat(formspec, "")
end

function mcs.show_ui_to(name)
    minetest.show_formspec(name, "mcs:ui", mcs.make_ui(name))
end