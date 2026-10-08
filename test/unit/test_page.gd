extends GutTest

var width: int = 100
var height: int = 200
var page: Page


func before_each():
	page = Page.new(width, height)


func test_page_creation():
	assert_not_null(page, "Page existence")


func test_page_image():
	var images = page.layers

	assert_not_null(images[0], "Background image existence")
	assert_eq(images[0].get_width(), width, "Background width check")
	assert_eq(images[0].get_height(), height, "Background height check")

	assert_not_null(images[1], "Foreground image existence")
	assert_eq(images[1].get_width(), width, "Foreground width check")
	assert_eq(images[1].get_height(), height, "Foreground height check")

	page.create_layer(width, height)
	images = page.layers
	assert_not_null(images[2], "New image existence")
	assert_eq(images[2].get_width(), width, "New width check")
	assert_eq(images[2].get_height(), height, "New height check")


func test_page_texture():
	var textures = page.get_content()

	assert_not_null(textures[0], "Background texture existence")
	assert_eq(textures[0].get_width(), width, "Background width check")
	assert_eq(textures[0].get_height(), height, "Background height check")

	assert_not_null(textures[1], "Foreground texture existence")
	assert_eq(textures[1].get_width(), width, "Foreground width check")
	assert_eq(textures[1].get_height(), height, "Foreground height check")

	page.create_layer(width, height)
	textures = page.get_content()
	assert_not_null(textures[2], "New texture existence")
	assert_eq(textures[2].get_width(), width, "New width check")
	assert_eq(textures[2].get_height(), height, "New height check")


func test_history_limit():
	for i in range(25):
		page.save_history_state()

	assert_eq(page.get_history_size(), 20, "History should contain at most 20 states")


func test_undo_restores_previous_state():
	var original_color = page.layers[0].get_pixel(0, 0)

	page.save_history_state()
	page.layers[0].set_pixel(0, 0, Color.RED)

	assert_true(page.undo(), "Undo should succeed")
	assert_eq(
		page.layers[0].get_pixel(0, 0),
		original_color,
		"Undo should restore the previous state"
	)


func test_undo_without_history():
	assert_false(page.undo(), "Undo should fail when there is no history")
