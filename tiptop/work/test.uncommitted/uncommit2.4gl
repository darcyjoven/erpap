database ds
main
    DEFINE l_tmp01   VARCHAR(10)
    DECLARE cur_1 SCROLL CURSOR FOR
     select * from test where c1='test9'
    OPEN cur_1
    FETCH cur_1 INTO l_tmp01
    DISPLAY 'A:',l_tmp01
end main
