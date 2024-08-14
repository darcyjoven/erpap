database ds

main
 define l_sql char(88),
        l_wc  char(88),
		l_s array[80] of char(79),
		l_colname char(10),
		l_from_dbs,l_to_dbs char(20),
		l_tab char(10),
		l_chr char(1),
		i,j,k,max_i smallint
 let l_from_dbs=arg_val(1)
 let l_to_dbs  =arg_val(2)
 let l_tab=arg_val(3)
 let l_wc =arg_val(4)
 if l_tab = ' ' then call unlolo_usage() exit program end if
#if l_tab = ' ' then
#	prompt 'Table name:' for l_tab
# end if
 close database
 database l_from_dbs
 if status then call unlolo_usage() exit program end if
 declare unlolo_c cursor for
	 select colname from systables,syscolumns
			where tabname=l_tab
			  and systables.tabid=syscolumns.tabid
			order by 1
 let l_s[1]='close database; database ',l_from_dbs,';'
 let l_sql = '#'
 let l_s[2]= 'select'
 let i = 3
 foreach unlolo_c into l_colname
   if status then display "foreach error:",status exit foreach end if
   if l_sql = '#' and i = 3
      then let l_sql=' ',l_colname
      else let l_sql=l_sql clipped,',',l_colname
   end if
   if length(l_sql) > 68
	  then let l_s[i]=l_sql let i=i+1
	       let l_sql=''
   end if
 end foreach
 if length(l_sql) > 0
	  then let l_s[i]=l_sql let i=i+1
	       let l_sql=''
 end if
 let max_i = i - 1
 let l_s[i]=' from ',l_tab clipped,' ',l_wc clipped
 if l_wc is not null and l_wc != ' '
    then let l_s[i]=l_s[i] clipped,' where ',l_wc clipped
 end if
 let i=i+1
 let l_s[i]=' into temp x;'
 let i=i+1
 let l_s[i]='close database; database ',l_to_dbs,';'
 let i=i+1
 let l_s[i]='insert into ',l_tab,' ('
 for k = 3 to max_i
    let i=i+1
    let l_s[i]=l_s[k]
 end for
 let i=i+1
 let l_s[i]=') select * from x;'
 for k = 1 to i
    display l_s[k] clipped
 end for
end main

function unlolo_usage()
 	display "syntax error!"
 	display "  usage : unlolo from_dbs   to_dbs     tab_name"
 	display "  Ex.1  : unlolo ds_old     ds         ima_file"
 	display "  Ex.2  : unlolo ds@server2 ds@server3 ima_file"
end function
