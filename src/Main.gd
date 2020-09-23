extends Node2D

export (PackedScene) var Enemy


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_EnemyTimer_timeout():
	var enemy = Enemy.instance()
	add_child(enemy)
	enemy.position = $EnemyPosition.position
