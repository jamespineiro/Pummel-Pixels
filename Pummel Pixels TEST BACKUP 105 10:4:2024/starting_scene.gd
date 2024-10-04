extends Node2D

@onready var menu_stage = $MenuPicture
@onready var player1 = $MenuPicture/Player1
@onready var player2 = $MenuPicture/Player2
@onready var player3 = $MenuPicture/Player3
@onready var player4 = $MenuPicture/Player4
@onready var stage = $MenuPicture/TileMap
@onready var play = $MenuPicture/Play
@onready var title = $MenuPicture/Title
@onready var my_name = $MenuPicture/MyName
@onready var camera = $Camera2D
@onready var tile_map = $TileMap

var player_animation_started = false
var player_stage_shaking = false
var stage_shake_count = 0
var stage_x_direction = 2
var player_stage_falling = false
var players : Array

# Called when the node enters the scene tree for the first time.
func _ready():
	players = [player1, player2, player3, player4]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if stage.global_position.y < 40:
		if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("attack0") or Input.is_action_just_pressed("special0") or Input.is_action_just_pressed("dodge0") or Input.is_action_just_pressed("jump0")  or Input.is_action_just_pressed("atk_neutral0")  or Input.is_action_just_pressed("special_neutral0")  or Input.is_action_just_pressed("sprint0"):
			play.visible = false
			if not player_animation_started:
				for player in players:
					player.play("scared")
			player_stage_shaking = true
			
		if player_stage_shaking:
			stage_shake_count += 1
			if stage_shake_count % 5 == 0:
				stage.global_position.x += stage_x_direction
				stage_x_direction *= -1
			if stage_shake_count > 60:
				player_stage_shaking = false
				player_stage_falling = true

		if player_stage_falling:
			if stage.global_position.y < 40:
				stage.global_position.y += .7
				title.global_position.y -= 2
				my_name.global_position.y -= 2
				tile_map.global_position.y += 3.3
				camera.global_position.y += .1
				camera.global_position.x += .04
				camera.zoom.x += .028
				camera.zoom.y += .028
				for player in players:
					player.global_position.y += .7
					
	elif player_stage_falling:
		player_stage_falling = false
		for player in players:
			player.play("default")
