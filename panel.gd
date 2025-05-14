extends Panel

func close():
	if $".".visible:
		await get_tree().create_timer(5).timeout 
		$".".visible=false

func camclose():
	$".".visible=false
