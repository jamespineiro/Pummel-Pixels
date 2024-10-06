extends Node

# Game setup settings

@onready var chosen_maps = ["SANDY PLATFORM (1V1)", "SANDY HEIGHTS (1V1)", "BIG SANDY PLATFORM (2V2)",
"GRASSY PLATFORM (1V1)", "GRASSY CAVE (HYBRID)", "BIG GRASSY PLATFORM (2V2)",
"PINK MAP PILLARS (2V2)", "RISING PINK PILLARS (HYBRID)", "PURPLE ISLANDS (1V1)",
"PURPLE ISLANDS (2V2)", "CASTLE CAGES (LAVA) (HYBRID)", "CASTLE WALL (HYBRID)",
"DYNAMIC CASTLE WALL (ENVIRONMENTAL) (HYBRID)", "WORKSHOP (HYBRID)", "NIGHT CAVE (HYBRID)",
"WIP 1", "WIP 2", "WIP 3"]

@onready var current_map = "SANDY PLATFORM (1V1)"

enum TEAM_TYPE {FFA, TWOVSTWO}
var current_team_type = TEAM_TYPE.FFA
enum GAMEMODE {CLASSIC, ARROWRAIN, SUPERSIZED, ZOMBIES, WANTED, JUGGERNAUT, PRACTICE}
var current_gamemode = GAMEMODE.CLASSIC
var game_time = 424
var game_lives = 3

# Gamemode Variables

var chose_juggernaut = false
var juggernaut_number = 0
var transition = false
var transition_camera_zoom = 7.73599243164062

# Attack balancing

const SATTACK1_X_VELOCITY = -400
const SATTACK1_Y_VELOCITY = -15700
const SATTACK1_DAMAGE = 3

const SAIRATTACK_X_VELOCITY = -300
const SAIRATTACK_Y_VELOCITY = -10700
const SAIRATTACK_DAMAGE = 3

const SATTACK2_X_VELOCITY = -500
const SATTACK2_Y_VELOCITY = -15700
const SATTACK2_DAMAGE = 3

const SATTACK3_X_VELOCITY = -800
const SATTACK3_Y_VELOCITY = -15700
const SATTACK3_DAMAGE = 8

const UPATTACKING_X_VELOCITY = -200
const UPATTACKING_Y_VELOCITY = -25700
const UPATTACKING_DAMAGE = 3

const AIRUPATTACKING_X_VELOCITY = -350
const AIRUPATTACKING_Y_VELOCITY = -20700
const AIRUPATTACKING_DAMAGE = 3

const AIRSPECIALING_X_VELOCITY = -550
const AIRSPECIALING_Y_VELOCITY = -3000
const AIRSPECIALING_DAMAGE = 10
			
const AIRPUNCHING_X_VELOCITY = -550
const AIRPUNCHING_Y_VELOCITY = 14000
const AIRPUNCHING_DAMAGE = 8
					
const SLIDING_X_VELOCITY = -550
const SLIDING_Y_VELOCITY = -24000
const SLIDING_DAMAGE = 8

const DAIRSPECIALING_X_VELOCITY = 5
const DAIRSPECIALING_Y_VELOCITY = -13000
const DAIRSPECIALING_DAMAGE = 4

const CRYING_X_VELOCITY = -850
const CRYING_Y_VELOCITY = -20000
const CRYING_OVER_OTHER_PLAYER_Y_VELOCITY = 10000
const CRYING_DAMAGE = 20

const DOWNATTACKING_X_VELOCITY = -5
const DOWNATTACKING_Y_VELOCITY = -18000
const DOWNATTACKING_NOT_ON_FLOOR_Y_VELOCITY = 12000
const DOWNATTACKING_DAMAGE = 3

# Player Selection
var player1_selected = true
var player2_selected = false
var player3_selected = false
var player4_selected = false
var player_count = 0;

var player1_player_index = 0
var player2_player_index = 1
var player3_player_index = 2
var player4_player_index = 3

var player1_dmg_dealt = 0
var player2_dmg_dealt = 0
var player3_dmg_dealt = 0
var player4_dmg_dealt = 0

var player1_dmg_taken = 0
var player2_dmg_taken = 0
var player3_dmg_taken = 0
var player4_dmg_taken = 0

var player1_knockouts = 0
var player2_knockouts = 0
var player3_knockouts = 0
var player4_knockouts = 0

var blue_team = []
var red_team = []
	
# Called when the node enters the scene tree for the first time.
func _ready():
	player_count = 0
	if player1_selected:
		player_count+=1
	if player2_selected:
		player_count+=1
	if player3_selected:
		player_count+=1
	if player4_selected:
		player_count+=1

func update_player_count():
	player_count = 0
	if player1_selected:
		player_count+=1
	if player2_selected:
		player_count+=1
	if player3_selected:
		player_count+=1
	if player4_selected:
		player_count+=1
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_player_count()
	if current_gamemode == GAMEMODE.JUGGERNAUT and not chose_juggernaut:
		juggernaut_number = randi_range(0, Input.get_connected_joypads().size()-1)
		if juggernaut_number == -1:
			juggernaut_number = 0
		chose_juggernaut = true
	
func refresh():
	if chose_juggernaut:
		chose_juggernaut = false

func reset_player_stats():
	player1_dmg_dealt = 0
	player2_dmg_dealt = 0
	player3_dmg_dealt = 0
	player4_dmg_dealt = 0

	player1_dmg_taken = 0
	player2_dmg_taken = 0
	player3_dmg_taken = 0
	player4_dmg_taken = 0

	player1_knockouts = 0
	player2_knockouts = 0
	player3_knockouts = 0
	player4_knockouts = 0
