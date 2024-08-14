database ds
 define buf,buf1,buf2  char(80)
 define prog char(20)
 define i,j    smallint
main
 whenever error continue
 drop table program
 create table program(statement char(100))
 let prog=ARG_VAL(1)
 load from 'x' insert into program
 display prog clipped,' load status:',status,' ',sqlca.sqlerrd[3],' rows loaded'
 if sqlca.sqlcode then exit program end if
 declare a cursor for select * from program
 foreach a into buf
   if status then exit foreach end if
   if buf is null then continue foreach end if
   if buf[1,10] = ' ' then continue foreach end if
   if buf[31,31]='{' then
      let buf1 = buf[1,10]
      let buf2 = buf[32,71]
      select zzz01 from zzz_file where zzz01 = buf2
      if status = 0 then continue foreach end if
      insert into zzz_file (zzz01,zzz02,zzz04) values(buf2,null,buf1)
      display STATUS,'/',buf2 clipped
      continue foreach
   end if
   if buf[1,8]='檔案編號' or buf[1,8]='檔案代號'
      then let buf1=buf[10,20] continue foreach
   end if
   if buf[1,8]='檔案名稱' then
      let buf2 = buf[10,40]
      insert into zzz_file (zzz01,zzz02,zzz04) values(buf2,null,buf1)
      continue foreach
   end if
 end foreach
end main
