local foods =
{
    beefnoodles =
    {
        test = function(cooker, names, tags)
            return (names.meat and names.meat and names.nightmarefuel and names.potato) and tags.meat and tags.meat >= 2.0 end,
        priority = 100,
        weight = 1,
        foodtype = FOODTYPE.MEAT,
        health = 150,
        hunger = 300,
        perishtime = TUNING.PERISH_SLOW,
        sanity = 120,
        cooktime = 2,
        floater = {"small", 0.05, 0.7},
        card_def = {ingredients = {{"meat", 2}, {"nightmarefuel", 2}, {"potato", 1}} },
    },
}

for k, v in pairs(foods) do
    v.name = k
    v.weight = v.weight or 1
    v.priority = v.priority or 0
    v.overridebuild = "beefnoodles"

    v.cookbook_category = "cookpot"
end

return foods
