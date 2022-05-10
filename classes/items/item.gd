extends Resource
class_name Item

export(String) var name = ""
export(String) var description = ""
export(String, 'Consumable', 'Weapon', 'Amor', '') var item_type
export(Texture) var icon
export(int) var value_to_add = 0
export(int) var weapon_damage = 0
export(int) var weapon_energie = 0
export(int) var amor_defense = 0
export(String, 'Feuer', 'Eis','Blitz', 'Neutral') var element_type
export(int) var item_costs
