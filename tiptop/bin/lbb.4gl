database ds

main
define
	l_name,l_name2 char(13),
	l_i,l_k SMALLINT,
	l_out char(13),
	l_desc char(36)

	let l_i=NUM_ARGS()
	if l_i=0 then exit program end if

	let l_name=arg_val(1)
	if l_name = ' ' then exit program end if

	LET l_out=FGL_GETENV('LOGNAME')
	let l_out=l_out clipped,'.lbl'
	START REPORT lbl_rep TO l_out

	for l_k=1 to l_i
		let l_name=arg_val(l_k)
		select zz02 into l_desc
			from zz_file
			where zz01=l_name
		let l_name=UPSHIFT(l_name)
		OUTPUT TO REPORT lbl_rep(l_desc,l_name)
	end for
	FINISH REPORT lbl_rep
end main

REPORT lbl_rep(p_desc,p_name)
DEFINE
	p_desc char(32),
	p_name char(07),
	l_on,l_off char(03),
	l_hon,l_hoff char(03),
	l_von,l_voff char(03)

	OUTPUT  TOP MARGIN 1
			LEFT MARGIN 0
			BOTTOM MARGIN 0
			PAGE LENGTH 66
	FORMAT
		on every row
			let l_von[1]=ascii(27)
			let l_von[2]=ascii(116)
			let l_von[3]=ascii(49)
			let l_on[1]=ascii(27)
			let l_on[2]=ascii(120)
			let l_on[3]=ascii(02)
			let l_off[1]=ascii(27)
			let l_off[2]=ascii(120)
			let l_off[3]=ascii(01)
			let l_voff[1]=ascii(27)
			let l_voff[2]=ascii(116)
			let l_voff[3]=ascii(48)
			let l_hon[1]=ascii(27)
			let l_hon[2]=ascii(121)
			let l_hon[3]=ascii(02)
			let l_hoff[1]=ascii(27)
			let l_hoff[2]=ascii(121)
			let l_hoff[3]=ascii(01)
			print l_on,l_von,l_hon;
			print p_name[2,3],p_desc,p_name,l_voff
			print p_name,'  ',p_name;
			print l_off,l_hoff
end report
