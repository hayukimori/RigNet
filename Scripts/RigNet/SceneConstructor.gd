extends Node

@export var decoder: RigNetDecoder
@export var vbox: VBoxContainer


func _ready() -> void:
	decoder.PageLoaded.connect(_on_page_loaded)
	decoder.PageFailed.connect(_on_page_failed)

	decoder.FetchPage("rignet://cyberspace.hayuki.cyou/pages/hub")

func render(page):
	for node in page.Nodes:
		match node.Type:
			0: pass  # UNKNOWN
			1: _add_heading(node.Text, node.Color)
			2: _add_paragraph(node.Text)
			3: _add_image(node.Url)
			4: _add_link(node.Text, node.Url)
			5: _add_divider()

func load_page(url: String) -> void:
	var nodes: Array = vbox.get_children()
	for node in nodes:
		node.queue_free()

	decoder.FetchPage(url)

func _add_heading(text: String, color: String):
	var label = Label.new()
	label.text = text
	if color != "":
		label.add_theme_color_override("font_color", Color(color))
	vbox.add_child(label)

func _add_paragraph(text: String):
	var label = Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	vbox.add_child(label)

func _add_divider():
	var sep = HSeparator.new()
	vbox.add_child(sep)

func _add_link(text: String, url: String):
	var btn = Button.new()
	btn.text = text
	btn.pressed.connect(func(): load_page(url))
	vbox.add_child(btn)

func _add_image(url: String):
	print("Found image")
	var req = HTTPRequest.new()
	var rect = TextureRect.new()
	add_child(req)
	req.request_completed.connect(func(result, code, headers, body):
		if code == 200:
			var img = Image.new()
			img.load_png_from_buffer(body)
			rect.texture = ImageTexture.create_from_image(img)
		req.queue_free()
	)
	vbox.add_child(rect)
	req.request(url)


func _on_page_loaded(page: RigPageWrapper) -> void:
	render(page)

func _on_page_failed(error: String) -> void:
	push_error("RigNet: " + error)
