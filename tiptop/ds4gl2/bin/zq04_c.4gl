# This program will read c_xxx.sql, insert column name into zq_file
# To run this program: $ q4 axm
#                      $ q4 aap

database ds
 define stmt char(80)
 define q1 char(10),q4 char(40)
 define f1 char(10),f4 char(40)
main
 whenever error continue
 drop table program
#改暫存檔
 create table program(statement char(80))
 load from 'x' insert into program
 display 'load status:',status,' ',sqlca.sqlerrd[3],' rows loaded'
 if sqlca.sqlcode then exit program end if
 declare a cursor for select * from program
 let q1=null
 let f1=null
 foreach a into stmt
   if status then exit foreach end if
   if stmt is null then continue foreach end if
# 處理表頭
   if stmt[1,8] = '檔案編號' or stmt[1,8] = '檔案代號' then
      case when stmt[10]<>' ' and stmt[10]<>':' let f1=stmt[10,20]
           when stmt[11]<>' ' let f1=stmt[11,21]
           when stmt[12]<>' ' let f1=stmt[12,22]
      end case
   end if
   if stmt[1,8] = '檔案名稱' then
      case when stmt[10]<>' ' and stmt[10]<>':' let f4=stmt[10,70]
           when stmt[11]<>' ' let f4=stmt[11,70]
           when stmt[12]<>' ' let f4=stmt[12,70]
      end case
      if f1 is not null then
         insert into zt_file(zt01,zt02,zt04,zt05, zt06, zt07)
                      values(f1,  f4,  'TOP',TODAY,USER,'T')
         if status=-239 then
            update zt_file set zt02=f4 where zt01=f1
         end if
      end if
   end if
 # 欄位定義列
 # if stmt[1,1] != ' ' and stmt[31,31] = '{' then
   if stmt[1,1] != ' '  then
      let q1=stmt[1,8]
      let q4=stmt[32,71]
 #    insert into zq_file (zq01,zq02,zq03,zq04)
 #                 values (q1,  0,   0,   q4)
      display q1,q4,status
 #    if sqlca.sqlcode=-239 then
 #       update zq_file set zq04=q4 where zq01=q1 and zq02='0' and zq03='0'
 #    end if
   end if
 # 欄位其他說明列
 # if stmt[1,1] = ' ' and stmt[31,31] = '{' then
   if stmt[1,1] = ' ' and stmt[31,31]='{'  then
 #    let q1=stmt[1,8]
      let q4=stmt[32,71]
 #    insert into zq_file (zq01,zq02,zq03,zq04)
 #                 values (q1,  0,   0,   q4)
      display q1,q4,status
 #    if sqlca.sqlcode=-239 then
 #       update zq_file set zq04=q4 where zq01=q1 and zq02='0' and zq03='0'
 #    end if
   end if
 end foreach
end main
