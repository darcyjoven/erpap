import libjson
function main()
    define j,l string
    let j = "{\"json\":\"value\",\"array\":[{\"key1\":\"val1\"},{\"key2\":\"val2\"}]}"
    call json2xml(j) returning l
    display "\n",l
end function
