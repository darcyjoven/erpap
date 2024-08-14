database ds
main
  define lastday date
  define l_user  char(10)
  define w       smallint
  let lastday = TODAY - 1 let w = weekday(lastday)
  if w = 0 then
     let lastday = TODAY - 1
  end if
  select count(*) into w FROM zl_file
    where zl01 = lastday and zl03 = USER
  if w = 0 then
     select zx02 into l_user from zx_file where zx01 = USER
     display ''
     display l_user CLIPPED,'君: 請補您昨日的 plog '
  end if
end main
