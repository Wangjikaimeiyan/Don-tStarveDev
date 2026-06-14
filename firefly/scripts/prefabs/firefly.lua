local assets =
{
    Asset("ANIM", "anim/firefly.zip"),
    Asset("ANIM", "anim/swap_firefly.zip"),
    Asset("ATLAS", "images/firefly.xml"),
    Asset("IMAGE", "images/firefly.tex"),
}

local function onequip(inst, owner)--这个函数是装备武器时用到的函数
    local skin_build = inst:GetSkinBuild()
    if skin_build ~= nil then--来检查武器是否拥有皮肤的函数
        owner:PushEvent("equipskinneditem", inst:GetSkinName())
        owner.AnimState:OverrideItemSkinSymbol("swap_object", skin_build, "swap_firefly", inst.GUID, "swap_firefly")
    else--如果没有皮肤,就会调用默认的动画
        owner.AnimState:OverrideSymbol("swap_object", "swap_firefly", "swap_firefly")
    end
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
end

local function onunequip(inst, owner)--这个函数是卸下武器用的函数
    owner.AnimState:Hide("ARM_carry")--隐藏持有武器动画
    owner.AnimState:Show("ARM_normal")--显示正常持有武器动画
    local skin_build = inst:GetSkinBuild()--这个函数也是检查玩家是否拥有武器皮肤的动画
    if skin_build ~= nil then
        owner:PushEvent("unequipskinneditem", inst:GetSkinName())
    end
end

    --添加带点电的特效
    local function OnAttack(weapon, attacker, target)--这个函数在玩家攻击时候调用
        if target ~= nil and target:IsValid() and attacker ~= nil and attacker:IsValid() then
            SpawnPrefab("electrichitsparks"):AlignToTarget(target,attacker,true)--electrichitsparks电击火花特效,表示攻击带有电击效果
        end
        if target and target.components.health and not target.components.health:IsDead() then
            local x,y,z = target:GetPosition():Get()
            SpawnPrefab("wanda_attack_shadowweapon_old_fx").Transform:SetPosition(x,y+1,z)--wanda_attack_shadowweapon_old_fx暗影武器攻击特效
        end                                                            --这个坐标是表示这些特效会在目标位置生成,并且显示在目标上方(y+1)的位
    end

local function fn()      --这个函数是武器实体的创建(inst)
    local inst = CreateEntity()--用inst来表示武器的实体
    --下面是基本的组件
    inst.entity:AddTransform()  --位置,旋转,缩放
    inst.entity:AddAnimState()  --动画状态
    inst.entity:AddNetwork()    --网络同步

    MakeInventoryPhysics(inst)      --定义了武器的物理属性,使其可以被拾取和掉落

    inst.AnimState:SetBank("firefly")
    inst.AnimState:SetBuild("firefly")    --定义了武器的动画库和定义文件
    inst.AnimState:PlayAnimation("idle")    --idle这个状态是饥荒中事物没有被使用时的闲置状态时的动画

    inst:AddTag("sharp")    --为武器添加标签(某些生物可能对这个标签产生特殊反应)
    inst:AddTag("pointy")

    --weapon (from weapon component) added to pristine state for optimization
    inst:AddTag("weapon")   --为这个事物添加一个武器的标签

    MakeInventoryFloatable(inst, "med", 0.05, {1.1, 0.5, 1.1}, true, -9)--使武器掉落时可以漂浮在水面上
                    --inst事物,med漂浮的模式,0.05漂浮有关的参数(可能是晃动的幅度),{1.1,0.5,1.1}在xyz轴上的缩放,true表示在水面上可以被推动,-9等级顺序
    inst.entity:SetPristine()   --减轻性能的,不懂得技术

    if not TheWorld.ismastersim then    --也是保证主机和客户端的,保证性能的,不懂得技术
        return inst
    end

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(188)--这里是设置武器攻击力的函数
    inst.components.weapon:SetOnAttack(OnAttack)--这个是武器在攻击时的函数特效(OnAttack在前面自定义过了)
    inst.components.weapon:SetElectric()
    -------

    inst:AddComponent("tool")--设置了武器的工具属性
    -- inst.components.tool:SetAction(ACTIONS.CHOP,2)--砍树
    -- inst.components.tool:SetAction(ACTIONS.MINE,2)--挖矿
    inst.components.tool:SetAction(ACTIONS.NET,2)--捕虫网

    -- inst:AddComponent("finiteuses")--finiteuses设置武器的耐久度
    -- inst.components.finiteuses:SetMaxUses(500)--[[这个函数时设置武器的耐久]]--
    -- inst.components.finiteuses:SetUses(500)--[[这个函数时设置武器的耐久]]--
    -- inst.components.finiteuses:SetConsumption(ACTIONS.MINE,1)
    -- inst.components.finiteuses:SetConsumption(ACTIONS.CHOP,1)
    -- inst.components.finiteuses:SetOnFinished(inst.Remove)--耐久为零时会移除武器

    inst:AddComponent("inspectable")--允许玩家检查武器的属性

    inst:AddComponent("inventoryitem")--设置了武器在物品栏中的图标图集
    inst.components.inventoryitem.atlasname = "images/firefly.xml"

    local planardamage = inst:AddComponent("planardamage")--设置位面伤害的函数
    planardamage:SetBaseDamage(80)--这个函数时设置位面伤害的数值
    
    inst:AddComponent("equippable") --该组件的作用时是装备可以被玩家添加到装备栏(使装备可以被装备)
    inst.components.equippable:SetOnEquip(onequip)--玩家装备这个inst时,onequip函数会被调用,函数的作用是:1.播放装备动画2.应用装备的增益效果3.显示特定的动画
    inst.components.equippable:SetOnUnequip(onunequip)--与上面的函数正好相反
    inst.components.equippable.walkspeedmult = 1.5--移速加成
    MakeHauntableLaunch(inst)--武器可以被幽灵影响

    return inst--返回一个游戏实体
end

return Prefab("firefly", fn, assets)--Prefab表示一个可以被服用的游戏模板("firefly:预制件名称,唯一的.fn:创造游戏实体的函数,相当于java中的构造器.assets:预制件所需要的文件,动画,纹理等等")