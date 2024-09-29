extends Area2D

@onready var main = get_tree().get_root()
@onready var player_1_death_timer = $Player1DeathTimer
@onready var player_2_death_timer = $Player2DeathTimer
@onready var player_3_death_timer = $Player3DeathTimer
@onready var player_4_death_timer = $Player4DeathTimer
var player1 : CharacterBody2D
var player2 : CharacterBody2D
var player3 : CharacterBody2D
var player4 : CharacterBody2D
var player_count : int
var ringout_explosion = preload("res://ringoutexplosion.tscn")
@onready var explosion_sound = $ExplosionSound

func _ready():
	player_count = Input.get_connected_joypads().size()
	player1 = get_node("../../player")
	if player_count >= 2:
		player2 = get_node("../../player2")
	if player_count >= 3:
		player3 = get_node("../../player3")
	if player_count >= 4:
		player4 = get_node("../../player4")

func _on_body_entered(body):
	if body.get_name() == "player" or body.get_name() == "player2" or body.get_name() == "player3" or body.get_name() == "player4" or body.is_in_group("Dummies"):
		if body.can_explode:
			explosion_sound.pitch_scale = randf_range(.95, 1.15)
			explosion_sound.play()
			var ringout_explosion_instance = ringout_explosion.instantiate()
			main.add_child.call_deferred(ringout_explosion_instance)
			if get_name() == "TopKillzone":
				ringout_explosion_instance.explode(body, body.global_position.x, 50, "top")
			elif get_name() == "BottomKillzone":
				ringout_explosion_instance.explode(body, body.global_position.x, 275, "bottom")
			elif get_name() == "LeftKillzone":
				ringout_explosion_instance.explode(body, 85, body.global_position.y, "left")
			elif get_name() == "RightKillzone":
				ringout_explosion_instance.explode(body, 495, body.global_position.y, "right")
		body.can_explode = false
		if not body.is_in_group("Dummies"):
			body.clear_projectiles()
		body.revive()
