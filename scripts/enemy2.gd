extends CharacterBody3D




const KEY_DATA = preload("res://scenes/key_data.tscn")


const SPEED = 50
const JUMP_VELOCITY = 4.5


@onready var nav = $NavigationAgent3D
@onready var agro_clock = $agro_clock
@onready var agro_count_clock = $agro_count_clock
@onready var model = $model



# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var target = Vector3(20, 2, -200)
var agro := false
var agro_clk := false
var agro_cont_clk := false
var clock_deg := 0
var count_clock_deg := 0




func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	
	
	if clock_deg > 360:
		clock_deg = 0
	if count_clock_deg < -360:
		count_clock_deg = 0
	
	
	if !agro_clk and !agro_cont_clk:
		model.rotation.y = 0
		look_at(target)
	
	
	
	if position.distance_to(target) > 3 and !agro:
		var current = global_transform.origin
		var next = nav.get_next_path_position()
		var direction = (next - current).normalized()
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	
	if position.distance_to(target) < 4:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	
	
	
	if agro_clk and !agro_cont_clk:
		model.rotation.y = agro_clock.get_rotation().y
	
	if !agro_clk and agro_cont_clk:
		model.rotation.y = agro_count_clock.get_rotation().y
	
	if agro_clk and agro_cont_clk:
		model.rotation.y = (agro_clock.get_rotation().y + (agro_count_clock.get_rotation().y * -1))/2
	
	
	if agro_clock.is_colliding():
		agro_clk = true
	
	if agro_count_clock.is_colliding():
		agro_cont_clk = true
	
	if !agro_clock.is_colliding():
		agro_clk = false
	
	if !agro_count_clock.is_colliding():
		agro_cont_clk = false
	
	if !agro_clk:
		clock_deg += 4
		agro_clock.rotation.y = deg_to_rad(clock_deg)
	
	if !agro_cont_clk:
		count_clock_deg -= 4
		agro_count_clock.rotation.y = deg_to_rad(count_clock_deg)
	
	
	move_and_slide()


func _on_area_3d_body_entered(body):
	if body.is_in_group("attacks"):
		var key = KEY_DATA.instantiate()
		add_sibling(key)
		key.transform = self.global_transform
		body.queue_free()
		queue_free()
		
		
	
	
	
	




