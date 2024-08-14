database ds

main
  options help file "helpfile"
  call helpfile()
end main
function helpfile()
  menu ""
  command "H. Help" help 995
  call showhelp(1)
  command "Esc. Exit"
  exit menu
  end menu
end function
