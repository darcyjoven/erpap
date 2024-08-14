database ds
 define buf  char(130)
 define stmt array[6000] of char(82)
 define prog char(20)
 define maxi smallint
 define i,j    smallint
 define S    char(1)
 define b2  char(10)
 define old array[100] of char(11)
 define g_zf01 char(20)
 define g_zf02 smallint
 define g_zf03 char(20)
main
 whenever error continue
 drop table program
 for j = 1 to 100 let old[j] = '#' end for
 create table program(statement char(100))
 let prog=ARG_VAL(1)
 if prog[1,1]='s' then let prog=prog[2,20] end if
 let g_zf01 = prog
 load from 'x' insert into program
 display prog clipped,' load status:',status,' ',sqlca.sqlerrd[3],' rows loaded'
 if sqlca.sqlcode then exit program end if
 let buf = "delete from zf_file where zf01 matches '",prog,"*'"
 prepare ps_p from buf execute ps_p
 declare a cursor for select * from program
 let maxi = 1
 foreach a into stmt[maxi]
   if status then exit foreach end if
   if stmt[maxi] is null then continue foreach end if
   let maxi = maxi + 1
 end foreach
 let maxi = maxi - 1
 display maxi,' rows into array'
 call aa()
end main

function aa()
  define ii smallint
  for ii = 1 to maxi
    let buf=stmt[ii]
    call bb()
  end for
end function

function bb()
define b     char(10)
define i3,i4,i5 smallint
 if buf[1,8] = 'FUNCTION' then
     for j = 9 to 100
       if buf[j,j] = '(' then exit for end if
     end for
     let j=j-1
     let g_zf01 = prog[1,3],buf[9,j]
 end if
 let i = 0
 while true
  if i > 74 then return end if
  let i = i+1
  if buf[i,i] = '#' then return end if
  if buf[i,i] = ' ' then return end if
  if buf[i,i] matches '[()-+*/{}="]' then continue while end if
  let i3=i+3
  if buf[i,i3] = 'CALL' then
     let i4=i+4 let i5=i+5
     if buf[i4,i4] >= 'A' AND buf[i4,i4] <= 'Z'
                            then let i=i4+5 continue while end if
     if buf[i4,i5] = 'cl' then let i=i4+5 continue while end if
     if buf[i4,i5] = 'sh' then let i=i4+5 continue while end if
     for j = i3 to 100
       if buf[j,j] = '(' then exit for end if
     end for
     let j=j-1
     select max(zf02)+1 into g_zf02 from zf_file where zf01 = g_zf01
     if g_zf02 is null then let g_zf02 = 1 end if
     if buf[i4,i5] != 'q_' and buf[i4,i5] != 's_' then
        let g_zf03=prog[1,3],buf[i4,j]
     end if
     let i = j
     if g_zf01=g_zf03        then continue while end if
     if g_zf01[9,13]='menu1' then continue while end if
     if g_zf03[9,13]='menu1' then continue while end if
     display g_zf01,g_zf02,' ',g_zf03
     insert into zf_file values(g_zf01,g_zf02,g_zf03)
  end if
 end while
end function
