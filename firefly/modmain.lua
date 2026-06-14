GLOBAL.setmetatable(env, {__index = function(t, k) return GLOBAL.rawget(GLOBAL, k) end})
PrefabFiles =
{
"firefly"
}

STRINGS.NAMES.FIREFLY = "梦该归于何处" --物品名称
STRINGS.RECIPE_DESC.FIREFLY = "Strategic Assault Mech"   --描述
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FIREFLY = "飞蛾扑火,向死而生"  --角色对物品描述


AddRecipe2(--制作函数 
    "firefly",--    绿宝石                    充能月亮碎片                        萤火虫                   月娥                            纯粹辉煌                      步行手杖               月熠                             火花柜
    {Ingredient("greengem",5),Ingredient("moonglass_charged",30),Ingredient("fireflies",30),Ingredient("moonbutterfly",20),Ingredient("purebrilliance",30),Ingredient("cane",1),Ingredient("moonstorm_spark",20),Ingredient("security_pulse_cage_full",1)},
    TECH.LUNARFORGING_TWO,
    {
        atlas = "images/firefly.xml",
        image = "firefly.tex",--武器的图片的源片
    },
    {"CRAFTING_STATION"}--表明该武器将会在辉煌铁匠铺中找到并且制作
)

