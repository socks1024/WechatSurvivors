extends CharacterBody2D

#加载子弹场景
@export var Bullet:PackedScene

@onready var audio_stream_player = $AudioStreamPlayer #0.74s
@onready var charging_timer = $ChargingTimer
@onready var invincible_timer = $InvincibleTimer
@onready var hurt_damage_boost_timer = $HurtDamageBoostTimer

@onready var score_controller = get_tree().get_first_node_in_group("ScoreController")

@onready var skill_manager = $SkillManager

#最大移动速度 生命值 攻击力 攻速 蓄力攻击子弹数 闪避
var moveSpeed = 100
func _on_speed_active():
	moveSpeed += 20






var max_hp = 3
func get_max_hp():
	return max_hp
func set_max_hp(i):
	max_hp = i
	
	max_hp_changed.emit()
	
	if hitpoint > max_hp:
		hitpoint = max_hp
signal max_hp_changed

var hitpoint = 3
func get_hp():
	return hitpoint
func set_hp(i):
	
	if i<0:
		
		if invincibility:
			return
		
		if (randf()<(dodge+charge_dodge_correction)):
			
			if dodge_heal && randf()<0.8:
				set_hp(get_hp()+1)
			
			dodge = 0.01
			#闪避应该要有动画
			return
		
		
		if hurt_dodge_boost:
			dodge += 0.7
		
		if hurt_damage_boost:
			hurt_damage_boost_timer.start()
			damage_boost += 4
		
		if strike_back:
			var n = ((2 * PI) / bullet_rotation) as int
			
			_create_bullet(n+1)
		
	
	
	
	
	
	
	
	
	self.hitpoint = i
	#受伤也应该要有动画
	
	hp_changed.emit()
	
	print(hitpoint)
	
	if hitpoint > max_hp:
		hitpoint = max_hp
	
	if self.hitpoint <= 0:
		self.queue_free()

var hit_heal = false
func _on_heal_a_active():
	hit_heal = true

var dodge_heal = false
func _on_heal_b_active():
	dodge_heal = true

var level_up_heal = false
func _on_heal_c_active():
	level_up_heal = true






func _on_level_up_signal():
	if level_up_heal:
		set_hp(get_hp()+1)
	if level_up_dodge_boost:
		dodge += 0.2









signal hp_changed
func _on_hp_active():
	set_max_hp(get_max_hp()+1)
	set_hp(get_hp()+1)

var invincibility = false#正在无敌
var invincible = false#能否无敌
func set_invinciblity():
	if invincible:
		invincibility = true
		invincible_timer.start()
func _on_invincible_timer_timeout():
	invincibility = false
func _on_injured_a_active():
	invincible = true

var strike_back = false
func _on_injured_b_active():
	strike_back = true

var hurt_damage_boost = false
func _on_injured_c_active():
	hurt_damage_boost = true






var damage = 1
func _on_damage_active():
	damage += 1
var damage_boost = 0
func _on_hurt_damage_boost_timer_timeout():
	damage_boost -= 4
func _on_super_high_damage_active():
	damage = 9999







var shootSpeed = 0.5
func _on_shooting_speed_bonus_active():
	shootSpeed = 0.25
	#charging_timer.wait_time = shootSpeed








var charged_amount = 3
func _on_charged_a_active():
	charged_amount += 3

var charging_damage_boost = false
func _on_charged_b_active():
	charging_damage_boost = true

func _on_charged_c_active():
	charging_timer.wait_time *= 0.5

var low_health_charging_bonus = false
func _on_low_health_charging_bonus_active():
	low_health_charging_bonus = true





var dodge = 0.01
var charge_dodge_correction = 0

var hit_dodge_boost = false
func _on_dodge_a_active():
	hit_dodge_boost = true

var dodge_boost_naturally = false
func _on_dodge_b_active():
	dodge_boost_naturally = true

var hurt_dodge_boost = false
func _on_dodge_c_active():
	hurt_dodge_boost = true

var charge_dodge_boost = false
func _on_charging_dodge_bonus_active():
	charge_dodge_boost = true

var level_up_dodge_boost = false
func _on_level_up_dodge_bonus_active():
	level_up_dodge_boost = true






func _on_hit_enemy():
	if hit_dodge_boost:
		dodge += 0.005
	
	if hit_heal && randf()<0.01:
		set_hp(get_hp()+1)













#移动方向
var moving_direction = Vector2(0,0)
#射击方向
var shooting_direction = Vector2(0,0)

#蓄力攻击旋转角（每子弹）
var bullet_rotation = 0.05 * PI
func _on_reduce_charging_angle_active():
	bullet_rotation *= 1.5






func _ready():
	strike_back = true
	
	score_controller.level_up_signal.connect(_on_level_up_signal)
	skill_manager.reduce_exp_for_level_up_active.connect(score_controller._on_reduce_exp_for_level_up_active)





func _physics_process(delta):
	
	_player_controll()
	
	_moving_process()
	
	if dodge_boost_naturally:
		dodge += 0.008 * delta


#攻击的触发
func _unhandled_input(event):
	
	if event.is_action_pressed("ui_accept"):
		charging_timer.start()
		if charging_damage_boost:
			damage_boost += 2
		if charge_dodge_boost:
			charge_dodge_correction = 0.7
	
	if event.is_action_released("ui_accept"):
		
		if charging_timer.time_left == 0:
			_shooting(true)
			
			if charging_damage_boost:
				damage_boost -= 2
			if charge_dodge_boost:
				charge_dodge_correction = 0
		else:
			_shooting(false)

#生成子弹
func _create_bullet(n):
	
	var total_degree = bullet_rotation * (n-1)
	
	var rotation_degree = 0.5 * total_degree
	
	for i in n:
		var bullet = Bullet.instantiate()
		add_child(bullet)
		
		bullet.velocity = bullet.velocity.rotated(rotation_degree)
		rotation_degree -= bullet_rotation
		
		i += 1

#处理射击动作 参数：是否是蓄力射击
func _shooting(charged):
	
	if $ShootTimer.time_left != 0:
		return
	
	$ShootTimer.start()
	
	if charged:
		var p = 0 
		if (low_health_charging_bonus)&&(get_hp()==1):
			p = 3
		
		_create_bullet(charged_amount + p)
		
	else:
		_create_bullet(1)
	
	#播放音效
	audio_stream_player.play()
	
	#相机晃动
	var camera = get_tree().get_first_node_in_group("camera") as Camera2D
	camera._shake()

#处理控制输入
func _player_controll():
	
	#移动方向
	moving_direction.x = Input.get_axis("ui_left","ui_right")
	moving_direction.y = Input.get_axis("ui_up","ui_down")
	moving_direction = moving_direction.normalized()
	
	#射击方向
	var mouse_position = get_global_mouse_position()
	shooting_direction = mouse_position - self.position
	
	if(shooting_direction != Vector2.ZERO):
		shooting_direction = shooting_direction.normalized()

#处理速度与位置变换
func _moving_process():
	
	velocity = moving_direction * moveSpeed
	
	move_and_slide()












func _on_charging_timer_timeout():
	audio_stream_player.play()
