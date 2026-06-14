GLOBAL.setmetatable(env, {__index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end})
PrefabFiles =
{
    "beefnoodles"
}

STRINGS.NAMES.BEEFNOODLES = "牛排意大利面" --物品名称
STRINGS.RECIPE_DESC.BEEFNOODLES = "--当你把它塞进背包时，能清晰地听到理智值在尖叫,牛排的焦香里混着一丝不可名状的甜腻，意面则像被触手卷过一样缠成一团,吃下去的瞬间，你会获得短暂的饱腹感，以及对“这玩意儿真的能吃吗”的深刻哲学思考。"   --描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BEEFNOODLES = "你们这群乡巴佬一辈子吃不起的牛排"  --角色对物品描述

local foods = require("beefnoodles")
for k,recipe in pairs (foods) do
    AddCookerRecipe("cookpot", recipe)
end