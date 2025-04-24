extends CanvasLayer

@onready var inventory :InventoryManager = $GUI/Inventory
@onready var black_bars: TextureRect = $GUI/BlackBars

func _ready() -> void:
	if get_tree().current_scene == self:
		print("Disabling Duplicate")
		self.queue_free()
	hide_inventory()
	inventory.prepare()


func hide_inventory():inventory.hide()
func show_inventory():inventory.show()
func hide_black_bars():black_bars.hide()
func show_black_bars():black_bars.show()
