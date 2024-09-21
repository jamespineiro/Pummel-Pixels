extends Control
@onready var gamemode_label = $GamemodeLabel
@onready var gamemode_description_label = $GamemodeDescriptionLabel
var falling_down = false
var set_up = false
@onready var down_timer = $DownTimer
var down_timer_started = false
var gonna_rise_up = false
var rising_up = false
@onready var tile_map = $TileMap
@onready var background = $Background
@onready var map_outline = $Map/MapOutline
@onready var top_label = $TopLabel

const MAP_1_AND_2 = preload("res://assets/MapPhotos/Map1and2.png")
const MAP_3_AND_4 = preload("res://assets/MapPhotos/Map3and4.png")
const MAP_5 = preload("res://assets/MapPhotos/Map5.png")
const MAP_6 = preload("res://assets/MapPhotos/Map6.png")
const MAP_7 = preload("res://assets/MapPhotos/Map7.png")
const MAP_8 = preload("res://assets/MapPhotos/Map8.png")
const MAP_9 = preload("res://assets/MapPhotos/Map9.png")
const MAP_10 = preload("res://assets/MapPhotos/Map10.png")
const MAP_11 = preload("res://assets/MapPhotos/Map11.png")
const MAP_12 = preload("res://assets/MapPhotos/Map12.png")
const MAP_13 = preload("res://assets/MapPhotos/Map13.png")
const MAP_14 = preload("res://assets/MapPhotos/Map14.png")
var max = 100
var min = -244
var speed = 3
@onready var map = $Map
@onready var map_name = $MapName
const TWO_VS_TWO_GAMEMODE_SELECTOR_BUTTON_BACKGROUND = preload("res://assets/MenuUI/TwoVsTwoGamemodeSelectorButtonBackground.png")
const FFA_GAMEMODE_SELECTOR_BUTTON_BACKGROUND = preload("res://assets/MenuUI/FFAGamemodeSelectorButtonBackground.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	if GameSettings.current_team_type == GameSettings.TEAM_TYPE.TWOVSTWO:
		background.texture = TWO_VS_TWO_GAMEMODE_SELECTOR_BUTTON_BACKGROUND
	else:
		background.texture = FFA_GAMEMODE_SELECTOR_BUTTON_BACKGROUND
	
	if (get_parent().scene_file_path != "res://scenes/starting_scene.tscn" and get_parent().scene_file_path != "res://scenes/results_screen.tscn"):
		global_position.x = 65
		rising_up = true
	else:
		global_position.x = 100
		global_position.y = min


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if GameSettings.current_team_type == GameSettings.TEAM_TYPE.TWOVSTWO:
		background.texture = TWO_VS_TWO_GAMEMODE_SELECTOR_BUTTON_BACKGROUND
	else:
		background.texture = FFA_GAMEMODE_SELECTOR_BUTTON_BACKGROUND
	
	if GameSettings.transition and (get_parent().scene_file_path == "res://scenes/starting_scene.tscn" or get_parent().scene_file_path == "res://scenes/results_screen.tscn"):
		falling_down = true
		GameSettings.transition = false
		
	if global_position.y < max and falling_down:
		global_position.y += speed
		if not set_up:
			if GameSettings.current_gamemode == GameSettings.GAMEMODE.CLASSIC:
				gamemode_label.text = "CLASSIC"
				gamemode_description_label.text = "DEAL DAMAGE TO YOUR OPPONENTS TO KNOCK THEM BACK FURTHER AND FURTHER WITH EACH HIT! KNOCK THEM OUT OF THE MAP TO SCORE POINTS AND WIN THE GAME!"
				gamemode_description_label.add_theme_color_override("font_shadow_color", Color(.39, .66, .76, 1))
				gamemode_label.add_theme_color_override("font_shadow_color", Color(.39, .66, .76, 1))
			elif GameSettings.current_gamemode == GameSettings.GAMEMODE.ARROWRAIN:
				gamemode_label.text = "ARROW RAIN"
				gamemode_description_label.text = "JUST LIKE CLASSIC, BUT YOU DON'T HAVE TO WORRY ABOUT RUNNING OUT OF ARROWS, EVER!!!"
				gamemode_description_label.add_theme_color_override("font_shadow_color", Color(.74, .58, .02, 1))
				gamemode_label.add_theme_color_override("font_shadow_color", Color(.74, .58, .02, 1))
			elif GameSettings.current_gamemode == GameSettings.GAMEMODE.SUPERSIZED:
				gamemode_label.text = "SUPERSIZED"
				gamemode_description_label.text = "EVERY FIGHTER IS NEARLY TWICE THE SIZE, AND SO ARE THE PROJECTILES! YOU BETTER GET REAL GOOD AT DODGING FOR THIS ONE!"
				gamemode_description_label.add_theme_color_override("font_shadow_color", Color(.49, .14, .51, 1))
				gamemode_label.add_theme_color_override("font_shadow_color", Color(.49, .14, .51, 1))
			elif GameSettings.current_gamemode == GameSettings.GAMEMODE.ZOMBIES:
				gamemode_label.text = "ZOMBIES"
				gamemode_description_label.text = "STARTS AS A NORMAL FREE-FOR-ALL MATCH, BUT ONCE YOU KNOCK SOMEONE OUT, THEY JOIN YOUR TEAM WITH 200 DAMAGE TAKEN! IF YOU INFECT THE WHOLE LOBBY YOU GET A BONUS POINT, AND FIRST TEAM WITH 10 POINTS WINS!"
				gamemode_description_label.add_theme_color_override("font_shadow_color", Color(.25, .6, .2, 1))
				gamemode_label.add_theme_color_override("font_shadow_color", Color(.25, .6, .2, 1))
			elif GameSettings.current_gamemode == GameSettings.GAMEMODE.WANTED:
				gamemode_label.text = "WANTED"
				gamemode_description_label.text = "FOR 30 SECONDS AT A TIME, RANDOM PLAYERS GET A BOUNTY ON THEIR HEAD. SAID PLAYER TAKES TWICE AS MUCH DAMAGE, AND IF YOU KNOCK THEM OUT, YOU'LL HEAL FOR 25 HEALTH!"
				gamemode_description_label.add_theme_color_override("font_shadow_color", Color(.7, .39, .2, 1))
				gamemode_label.add_theme_color_override("font_shadow_color", Color(.7, .39, .2, 1))
			elif GameSettings.current_gamemode == GameSettings.GAMEMODE.JUGGERNAUT:
				gamemode_label.text = "JUGGERNAUT"
				gamemode_description_label.text = "DESTROY THE GIANT, STRONG, HARD-HITTING JUGGERNAUT, TO BECOME THE NEW JUGGERNAUT! KNOCK OUT OPPONENTS AS JUGGERNAUT TO EARN 5 POINTS AND WIN THE GAME!"
				gamemode_description_label.add_theme_color_override("font_shadow_color", Color(.61, .12, .09, 1))
				gamemode_label.add_theme_color_override("font_shadow_color", Color(.61, .12, .09, 1))
				
			if GameSettings.current_map == "WORKSHOP (HYBRID)":
				map_name.add_theme_color_override("font_shadow_color", Color("#3e53c1",1))
				map.texture = MAP_10
			elif GameSettings.current_map == "SANDY PLATFORM (1V1)":
				map_name.add_theme_color_override("font_shadow_color", Color("#e6c9a5",1))
				map.texture = MAP_1_AND_2
			elif GameSettings.current_map == "RISING SANDY PLATFORM (1V1)":
				map_name.add_theme_color_override("font_shadow_color", Color("#e6c9a5",1))
				map.texture = MAP_1_AND_2
			elif GameSettings.current_map == "GRASSY PLATFORM (1V1)":
				map_name.add_theme_color_override("font_shadow_color", Color("#6fbf40",1))
				map.texture = MAP_3_AND_4
			elif GameSettings.current_map == "RISING GRASSY PLATFORM (1V1)":
				map_name.add_theme_color_override("font_shadow_color", Color("#6fbf40",1))
				map.texture = MAP_3_AND_4
			elif GameSettings.current_map == "PINK MAP PILLARS (2V2)":
				map_name.add_theme_color_override("font_shadow_color", Color("#f9cfe5",1))
				map.texture = MAP_5
			elif GameSettings.current_map == "RISING PINK PILLARS (HYBRID)":
				map_name.add_theme_color_override("font_shadow_color", Color("#f9cfe5",1))
				map.texture = MAP_6
			elif GameSettings.current_map == "PURPLE ISLANDS (1V1)":
				map_name.add_theme_color_override("font_shadow_color", Color("#cb6cf2",1))
				map.texture = MAP_7
			elif GameSettings.current_map == "PURPLE ISLANDS (2V2)":
				map_name.add_theme_color_override("font_shadow_color", Color("#cb6cf2",1))
				map.texture = MAP_8
			elif GameSettings.current_map == "CASTLE CAGES (LAVA) (HYBRID)":
				map_name.add_theme_color_override("font_shadow_color", Color("#f3750c",1))
				map.texture = MAP_9
			elif GameSettings.current_map == "CASTLE WALL (HYBRID)":
				map_name.add_theme_color_override("font_shadow_color", Color("#bf4048",1))
				map.texture = MAP_11
			elif GameSettings.current_map == "DYNAMIC CASTLE WALL (ENVIRONMENTAL) (HYBRID)":
				map_name.add_theme_color_override("font_shadow_color", Color("#bf4048",1))
				map.texture = MAP_11
			elif GameSettings.current_map == "NIGHT CAVE (HYBRID)":
				map_name.add_theme_color_override("font_shadow_color", Color("#3e53c1",1))
				map.texture = MAP_12
			elif GameSettings.current_map == "BIG SANDY PLATFORM (2V2)":
				map_name.add_theme_color_override("font_shadow_color", Color("#e6c9a5",1))
				map.texture = MAP_14
			elif GameSettings.current_map == "BIG GRASSY PLATFORM (2V2)":
				map_name.add_theme_color_override("font_shadow_color", Color("#6fbf40",1))
				map.texture = MAP_13
			elif GameSettings.current_map == "WIP 1":
				map_name.add_theme_color_override("font_shadow_color", Color("#6fbf40",1))
				map.texture = MAP_3_AND_4
			elif GameSettings.current_map == "WIP 2":
				map_name.add_theme_color_override("font_shadow_color", Color("#6fbf40",1))
				map.texture = MAP_3_AND_4
			elif GameSettings.current_map == "WIP 3":
				map_name.add_theme_color_override("font_shadow_color", Color("#6fbf40",1))
				map.texture = MAP_13
				
			map_name.text = GameSettings.current_map
			
			set_up = true
	elif not down_timer_started and global_position.y >= max and falling_down:
		down_timer.start()
		down_timer_started = true
			
	if rising_up:
		global_position.y -= speed
		if global_position.y < min:
			queue_free()

func _on_down_timer_timeout():
	down_timer.stop()
	if GameSettings.current_map == "WORKSHOP (HYBRID)":
		get_tree().change_scene_to_file("res://scenes/lobby.tscn")
	elif GameSettings.current_map == "SANDY PLATFORM (1V1)":
		get_tree().change_scene_to_file("res://scenes/sand_map_platform.tscn")
	elif GameSettings.current_map == "RISING SANDY PLATFORM (1V1)":
		get_tree().change_scene_to_file("res://scenes/sand_map_cave.tscn")
	elif GameSettings.current_map == "GRASSY PLATFORM (1V1)":
		get_tree().change_scene_to_file("res://scenes/green_map_platform.tscn")
	elif GameSettings.current_map == "RISING GRASSY PLATFORM (1V1)":
		get_tree().change_scene_to_file("res://scenes/green_map_cave.tscn")
	elif GameSettings.current_map == "PINK MAP PILLARS (2V2)":
		get_tree().change_scene_to_file("res://scenes/pink_map_pillars.tscn")
	elif GameSettings.current_map == "RISING PINK PILLARS (HYBRID)":
		get_tree().change_scene_to_file("res://scenes/pink_map_island.tscn")
	elif GameSettings.current_map == "PURPLE ISLANDS (1V1)":
		get_tree().change_scene_to_file("res://scenes/purple_map_default.tscn")
	elif GameSettings.current_map == "PURPLE ISLANDS (2V2)":
		get_tree().change_scene_to_file("res://scenes/purple_map_alternate.tscn")
	elif GameSettings.current_map == "CASTLE CAGES (LAVA) (HYBRID)":
		get_tree().change_scene_to_file("res://scenes/castle_map_default.tscn")
	elif GameSettings.current_map == "CASTLE WALL (HYBRID)":
		get_tree().change_scene_to_file("res://scenes/castle_map_wall.tscn")
	elif GameSettings.current_map == "DYNAMIC CASTLE WALL (ENVIRONMENTAL) (HYBRID)":
		get_tree().change_scene_to_file("res://scenes/castle_map_wall.tscn")
	elif GameSettings.current_map == "NIGHT CAVE (HYBRID)":
		get_tree().change_scene_to_file("res://scenes/cave_night_map.tscn")
	elif GameSettings.current_map == "BIG SANDY PLATFORM (2V2)":
		get_tree().change_scene_to_file("res://scenes/sand_map_big.tscn")
	elif GameSettings.current_map == "BIG GRASSY PLATFORM (2V2)":
		get_tree().change_scene_to_file("res://scenes/green_map_big.tscn")
	elif GameSettings.current_map == "WIP 1":
		get_tree().change_scene_to_file("res://scenes/green_map_platform.tscn")
	elif GameSettings.current_map == "WIP 2":
		get_tree().change_scene_to_file("res://scenes/green_map_cave.tscn")
	elif GameSettings.current_map == "WIP 3":
		get_tree().change_scene_to_file("res://scenes/green_map_big.tscn")
	
