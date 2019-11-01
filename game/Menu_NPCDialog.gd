class_name Menu_NPCDialog
extends PopupDialog


# Called when the node enters the scene tree for the first time.
func _ready():
	add_user_signal("Done",[TYPE_OBJECT])
	add_user_signal("Choice",[TYPE_OBJECT])
# warning-ignore:return_value_discarded
	$Panel/GridContainer/Button1.connect("pressed",self,"_on_Button_pressed",[0])
	$Panel/GridContainer/Button2.connect("pressed",self,"_on_Button_pressed",[1])
	$Panel/GridContainer/Button3.connect("pressed",self,"_on_Button_pressed",[2])
	$Panel/GridContainer/Button4.connect("pressed",self,"_on_Button_pressed",[3])

var _Dlg:DialogScene

func init(Dlg:DialogScene):
	_Dlg=Dlg

func _on_Button_OK_pressed():
	self.visible=false
	emit_signal("Done", self)	

func _on_Button_pressed(extra_arg_0):
	emit_signal("Choice", extra_arg_0)

func stageChanged():
	$Panel/RichTextLabel.bbcode_text=_Dlg.get_ActualStage().get_Text()
	if(_Dlg.get_ActualStage().get_Choices().has(0)):
		$Panel/GridContainer/Button1.visible=true
		$Panel/GridContainer/Button1.text= _Dlg.get_ActualStage().get_Choices()[0].get_Text()
	else:
		$Panel/GridContainer/Button1.visible=false
		
	if(_Dlg.get_ActualStage().get_Choices().has(1)):
		$Panel/GridContainer/Button2.visible=true
		$Panel/GridContainer/Button2.text= _Dlg.get_ActualStage().get_Choices()[1].get_Text()
	else:
		$Panel/GridContainer/Button2.visible=false
	if(_Dlg.get_ActualStage().get_Choices().has(2)):
		$Panel/GridContainer/Button3.visible=true
		$Panel/GridContainer/Button3.text= _Dlg.get_ActualStage().get_Choices()[2].get_Text()
	else:
		$Panel/GridContainer/Button3.visible=false
	if(_Dlg.get_ActualStage().get_Choices().has(3)):
		$Panel/GridContainer/Button4.visible=true
		$Panel/GridContainer/Button4.text= _Dlg.get_ActualStage().get_Choices()[3].get_Text()
	else:
		$Panel/GridContainer/Button4.visible=false
	
	#if(_Dlg.get_Actor(0) != null):
	#	NPC1.se_Dlg.get_Actor(0).get_Image()
	