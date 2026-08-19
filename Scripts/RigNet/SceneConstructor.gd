extends Node

@export var page_container: HBoxContainer
@export var decoder: RigNetDecoder

func _ready():
	decoder.PageLoaded.connect(_on_rig_net_decoder_page_loaded)
	decoder.PageFailed.connect(_on_rig_net_decoder_page_failed)

	load_page("rignet://cyberspace.hayuki.cyou/pages/hub")

func load_page(url: String):
	decoder.FetchPage(url)

func _on_rig_net_decoder_page_loaded(page: RigPageWrapper):
	for child in page_container.get_children():
		child.queue_free()

	var i := 0
	while i < page.Sections.size():
		var section: RigSectionWrapper = page.Sections[i]

		match section.Layout:
			0: # FULL
				var vbox := _make_section_vbox(section)
				vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				page_container.add_child(vbox)
				i += 1

			1: # LEFT
				var hbox := HBoxContainer.new()
				hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL

				var left := _make_section_vbox(section)
				left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				hbox.add_child(left)

				if i + 1 < page.Sections.size() and page.Sections[i + 1].Layout == 2:
					var right := _make_section_vbox(page.Sections[i + 1])
					right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
					hbox.add_child(right)
					i += 2
				else:
					i += 1

				page_container.add_child(hbox)

			2: # RIGHT alone (no left before)
				var vbox := _make_section_vbox(section)
				vbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				page_container.add_child(vbox)
				i += 1

			3: # SPLIT — splits equally
				var hbox := HBoxContainer.new()
				hbox.size_flags_horizontal = Control.SIZE_EXPAND_FILL

				var left := _make_section_vbox(section)
				left.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				hbox.add_child(left)

				if i + 1 < page.Sections.size():
					var right := _make_section_vbox(page.Sections[i + 1])
					right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
					hbox.add_child(right)
					i += 2
				else:
					i += 1

				page_container.add_child(hbox)

func _make_section_vbox(section: RigSectionWrapper) -> VBoxContainer:
	var vbox := VBoxContainer.new()

	if section.Title != "":
		var label := Label.new()
		label.text = "\\ " + section.Title
		vbox.add_child(label)
		vbox.add_child(HSeparator.new())

	for node in section.Nodes:
		var element := _build_node(node)
		if element:
			vbox.add_child(element)

	return vbox

func _build_node(node: RigNodeWrapper) -> Control:
	match node.Type:
		1: return _make_heading(node.Text, node.Color)
		2: return _make_paragraph(node.Text)
		3: return _make_image(node.Url)
		4: return _make_link(node.Text, node.Url)
		5: return HSeparator.new()
	return null

func _make_heading(text: String, color: String) -> Label:
	var label := Label.new()
	label.text = text
	if color != "":
		label.add_theme_color_override("font_color", Color(color))
	return label

func _make_paragraph(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.autowrap_mode = TextServer.AUTOWRAP_WORD
	return label

func _make_link(text: String, url: String) -> Button:
	var btn := Button.new()
	btn.text = text
	btn.pressed.connect(func(): load_page(url))
	return btn

func _make_image(url: String) -> TextureRect:
	var rect := TextureRect.new()
	var req  := HTTPRequest.new()
	add_child(req)
	req.request_completed.connect(func(_r, code, _h, body):
		if code == 200:
			var img := Image.new()
			img.load_png_from_buffer(body)
			rect.texture = ImageTexture.create_from_image(img)
		req.queue_free()
	)
	req.request(url)
	return rect

func _on_rig_net_decoder_page_failed(error: String):
	push_error("RigNet: " + error)
