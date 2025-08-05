extends Node3D
class_name NumberPopupComponent


var num : int = 1222

var num_list = []


func _ready() -> void:
	for numb in $Numbers.get_children():
		numb.hide()
		
	formDigit()


func formDigit():
	
	
	# Edge Cases
	if num == 0:
		$Numbers/DigitOnes.frame = 0
		$Numbers/DigitOnes.show()
		return
	
	
	while num != 0:
		
		var digit = num % 10
		num_list.append(digit)
		num /= 10
	

	if num_list.size() > 0:
		$Numbers/DigitOnes.frame = num_list[0]
		$Numbers/DigitOnes.show()
	else:
		return
	
	if num_list.size() > 1:
		$Numbers/DigitTwos.frame = num_list[1]
		$Numbers/DigitTwos.show()
	else:
		return
	
	if num_list.size() > 2:
		$Numbers/DigitThrees.frame = num_list[2]
		$Numbers/DigitThrees.show()
	else:
		return
	
	if num_list.size() > 3:
		$Numbers/DigitFours.frame = num_list[3]
		$Numbers/DigitFours.show()
	else:
		return
	

func delete():
	queue_free()
