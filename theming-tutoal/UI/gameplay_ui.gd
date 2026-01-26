extends Control

@export var description : NinePatchRect
@export var party_description: NinePatchRect

func set_description(item : Item):
	description.find_child("Name").text = item.title
	description.find_child("Icon").texture = item.icon
	description.find_child("Description").text = item.description

func set_party_description(character : Character):
	party_description.find_child("Icon").texture = character.texture
	party_description.find_child("Description").text = character.description
