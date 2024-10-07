extends CharacterBody2D

@onready var main = get_tree().get_root()
@onready var hit_cloud = load("res://scenes/cloudthatwaswaytoohardtoimplement.tscn")

@export var player_index = GameSettings.player1_player_index
var team_name = "team-dummy"

@onready var player_1 : CharacterBody2D
@onready var player_2 : CharacterBody2D
@onready var player_3 : CharacterBody2D
@onready var player_4 : CharacterBody2D

@export var health = 0
@export var lives = 9999
@export var score = 0

@onready var hit_sound = $HitSound
@onready var respawn_timer = $RespawnTimer

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var dead = false
var starting_position_x : int
var starting_position_y : int
var colliding_with_arrow = false

@onready var sprite = $AnimatedSprite2D

@onready var immunity_timer = $ImmunityTimer

var killzone_script = preload("res://killzone.gd")

var hit = false
var stunned = false
var impact_y_velocity = 0.0
var impact_x_velocity = 0.0
const CLOUD_STARTING_FRAMES = 2
var cloud_frames = CLOUD_STARTING_FRAMES

@onready var player_health = $PlayerHealth
@onready var scoreboard : Control
@onready var player_who_hit_me_last : CharacterBody2D

var gravity_capped = false
var can_explode = true
var dodging = false

func _ready():
	
	if GameSettings.current_gamemode != GameSettings.GAMEMODE.PRACTICE:
		queue_free()
	else:
		visible = true
		
	scoreboard = get_node("../CanvasLayer/ScoreboardAndIcons")
	
	for dummy in get_tree().get_nodes_in_group("Dummies"):
		add_collision_exception_with(dummy)
		
	if GameSettings.player1_selected:
		player_1 = get_node("../player")
		add_collision_exception_with(player_1)
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
	starting_position_y = 0
	
func _physics_process(delta):
	
	update_health_text()		
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if (not is_on_floor()) and (((velocity.y * delta) > 5 or gravity_capped) and not hit):
		velocity.y = 12000 * delta
		gravity_capped = true
	else:
		gravity_capped = false

	# Handle jump.
	if is_on_floor():
		sprite.rotation_degrees = 0
		if gravity_capped:
			gravity_capped = false
	else:
		sprite.rotation_degrees -= 1
#
		#velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if not dead:
		move_and_slide()
		if hit:
			if abs(impact_y_velocity) > 500:
				sprite.rotation_degrees += impact_y_velocity / 300
			else:
				sprite.rotation_degrees += impact_x_velocity/6
				
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
			
			if ((not is_on_floor() and (abs(impact_y_velocity) < 500 and abs(impact_x_velocity) < 500) or (abs(impact_y_velocity) < 50 and abs(impact_x_velocity) < 50)) or (abs(impact_x_velocity) < 1 and is_on_floor())):
				hit = false
				velocity.x = 0

func update_health_text():
	player_health.text = str(int(health))

func _on_area_2d_body_entered(body):
	if colliding_with_arrow:
		colliding_with_arrow = false
	if body is CharacterBody2D:
		if body.has_method("assign_shooter") and body.can_collide_with_player:
			if body.is_in_group(team_name):
				colliding_with_arrow = true
				if velocity.y < 0:
					velocity.y = 0
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
			
		impact_x_velocity = (x_velocity * (health_factor))
		impact_y_velocity = (y_velocity * (health_factor))
		health += damage
		if player_who_hit_me_last != null:
			player_who_hit_me_last.dmg_dealt += damage
		immunity_timer.start()
	
func take_constant_damage(x_velocity, y_velocity, damage):
	if immunity_timer.is_stopped():
		hit_sound.pitch_scale = randf_range(.85,1.05)
		hit_sound.play()
		hit = true
		var health_factor = .7
			
		impact_x_velocity = (x_velocity * (health_factor))
		impact_y_velocity = (y_velocity * (health_factor))
		
		health += damage
		if player_who_hit_me_last != null:
			player_who_hit_me_last.dmg_dealt += damage
		immunity_timer.start()

func revive():
	health = 0
	if not scoreboard.game_just_finished:
		if not dead:
			if player_who_hit_me_last != null:
				player_who_hit_me_last.score += 1
				player_who_hit_me_last.knockouts += 1
			else:
				if player_1 != null and player_1.team_name != team_name and not player_1.dead:
					player_1.score += 1
					player_1.knockouts += 1
				elif player_2 != null and player_2.team_name != team_name and not player_2.dead:
					player_2.score += 1
					player_2.knockouts += 1
				elif player_3 != null and player_3.team_name != team_name and not player_3.dead:
					player_3.score += 1
					player_3.knockouts += 1
				elif player_4 != null and player_4.team_name != team_name and not player_4.dead:
					player_4.score += 1
					player_4.knockouts += 1
		global_position.x = -50
		global_position.y = -50
		dead = true
		if lives > 1:
			respawn_timer.start()
			
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
		
		can_explode = true
		respawn_timer.stop()

func _on_immunity_timer_timeout():
	immunity_timer.stop()
