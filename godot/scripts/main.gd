extends Control

signal return_to_office
signal action_observed(action: String)

const LEVEL_PATH := "res://levels/night_shift_checkout/level.json"
const INCIDENT_REPO_ROOT := "res://levels/night_shift_checkout/incident_repo"
const EDIT_FILE := "src/discounts.js"

var level: Dictionary = {}
var sandbox_path := ""
var discovered_clues: Dictionary = {}
var hint_index := 0
var hints_used := 0
var tests_run := 0
var elapsed_seconds := 0
var remaining_seconds := 3600

var timer_label: Label
var score_label: Label
var status_label: Label
var clue_detail: RichTextLabel
var case_file: RichTextLabel
var editor: TextEdit
var terminal_output: TextEdit
var helper_output: TextEdit
var clock_timer: Timer


func _ready() -> void:
	_load_level()
	sandbox_path = ProjectSettings.globalize_path("user://night_shift_checkout")
	remaining_seconds = int(level.get("timer_minutes", 60)) * 60
	_build_ui()
	_ensure_sandbox(true)
	_load_editor_file()
	_render_case_file()
	_render_helper_intro()
	_append_terminal("Sandbox created at: " + sandbox_path + "\n")
	_start_clock()


func _load_level() -> void:
	var raw := FileAccess.get_file_as_string(LEVEL_PATH)
	var parsed = JSON.parse_string(raw)
	if typeof(parsed) == TYPE_DICTIONARY:
		level = parsed
	else:
		push_error("Could not parse level JSON: " + LEVEL_PATH)
		level = {}


func _input(event: InputEvent) -> void:
	if is_visible_in_tree() and event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		get_viewport().set_input_as_handled()
		return_to_office.emit()


func _build_ui() -> void:
	var background := ColorRect.new()
	background.color = Color(0.055, 0.065, 0.06)
	background.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(background)

	var root := VBoxContainer.new()
	root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	root.add_theme_constant_override("separation", 8)
	root.add_child(_build_top_bar())

	var body := HSplitContainer.new()
	body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.split_offset = 360
	body.add_child(_build_clue_panel())
	body.add_child(_build_workstation())
	root.add_child(body)
	add_child(root)


func _build_top_bar() -> Control:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(0, 54)
	var bar := HBoxContainer.new()
	bar.add_theme_constant_override("separation", 18)
	bar.add_child(_title_label(str(level.get("title", "Legacy Incident"))))

	status_label = Label.new()
	status_label.text = str(level.get("incident_status", "SEV-2 active"))
	status_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bar.add_child(status_label)

	timer_label = Label.new()
	timer_label.text = "60:00"
	timer_label.add_theme_font_size_override("font_size", 22)
	bar.add_child(timer_label)

	score_label = Label.new()
	score_label.text = "Score: 1000"
	score_label.add_theme_font_size_override("font_size", 22)
	bar.add_child(score_label)

	var return_button := Button.new()
	return_button.name = "ReturnToOffice"
	return_button.text = "Return to cubicle [Esc]"
	return_button.pressed.connect(func(): return_to_office.emit())
	bar.add_child(return_button)

	panel.add_child(bar)
	return panel


func _build_clue_panel() -> Control:
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(340, 0)
	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 8)

	var desk_note := RichTextLabel.new()
	desk_note.bbcode_enabled = true
	desk_note.fit_content = true
	desk_note.text = "[b]Rifkin Software / Workstation 04[/b]\n\nJoel left the incident evidence here. Read it before touching production.\n\n[b]Desk notes[/b]"
	box.add_child(desk_note)

	var clue_heading := _section_label("Clues")
	box.add_child(clue_heading)

	for clue in level.get("clues", []):
		var button := Button.new()
		button.text = str(clue.get("title", "Clue"))
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.pressed.connect(Callable(self, "_open_clue").bind(clue))
		box.add_child(button)

	clue_detail = RichTextLabel.new()
	clue_detail.bbcode_enabled = true
	clue_detail.size_flags_vertical = Control.SIZE_EXPAND_FILL
	clue_detail.text = "[i]No clue selected.[/i]"
	box.add_child(clue_detail)

	panel.add_child(box)
	return panel


func _build_workstation() -> Control:
	var tabs := TabContainer.new()
	tabs.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	tabs.size_flags_vertical = Control.SIZE_EXPAND_FILL

	case_file = RichTextLabel.new()
	case_file.name = "Case File"
	case_file.bbcode_enabled = true
	case_file.size_flags_vertical = Control.SIZE_EXPAND_FILL
	tabs.add_child(case_file)

	var editor_box := VBoxContainer.new()
	editor_box.name = "Editor"
	editor_box.add_child(_section_label("src/discounts.js"))
	editor = TextEdit.new()
	editor.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	editor.size_flags_vertical = Control.SIZE_EXPAND_FILL
	editor.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	editor.text_changed.connect(func():
		if is_visible_in_tree():
			action_observed.emit("typing")
	)
	editor_box.add_child(editor)
	var editor_actions := HBoxContainer.new()
	var save_button := Button.new()
	save_button.text = "Save Draft"
	save_button.pressed.connect(_save_editor_file)
	editor_actions.add_child(save_button)
	var reset_button := Button.new()
	reset_button.text = "Reset Sandbox"
	reset_button.pressed.connect(_reset_sandbox)
	editor_actions.add_child(reset_button)
	editor_box.add_child(editor_actions)
	tabs.add_child(editor_box)

	var terminal_box := VBoxContainer.new()
	terminal_box.name = "Terminal"
	var terminal_actions := HBoxContainer.new()
	var simulate_button := Button.new()
	simulate_button.text = "Simulate API"
	simulate_button.pressed.connect(Callable(self, "_run_runner").bind("simulate"))
	terminal_actions.add_child(simulate_button)
	var test_button := Button.new()
	test_button.text = "Run Tests"
	test_button.pressed.connect(Callable(self, "_run_runner").bind("test"))
	terminal_actions.add_child(test_button)
	var deploy_button := Button.new()
	deploy_button.text = "Deploy"
	deploy_button.pressed.connect(Callable(self, "_run_runner").bind("deploy"))
	terminal_actions.add_child(deploy_button)
	var status_button := Button.new()
	status_button.text = "Status"
	status_button.pressed.connect(Callable(self, "_run_runner").bind("status"))
	terminal_actions.add_child(status_button)
	terminal_box.add_child(terminal_actions)
	terminal_output = TextEdit.new()
	terminal_output.editable = false
	terminal_output.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	terminal_output.size_flags_vertical = Control.SIZE_EXPAND_FILL
	terminal_box.add_child(terminal_output)
	tabs.add_child(terminal_box)

	var helper_box := VBoxContainer.new()
	helper_box.name = "Helper"
	helper_output = TextEdit.new()
	helper_output.editable = false
	helper_output.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	helper_output.size_flags_vertical = Control.SIZE_EXPAND_FILL
	helper_box.add_child(helper_output)
	var hint_button := Button.new()
	hint_button.text = "Ask for Hint"
	hint_button.pressed.connect(_next_hint)
	helper_box.add_child(hint_button)
	tabs.add_child(helper_box)
	tabs.tab_changed.connect(func(index: int):
		if is_visible_in_tree():
			action_observed.emit(["case_file_viewed", "editor_opened", "terminal_opened", "helper_opened"][index])
	)

	return tabs


func _title_label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 24)
	return label


func _section_label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", 18)
	return label


func _open_clue(clue: Dictionary) -> void:
	var clue_id := str(clue.get("id", clue.get("title", "clue")))
	if not discovered_clues.has(clue_id):
		discovered_clues[clue_id] = true
		_update_score()
	clue_detail.text = "[b]" + str(clue.get("title", "Clue")) + "[/b]\n\n" + str(clue.get("body", ""))
	action_observed.emit("clue_read")


func _render_case_file() -> void:
	var objectives := PackedStringArray()
	for item in level.get("objectives", []):
		objectives.append("- " + str(item))
	var rules := PackedStringArray()
	for item in level.get("realism_rules", []):
		rules.append("- " + str(item))
	case_file.text = "[b]Incident Brief[/b]\n" + str(level.get("brief", "")) + "\n\n[b]Objectives[/b]\n" + "\n".join(objectives) + "\n\n[b]Realism Rules[/b]\n" + "\n".join(rules)


func _render_helper_intro() -> void:
	helper_output.text = "Helper online.\n\nI can help you form hypotheses, choose evidence, and understand test output. I will not write code or patch the repo for you.\n"


func _next_hint() -> void:
	action_observed.emit("hint_requested")
	var hints: Array = level.get("hints", [])
	if hint_index >= hints.size():
		helper_output.text += "\nNo more direct hints. Re-run the API simulation, compare it to the schema diff, and make the smallest code change that preserves old coupons."
		return
	hints_used += 1
	helper_output.text += "\nHint " + str(hint_index + 1) + ": " + str(hints[hint_index])
	hint_index += 1
	_update_score()


func _ensure_sandbox(force_reset: bool) -> void:
	if force_reset and DirAccess.dir_exists_absolute(sandbox_path):
		_remove_dir_recursive(sandbox_path)
	DirAccess.make_dir_recursive_absolute(sandbox_path)
	for file_path in level.get("repo_files", []):
		var source_path := INCIDENT_REPO_ROOT + "/" + str(file_path)
		var target_path := sandbox_path.path_join(str(file_path))
		DirAccess.make_dir_recursive_absolute(target_path.get_base_dir())
		var contents := FileAccess.get_file_as_string(source_path)
		var out := FileAccess.open(target_path, FileAccess.WRITE)
		if out:
			out.store_string(contents)


func _remove_dir_recursive(path: String) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		return
	for file_name in dir.get_files():
		dir.remove(file_name)
	for dir_name in dir.get_directories():
		_remove_dir_recursive(path.path_join(dir_name))
	dir.change_dir("..")
	DirAccess.remove_absolute(path)


func _load_editor_file() -> void:
	var edit_path := sandbox_path.path_join(EDIT_FILE)
	editor.set_block_signals(true)
	editor.text = FileAccess.get_file_as_string(edit_path)
	editor.set_block_signals(false)


func _save_editor_file(observe: bool = true) -> void:
	var edit_path := sandbox_path.path_join(EDIT_FILE)
	var out := FileAccess.open(edit_path, FileAccess.WRITE)
	if out:
		out.store_string(editor.text)
		if observe:
			action_observed.emit("draft_saved")
	_append_terminal("Saved " + EDIT_FILE + "\n")


func _reset_sandbox() -> void:
	_ensure_sandbox(true)
	_load_editor_file()
	_append_terminal("Sandbox reset to the incident snapshot.\n")
	action_observed.emit("sandbox_reset")


func _run_runner(command: String) -> void:
	_save_editor_file(false)
	if command == "test":
		tests_run += 1
	var runner_path := ProjectSettings.globalize_path("res://tools/level_runner.mjs")
	var output: Array = []
	var args := PackedStringArray([runner_path, sandbox_path, command])
	var exit_code := OS.execute("node", args, output, true, false)
	var text := ""
	if output.size() > 0:
		text = str(output[0])
	_append_terminal("$ " + command + "\n" + text + "\n(exit " + str(exit_code) + ")\n")
	if command == "deploy":
		if exit_code == 0:
			status_label.text = "Deploy accepted. Checkout restored."
		else:
			status_label.text = "Deploy rejected. Evidence still disagrees."
		action_observed.emit("deploy_accepted" if exit_code == 0 else "deploy_rejected")
	elif command == "test":
		action_observed.emit("tests_passed" if exit_code == 0 else "tests_failed")
	elif command == "simulate":
		action_observed.emit("simulate")
	elif command == "status":
		action_observed.emit("status_checked")
	_update_score()


func _append_terminal(text: String) -> void:
	terminal_output.text += text + "\n"
	terminal_output.set_caret_line(max(0, terminal_output.get_line_count() - 1))


func _start_clock() -> void:
	clock_timer = Timer.new()
	clock_timer.wait_time = 1.0
	clock_timer.timeout.connect(_tick_clock)
	add_child(clock_timer)
	clock_timer.start()
	_update_timer()
	_update_score()


func _tick_clock() -> void:
	elapsed_seconds += 1
	if remaining_seconds > 0:
		remaining_seconds -= 1
	_update_timer()
	if remaining_seconds == 1800:
		status_label.text = "SEV-2 active. Support queue is growing."
	elif remaining_seconds == 600:
		status_label.text = "SEV-1 warning. Leadership joined the bridge."
	elif remaining_seconds == 0:
		status_label.text = "Clock expired. You can still finish, but the ending will reflect it."
	_update_score()


func _update_timer() -> void:
	var minutes := int(remaining_seconds / 60)
	var seconds := remaining_seconds % 60
	timer_label.text = "%02d:%02d" % [minutes, seconds]


func _update_score() -> void:
	if score_label == null:
		return
	var base := 1000
	var penalty := int(elapsed_seconds / 6) + hints_used * 60 + tests_run * 5
	var bonus := discovered_clues.size() * 20
	var score: int = int(max(0, base - penalty + bonus))
	score_label.text = "Score: " + str(score)
