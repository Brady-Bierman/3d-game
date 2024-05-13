extends CharacterBody3D


@export var speed : float = 5.0
@export var jump_velocity : float = 4.5

@onready var model = $player_model
@onready var pivot = $pivot
@onready var player = $"."
@onready var bullet_spawn = $pivot/bullet_spawn
@onready var fire_rate = $fire_rate
@onready var audio = $AudioStreamPlayer


const BULLET = preload("res://scenes/bullet.tscn")

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var bullet_speed := 15
var ready_fire := true
var has_key := false



func _unhandled_input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			player.rotation.y += (event.relative.x * -.005)
			pivot.rotation.x += (event.relative.y * -.005)
			pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-70), deg_to_rad(50))
			
			
		
		
	
	





func _physics_process(delta):
	var z := 0
	var x := 0
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_velocity
		
		
		if Input.is_action_pressed("forward"):
			z = -1
			model.rotation.y = deg_to_rad(0)
		elif Input.is_action_pressed("backward"):
			z = 1
			model.rotation.y = deg_to_rad(180)
			
			
		if Input.is_action_pressed("left"):
			x = -1
			model.rotation.y = deg_to_rad(90)
		elif Input.is_action_pressed("right"):
			x = 1
			model.rotation.y = deg_to_rad(-90)
		
		if Input.is_action_just_pressed("fire"):
			if ready_fire:
				spawn_bullet()
		
		
	if x == 0 and z == 0:
		model.rotation.y = deg_to_rad(0)
		
		
	
	
	
	
	var direction = (transform.basis * Vector3(x, 0, z)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	
	
	move_and_slide()
	
	
	










func spawn_bullet():
	ready_fire = false
	fire_rate.start()
	var projectile = BULLET.instantiate()
	audio.play()
	add_sibling(projectile)
	
	projectile.transform = bullet_spawn.global_transform
	projectile.linear_velocity = bullet_spawn.global_transform.basis.z * -1 * bullet_speed
	
	


func pickup():
	has_key = true
	
	








func _on_fire_rate_timeout():
	ready_fire = true
	






