extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("connected_to_server",self,"entered_room")
	get_tree().connect("network_peer_connected",self,"new_user_connected")
	get_tree().connect("network_peer_disconnected",self,"user_disconnected")
	get_tree().connect("server_disconnected",self,"server_disconnected")
	pass # Replace with function body.
	
func entered_room():
	$Panel/ChatBox.text += "Entered the room \n"
	
func new_user_connected(id):
	$Panel/ChatBox.text += str(id) + " has entered the room \n"
	
func user_disconnected(id):
	$Panel/ChatBox.text += str(id) + " has left the room \n"
	
func server_disconnected():
	$Panel/ChatBox.text += "Server has disconnected \n"
	
func host_chat():
	var host = NetworkedMultiplayerENet.new()
	host.create_server(2000)
	get_tree().set_network_peer(host)
	
func _input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ENTER:
			send_message()

func join_room():
	var ip = $IpAddress.text
	var host = NetworkedMultiplayerENet.new()
	host.create_client(ip,2000)
	get_tree().set_network_peer(host)

func send_message():
	var message = $Panel/ChatInput.text
	var id = get_tree().get_network_unique_id()#GameManager.userInfo.email#
	rpc("receive_message",id,message)
	$Panel/ChatInput.text = ""

sync func receive_message(id,message):
	$Panel/ChatBox.text += str(id) + ": " + message + "\n"
	
func _on_HostRoom_button_up():
	host_chat()
	pass # Replace with function body.


func _on_JoinRoom_button_up():
	join_room()
	pass # Replace with function body.


func _on_Leave_button_up():
	get_tree().set_network_peer(null)
	pass # Replace with function body.
