-- FOO COMMENT


FUNCTION mod2(param)
  DEFINE param String
  DEFINE cmd Integer
  DEFINE cmdstr String
  DEFINE ret,m String
  CALL set_mod(2) RETURNING m
  MENU "hallo"
    COMMAND "mod3"
      LET cmd=1
      LET cmdstr="mod2"
      LET ret=mod3(param)
      DISPLAY "ret is",ret
    COMMAND "exit"
      LET cmd=2
      LET cmdstr="exit"
      EXIT MENU
  END MENU
  RETURN cmdstr,cmd
END FUNCTION
