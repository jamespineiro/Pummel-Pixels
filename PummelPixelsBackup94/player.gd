extends CharacterBody2D

@onready var main = get_tree().get_root()
@onready var arrow = load("res://scenes/arrow.tscn")
@onready var hit_cloud = load("res://scenes/cloudthatwaswaytoohardtoimplement.tscn")

@export var player_index = GameSettings.player1_player_index
var team_name = "team-one"

@onready var player_2 : CharacterBody2D
@onready var player_3 : CharacterBody2D
@onready var player_4 : CharacterBody2D

var dodge_meter_4_image = preload("res://assets/Player1DodgeMeter4.png")
var dodge_meter_3_image = preload("res://assets/Player1DodgeMeter3.png")
var dodge_meter_2_image = preload("res://assets/Player1DodgeMeter2.png")
var dodge_meter_1_image = preload("res://assets/Player1DodgeMeter1.png")
var dodge_meter_0_image = preload("res://assets/Player1DodgeMeter0.png")
var arrow_meter_3_image = preload("res://assets/Player1ArrowUI3.png")
var arrow_meter_2_image = preload("res://assets/Player1ArrowUI2.png")
var arrow_meter_1_image = preload("res://assets/Player1ArrowUI1.png")
var arrow_meter_0_image = preload("res://assets/Player1ArrowUI0.png")

@export var health = 0
@export var lives = 50
@export var score = 0
var NORMAL_SPEED = 115.0
var SPEED = 115.0
const DODGING_SPEED = 125.0
const DODGING_COOLDOWN_SPEED = 105.0
const CHARGING_SPEED = 150.0
const AIR_SPECIALING_SPEED = 95.0
const CHARGE_AIR_SPECIALING_SPEED = 175.0
const JUMP_VELOCITY = -300.0
const ATTACKING_SPEED = 70.0
const DASH_ATTACKING_SPEED = 50
const SLIDING_SPEED = 75.0
const CHARGE_SLIDING_SPEED = 105.0
const MAX_SPECIALS = 2
const INITIAL_JUMP_SPEED = 800.0
const RECOVERY_SPEED = 40.0
var climb_slip_speed = 0.0

enum animation {IDLE, RUNNING, JUMPING, EMOTING, CROSSBOWING,
 AIRPUNCHING, SHIELDING, SATTACK1, SATTACK2, SATTACK3, UPATTACKING,
 DOWNATTACKING, AIRSPECIALING, DAIRSPECIALING, CHARGING, SLIDING,
 CRYING, GLIDING, AIRUPATTACKING, AIRCROSSBOWING, AIRDOWNATTACKING,
 CLIMBINGLEFT, CLIMBINGRIGHT, CROUCHING, NEUTRALDODGING, SIDEDODGING,
 UPDODGING, DOWNDODGING, SAIRATTACK, AIRSHIELDING, GROUNDAIRUPATTACKING, AIRCRYING,
 HIT, HITSTUNNED}

var current_animation = animation.IDLE

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var direction = Input.get_axis("left"+str(player_index), "right"+str(player_index))
@export var dead = false
var jump_count = 0
var atk_count = 0
var special_count = 0
var charging = false
var sliding = false
var crying = false
var side_attacking = false
var charge_on_cooldown = false
var just_shot = false
var dodges_left = 4
@export var arrows_left = 3
var no_arrows = false
var other_velocity = 0.0
var arrow_speed = 0.0
var dair_special_count = 0
var can_explode = true
var starting_position_x : int
var starting_position_y : int
var colliding_with_arrow = false
var starting_round = false

@onready var sprite = $AnimatedSprite2D

@onready var timer = $AttackTimers/SideAttackTimer
@onready var slide_timer = $SpecialTimers/SlideTimer
@onready var cry_timer = $SpecialTimers/CryTimer
@onready var respawn_timer = $RespawnTimer

@onready var immunity_timer = $ImmunityTimer

@onready var dodge_timer = $DodgeTimers/DodgeTimer
@onready var dodge_cooldown = $DodgeTimers/DodgeCooldown
@onready var dodge_super_cooldown = $DodgeTimers/DodgeSuperCooldown

@onready var dodge_meter_ui = $DodgeMeterUI
@onready var arrow_meter_ui = $ArrowMeterUI

var dodge_meter_images = [dodge_meter_0_image, dodge_meter_1_image,
dodge_meter_2_image, dodge_meter_3_image, dodge_meter_4_image]

var killzone_script = preload("res://killzone.gd")

@onready var attack_hurt_box = $AttackHurtBox

@onready var shield_box = $ShieldHurtBox/ShieldBox
@onready var shield_box_flipped = $ShieldHurtBox/ShieldBoxFlipped
@onready var side_attack_1_box = $AttackHurtBox/SideAttack1Box
@onready var side_attack_1_box_flipped = $AttackHurtBox/SideAttack1BoxFlipped
@onready var side_attack_2_box = $AttackHurtBox/SideAttack2Box
@onready var side_attack_2_box_flipped = $AttackHurtBox/SideAttack2BoxFlipped
@onready var side_attack_3_box = $AttackHurtBox/SideAttack3Box
@onready var side_attack_3_box_flipped = $AttackHurtBox/SideAttack3BoxFlipped
@onready var up_attack_box = $AttackHurtBox/UpAttackBox
@onready var up_attack_box_flipped = $AttackHurtBox/UpAttackBoxFlipped
@onready var side_special_air_box = $AttackHurtBox/SideSpecialAirBox
@onready var side_special_air_box_flipped = $AttackHurtBox/SideSpecialAirBoxFlipped
@onready var air_punch_box = $AttackHurtBox/AirPunchBox
@onready var air_punch_box_flipped = $AttackHurtBox/AirPunchBoxFlipped
@onready var sliding_box = $AttackHurtBox/SlidingBox
@onready var sliding_box_flipped = $AttackHurtBox/SlidingBoxFlipped
@onready var air_down_attack_box = $AttackHurtBox/AirDownAttackBox
@onready var crying_box = $AttackHurtBox/CryingBox
@onready var crying_box_flipped = $AttackHurtBox/CryingBoxFlipped
@onready var down_attack_box_1 = $AttackHurtBox/DownAttackBox1
@onready var down_attack_box_2 = $AttackHurtBox/DownAttackBox2
@onready var down_attack_box_2_flipped = $AttackHurtBox/DownAttackBox2Flipped
@onready var down_attack_box_1_flipped = $AttackHurtBox/DownAttackBox1Flipped

@onready var up_attack_sword_slash = $SoundEffects/UpAttackSwordSlash
@onready var s_attack_2_sword_slash = $SoundEffects/SAttack2SwordSlash
@onready var s_attack_3_sword_slash = $SoundEffects/SAttack3SwordSlash
@onready var s_attack_1_sword_slash = $SoundEffects/SAttack1SwordSlash
@onready var down_air_attack = $SoundEffects/DownAirAttack
@onready var fire_attack = $SoundEffects/FireAttack
@onready var hit_sound = $SoundEffects/HitSound
@onready var cry_sound = $SoundEffects/CrySound
@onready var air_punch_sound = $SoundEffects/AirPunchSound
@onready var shield_sound = $SoundEffects/ShieldSound
@onready var shield_block = $SoundEffects/ShieldBlock
@onready var dodge_sound = $SoundEffects/DodgeSound
@onready var out_of_arrows_sound = $SoundEffects/OutOfArrowsSound

var hit = false
var stunned = false
var impact_y_velocity = 0.0
var impact_x_velocity = 0.0
var dodging = false
const CLOUD_STARTING_FRAMES = 2
var cloud_frames = CLOUD_STARTING_FRAMES

@onready var player_health = $PlayerHealth
@onready var scoreboard : Control
@onready var player_who_hit_me_last : CharacterBody2D

var was_sprinting = false
var gravity_capped = false

var arrow_rain_ui = preload("res://assets/ArrowRainUI.png")
var juggernaut = false

var knockouts = 0
var dmg_dealt = 0
var dmg_taken = 0

func _ready():
	if GameSettings.current_gamemode == GameSettings.GAMEMODE.SUPERSIZED:
		apply_scale(Vector2(1.5,1.5))
	if GameSettings.current_gamemode == GameSettings.GAMEMODE.ARROWRAIN:
		arrows_left = 999
		arrow_meter_ui.texture = arrow_rain_ui
			
	if GameSettings.current_team_type == GameSettings.TEAM_TYPE.TWOVSTWO:
		var team_choice = randi_range(0,1)
		if team_choice == 0:
			if GameSettings.red_team.size() < Input.get_connected_joypads().size()%2:
				team_name = "red-team"
				GameSettings.red_team.append(self)
			else:
				team_name = "blue-team"
				GameSettings.blue_team.append(self)
		else:
			if GameSettings.blue_team.size() < Input.get_connected_joypads().size()%2:
				team_name = "blue-team"
				GameSettings.blue_team.append(self)
			else:
				team_name = "red-team"
				GameSettings.red_team.append(self)
				
	if GameSettings.current_gamemode == GameSettings.GAMEMODE.JUGGERNAUT:
		if GameSettings.juggernaut_number == player_index:
			juggernaut = true
			apply_scale(Vector2(1.5,1.5))
			team_name = "red-team"
			arrows_left = 999
			arrow_meter_ui.texture = arrow_rain_ui
		else:
			team_name = "blue-team"
			
	if team_name == "red-team":
		dodge_meter_4_image = preload("res://assets/RedDodgeMeter4.png")
		dodge_meter_3_image = preload("res://assets/RedDodgeMeter3.png")
		dodge_meter_2_image = preload("res://assets/RedDodgeMeter2.png")
		dodge_meter_1_image = preload("res://assets/RedDodgeMeter1.png")
		dodge_meter_0_image = preload("res://assets/RedDodgeMeter0.png")
		dodge_meter_ui.texture = dodge_meter_4_image
		dodge_meter_images = [dodge_meter_0_image, dodge_meter_1_image,
		dodge_meter_2_image, dodge_meter_3_image, dodge_meter_4_image]
	elif team_name == "blue-team":
		dodge_meter_4_image = preload("res://assets/BlueDodgeMeter4.png")
		dodge_meter_3_image = preload("res://assets/BlueDodgeMeter3.png")
		dodge_meter_2_image = preload("res://assets/BlueDodgeMeter2.png")
		dodge_meter_1_image = preload("res://assets/BlueDodgeMeter1.png")
		dodge_meter_0_image = preload("res://assets/BlueDodgeMeter0.png")
		dodge_meter_ui.texture = dodge_meter_4_image
		dodge_meter_images = [dodge_meter_0_image, dodge_meter_1_image,
		dodge_meter_2_image, dodge_meter_3_image, dodge_meter_4_image]
		
			
	if not GameSettings.player1_selected:
		queue_free()
	else:
		visible = true
	
	scoreboard = get_node("../ScoreboardAndIcons")
	if GameSettings.player2_selected:
		player_2 = get_node("../player2")
		add_collision_exception_with(player_2)
	if GameSettings.player3_selected:
		player_3 = get_node("../player3")
		add_collision_exception_with(player_3)
	if GameSettings.player4_selected:
		player_4 = get_node("../player4")
		add_collision_exception_with(player_4)
	starting_position_x = int(global_position.x)
	starting_position_y = int(global_position.y)
	
func _physics_process(delta):
	if is_on_floor() and starting_round and current_animation != animation.EMOTING:
		sprite.play("emote")
		current_animation = animation.EMOTING
		
	GameSettings.player1_knockouts = knockouts
	GameSettings.player1_dmg_dealt = dmg_dealt
	GameSettings.player1_dmg_taken = dmg_taken
		
	# Add the gravity.
	if not starting_round and current_animation != animation.CLIMBINGLEFT and current_animation != animation.CLIMBINGRIGHT and current_animation != animation.CRYING and current_animation != animation.AIRCRYING and current_animation != animation.AIRUPATTACKING and current_animation != animation.GROUNDAIRUPATTACKING and current_animation != animation.AIRSPECIALING and current_animation != animation.CHARGING and current_animation != animation.SLIDING and current_animation != animation.SATTACK1 and current_animation != animation.SATTACK2 and current_animation != animation.SATTACK3 and current_animation != animation.CROSSBOWING and current_animation != animation.AIRCROSSBOWING and current_animation != animation.UPATTACKING and current_animation != animation.DOWNATTACKING and current_animation != animation.SHIELDING and current_animation != animation.AIRSHIELDING and current_animation != animation.AIRPUNCHING and current_animation != animation.DAIRSPECIALING:
		if Input.is_action_just_pressed("right_stick_left"+str(player_index)) and not sprite.flip_h:
			sprite.flip_h = true
			direction *= -1
		elif Input.is_action_just_pressed("right_stick_right"+str(player_index)) and sprite.flip_h:
			sprite.flip_h = false
			direction *= -1
	
	update_health_text()		
	
	if not stunned and not hit:
		if (not dead) and (not (is_on_floor()) or current_animation == animation.GROUNDAIRUPATTACKING or Input.is_action_just_pressed("sprint"+str(player_index)) or  Input.is_action_just_released("sprint"+str(player_index))):
			if Input.is_action_just_pressed("sprint"+str(player_index)):
				SPEED = CHARGING_SPEED
				if direction != 0 and current_animation != animation.SHIELDING and current_animation != animation.AIRSHIELDING and current_animation != animation.AIRCRYING and current_animation != animation.GROUNDAIRUPATTACKING and current_animation != animation.AIRSHIELDING and current_animation != animation.NEUTRALDODGING and current_animation != animation.SAIRATTACK and current_animation != animation.UPDODGING and current_animation != animation.DOWNDODGING and current_animation != animation.SIDEDODGING and current_animation != animation.AIRUPATTACKING and current_animation != animation.DAIRSPECIALING and current_animation != animation.AIRPUNCHING and current_animation != animation.CROSSBOWING and current_animation != animation.AIRCROSSBOWING and current_animation != animation.AIRSPECIALING and current_animation != animation.SATTACK1 and current_animation != animation.SATTACK2 and current_animation != animation.SATTACK3:
					sprite.play("side_special_ground")
					current_animation = animation.CHARGING
			elif (Input.is_action_just_released("sprint" + str(player_index))):
				SPEED = NORMAL_SPEED
				if current_animation == animation.CHARGING or current_animation == animation.JUMPING:
					if is_on_floor():
						sprite.play("running")
						current_animation = animation.RUNNING
					elif (current_animation != animation.SATTACK1 and current_animation != animation.SATTACK2 and current_animation != animation.SATTACK3 and current_animation != animation.AIRCRYING and current_animation != animation.AIRSHIELDING and current_animation != animation.GROUNDAIRUPATTACKING and current_animation != animation.SHIELDING and current_animation != animation.NEUTRALDODGING and current_animation != animation.SAIRATTACK and current_animation != animation.UPDODGING and current_animation != animation.DOWNDODGING and current_animation != animation.SIDEDODGING and current_animation != animation.AIRDOWNATTACKING and current_animation != animation.AIRUPATTACKING and current_animation != animation.GLIDING and current_animation != animation.DAIRSPECIALING and current_animation != animation.AIRPUNCHING and current_animation != animation.CROSSBOWING and current_animation != animation.AIRCROSSBOWING and current_animation != animation.AIRSPECIALING):
						sprite.play("jumping")
						current_animation = animation.JUMPING
			elif jump_count > 0 and velocity.y > -200 and Input.is_action_just_pressed("jump"+str(player_index)) and not is_on_wall() and current_animation != animation.AIRCRYING and current_animation != animation.GROUNDAIRUPATTACKING and current_animation != animation.AIRSHIELDING and current_animation != animation.NEUTRALDODGING and current_animation != animation.SAIRATTACK and current_animation != animation.UPDODGING and current_animation != animation.DOWNDODGING and current_animation != animation.SIDEDODGING and current_animation != animation.AIRUPATTACKING and current_animation != animation.DAIRSPECIALING and current_animation != animation.AIRPUNCHING and current_animation != animation.CROSSBOWING and current_animation != animation.AIRCROSSBOWING and current_animation != animation.AIRSPECIALING:
				sprite.play("gliding")
				current_animation = animation.GLIDING
			elif not colliding_with_arrow and is_on_wall() and current_animation != animation.GROUNDAIRUPATTACKING and current_animation != animation.AIRCRYING and current_animation != animation.AIRSHIELDING and current_animation != animation.SAIRATTACK and current_animation != animation.NEUTRALDODGING and current_animation != animation.UPDODGING and current_animation != animation.DOWNDODGING and current_animation != animation.SIDEDODGING and current_animation != animation.AIRDOWNATTACKING and current_animation != animation.AIRUPATTACKING and current_animation != animation.GLIDING and current_animation != animation.DAIRSPECIALING and current_animation != animation.AIRPUNCHING and current_animation != animation.CROSSBOWING and current_animation != animation.AIRCROSSBOWING and current_animation != animation.AIRSPECIALING:
				if direction < 0:
					sprite.play("climbing_left")
					current_animation = animation.CLIMBINGLEFT
				elif direction > 0:
					sprite.play("climbing_right")
					current_animation = animation.CLIMBINGRIGHT
			elif (Input.is_action_just_released("jump"+str(player_index)) and current_animation == animation.GLIDING) or (current_animation != animation.AIRCRYING and current_animation != animation.AIRSHIELDING and current_animation != animation.GROUNDAIRUPATTACKING and current_animation != animation.SHIELDING and current_animation != animation.NEUTRALDODGING and current_animation != animation.SAIRATTACK and current_animation != animation.UPDODGING and current_animation != animation.DOWNDODGING and current_animation != animation.SIDEDODGING and current_animation != animation.AIRDOWNATTACKING and current_animation != animation.AIRUPATTACKING and current_animation != animation.GLIDING and current_animation != animation.DAIRSPECIALING and current_animation != animation.AIRPUNCHING and current_animation != animation.CROSSBOWING and current_animation != animation.AIRCROSSBOWING and current_animation != animation.AIRSPECIALING):
				if SPEED == NORMAL_SPEED and (current_animation != animation.SATTACK1 and current_animation != animation.SATTACK2 and current_animation != animation.SATTACK3 and current_animation != animation.AIRCRYING and current_animation != animation.AIRSHIELDING and current_animation != animation.GROUNDAIRUPATTACKING and current_animation != animation.SHIELDING and current_animation != animation.NEUTRALDODGING and current_animation != animation.SAIRATTACK and current_animation != animation.UPDODGING and current_animation != animation.DOWNDODGING and current_animation != animation.SIDEDODGING and current_animation != animation.AIRDOWNATTACKING and current_animation != animation.AIRUPATTACKING and current_animation != animation.DAIRSPECIALING and current_animation != animation.AIRPUNCHING and current_animation != animation.CROSSBOWING and current_animation != animation.AIRCROSSBOWING and current_animation != animation.AIRSPECIALING):
					sprite.play("jumping")
					current_animation = animation.JUMPING
				elif SPEED == CHARGING_SPEED and current_animation != animation.SHIELDING and current_animation != animation.AIRSHIELDING and current_animation != animation.AIRCRYING and current_animation != animation.GROUNDAIRUPATTACKING and current_animation != animation.AIRSHIELDING and current_animation != animation.NEUTRALDODGING and current_animation != animation.SAIRATTACK and current_animation != animation.UPDODGING and current_animation != animation.DOWNDODGING and current_animation != animation.SIDEDODGING and current_animation != animation.AIRUPATTACKING and current_animation != animation.DAIRSPECIALING and current_animation != animation.AIRPUNCHING and current_animation != animation.CROSSBOWING and current_animation != animation.AIRCROSSBOWING and current_animation != animation.AIRSPECIALING and current_animation != animation.SATTACK1 and current_animation != animation.SATTACK2 and current_animation != animation.SATTACK3:
					sprite.play("side_special_ground")
					current_animation = animation.JUMPING
			if current_animation == animation.JUMPING or (current_animation == animation.CROSSBOWING):
				# If you're falling, use normal gravity
				velocity.y += gravity * delta
			elif current_animation == animation.UPDODGING and dodges_left > 0:
				velocity.y = -2500 * delta
			elif current_animation == animation.DOWNDODGING and dodges_left > 0:
				velocity.y = 4500 * delta
			elif current_animation == animation.GROUNDAIRUPATTACKING:
				velocity.y = -2300.0 * delta
			elif current_animation == animation.AIRUPATTACKING:
				velocity.y = -4600.0 * delta
			elif current_animation == animation.GLIDING and velocity.y > 0:
				velocity.y = 1400 * delta
			elif current_animation != animation.AIRSHIELDING and current_animation != animation.AIRCROSSBOWING and current_animation != animation.AIRPUNCHING and current_animation != animation.AIRSPECIALING and current_animation != animation.AIRCRYING and current_animation != animation.DAIRSPECIALING:
				# If you're attacking, you should fall slightly slower
				if velocity.y > 0:
					if animation.CLIMBINGLEFT or animation.CLIMBINGRIGHT:
						velocity.y = ((INITIAL_JUMP_SPEED + climb_slip_speed) * delta)
						climb_slip_speed += 30
					elif current_animation == animation.SAIRATTACK:
						velocity.y = 2600 * delta
					else:
						velocity.y = 1400 * delta
				else:
					velocity.y += gravity * delta
			elif current_animation == animation.AIRCROSSBOWING or current_animation == animation.AIRSHIELDING:
				velocity.y = 2000 * delta
			elif current_animation == animation.AIRPUNCHING and velocity.y > 0:
				velocity.y = 2600 * delta
			elif current_animation == animation.AIRSPECIALING:
				if velocity.y > 0:
					velocity.y = 600 * delta
				else:
					velocity.y = -600 * delta
			elif current_animation == animation.DAIRSPECIALING or current_animation == animation.AIRCRYING:
				velocity.y = 300 * delta
			else: 
				velocity.y += gravity * delta
		elif direction == 0 and not (Input.is_action_just_pressed("right_stick_left"+str(player_index)) or Input.is_action_just_pressed("right_stick_right"+str(player_index))) and not charging and not sliding and current_animation != animation.GROUNDAIRUPATTACKING and current_animation != animation.SLIDING and current_animation != animation.CRYING and current_animation != animation.AIRCRYING and current_animation != animation.SAIRATTACK and current_animation != animation.NEUTRALDODGING and current_animation != animation.UPDODGING and current_animation != animation.AIRCROSSBOWING and current_animation != animation.DOWNDODGING and current_animation != animation.SIDEDODGING and current_animation != animation.CRYING and current_animation != animation.EMOTING and current_animation != animation.CROSSBOWING and current_animation != animation.SHIELDING and current_animation != animation.AIRPUNCHING and current_animation != animation.UPATTACKING and current_animation != animation.DOWNATTACKING and current_animation != animation.AIRSPECIALING and current_animation != animation.AIRDOWNATTACKING and current_animation != animation.AIRCROSSBOWING and current_animation != animation.AIRUPATTACKING and current_animation != animation.DAIRSPECIALING:
			sprite.play("idle")
			current_animation = animation.IDLE
		elif not starting_round and ((sliding) or ((direction != 0 and Input.is_action_just_pressed("special"+str(player_index))) or Input.is_action_just_pressed("right_stick_left"+str(player_index)) or Input.is_action_just_pressed("right_stick_right"+str(player_index)))) and current_animation != animation.NEUTRALDODGING and current_animation != animation.CRYING and current_animation != animation.UPDODGING and current_animation != animation.DOWNDODGING and current_animation != animation.SIDEDODGING and current_animation != animation.GROUNDAIRUPATTACKING and current_animation != animation.SAIRATTACK and current_animation != animation.AIRCROSSBOWING and current_animation != animation.CRYING and current_animation != animation.CROSSBOWING and current_animation != animation.SHIELDING and current_animation != animation.AIRPUNCHING and current_animation != animation.UPATTACKING and current_animation != animation.DOWNATTACKING and current_animation != animation.AIRSPECIALING and current_animation != animation.AIRDOWNATTACKING and current_animation != animation.AIRCROSSBOWING and current_animation != animation.AIRUPATTACKING and current_animation != animation.DAIRSPECIALING and current_animation != animation.SATTACK1 and current_animation != animation.SATTACK2 and current_animation != animation.SATTACK3:
			sprite.play("side_special_ground2")
			current_animation = animation.SLIDING
			if not sliding:
				sliding = true
				slide_timer.start()
				if Input.is_action_just_pressed("right_stick_left"+str(player_index)) and not sprite.flip_h:
					sprite.flip_h = true
					direction *= -1
				elif Input.is_action_just_pressed("right_stick_right"+str(player_index)) and sprite.flip_h:
					sprite.flip_h = false
					direction *= -1
		elif direction != 0 and current_animation != animation.AIRCROSSBOWING and current_animation != animation.CHARGING and current_animation != animation.CRYING and current_animation != animation.SAIRATTACK and current_animation != animation.NEUTRALDODGING and current_animation != animation.UPDODGING and current_animation != animation.DOWNDODGING and current_animation != animation.SIDEDODGING and current_animation != animation.SATTACK1 and current_animation != animation.SATTACK2 and current_animation != animation.SATTACK3 and current_animation != animation.EMOTING and current_animation != animation.CROSSBOWING and current_animation != animation.SHIELDING and current_animation != animation.AIRPUNCHING and current_animation != animation.UPATTACKING and current_animation != animation.AIRSPECIALING:
			if SPEED == NORMAL_SPEED:
				sprite.play("running")
				current_animation = animation.RUNNING
			elif SPEED == CHARGING_SPEED and current_animation != animation.SHIELDING and current_animation != animation.AIRSHIELDING and current_animation != animation.AIRCRYING and current_animation != animation.GROUNDAIRUPATTACKING and current_animation != animation.AIRSHIELDING and current_animation != animation.NEUTRALDODGING and current_animation != animation.SAIRATTACK and current_animation != animation.UPDODGING and current_animation != animation.DOWNDODGING and current_animation != animation.SIDEDODGING and current_animation != animation.AIRUPATTACKING and current_animation != animation.DAIRSPECIALING and current_animation != animation.AIRPUNCHING and current_animation != animation.CROSSBOWING and current_animation != animation.AIRCROSSBOWING and current_animation != animation.AIRSPECIALING and current_animation != animation.SATTACK1 and current_animation != animation.SATTACK2 and current_animation != animation.SATTACK3:
				sprite.play("side_special_ground")
				current_animation = animation.CHARGING
	elif stunned:
		sprite.play("hitstunned")
		current_animation = animation.HITSTUNNED
		direction = 0
		velocity.y = 0
		velocity.x = 0
		
	if (not is_on_floor()) and (((velocity.y * delta) > 7 or gravity_capped) and not hit) and (current_animation == animation.JUMPING or current_animation == animation.CHARGING):
		velocity.y = 16000 * delta
		gravity_capped = true
	else:
		gravity_capped = false

	# Handle jump.
	if not starting_round and not hit and not dead and Input.is_action_just_pressed("jump"+str(player_index)) and jump_count < 1 and ((current_animation == animation.JUMPING or current_animation == animation.DAIRSPECIALING or current_animation == animation.CLIMBINGLEFT or current_animation == animation.CLIMBINGRIGHT) or (is_on_floor() and current_animation != animation.CRYING)):
		if current_animation == animation.DAIRSPECIALING:
			sprite.play("jumping")
			current_animation = animation.JUMPING
		if gravity_capped:
			gravity_capped = false
		
		velocity.y = JUMP_VELOCITY
		jump_count += 1
	
	if not no_arrows and (current_animation == animation.CROSSBOWING or current_animation == animation.AIRCROSSBOWING) and sprite.get_frame() == 2 and not just_shot:
		shoot_arrow()
		just_shot = true
	elif no_arrows and (current_animation == animation.CROSSBOWING or current_animation == animation.AIRCROSSBOWING) and sprite.get_frame() == 1 and not just_shot:
		out_of_arrows_sound.pitch_scale = randf_range(1,1.3)
		out_of_arrows_sound.play()
	
	if is_on_floor() or is_on_wall():
		if is_on_floor():
			climb_slip_speed = 0
			special_count = 0
			dair_special_count = 0
			jump_count = 0
		if is_on_wall():
			jump_count = 0
	
	if not stunned and not starting_round:
		if hit and SPEED != RECOVERY_SPEED:
			if impact_x_velocity > 1:
				direction = 1
			elif impact_x_velocity < -1:
				direction = -1
		elif current_animation == animation.AIRCRYING or current_animation == animation.CRYING:
			direction = 0
		elif other_velocity == 0 and (not dead) and (not (side_attacking and is_on_floor())) and current_animation != animation.GROUNDAIRUPATTACKING and current_animation != animation.AIRSHIELDING and current_animation != animation.AIRCRYING and  current_animation != animation.SHIELDING and current_animation != animation.AIRPUNCHING and current_animation != animation.SIDEDODGING and current_animation != animation.NEUTRALDODGING and current_animation != animation.UPDODGING and current_animation != animation.DOWNDODGING and current_animation != animation.SAIRATTACK and current_animation != animation.AIRDOWNATTACKING and current_animation != animation.AIRUPATTACKING and current_animation != animation.AIRSPECIALING and current_animation != animation.DOWNATTACKING and current_animation != animation.UPATTACKING and current_animation != animation.CRYING and current_animation != animation.SLIDING:
			direction = Input.get_axis("left"+str(player_index), "right"+str(player_index))
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if not starting_round and not stunned and not (hit and SPEED != RECOVERY_SPEED):
		if SPEED != RECOVERY_SPEED and other_velocity != 0:
			velocity.x = velocity.x + other_velocity
		elif SPEED != RECOVERY_SPEED and direction or (side_attacking or current_animation == animation.CHARGING or current_animation == animation.SLIDING):
			if current_animation == animation.SIDEDODGING and dodges_left > 0:
				if sprite.flip_h:
					velocity.x = -1 * DODGING_SPEED
				else:
					velocity.x = DODGING_SPEED
			elif current_animation == animation.SIDEDODGING and dodges_left <= 0:
				if sprite.flip_h:
					velocity.x = -1 * DODGING_COOLDOWN_SPEED
				else:
					velocity.x = DODGING_COOLDOWN_SPEED
			elif current_animation == animation.SLIDING:
				if sprite.flip_h:
					if SPEED == CHARGING_SPEED:
						velocity.x = -1 * CHARGE_SLIDING_SPEED
					elif SPEED == NORMAL_SPEED:
						velocity.x = -1 * SLIDING_SPEED
				else:
					if SPEED == CHARGING_SPEED:
						velocity.x = CHARGE_SLIDING_SPEED
					elif SPEED == NORMAL_SPEED:
						velocity.x = SLIDING_SPEED
			elif current_animation == animation.AIRSPECIALING: 
				if SPEED == NORMAL_SPEED:
					velocity.x = direction * AIR_SPECIALING_SPEED
				elif SPEED == CHARGING_SPEED:
					velocity.x = direction * CHARGE_AIR_SPECIALING_SPEED
			elif current_animation == animation.SATTACK3:
				velocity.x = direction * DASH_ATTACKING_SPEED
			elif current_animation == animation.DAIRSPECIALING or current_animation == animation.SATTACK1 or current_animation == animation.SATTACK2:
				velocity.x = direction * ATTACKING_SPEED
			else:
				velocity.x = direction * SPEED
		elif SPEED == RECOVERY_SPEED:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if not is_on_wall() and current_animation != animation.CROSSBOWING and current_animation != animation.AIRCROSSBOWING:
		if direction < 0:
			sprite.flip_h = true
		elif direction > 0:
			sprite.flip_h = false
	
	if not dead:
		move_and_slide()
		enable_hurtboxes()
		if hit:
			if abs(impact_y_velocity) > 500:
				sprite.rotation_degrees += impact_y_velocity / 300
			else:
				sprite.rotation_degrees += impact_x_velocity/6
				
			# NOTE RIGHT NOW YOU ARENT SPINNING ANYMORE FOR SOME REASON. YOU GOTTA FIX THAT
				
			sprite.play("hit")
			current_animation = animation.HIT
			velocity.y = impact_y_velocity * delta
			velocity.y += (gravity*3.5) * delta
			velocity.x = impact_x_velocity
			impact_y_velocity *= .9
			impact_x_velocity *= .9
			
			if abs(impact_x_velocity) > 1000 or abs(impact_y_velocity) > 1000:
				if cloud_frames == CLOUD_STARTING_FRAMES:
					var cloud_instance = hit_cloud.instantiate()
					cloud_instance.assign_player(self)
					main.add_child.call_deferred(cloud_instance)
				cloud_frames -= 1
				if cloud_frames <= 0:
					cloud_frames = CLOUD_STARTING_FRAMES
			
			if ((not is_on_floor() and (abs(impact_y_velocity) < 500 and abs(impact_x_velocity) < 500) or (juggernaut and (abs(impact_y_velocity) < 2000 and abs(impact_x_velocity) < 2000))) or (abs(impact_y_velocity) < 50 and abs(impact_x_velocity) < 50)) or (abs(impact_x_velocity) < 1 and is_on_floor()):
				hit = false
				_on_animated_sprite_2d_animation_finished()
				if not was_sprinting:
					SPEED = 115
				else:
					SPEED = CHARGING_SPEED
				sprite.rotation_degrees = 0
			elif abs(impact_x_velocity) < 40 and not is_on_floor():
				SPEED = RECOVERY_SPEED 
	
func _input(event):
	
	if current_animation != animation.HIT and not dead and not stunned and not hit and not starting_round:
		if event.is_action_pressed("dodge" + str(player_index)) and current_animation != animation.NEUTRALDODGING and current_animation != animation.UPDODGING and current_animation != animation.DOWNDODGING and current_animation != animation.SIDEDODGING:
			if Input.is_action_pressed("left" + str(player_index)) or Input.is_action_pressed("right" + str(player_index)):
				current_animation = animation.SIDEDODGING
				if dodges_left > 0:
					dodge_sound.pitch_scale = randf_range(2.5, 2.8)
					dodge_sound.play()
					sprite.play("side_dodge")
				else:
					dodge_sound.pitch_scale = randf_range(1.7, 1.9)
					dodge_sound.play()
					sprite.play("side_dodge_cooldown")
			elif Input.is_action_pressed("down" + str(player_index)):
				current_animation = animation.DOWNDODGING
				if dodges_left > 0:
					dodge_sound.pitch_scale = randf_range(2.5, 2.8)
					dodge_sound.play()
					sprite.play("down_dodge")
				else:
					dodge_sound.pitch_scale = randf_range(1.7, 1.9)
					dodge_sound.play()
					sprite.play("down_dodge_cooldown")
			elif Input.is_action_pressed("up" + str(player_index)):
				current_animation = animation.UPDODGING
				if dodges_left > 0:
					dodge_sound.pitch_scale = randf_range(2.5, 2.8)
					dodge_sound.play()
					sprite.play("up_dodge")
				else:
					dodge_sound.pitch_scale = randf_range(1.7, 1.9)
					dodge_sound.play()
					sprite.play("up_dodge_cooldown")
			else:
				current_animation = animation.NEUTRALDODGING
				if dodges_left > 0:
					dodge_sound.pitch_scale = randf_range(2.5, 2.8)
					dodge_sound.play()
					sprite.play("neutral_dodge")
				else:
					dodge_sound.pitch_scale = randf_range(1.7, 1.9)
					dodge_sound.play()
					sprite.play("neutral_dodge_cooldown")
			if dodges_left > 0:
				dodging = true
				match dodges_left:
					5:
						dodge_timer.wait_time = dodges_left * .1
						dodge_timer.start()
					4:
						dodge_timer.wait_time = .4
						dodge_timer.start()
					3:
						dodge_timer.wait_time = .3
						dodge_timer.start()
					2:
						dodge_timer.wait_time = .25
						dodge_timer.start()
					1:
						dodge_timer.wait_time = .2
						dodge_timer.start()
				dodges_left -= 1
				dodge_meter_ui.texture = dodge_meter_images[dodges_left]
		elif current_animation == animation.CHARGING or current_animation == animation.IDLE or current_animation == animation.RUNNING or current_animation == animation.JUMPING:
			if is_on_floor():
				if event.is_action_pressed("atk_neutral"+str(player_index)):
					if arrows_left > 0:
						sprite.play("crossbow")
						no_arrows = false
					else:
						sprite.play("crossbow_no_arrows")
						no_arrows = true
					current_animation = animation.CROSSBOWING
					just_shot = false
				elif crying or (event.is_action_pressed("right_stick_down"+str(player_index)) or (event.is_action_pressed("special"+str(player_index)) and Input.is_action_pressed("down"+str(player_index)))):
					cry_sound.pitch_scale = randf_range(1.50, 1.70)
					cry_sound.play()
					sprite.play("down_special_ground")
					current_animation = animation.CRYING
					if not crying:
						crying = true
						cry_timer.start()
				elif event.is_action_pressed("special_neutral"+str(player_index)):
					shield_sound.pitch_scale = randf_range(1.15, 1.40)
					shield_sound.play()
					sprite.play("shield")
					current_animation = animation.SHIELDING
				elif (event.is_action_pressed("right_stick_up"+str(player_index))) and special_count < MAX_SPECIALS:
					current_animation = animation.GROUNDAIRUPATTACKING
					up_attack_sword_slash.pitch_scale = randf_range(1.15, 1.40)
					up_attack_sword_slash.play()
					sprite.play("air_up_attack")
				elif direction != 0:
					if event.is_action_pressed("attack"+str(player_index)):
						if not side_attacking:
							side_attacking = true
						if atk_count == 0:
							s_attack_1_sword_slash.pitch_scale = randf_range(1.05, 1.25)
							s_attack_1_sword_slash.play()
							sprite.play("side_attack1")
							current_animation = animation.SATTACK1
							timer.start()
						elif atk_count == 1:
							s_attack_2_sword_slash.pitch_scale = randf_range(.85, 1.05)
							s_attack_2_sword_slash.play()
							sprite.play("side_attack2")
							current_animation = animation.SATTACK2
							timer.start()
						elif atk_count == 2:
							s_attack_3_sword_slash.pitch_scale = randf_range(.85, 1.05)
							s_attack_3_sword_slash.play()
							sprite.play("side_attack3")
							current_animation = animation.SATTACK3
							timer.start()
				elif direction == 0:
					if event.is_action_pressed("attack"+str(player_index)) and Input.is_action_pressed("up"+str(player_index)):
						up_attack_sword_slash.pitch_scale = randf_range(1.15, 1.40)
						up_attack_sword_slash.play()
						sprite.play("up_attack")
						current_animation = animation.UPATTACKING
					elif event.is_action_pressed("attack"+str(player_index)) and (Input.is_action_pressed("down"+str(player_index))):
						s_attack_3_sword_slash.pitch_scale = randf_range(1.05, 1.25)
						s_attack_3_sword_slash.play()
						sprite.play("down_attack")
						current_animation = animation.DOWNATTACKING
					elif event.is_action_pressed("attack"+str(player_index)):
						if arrows_left > 0:
							sprite.play("crossbow")
							no_arrows = false
						else:
							sprite.play("crossbow_no_arrows")
							no_arrows = true
						current_animation = animation.CROSSBOWING
						just_shot = false
					elif crying or (event.is_action_pressed("right_stick_down"+str(player_index)) or (event.is_action_pressed("special"+str(player_index)) and Input.is_action_pressed("down"+str(player_index)))):
						cry_sound.pitch_scale = randf_range(1.50, 1.70)
						cry_sound.play()
						sprite.play("down_special_ground")
						current_animation = animation.CRYING
						if not crying:
							crying = true
							cry_timer.start()
					elif (event.is_action_pressed("special"+str(player_index))) and Input.is_action_pressed("up" + str(player_index)):
						up_attack_sword_slash.pitch_scale = randf_range(1.15, 1.40)
						up_attack_sword_slash.play()
						current_animation = animation.GROUNDAIRUPATTACKING
						sprite.play("air_up_attack")
					elif event.is_action_pressed("special"+str(player_index)):
						shield_sound.pitch_scale = randf_range(1.15, 1.40)
						shield_sound.play()
						sprite.play("shield")
						current_animation = animation.SHIELDING
					elif event.is_action_pressed("emote"+str(player_index)):
						sprite.play("emote")
						current_animation = animation.EMOTING
			else: # if in air
				if event.is_action_pressed("atk_neutral"+str(player_index)):
					air_punch_sound.pitch_scale = randf_range(1.15, 1.40)
					air_punch_sound.play()
					sprite.play("air_punch")
					current_animation = animation.AIRPUNCHING
				elif event.is_action_pressed("special_neutral" + str(player_index)) and special_count < MAX_SPECIALS:
					shield_sound.pitch_scale = randf_range(1.15, 1.40)
					shield_sound.play()
					sprite.play("shield")
					current_animation = animation.AIRSHIELDING
					special_count += 1
				elif event.is_action_pressed("right_stick_down"+str(player_index)) and special_count < MAX_SPECIALS:
					cry_sound.pitch_scale = randf_range(1.50, 1.70)
					cry_sound.play()
					sprite.play("down_special_ground")
					current_animation = animation.AIRCRYING
					special_count += 1
				elif (event.is_action_pressed("right_stick_left"+str(player_index)) or event.is_action_pressed("right_stick_right"+str(player_index))) and special_count < MAX_SPECIALS:
					fire_attack.pitch_scale = randf_range(.95, 1.05)
					fire_attack.play()
					sprite.play("side_special_air")
					current_animation = animation.AIRSPECIALING
					special_count += 1
					if Input.is_action_just_pressed("right_stick_left"+str(player_index)) and not sprite.flip_h:
						sprite.flip_h = true
						direction *= -1
					elif Input.is_action_just_pressed("right_stick_right"+str(player_index)) and sprite.flip_h:
						sprite.flip_h = false
						direction *= -1
				elif (event.is_action_pressed("right_stick_up"+str(player_index))) and special_count < MAX_SPECIALS:
					up_attack_sword_slash.pitch_scale = randf_range(1.15, 1.40)
					up_attack_sword_slash.play()
					current_animation = animation.AIRUPATTACKING
					sprite.play("air_up_attack")
					special_count += 1
				elif dair_special_count < 2 and (event.is_action_pressed("attack"+str(player_index)) and Input.is_action_pressed("down"+str(player_index))):
					down_air_attack.pitch_scale = randf_range(1,1.05)
					down_air_attack.play()
					current_animation = animation.DAIRSPECIALING
					sprite.play("down_special_air")
					dair_special_count += 1
				elif (event.is_action_pressed("attack"+str(player_index))) and Input.is_action_pressed("up"+str(player_index)):
					if arrows_left > 0:
						sprite.play("crossbow")
						no_arrows = false
					else:
						sprite.play("crossbow_no_arrows")
						no_arrows = true
					current_animation = animation.AIRCROSSBOWING
					just_shot = false
				elif direction != 0:
					if event.is_action_pressed("special"+str(player_index)) and special_count < MAX_SPECIALS:
						if (Input.is_action_pressed("left"+str(player_index)) or Input.is_action_pressed("right"+str(player_index))):
							fire_attack.pitch_scale = randf_range(.95, 1.05)
							fire_attack.play()
							sprite.play("side_special_air")
							current_animation = animation.AIRSPECIALING
							special_count += 1
					elif event.is_action_pressed("attack"+str(player_index)):
						s_attack_1_sword_slash.pitch_scale = randf_range(1.15, 1.40)
						s_attack_1_sword_slash.play()
						sprite.play("side_attack1")
						current_animation = animation.SAIRATTACK
				elif direction == 0:
					if event.is_action_pressed("special"+str(player_index)) and special_count < MAX_SPECIALS:
						if Input.is_action_pressed("down"+str(player_index)):
							cry_sound.pitch_scale = randf_range(1.50, 1.70)
							cry_sound.play()
							sprite.play("down_special_ground")
							current_animation = animation.AIRCRYING
							special_count += 1
						elif Input.is_action_pressed("up"+str(player_index)) and special_count < MAX_SPECIALS:
							up_attack_sword_slash.pitch_scale = randf_range(1.15, 1.40)
							up_attack_sword_slash.play()
							sprite.play("air_up_attack")
							current_animation = animation.AIRUPATTACKING
							special_count += 1
						elif Input.is_action_pressed("special" + str(player_index)):
							shield_sound.pitch_scale = randf_range(1.15, 1.40)
							shield_sound.play()
							sprite.play("shield")
							current_animation = animation.AIRSHIELDING
							special_count += 1
					if event.is_action_pressed("attack"+str(player_index)):
						air_punch_sound.pitch_scale = randf_range(1.15, 1.40)
						air_punch_sound.play()
						sprite.play("air_punch")
						current_animation = animation.AIRPUNCHING

func update_health_text():
	player_health.text = str(int(health))
	player_health.set_modulate.call_deferred(scoreboard.get_player_health_color(player_index))

func shoot_arrow():
	if arrows_left > 0:
		var arrow_instance = arrow.instantiate()
		arrow_instance.assign_shooter(self)
		main.add_child.call_deferred(arrow_instance)
		arrows_left -= 1
		update_arrow_ui()
	
func update_arrow_ui():
	match arrows_left:
		3:
			arrow_meter_ui.texture = arrow_meter_3_image
		2:
			arrow_meter_ui.texture = arrow_meter_2_image
		1:
			arrow_meter_ui.texture = arrow_meter_1_image
		0:
			arrow_meter_ui.texture = arrow_meter_0_image
			
func _on_area_2d_body_entered(body):
	if colliding_with_arrow:
		colliding_with_arrow = false
	if body is CharacterBody2D:
		if body.has_method("assign_shooter") and body.can_collide_with_player:
			if body.is_in_group(team_name):
				colliding_with_arrow = true
				if velocity.y < 0:
					velocity.y = 0
				other_velocity += arrow_speed
	elif body is TileMap:
		if hit:
			if is_on_wall():
				impact_x_velocity *= -1
			if is_on_floor():
				impact_y_velocity *= -1
				
func take_damage(x_velocity, y_velocity, damage):
	if immunity_timer.is_stopped():
		hit_sound.pitch_scale = randf_range(.85,1.05)
		hit_sound.play()
		if SPEED == CHARGING_SPEED:
			was_sprinting = true
		hit = true
		var health_factor = 0
		if health > 250:
			health_factor = 8
		elif health > 220:
			health_factor = 7
		elif health > 200:
			health_factor = 6.4
		elif health > 180:
			health_factor = 6.2
		elif health > 160:
			health_factor = 6
		elif health > 140:
			health_factor = 6
		elif health > 120:
			health_factor = 3
		elif health > 100:
			health_factor = 2.6
		elif health > 80:
			health_factor = 2.2
		elif health > 60:
			health_factor = 1.6
		elif health > 40:
			health_factor = 1.4
		elif health > 20:
			health_factor = 1.1
		elif health > 10:
			health_factor = .9
		else:
			health_factor = .7
			
		var jugg_factor = 1
		if juggernaut:
			jugg_factor = .5
			
		impact_x_velocity = (x_velocity * (health_factor) * jugg_factor)
		impact_y_velocity = (y_velocity * (health_factor) * jugg_factor)
		health += damage
		dmg_taken += damage
		player_who_hit_me_last.dmg_dealt += damage
		SPEED = 0
		immunity_timer.start()
	
func take_constant_damage(x_velocity, y_velocity, damage):
	if immunity_timer.is_stopped():
		hit_sound.pitch_scale = randf_range(.85,1.05)
		hit_sound.play()
		if SPEED == CHARGING_SPEED:
			was_sprinting = true
		hit = true
		var health_factor = .7
		var jugg_factor = 1
		if juggernaut:
			jugg_factor = .5
			
		impact_x_velocity = (x_velocity * (health_factor) * jugg_factor)
		impact_y_velocity = (y_velocity * (health_factor) * jugg_factor)
		
		health += damage
		dmg_taken += damage
		player_who_hit_me_last.dmg_dealt += damage
		SPEED = 0
		immunity_timer.start()
			
func _on_area_2d_body_exited(body):
	if body is CharacterBody2D:
		if body.has_method("assign_shooter"):
			other_velocity -= arrow_speed
			arrow_speed = 0

func revive():
	health = 0
	if not scoreboard.game_just_finished:
		if not dead:
			if player_who_hit_me_last != null:
				if GameSettings.current_gamemode == GameSettings.GAMEMODE.JUGGERNAUT:
					if juggernaut:
						dejuggify()
						player_who_hit_me_last.juggify()
					else:
						player_who_hit_me_last.score += 1
						player_who_hit_me_last.knockouts += 1
				else:
					player_who_hit_me_last.score += 1
					player_who_hit_me_last.knockouts += 1
			else:
				if player_2 != null and player_2.team_name != team_name and not player_2.dead:
					if not juggernaut:
						player_2.score += 1
						player_2.knockouts += 1
					if juggernaut:
						dejuggify()
						player_2.juggify()
				elif player_3 != null and player_3.team_name != team_name and not player_3.dead:
					if not juggernaut:
						player_3.score += 1
						player_3.knockouts += 1
					if juggernaut:
						dejuggify()
						player_3.juggify()
				elif player_4 != null and player_4.team_name != team_name and not player_4.dead:
					if not juggernaut:
						player_4.score += 1
						player_4.knockouts += 1
					if juggernaut:
						dejuggify()
						player_4.juggify()
		global_position.x = -50
		global_position.y = -50
		dead = true
		jump_count = 0
		if lives > 1:
			respawn_timer.start()

func clear_projectiles():
	for node in get_tree().get_nodes_in_group("Projectiles"):
		if node.shooter.get_name() == get_name():
			node.gave_arrow = true
			node.queue_free()
			
func _on_respawn_timer_timeout():
	if not scoreboard.game_just_finished:
		lives -= 1
		health = 0
		dead = false
		global_position.x = starting_position_x
		global_position.y = starting_position_y
		impact_x_velocity = 0
		impact_y_velocity = 0
		velocity.x = 0
		velocity.y = 0
		_on_animated_sprite_2d_animation_finished()
		dodges_left = 4
		dodge_meter_ui.texture = dodge_meter_images[dodges_left]
		if not GameSettings.current_gamemode == GameSettings.GAMEMODE.ARROWRAIN:
			arrows_left = 3
		if Input.is_action_pressed("sprint"+str(player_index)):
			SPEED = CHARGING_SPEED
		else:
			SPEED = NORMAL_SPEED
		update_arrow_ui()
		can_explode = true
		respawn_timer.stop()
			
func _on_timer_timeout():
	atk_count = 0
	timer.stop()
	side_attacking = false
	if current_animation == animation.SATTACK1 or current_animation == animation.SATTACK2 or current_animation == animation.SATTACK3:
		sprite.play("running")
		current_animation = animation.RUNNING

func _on_slide_timer_timeout():
	sliding = false
	slide_timer.stop()

func _on_cry_timer_timeout():
	crying = false
	cry_timer.stop()

func _on_dodge_timer_timeout():
	if is_on_floor():
		if current_animation == animation.SATTACK1 or current_animation == animation.SATTACK2:
			atk_count += 1
			side_attacking = false
		else:
			atk_count = 0
			side_attacking = false
		if direction == 0:
			sprite.play("idle")
			current_animation = animation.IDLE
		elif direction != 0:
			sprite.play("running")
			current_animation = animation.RUNNING
	else:
		atk_count = 0
		sprite.play("jumping")
		current_animation = animation.JUMPING
	
	if dodges_left > 0:
		dodge_cooldown.start()
	else:
		dodge_cooldown.stop()
		dodge_super_cooldown.start()
	
	dodging = false
	dodge_timer.stop()

func _on_dodge_cooldown_timeout():
	if dodges_left == 3:
		dodges_left += 1
		dodge_cooldown.stop()
	elif dodges_left < 3:
		dodges_left += 1
		dodge_cooldown.start()
	dodge_meter_ui.texture = dodge_meter_images[dodges_left]

func _on_dodge_super_cooldown_timeout():
	dodges_left = 4
	dodge_super_cooldown.stop()
	dodge_meter_ui.texture = dodge_meter_4_image

func _on_animated_sprite_2d_animation_finished():
	if is_on_wall() and (current_animation == animation.AIRCROSSBOWING or current_animation == animation.CROSSBOWING):
		if direction < 0:
			sprite.flip_h = true
		elif direction > 0:
			sprite.flip_h = false
	
	if stunned and current_animation == animation.HITSTUNNED:
		stunned = false
	if is_on_floor():
		if current_animation == animation.SATTACK1 or current_animation == animation.SATTACK2:
			atk_count += 1
			side_attacking = false
		else:
			atk_count = 0
			side_attacking = false
		if direction == 0:
			sprite.play("idle")
			current_animation = animation.IDLE
		elif direction != 0:
			sprite.play("running")
			current_animation = animation.RUNNING
	else:
		atk_count = 0
		sprite.play("jumping")
		current_animation = animation.JUMPING
		
	if not (Input.is_action_pressed("left" + str(player_index)) or Input.is_action_pressed("right" + str(player_index))):
		direction = 0
		
	if not shield_box.disabled:
		shield_box.disabled = true
	if not shield_box_flipped.disabled:
		shield_box_flipped.disabled = true
		
	if not side_attack_1_box.disabled:
		side_attack_1_box.disabled = true
	if not side_attack_1_box_flipped.disabled:
		side_attack_1_box_flipped.disabled = true
		
	if not side_attack_2_box.disabled:
		side_attack_2_box.disabled = true
	if not side_attack_2_box_flipped.disabled:
		side_attack_2_box_flipped.disabled = true
		
	if not side_attack_3_box.disabled:
		side_attack_3_box.disabled = true
	if not side_attack_3_box_flipped.disabled:
		side_attack_3_box_flipped.disabled = true
	
	if not up_attack_box.disabled:
		up_attack_box.disabled = true
	if not up_attack_box_flipped.disabled:
		up_attack_box_flipped.disabled = true
		
	if not side_special_air_box.disabled:
		side_special_air_box.disabled = true
	if not side_special_air_box_flipped.disabled:
		side_special_air_box_flipped.disabled = true
		
	if not air_punch_box.disabled:
		air_punch_box.disabled = true
	if not air_punch_box_flipped.disabled:
		air_punch_box_flipped.disabled = true
		
	if not sliding_box.disabled:
		sliding_box.disabled = true
	if not sliding_box_flipped.disabled:
		sliding_box_flipped.disabled = true
		
	if not air_down_attack_box.disabled:
		air_down_attack_box.disabled = true
		
	if not crying_box.disabled:
		crying_box.disabled = true
	if not crying_box_flipped.disabled:
		crying_box_flipped.disabled = true
		
	if not down_attack_box_1.disabled:
		down_attack_box_1.disabled = true
	if not down_attack_box_1_flipped.disabled:
		down_attack_box_1_flipped.disabled = true
		
	if not down_attack_box_2.disabled:
		down_attack_box_2.disabled = true
	if not down_attack_box_2_flipped.disabled:
		down_attack_box_2_flipped.disabled = true

func enable_hurtboxes():
	if not shield_box.disabled:
		shield_box.disabled = true
	if not shield_box_flipped.disabled:
		shield_box_flipped.disabled = true
		
	if not side_attack_1_box.disabled:
		side_attack_1_box.disabled = true
	if not side_attack_1_box_flipped.disabled:
		side_attack_1_box_flipped.disabled = true
		
	if not side_attack_2_box.disabled:
		side_attack_2_box.disabled = true
	if not side_attack_2_box_flipped.disabled:
		side_attack_2_box_flipped.disabled = true
		
	if not side_attack_3_box.disabled:
		side_attack_3_box.disabled = true
	if not side_attack_3_box_flipped.disabled:
		side_attack_3_box_flipped.disabled = true
	
	if not up_attack_box.disabled:
		up_attack_box.disabled = true
	if not up_attack_box_flipped.disabled:
		up_attack_box_flipped.disabled = true
		
	if not side_special_air_box.disabled:
		side_special_air_box.disabled = true
	if not side_special_air_box_flipped.disabled:
		side_special_air_box_flipped.disabled = true
		
	if not air_punch_box.disabled:
		air_punch_box.disabled = true
	if not air_punch_box_flipped.disabled:
		air_punch_box_flipped.disabled = true
		
	if not sliding_box.disabled:
		sliding_box.disabled = true
	if not sliding_box_flipped.disabled:
		sliding_box_flipped.disabled = true
		
	if not air_down_attack_box.disabled:
		air_down_attack_box.disabled = true
		
	if not crying_box.disabled:
		crying_box.disabled = true
	if not crying_box_flipped.disabled:
		crying_box_flipped.disabled = true
		
	if not down_attack_box_1.disabled:
		down_attack_box_1.disabled = true
	if not down_attack_box_1_flipped.disabled:
		down_attack_box_1_flipped.disabled = true
		
	if not down_attack_box_2.disabled:
		down_attack_box_2.disabled = true
	if not down_attack_box_2_flipped.disabled:
		down_attack_box_2_flipped.disabled = true
	
	
	if not hit and (current_animation == animation.SHIELDING or current_animation == animation.AIRSHIELDING) and sprite.frame > 1:
		if sprite.flip_h:
			shield_box_flipped.disabled = false
		else:
			shield_box.disabled = false
	elif (current_animation == animation.SATTACK1 or current_animation == animation.SAIRATTACK):
		if sprite.frame > 1 and sprite.frame < 4:
			if sprite.flip_h:
				side_attack_1_box_flipped.disabled = false
			else:
				side_attack_1_box.disabled = false
		else:
			if not side_attack_1_box.disabled:
				side_attack_1_box.disabled = true
			if not side_attack_1_box_flipped.disabled:
				side_attack_1_box_flipped.disabled = true
	elif current_animation == animation.SATTACK2:
		if sprite.frame > 1:
			if sprite.flip_h:
				side_attack_2_box_flipped.disabled = false
			else:
				side_attack_2_box.disabled = false
	elif current_animation == animation.SATTACK3:
		if sprite.frame > 2 and sprite.frame < 5:
			if sprite.flip_h:
				side_attack_3_box_flipped.disabled = false
			else:
				side_attack_3_box.disabled = false
		else:
			if sprite.flip_h:
				side_attack_3_box_flipped.disabled = true
			else:
				side_attack_3_box.disabled = true
	elif (current_animation == animation.UPATTACKING or current_animation == animation.AIRUPATTACKING or current_animation == animation.GROUNDAIRUPATTACKING):
		if sprite.frame > 1:
			if sprite.flip_h:
				up_attack_box_flipped.disabled = false
			else:
				up_attack_box.disabled = false
	elif current_animation == animation.AIRSPECIALING:
		if sprite.frame > 3:
			if sprite.flip_h:
				side_special_air_box_flipped.disabled = false
			else:
				side_special_air_box.disabled = false
	elif current_animation == animation.AIRPUNCHING:
		if sprite.frame > 2 and sprite.frame < 5:
			if sprite.flip_h:
				air_punch_box_flipped.disabled = false
			else:
				air_punch_box.disabled = false
		else:
			if sprite.flip_h:
				air_punch_box_flipped.disabled = true
			else:
				air_punch_box.disabled = true
	elif current_animation == animation.SLIDING:
		if sprite.flip_h:
			sliding_box_flipped.disabled = false
		else:
			sliding_box.disabled = false
	elif current_animation == animation.DAIRSPECIALING:
		if not hit and sprite.frame > 0:
			air_down_attack_box.disabled = false
		else:
			air_down_attack_box.disabled = true
	elif current_animation == animation.CRYING or current_animation == animation.AIRCRYING:
		if sprite.frame > 3 and sprite.frame < 9:
			if sprite.flip_h:
				crying_box_flipped.disabled = false
			else:
				crying_box.disabled = false
		else:
			if sprite.flip_h:
				crying_box_flipped.disabled = true
			else:
				crying_box.disabled = true
	elif current_animation == animation.DOWNATTACKING:
		if sprite.frame == 2:
			if sprite.flip_h:
				down_attack_box_1_flipped.disabled = false
			else:
				down_attack_box_1.disabled = false
		elif sprite.frame > 2:
			if not down_attack_box_1.disabled:
				down_attack_box_1.disabled = true
			if not down_attack_box_1_flipped.disabled:
				down_attack_box_1_flipped.disabled = true
			if sprite.flip_h:
				down_attack_box_2_flipped.disabled = false
			else:
				down_attack_box_2.disabled = false
		
func _on_shield_hurt_box_body_entered(body):
	if body is CharacterBody2D:
		if not hit:
			if (not shield_box.disabled or not shield_box_flipped.disabled) and body.has_method("assign_shooter"):
				if ((body.slow_arrow_wall_timer.is_stopped() and body.fast_arrow_wall_timer.is_stopped()) or body.falling):
					shield_block.pitch_scale = randf_range(1.15, 1.40)
					shield_block.play()
					if body.falling:
						body.falling = false
					body.add_collision_exception_with(self)
					body.add_collision_exception_with(body)
					body.can_collide_with_player = false
					body.arrow_emergency_timer.wait_time = 12
					body.arrow_emergency_timer.start()
					body.arrow_despawn_timer.wait_time = 10
					body.arrow_despawn_timer.start()
					body.flipped_arrow_emergency_timer.stop()
					body.remove_from_group(body.team_name)
					body.add_to_group(team_name)
					
					if not body.fire.visible:
						body.fire.visible = true
						body.flaming_arrow = true
					elif not body.blue_fire.visible:
						body.fire.visible = false
						body.blue_fire.visible = true
						body.blue_flaming_arrow = true
						
					if body.blue_fire.visible and body.fire.visible:
						body.fire.visible = false
						
					if body.sprite_2d.flip_h and body.rotation_degrees == -90:
						body.rotation_degrees = 0
						body.sprite_2d.flip_h = false
						body.blue_fire.rotation_degrees = -90
						body.fire.rotation_degrees = -90
					elif not body.sprite_2d.flip_h and body.rotation_degrees == 90:
						body.rotation_degrees = 0
						body.sprite_2d.flip_h = true
						body.blue_fire.rotation_degrees = -90
						body.fire.rotation_degrees = -90
					
					body.team_name = team_name
					if team_name == "team-one":
						body.sprite_2d.texture = body.arrow_image1
					elif team_name == "team-two":
						body.sprite_2d.texture = body.arrow_image2
					elif team_name == "team-three":
						body.sprite_2d.texture = body.arrow_image3
					elif team_name == "team-four":
						body.sprite_2d.texture = body.arrow_image4
					elif team_name == "red-team":
						body.sprite_2d.texture = body.red_arrow_image
					elif team_name == "blue-team":
						body.sprite_2d.texture = body.blue_arrow_image
						
					if body.SPEED != 0:
						body.SPEED *= -1
						if body.SPEED > 0 and body.SPEED < 375:
							body.SPEED += 25
						elif body.SPEED < 0 and body.SPEED > -375:
							body.SPEED -= 25
					else:
						if sprite.flip_h:
							body.SPEED = -200
						else:
							body.SPEED = 200
					
					if sprite.flip_h:
						body.sprite_2d.flip_h = true
					else:
						body.sprite_2d.flip_h = false
						
					if body.rotation_degrees != 0:
						if sprite.flip_h:
							body.sprite_2d.flip_h = true
						else:
							body.sprite_2d.flip_h = false
							
					if not body.blue_flaming_arrow and body.blue_fire.visible:
						body.blue_flaming_arrow = true
					
					body.sliding = false
					body.change_color_to(team_name)
					body.shooter = self

func _on_attack_hurt_box_body_entered(body):
	if body != self:
		if body is CharacterBody2D:
			if body.has_method("shoot_arrow"):
				if not body.dodging and not body.team_name == team_name:
					body.player_who_hit_me_last = self
					var jugg_factor = 1.3
					if current_animation == animation.SAIRATTACK or current_animation == animation.SATTACK1:
						if current_animation == animation.SATTACK1:
							if sprite.flip_h:
								body.take_constant_damage(GameSettings.SATTACK1_X_VELOCITY, GameSettings.SATTACK1_Y_VELOCITY, GameSettings.SATTACK1_DAMAGE)
							else:
								body.take_constant_damage(GameSettings.SATTACK1_X_VELOCITY*-1, GameSettings.SATTACK1_Y_VELOCITY, GameSettings.SATTACK1_DAMAGE)
						else:
							if sprite.flip_h:
								body.take_constant_damage(GameSettings.SAIRATTACK_X_VELOCITY, GameSettings.SAIRATTACK_Y_VELOCITY, GameSettings.SAIRATTACK_DAMAGE)
							else:
								body.take_constant_damage(GameSettings.SAIRATTACK_X_VELOCITY*-1, GameSettings.SAIRATTACK_Y_VELOCITY, GameSettings.SAIRATTACK_DAMAGE)
					elif current_animation == animation.SATTACK2:
						if sprite.flip_h:
							body.take_constant_damage(GameSettings.SATTACK2_X_VELOCITY, GameSettings.SATTACK2_Y_VELOCITY, GameSettings.SATTACK2_DAMAGE)
						else:
							body.take_constant_damage(GameSettings.SATTACK2_X_VELOCITY*-1, GameSettings.SATTACK2_Y_VELOCITY, GameSettings.SATTACK2_DAMAGE)
					elif current_animation == animation.SATTACK3:
						if sprite.flip_h:
							body.take_damage(GameSettings.SATTACK3_X_VELOCITY, GameSettings.SATTACK3_Y_VELOCITY, GameSettings.SATTACK3_DAMAGE)
						else:
							body.take_damage(GameSettings.SATTACK3_X_VELOCITY*-1, GameSettings.SATTACK3_Y_VELOCITY, GameSettings.SATTACK3_DAMAGE)
					elif (current_animation == animation.UPATTACKING or current_animation == animation.GROUNDAIRUPATTACKING):
						if sprite.flip_h:
							body.take_damage(GameSettings.UPATTACKING_X_VELOCITY, GameSettings.UPATTACKING_Y_VELOCITY, GameSettings.UPATTACKING_DAMAGE)
						else:
							body.take_damage(GameSettings.UPATTACKING_X_VELOCITY*-1, GameSettings.UPATTACKING_Y_VELOCITY, GameSettings.UPATTACKING_DAMAGE)
					elif current_animation == animation.AIRUPATTACKING:
						if sprite.flip_h:
							body.take_damage(GameSettings.AIRUPATTACKING_X_VELOCITY, GameSettings.AIRUPATTACKING_Y_VELOCITY, GameSettings.AIRUPATTACKING_DAMAGE)
						else:
							body.take_damage(GameSettings.AIRUPATTACKING_X_VELOCITY*-1, GameSettings.AIRUPATTACKING_Y_VELOCITY, GameSettings.AIRUPATTACKING_DAMAGE)
					elif current_animation == animation.AIRSPECIALING:
						if sprite.flip_h:
							body.take_damage(GameSettings.AIRSPECIALING_X_VELOCITY, GameSettings.AIRSPECIALING_Y_VELOCITY, GameSettings.AIRSPECIALING_DAMAGE)
						else:
							body.take_damage(GameSettings.AIRSPECIALING_X_VELOCITY*-1, GameSettings.AIRSPECIALING_Y_VELOCITY, GameSettings.AIRSPECIALING_DAMAGE)
					elif current_animation == animation.AIRPUNCHING:
						if sprite.flip_h:
							body.take_damage(GameSettings.AIRPUNCHING_X_VELOCITY, GameSettings.AIRPUNCHING_Y_VELOCITY, GameSettings.AIRPUNCHING_DAMAGE)
						else:
							body.take_damage(GameSettings.AIRPUNCHING_X_VELOCITY*-1, GameSettings.AIRPUNCHING_Y_VELOCITY, GameSettings.AIRPUNCHING_DAMAGE)
					elif current_animation == animation.SLIDING:
						if body.global_position.y - 5 < global_position.y:
							if sprite.flip_h:
								body.take_damage(GameSettings.SLIDING_X_VELOCITY, GameSettings.SLIDING_Y_VELOCITY, GameSettings.SLIDING_DAMAGE)
							else:
								body.take_damage(GameSettings.SLIDING_X_VELOCITY*-1, GameSettings.SLIDING_Y_VELOCITY, GameSettings.SLIDING_DAMAGE)
						else:
							if sprite.flip_h:
								body.take_damage(GameSettings.SLIDING_X_VELOCITY, GameSettings.SLIDING_Y_VELOCITY*-1, GameSettings.SLIDING_DAMAGE)
							else:
								body.take_damage(GameSettings.SLIDING_X_VELOCITY*-1, GameSettings.SLIDING_Y_VELOCITY*-1, GameSettings.SLIDING_DAMAGE)
					elif current_animation == animation.DAIRSPECIALING:
						if body.is_on_floor():
							body.take_damage(GameSettings.DAIRSPECIALING_X_VELOCITY, GameSettings.DAIRSPECIALING_Y_VELOCITY, GameSettings.DAIRSPECIALING_DAMAGE)
						else:
							body.take_damage(GameSettings.DAIRSPECIALING_X_VELOCITY, GameSettings.DAIRSPECIALING_Y_VELOCITY*-1, GameSettings.DAIRSPECIALING_DAMAGE)
					elif current_animation == animation.CRYING or current_animation == animation.AIRCRYING:
						if body.global_position.y - 5 < global_position.y: # the other player is above you
							if sprite.flip_h:
								body.take_damage(GameSettings.CRYING_X_VELOCITY, GameSettings.CRYING_Y_VELOCITY, GameSettings.CRYING_DAMAGE)
							else:
								body.take_damage(GameSettings.CRYING_X_VELOCITY*-1, GameSettings.CRYING_Y_VELOCITY, GameSettings.CRYING_DAMAGE)
						else:
							if sprite.flip_h:
								body.take_damage(GameSettings.CRYING_X_VELOCITY, GameSettings.CRYING_OVER_OTHER_PLAYER_Y_VELOCITY, GameSettings.CRYING_DAMAGE)
							else:
								body.take_damage(GameSettings.CRYING_X_VELOCITY*-1, GameSettings.CRYING_OVER_OTHER_PLAYER_Y_VELOCITY, GameSettings.CRYING_DAMAGE)
					elif current_animation == animation.DOWNATTACKING:
						if body.is_on_floor():
							body.take_damage(GameSettings.DOWNATTACKING_X_VELOCITY, GameSettings.DOWNATTACKING_Y_VELOCITY, GameSettings.DOWNATTACKING_DAMAGE)
						else:
							body.take_damage(GameSettings.DOWNATTACKING_X_VELOCITY, GameSettings.DOWNATTACKING_NOT_ON_FLOOR_Y_VELOCITY, GameSettings.DOWNATTACKING_DAMAGE)
							
					if juggernaut:
						body.impact_x_velocity *= jugg_factor
						body.impact_y_velocity *= jugg_factor
						body.health += 15

func _on_immunity_timer_timeout():
	immunity_timer.stop()

func juggify():
	if GameSettings.current_gamemode == GameSettings.GAMEMODE.JUGGERNAUT:
		juggernaut = true
		health = 0
		apply_scale(Vector2(1.5,1.5))
		team_name = "red-team"
		dodge_meter_4_image = preload("res://assets/RedDodgeMeter4.png")
		dodge_meter_3_image = preload("res://assets/RedDodgeMeter3.png")
		dodge_meter_2_image = preload("res://assets/RedDodgeMeter2.png")
		dodge_meter_1_image = preload("res://assets/RedDodgeMeter1.png")
		dodge_meter_0_image = preload("res://assets/RedDodgeMeter0.png")
		dodge_meter_ui.texture = dodge_meter_4_image
		dodge_meter_images = [dodge_meter_0_image, dodge_meter_1_image,
		dodge_meter_2_image, dodge_meter_3_image, dodge_meter_4_image]
		arrows_left = 999
		arrow_meter_ui.texture = arrow_rain_ui
		scoreboard.update_icons()
		
func dejuggify():
	if GameSettings.current_gamemode == GameSettings.GAMEMODE.JUGGERNAUT:
		juggernaut = false
		apply_scale(Vector2(.66,.66))
		team_name = "blue-team"
		dodge_meter_4_image = preload("res://assets/BlueDodgeMeter4.png")
		dodge_meter_3_image = preload("res://assets/BlueDodgeMeter3.png")
		dodge_meter_2_image = preload("res://assets/BlueDodgeMeter2.png")
		dodge_meter_1_image = preload("res://assets/BlueDodgeMeter1.png")
		dodge_meter_0_image = preload("res://assets/BlueDodgeMeter0.png")
		dodge_meter_ui.texture = dodge_meter_4_image
		dodge_meter_images = [dodge_meter_0_image, dodge_meter_1_image,
		dodge_meter_2_image, dodge_meter_3_image, dodge_meter_4_image]
		arrows_left = 3
		update_arrow_ui()
		scoreboard.update_icons()
