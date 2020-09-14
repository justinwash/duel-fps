extends Node

const db = {}

func add_entry(name, data):
	db[name] = data
	
func remove_entry(name):
	if db[name]:
		var _removed_entry = db.erase(name)
		
func get_entry(name):
	return db[name]
