local CONSTANTS = require("common.constants")

local lib_technologies = require("lib.technologies")

local ban_map = {}
for name, technology in pairs(prototypes.technology) do
    if technology.effects then
        for _, effect in ipairs(technology.effects) do
            if effect.type == "nothing" and effect.effect_description and effect.effect_description[1] and effect.effect_description[1] == CONSTANTS.mod_name .. "-disable-with" then
                ban_map[effect.effect_description[2]] = ban_map[effect.effect_description[2]] or {}
                ban_map[effect.effect_description[2]][name] = true
            end
        end
    end
end

event_lib.add_lib({
    events = {
        on_research_finished = function(event)
            if ban_map[event.research.name] ~= nil then
                for technology, _ in pairs(ban_map[event.research.name]) do
                    event.research.force.technologies[technology].enabled = false
                end
                -- Also fix research queue
                local new_research_queue = {}
                for _, research in ipairs(event.research.force.research_queue) do
                    if not ban_map[event.research.name][research.name] then
                        table.insert(new_research_queue, research)
                    end
                end
                event.research.force.research_queue = new_research_queue
            end
        end
    },
    on_nth_tick = {
        [60] = function()
            -- Enforce technology disabling in case of other mod interference
            for _, force in pairs(game.forces) do
                local changed_something = false
                for source, ban_list in pairs(ban_map) do
                    if force.technologies[source] and (force.technologies[source].researched or force.technologies[source].level > lib_technologies.get_technology_level(force.technologies[source].prototype)) then
                        for technology, _ in pairs(ban_list) do
                            if force.technologies[technology] and force.technologies[technology].enabled then
                                force.technologies[technology].enabled = false
                                changed_something = true
                            end
                        end
                    end
                end
                -- Revalidate queue if something changed
                if changed_something then
                    local new_research_queue = {}
                    for _, research in ipairs(force.research_queue) do
                        if research.enabled then
                            table.insert(new_research_queue, research)
                        end
                    end
                    force.research_queue = new_research_queue
                end
            end
        end
    }
})