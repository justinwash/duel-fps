extends Node

signal health_updated

export var HEALTH = 100 setget health_set, health_get

func health_set(new_value):
    HEALTH = new_value
    emit_signal("health_updated")

func health_get():
    return HEALTH
