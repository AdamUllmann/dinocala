extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 4.0
var defaultSpeed = 4.0
#var sprintSpeed = 25.0
var sprintSpeed = 250.0
#var jump_speed = 11.0
var jump_speed = 40.0
var mouse_sensitivity = 0.002
var actionPressed = false
var inAir = false

@onready var camera = $ThirdPersonCamera
@onready var raycast := $Camera3D/RayCast3D
@onready var world := $/root/main/map
@onready var playerCoords := $/root/UIposition
@onready var waterMesh := get_parent().get_node("waterMesh")


func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

func get_input():
	var input = Input.get_vector("strafe_left", "strafe_right", "move_forward", "move_back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed
	waterMesh.get_child(0).position.x = position.x
	waterMesh.get_child(0).position.z = position.z
	waterMesh.get_child(0).position.y = abs(position.x / 600) + abs(position.z / 600)
	

func _physics_process(delta):
	
	doAction()
	velocity.y += -gravity * delta
	get_input()
	move_and_slide()
	jump()
	
func jump():
	if inAir and is_on_floor():
		
		inAir = false
		


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		var cam_rot = camera.rotation_degrees
		cam_rot.x -= event.relative.y * mouse_sensitivity
		cam_rot.y -= event.relative.x * mouse_sensitivity
		cam_rot.x = clamp(cam_rot.x, -70, 70)  # Limit vertical angle
		camera.rotation_degrees = cam_rot
		
		
	if event.is_action_released("action"):
		$AnimationPlayer.stop()
		actionPressed = false
		$Camera3D/pickaxe/pickaxe/pickCam2.current = false
		$Camera3D.current = true		
		
	if event.is_action_pressed("sprint"):
		speed = sprintSpeed
	if event.is_action_released("sprint"):
		speed = defaultSpeed
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		%Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		%Camera3D.rotation.x = clampf(%Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
			
	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
		inAir = true

		
	
	
	

func breakBlocks():
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider is StaticBody3D:
			var collisionPoint = raycast.get_collision_point()
			var particleScene := preload("res://Scenes/player/mining_particles.tscn")
			var particles := particleScene.instantiate()
			particles.position = collisionPoint
			world.add_child(particles)
			particles.emitting = true
			world.dig(collisionPoint, 1)
			
		
func doAction():
	if actionPressed:
		breakBlocks()
