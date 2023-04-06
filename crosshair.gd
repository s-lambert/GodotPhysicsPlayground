class_name Crosshair
extends Node2D

const COLOR = Color.WHITE
const LINE_WIDTH = 2.0

# Called when the node enters the scene tree for the first time.
func _draw() -> void:
	draw_line(Vector2(0, 10), Vector2(0, -10), COLOR, LINE_WIDTH, false)
	draw_line(Vector2(-10, 0), Vector2(10, 0), COLOR, LINE_WIDTH, false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
