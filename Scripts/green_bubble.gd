extends Area2D

#弹速
@export var SPEED = 20
#射程
@export var RANGE = 9000

var velocity = Vector2.ZERO
var damage = 0

#玩家
@onready var player = get_parent() as CharacterBody2D
@onready var sprite2D = $Sprite2D

#初速度
func _ready():
	var shooting_direction = player.shooting_direction
	
	velocity = shooting_direction * SPEED
	damage = player.damage + player.damage_boost
	
	self.hit_enemy.connect(player._on_hit_enemy)
	
	if velocity.x > 0:
		sprite2D.flip_h = true

#运动
func _process(delta):
	position += velocity
	
	if position.length() >= RANGE:
		queue_free()

#处理与敌人的碰撞
func _on_area_entered(area):
	
	if area.hitpoint != null:
		
		area.set_hp( area.get_hp() - player.damage)
		
		hit_enemy.emit()
		
		self.queue_free()

signal hit_enemy
