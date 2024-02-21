/obj/item/ammo_box/magazine/internal/cylinder
	name = "revolver cylinder"
	ammo_type = /obj/item/ammo_casing/a357
	caliber = ".357"
	max_ammo = 7
	instant_load = TRUE

/obj/item/ammo_box/magazine/internal/cylinder/get_round(keep = FALSE, counter_clockwise = FALSE)
	rotate(counter_clockwise)

	var/b = stored_ammo[1]
	if(!keep)
		stored_ammo[1] = null

	return b

/obj/item/ammo_box/magazine/internal/cylinder/proc/rotate(counter_clockwise = FALSE)
	var/b
	if(!counter_clockwise)
		b = stored_ammo[1]
		stored_ammo.Cut(1,2)
		stored_ammo.Insert(0, b)
	else
		b = stored_ammo[max_ammo]
		stored_ammo.Cut(max_ammo,max_ammo+1)
		stored_ammo.Insert(max_ammo, b)

/obj/item/ammo_box/magazine/internal/cylinder/proc/spin()
	for(var/i in 1 to rand(0, max_ammo*2))
		rotate()

/obj/item/ammo_box/magazine/internal/cylinder/ammo_list(drop_list = FALSE)
	var/list/L = list()
	for(var/i=1 to stored_ammo.len)
		var/obj/item/ammo_casing/bullet = stored_ammo[i]
		if(bullet)
			L.Add(bullet)
			if(drop_list)//We have to maintain the list size, to emulate a cylinder
				stored_ammo[i] = null
		else
			L.Add(null)
	return L

/obj/item/ammo_box/magazine/internal/cylinder/give_round(obj/item/ammo_casing/R, replace_spent = 0)
	if(!R || (caliber && R.caliber != caliber) || (!caliber && R.type != ammo_type))
		return FALSE

	for(var/i in 1 to stored_ammo.len)
		var/obj/item/ammo_casing/bullet = stored_ammo[i]
		if(!bullet || !bullet.BB) // found a spent ammo
			stored_ammo[i] = R
			R.forceMove(src)

			if(bullet)
				bullet.forceMove(drop_location())
			return TRUE

	return FALSE
