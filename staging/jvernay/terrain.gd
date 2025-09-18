extends WorldEnvironment

func _ready():
	$Kenney.add_child(CharaControl_Input.new(0))

func _physics_process(delta: float) -> void:
	$SpotLight3D.look_at($Kenney.position)
