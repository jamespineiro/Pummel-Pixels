extends CharacterBody2D

# Make it so that when two arrows collide, the front one gains the speed of the back one,
# and the back one completely stops and falls down

var arrow_image1 = preload("res://assets/Player1Arrow.png")
var arrow_image2 = preload("res://assets/Player2Arrow.png")
var arrow_image3 = preload("res://assets/Player3/Player3Arrow.png")
var arrow_image4 = preload("res://assets/Player4/Player4Arrow.png")
var red_arrow_image = preload("res://assets/RedArrow.png")
var blue_arrow_image = preload("res://assets/BlueArrow.png")
@onready var hit_cloud = load("res://scenes/cloudthatwaswaytoohardtoimplement.tscn")

var this_script = preload("res://arrow.gd")

@export var SPEED = 300
@onready var sprite_2d = $Sprite2D
@onready var arrow_despawn_timer = $ArrowDespawnTimer
@onready var slow_arrow_wall_timer = $SlowArrowWallTimer
@onready var collision_shape_2d = $CollisionShape2D
@onready var area_2d_collision_shape = $Area2D/Area2DCollisionShape
@onready var arrow_emergency_timer = $ArrowEmergencyTimer
@onready var give_new_arrow_timer = $GiveNewArrowTimer
@onready var fast_arrow_wall_timer = $FastArrowWallTimer
@onready var flipped_arrow_emergency_timer = $FlippedArrowEmergencyTimer
@onready var fire = $Fire
@onready var blue_fire = $BlueFire

var direction : float
var spawnPosition : Vector2
var spawnRotation : float
var shooter = Node2D
var falling = false
var sliding = false
var sliding_speed = 500
var was_on_wall = false
var was_on_floor = false
var team_name : String
@export var gave_arrow = false
@export var slow_arrow = false
@export var flaming_arrow = false
@export var blue_flaming_arrow = false
@export var can_collide_with_player = false
@onready var arrow_fire_sound = $Sounds/ArrowFireSound
@onready var arrow_released_sound = $Sounds/ArrowReleasedSound
@onready var fire_arrow_released_sound = $Sounds/FireArrowReleasedSound
@onready var arrow_hits_ground_or_wall_sound = $Sounds/ArrowHitsGroundOrWallSound
var cloud_made = false

func _ready():
	global_position.x = spawnPosition.x
	global_position.y = spawnPosition.y+2.5
	arrow_emergency_timer.start()
	give_new_arrow_timer.start()
	can_collide_with_player = false
	if slow_arrow:
		fire.visible = true
		fire_arrow_released_sound.pitch_scale = randf_range(.9,1.2)
		fire_arrow_released_sound.play()
	else:
		arrow_released_sound.pitch_scale = randf_range(.9,1.2)
		arrow_released_sound.play()

func assign_shooter(body):
	shooter = body
	direction = shooter.global_rotation
	if not shooter.is_on_wall():
		spawnPosition = shooter.global_position
	else:
		if shooter.direction < 0:
			spawnPosition.y = shooter.global_position.y + 2.5
			spawnPosition.x = shooter.global_position.x + 5
		else:
			spawnPosition.y = shooter.global_position.y + 2.5
			spawnPosition.x = shooter.global_position.x - 5
	add_to_group(shooter.team_name)
	team_name = shooter.team_name
	add_collision_exception_with(shooter)
	add_collision_exception_with(self)
	if shooter.sprite.flip_h:
		if shooter.direction > 0:
			SPEED = -100
			slow_arrow = true
		else:
			SPEED = -300
	elif shooter.direction < 0:
		SPEED = 100
		slow_arrow = true
		
	if body.team_name == "team-one":
		get_node("Sprite2D").texture = arrow_image1 
	elif body.team_name == "team-two":
		get_node("Sprite2D").texture = arrow_image2
	elif body.team_name == "team-three":
		get_node("Sprite2D").texture = arrow_image3
	elif body.team_name == "team-four":
		get_node("Sprite2D").texture = arrow_image4
	elif body.team_name == "red-team":
		get_node("Sprite2D").texture = red_arrow_image
	elif body.team_name == "blue-team":
		get_node("Sprite2D").texture = blue_arrow_image
		
	if shooter.juggernaut or GameSettings.current_gamemode == GameSettings.GAMEMODE.SUPERSIZED:
		apply_scale(Vector2(1.5,1.5))

func _physics_process(delta):
	velocity = Vector2(SPEED, 0).rotated(direction)
	if blue_fire.visible and fire.visible:
		fire.visible = false
		if not blue_flaming_arrow:
			blue_flaming_arrow = true
	if SPEED < 0 and not sprite_2d.flip_h:
		sprite_2d.flip_h = true
	if falling:
		velocity.y = 15500 * delta
	elif sliding:
		velocity.y = (5500 + sliding_speed) * delta
		sliding_speed += 500
		if not sprite_2d.flip_h:
			if sprite_2d.rotation_degrees < 90:
				sprite_2d.rotation_degrees += 10
		else:
			if sprite_2d.rotation_degrees > -90:
				sprite_2d.rotation_degrees -= 10
		if sliding_speed > 10500:
			falling = true
		if flipped_arrow_emergency_timer.is_stopped():
			flipped_arrow_emergency_timer.start()
			
	move_and_slide()

func _on_area_2d_body_entered(body):
	if body is CharacterBody2D: # If the arrow collides with a player or arrow
		if body.has_method("shoot_arrow"):
			if not body.dodging and body.team_name == team_name and (SPEED == 0 or is_on_floor()) and can_collide_with_player: # arrow falls on players head
				if global_position.y + 5 < body.global_position.y:
					_on_arrow_despawn_timer_timeout()
			elif body.team_name != team_name and not body.dodging: # arrow hits player that is not the shooter
				body.immunity_timer.stop()
				body.player_who_hit_me_last = shooter
				if blue_flaming_arrow or (flaming_arrow and (rotation_degrees == -90 or rotation_degrees == 90)):
					if rotation_degrees == 90 or rotation_degrees == -90:
						if body.global_position.y > global_position.y:
							body.take_constant_damage(200, -8000, 15)
						else:
							body.take_damage(3, 20000, 15)
					else:
						if body.global_position.y < global_position.y:
							if sprite_2d.flip_h:
								body.take_damage(-650, -19000, 15)
							else:
								body.take_damage(650, -19000, 15)
						else:
							if sprite_2d.flip_h:
								body.take_damage(-650, 14000, 15)
							else:
								body.take_damage(650, 14000, 15)
				elif slow_arrow or flaming_arrow: 
					if blue_flaming_arrow:
						if body.global_position.y < global_position.y:
							if sprite_2d.flip_h:
								body.take_damage(-650, -19000, 15)
							else:
								body.take_damage(650, -19000, 15)
						else:
							if sprite_2d.flip_h:
								body.take_damage(-650, 14000, 15)
							else:
								body.take_damage(650, 14000, 15)
					else:
						if body.global_position.y < global_position.y:
							if sprite_2d.flip_h:
								body.take_damage(-500, -13000, 8)
							else:
								body.take_damage(500, -13000, 8)
						else:
							if sprite_2d.flip_h:
								body.take_damage(-500, 13000, 8)
							else:
								body.take_damage(500, 13000, 8)
				else:
					if sprite_2d.flip_h:
						body.take_constant_damage(-50, -2000, 3)
					else:
						body.take_constant_damage(50, -2000, 3)
				_on_arrow_despawn_timer_timeout()
			elif body.team_name != team_name and body.dodging:
				add_collision_exception_with(body)
				
		elif body.has_method("assign_shooter") and body != self: # arrow that isnt this arrow
			if body.team_name == team_name:
				if body.is_on_floor():
					_on_arrow_despawn_timer_timeout()
				else:
					if body.SPEED != 0: # other arrow is in the air
						body.SPEED = SPEED
					if sprite_2d.flip_h:
						rotation_degrees = -90
						blue_fire.rotation_degrees = 90
					else:
						rotation_degrees = 90
						blue_fire.rotation_degrees = -90
					flaming_arrow = true
					blue_fire.global_position.x = global_position.x
					blue_fire.visible = true
					blue_flaming_arrow = true
					fire.visible = false
					if not body.fire.visible:
						body.fire.visible = true
					else:
						body.fire.visible = false
						body.blue_fire.visible = true
						body.blue_flaming_arrow = true
					flipped_arrow_emergency_timer.start()
					SPEED = 0
					falling = true
			else:
				body.shooter.arrows_left+=1
				shooter.arrows_left+=1
				sprite_2d.visible = false
				fire.visible = false
				blue_fire.visible = false
				
				if body != null:
					body.sprite_2d.visible = false
					body.fire.visible = false
					body.blue_fire.visible = false
					var cloud_instance2 = hit_cloud.instantiate()
					cloud_instance2.assign_arrow(body)
					shooter.main.add_child.call_deferred(cloud_instance2)
				
				if not cloud_made:
					var cloud_instance = hit_cloud.instantiate()
					cloud_instance.assign_arrow(self)
					shooter.main.add_child.call_deferred(cloud_instance)
					cloud_made = true
				
	if body is TileMap or (body is Sprite2D and body.has_method("change_speed")): # If the arrow collides with a platform
		if is_on_floor_only() and rotation_degrees != 0: # that is a floor
			SPEED /= 5
			arrow_despawn_timer.start()
		if slow_arrow and is_on_wall_only():
			slow_arrow_wall_timer.start()
			SPEED = 0
		elif not slow_arrow and not blue_flaming_arrow:
			fast_arrow_wall_timer.start()
			SPEED = 0
		arrow_hits_ground_or_wall_sound.pitch_scale = randf_range(.9,1.2)
		arrow_hits_ground_or_wall_sound.play()
		
func give_arrow():
	if not gave_arrow:
		if shooter.arrows_left < 3:
			shooter.arrows_left += 1
			gave_arrow = true
			shooter.update_arrow_ui()

func _on_give_new_arrow_timer_timeout():
	give_arrow()
	give_new_arrow_timer.stop()

func _on_arrow_emergency_timer_timeout():
	give_arrow()
	call_deferred("queue_free")
	arrow_emergency_timer.stop()

func _on_arrow_despawn_timer_timeout():
	give_arrow()
	call_deferred("queue_free")
	arrow_despawn_timer.stop()

func _on_slow_arrow_wall_timer_timeout():
	SPEED = 0
	sliding = true
	slow_arrow_wall_timer.stop()

func _on_fast_arrow_wall_timer_timeout():
	SPEED = 0
	sliding = true
	fast_arrow_wall_timer.stop()
	
func _on_flipped_arrow_emergency_timer_timeout():
	give_arrow()
	call_deferred("queue_free")
	flipped_arrow_emergency_timer.stop()

func _on_area_2d_body_exited(body):
	if body is CharacterBody2D and body == shooter:
		can_collide_with_player = true
		remove_collision_exception_with(shooter)

func change_color_to(shield_team_name):
	if shield_team_name == "team-one":
		get_node("Sprite2D").texture = arrow_image1 
	elif shield_team_name == "team-two":
		get_node("Sprite2D").texture = arrow_image2
	elif shield_team_name == "team-three":
		get_node("Sprite2D").texture = arrow_image3
	elif shield_team_name == "team-four":
		get_node("Sprite2D").texture = arrow_image4
	elif shield_team_name == "red-team":
		get_node("Sprite2D").texture = red_arrow_image
	elif shield_team_name == "blue-team":
		get_node("Sprite2D").texture = blue_arrow_image
