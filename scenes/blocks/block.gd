extends RigidBody2D

var dragging :=false
var dragOffset:=Vector2.ZERO
var active:=false
@export var draggable:=false
@onready var resetPosition:=position
@onready var resetRotation:=rotation

func _ready() -> void:
	if not draggable:
		modulate=Color.GRAY

func _process(_delta: float) -> void:
	if dragging:
		global_position=get_viewport().get_mouse_position()-dragOffset

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	#print('event')
	if draggable and not active and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			print('clicked')
			dragOffset=event.position-global_position
		dragging=event.pressed

func activate()->void:
	modulate=Color.WHITE
	freeze=false
	#sleeping=false
	active=true
	resetPosition=position
	resetRotation=rotation

func reset()->void:
	#sleeping=true
	active=false
	set_deferred('freeze',true)
	set_deferred('position',resetPosition)
	set_deferred('rotation',resetRotation)
	if not draggable:
		modulate=Color.GRAY
