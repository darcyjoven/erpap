database ds
main
 define n1,i,j smallint
 declare a cursor for select zq201 from zq2_file
 foreach a into n1
    if n1 < 500 then continue foreach end if
    let i = n1 / 256
    let j = n1 - i * 256
    display n1,i,j
    update a set (zq202,zq203) = (i,j) where zq201 = n1
 end foreach
end main
