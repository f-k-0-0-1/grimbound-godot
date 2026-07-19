extends Node2D

@export var tile_texture: Texture2D
@export var segment_count: int = 5
@export var tile_size: int = 48
@export var tile_height: int = 20
@export var gap_between: float = 0.0
@export var gravity_scale: float = 1.0
@export var bridge_slack: float = 0.95 # NEW: Controls how much the bridge droops

@onready var anchor: StaticBody2D = $AnchorPoint
@onready var segments_container: Node2D = $Segments

var segment_list: Array = []

func _ready() -> void:
	_generate_bridge()

func _generate_bridge() -> void:
	# Clear existing segments
	for child in segments_container.get_children():
		child.queue_free()
	if has_node("EndAnchor"):
		get_node("EndAnchor").queue_free()
		
	segment_list.clear()
	await get_tree().process_frame
	
	# We use the exact center of the tile for placement
	var half_tile = tile_size / 2.0
	
	for i in range(segment_count):
		var seg = _create_segment(i)
		segments_container.add_child(seg)
		segment_list.append(seg)
		
		# FIX 1: Perfectly center the rigid body origin
		seg.position = Vector2(i * (tile_size + gap_between) + half_tile, 0)
		
		var joint = PinJoint2D.new()
		joint.disable_collision = true
		
		# FIX 3: Add joints to the container, NOT the rotating rigid bodies
		segments_container.add_child(joint)
		
		if i == 0:
			joint.node_a = anchor.get_path()
			joint.node_b = seg.get_path()
			# Pivot exactly at the start anchor
			joint.position = Vector2(0, 0) 
		else:
			var prev_seg = segment_list[i-1]
			joint.node_a = prev_seg.get_path()
			joint.node_b = seg.get_path()
			# Pivot exactly between the two segments
			joint.position = Vector2(i * (tile_size + gap_between), 0)

	if segment_count > 0:
		var end_anchor = StaticBody2D.new()
		end_anchor.name = "EndAnchor"
		add_child(end_anchor)
		
		var total_width = segment_count * (tile_size + gap_between)
		
		# FIX 2: Apply slack so the bridge isn't a tightrope
		end_anchor.position = Vector2(total_width * bridge_slack, 0)
		
		var final_joint = PinJoint2D.new()
		final_joint.disable_collision = true
		segments_container.add_child(final_joint)
		
		var last_seg = segment_list[-1]
		final_joint.node_a = last_seg.get_path()
		final_joint.node_b = end_anchor.get_path()
		
		# Pivot at the right edge of the last segment
		final_joint.position = Vector2(total_width, 0)

func _create_segment(index: int) -> RigidBody2D:
	var seg = RigidBody2D.new()
	seg.name = "Segment_" + str(index)
	seg.gravity_scale = gravity_scale
	
	# FIX 4: Lower dampening so it swings realistically
	seg.linear_damp = 0.1
	seg.angular_damp = 0.1
	
	var sprite = Sprite2D.new()
	sprite.texture = tile_texture
	# Sprite is centered by default, do not change it
	seg.add_child(sprite)
	
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = Vector2(tile_size, tile_height) 
	collision.shape = shape
	# Collision is perfectly aligned with the centered sprite
	seg.add_child(collision)
	
	return seg
