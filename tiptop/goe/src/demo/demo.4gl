import libsuna
function main()
    define s integer

    call sum(2,4) returning s
    display sfmt("\n2+3=%1",s)
end function
