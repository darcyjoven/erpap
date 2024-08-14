############################################################################### 
#
#       Copyright 1989-2000 Four J's Development Tools Ltd.
#                          All Rights Reserved.
#
# This product and related documentation is protected by copyright and
# distributed under licenses restricting its use, copying, distribution
# and decompilation.  No part of this product or related documentation
# may be reproduced in any form by any means without prior written
# authorization of Four J's Development Tools and its licensors, if any.
#
############################################################################### 

###############################################################################
## <SOURCE
## Company  = "Four J's Development Tools"
## Project  = "Open Database Interface"
## Type     = "Program"
## Name     = "odisamp1.4gl"
## Comment  = "ODI sample program 1."
## Version  = "1.00.1a"
## Language = "4GL"
## />
## <UPDATE Version="1.00.1a" Date="1999/10/03" Author="SF">
##    <DESCRIPTION> First version.</DESCRIPTION>
## </UPDATE>
## <DESCRIPTION> <![CDATA[
##
##    1. Setup the odisamp.prf file.
##    2. Set FGLPROFILE to "odisamp.prf".
##    3. Compile this program.
##    4. Execute this program.
##
## ]]></DESCRIPTION>
## </SOURCE>
###############################################################################

main

    call test_connect("ds_init","Connection to Oracle ds_init ..."    )
    call test_connect("ds","Connection to Oracle ds ..."    )
    call test_connect("ds1","Connection to Oracle ds1 ..."    )
    call test_connect("dstest","Connection to Informix dstest ..."    )
    call test_connect("dbtest2","Connection to SQL Server ...")
    call test_connect("dbtest3","Connection to IBM DB2 ..."   )

end main


function test_connect( dbname, conmsg )

    define dbname char(30)
    define conmsg char(35)
    define rowmsg char(66)

    whenever error continue

    database dbname

    if status=0 then
       display conmsg, " successful!"
    else
       display conmsg, " failed! (status=", status using "-------", ")"
    end if

    whenever error stop

end function
