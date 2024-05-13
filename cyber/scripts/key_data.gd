extends RigidBody3D


@onready var timer = $Timer
@onready var mesh = $MeshInstance3D
@onready var audio = $AudioStreamPlayer
@onready var hitbox = $hitbox


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		body.pickup()
		audio.play()
		timer.start()
		mesh.queue_free()
		hitbox.queue_free()
	
	





func _on_timer_timeout():
	queue_free()
