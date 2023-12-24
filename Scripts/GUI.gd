extends Control

@onready var score_controller = get_tree().get_first_node_in_group("ScoreController")
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var skill_manager = player.get_node("SkillManager")


var skills

func _ready():
	score_controller.level_up_signal.connect(_on_level_up_signal)
	score_controller.exp_changed.connect(_on_exp_changed)
	player.hp_changed.connect(_on_hp_changed)
	
	self.grab_focus()	

func set_upgrade_menu():
	
	skills = skill_manager.get_3_pickable_skills(score_controller.level)
	
	$UpgradeMenu/MarginContainer/SkillChoices/Skill1/Name.text = skills[0][0]
	$UpgradeMenu/MarginContainer/SkillChoices/Skill1/Discription.text = skills[0][1]
	
	$UpgradeMenu/MarginContainer/SkillChoices/Skill2/Name.text = skills[1][0]
	$UpgradeMenu/MarginContainer/SkillChoices/Skill2/Discription.text = skills[1][1]
	
	$UpgradeMenu/MarginContainer/SkillChoices/Skill3/Name.text = skills[2][0]
	$UpgradeMenu/MarginContainer/SkillChoices/Skill3/Discription.text = skills[2][1]
	

func _on_pause_button_pressed():
	$PauseMenu.show()
	get_tree().paused = true

func _on_level_up_signal():
	$MarginContainer/Top/Left/EXP/TextureProgressBar.max_value = score_controller.exp_for_level_up
	get_tree().paused = true
	$UpgradeMenu.show()
	set_upgrade_menu()
func _on_exp_changed():
	$MarginContainer/Top/Left/EXP/TextureProgressBar.value = score_controller.exp
func _on_hp_changed():
	$MarginContainer/Top/Left/HP/TextureProgressBar.value = player.hitpoint

func _on_button_1_pressed():
	$PauseMenu.hide()
func _on_button_2_pressed():
	get_tree().reload_current_scene()
func _on_button_5_pressed():
	get_tree().quit()
func _on_pause_menu_popup_hide():
	get_tree().paused = false

func upgrade_finished():
	$UpgradeMenu.hide()
	get_tree().paused = false
func _on_button_a_pressed():
	skills[0][2].emit()
	upgrade_finished()
func _on_button_b_pressed():
	skills[1][2].emit()
	upgrade_finished()
func _on_button_c_pressed():
	skills[2][2].emit()
	upgrade_finished()






