extends Node2D

@onready var player_count : int 
@onready var scoreboard_and_icons = get_node("CanvasLayer/ScoreboardAndIcons")
@onready var camera = get_node("Camera2D")
@onready var match_timer = scoreboard_and_icons.match_timer

enum TEAM_TYPE {FFA, TWOVSTWO}
enum GAMEMODE {CLASSIC, PARTY, ZOMBIES, SPEEDRUN, VOLLEYBALL, ARCHERANARCHY, JUGGERNAUT, SUPERSIZED}

var current_team_type = TEAM_TYPE.FFA
var current_gamemode = GAMEMODE.CLASSIC

@export var moving_background = false
@export var map_name = "Lobby"

@export var cloud : TextureRect
@export var back_cloud : TextureRect

@export var team_one = []
@export var team_two = []
@export var team_three = []
@export var team_four = []

@export var blue_team = []
@export var red_team = []

@export var players = []

var player_1 : CharacterBody2D
var player_2 : CharacterBody2D
var player_3 : CharacterBody2D
var player_4 : CharacterBody2D

var changes_made = false

func _ready():
	
	if GameSettings.player1_selected:
		player_1 = get_node("player")
		players.append(player_1)
	if GameSettings.player2_selected:
		player_2 = get_node("player2")
		players.append(player_2)
	if GameSettings.player3_selected:
		player_3 = get_node("player3")
		players.append(player_3)
	if GameSettings.player4_selected:
		player_4 = get_node("player4")
		players.append(player_4)
	
	for player in players:
		if player != null:
			match current_team_type:
				TEAM_TYPE.FFA:
					match player.team_name:
						"team-one":
							team_one.append(player)
						"team-two":
							team_two.append(player)
						"team-three":
							team_three.append(player)
						"team-four":
							team_four.append(player)
				TEAM_TYPE.TWOVSTWO:
					match player.team_name:
						"blue_team":
							blue_team.append(player)
						"red_team":
							red_team.append(player)
	
	if scene_file_path == "res://scenes/lobby.tscn" or scene_file_path == "res://scenes/starting_scene.tscn":
		moving_background = false
	else:
		moving_background = true
		#cloud = get_node("Skies/Sky4")
		#back_cloud = get_node("Skies/Sky2")
		
	camera.zoom = Vector2(10, 10)

	player_count = Input.get_connected_joypads().size()
	
func update_gamemode():
	for player in players:
		if player != null:
			match current_team_type:
				TEAM_TYPE.FFA:
					match player.team_name:
						"team-one":
							team_one.append(player)
						"team-two":
							team_two.append(player)
						"team-three":
							team_three.append(player)
						"team-four":
							team_four.append(player)
				TEAM_TYPE.TWOVSTWO:
					match player.team_name:
						"blue_team":
							blue_team.append(player)
						"red_team":
							red_team.append(player)
	changes_made = false
	
func _process(_delta):
	if camera.zoom.x > 8:
		camera.zoom.x -= .2
		camera.zoom.y -= .2
	elif camera.zoom.x > 7:
		camera.zoom.x -= .14
		camera.zoom.y -= .14
	elif camera.zoom.x > 6:
		camera.zoom.x -= .07
		camera.zoom.y -= .07
	elif camera.zoom.x < 6:
		camera.zoom.x = 6
		camera.zoom.y = 6
	
	if Input.get_connected_joypads().size() != player_count:
		player_count = Input.get_connected_joypads().size()
	
	if changes_made:
		update_gamemode()
	
	if Input.is_action_just_pressed("Map 0"):
		map_name = "Lobby"
		switch_scene("Projectiles")
		get_tree().change_scene_to_file("res://scenes/lobby.tscn")
	elif Input.is_action_just_pressed("Map 1"):
		map_name = "Sand Map Platform"
		switch_scene("Projectiles")
		get_tree().change_scene_to_file("res://scenes/sand_map_platform.tscn")
	elif Input.is_action_just_pressed("Map 2"):
		map_name = "Sand Map Cave"
		switch_scene("Projectiles")
		get_tree().change_scene_to_file("res://scenes/sand_map_cave.tscn")
	elif Input.is_action_just_pressed("Map 3"):
		map_name = "Green Map Platform"
		switch_scene("Projectiles")
		get_tree().change_scene_to_file("res://scenes/green_map_platform.tscn")
	elif Input.is_action_just_pressed("Map 4"):
		map_name = "Green Map Cave"
		switch_scene("Projectiles")
		get_tree().change_scene_to_file("res://scenes/green_map_cave.tscn")
	elif Input.is_action_just_pressed("Map 5"):
		map_name = "Pink Map Pillars"
		switch_scene("Projectiles")
		get_tree().change_scene_to_file("res://scenes/pink_map_pillars.tscn")
	elif Input.is_action_just_pressed("Map 6"):
		map_name = "Pink Map Island"
		switch_scene("Projectiles")
		get_tree().change_scene_to_file("res://scenes/pink_map_island.tscn")
	elif Input.is_action_just_pressed("Map 7"):
		map_name = "Purple Map Default"
		switch_scene("Projectiles")
		get_tree().change_scene_to_file("res://scenes/purple_map_default.tscn")
	elif Input.is_action_just_pressed("Map 8"):
		map_name = "Purple Map Alternate"
		switch_scene("Projectiles")
		get_tree().change_scene_to_file("res://scenes/purple_map_alternate.tscn")
	elif Input.is_action_just_pressed("Map 9"):
		map_name = "Castle Map Default"
		switch_scene("Projectiles")
		get_tree().change_scene_to_file("res://scenes/castle_map_default.tscn")
	elif Input.is_action_just_pressed("Map 11"):
		map_name = "Castle Map Wall"
		switch_scene("Projectiles")
		get_tree().change_scene_to_file("res://scenes/castle_map_wall.tscn")
	elif Input.is_action_just_pressed("Map 12"):
		map_name = "Cave Night Map"
		switch_scene("Projectiles")
		get_tree().change_scene_to_file("res://scenes/cave_night_map.tscn")
	elif Input.is_action_just_pressed("Map 13"):
		map_name = "Sand Map Big"
		switch_scene("Projectiles")
		get_tree().change_scene_to_file("res://scenes/sand_map_big.tscn")
	elif Input.is_action_just_pressed("Map 14"):
		map_name = "Sand Map Big"
		switch_scene("Projectiles")
		get_tree().change_scene_to_file("res://scenes/green_map_big.tscn")
	elif Input.is_action_just_pressed("Map 15"):
		map_name = "Sand Map Bridge"
		switch_scene("Projectiles")
		get_tree().change_scene_to_file("res://scenes/sand_bridge_map.tscn")
	elif Input.is_action_just_pressed("back_to_gamemode_select"):
		map_name = ""
		switch_scene("Projectiles")
		get_tree().change_scene_to_file("res://scenes/starting_scene.tscn")
		
	if moving_background:
		if map_name == "Castle Map Default":
			if cloud != null and back_cloud != null:
				cloud.global_position.x += .003
				back_cloud.global_position.x += .002
		elif scene_file_path != "res://scenes/lobby.tscn":
			if cloud != null and back_cloud != null:
				cloud.global_position.x += .0015
				back_cloud.global_position.x += .0010
		
func clear_group(group):
	for node in get_tree().get_nodes_in_group(group):
		node.queue_free()
		
func switch_scene(_group):
	clear_group("Projectiles")
	match_timer.stop()
	match_timer.start()
	

