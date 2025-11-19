extends RigidBody2D

var dragging :=false
var dragOffset:=Vector2.ZERO
@export var draggable:=false

func _ready() -> void:
	if not draggable:
		modulate=Color.GRAY

func _process(_delta: float) -> void:
	if dragging:
		global_position=get_viewport().get_mouse_position()-dragOffset

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if draggable and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			print('clicked')
			dragOffset=event.position-global_position
		dragging=event.pressed
