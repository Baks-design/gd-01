class_name State extends Node

var state_machine: StateMachine
var player: CharacterBody3D
var is_entering: bool = false

func enter(_msg: Dictionary = {}) -> void:
	is_entering = true
	_on_enter(_msg)
	is_entering = false

func _on_enter(_msg: Dictionary = {}) -> void: pass

func exit() -> void: pass

func physics_update(_delta: float) -> void: pass

func update(_delta: float) -> void: pass

func handle_input(_event: InputEvent) -> void: pass
