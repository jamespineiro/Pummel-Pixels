extends Node2D

@onready var rematch_different_map_button = $RematchDifferentMapButton
@onready var play_again_button = $PlayAgainButton
@onready var back_to_menu_button = $BackToMenuButton
@onready var button_wait_timer = $ButtonWaitTimer
const CLASSIC_BUTTON_RED = preload("res://assets/MenuUI/ClassicButton3.png")
const CLASSIC_BUTTON_GREEN = preload("res://assets/MenuUI/ClassicButton4.png")
const CLASSIC_BUTTON_BLUE = preload("res://assets/MenuUI/ClassicButton.png")
var can_continue = false

@onready var first_place_dmg_taken = $PlayerStats/PlayerDmgTaken/FirstPlaceDmgTaken
@onready var second_place_dmg_taken = $PlayerStats/PlayerDmgTaken/SecondPlaceDmgTaken
@onready var third_place_dmg_taken = $PlayerStats/PlayerDmgTaken/ThirdPlaceDmgTaken
@onready var fourth_place_dmg_taken = $PlayerStats/PlayerDmgTaken/FourthPlaceDmgTaken
@onready var first_place_dmg_taken_number = $PlayerStats/PlayerDmgTaken/FirstPlaceDmgTakenNumber
@onready var second_place_dmg_taken_number = $PlayerStats/PlayerDmgTaken/SecondPlaceDmgTakenNumber
@onready var third_place_dmg_taken_number = $PlayerStats/PlayerDmgTaken/ThirdPlaceDmgTakenNumber
@onready var fourth_place_dmg_taken_number = $PlayerStats/PlayerDmgTaken/FourthPlaceDmgTakenNumber
@onready var first_place_k_os = $PlayerStats/PlayerKOs/FirstPlaceKOs
@onready var second_place_k_os = $PlayerStats/PlayerKOs/SecondPlaceKOs
@onready var third_place_k_os = $PlayerStats/PlayerKOs/ThirdPlaceKOs
@onready var fourth_place_k_os = $PlayerStats/PlayerKOs/FourthPlaceKOs
@onready var first_place_ko_number = $PlayerStats/PlayerKOs/FirstPlaceKONumber
@onready var second_place_ko_number = $PlayerStats/PlayerKOs/SecondPlaceKONumber
@onready var third_place_ko_number = $PlayerStats/PlayerKOs/ThirdPlaceKONumber
@onready var fourth_place_ko_number = $PlayerStats/PlayerKOs/FourthPlaceKONumber
@onready var first_place_dmg_dealt = $PlayerStats/PlayerDmg/FirstPlaceDmgDealt
@onready var second_place_dmg_dealt = $PlayerStats/PlayerDmg/SecondPlaceDmgDealt
@onready var third_place_dmg_dealt = $PlayerStats/PlayerDmg/ThirdPlaceDmgDealt
@onready var fourth_place_dmg_dealt = $PlayerStats/PlayerDmg/FourthPlaceDmgDealt
@onready var first_place_dmg_dealt_number = $PlayerStats/PlayerDmg/FirstPlaceDmgDealtNumber
@onready var second_place_dmg_dealt_number = $PlayerStats/PlayerDmg/SecondPlaceDmgDealtNumber
@onready var third_place_dmg_dealt_number = $PlayerStats/PlayerDmg/ThirdPlaceDmgDealtNumber
@onready var fourth_place_dmg_dealt_number = $PlayerStats/PlayerDmg/FourthPlaceDmgDealtNumber

@onready var first_place_stats = [first_place_dmg_taken, first_place_dmg_taken_number, first_place_dmg_dealt_number
								, first_place_k_os, first_place_ko_number, first_place_dmg_dealt]
@onready var second_place_stats = [second_place_dmg_taken, second_place_dmg_taken_number, second_place_dmg_dealt_number
								, second_place_k_os, second_place_ko_number, second_place_dmg_dealt]
@onready var third_place_stats = [third_place_dmg_taken, third_place_dmg_taken_number, third_place_dmg_dealt_number
								, third_place_k_os, third_place_ko_number, third_place_dmg_dealt]
@onready var fourth_place_stats = [fourth_place_dmg_taken, fourth_place_dmg_taken_number, fourth_place_dmg_dealt_number
								, fourth_place_k_os, fourth_place_ko_number, fourth_place_dmg_dealt]
								
@onready var first_place_numbers = [first_place_dmg_taken_number, first_place_dmg_dealt_number, first_place_ko_number]
@onready var second_place_numbers = [second_place_dmg_taken_number, second_place_dmg_dealt_number, second_place_ko_number]
@onready var third_place_numbers = [third_place_dmg_taken_number, third_place_dmg_dealt_number, third_place_ko_number]
@onready var fourth_place_numbers = [fourth_place_dmg_taken_number, fourth_place_dmg_dealt_number, fourth_place_ko_number]
@onready var placement_numbers = [first_place_numbers, second_place_numbers, third_place_numbers, fourth_place_numbers]
@onready var placement_booleans = [false, false, false, false]

@onready var player_1 = $Player1
@onready var player_2 = $Player2
@onready var player_3 = $Player3
@onready var player_4 = $Player4

var player_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	var _players = []
	
	play_again_button.grab_focus()
	button_wait_timer.start()
	if GameSettings.player1_selected:
		player_count+=1
		player_1.visible = true
	if GameSettings.player2_selected:
		player_count+=1
		player_2.visible = true
	if GameSettings.player3_selected:
		player_count+=1
		player_3.visible = true
	if GameSettings.player4_selected:
		player_count+=1
		player_4.visible = true
			
	var placement_order = []
	
	var performance_scores = []
	
	var player1_performance_score = -999
	var player2_performance_score = -999
	var player3_performance_score = -999
	var player4_performance_score = -999
	
	if player_count > 0:
		player1_performance_score = (GameSettings.player1_dmg_dealt - GameSettings.player1_dmg_taken) + (GameSettings.player1_knockouts * 100)
		performance_scores.append(player1_performance_score)
	if player_count > 1:
		player2_performance_score = (GameSettings.player2_dmg_dealt - GameSettings.player2_dmg_taken) + (GameSettings.player2_knockouts * 100)
		performance_scores.append(player2_performance_score)
	if player_count > 2:
		player3_performance_score = (GameSettings.player3_dmg_dealt - GameSettings.player3_dmg_taken) + (GameSettings.player3_knockouts * 100)
		performance_scores.append(player3_performance_score)
	if player_count > 3:
		player4_performance_score = (GameSettings.player4_dmg_dealt - GameSettings.player4_dmg_taken) + (GameSettings.player4_knockouts * 100)
		performance_scores.append(player4_performance_score)

	performance_scores.sort()
	
	var index = 0
	
	while performance_scores.size() != 0:
		if GameSettings.player1_selected and performance_scores[performance_scores.size()-1] == player1_performance_score:
			placement_order.append(player_1)
			performance_scores.pop_back()
			placement_numbers[index][1].text = str(GameSettings.player1_dmg_dealt)
			placement_numbers[index][0].text = str(int(GameSettings.player1_dmg_taken))
			placement_numbers[index][2].text = str(GameSettings.player1_knockouts)
		elif GameSettings.player2_selected and performance_scores[performance_scores.size()-1] == player2_performance_score:
			placement_order.append(player_2)
			performance_scores.pop_back()
			placement_numbers[index][1].text = str(GameSettings.player2_dmg_dealt)
			placement_numbers[index][0].text = str(int(GameSettings.player2_dmg_taken))
			placement_numbers[index][2].text = str(GameSettings.player2_knockouts)
		elif GameSettings.player3_selected and performance_scores[performance_scores.size()-1] == player3_performance_score:
			placement_order.append(player_3)
			performance_scores.pop_back()
			placement_numbers[index][1].text = str(GameSettings.player3_dmg_dealt)
			placement_numbers[index][0].text = str(int(GameSettings.player3_dmg_taken))
			placement_numbers[index][2].text = str(GameSettings.player3_knockouts)
		elif GameSettings.player4_selected and performance_scores[performance_scores.size()-1] == player4_performance_score:
			placement_order.append(player_4)
			performance_scores.pop_back()
			placement_numbers[index][1].text = str(GameSettings.player4_dmg_dealt)
			placement_numbers[index][0].text = str(int(GameSettings.player4_dmg_taken))
			placement_numbers[index][2].text = str(GameSettings.player4_knockouts)
		index+=1
	
	if player_count > 0:
		for stat in first_place_stats:
			stat.visible = true
		if not placement_booleans[0]:
			placement_order[0].global_position = Vector2(169,150)
			placement_booleans[0] = true
		elif not placement_booleans[1]:
			placement_order[0].global_position = Vector2(248,166)
			placement_booleans[1] = true
		elif not placement_booleans[2]:
			placement_order[0].global_position = Vector2(329,182)
			placement_booleans[2] = true
		elif not placement_booleans[3]:
			placement_order[0].global_position = Vector2(409,198)
			placement_booleans[3] = true
	if player_count > 1:
		for stat in second_place_stats:
			stat.visible = true
		if not placement_booleans[1]:
			placement_order[1].global_position = Vector2(248,166)
			placement_booleans[1] = true
		elif not placement_booleans[2]:
			placement_order[1].global_position = Vector2(329,182)
			placement_booleans[2] = true
		elif not placement_booleans[3]:
			placement_order[1].global_position = Vector2(409,198)
			placement_booleans[3] = true
	if player_count > 2:
		for stat in third_place_stats:
			stat.visible = true
		if not placement_booleans[2]:
			placement_order[2].global_position = Vector2(329,182)
			placement_booleans[2] = true
		elif not placement_booleans[3]:
			placement_order[2].global_position = Vector2(409,198)
			placement_booleans[3] = true
	if player_count > 3:
		for stat in fourth_place_stats:
			stat.visible = true
		if not placement_booleans[3]:
			placement_order[3].global_position = Vector2(409,198)
			placement_booleans[3] = true
		elif not placement_booleans[2]:
			placement_order[3].global_position = Vector2(329,182)
			placement_booleans[2] = true
		
func _on_play_again_button_pressed():
	if can_continue:
		GameSettings.transition = true

func _on_back_to_menu_button_pressed():
	if can_continue:
		get_tree().change_scene_to_file("res://scenes/starting_scene.tscn")

func _on_rematch_different_map_button_pressed():
	if can_continue:
		GameSettings.current_map = GameSettings.chosen_maps[randi_range(0, GameSettings.chosen_maps.size()-1)]
		_on_play_again_button_pressed()

func _on_button_wait_timer_timeout():
	can_continue = true
	play_again_button.icon = CLASSIC_BUTTON_GREEN
	back_to_menu_button.icon = CLASSIC_BUTTON_RED
	rematch_different_map_button.icon = CLASSIC_BUTTON_BLUE
	button_wait_timer.stop()
