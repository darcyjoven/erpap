database ds
define prog,prog1,prog2,out   char(40)
define b     char(80)
define x     char(80)
define bi,i,j,k smallint
main
whenever error continue
let prog1=ARG_VAL(1)
let prog2=ARG_VAL(2)
for k = 1 to 2
 drop table bb
 create table bb(bb char(100))
 if k=1 then let prog=prog1 end if
 if k=2 then let prog=prog2 end if
 load from prog insert into bb
 display prog clipped,' load status:',status,' ',sqlca.sqlerrd[3],' rows loaded'
 if sqlca.sqlcode then exit program end if
 let out='x',k USING '&'
 start report rep to out
 declare c cursor for select * from bb
 foreach c into b
    let bi=0
    if b[1,5]='ATTRI' or b[1,5]='TABLE' then exit foreach end if
    for i = 1 to 80
       if b[i,i]='[' then let bi=i end if
       if b[i,i]=']' then
          if bi != 0 then
             let x=b[bi,i]
             output to report rep(x)
          end if
          let bi=0
       end if
    end for
 end foreach
 finish report rep
end for
end main

report rep(x)
define x char(80)
output TOP MARGIN 0 LEFT MARGIN 0 BOTTOM MARGIN 0 PAGE LENGTH 10
format
  on every row print x clipped
end report
