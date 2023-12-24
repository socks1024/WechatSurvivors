extends Node


#技能的数据（伪接口？懒得传节点了，一开始没做这些设想……可扩展性太低了）
signal speed_active
var speed = ["速度","速度上升",speed_active]

signal hp_active
var hp = ["生命","生命上升",hp_active]

signal damage_active
var damage = ["伤害","伤害上升",damage_active]

signal charge_a_active
signal charge_b_active
signal charge_c_active
var charge_a = ["蓄力A","蓄力攻击气泡数增加",charge_a_active]
var charge_b = ["蓄力B","蓄力攻击伤害增加",charge_b_active]
var charge_c = ["蓄力C","蓄力速度减少",charge_c_active]

signal injured_a_active
signal injured_b_active
signal injured_c_active
var injured_a = ["免打扰","受伤后短时间内无敌",injured_a_active]
var injured_b = ["破防","受伤时反击",injured_b_active]
var injured_c = ["受伤C","受伤后短时间内伤害上升",injured_c_active]

signal dodge_a_active
signal dodge_b_active
signal dodge_c_active
var dodge_a = ["闪避A","造成伤害时增加闪避率",dodge_a_active]
var dodge_b = ["闪避B","缓慢增加闪避率",dodge_b_active]
var dodge_c = ["闪避C","受伤时增加闪避率",dodge_c_active]

signal heal_a_active
signal heal_b_active
signal heal_c_active
var heal_a = ["幸灾乐祸","击中敌人时有概率回复生命",heal_a_active]
var heal_b = ["回复B","闪避时有概率回复生命",heal_b_active]
var heal_c = ["回复C","升级时有概率回复生命",heal_c_active]

signal charging_dodge_bonus_active
signal reduce_charging_angle_active
signal shooting_speed_bonus_active
signal super_high_damage_active
signal level_up_dodge_bonus_active
signal reduce_exp_for_level_up_active
signal low_health_charging_bonus_active
var charing_dodge_bonus = ["正在输入中","蓄力时大幅提升闪避率",charging_dodge_bonus_active]
var reduce_charging_angle = ["喷子模式","蓄力攻击散射角度增大",reduce_charging_angle_active]
var shooting_speed_bonus = ["语音打字","提升普通攻击射速",shooting_speed_bonus_active]
var super_high_damage = ["玻璃心","将自身和敌人的伤害提高到9999",super_high_damage_active]
var level_up_dodge_bonus = ["成就感","升级时增加闪避率",level_up_dodge_bonus_active]
var reduce_exp_for_level_up = ["互联网原住民","减少升级所需的经验",reduce_exp_for_level_up_active]
var low_health_charging_bonus = ["丝血反杀","生命值为1时蓄力攻击气泡数增加",low_health_charging_bonus_active]

#signal exprience_enemy_active
#signal explode_enemy_active
#signal zombie_enemy_active
#var exprience_enemy = ["","出现提供更多经验值的特殊敌人",exprience_enemy_active]
#var explode_enemy = ["","出现会自爆的特殊敌人",explode_enemy_active]
#var zombie_enemy = ["","出现会复活的特殊敌人",zombie_enemy_active]



#技能的分组
var normal_skill = [charing_dodge_bonus,reduce_charging_angle,shooting_speed_bonus,super_high_damage,level_up_dodge_bonus,reduce_exp_for_level_up,low_health_charging_bonus]
#0-6
var unchosed_normal_skill = []
var basic_skill = [speed,hp,damage]
var charge_skill = [charge_a,charge_b,charge_c]
var injured_skill = [injured_a,injured_b,injured_c]
var dodge_skill = [dodge_a,dodge_b,dodge_c]
var heal_skill = [heal_a,heal_b,heal_c]
#var enemy_skill = [exprience_enemy,explode_enemy,zombie_enemy]


#存储技能组
var skill_sets = [normal_skill,basic_skill,charge_skill,injured_skill,dodge_skill,heal_skill]
#0-5

#这是命名很水的给三选一用的随机数
var array_1 = [null,null,null,null]
var array_1_count = 0


func _on_charging_dodge_bonus_active():
	unchosed_normal_skill.remove_at(0)
func _on_reduce_charging_angle_active():
	unchosed_normal_skill.remove_at(1)
func _on_shooting_speed_bonus_active():
	unchosed_normal_skill.remove_at(2)
func _on_super_high_damage_active():
	unchosed_normal_skill.remove_at(3)
func _on_level_up_dodge_bonus_active():
	unchosed_normal_skill.remove_at(4)
func _on_reduce_exp_for_level_up_active():
	unchosed_normal_skill.remove_at(5)
func _on_low_health_charging_bonus_active():
	unchosed_normal_skill.remove_at(6)




func _ready():
	
	unchosed_normal_skill = normal_skill.duplicate()
	
	
	#生成供三选一使用的随机数组
	var i = 0
	var j = 0
	array_1[0] = randi_range(2,5)
	while(array_1[3] == null):
		j = randi_range(2,5)
		if array_1[i] != j:
			i += 1
			array_1[i] = j

func skill_activate(skill):
	skill[3].emit()

func get_3_pickable_skills(level):
	
	var arr = [null,null,null]
	
	var i = level%3
	
	if i == 1:
		arr = basic_skill

	elif i == 2:
		var normal_skill_temp = unchosed_normal_skill.duplicate() as Array
		
		var k = 0
		for j in 3:
			
			k = randi_range(0,normal_skill_temp.size()-1)
			arr[j] = normal_skill_temp[k]
			normal_skill_temp.remove_at(k)
			
	else:
		arr = skill_sets[ array_1[array_1_count] ]#从三选一当中选择没有刷新过的
		array_1_count += 1
	
	
	return arr

