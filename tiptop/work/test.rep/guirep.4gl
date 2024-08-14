database ds

main
define g_i     smallint,
       g_char  char(1)

  START REPORT gui_rep TO 'test.gui2'

  LET g_char='A'

  FOR g_i = 1 TO 50
   IF g_i = 11 THEN LET g_char='B' END IF
   IF g_i = 21 THEN LET g_char='C' END IF
   OUTPUT TO REPORT gui_rep(g_i,g_char)
  END FOR

  FINISH REPORT gui_rep

end main

REPORT gui_rep(g_i,g_char)
define g_i     smallint,
       g_char  char(1)

  OUTPUT TOP MARGIN 0
         LEFT MARGIN 0
         BOTTOM MARGIN 1
         PAGE LENGTH 12
  ORDER BY g_char,g_i
  FORMAT
   PAGE HEADER
   print 'Header :',g_char
 
  before group of g_char
   skip to top of page

  on every row
   print 'g_char, g_i:',g_char,'/',g_i

  after group of g_char
    message 'after group'

END REPORT
