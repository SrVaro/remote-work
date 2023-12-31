extends Node2D

@onready var interaction_area = $InteractionArea
@onready var progressBar
@onready var particleSystem = $GPUParticles2D
@onready var computer = $Computer
@onready var text_edit = get_node("/root/UI/HUD/WorkExeScreen/WorkExeScreen/TextEditMargin/TextEdit")

@onready var notification_alert = $NotificationAlert

var last_key: String

var code_example = [
	"struct group_info *groups_alloc(int gidsetsize)",
	"	{",
	"		struct group_info *gi;",
	"		gi = kvmalloc(struct_size(gi, gid, gidsetsize), GFP_KERNEL_ACCOUNT);",
	"		if (!gi)",
	"			return NULL;",
	"		atomic_set(&gi->usage, 1);",
	"		gi->ngroups = gidsetsize;",
	"		return gi;",
	"	}",
	"",
	"EXPORT_SYMBOL(groups_alloc);",
	"void groups_free(struct group_info *group_info)",
	"	{",
	"		kvfree(group_info);",
	"	}",
	"",
	"EXPORT_SYMBOL(groups_free);,",
	"/* export the group_info to a user-space array */",
	"static int groups_to_user(gid_t __user *grouplist,",
	"const struct group_info *group_info)",
	"struct user_namespace *user_ns = current_user_ns();",
	"int i;",
	"unsigned int count = group_info->ngroups;",
	"",
	"for (i = 0; i < count; i++) {",
	"	gid_t gid;",
	"	gid = from_kgid_munged(user_ns, group_info->gid[i]);",
	"	if (put_user(gid, grouplist+i))",
	"	return -EFAULT;",
	"}",
		"return 0;",
	"}",
	"EXPORT_SYMBOL(groups_free);,",
	"/* export the group_info to a user-space array */",
	"static int groups_to_user(gid_t __user *grouplist,",
	"const struct group_info *group_info)",
	"struct user_namespace *user_ns = current_user_ns();",
	"int i;",
	"unsigned int count = group_info->ngroups;",
	]
	
var text_upd_counter: int = 0
var random = RandomNumberGenerator.new()

var tiktok_event = false
var tiktoks_passed = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	interaction_area.interact = Callable(self, "_trigger_computer")
	text_edit.text_changed.connect(_on_text_edit_text_changed)
	text_edit.visibility_changed.connect(_on_text_edit_visibility_changed)
	Events.tiktok_event.connect(_on_tiktok_event)
	progressBar = text_edit.get_node("../../ProgressBar")
	random.randomize()
	
func _process(delta):
	if !NotificationManager._is_notification_list_empty():
		notification_alert.show()
	else: 
		notification_alert.hide()
	
func _trigger_computer():
	GameSystem.toggle_computer_mode()
	text_edit.text = ""
	text_upd_counter = 0

func _on_text_edit_visibility_changed():
	text_edit.grab_focus()

func _on_text_edit_text_changed():
	last_key = text_edit.get_line(text_edit.get_line_count() -1).strip_edges(true,true)[0]
	text_edit.editable = false
	text_edit.remove_text(text_upd_counter, 0, text_upd_counter, 1)
	text_upd_counter += 1
	if !NotificationManager._is_notification_list_empty():
		var first_notification: Notification = NotificationManager._get_first_notification()
		progressBar.max_value = first_notification.task_level * 100
		if progressBar.value < progressBar.max_value:
			computer.play("new_animation")
			progressBar.value += 2.5
		else:
			NotificationManager._remove_first_notification()
			progressBar.value = 0
			computer.play("default")
	text_edit.insert_text_at_caret(code_example[random.randi_range(0, 30)] + "\n", 0)
	await get_tree().create_timer(0.1).timeout
	text_edit.editable = true

	
func _on_tiktok_event(value: bool):
	text_edit.editable = !value

	
	

	
