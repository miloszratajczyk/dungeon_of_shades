extends Node

@onready var mess: Control

var is_first_cape_drop: bool = true
var is_first_wand_drop: bool = true

#Texture id, text, time, should_continue
var data := {
	"loading":[
		[0, "Loading", 0.1],
	],
	"pause":[
		[1, "Pause", 0.1],
	],
	"game-over":[
		[10, "You died. LOL!", 10.0],
	],
	"key":[
		[18, "Great! Now we can go to another level.", 5.0],
		[8, "Yipee! The key is found!", 4.0],
		[8, "Here comes the keeeeeey. Hello key. Welcome.", 6.0],
		[8, "There he is. He is here.", 5.0],
		[16, "Why would you lock the exit if you leave the key lying around?", 6.0],
		[15, "I'm tired. Can we go now?", 4.0],
		[14, "Yey... Yet another key.", 4.0],
	],
	"lock": [
		[22, "You have to find the key first.", 5.0],
		[22, "The exit is locked.", 5.0],
		[22, "Find the key first.", 5.0],
		[23, "<- That thing. Find it first.", 5.0],
		[22, "No exit for you.", 5.0],
		[23, "<- This is KEY. The thing you must find.", 5.0],
		[22, "Egress means exit.", 5.0],
		[23, "??? NO KEY ???", 5.0],
		[22, "This room is a Hall of Egress.", 5.0],
		[23, "Yo! Where the keys at?", 5.0],
	],
	"level1": [
		[9, "Hey! Thanks for doing this quest with me.", 6.0],
		[14, "You can move around with WSAD and dash with Space.", 5.0],
		[18, "Also... Try the attacks I gave you with BOTH mouse buttons.", 5.0],
		[16, "Or some buttons on the controller.", 5.0],
		[14, "I don't know which. You can figure it out.", 5.0],
	],
	"level2": [
		[8, "Now this is going to get way more interesting.", 5.0],
		[9, "Your wand looks dead. It's way darker and not as powerful.", 5.0],
		[18, "But worry not, my fearless caretaker. We shan't wail.", 5.0],
		[8, "For many more matchsticks are hidden on our trail!", 5.0],
	],
	"level3": [
		[12, "Wow, you're really taking a beating. But it'll be worth it.", 5.0],
		[9, "The treasure at the end is enormous, trust me.", 5.0],
		[14, "It so huge we don't even have to split evenly.", 5.0],
		[8, "I could take like 80 percent and you'd still be satisfied.", 5.0],
	],
	"level4": [
		[9, "If you ever think about giving up, just don't.", 5.0],
		[18, "You only lose when you give up, not when you fail.", 5.0],
		[16, "I'm not trying to motivate you. I just really need that treasure.", 5.0],
		[18, "Also my wife keeps talking about renovating the kitchen.", 5.0],
		[8, "So remember! A lot of cats depend on you. ", 5.0],
	],
	"level5": [
		[2, "Are we there yet?", 4.0],
		[14, "I think we're about halfway.", 5.0],
		[13, "WAIT A MINUTE! You could talk this entire time?", 5.0],
		[12, "Why didn't you laugh at any of my jokes?", 5.0],
		[3, "...", 4.0],
		[7, "Oh, I get it. The silent treatment again.", 5.0],
	],
	"level6": [
		[18, "If I must be honest, I never expected us to get this far.", 5.0],
		[10, "But I guess we make a great team, don't you think?", 5.0],
		[2, "If I must be honest, you're not really helping.", 5.0],
		[17, "EXCUSE ME?! You wouldn't even be here if not for me!", 5.0],
		[3, "Exactly.", 5.0],
	],
	"level7": [
		[19, "Are you mad at me? I always put us in some kind of trouble.", 5.0],
		[2, "Nah. It's just another of our crazy adventures.", 5.0],
		[3, "Except this time I might actually die.", 5.0],
		[11, "No way. That last trip to the vet was way scarier.", 5.0],
		[16, "He said I should go on a diet, because I'm fat.", 5.0],
		[15, "And not eating snacks is way worse than dying.", 5.0],
	],
	"level8": [
		[14, "Alright it must be close. I can smell it.", 5.0],
		[18, "I mean, I KNOW it's close. No need to worry. Like, at all.", 5.0],
		[3, "I wasn't worried. At least until now.", 5.0],
		[2, "But how do you know about the treasure anyway?", 5.0],
		[3, "I... Um... Watched that one short last night.", 5.0],
		[5, "Seriously? We might as well go home already.", 5.0],
		[18, "No! Wait! The video was very thorough.", 5.0],
	],
	"the-end": [
		[8, "Yay! We've found it!", 5.0],
		[4, "...", 3.0],
		[20, ":>", 3.0],
		[3, "You're telling me I did all of this for a cake?", 5.0],
		[18, "Well... Yea, but...", 4.0],
		[5, "...", 3.0],
		[20, "Now you can say it was 'a piece of cake'.", 5.0],
		[6, "Heh...", 3.0],
	],
	"wand-drop": [
		[8, "There it is! You can switch your wands with the mouse wheel.", 5.0],
		[9, "Nice wand! The closer the color the more damage it deals, I think.", 5.0],
		[18, "Hm. Maybe you can attack one primary color at a time. I'm not sure.", 5.0],
		[8, "Yipee! Another wand. So bright and sparkly!", 5.0],
		[19, "That's too many matchsticks. I don't have any strategies for that.", 5.0],
		[13, "Another one? Who even leaves them in a place like that?", 5.0],
	],
	"cape-drop": [
		[8, "Oh! A cape! It will protect you from attacks of similar color.", 5.0],
		[9, "Another cape! You can swap your capes with Q and E keys.", 5.0],
		[15, "This one looks weird. You can wear it as an apron, I guess.", 5.0],
		[18, "Nice. This one is brighter than yours, so it'll work better.", 5.0],
		[9, "That one looks like a bib. I don't even know if it's a cape.", 5.0],
		[8, "Wowow! Another gown. LET'S GOOOOOOO!", 5.0],
	],
	"life-drop": [
		[19, "Did you just absorb somebody's heart? At least you look better.", 5.0],
		[12, "Stealing life force from innocent hearts again? Perfectly normal.", 5.0],
		[11, "Hey? Maybe next time you could try, not doing that? It's weird.", 5.0],
		[17, "So you just eat that huge heart and immediately feel better, huh?", 5.0],
		[14, "OH! They're made from gingerbread! Why didn't you tell me!", 5.0],
		[18, "I'll never get used to this. I'm wounded for life.", 5.0],
	],
	"cat-collison": [
		[16, "Don't push me!", 3.0],
		[15, "Stop poking me!", 3.0],
		[16, "I told you to stop pushing me.", 4.0],
		[17, "STOP POKING ME!", 3.0],
		[13, "Are you okay? Because you cannot even walk straight.", 5.0],
		[17, "Stooooop!", 3.0],
		[16, "Do you really have to keep running into me?", 4.0],
		[17, "STOP PUSHING ME, pleeeeeeease.", 4.0],
		[12, "AHH! You've scared me.", 4.0],
		[19, "How can you not see me? I'M HERE!", 4.0],
		[14, "Okay. I'm gonna pretend that you're just trying to pet me.", 5.0],
	],
	"cast-collison": [
		[16, "Don't step into your cast, silly. It will kill you.", 6.0],
		[15, "You're doing it again. Don't touch your cast.", 5.0],
		[13, "Are you even listening to me? Cast. Bad. It. Kill.", 5.0],
		[13, "Why didn't you dodge it? Are you stupid?", 5.0],
		[11, "Alright. One more time. Your CAST KILLS you.", 5.0],
		[16, "Why do you keep stepping into it? Are you blind?", 5.0],
		[18, "Now I comprehend. Thine dodging skills art trash.", 5.0],
		[10, "Skill issue.", 4.0],
		[18, "Another skill issue.", 4.0],
		[10, "HAHAHA! Try harder next time.", 4.0],
		[9, "SKILL. ISSUE.", 4.0],
		[11, "Okay you can stop now. It's gotten boring.", 5.0],
		[12, "Seriously. You can stop hurting yourself.", 5.0],
		[12, "Don't do that please.", 4.0],
	],

}
var in_dialog := false
var current_key := ""
var current_id := 0
var is_skipped := false

func _input(event):
	if in_dialog and event.is_action_pressed("skip"):
		spawn_dialog(current_key)

func spawn_dialog(key: String, single=false) -> void:

	current_key = key
	if current_id < len(data[key]):
		mess.show()
		mess.blur.show()
		mess.skip_label.show()
		if key == "level1":
			mess.tutorial_view.show()
		in_dialog = true
		Engine.time_scale = 0.0
		mess.set_mess(data[key][current_id][0], data[key][current_id][1])
		if single:
			data[key].remove_at(current_id)
			current_id = len(data[key])
		else:
			current_id += 1
	else:
		mess.hide()
		mess.blur.hide()
		mess.skip_label.hide()
		if key == "level1":
			mess.tutorial_view.hide()
		in_dialog = false
		Engine.time_scale = 1.0
		current_id = 0

func spawn(key: String) -> void:
	mess.show()
	mess.blur.show()
	if key == "pause":
		mess.tutorial_view.show()

	for message in data[key]:
		mess.set_mess(message[0], message[1])
		await get_tree().create_timer(message[2]).timeout

	mess.hide()
	mess.blur.hide()
	if key == "pause":
		mess.tutorial_view.hide()

func spawn_single(key: String) -> void:
	if len(data[key]) == 0 or mess.visible:
		return
	mess.show()
	var message = data[key][0]
	mess.set_mess(message[0], message[1])
	await get_tree().create_timer(message[2]).timeout
	data[key].remove_at(0)
	mess.hide()
