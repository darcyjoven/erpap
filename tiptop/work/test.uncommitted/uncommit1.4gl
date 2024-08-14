database ds

main
    DEFINE l_tmp02   VARCHAR(10)
    DEFINE l_tmp03   VARCHAR(10)
  begin work
  insert into test values('test9')
  run "fglrun uncommit2"
    DECLARE cur_2 SCROLL CURSOR FOR
     select * from test where c1='test9'
    OPEN cur_2
    FETCH cur_2 INTO l_tmp02
    DISPLAY 'B:',l_tmp02
  rollback work
    DECLARE cur_3 SCROLL CURSOR FOR
     select * from test where c1='test9'
    OPEN cur_3
    FETCH cur_3 INTO l_tmp03
    DISPLAY 'C:',l_tmp03
end main
