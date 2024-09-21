extends Control
@onready var top_label = $TopLabel

@onready var twovstwo_button = $TeammodeSelectNodes/"2V2Button"
@onready var ffa_button = $TeammodeSelectNodes/FFAButton
@onready var background = $Background
@onready var ffa_label = $TeammodeSelectNodes/FFALabel
@onready var twovstwo_label = $"TeammodeSelectNodes/2V2Label"

@onready var classic_button = $GamemodeButtons/ClassicButton
@onready var arrow_rain_button = $GamemodeButtons/ArrowRainButton
@onready var supersized_button = $GamemodeButtons/SuperSizedButton
@onready var zombies_button = $GamemodeButtons/ZombiesButton
@onready var wanted_button = $GamemodeButtons/WantedButton
@onready var juggernaut_button = $GamemodeButtons/JuggernautButton

const DISABLED_BUTTON = preload("res://assets/MenuUI/DisabledButton.png")
const CLASSIC_BUTTON_GREEN = preload("res://assets/MenuUI/ClassicButton4.png")
const CLASSIC_BUTTON_RED = preload("res://assets/MenuUI/ClassicButton3.png")
const CLASSIC_BUTTON = preload("res://assets/MenuUI/ClassicButton.png")

@onready var map_buttons = $MapButtons
@onready var sand_map_button = $MapButtons/SandMapButton
@onready var sand_map_moving_button = $MapButtons/SandMapMovingButton
@onready var sand_map_big_button = $MapButtons/SandMapBigButton
@onready var grass_map_button = $MapButtons/GrassMapButton
@onready var grass_map_moving_button = $MapButtons/GrassMapMovingButton
@onready var grass_map_big_button = $MapButtons/GrassMapBigButton
@onready var pink_map_pillars_button = $MapButtons/PinkMapPillarsButton
@onready var pink_map_rising_button = $MapButtons/PinkMapRisingButton
@onready var purple_map_small_button = $MapButtons/PurpleMapSmallButton
@onready var purple_map_big_button = $MapButtons/PurpleMapBigButton
@onready var castle_map_cages_button = $MapButtons/CastleMapCagesButton
@onready var castle_wall_map_button = $MapButtons/CastleWallMapButton
@onready var castle_wall_map_rising_lava_button = $MapButtons/CastleWallMapRisingLavaButton
@onready var work_shop_map_button = $MapButtons/WorkShopMapButton
@onready var night_cave_map_button = $MapButtons/NightCaveMapButton
@onready var grass_map_button_2 = $MapButtons/GrassMapButton2
@onready var grass_map_moving_button_2 = $MapButtons/GrassMapMovingButton2
@onready var grass_map_big_button_2 = $MapButtons/GrassMapBigButton2
@onready var select_all_button = $MapButtons/SelectAllButton
@onready var select_none_button = $MapButtons/SelectNoneButton
@onready var continue_button = $MapButtons/ContinueButton
@onready var map_name_label = $MapButtons/MapNameLabel

@onready var gamemode_label = $GamemodeButtons/GamemodeLabel
@onready var gamemode_description_label = $GamemodeButtons/GamemodeDescriptionLabel

@onready var character_select_buttons = $CharacterSelectButtons
@onready var player_1_button = $CharacterSelectButtons/Player1Icon/Player1Button
@onready var player_2_button = $CharacterSelectButtons/Player2Icon/Player2Button
@onready var player_3_button = $CharacterSelectButtons/Player3Icon/Player3Button
@onready var player_4_button = $CharacterSelectButtons/Player4Icon/Player4Button

@onready var map_buttons_array = [sand_map_button, sand_map_moving_button, sand_map_big_button, grass_map_button,
grass_map_moving_button, grass_map_big_button, pink_map_pillars_button, pink_map_rising_button,
purple_map_small_button, purple_map_big_button, castle_map_cages_button, castle_wall_map_button,
castle_wall_map_rising_lava_button, work_shop_map_button, night_cave_map_button, grass_map_button_2,
grass_map_moving_button_2, grass_map_big_button_2]

const MAP_APPROVED = preload("res://assets/MapPhotos/MapApproved.png")
const MAP_NOT_APPROVED = preload("res://assets/MapPhotos/MapNotApproved.png")

@onready var background_texture = background.texture
@onready var ffa_gamemode_background = preload("res://assets/MenuUI/FFAGamemodeSelectorButtonBackground.png")
@onready var twovstwo_gamemode_background = preload("res://assets/MenuUI/TwoVsTwoGamemodeSelectorButtonBackground.png")
@onready var ffa_background = preload("res://assets/MenuUI/FFAGamemodeSelectorBackground.png")
@onready var twovstwo_background = preload("res://assets/MenuUI/TwoVsTwoGamemodeSelectorBackground.png")
var set_up = false

@onready var maps = ["SANDY PLATFORM (1V1)", "RISING SANDY PLATFORM (1V1)", "BIG SANDY PLATFORM (2V2)",
"GRASSY PLATFORM (1V1)", "RISING GRASSY PLATFORM (1V1)", "BIG GRASSY PLATFORM (2V2)",
"PINK MAP PILLARS (2V2)", "RISING PINK PILLARS (HYBRID)", "PURPLE ISLANDS (1V1)",
"PURPLE ISLANDS (2V2)", "CASTLE CAGES (LAVA) (HYBRID)", "CASTLE WALL (HYBRID)",
"DYNAMIC CASTLE WALL (ENVIRONMENTAL) (HYBRID)", "WORKSHOP (HYBRID)", "NIGHT CAVE (HYBRID)",
"WIP 1", "WIP 2", "WIP 3"]

@onready var chosen_maps = ["SANDY PLATFORM (1V1)", "RISING SANDY PLATFORM (1V1)", "BIG SANDY PLATFORM (2V2)",
"GRASSY PLATFORM (1V1)", "RISING GRASSY PLATFORM (1V1)", "BIG GRASSY PLATFORM (2V2)",
"PINK MAP PILLARS (2V2)", "RISING PINK PILLARS (HYBRID)", "PURPLE ISLANDS (1V1)",
"PURPLE ISLANDS (2V2)", "CASTLE CAGES (LAVA) (HYBRID)", "CASTLE WALL (HYBRID)",
"DYNAMIC CASTLE WALL (ENVIRONMENTAL) (HYBRID)", "WORKSHOP (HYBRID)", "NIGHT CAVE (HYBRID)",
"WIP 1", "WIP 2", "WIP 3"]

@onready var gamemode_buttons = [classic_button, arrow_rain_button, supersized_button,
zombies_button, wanted_button, juggernaut_button]

enum state {TEAMMODESELECT, GAMEMODESELECT, MAPSELECT, CHARACTERSELECT, TEAMSELECT, TRANSITIONING}
var current_state = state.TEAMMODESELECT
enum TEAM_TYPE {FFA, TWOVSTWO}
var current_team_type = TEAM_TYPE.FFA
enum GAMEMODE {CLASSIC, ARROWRAIN, SUPERSIZED, ZOMBIES, WANTED, JUGGERNAUT}
var current_gamemode = GAMEMODE.CLASSIC
var game_time = 304
var game_lives = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not set_up and global_position.y > 70 and current_state == state.TEAMMODESELECT:
		ffa_button.grab_focus()
		set_up = true
	if Input.is_action_just_pressed("goback") and current_state != state.TRANSITIONING:
		if current_state == state.TEAMMODESELECT and global_position.y > 70:
			get_tree().reload_current_scene()
		elif current_state == state.GAMEMODESELECT:
			switch_to_teammodes()
			background.texture = background_texture
		elif current_state == state.MAPSELECT:
			switch_to_gamemodes()
	
	if current_state == state.MAPSELECT:
		if chosen_maps.size() == 0:
			continue_button.icon = DISABLED_BUTTON
		elif continue_button.icon == DISABLED_BUTTON:
			continue_button.icon = CLASSIC_BUTTON
		
		for button in map_buttons_array:
			if button.has_focus():
				button.self_modulate = Color(1,1,0,1)
			elif button.self_modulate == Color(1,1,0,1) and not button.has_focus():
				button.self_modulate = Color(1,1,1,1)
		
		if sand_map_button.has_focus() and map_name_label.text != "SANDY PLATFORM (1V1)":
			map_name_label.text = "SANDY PLATFORM (1V1)"
		elif sand_map_moving_button.has_focus() and map_name_label.text != "RISING SANDY PLATFORM (1V1)":
			map_name_label.text = "RISING SANDY PLATFORM (1V1)"
		elif sand_map_big_button.has_focus() and map_name_label.text != "BIG SANDY PLATFORM (2V2)":
			map_name_label.text = "BIG SANDY PLATFORM (2V2)"
		elif grass_map_button.has_focus() and map_name_label.text != "GRASSY PLATFORM (1V1)":
			map_name_label.text = "GRASSY PLATFORM (1V1)"
		elif grass_map_moving_button.has_focus() and map_name_label.text != "RISING GRASSY PLATFORM (1V1)":
			map_name_label.text = "RISING GRASSY PLATFORM (1V1)"
		elif grass_map_big_button.has_focus() and map_name_label.text != "BIG GRASSY PLATFORM (2V2)":
			map_name_label.text = "BIG GRASSY PLATFORM (2V2)"
		elif pink_map_pillars_button.has_focus() and map_name_label.text != "PINK PILLARS (2V2)":
			map_name_label.text = "PINK MAP PILLARS (2V2)"
		elif pink_map_rising_button.has_focus() and map_name_label.text != "RISING PINK PILLARS (HYBRID)":
			map_name_label.text = "RISING PINK PILLARS (HYBRID)"
		elif purple_map_small_button.has_focus() and map_name_label.text != "PURPLE ISLANDS (1V1)":
			map_name_label.text = "PURPLE ISLANDS (1V1)"
		elif purple_map_big_button.has_focus() and map_name_label.text != "PURPLE ISLANDS (2V2)":
			map_name_label.text = "PURPLE ISLANDS (2V2)"
		elif castle_map_cages_button.has_focus() and map_name_label.text != "CASTLE CAGES (LAVA) (HYBRID)":
			map_name_label.text = "CASTLE CAGES (LAVA) (HYBRID)"
		elif castle_wall_map_button.has_focus() and map_name_label.text != "CASTLE WALL (HYBRID)":
			map_name_label.text = "CASTLE WALL (HYBRID)"
		elif castle_wall_map_rising_lava_button.has_focus() and map_name_label.text != "DYNAMIC CASTLE WALL (ENVIRONMENTAL) (HYBRID)":
			map_name_label.text = "DYNAMIC CASTLE WALL (ENVIRONMENTAL) (HYBRID)"
		elif work_shop_map_button.has_focus() and map_name_label.text != "WORKSHOP (HYBRID)":
			map_name_label.text = "WORKSHOP (HYBRID)"
		elif night_cave_map_button.has_focus() and map_name_label.text != "NIGHT CAVE (HYBRID)":
			map_name_label.text = "NIGHT CAVE (HYBRID)"
		elif grass_map_button_2.has_focus() and map_name_label.text != "WIP 1":
			map_name_label.text = "WIP 1"
		elif grass_map_moving_button_2.has_focus() and map_name_label.text != "WIP 2":
			map_name_label.text = "WIP 2"
		elif grass_map_big_button_2.has_focus() and map_name_label.text != "WIP 3":
			map_name_label.text = "WIP 3"
		elif select_all_button.has_focus() and map_name_label.text != "SELECTS ALL MAPS":
			map_name_label.text = "SELECTS ALL MAPS"
		elif select_none_button.has_focus() and map_name_label.text != "DESELECTS ALL MAPS":
			map_name_label.text = "DESELECTS ALL MAPS"
		elif continue_button.has_focus() and map_name_label.text != "BEGIN!":
			map_name_label.text = "BEGIN!"
	
	elif current_state == state.GAMEMODESELECT:
		if classic_button.has_focus():
			gamemode_label.text = "CLASSIC"
			gamemode_description_label.text = "DEAL DAMAGE TO YOUR OPPONENTS TO KNOCK THEM BACK FURTHER AND FURTHER WITH EACH HIT! KNOCK THEM OUT OF THE MAP TO SCORE POINTS AND WIN THE GAME!"
			gamemode_description_label.add_theme_color_override("font_shadow_color", Color(.39, .66, .76, 1))
			gamemode_label.add_theme_color_override("font_shadow_color", Color(.39, .66, .76, 1))
		elif arrow_rain_button.has_focus():
			gamemode_label.text = "ARROW RAIN"
			gamemode_description_label.text = "JUST LIKE CLASSIC, BUT YOU DON'T HAVE TO WORRY ABOUT RUNNING OUT OF ARROWS, EVER!!!"
			gamemode_description_label.add_theme_color_override("font_shadow_color", Color(.74, .58, .02, 1))
			gamemode_label.add_theme_color_override("font_shadow_color", Color(.74, .58, .02, 1))
		elif supersized_button.has_focus():
			gamemode_label.text = "SUPERSIZED"
			gamemode_description_label.text = "EVERY FIGHTER IS NEARLY TWICE THE SIZE, AND SO ARE THE PROJECTILES! YOU BETTER GET REAL GOOD AT DODGING FOR THIS ONE!"
			gamemode_description_label.add_theme_color_override("font_shadow_color", Color(.49, .14, .51, 1))
			gamemode_label.add_theme_color_override("font_shadow_color", Color(.49, .14, .51, 1))
		elif zombies_button.has_focus():
			gamemode_label.text = "ZOMBIES"
			gamemode_description_label.text = "STARTS AS A NORMAL FREE-FOR-ALL MATCH, BUT ONCE YOU KNOCK SOMEONE OUT, THEY JOIN YOUR TEAM WITH 200 DAMAGE TAKEN! IF YOU INFECT THE WHOLE LOBBY YOU GET A BONUS POINT, AND FIRST TEAM WITH 10 POINTS WINS!"
			gamemode_description_label.add_theme_color_override("font_shadow_color", Color(.25, .6, .2, 1))
			gamemode_label.add_theme_color_override("font_shadow_color", Color(.25, .6, .2, 1))
		elif wanted_button.has_focus():
			gamemode_label.text = "WANTED"
			gamemode_description_label.text = "FOR 30 SECONDS AT A TIME, RANDOM PLAYERS GET A BOUNTY ON THEIR HEAD. SAID PLAYER TAKES TWICE AS MUCH DAMAGE, AND IF YOU KNOCK THEM OUT, YOU'LL HEAL FOR 25 HEALTH!"
			gamemode_description_label.add_theme_color_override("font_shadow_color", Color(.7, .39, .2, 1))
			gamemode_label.add_theme_color_override("font_shadow_color", Color(.7, .39, .2, 1))
		elif juggernaut_button.has_focus():
			gamemode_label.text = "JUGGERNAUT"
			gamemode_description_label.text = "DESTROY THE GIANT, STRONG, HARD-HITTING JUGGERNAUT, TO BECOME THE NEW JUGGERNAUT! KNOCK OUT OPPONENTS AS JUGGERNAUT TO EARN 5 POINTS AND WIN THE GAME!"
			gamemode_description_label.add_theme_color_override("font_shadow_color", Color(.61, .12, .09, 1))
			gamemode_label.add_theme_color_override("font_shadow_color", Color(.61, .12, .09, 1))
			
func switch_to_teammodes():
	if current_state == state.GAMEMODESELECT:
		for button in gamemode_buttons:
			button.visible = false
			button.disabled = true
		gamemode_label.visible = false
		gamemode_description_label.visible = false
		zombies_button.icon = CLASSIC_BUTTON_GREEN
		juggernaut_button.icon = CLASSIC_BUTTON_RED
		
	current_state = state.TEAMMODESELECT
	
	twovstwo_button.disabled = false
	twovstwo_button.visible = true
	ffa_button.disabled = false
	ffa_button.visible = true
	ffa_label.visible = true
	twovstwo_label.visible = true
	
	top_label.text = "TEAM MODE SELECT"
	if current_team_type == TEAM_TYPE.FFA:
		ffa_button.grab_focus()
	else:
		twovstwo_button.grab_focus()
	
func switch_to_gamemodes():
	if current_state == state.MAPSELECT:
		if background.texture == ffa_background:
			background.texture = ffa_gamemode_background
		elif background.texture == twovstwo_background:
			background.texture = twovstwo_gamemode_background
			
		for button in map_buttons_array:
			button.visible = false
			button.disabled = true
			
		select_all_button.visible = false
		select_all_button.disabled = true
		select_none_button.visible = false
		select_none_button.disabled = true
		continue_button.visible = false
		continue_button.disabled = true
		map_name_label.visible = false
			
	current_state = state.GAMEMODESELECT
	
	twovstwo_button.disabled = true
	twovstwo_button.visible = false
	ffa_button.disabled = true
	ffa_button.visible = false
	ffa_label.visible = false
	twovstwo_label.visible = false
	
	if GameSettings.current_team_type == GameSettings.TEAM_TYPE.TWOVSTWO:
		zombies_button.icon = DISABLED_BUTTON
		juggernaut_button.icon = DISABLED_BUTTON
	
	for button in gamemode_buttons:
		button.visible = true
		button.disabled = false
	gamemode_label.visible = true
	gamemode_description_label.visible = true
	classic_button.grab_focus()
	top_label.text = "GAMEMODE SELECT"
	
func switch_to_map_selection():
	
	if background.texture == ffa_gamemode_background:
		background.texture = ffa_background
	elif background.texture == twovstwo_gamemode_background:
		background.texture = twovstwo_background
	
	for button in gamemode_buttons:
		button.visible = false
		button.disabled = true
		
	gamemode_label.visible = false
	gamemode_description_label.visible = false
	
	#Character select
	
	character_select_buttons.visible = false
	player_1_button.disabled = true
	player_2_button.disabled = true
	player_3_button.disabled = true
	player_4_button.disabled = true
	
	#Map
		
	for button in map_buttons_array:
		button.visible = true
		button.disabled = false
		
	select_all_button.visible = true
	select_all_button.disabled = false
	select_none_button.visible = true
	select_none_button.disabled = false
	continue_button.visible = true
	continue_button.disabled = false
	map_name_label.visible = true
		
	sand_map_button.grab_focus()
	
	map_buttons.visible = true
	current_state = state.MAPSELECT
	top_label.text = "MAP SELECTION"

func switch_to_character_selection():
	for button in map_buttons_array:
		button.visible = false
		button.disabled = true
		
	select_all_button.visible = false
	select_all_button.disabled = true
	select_none_button.visible = false
	select_none_button.disabled = true
	continue_button.visible = false
	continue_button.disabled = true
	map_name_label.visible = false
	
	# Char select stuff
	character_select_buttons.visible = true
	player_1_button.disabled = false
	player_2_button.disabled = false
	player_3_button.disabled = false
	player_4_button.disabled = false
	
	player_1_button.grab_focus()
	top_label.text = "CHARACTER SELECT"
			
func _on_ffa_button_pressed():
	background.texture = ffa_gamemode_background
	current_team_type = TEAM_TYPE.FFA
	GameSettings.current_team_type = GameSettings.TEAM_TYPE.FFA
	switch_to_gamemodes()

func _on_v_2_button_pressed():
	background.texture = twovstwo_gamemode_background
	current_team_type = TEAM_TYPE.TWOVSTWO
	GameSettings.current_team_type = GameSettings.TEAM_TYPE.TWOVSTWO
	switch_to_gamemodes()
	
func _on_classic_button_pressed():
	current_gamemode = GAMEMODE.CLASSIC
	GameSettings.current_gamemode = GameSettings.GAMEMODE.CLASSIC
	switch_to_map_selection()

func _on_arrow_rain_button_pressed():
	current_gamemode = GAMEMODE.ARROWRAIN
	GameSettings.current_gamemode = GameSettings.GAMEMODE.ARROWRAIN
	switch_to_map_selection()

func _on_super_sized_button_pressed():
	current_gamemode = GAMEMODE.SUPERSIZED
	GameSettings.current_gamemode = GameSettings.GAMEMODE.SUPERSIZED
	switch_to_map_selection()

func _on_zombies_button_pressed():
	if current_team_type == TEAM_TYPE.FFA:
		current_gamemode = GAMEMODE.ZOMBIES
		GameSettings.current_gamemode = GameSettings.GAMEMODE.ZOMBIES
		switch_to_map_selection()

func _on_wanted_button_pressed():
	current_gamemode = GAMEMODE.WANTED
	GameSettings.current_gamemode = GameSettings.GAMEMODE.WANTED
	switch_to_map_selection()

func _on_juggernaut_button_pressed():
	if current_team_type == TEAM_TYPE.FFA:
		current_gamemode = GAMEMODE.JUGGERNAUT
		GameSettings.current_gamemode = GameSettings.GAMEMODE.JUGGERNAUT
		switch_to_map_selection()

func edit_chosen_maps_array(map_name, address):
	if map_name in chosen_maps:
		address.texture = MAP_NOT_APPROVED
		chosen_maps.erase(map_name)
	else:
		address.texture = MAP_APPROVED
		chosen_maps.append(map_name)

func _on_sand_map_button_pressed():
	edit_chosen_maps_array("SANDY PLATFORM (1V1)", $MapButtons/SandMapButton/ButtonApproval)

func _on_sand_map_moving_button_pressed():
	edit_chosen_maps_array("RISING SANDY PLATFORM (1V1)", $MapButtons/SandMapMovingButton/ButtonApproval)

func _on_sand_map_big_button_pressed():
	edit_chosen_maps_array( "BIG SANDY PLATFORM (2V2)", $MapButtons/SandMapBigButton/ButtonApproval)

func _on_grass_map_button_pressed():
	edit_chosen_maps_array( "GRASSY PLATFORM (1V1)", $MapButtons/GrassMapButton/ButtonApproval)

func _on_grass_map_moving_button_pressed():
	edit_chosen_maps_array( "RISING GRASSY PLATFORM (1V1)", $MapButtons/GrassMapMovingButton/ButtonApproval)

func _on_grass_map_big_button_pressed():
	edit_chosen_maps_array( "BIG GRASSY PLATFORM (2V2)",$MapButtons/GrassMapBigButton/ButtonApproval)

func _on_pink_map_pillars_button_pressed():
	edit_chosen_maps_array( "PINK MAP PILLARS (2V2)",$MapButtons/PinkMapPillarsButton/ButtonApproval )

func _on_pink_map_rising_button_pressed():
	edit_chosen_maps_array( "RISING PINK PILLARS (HYBRID)",$MapButtons/PinkMapRisingButton/ButtonApproval )

func _on_purple_map_small_button_pressed():
	edit_chosen_maps_array( "PURPLE ISLANDS (1V1)", $MapButtons/PurpleMapSmallButton/ButtonApproval)

func _on_purple_map_big_button_pressed():
	edit_chosen_maps_array( "PURPLE ISLANDS (2V2)", $MapButtons/PurpleMapBigButton/ButtonApproval)

func _on_castle_map_cages_button_pressed():
	edit_chosen_maps_array( "CASTLE CAGES (LAVA) (HYBRID)",$MapButtons/CastleMapCagesButton/ButtonApproval )

func _on_castle_wall_map_button_pressed():
	edit_chosen_maps_array( "CASTLE WALL (HYBRID)", $MapButtons/CastleWallMapButton/ButtonApproval)

func _on_castle_wall_map_rising_lava_button_pressed():
	edit_chosen_maps_array( "DYNAMIC CASTLE WALL (ENVIRONMENTAL) (HYBRID)", $MapButtons/CastleWallMapRisingLavaButton/ButtonApproval)

func _on_work_shop_map_button_pressed():
	edit_chosen_maps_array( "WORKSHOP (HYBRID)", $MapButtons/WorkShopMapButton/ButtonApproval)

func _on_night_cave_map_button_pressed():
	edit_chosen_maps_array( "NIGHT CAVE (HYBRID)", $MapButtons/NightCaveMapButton/ButtonApproval)
	
func _on_grass_map_button_2_pressed():
	edit_chosen_maps_array( "WIP 1",$MapButtons/GrassMapButton2/ButtonApproval )

func _on_grass_map_moving_button_2_pressed():
	edit_chosen_maps_array( "WIP 2", $MapButtons/GrassMapMovingButton2/ButtonApproval)

func _on_grass_map_big_button_2_pressed():
	edit_chosen_maps_array( "WIP 3", $MapButtons/GrassMapBigButton2/ButtonApproval)

func _on_select_all_button_pressed():
	chosen_maps = []
	
	edit_chosen_maps_array("SANDY PLATFORM (1V1)", $MapButtons/SandMapButton/ButtonApproval)
	edit_chosen_maps_array("RISING SANDY PLATFORM (1V1)", $MapButtons/SandMapMovingButton/ButtonApproval)
	edit_chosen_maps_array( "BIG SANDY PLATFORM (2V2)", $MapButtons/SandMapBigButton/ButtonApproval)
	edit_chosen_maps_array( "GRASSY PLATFORM (1V1)", $MapButtons/GrassMapButton/ButtonApproval)
	edit_chosen_maps_array( "RISING GRASSY PLATFORM (1V1)", $MapButtons/GrassMapMovingButton/ButtonApproval)
	edit_chosen_maps_array( "BIG GRASSY PLATFORM (2V2)",$MapButtons/GrassMapBigButton/ButtonApproval)
	edit_chosen_maps_array( "PINK MAP PILLARS (2V2)",$MapButtons/PinkMapPillarsButton/ButtonApproval )
	edit_chosen_maps_array( "RISING PINK PILLARS (HYBRID)",$MapButtons/PinkMapRisingButton/ButtonApproval )
	edit_chosen_maps_array( "PURPLE ISLANDS (1V1)", $MapButtons/PurpleMapSmallButton/ButtonApproval)
	edit_chosen_maps_array( "PURPLE ISLANDS (2V2)", $MapButtons/PurpleMapBigButton/ButtonApproval)
	edit_chosen_maps_array( "CASTLE CAGES (LAVA) (HYBRID)",$MapButtons/CastleMapCagesButton/ButtonApproval )
	edit_chosen_maps_array( "CASTLE WALL (HYBRID)", $MapButtons/CastleWallMapButton/ButtonApproval)
	edit_chosen_maps_array( "DYNAMIC CASTLE WALL (ENVIRONMENTAL) (HYBRID)", $MapButtons/CastleWallMapRisingLavaButton/ButtonApproval)
	edit_chosen_maps_array( "WORKSHOP (HYBRID)", $MapButtons/WorkShopMapButton/ButtonApproval)
	edit_chosen_maps_array( "NIGHT CAVE (HYBRID)", $MapButtons/NightCaveMapButton/ButtonApproval)
	edit_chosen_maps_array( "WIP 1",$MapButtons/GrassMapButton2/ButtonApproval )
	edit_chosen_maps_array( "WIP 2", $MapButtons/GrassMapMovingButton2/ButtonApproval)
	edit_chosen_maps_array( "WIP 3", $MapButtons/GrassMapBigButton2/ButtonApproval)
	
func _on_select_none_button_pressed():
	chosen_maps = []
	chosen_maps.append_array(maps)
	
	edit_chosen_maps_array("SANDY PLATFORM (1V1)", $MapButtons/SandMapButton/ButtonApproval)
	edit_chosen_maps_array("RISING SANDY PLATFORM (1V1)", $MapButtons/SandMapMovingButton/ButtonApproval)
	edit_chosen_maps_array( "BIG SANDY PLATFORM (2V2)", $MapButtons/SandMapBigButton/ButtonApproval)
	edit_chosen_maps_array( "GRASSY PLATFORM (1V1)", $MapButtons/GrassMapButton/ButtonApproval)
	edit_chosen_maps_array( "RISING GRASSY PLATFORM (1V1)", $MapButtons/GrassMapMovingButton/ButtonApproval)
	edit_chosen_maps_array( "BIG GRASSY PLATFORM (2V2)",$MapButtons/GrassMapBigButton/ButtonApproval)
	edit_chosen_maps_array( "PINK MAP PILLARS (2V2)",$MapButtons/PinkMapPillarsButton/ButtonApproval )
	edit_chosen_maps_array( "RISING PINK PILLARS (HYBRID)",$MapButtons/PinkMapRisingButton/ButtonApproval )
	edit_chosen_maps_array( "PURPLE ISLANDS (1V1)", $MapButtons/PurpleMapSmallButton/ButtonApproval)
	edit_chosen_maps_array( "PURPLE ISLANDS (2V2)", $MapButtons/PurpleMapBigButton/ButtonApproval)
	edit_chosen_maps_array( "CASTLE CAGES (LAVA) (HYBRID)",$MapButtons/CastleMapCagesButton/ButtonApproval )
	edit_chosen_maps_array( "CASTLE WALL (HYBRID)", $MapButtons/CastleWallMapButton/ButtonApproval)
	edit_chosen_maps_array( "DYNAMIC CASTLE WALL (ENVIRONMENTAL) (HYBRID)", $MapButtons/CastleWallMapRisingLavaButton/ButtonApproval)
	edit_chosen_maps_array( "WORKSHOP (HYBRID)", $MapButtons/WorkShopMapButton/ButtonApproval)
	edit_chosen_maps_array( "NIGHT CAVE (HYBRID)", $MapButtons/NightCaveMapButton/ButtonApproval)
	edit_chosen_maps_array( "WIP 1",$MapButtons/GrassMapButton2/ButtonApproval )
	edit_chosen_maps_array( "WIP 2", $MapButtons/GrassMapMovingButton2/ButtonApproval)
	edit_chosen_maps_array( "WIP 3", $MapButtons/GrassMapBigButton2/ButtonApproval)

func _on_continue_button_pressed():
	if chosen_maps.size() > 0:
		GameSettings.chosen_maps = chosen_maps
		GameSettings.current_map = chosen_maps[randi_range(0, chosen_maps.size()-1)]
		GameSettings.transition = true
		current_state = state.TRANSITIONING
