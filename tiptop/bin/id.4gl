main
define
	ids char(10),
	c2 char(02),
	id2 char(11),
	id3 char(11),
	chkalp char(26),
	chkid smallint,
	l_i smallint

	#the order sequence is important
	let chkalp='ABCDEFGHJKLMNPQRSTUVXYWZIO'
	let id2='19876543211'

	while true
		prompt 'your ID:' for ids
		if int_flag then exit while end if
		if length(ids)<10 then
			error 'Error: length of ID must equal to 10'
			continue while
		end if
		let ids[1]=upshift(ids[1])
		if ids[1] not matches '[ABCDEFGHJKLMNPQRSTUVWXYZ]' then
			error 'Error: The fist byte must be Character and exclusive IO'
			continue while
		end if
		for l_i=2 to 10
			if ids[l_i] not matches '[0-9]' then
				error 'Error: 2-10 byte must be numeric'
				continue while
			end if
		end for

		for l_i=1 to 26
			if ids[1]=chkalp[l_i] then exit for end if
		end for
		let c2=l_i+9 using '&&'
		let ids[1]=c2[2]		#將字母用第二位取代成10位數字
		let id3=c2[1],ids		#將第一位和十位加成11位

		let chkid=0
		for l_i=1 to 11
			let chkid=chkid+id3[l_i]*id2[l_i]
		end for
		
		display 'checksum=',chkid
		if chkid mod 10 then
			display 'error input'
		end if
	end while
end main
