# 1 "fgldeb.4g"
# 1 "<built-in>"
# 1 "<command line>"
# 1 "fgldeb.4g"
------------------------------------------------------------------------------
-- $Id: fgldeb.4g,v 1.6 2004/10/21 13:16:19 leo Exp $
-- main module for "fgldeb" - the Debugger Frontend for "fglrun -d "
------------------------------------------------------------------------------
SCHEMA ds

# 1 "version.h" 1
# 8 "fgldeb.4g" 2
-- #include "macros.h"

DEFINE g_version_str String
DEFINE g_version_major Integer
DEFINE g_version_minor Integer
DEFINE g_version_patch Integer

-- this funky macro attaches a history array to a field
-- in input mode, use this macro in an INPUT statement
-- ( but dont forget to call "history_insert" in accept case
-- and you are shure that you want to keep this string )
# 34 "fgldeb.4g"
--this macro is inserted in various dialogs to be able to invoke
--the standard stepping actions of the debugger
# 51 "fgldeb.4g"
-- #define CURR_WIN(abc) CURRENT WINDOW IS abc CALL set_current_dialog(#abc) DISPLAY "CALL currwin ",#abc," from line ",51
# 63 "fgldeb.4g"
--Types--
--source code array for the current source
DEFINE src_arr DYNAMIC ARRAY OF RECORD
  marker String, { line marker image }
  lnum Integer,
  line String,
  isBreak Integer
END RECORD

--answer lines from the debugger
DEFINE deb_arr DYNAMIC ARRAY OF String
--the number of lines from the debugger
DEFINE deb_arr_len INTEGER

--window hierarchy
DEFINE win_arr DYNAMIC ARRAY OF String

--breakpoint structure
# 92 "fgldeb.4g"
--current breakpoint list
DEFINE break_arr DYNAMIC ARRAY OF RECORD
  enabled String, breakNum Integer, breakType String, funcName String, lineNumber Integer, modName String, hits Integer, line String, isFunction Integer
END RECORD


--current stack list
DEFINE stk_arr DYNAMIC ARRAY OF RECORD
  marker String ,
  level Integer,
  funcName String,
  modName String,
  lineNumber Integer
END RECORD

--history arrays
DEFINE fdb_hist_arr DYNAMIC ARRAY OF STRING
DEFINE inspectvar_hist_arr DYNAMIC ARRAY OF STRING
DEFINE search_hist_arr DYNAMIC ARRAY OF STRING
DEFINE func_hist_arr DYNAMIC ARRAY OF STRING

--array of variables to watch
DEFINE watch_arr DYNAMIC ARRAY OF STRING

--keeps track of the finish function returns (stepout command)
DEFINE finish_arr DYNAMIC ARRAY OF RECORD
   funcName String,
   caller String
END RECORD

--all directories containing sources
--DEFINE dir_arr DYNAMIC ARRAY OF STRING

--all module names of the debugee
DEFINE mod_arr DYNAMIC ARRAY OF STRING

DEFINE global_var_arr,local_var_arr DYNAMIC ARRAY OF RECORD
    varname String,
    value String,
    modname String
END RECORD

--auto variables, for each active stack frame there is an array of variables
DEFINE auto_arr DYNAMIC ARRAY OF RECORD
  frame_name STRING ,
  var_arr DYNAMIC ARRAY OF STRING,
  pos_arr DYNAMIC ARRAY OF INTEGER
END RECORD

--globals
--THE command channel to the real debugger
DEFINE g_channel base.Channel
--number of command sent to real debugger
DEFINE g_cmdcount Integer
--the file name for the file currently displayed
DEFINE g_file_displayed String
--the "long" version (complete path)
DEFINE g_file_displayed_long String
--the currently active file inside this debugger frontend
DEFINE g_file_current String
--the file where frame 0 is currently active(top of stack)
DEFINE g_file_0 String
--the "long" version (complete path)
DEFINE g_file_current_long String
define g_src_path String

DEFINE g_state STRING -- 3 states: "initial", "running" or "stopped"



DEFINE g_active, g_source_changed ,g_in_display Integer
--the current displayed line in the current displayed (g_file_displayed)
DEFINE g_line Integer
--linenumber showed in the statusbar
DEFINE g_status_line_no Integer
DEFINE g_source_lines Integer --number of lines in the file
--the source line number of frame 0 (top of stack)
DEFINE g_line_0 Integer
DEFINE g_verbose Integer
DEFINE g_frame_no Integer -- current stackframe
DEFINE g_frame_name String -- current stackframe function name
DEFINE g_view_function String -- current viewed function
--the line number and filename for the main function
DEFINE g_main_lineNumber INTEGER
DEFINE g_main_modName STRING
-- last module for breakpoint restore info
DEFINE g_lastmod STRING

--- searchdialog
DEFINE srch_search String
DEFINE srch_wholeword,srch_matchcase,srch_useMATCHES Integer
DEFINE srch_updown String

-- if this variable is set, get_deb_out() does not interpret
-- a line number info in the output (and changes automaticaly the displayed file)
DEFINE g_deb_out_ignore_linenumber Integer
-- the filename and line parsed in get_deb_out
DEFINE g_deb_out_filename String
DEFINE g_deb_out_line Integer
DEFINE g_deb_out_active,g_deb_out_repeat INTEGER
--do we continue the step command if the program ended ?
DEFINE g_continue INTEGER
--do we reload the whole program if the debugger backend died
DEFINE g_reload INTEGER

--flag to prevent being recursive in the function
DEFINE g_read_in_source_active Integer
--is set to 1 if the read in of a source file didnt work
DEFINE g_read_in_source_error Integer
--
-- variables for raising the debugger in gdc, to switch back and forth
DEFINE g_debugger_raised Integer
-- (debuggee is the program which is debugged)
DEFINE g_debuggee_widget String
DEFINE g_debuggee_raised Integer

DEFINE g_inspectvariable_name , g_inspectvariable_value String
DEFINE g_fdbcommand , g_debout String

DEFINE g_program,g_args STRING

--how many times was get_function_names called ?
DEFINE g_function_names_called STRING
--array containing ALL function names
DEFINE g_func_arr DYNAMIC ARRAY OF STRING

--remembers the last command sent to the debugger
DEFINE g_last_deb_cmd STRING

--function name for adding breakpoints
DEFINE g_funcName STRING

--do we run gdb in the pipe ?
DEFINE g_isgdb INTEGER

--do we need to check for a function return ?
DEFINE g_check_finish INTEGER
DEFINE g_finish_result STRING

--flag to test the end state
DEFINE g_quit INTEGER

--string displayed in the help window
DEFINE g_helpstr STRING
--cursor position in the help window
DEFINE g_helpcursor INTEGER

--Front End Name
DEFINE g_fename STRING






--THE main proc
MAIN
  --state variable for the quasi nonmodal dialogs:
  --normal state is "fgldeb", dialog states are
  --"inspectvariable" "fdbcommand" "local_variables" "global_variables"
  --go out with "exitapp"
  DEFINE da_state String
  DEFINE breakNum Integer
  OPTIONS INPUT WRAP
  OPTIONS HELP FILE "fgldeb.img"
  DEFER INTERRUPT
  --initialize globals
  LET g_version_str="1.1.1"
  LET g_version_major=1
  LET g_version_minor=1
  LET g_version_patch=1
  LET g_channel=base.channel.create()
  LET g_file_displayed_long=" "
  LET g_in_display=0
  LET g_line=0
  LET g_line_0=0
  LET g_frame_no=0
  LET g_source_changed=0
  LET g_source_lines=0
  LET g_lastmod=" "
  --load UI stuff
  CALL ui.Interface.loadActionDefaults("fgldeb")
  CALL ui.Interface.loadStyles("fgldeb")
  --CALL ui.Interface.loadToolBar("fgldeb")
  --open the one and only debugger window
  CLOSE WINDOW screen CALL remove_dialog_name("screen")
  --OPEN WINDOW fgldeb WITH FORM "fgldeb" ATTRIBUTES(STYLE="basic")
  IF NOT windowExist("fgldeb") THEN OPEN WINDOW fgldeb WITH FORM "fgldeb" ELSE CURRENT WINDOW IS fgldeb END IF CALL set_current_dialog("fgldeb")
  CALL set_debug_logo()
  CALL set_g_state("initial")
  --open form form1 from "fgldeb"
  --display form form1
  CALL parse_args() RETURNING g_program,g_args
  IF length(g_program)==0 THEN
    DISPLAY "usage: fglrun fgldeb <progname>"
    EXIT PROGRAM
  END IF
  CALL open_program()
  IF g_active=0 THEN
    EXIT PROGRAM
  END IF
  --CALL deb_write("break main")
  --now disable the currframe
  LET g_frame_no=0
  CALL goto_src_line(g_line_0)
  --CALL do_run()
  --CALL update_breakpoints()
  --CALL update_stack()
  -- main debugger loop
  LET da_state="initial"
  WHILE g_active AND da_state<>"exitapp"
    IF g_source_changed THEN
      CALL update_breakpoints()
    END IF
    LET g_source_changed=0
    CURRENT WINDOW IS fgldeb CALL set_current_dialog("fgldeb")
    --CALL set_count(g_source_lines)
    CALL set_count(src_arr.getLength())
    --this interaction statement shows the current source file,
    --allows to set breakpoints and to invoke step actions and
    --various dialogs
    DISPLAY ARRAY src_arr TO src.*
      HELP 1
      ATTRIBUTES(UNBUFFERED,KEEP CURRENT ROW)
      BEFORE DISPLAY
        --checking the dialog state machine
        LET g_in_display=1
        CALL goto_src_line(g_line)
        -- call a small hackish proc to update the marker correctly
        IF g_file_displayed=g_file_0 AND g_line_0<>0 THEN
          IF src_arr[g_line_0].marker IS NOT NULL AND
           (da_state="fdbcommand" OR da_state="inspectvariable" ) THEN
            CALL pokeMarker()
          END IF
        END IF
        -- check if we left the display array because of a step command in
        -- a modal dialog , in this case we re-enter here the dialog to
        -- refresh the array and exit the dialog immediately
        -- DISPLAY "da_state in BEFORE DISPLAY array fgldeb is ",da_state
      BEFORE ROW
        CASE da_state
          WHEN "inspectvariable"
            EXIT DISPLAY
          WHEN "fdbcommand"
            EXIT DISPLAY
          WHEN "local_variables"
            EXIT DISPLAY
          WHEN "global_variables"
            EXIT DISPLAY
        END CASE
      --comment this in case of trouble with the autovars
      --{
      --BEFORE ROW
      -- LET g_line=arr_curr()
      -- CALL update_stack()
      -- CALL update_autovars()
      --}
      ON ACTION close
        LET da_state=do_quit(da_state)
        EXIT DISPLAY
      ON KEY(interrupt)
        LET da_state=do_quit(da_state)
        EXIT DISPLAY
      ON ACTION quit
        LET da_state=do_quit(da_state)
        EXIT DISPLAY
      ON ACTION run
        CALL do_run()
        IF g_source_changed THEN EXIT DISPLAY END IF
      ON ACTION rerun
        LET g_line=arr_curr()
        CALL do_rerun()
        IF g_source_changed THEN EXIT DISPLAY END IF
      ON ACTION stepinto
        LET g_line=arr_curr()
        CALL do_stepinto()
        IF g_source_changed THEN EXIT DISPLAY END IF
      ON ACTION stepover
        LET g_line=arr_curr()
        CALL do_stepover()
        IF g_source_changed THEN EXIT DISPLAY END IF
      ON ACTION stepout
        LET g_line=arr_curr()
        CALL do_stepout()
        IF g_source_changed THEN EXIT DISPLAY END IF
      ON ACTION run2cursor
        LET g_line=arr_curr()
        call do_run2cursor()
        IF g_source_changed THEN EXIT DISPLAY END IF
      ON ACTION viewbreak
        LET g_line=arr_curr()
        CALL show_breakpoints()
        IF g_source_changed THEN EXIT DISPLAY END IF
      ON ACTION viewstack
        LET g_line=arr_curr()
        CALL update_stack()
        IF show_stack()=1 THEN
          EXIT DISPLAY
        END IF
      ON ACTION viewmodules
        LET g_line=arr_curr()
        CALL show_modules()
        IF g_source_changed THEN EXIT DISPLAY END IF
      ON ACTION viewfunctions
        LET g_line=arr_curr()
        LET g_view_function=show_functions(1)
        IF g_source_changed THEN EXIT DISPLAY END IF
      ON ACTION togglebreak
        LET g_line=arr_curr()
        CALL do_toggle_break()
        IF g_source_changed THEN EXIT DISPLAY END IF
      ON ACTION togglebreakdisable
        CALL do_toggle_breakdisable()
        IF g_source_changed THEN EXIT DISPLAY END IF
      ON ACTION addbreak
        CALL do_add_break() RETURNING breakNum
        IF g_source_changed THEN EXIT DISPLAY END IF
      ON ACTION find
        CALL do_find("src","source code")
      ON ACTION findnext
        CALL do_findnext("src")
      ON ACTION accept
        LET g_line=arr_curr()
        CALL do_toggle_break()
      ON ACTION about
        CALL do_about()
      -- call pseudo non modal dialogs
      ON ACTION fdbcommand
        LET g_line=arr_curr()
        --IF g_source_changed THEN EXIT DISPLAY END IF
        LET da_state="fdbcommand"
        EXIT DISPLAY
      ON ACTION viewlocals
        LET da_state="local_variables"
        EXIT DISPLAY
      ON ACTION viewglobals
        LET da_state="global_variables"
        EXIT DISPLAY
      ON ACTION viewwatchlist
        LET da_state= do_view_watches_from("fgldeb")
        IF da_state<>"fgldeb" THEN EXIT DISPLAY END IF
      ON ACTION inspectvariable
        LET g_line=arr_curr()
        LET da_state=do_grab_variables_from("fgldeb")
        EXIT DISPLAY
      ON ACTION save_state
        CALL save_state()
      ON ACTION restore_state
        CALL restore_state()
      ON ACTION togglehideauto
        CALL toggle_hide_group("auto_group","togglehideauto","&Auto")
      ON ACTION togglehidewatch
        CALL toggle_hide_group("watch_group","togglehidewatch","&Watch")
      --ON ACTION help
        --CALL help_dialog(MAIN_HELP)
    END DISPLAY
    LET g_in_display=0
    CASE da_state
      WHEN "inspectvariable"
        LET da_state=inspectvariable(1)
      WHEN "fdbcommand"
        LET da_state=do_fdb_command()
      WHEN "local_variables"
        LET da_state=showvariables("local")
      WHEN "global_variables"
        LET da_state=showvariables("global")
    END CASE
  END WHILE
  CALL g_channel.close()
END MAIN

--opens up a pipe to "fglrun -d" or gdb and
--intializes breakpoints and the main line number
FUNCTION open_program()
  DEFINE program String
  DEFINE fglrun String
  DEFINE l_locale STRING
  DEFINE l_codeset STRING
  DEFINE l_i INTEGER
  DEFINE l_user LIKE zx_file.zx01
  DEFINE l_lang LIKE zx_file.zx06
  DEFINE l_ch base.Channel
  DEFINE l_cmd STRING
  DEFINE l_dvm_ver STRING
  DEFINE l_buf STRING
  DEFINE l_str STRING

  DATABASE ds
  LET l_user = FGL_GETENV("LOGNAME")
  SELECT zx06 INTO l_lang FROM zx_file WHERE zx01 = l_user
  CLOSE DATABASE

  LET l_locale = FGL_GETENV("LANG")
  LET l_i = l_locale.getIndexOf(".", 1)
  IF l_i != 0 THEN
     LET l_locale = l_locale.subString(1, l_i-1)
  END IF
  LET l_locale = l_locale.toUpperCase()

  LET l_ch = base.Channel.create()
  CALL l_ch.openPipe("locale charmap | cut -d. -f1 | tr -d \"'\"'\"'", "r")
  WHILE l_ch.read(l_codeset)
  END WHILE
  CALL l_ch.close()
  LET l_codeset = l_codeset.toUpperCase()

  LET l_ch = base.Channel.create()
  CALL l_ch.openPipe("fpi", "r")
  WHILE l_ch.read(l_buf)
      LET l_str = l_buf
      LET l_buf = l_buf.toUpperCase()
      IF ( l_i := l_buf.getIndexOf("VERSION", 1) ) THEN
         LET l_dvm_ver = l_str.subString(l_i + 7, l_str.getLength())
         LET l_dvm_ver = l_dvm_ver.trim()
         EXIT WHILE
      END IF
  END WHILE
  CALL l_ch.close()

  IF l_locale = "ZH_TW" AND l_codeset = "BIG5" AND l_lang = '2' THEN
     IF l_dvm_ver >= "2.02.06" THEN
        LET l_cmd = " -t gbk"
     ELSE
        LET l_cmd = " -t gb2312"
     END IF
  END IF

  IF l_locale = "ZH_CN" AND ( l_codeset = "GB2312" OR l_codeset = "GBK" OR l_codeset = "GB18030" ) AND l_lang = '0' THEN
     LET l_cmd = " -t big5"
  END IF

  IF NOT g_isgdb THEN
    IF fgl_getenv("FGLRUN") IS NOT NULL THEN
      LET fglrun = fgl_getenv("FGLRUN")
    ELSE
      LET fglrun = "fglrun"
    END IF
    IF l_cmd IS NULL THEN
       LET program = fglrun || " -d " || g_program || " 2>&1"
    ELSE
       LET program = fglrun || l_cmd || " -d " || g_program || " 2>&1"
    END IF
  ELSE
    LET program = "gdb " || g_program
  END IF
  CALL g_channel.openpipe(program,"u")
  DISPLAY "program is: \"",program,"\", status is:",status
  IF status < 0 THEN
    DISPLAY "can't open :",program
    EXIT PROGRAM
  END IF
  CALL g_channel.setDelimiter("")
  LET g_active=1
  IF NOT g_isgdb THEN
    CALL deb_write("set prompt (fglgui)")
  ELSE
    CALL deb_write("set prompt (fglgui)\\n")
  END IF
  CALL deb_write("set annotate 1")
  CALL get_deb_out()
  CALL restore_state()
  CALL update_watch()
  LET g_frame_no=1
  CALL deb_write("info line main")
  CALL get_deb_out()
  LET g_main_lineNumber=g_line_0
  LET g_main_modName =g_file_0
END FUNCTION


--this function is called in case the
--underlying fglrun -d died for some reason...
--nobody is expected to be bugfree...
FUNCTION reopen_program()
  CALL g_channel.close()
  CALL save_state()
  LET g_channel = base.channel.create()
  LET g_reload=0
  CALL open_program()
  CALL set_g_state("initial")
  DISPLAY "reopened :" , g_program
END FUNCTION

--wrapper function around grab_variables() to check
--the location from where it was called
--if coming from the main loop, then inspectvariable()
--is called, if already inside inspectvariable, then
--just stay in the dialog and update the values
FUNCTION do_grab_variables_from(where)
  DEFINE where STRING
  DEFINE input_arr DYNAMIC ARRAY OF STRING
  DEFINE varnames,da_state STRING
  DEFINE i,len INTEGER
  CALL grab_variables(input_arr)
  LET len=input_arr.getLength()
  FOR i=1 TO len
    LET varnames=varnames.append(input_arr[i])
    LET varnames=varnames.append(" ")
  END FOR
  IF varnames IS NOT NULL THEN
    --cut the last space
    LET varnames=varnames.subString(1,varnames.getLength()-1)
  END IF
  LET da_state="inspectvariable"
  IF where="fgldeb" THEN
    --IF varnames IS NOT NULL THEN
    -- LET g_inspectvariable_name=varnames
    -- LET da_state=inspectvariable(1)
    --
    --ELSE
    -- LET da_state=inspectvariable(0)
    --END IF
    LET g_inspectvariable_name=varnames
  ELSE
    LET g_inspectvariable_name=varnames
  END IF
  RETURN da_state
END FUNCTION

--tiny function to force an update of the main display array
--for showing correctly the current line marker
FUNCTION pokeMarker()
  DEFINE tabNode om.DomNode
  DEFINE idx,pageSize,offset Integer
  LET tabNode= _deb_omId2Node(_deb_getOmIdTable("src"))
  LET pageSize=tabNode.getAttribute("pageSize")
  LET offset=tabNode.getAttribute("offset")
  --FOR i=offset TO offset+pageSize
  -- DISPLAY src_arr[i+1].marker TO src[i-offset+1].b
  --END FOR
  LET idx=tabNode.getAttribute("currentRow")-tabNode.getAttribute("offset")+1
  DISPLAY src_arr[g_line_0].marker TO src[idx].b
  --CALL ui.interface.refresh()
END FUNCTION

--finds the breakpoint number of the main() function
FUNCTION find_break_main()
  DEFINE i,len INTEGER
  LET len=break_arr.getLength()
  FOR i=1 TO len
    IF g_main_lineNumber=break_arr[i].lineNumber AND
        g_main_modName =break_arr[i].modName THEN
       RETURN break_arr[i].breakNum
    END IF
  END FOR
  RETURN -1
END FUNCTION

--removes the breakpoint of the main() function
FUNCTION remove_break_main()
  DEFINE bmain,idx INTEGER
  LET bmain=find_break_main()
  IF bmain<>-1 THEN
    LET idx=get_breakpoint_index(bmain)
    IF break_arr[idx].breakType="del" THEN
      CALL deb_write(sfmt("delete %1",bmain))
      CALL get_deb_out()
    END IF
    CALL update_breakpoints()
  END IF
END FUNCTION

--when invoking a step command like "next" or "step" then
--check if the program already runs
--if not,check for a breakpoint in main, set if necessary and
--invoke the "run" command
FUNCTION check_initial_step_state()
  DEFINE bmain INTEGER
  IF g_state="initial" OR
     (g_state="stopped" AND g_isgdb) THEN
    -- search if we already have a breakpoint at the main line
    LET bmain=find_break_main()
    IF bmain=-1 THEN
      CALL deb_write(sfmt("tbreak %1:%2",g_main_modName,g_main_lineNumber))
      CALL get_deb_out()
      CALL update_breakpoints()
    END IF
    CALL set_g_state("running")
    CALL deb_write(sfmt("run %1",g_args))
    CALL get_deb_out()
    RETURN 1
  ELSE
    RETURN 0
  END IF
END FUNCTION

--sends either "run" or "continue" depending on the
--current state
FUNCTION do_run()
  DEFINE cmd String
  CALL raise_debuggee("run")
  CASE g_state
    WHEN "running"
      LET cmd="continue"
    WHEN "stopped"
      LET cmd=sfmt("run %1",g_args)
    WHEN "initial"
      LET cmd=sfmt("run %1",g_args)
      DISPLAY cmd
    OTHERWISE
      CALL deb_error ("unknown state :"||g_state)
  END CASE
  CALL set_g_state("running")
  CALL do_debugger_step_cmd(cmd)
  CALL raise_debugger("run")
END FUNCTION

--one of the easy things, let the program start from the beginning
FUNCTION do_rerun()
  --DEFINE cmd String
  CALL raise_debuggee("rerun")
  CALL do_debugger_step_cmd(sfmt("run %1",g_args))
  CALL raise_debugger("rerun")
END FUNCTION

--checks first if the fgldeb is in initial state
--and performs the step command.
FUNCTION try_stepcmd(name,cmd)
  DEFINE name STRING
  DEFINE cmd STRING
  CALL raise_debuggee(name)
LABEL again:
  IF NOT check_initial_step_state() THEN
    IF name="stepout" THEN
      CALL do_stepout_int()
    ELSE
      CALL do_debugger_step_cmd(cmd)
    END IF
  ELSE
    IF name="stepout" THEN
      CALL do_stepout_int()
    ELSE
      CALL do_debugger_step_cmd(cmd)
    END IF
    CALL remove_break_main()
  END IF
  --if the programs stops during the excution, apply
  --the command again
  IF g_state="initial" AND g_continue THEN
    GOTO :again
  END IF
  CALL raise_debugger(name)
END FUNCTION

--instructs "fglrun -d" to run to the current source code position
--when other breakpoints are hit before reaching the wanted source
--line, the command is ignored
--(the internal breakpoint will be deleted by "fglrun -d")
FUNCTION do_run2cursor()
  CALL try_stepcmd("run2cursor",sfmt("until %1",g_line))
END FUNCTION

--causes stepping into a function
FUNCTION do_stepinto()
  CALL try_stepcmd("stepinto","s")
END FUNCTION

--causes stepping over the next line
FUNCTION do_stepover()
  CALL try_stepcmd("stepover","n")
END FUNCTION

--causes stepping out of the current function
--and displaying a messagebox with the function result
FUNCTION do_stepout()
  CALL try_stepcmd("stepout","dummy")
END FUNCTION

--real work of doing step out
FUNCTION do_stepout_int()
  DEFINE i,found,len Integer
  DEFINE caller,funcName String
  LET found=0
  call update_stack()
  --remember the caller function if there is one
  LET caller=""
  LET funcName=stk_arr[1].funcName
  IF stk_arr.getLength()>1 THEN
    LET caller=stk_arr[2].funcName
  END IF
  LET len=finish_arr.getLength()
  --go through finish_arr and search if we can already find the current function
  --or the caller function
  FOR i=1 TO len
    IF funcName.getLength()>0 AND finish_arr[i].funcName=funcName THEN
      --DISPLAY "found finish_entry ",i," for funcName:",funcName,"set caller:",caller,"previous was :",finish_arr[i].caller
      LET finish_arr[i].caller=caller
      LET found=1
      EXIT FOR
    ELSE IF caller.getLength()>0 AND finish_arr[i].caller=caller THEN
      --DISPLAY "found finish_entry ",i," for caller:",caller,"set funcName:",funcName,"previous was :",finish_arr[i].funcName
      LET finish_arr[i].funcName=funcName
      LET found=1
      EXIT FOR
    END IF
    END IF
  END FOR
  --add the top function and his caller to finish_arr
  IF found=0 AND caller.getLength()>0 AND funcName.getLength()>0 THEN
    LET i=len+1
    LET finish_arr[i].funcName = funcName
    LET finish_arr[i].caller = caller
    --DISPLAY "add  finish_entry ",i," for caller:",caller,"set funcName:",funcName
  END IF
  CALL do_debugger_step_cmd("finish")
END FUNCTION

--parses the command line arguments of this program
--and returns the program name and arguments for the debuggee
FUNCTION parse_args()
  DEFINE i Integer
  DEFINE debugger_args,arg_count Integer
  DEFINE arg_arr DYNAMIC ARRAY OF String
  DEFINE program,args String
  DEFINE arg String
  LET g_verbose=0
  LET debugger_args=0
  LET arg_count=0
  LET program=""
  --DISPLAY "num_args are:",num_args()
  FOR i=1 TO num_args()
    IF arg_val(i) = "--" THEN
      LET debugger_args=1
    ELSE IF arg_val(i) = "\\-\\-" THEN
      IF debugger_args=0 THEN
        LET arg_count=arg_count+1
        LET arg_arr[arg_count]="--"
      END IF
    ELSE
      IF debugger_args=0 THEN
        LET arg_count=arg_count+1
        --DISPLAY "arg_count is ",arg_count
        LET arg_arr[arg_count]=arg_val(i)
      ELSE
        IF arg_val(i)="-v" OR arg_val(i)="--verbose" THEN
          LET g_verbose=1
        ELSE IF arg_val(i)="-g" OR arg_val(i)="--gdb" THEN
          LET g_isgdb=1
        END IF
        END IF
      END IF
    END IF
    END IF
  END FOR
  FOR i=1 TO arg_count
    IF i=1 THEN
      LET program=arg_arr[i]
    ELSE
      LET arg="'", arg_arr[i], "'"
      LET args=args.append(arg)
      IF i<>arg_count THEN
        LET args=args.append(" ")
      END IF
    END IF
  END FOR
  DISPLAY "program is \"",program,"\", args are \"",args,"\""
  RETURN program,args
END FUNCTION

--sets the source code line in the source code array
FUNCTION set_src_arr_value(arr,i,str,updatedisplay)
  DEFINE arr DYNAMIC ARRAY OF STRING
  DEFINE i INTEGER
  DEFINE updatedisplay INTEGER
  DEFINE str STRING
  IF updatedisplay THEN
    LET src_arr[i].marker=""
    LET src_arr[i].lnum=i
    LET src_arr[i].line=str
    LET src_arr[i].isBreak=0
  ELSE
    LET arr[i]=str
  END IF
  --uncomment the next line to see each line read in
  --DISPLAY "line ",i,":",str
END FUNCTION

--reads in a source code file and saves the content in the
--given array "arr"
FUNCTION read_in_source (srcName,arr,updatedisplay)
  DEFINE srcName STRING --filename of the source code
  DEFINE arr DYNAMIC ARRAY OF STRING --array to place the source lines in
  DEFINE updatedisplay INTEGER --is this the interactive source file ?
  DEFINE errstr,linestr,fullname String
  DEFINE ch_src base.Channel
  DEFINE i,found Integer
  IF g_read_in_source_active THEN
    RETURN
  END IF
  LET g_read_in_source_error=0
  LET g_read_in_source_active = 1
  LET fullname=srcName
  IF NOT fileExists(fullname) THEN
    LET found=0
    --inspect the directories we already know
{
-- LET len=dis_arr.getLength()
-- FOR i=1 TO len
-- --dirarr contains always slashes at the end
-- LET fullname=dir_arr[i]||srcName
-- IF fileExists(fullname) THEN
-- let found=1
-- EXIT FOR
-- END IF
-- END FOR
}
  ELSE
    LET found=1
  END IF
  IF NOT found THEN
    LET fullname=get_full_module_name(srcName)
    IF fullname.getLength()=0 THEN
      LET found=0
    ELSE IF NOT fileExists(fullname) THEN
      --LET fullname=input_full_path(srcName)
      LET found=0
    ELSE
      LET found=1
    END IF
    END IF
  END IF
  IF NOT found THEN
    IF updatedisplay THEN
      CALL fgl_winMessage("Debugger", "Cannot find the module\""||srcName||"\",please check FGLSOURCEPATH !", "info")
    END IF
    LET g_read_in_source_error=1
    GOTO :endfunc
  END IF
  -- clear the array
  IF updatedisplay THEN
    CALL src_arr.clear()
  ELSE
    CALL arr.clear()
  END IF
  LET ch_src=base.channel.create()
  --DISPLAY "read_in_source :",srcName
  CALL ch_src.openFile(fullname,"r")
  IF status < 0 THEN
    LET errstr= "can't read : "||srcName
    ERROR errstr
    LET g_read_in_source_error=1
    GOTO :endfunc
  END IF
  LET i=1
  --CALL ch_src.setDelimiter("")
  WHILE (linestr:=ch_src.readline()) IS NOT NULL
    {
    --look for "\\\n" in the line and deconcat...
    WHILE linestr.getIndexOf("\n",1)>0 AND
          linestr.getCharAt(linestr.getIndexOf("\n",1)-1)="\\"
      LET idx=linestr.getIndexOf("\n",1)
      LET l=linestr.subString(1,idx-2)
      LET linestr=linestr.subString(idx+1,linestr.getLength())
      CALL set_src_arr_value(arr,i,l,updatedisplay )
      LET i=i+1
    END WHILE
    }
    CALL set_src_arr_value(arr,i,linestr,updatedisplay)
    LET i=i+1
  END WHILE
  CALL ch_src.close()
  IF updatedisplay THEN
    LET g_source_lines=i-1
    LET g_file_displayed_long=srcName
    LET g_file_displayed=get_short_filename(srcName)
    CALL fgl_settitle("Debugger - "||srcName)
    CALL set_TableColumn_text("src","line",srcName)
    MESSAGE "loaded ",srcName
    LET g_source_changed=1
  END IF
LABEL endfunc:
    LET g_read_in_source_active=0
END FUNCTION

FUNCTION get_breakpoint_enabled(breakNum)
  DEFINE breakNum, idx INTEGER
  LET idx=get_breakpoint_index(breakNum)
  IF idx=0 THEN
    RETURN "notfound"
  END IF
  RETURN break_arr[idx].enabled
END FUNCTION

--gives back the index in the breakpoint array
--if not found, returns 0
FUNCTION get_breakpoint_index(breakNum)
  DEFINE breakNum,i,len INTEGER
  LET len=break_arr.getLength()
  FOR i=1 TO len
    IF break_arr[i].breakNum=breakNum THEN
      RETURN i
    END IF
  END FOR
  RETURN 0
END FUNCTION

FUNCTION get_marker (line,breakNum)
  DEFINE line,breakNum Integer
  DEFINE marker,enabled String
  LET marker="debug"
  IF breakNum==-1 THEN
    LET breakNum=search_breakpoint(line)
  END IF
  IF breakNum>0 THEN
    LET enabled=get_breakpoint_enabled(breakNum)
    CASE enabled
      WHEN "y"
        LET marker=marker || "_break"
      WHEN "n"
        LET marker=marker || "_break_disabled"
    END CASE
  END IF
  IF line=g_line_0 AND g_file_displayed=g_file_0 THEN
    LET marker=marker || "_marker"
  ELSE IF g_frame_no>1 AND g_frame_no<=stk_arr.getLength() THEN
    IF line=stk_arr[g_frame_no].lineNumber AND
        g_file_displayed=stk_arr[g_frame_no].modName THEN
      LET marker=marker || "_frame"
    END IF
  END IF
  END IF
  IF marker="debug" THEN
    --neither a current or breakpoint line
    LET marker=""
  END IF
  RETURN marker
END FUNCTION

FUNCTION search_breakpoint(line)
  DEFINE line integer
  DEFINE i,len Integer
  LET len=break_arr.getLength()
  FOR i=1 TO len
    IF break_arr[i].modName=g_file_displayed AND break_arr[i].lineNumber=line THEN
      RETURN break_arr[i].breakNum
    END IF
  END FOR
  RETURN 0
END FUNCTION

--deletes the current line marker (top of stack)
FUNCTION clear_current_marker()
  DEFINE tmp_line Integer
  IF g_file_0=g_file_displayed AND g_line_0>0 AND g_line_0<src_arr.getLength() THEN
    LET tmp_line=g_line_0
    LET g_line_0=-1
    --reset the current previous line marker
    LET g_line=tmp_line
    LET src_arr[tmp_line].marker=get_marker(tmp_line,-1)
    LET g_line_0=tmp_line
  END IF
END FUNCTION

--deletes the frame marker for the current selected stackframe
FUNCTION clear_frame_marker()
  DEFINE tmp_frame_no,lineNumber Integer
  -- DEFINE tmp_line Integer
  --IF g_frame_no=1 THEN
    --CALL clear_current_marker()
  IF g_frame_no>1 AND g_frame_no<=stk_arr.getLength() THEN
    LET lineNumber=stk_arr[g_frame_no].lineNumber
    IF stk_arr[g_frame_no].modname=g_file_displayed AND
       lineNumber>0 AND lineNumber<=src_arr.getLength() THEN
      LET tmp_frame_no=g_frame_no
      LET g_frame_no=0
      LET src_arr[lineNumber].marker=get_marker(lineNumber,-1)
      LET g_frame_no=tmp_frame_no
    END IF
  END IF
END FUNCTION

FUNCTION clear_all_markers()
  CALL clear_frame_marker()
  CALL clear_current_marker()
END FUNCTION

FUNCTION goto_src_line (src_line)
  DEFINE src_line Integer

  --DISPLAY sfmt("goto_src_line:%1,g_line:%2,g_line_0:%3,g_frame_no:%4,g_file_0:%5",src_line,g_line,g_line_0,g_frame_no,g_file_0)
  IF g_file_displayed<>g_file_current THEN
    --DISPLAY "exit goto_src_line"
    RETURN
  END IF
  CALL clear_current_marker()
  IF g_in_display THEN
    --DISPLAY "fgl_set_arr_curr ",src_line
    CALL fgl_set_arr_curr(src_line)
  ELSE
    --DISPLAY "fgl_dialog_setcurrline ",src_line
    CALL fgl_dialog_setcurrline (0, src_line)
  END IF

  LET g_line=src_line
  IF g_frame_no=1 AND g_file_0=g_file_displayed THEN
    LET g_line_0=g_line
  END IF
  --IF g_frame_no > 1 THEN
    --LET src_arr[g_line].marker=get_marker(g_line,-1)
    --DISPLAY "marker is ",src_arr[g_line].marker
  --END IF
  IF g_file_0=g_file_displayed THEN
    LET src_arr[g_line_0].marker=get_marker(g_line_0,-1)
    --DISPLAY "set marker in line ",g_line_0," to ",src_arr[g_line_0].marker
  END IF
  LET g_status_line_no=g_line
  CALL update_status(0)
END FUNCTION

FUNCTION yesno(m)
  DEFINE m STRING
  DEFINE im,ret STRING
  --LET im="exclamation"
  LET im="question"
  MENU "Message" ATTRIBUTE(STYLE="dialog",COMMENT=m,IMAGE=im)
    COMMAND "Yes"
      LET ret="yes"
      --EXIT MENU
    COMMAND "No"
      LET ret="no"
      --EXIT MENU
    {
    COMMAND KEY(interrupt)
      LET ret="no"
      EXIT MENU
    }
  END MENU
  RETURN ret
END FUNCTION

--function to get the answer of the debugger
--as a response to a g_channel.write("foo")
--each answer line from the debugger is
--stored in the global "deb_arr"
--furthermore the linenumber g_line

FUNCTION get_deb_out()
  DEFINE i,num INTEGER
  -- check if we are about going recursively into this function
  IF g_deb_out_active=1 THEN
    LET g_deb_out_repeat=g_deb_out_repeat+1
    --DISPLAY "g_deb_out_repeat is ",g_deb_out_repeat
  ELSE
    LET g_deb_out_active=1
    CALL get_deb_out_int()
    LET deb_arr_len=deb_arr.getLength()
    LET g_deb_out_active=0
    LET num=g_deb_out_repeat-1
    LET g_deb_out_repeat=0
    FOR i=1 TO num
      DISPLAY "!!REPEAT g_deb_out, round", i
      CALL get_deb_out()
    END FOR
  END IF
END FUNCTION


FUNCTION get_deb_out_int()
  DEFINE linestr,filename,linenumstr String
  DEFINE result,i,first,second,ask_continue INTEGER
  DEFINE idx,locateidx,len,fatalerror,check_exit,k INTEGER
  DEFINE lastline,err String
  DEFINE bsrc_arr DYNAMIC ARRAY OF STRING --TQC-640040
  --DEFINE check_finish,check_finish2 ,finish_len Integer
--Label start:
  LET ask_continue=0
  LET check_exit=0
  CALL deb_arr.clear()
  LET idx=0
  --read in the lines from the channel
  WHILE 1
    LET result=g_channel.read(linestr)
    IF result= 0 THEN
       CALL set_g_state("stopped")
       DISPLAY "debugger backend terminated"
       IF g_quit=0 THEN
         LET err="Debugger backend terminated ,"
         FOR i=1 TO deb_arr.getLength()
           LET err=err.append(sfmt("\n%1",deb_arr[i]))
           IF i>10 THEN
             EXIT FOR
           END IF
         END FOR
           LET err=err.append("\nContinue?")
         --CALL fgl_winmessage("Fatal Error",err,"stop")
         IF fgl_winquestion("Fatal Error",err,"no","yes|no","question",0)="yes" THEN
           LET g_reload=1
         END IF
         LET g_quit=1
       END IF
       LET g_active=0
       EXIT WHILE
    END IF
    LET len=linestr.getLength()
    IF len> 64000 THEN
      DISPLAY "cut debugger line to 64k"
      LET linestr=linestr.subString(1,64000)
    END IF
    --uncomment the next line to get ALL debugger output
    --IF idx<20 THEN
    -- DISPLAY ">>deb>>",idx,":",linestr
    --ELSE IF idx=20 THEN
    -- DISPLAY ">>deb .... >>"
    --END IF
    --END IF
    IF linestr="(fglgui)" THEN
      EXIT WHILE
    END IF
    LET idx=idx+1
    LET deb_arr[idx]=linestr
    --IF len=0 THEN
    -- CONTINUE WHILE
    --END IF
  END WHILE
  LET deb_arr_len=deb_arr.getLength()
  LET k=1
  LET locateidx=0
  --checks the last two answer lines for key strings
  FOR i=deb_arr_len TO 1 STEP -1
    IF k>2 THEN
      EXIT FOR
    END IF
    LET linestr=deb_arr[i]
    LET len=linestr.getLength()
    IF len>2 AND linestr.getCharAt(1)==ascii(26) AND linestr.getCharAt(2)==ascii(26) THEN
      LET locateidx=idx
      LET first=linestr.getIndexOf (":", 3)
      IF first<5 THEN
        --we got a drive letter followed by a colon
        LET first=linestr.getIndexOf (":", first+1)
      END IF
      LET second=linestr.getIndexOf (":", first+1)
      LET filename=linestr.subString(3,first-1)
      LET linenumstr=linestr.subString(first+1,second-1)
      IF NOT isNumber(linenumstr) THEN
        CALL deb_error(sfmt("could not parse linenumber \"%1\" in where line string \"%2\" in get_deb_out_int",linenumstr,linestr))
      END IF
      LET g_deb_out_filename=filename
      LET g_deb_out_line=linenumstr
      --DISPLAY "filename is \"",filename,"\" linenumstr is :",linenumstr
      IF filename<>g_file_displayed_long AND NOT g_deb_out_ignore_linenumber THEN
        LET g_source_changed=0
      -- TQC-640040 begin
        --CALL read_in_source(filename,src_arr,1)
        CALL read_in_source(filename,bsrc_arr,1)
      -- TQC-640040 end
        IF g_source_changed THEN
          LET g_file_current_long=filename
          LET g_file_current=get_short_filename(g_file_current_long)
          IF g_frame_no=1 THEN
            LET g_file_0=g_file_current
          END IF
          IF g_file_0=g_file_current AND g_line_0>0 AND
             g_line_0<src_arr.getLength() THEN
            --mark the current line
            LET src_arr[g_line_0].marker=get_marker(g_line_0,-1)
          END IF
        END IF
      END IF
      IF NOT g_deb_out_ignore_linenumber THEN
        --DISPLAY "get_deb_out:goto_src_line ",g_deb_out_line
        CALL goto_src_line(g_deb_out_line)
      END IF
    END IF
    IF sent_execution_cmd() OR get_last_keyword()="where" THEN
      IF len>0 AND linestr.getIndexOf("Program exited",1)=1 THEN
        LET check_exit=1
      ELSE IF len>0 AND linestr.getIndexOf("The program is not being run.",1)=1 THEN
        CALL set_g_state("stopped")
        LET ask_continue=1
      ELSE IF len>0 AND linestr.getIndexOf("Value returned is ",1)=1 THEN
        LET g_check_finish=1
          --DISPLAY "set g_check_finish to 1"
        LET g_finish_result=linestr.subString(linestr.getIndexOf("Value returned is ",1)+length("Value returned is "),len)
      ELSE IF len>0 AND linestr.getIndexOf("Fatal error",1)=1 THEN
        LET fatalerror=1
      END IF
      END IF
      END IF
      END IF
    END IF
  END FOR
  IF locateidx=deb_arr_len AND deb_arr_len>1 THEN
    LET lastline=deb_arr[deb_arr_len-1]
  ELSE IF deb_arr_len>0 THEN
    LET lastline=deb_arr[deb_arr_len]
  ELSE
    LET lastline=NULL
  END IF
  END IF
  IF fatalerror=1 THEN
    CALL update_status(0)
    CALL fgl_winmessage(deb_arr[1],deb_arr[2],"stop")
  END IF
  IF check_exit AND lastline IS NOT NULL THEN
    IF lastline.getIndexOf("Program exited",1)=1 THEN
      DISPLAY "program exit"
      CALL set_g_state("stopped")
      CALL fgl_winmessage("Debugger",lastline,"stop")
    END IF
  END IF
  IF get_last_keyword()="where" THEN
    --fglrun -d answers nothing
    IF lastline IS NULL THEN
      CALL set_g_state("stopped")
    --gdb answers no stack
    ELSE IF lastline="No stack." THEN
      CALL set_g_state("stopped")
    END IF
    END IF
  END IF
  IF g_state="stopped" THEN
    CALL finish_arr.clear()
  END IF
  IF g_active=1 AND ask_continue=1 THEN
    IF yesno("The program is not being run. Continue debugging ?")="yes" THEN
      CALL set_g_state("initial")
      LET g_continue=1
    END IF
  END IF
END FUNCTION

--lenghty function to parse the "info breakpoints" command
--and to update the current viewed modules images correctly

FUNCTION update_breakpoints()
  DEFINE len,len2,i,j,startWhat,bcount,lineNumber,breakNum Integer
  DEFINE startDisp,endDisp,startEnb,startEnb2,endEnb,tabPos Integer
  DEFINE startFunc,endFunc,startMod,endMod,startLine,endNum Integer
  DEFINE breakType,enabled,breakNumStr,modName,funcName String
  DEFINE head,what,linestr,numStr,inStr,atStr,bpfield String
  DEFINE startHit,endHit,break_len integer
  DEFINE hitNumStr STRING
  --keeps the breakpoint linenumbers of the current module
  DEFINE tmp_arr DYNAMIC ARRAY OF Integer
  DEFINE break_arr_old DYNAMIC ARRAY OF RECORD
    enabled String, breakNum Integer, breakType String, funcName String, lineNumber Integer, modName String, hits Integer, line String, isFunction Integer
  END RECORD
  DEFINE tmp_count Integer

  --get ALL breakpoints from the runner
  CALL deb_write("info breakpoints")
  CALL get_deb_out()
  LET tmp_count=0
  LET len=deb_arr.getLength()
  IF len=0 THEN
    IF g_verbose THEN
      DISPLAY "got no breakpoints"
    END IF
    RETURN
  END IF
  --completely update the source array
  LET len2=src_arr.getLength()
  FOR i=1 TO len2
    LET src_arr[i].isBreak=0
    LET src_arr[i].marker=""
  END FOR
  --set the current line Number
  IF g_state="running" AND
    g_file_displayed=g_file_0 AND g_line_0>0 AND g_line_0<len2 THEN
    LET src_arr[g_line_0].marker="debug_marker"
  END IF
  --set the current select frame (if ANY)
  IF g_frame_no>1 AND g_frame_no<=stk_arr.getLength() THEN
    LET lineNumber=stk_arr[g_frame_no].lineNumber
    IF g_file_displayed=stk_arr[g_frame_no].modName AND
       lineNumber>1 AND lineNumber<len2 THEN
      LET src_arr[lineNumber].marker="debug_frame"
    END IF
  END IF
  LET head=deb_arr[1]
  --getting the columns for the elements
  LET startDisp=head.getIndexOf ("Disp", 3)
  LET startEnb=head.getIndexOf ("Enb", 3)
  --save this position for worst case
  LET startEnb2=startEnb
  LET startWhat=head.getIndexOf ("What", 3)
  LET bcount=0
  --copy the old breakpoint array
  LET break_len=break_arr.getLength()
  FOR i=1 TO break_len
    LET break_arr_old[i].*=break_arr[i].*
  END FOR
  CALL break_arr.clear()
  FOR i=2 TO len
    LET linestr=deb_arr[i]
    LET tabPos=linestr.getIndexOf("\t",1)
    IF tabPos=1 THEN
      --ok, we have a tab in the beginning of the line
      LET startHit=linestr.getIndexOf("hit ",1)
      IF startHit>0 THEN
        LET startHit=startHit+length("hit ")+1
        LET endHit=linestr.getIndexOf(" ",startHit)-1
        LET hitNumStr=linestr.subString(startHit,endHit)
        IF breakNum>0 THEN
          LET break_arr[breakNum].hits=hitNumStr
        END IF
      END IF
      CONTINUE FOR
    END IF
    LET endNum=linestr.getIndexOf(" ",1)-1
    LET breakNumStr=linestr.subString(1,endNum)
    LET breakNum=breakNumStr
    WHILE linestr.getCharAt(startDisp)<>"k" AND
          linestr.getCharAt(startDisp)<>"d" AND
          startDisp<startEnb2
      LET startDisp=startDisp+1
      LET startEnb =startEnb+1
      LET startWhat=startWhat+1
    END WHILE
    IF linestr.getCharAt(startDisp)<>"k" AND
       linestr.getCharAt(startDisp)<>"d" THEN
      DISPLAY "!!!!ERROR: can't figure out \"Disp\" location in breakpoint string"
      CONTINUE FOR
    END IF
    LET endDisp=linestr.getIndexOf(" ",startDisp)-1
    LET breakType=linestr.subString(startDisp,endDisp)
    LET bcount=bcount+1
    --LET bcount=breakNum
    LET break_arr[bcount].breakType=breakType
    LET endEnb=linestr.getIndexOf(" ",startEnb)-1
    LET enabled=linestr.subString(startEnb,endEnb)
    LET break_arr[bcount].enabled=enabled
    LET what=linestr.subString(startWhat,linestr.getLength())
    LET inStr=what.subString(1,3)
    --DISPLAY "inStr=\"",inStr,"\""
    IF inStr="in " THEN
      LET break_arr[bcount].breakNum=breakNum
      LET startFunc=4
      LET endFunc=what.getIndexOf(" ",startFunc)-1
      LET funcName=what.subString(startFunc,endFunc)
      LET break_arr[bcount].funcName=funcName
      LET atStr=what.subString(endFunc+1,endFunc+4)
      --DISPLAY "atStr=\"",atStr,"\""
      IF atStr=" at " THEN
        LET startMod=endFunc+5
        LET endMod=what.getIndexOf(":",startMod)-1
        LET modName=what.subString(startMod,endMod)
        LET break_arr[bcount].modName=modName
        LET startLine=endMod+2
        LET numStr=what.subString(startLine,what.getLength())
        LET lineNumber=numStr
        LET break_arr[bcount].lineNumber=lineNumber
      END IF
      --DISPLAY "bpoint ",bcount,",func:",funcName,",mod:",modName,",line:",lineNumber
      IF modName=g_file_displayed THEN
        --check if the breakpoint field needs a redisplay
        --and remember the linenumber in the tmp_arr
        LET tmp_count=tmp_count+1
        LET tmp_arr[tmp_count]=lineNumber
        LET bpfield=src_arr[lineNumber].marker
        --IF bpfield.getLength()=0 OR bpfield<>"circle" THEN
        -- LET bpfield="debug_break"
        -- IF g_line=lineNumber THEN
        -- LET bpfield="debug_breaknmarker"
        -- END IF
        LET src_arr[lineNumber].marker=get_marker(lineNumber,breakNum)
        LET src_arr[lineNumber].isBreak=src_arr[lineNumber].isBreak+1
        --END IF
      END IF
    END IF
  END FOR
  --look in the old breakpoints, if there is a line information then
  -- copy it
  LET len=break_arr.getLength()
  LET len2=break_arr_old.getLength()
  FOR i=1 TO len
    LET breakNum=break_arr[i].breakNum
    FOR j=1 TO len2
      IF break_arr_old[j].breakNum=breakNum THEN
        LET break_arr[i].line=break_arr_old[j].line
        LET break_arr[i].isFunction=break_arr_old[j].isFunction
        EXIT FOR
      END IF
    END FOR
  END FOR
  --look if there are breakpoints in the current module array
  --which are not in the breakpoint array and delete them
  {
  LET len=src_arr.getLength()
  LET len2=tmp_arr.getLength()
  FOR i=1 TO len
    IF src_arr[i].isBreak>0 THEN
      --we assume a breakpoint in line i
      --look if this is true
      LET found=0
      FOR j=1 TO len2
        IF tmp_arr[j]=i THEN
          LET found=1
          EXIT FOR
        END IF
      END FOR
      IF found=0 THEN
        --delete the bitmap
        LET bpfield=src_arr[i].marker
        IF g_line=lineNumber THEN
          LET bpfield="debug_marker"
        ELSE
          LET bpfield=""
        END IF
        LET src_arr[lineNumber].marker=bpfield
        LET src_arr[lineNumber].isBreak=0
      END IF
    END IF
  END FOR
  }
END FUNCTION

FUNCTION om_get_current_window_name()
  DEFINE w ui.Window
  DEFINE n om.DomNode
  LET w=ui.Window.getCurrent()
  LET n=w.getNode()
  RETURN n.getAttribute("name")
END FUNCTION

--the following functions build a private
--window stack, each ,OPEN_WIN , CURR_WIN
--or CLOSE_WIN macro calls the functions

FUNCTION get_current_dialog()
  DEFINE win STRING
  IF win_arr.getLength()>0 THEN
    LET win=win_arr[1]
  ELSE
    --RETURN om_get_current_window_name()
    LET win="fgldeb"
  END IF
  IF NOT windowExist(win) THEN
    LET win="fgldeb"
  END IF
  RETURN win
END FUNCTION

FUNCTION get_current_window_stack()
  DEFINE i,len INTEGER
  DEFINE result STRING
  LET len=win_arr.getLength()
  FOR i=1 TO len
    LET result=result.append(win_arr[i])
    LET result=result.append(" ")
  END FOR
  RETURN result
END FUNCTION

FUNCTION set_current_dialog(win)
  DEFINE win STRING
  --DISPLAY "#######CURRENT WINDOW IS ",win
  --exclude the main window
  IF win="fgldeb" THEN
    RETURN
  END IF
  CALL remove_dialog_name(win)
  CALL win_arr.insertElement(1)
  LET win_arr[1]=win
END FUNCTION

FUNCTION remove_dialog_name(win)
  DEFINE win STRING
  DEFINE i,len INTEGER
  LET len=win_arr.getLength()
  FOR i=1 TO len
    IF win=win_arr[i] THEN
      CALL win_arr.deleteElement(i)
      EXIT FOR
    END IF
  END FOR
END FUNCTION

--function to parse the result of "where" (same as "backtrace")
--the result is stored in the global "stk_arr"
FUNCTION update_stack()
  CALL deb_write("where")
  CALL get_deb_out()
  CALL update_stack1()
  CALL check_function_finish()
END FUNCTION

FUNCTION update_stack1()
  DEFINE i,len,stk_count,endLevel,endFunc,startMod,endMod,found Integer
  DEFINE j,stk_len,auto_len INTEGER
  DEFINE levelStr,funcName,modName,lineNumberStr,line,auto_frame_name String
  CALL stk_arr.clear()
  LET len=deb_arr.getLength()
  IF len=0 THEN
    IF g_verbose THEN
      DISPLAY "got no stack"
    END IF
    CALL auto_arr.clear()
    LET auto_arr[1].frame_name="__INIT__"
    RETURN
  END IF
  FOR i=1 TO len
    LET line=deb_arr[i]
    IF line.subString(1,1)<>"#" THEN
      --DISPLAY "line \"",line,"\" is not a \"where\" line "
      CONTINUE FOR
    END IF
    LET stk_count=stk_count+1
    --parse out level,funcName,modName and lineNumber
    LET endLevel=line.getIndexOf(" ",1)-1
    LET levelStr=line.subString(2,endLevel)
    LET stk_arr[stk_count].level=levelStr
    LET endFunc=line.getIndexOf(" at ",endLevel)-1
    LET funcName=line.subString(endLevel+2,endFunc)
    LET stk_arr[stk_count].funcName=funcName
    LET startMod=endFunc+5
    LET endMod=line.getIndexOf(":",startMod)-1
    LET modName=line.subString(startMod,endMod)
    LET stk_arr[stk_count].modName=modName
    LET lineNumberStr=line.subString(endMod+2,line.getLength())
    LET stk_arr[stk_count].lineNumber=lineNumberStr
    --DISPLAY "level:",levelStr,"count: ",stk_count," funcName:",funcName," modName:",modName," line:",lineNumberStr
    --update auto_arr
    LET found=0
    LET auto_len = auto_arr.getLength()
    FOR j=1 TO auto_len
      IF auto_arr[j].frame_name=funcName THEN
        LET found=1
        EXIT FOR
      END IF
    END FOR
    IF NOT found THEN
      --DISPLAY "add \"",funcName,"\" to auto_arr"
      LET auto_arr[auto_len+1].frame_name=funcName
    END IF
  END FOR
  --IF om_get_current_window_name()=="fgldeb" THEN
  -- DISPLAY stk_arr[1].funcName TO currfunc
  -- DISPLAY stk_arr[1].lineNumber TO cline
  --END IF
  LET stk_len=stk_arr.getLength()
  IF g_frame_no>0 AND g_frame_no<=stk_len THEN
    LET g_frame_name=stk_arr[g_frame_no].funcName
    LET g_status_line_no=stk_arr[g_frame_no].lineNumber
    CALL update_status(0)
  END IF
  --delete unused auto_arr frames
  LET auto_len=auto_arr.getLength()
  FOR i=1 TO auto_len
    LET found=0
    LET auto_frame_name=auto_arr[i].frame_name
    FOR j=1 TO stk_len
      IF stk_arr[j].funcName=auto_frame_name THEN
        LET found=1
        EXIT FOR
      END IF
    END FOR
    IF NOT found THEN
      --DISPLAY "delete \"",auto_frame_name,"\" from auto_arr"
      CALL auto_arr.deleteElement(i)
    END IF
  END FOR
END FUNCTION

--is invoked when a get_deb_out gave "Value returned.." back
FUNCTION check_function_finish()
  DEFINE i,len INTEGER
  IF g_check_finish THEN
    --check , if one of the break until function returns became true
    --DISPLAY "in check_finish2 , stk_arr[1].funcName is:",stk_arr[1].funcName
    LET g_check_finish=0
    LET len=finish_arr.getLength()
    FOR i=1 TO len
      --DISPLAY "compare with finish_arr[",i,"]:",finish_arr[i].caller
      IF finish_arr[i].caller=stk_arr[1].funcName THEN
        IF NOT windowExist("finish") THEN OPEN WINDOW finish WITH FORM "finish" ELSE CURRENT WINDOW IS finish END IF CALL set_current_dialog("finish")
        CALL fgl_settitle(sfmt("Step out of %1",finish_arr[i].funcName))
        DISPLAY finish_arr[i].funcName TO finishFunc
        DISPLAY g_finish_result TO finishResult
        MENU "Step Out"
          COMMAND "Ok"
            EXIT MENU
        END MENU
        CLOSE WINDOW finish CALL remove_dialog_name("finish")
        CALL finish_arr.deleteElement(i)
        EXIT FOR
      END IF
    END FOR
  END IF
END FUNCTION

--tries to find a slash or backlash
--in a given filename
FUNCTION get_file_separator(fname)
  DEFINE fname,sep String
  IF fname.getIndexOf("/",1) <> 0 THEN
    LET sep="/"
  ELSE IF fname.getIndexOf("\\",1) <> 0 THEN
    LET sep="\\"
  END IF
  END IF
  RETURN sep
END FUNCTION

--computes a short filename from a long filename
FUNCTION get_short_filename(fname)
  DEFINE fname,tmpStr,sep String
  DEFINE idx Integer
  LET tmpStr=fname
  LET sep=get_file_separator(fname)
  IF sep IS NULL THEN
    --no separator, we already have the file
    RETURN fname
  END IF
  LET idx=1
  WHILE idx<>0
    LET idx=fname.getIndexOf(sep,1)
    IF idx<>0 THEN
      LET fname=fname.subString(idx+1,fname.getLength())
    END IF
  END WHILE
  --DISPLAY "get_short_filename:original \"",tmpStr,"\" short \"",fname,"\""
  RETURN fname
END FUNCTION

--gives back the directory portion of a filename
FUNCTION get_dirname(fname)
  DEFINE fname,dirname,sep String
  DEFINE idx,start INTEGER
  LET sep=get_file_separator(fname)
  --DISPLAY "get_dirname ",fname
  IF sep IS NULL THEN
    RETURN ""
  END IF
  LET start=1
  LET idx=1
  WHILE idx<> 0
    LET idx=fname.getIndexOf(sep,1)
    IF idx<>0 THEN
      LET dirname=dirname.append(fname.subString(start,idx))
      LET fname=fname.subString(idx+1,fname.getLength())
      LET start=idx+1
    END IF
  END WHILE
  --DISPLAY "dirname= ",dirname
  RETURN dirname
END FUNCTION

--following a whole bunch of functions to set dynamically the
--column title, this should be really a 4gl-library function

FUNCTION set_TableColumn_text(tabName,colName,text)
  DEFINE tabName,colName,text String
  DEFINE tabId ,colId Integer
  DEFINE colNode om.DomNode
  LET tabId = _deb_getOmIdTable(tabName)
  IF tabId = -1 THEN
    RETURN
  END IF
  --get the TableColumn id
  LET colId = _deb_getOmIdTableColumn(tabId,colName)
  IF colId = -1 THEN
    RETURN
  END IF
  LET colNode= _deb_omId2Node(colId)
  IF colNode IS NULL THEN
    RETURN
  END IF
  CALL colNode.setAttribute("text",text)
END FUNCTION

--bunch of om functions


FUNCTION _deb_omId2Node(omId)
   DEFINE omId Integer
   DEFINE node om.DomNode
   DEFINE doc om.DomDocument
   DEFINE idStr String
   LET doc =ui.Interface.getDocument()
   LET node =doc.getElementById(omId)
   IF node IS NULL THEN
     LET idStr=omId
     CALL deb_error("could not convert id \""||idStr||"\" to a node")
   END IF
   RETURN node
END FUNCTION

FUNCTION _deb_getOmIdXPath(xPathSearchStr,nodeIdForStart)
   DEFINE xPathSearchStr String
   DEFINE nodeIdForStart Integer
   DEFINE r, n om.DomNode
   DEFINE nl om.NodeList
   DEFINE id Integer
   DEFINE doc om.DomDocument
   LET doc =ui.Interface.getDocument()
   --LET r = ui.Interface.getRootNode()
   LET r = doc.getElementById(nodeIdForStart)
   IF r IS NULL THEN
     RETURN -1
   END IF
   LET nl = r.selectByPath(xPathSearchStr)
   LET id=-1
   IF nl.getLength()=1 THEN
     let n = nl.item(1)
     let id = n.getId()
   ELSE IF nl.getLength()>1 THEN
     CALL deb_error("_deb_getOmIdXPath:got more than one id for "||xPathSearchStr)
     let id = -1
   ELSE
     CALL deb_error("_deb_getOmIdXPath:did not find an id for "||xPathSearchStr)
     let id = -1
   END IF
   END IF
   RETURN id
END FUNCTION

FUNCTION _deb_getOmNodeXPath(xPathSearchStr,nodeIdForStart)
  DEFINE xPathSearchStr String
  DEFINE nodeIdForStart Integer
  DEFINE omId INTEGER
  LET omId=_deb_getOmIdXPath(xPathSearchStr,nodeIdForStart)
  IF omId=-1 THEN
    RETURN NULL
  END IF
  RETURN _deb_omId2Node(omId)
END FUNCTION

FUNCTION _deb_getOmIdCurrentWindow()
   DEFINE root,currWinNode om.DomNode
   DEFINE doc om.DomDocument
   DEFINE currWinId Integer
   LET root=ui.Interface.getRootNode()
   LET currWinId= root.getAttribute("currentWindow")
   --sanity check if the currentwindow exists in the tree
   LET doc =ui.Interface.getDocument()
   LET currWinNode =doc.getElementById(currWinId)
   IF currWinNode IS NULL OR currWinNode.getTagName()<>"Window" THEN
      CALL deb_error("_deb_getOmIdCurrentWindow, window corrupt")
      RETURN -1
   END IF
   RETURN currWinId
END FUNCTION

FUNCTION _deb_getOmNodeGroup(tagName)
  DEFINE tagName String
  DEFINE searchStr String
  DEFINE ret om.DomNode
  LET searchStr=sfmt("//Group[@tag=\"%1\"]",tagName)
  LET ret= _deb_getOmNodeXPath(searchStr,_deb_getOmIdCurrentWindow())
  IF ret IS NULL Then
    CALL deb_error("can't get omNode for Group with tag \""||tagName||"\"")
  END IF
  RETURN ret
END FUNCTION

FUNCTION _deb_setGroupHidden(tagName,hide)
  DEFINE tagName String
  DEFINE hide INTEGER
  DEFINE node om.DomNode
  LET node=_deb_getOmNodeGroup(tagName)
  IF node IS NOT NULL THEN
    CALL node.setAttribute("hidden",hide)
  END IF
END FUNCTION

FUNCTION _deb_getGroupHidden(tagName)
  DEFINE tagName String
  DEFINE node om.DomNode
  DEFINE result STRING
  LET node=_deb_getOmNodeGroup(tagName)
  IF node IS NOT NULL THEN
    LET result=node.getAttribute("hidden")
    IF result IS NULL THEN
      LET result="0"
    END IF
  ELSE
    LET result=NULL
  END IF
  RETURN result
END FUNCTION

FUNCTION _deb_getOmNodeButton(actionName)
  DEFINE actionName String
  DEFINE searchStr String
  DEFINE node om.DomNode
  LET searchStr=sfmt("//Button[@name=\"%1\"]",actionName)
  LET node= _deb_getOmNodeXPath(searchStr,_deb_getOmIdCurrentWindow())
  IF node IS NULL THEN
    CALL deb_error("can't get omNode for Button with action \""||actionName||"\"")
  END IF
  RETURN node
END FUNCTION

FUNCTION _deb_setButtonText(actionName,txt)
  DEFINE actionName STRING
  DEFINE txt STRING
  DEFINE node om.DomNode
  LET node=_deb_getOmNodeButton(actionName)
  IF node IS NOT NULL THEN
    CALL node.setAttribute("text",txt)
  END IF
END FUNCTION

FUNCTION _deb_getOmIdTable(tabName)
   DEFINE tabName String
   DEFINE searchStr String
   DEFINE ret Integer
   LET searchStr="//Table[@tabName=\"" || tabName || "\"]"
   LET ret= _deb_getOmIdXPath(searchStr,0)
   IF ret= -1 Then
     CALL deb_error("can't get omId for Table \""||tabName||"\"")
   END IF
   RETURN ret
END FUNCTION



FUNCTION _deb_getOmIdTableColumn(tabId,colName)
  DEFINE tabId Integer
  DEFINE colName String
  DEFINE searchStr String
  DEFINE ret Integer
  LET searchStr="//TableColumn[@colName=\"" || colName || "\"]"
  LET ret= _deb_getOmIdXPath(searchStr,tabId)
  IF ret= -1 Then
    CALL deb_error("can't get omId for TableColumn \""||colName||"\"");
  END IF
  RETURN ret
END FUNCTION


FUNCTION deb_error(str)
  define str String
  DISPLAY "ERROR :",str
END FUNCTION

--lets the debugger die
FUNCTION do_quit(state)
  DEFINE state STRING
  -- postpone this until stable
  IF yesno("Exit the debugger")="no" THEN
    RETURN state
  END IF
  CALL save_state()
  IF g_active THEN
    LET g_quit=1
    CALL deb_write("quit")
    CALL get_deb_out()
  END IF
  RETURN "exitapp"
END FUNCTION


FUNCTION set_g_state(st)
  DEFINE st String
  IF (g_state="running" AND st="stopped") OR
     (g_state="running" AND st="initial") OR
     (g_state="stopped" AND st="running") OR
     (g_state="initial" AND st="running") THEN
    --DISPLAY "!!!!!!! clear_all_markers"
    CALL clear_all_markers()
    CASE st
      WHEN "running"
        LET g_frame_no=1
        LET g_frame_name="main()"
        LET g_line_0=g_main_lineNumber
        LET g_file_0=g_main_modName
      OTHERWISE
        LET g_frame_no=0
        LET g_frame_name=""
    END CASE
  END IF
  IF g_state="initial" AND st="stopped" THEN
    LET st="initial"
  END IF
  LET g_state=st
  CALL update_status(1)
END FUNCTION

--resets the currently selected stackframe to the top
--and clears all line markers
FUNCTION prepare_stepcmd ()
  CALL clear_all_markers()
  IF g_state="running" THEN
    LET g_frame_no=1
  END IF
  LET g_continue=0
END FUNCTION

--general step function for use within
--the main loop
FUNCTION do_debugger_step_cmd(cmd)
  DEFINE cmd String
  CALL prepare_stepcmd()
  CALL set_g_state("running")
  CALL deb_write(cmd)
  CALL get_deb_out()
  IF g_state="initial" AND g_continue THEN
    CALL clear_all_markers()
    RETURN
  END IF
  IF g_state="stopped" AND g_reload THEN
    CALL clear_all_markers()
    CALL reopen_program()
    RETURN
  END IF
  CALL update_stack()
  CALL update_watch()
  CALL update_autovars()
  LET g_quit=0
END FUNCTION

FUNCTION deb_write (cmd)
  DEFINE cmd String
  LET g_cmdcount=g_cmdcount+1
  --uncomment the next line to trace ALL commands sent to the debugger
  --DISPLAY "<<write \"",cmd,"\",count :",g_cmdcount
  CALL g_channel.write(cmd)
  LET g_last_deb_cmd=cmd
END FUNCTION

--returns the last command keyword
FUNCTION get_last_keyword()
  DEFINE endword INTEGER
  DEFINE cmd STRING
  LET endword=g_last_deb_cmd.getIndexOf(" ",1)
  IF endword=0 THEN LET
    cmd=g_last_deb_cmd
  ELSE
    LET cmd=g_last_deb_cmd.subString(1,endword-1)
  END IF
  LET cmd=complete_fdb_command(cmd)
  RETURN cmd
END FUNCTION

--did we sent one of the following commands ?
FUNCTION sent_execution_cmd()
  DEFINE cmd STRING
  LET cmd=get_last_keyword()
  IF cmd="run" OR cmd="continue" OR cmd="step" OR cmd="next" OR
     cmd="until" OR cmd="quit" OR cmd="finish" OR cmd="call" THEN
    RETURN 1
  ELSE
    RETURN 0
  END IF
END FUNCTION

--makes a complete command name from an incomplete sequence
FUNCTION complete_fdb_command (part)
  DEFINE part STRING
  DEFINE i, len, found, firstidx INTEGER
  DEFINE carr DYNAMIC ARRAY OF STRING
  LET carr[1] ="break" -- Set breakpoint at specified line or function
  LET carr[2] ="tbreak" -- Set a temporary breakpoint
  LET carr[3] ="backtrace" -- Print backtrace of all stack frames
  LET carr[4] ="bt" -- Print backtrace of all stack frames
  LET carr[5] ="continue" -- Continue program being debugged
  LET carr[6] ="call" -- Call a function in the program
  LET carr[7] ="clear" -- Clear breakpoint at specified line or function.
  LET carr[8] ="delete" -- Delete some breakpoints or
                           -- auto-display expressions
  LET carr[9] ="define" -- Define a new command name.
  LET carr[10]="display" -- Print value of expression EXP each time
                           -- the program stops
  LET carr[11]="disable" -- Disable some breakpoints
  LET carr[12]="down" -- Select and print FUNCTION called by this one
  LET carr[13]="enable" -- Enable some breakpoints
  LET carr[14]="echo" -- Print a constant string
  LET carr[15]="file" -- Use FILE as program to be debugged
  LET carr[16]="finish" -- Execute until selected stack frame returns
  LET carr[17]="frame" -- Select and print a stack frame.
  LET carr[18]="help" -- Print list of commands.
  LET carr[19]="info" -- Generic command for showing things about
                           -- the program being debugged.
  LET carr[20]="list" -- List specified function or line
  LET carr[21]="next" -- Step program
  LET carr[22]="output" -- Like "print" but doesnt put in value history
                           -- and doesnt print newline.
  LET carr[23]="print" -- Print value of expression EXP
  LET carr[24]="quit" -- Exit fgldb
  LET carr[25]="run" -- Start debugged program
  LET carr[26]="step" -- Step program until it reaches a different source
                           -- line
  LET carr[27]="set" -- Evaluate expression EXP and assign result to
                           -- variable VAR
  LET carr[28]="signal" -- Continue program giving it signal specified by
                           -- the argument
  LET carr[29]="source" -- Read commands from a file named FILE.
  LET carr[30]="tty" -- Set terminal for future runs of program being
                           -- debugged.
  LET carr[31]="up" -- Select and print FUNCTION that called this one
  LET carr[32]="undisplay" -- Cancel some expressions to be displayed when
                           -- program stops
  LET carr[33]="until" -- Execute until the program reaches a source line
                           -- greater than the current or a specified line or
                           -- address or function (same args as break command)
  LET carr[34]="watch" -- Set a watchpoint for an expression
  LET carr[35]="where" -- Print backtrace of all stack frames

  LET len=carr.getLength()
  FOR i=1 TO len
    IF carr[i].getIndexOf(part,1)=1 THEN
      LET found=found+1
      IF found=1 THEN
        LET firstidx=i
      -- ELSE
        -- DISPLAY "ambigous command \"",part,"\",can be :",carr[firstidx]," or ",carr[i]
      END IF
    END IF
  END FOR
  IF found>0 THEN
    -- DISPLAY "completed \"",part,"\" to \"",carr[firstidx],"\""
    RETURN carr[firstidx]
  END IF
  RETURN "none"
END FUNCTION

--interacts directly with the underlying "TRUE" fdb debugger
--the user can type in commands and sees the answer from the
--debugger , useful in special situations and for exploring
--the richness of the debugger interface

FUNCTION do_fdb_command()
  DEFINE c,result,cmd String
  DEFINE go_out,i,idxhist,refresh,cidx,insert_in_history Integer

  --LET fdbcommand=""
  IF NOT windowExist("fdbcommand") THEN OPEN WINDOW fdbcommand WITH FORM "fdbcommand" ELSE CURRENT WINDOW IS fdbcommand END IF CALL set_current_dialog("fdbcommand")
  LET go_out=0
    WHILE NOT go_out
    LET idxhist=0
    INPUT BY NAME g_fdbcommand,g_debout WITHOUT DEFAULTS ATTRIBUTES(UNBUFFERED)
      --AFTER INPUT
        --DISPLAY "COMMAND is ",g_fdbcommand
      ON ACTION history_up IF INFIELD(g_fdbcommand) THEN CALL history_up(fdb_hist_arr,idxhist,g_fdbcommand) RETURNING g_fdbcommand,idxhist END IF ON ACTION history_down IF INFIELD(g_fdbcommand) THEN CALL history_down(fdb_hist_arr,idxhist,g_fdbcommand) RETURNING g_fdbcommand,idxhist END IF ON ACTION history_show IF INFIELD(g_fdbcommand) THEN CALL history_show(fdb_hist_arr,idxhist,g_fdbcommand) RETURNING g_fdbcommand,idxhist DISPLAY "g_fdbcommand" , " is ", g_fdbcommand END IF
      ON ACTION showfdbcommands
        LET cmd=do_show_all_commands()
        IF cmd IS NOT NULL THEN
          LET g_fdbcommand=cmd
        END IF
      ON ACTION refresh
        LET refresh=1
      ON ACTION clipboard
        CALL ui.Interface.frontCall("standard", "cbset", [g_debout], [status])
      ON KEY(Interrupt)
        LET go_out=1
        --LET g_fdbcommand=""
        EXIT INPUT
    END INPUT
    IF go_out=1 THEN
      EXIT WHILE
    END IF
     -- we need to go out of the current window if one of the following commands
    -- is executed
    IF refresh THEN
      LET g_fdbcommand="where"
    END IF
    IF length(g_fdbcommand) = 0 THEN
      CONTINUE WHILE
    END IF
    LET cidx=g_fdbcommand.getIndexOf(" ",1)
    IF cidx=0 THEN
      LET cidx=g_fdbcommand.getLength()+1
    END IF
    LET c =g_fdbcommand.subString(1,cidx-1)
    --DISPLAY "c is \"",c,"\""
    LET c= complete_fdb_command (c)
    IF refresh OR c="step" OR c="next" OR
       c="continue" OR c="break" OR c="tbreak" OR
       c="clear" OR c="delete" OR c="return" OR
       c="finish" OR c="call" OR c="enable" OR
       c="disable" OR c="where" OR c="run" THEN
      CURRENT WINDOW IS fgldeb CALL set_current_dialog("fgldeb")
      LET refresh=1
    END IF
    IF c="run" OR c="continue" OR c="step" OR c="next" THEN
       CALL do_debugger_step_cmd(g_fdbcommand)
    ELSE
       CALL deb_write(g_fdbcommand)
       CALL get_deb_out()
    END IF
    LET result=""
    LET insert_in_history=0
    FOR i=1 TO deb_arr_len
      IF i=1 AND deb_arr[1].getIndexOf("Undefined command",1)=0 THEN
        LET insert_in_history=1
      END IF
      LET result=result.append(deb_arr[i])
      LET result=result.append("\n")
    END FOR
    IF insert_in_history THEN
      CALL history_insert(fdb_hist_arr,g_fdbcommand)
    END IF
    CURRENT WINDOW IS fdbcommand CALL set_current_dialog("fdbcommand")
    LET g_debout=result
    DISPLAY result TO g_debout
    LET c=g_fdbcommand
    -- we need to go out of the current window if one of the following commands
    -- is executed
    IF refresh THEN
      CURRENT WINDOW IS fgldeb CALL set_current_dialog("fgldeb")
      CALL update_stack()
      CALL update_breakpoints()
      --DISPLAY "return fdbcommand on ",g_fdbcommand
      RETURN "fdbcommand"
    END IF
    IF c="q" OR c="quit" THEN
      LET go_out=1
    END IF
  END WHILE
  CLOSE WINDOW fdbcommand CALL remove_dialog_name("fdbcommand")
  --DISPLAY "end of fdbcommand,current window is ", get_current_dialog()
  --DISPLAY "stack is \"", get_current_window_stack() , "\""
  --RETURN "fgldeb"
  RETURN get_current_dialog()
END FUNCTION

--inserts an entry into to gieven history array
--the function checks for duplicates
--and deletes them before inserting the new entry
FUNCTION history_insert (hist_arr,entry)
  DEFINE hist_arr DYNAMIC ARRAY OF STRING
  DEFINE entry STRING
  DEFINE i,len INTEGER
  --insert the command into the history
  --first look if its already in the history
  LET len=hist_arr.getLength()
  FOR i=1 TO len
    IF hist_arr[i]=entry THEN
      --DISPLAY "delete entry ",i," for command ",entry
      CALL hist_arr.deleteElement(i)
      EXIT FOR
    END IF
  END FOR
  CALL hist_arr.insertElement(1)
  LET hist_arr[1]=entry
  {
  -- print out the history array
  --LET len=hist_arr.getLength()
  --FOR i=1 TO len
  -- DISPLAY "hist_arr[",i,"]=",hist_arr[i]
  --END FOR
  }
END FUNCTION

--goes up in the given history array
FUNCTION history_up (hist_arr,idx,prevEntry)
  DEFINE hist_arr DYNAMIC ARRAY OF STRING
  DEFINE idx INTEGER
  DEFINE prevEntry,entry STRING
  IF hist_arr.getLength()<1 THEN
    RETURN prevEntry,idx
  END IF
LABEL fdb_history_up:
  LET idx=idx+1
  IF idx>hist_arr.getLength() THEN
    LET idx=hist_arr.getLength()
  END IF
  IF idx=0 THEN
    LET entry=""
  ELSE
    LET entry=hist_arr[idx]
  END IF
  IF entry IS NOT NULL AND entry=prevEntry AND
     hist_arr.getLength()>1 AND idx<hist_arr.getLength() THEN
    --the value didnt change
    GOTO :fdb_history_up
  END IF
  RETURN entry,idx
END FUNCTION

--goes down in the given history array
FUNCTION history_down (hist_arr,idx,prevEntry)
  DEFINE hist_arr DYNAMIC ARRAY OF STRING
  DEFINE idx INTEGER
  DEFINE prevEntry,entry STRING
  LET idx=idx-1
  IF idx<0 THEN
    LET idx=0
  END IF
  IF idx=0 THEN
    LET entry=""
  ELSE
    LET entry=hist_arr[idx]
  END IF
  RETURN entry,idx
END FUNCTION

--shows a dialog containing the history list
FUNCTION history_show(hist_arr,idx,oldvalue)
  DEFINE hist_arr DYNAMIC ARRAY OF STRING
  DEFINE idx Integer
  DEFINE oldvalue,value STRING
  DEFINE prevIdx,i,len INTEGER
  LET prevIdx=idx
  LET value=oldvalue
  IF NOT windowExist("fdbhistory") THEN OPEN WINDOW fdbhistory WITH FORM "fdbhistory" ELSE CURRENT WINDOW IS fdbhistory END IF CALL set_current_dialog("fdbhistory")
  CALL set_count(hist_arr.getLength())
  DISPLAY ARRAY hist_arr to hist.* ATTRIBUTES(UNBUFFERED)
    BEFORE DISPLAY
      LET len=hist_arr.getLength()
      FOR i=1 TO len
        IF hist_arr[i]=value THEN
          CALL fgl_set_arr_curr(i)
          EXIT FOR
        END IF
      END FOR
    ON KEY(Interrupt)
      LET value=oldValue
      LET idx=prevIdx
      EXIT DISPLAY
    ON ACTION delete
      --delete the current line in the array
      --because this leads to core dumps when we
      --stay in the DISPLAY ARRAY, we go out
      --and reenter the interaction
      CALL hist_arr.deleteElement(arr_curr())
    AFTER DISPLAY
      LET prevIdx=-1
      LET idx=arr_curr()
      --DISPLAY "set idx to",idx
  END DISPLAY
  CLOSE WINDOW fdbhistory CALL remove_dialog_name("fdbhistory")
  IF idx!=prevIdx THEN
    LET value=hist_arr[idx]
  ELSE
    LET value=oldvalue
  END IF
  RETURN value,idx
END FUNCTION

--shows a dialog containing all commands
FUNCTION do_show_all_commands()
  DEFINE cmd_arr DYNAMIC ARRAY OF RECORD
    cmd String,
    hlp String
  END RECORD
  DEFINE cmd_idx,i,minus2Idx INTEGER
  DEFINE line STRING
  CALL deb_write("help")
  CALL get_deb_out()
  IF deb_arr.getLength()<1 THEN
    ERROR "debugger did not respond"
    RETURN ""
  END IF
  --DISPLAY "deb_arr[1]=\"",deb_arr[1],"\""
  IF deb_arr[1]<>"List of commands" THEN
    ERROR "did not get \"List of commands\""
    RETURN ""
  END IF
  CALL cmd_arr.clear()
  LET cmd_idx=0
  FOR i=2 TO deb_arr_len
    LET cmd_idx=cmd_idx+1
    LET line=deb_arr[i]
    LET minus2Idx=line.getIndexOf(" -- ",1)
    LET cmd_arr[cmd_idx].cmd=line.subString(1,minus2Idx-1)
    LET cmd_arr[cmd_idx].hlp=line.subString(minus2Idx+3,line.getLength())
  END FOR
  IF NOT windowExist("fdbcommandlist") THEN OPEN WINDOW fdbcommandlist WITH FORM "fdbcommandlist" ELSE CURRENT WINDOW IS fdbcommandlist END IF CALL set_current_dialog("fdbcommandlist")
    LET cmd_idx=0
    CALL set_count(cmd_arr.getLength())
    DISPLAY ARRAY cmd_arr TO rec.*
      AFTER DISPLAY
        LET cmd_idx=arr_curr()
      ON KEY(Interrupt)
        EXIT DISPLAY
    END DISPLAY
  CLOSE WINDOW fdbcommandlist CALL remove_dialog_name("fdbcommandlist")
  IF cmd_idx>0 THEN
     RETURN cmd_arr[cmd_idx].cmd
     --DISPLAY g_fdbcommand TO g_fdbcommand
  END IF
  RETURN ""
END FUNCTION


--tries to toggle the breakpoint at the current line
--main problem: the debugger does not treat every line as valid
--so the debugger eventually takes one of the next lines for
--the breakpoint
--for switching a breakpoint on this is no problem, however
--for switching a breakpoint off this causes problems, because
--if we are in a line which has no breakpoint, we think we require
--a new one,but it may result that an already existing breakpoints is
--created twice,because the real line is different
FUNCTION do_toggle_break()
  define cmd,breakNum,currlineStr String
  define currline,clear Integer
  LET cmd="help"
  LET breakNum=-1
  LET currline=g_line
  LET currlineStr=currline
  IF search_breakpoint(currline)=0 THEN
    LET clear=0
    LET cmd=sfmt("break %1:%2",g_file_displayed,currlineStr)
  ELSE
    --find which breakpoint we have to delete
    LET clear=1
    LET breakNum=search_breakpoint(currline)
    IF breakNum<>0 THEN
      LET cmd=sfmt("delete %1",breakNum)
    END IF
    --LET src_arr[currline].isBreak=0
    --IF currline=g_line THEN
    -- LET src_arr[currline].marker="debug_marker"
    --ELSE
    -- LET src_arr[currline].marker=""
    --END IF
  END IF
  CALL deb_write(cmd)
  CALL get_deb_out()
  CALL check_break_line(currline,clear,g_file_displayed,NULL)
END FUNCTION

FUNCTION check_break_line(currline,clear,filename,line_arr)
  define filename,breakNumStr,cmd String
  define line_arr DYNAMIC ARRAY OF STRING
  define currline,clear,breakNum,breakNum2,realLine,bcount,bcount2 Integer
  LET bcount=break_arr.getLength()
  CALL update_breakpoints()
  LET bcount2=break_arr.getLength()
  IF clear=0 AND bcount2>bcount THEN
    --we requested adding a breakpoint and we also got one breakpoint more
    LET breakNum=break_arr[bcount2].breakNum
    LET realLine=break_arr[bcount2].lineNumber
    --check if we added a 2nd breakpoint
    LET breakNum2=search_breakpoint(realLine)
    IF realLine!=currline AND breakNum<>breakNum2 THEN
      --we have another breakpoint at the same line
      --we assume deleting both in this case
      --DISPLAY "found breakpoints ",breakNum,",",breakNum2," for line ",realLine,",deleting both"
      LET breakNumStr=breakNum
      LET cmd="delete "||breakNumStr
      CALL deb_write(cmd)
      CALL get_deb_out()
      LET breakNumStr=breakNum2
      LET cmd="delete "||breakNumStr
      CALL deb_write(cmd)
      CALL get_deb_out()
      --finally redisplay the breakpoints again
      CALL update_breakpoints()
    ELSE

      --remember the context of the breakpoint
      IF break_arr[bcount2].modName=filename THEN
        IF filename=g_file_displayed THEN
          LET break_arr[bcount2].line=src_arr[realLine].line
        END IF
        IF line_arr.getLength()>=realLine THEN
          LET break_arr[bcount2].line=line_arr[realLine]
        END IF
      END IF
    END IF
  END IF
END FUNCTION

FUNCTION do_toggle_breakdisable()
  DEFINE breakNumStr,cmd String
  LET breakNumStr=search_breakpoint(arr_curr())
  IF breakNumStr=="0" THEN
    --DISPLAY "no breakpoint found at ",arr_curr()
    RETURN
  END IF
  IF break_arr[breakNumStr].enabled="y" THEN
    LET cmd= "disable "
  ELSE
    LET cmd= "enable "
  END IF
  LET cmd=cmd || breakNumStr
  CALL deb_write(cmd)
  CALL get_deb_out()
  CALL update_breakpoints()
END FUNCTION


{
--implementation using "tbreak"
FUNCTION do_run2cursor_int()
  DEFINE breakNumStr,cmd,currlineStr String
  DEFINE currline,breakNum,bcount,bcount2 Integer
  LET currline=arr_curr()
  LET currlineStr=currline
  LET breakNum=search_breakpoint(currline)
  IF breakNum=0 THEN
    --remember the number of breakpoints
    LET bcount=break_arr.getLength()
    LET cmd="tbreak " || g_file_displayed || ":" || currlineStr
    CALL deb_write(cmd)
    CALL get_deb_out()
    CALL update_breakpoints()
    LET breakNum=search_breakpoint(currline)
    IF breakNum=0 THEN
      --the number of breakpoints didnt change, bail out
      LET bcount2=break_arr.getLength()
      IF bcount2<=bcount THEN
        IF g_verbose THEN
          CALL deb_error(sfmt("can't set temporary breakpoint on line:%1",currline))
        END IF
        RETURN
      END IF
      --ok, we got a new breakpoint, now look if there is already a breakpoint
      --with the same line number
      LET breakNum=search_breakpoint(break_arr[bcount2].lineNumber)
      IF break_arr[bcount2].breakNum<> breakNum THEN
        --there is already a breakpoint with the same line number
        --delete our temporary breakpoint
        LET breakNumStr=break_arr[bcount2].breakNum
        --DISPLAY "breakpoint :",breakNum," already handles line number ",break_arr[bcount2].lineNumber," delete temporary breakpoint #",breakNumStr
        LET cmd="delete "||breakNumStr
        CALL deb_write(cmd)
        CALL get_deb_out()
        CALL update_breakpoints()
      END IF
    END IF
  END IF
  CALL deb_write("continue")
  CALL get_deb_out()
  CALL update_breakpoints()
END FUNCTION
}


FUNCTION show_stack()
  DEFINE frame_cmd String
  DEFINE frame_no,tmp_frame_no,result,lineNumber Integer
  LET result=0
  IF NOT windowExist("stack") THEN OPEN WINDOW stack WITH FORM "stack" ELSE CURRENT WINDOW IS stack END IF CALL set_current_dialog("stack")
  MESSAGE "Choose a call frame for inspecting"
  CALL set_count(stk_arr.getLength())
  DISPLAY ARRAY stk_arr TO stk.* ATTRIBUTES(UNBUFFERED)
    BEFORE DISPLAY
      IF g_state<>"running" THEN
        CONTINUE DISPLAY
      END IF
      IF g_frame_no <= stk_arr.getLength() THEN
        LET stk_arr[g_frame_no].marker="debug_frame"
        CALL fgl_set_arr_curr(g_frame_no)
      END IF
      IF stk_arr.getLength()>=1 THEN
        LET stk_arr[1].marker="debug_marker"
      END IF
    ON ACTION accept
      IF g_state<>"running" THEN
        LET g_frame_no=0
        EXIT DISPLAY
      END IF
      CALL clear_frame_marker()
      LET frame_no=stk_arr[arr_curr()].level
      LET frame_cmd=sfmt("frame %1",frame_no)
      LET tmp_frame_no=g_frame_no
      LET g_frame_no=frame_no+1
      CALL deb_write(frame_cmd)
      CALL get_deb_out()
      IF check_new_frame(frame_no) THEN
        LET g_frame_name=stk_arr[g_frame_no].funcName
        IF g_frame_no>1 AND g_file_displayed=stk_arr[g_frame_no].modName THEN
          LET lineNumber=stk_arr[g_frame_no].lineNumber
          IF lineNumber>1 AND lineNumber<=src_arr.getLength() THEN
            LET src_arr[lineNumber].marker=get_marker(lineNumber,-1)
          END IF
        END IF
      ELSE
        IF g_state="running" THEN
          LET g_frame_no=tmp_frame_no
        END IF
      END IF
      LET result=1
      EXIT DISPLAY
  END DISPLAY
  CLOSE WINDOW stack CALL remove_dialog_name("stack")
  RETURN result
END FUNCTION

FUNCTION check_new_frame(frame_no)
  DEFINE frame_no INTEGER
  DEFINE frameline,levelStr STRING
  DEFINE endpos,newlevel INTEGER
  IF deb_arr_len>0 THEN
    LET frameline=deb_arr[1]
    IF frameline.getCharAt(1)="#" THEN
       LET endpos=frameline.getIndexOf(" ",1)-1
       LET levelStr=frameline.subString(2,endpos)
       LET newlevel=levelStr
       IF newlevel=frame_no THEN
         RETURN 1
       END IF
    END IF
  END IF
  RETURN 0
END FUNCTION

--parses the module names from a comma separated list
--returns the index of the currently displayed file
FUNCTION parse_module_names(srcline)
  DEFINE srcline,mod STRING
  DEFINE cidx,finish,src_idx,currpos,currIdx INTEGER
  LET cidx=1
  LET finish=0
  LET src_idx=0
  LET currpos=1
  LET currIdx=1
  CALL mod_arr.clear()
  WHILE NOT FINISH
    LET cidx=srcline.getIndexOf(",",currpos)
    IF cidx > 0 THEN
      LET mod=srcline.subString(currpos,cidx-1)
      IF srcline.getCharAt(cidx+1)=" " THEN
         LET currpos=cidx+2
      ELSE
         ERROR "parse_sources:did not find space char after \"",mod,"\""
         LET currpos=cidx+1
      END IF
    ELSE
      LET mod=srcline.subString(currpos,srcline.getLength())
      LET finish=1
    END IF
    LET src_idx=src_idx+1
    LET mod_arr[src_idx]=mod
    IF mod=g_file_displayed THEN
      LET currIdx=src_idx
    END IF
  END WHILE
  --LET len=mod_arr.getLength()
  --FOR i=1 TO len
  -- DISPLAY "mod_arr[",i,"]=\"",mod_arr[i],"\""
  --END FOR
  RETURN currIdx
END FUNCTION

--invokes an "info line something" command and
--either jumps to the specified location or
--just leaves the information about file and line of the object
--in g_deb_out_fileName,g_deb_out_line

FUNCTION get_info_line(info_line_cmd,jumpTo)
  DEFINE info_line_cmd STRING
  DEFINE jumpTo Integer
  DEFINE ig ,tmp_frame_no Integer
  CALL deb_write(info_line_cmd)
  --do not change the displayed file here
  LET ig = g_deb_out_ignore_linenumber
  LET g_deb_out_ignore_linenumber= NOT jumpTo
  --do not change current line,current module
  LET tmp_frame_no=g_frame_no
  LET g_frame_no=0
  --ok, call the magic function
  CALL get_deb_out()
  --restore the globals
  LET g_deb_out_ignore_linenumber= ig
  LET g_frame_no=tmp_frame_no
END FUNCTION

--gets the full qualified name of a module
--returns the empty string in case of error
FUNCTION get_full_module_name(srcName)
  DEFINE srcName,fullName String
  --DEFINE tmp_frame_no Integer
  CALL get_info_line(sfmt("info line %1:1",srcName),0)
  IF deb_arr.getLength()<3 THEN
    --CALL fgl_winmessage("Debugger","No lines in \""||srcName||"\" found","error")
    RETURN ""
  END IF
  LET fullName=g_deb_out_filename
  RETURN fullName
END FUNCTION

FUNCTION get_function_info(funcName,jumpToFunction)
  DEFINE funcName String
  DEFINE jumpToFunction Integer
  --DEFINE tmp_frame_no Integer
  --DEFINE fileName STRING
  CALL get_info_line(sfmt("info line %1",funcName),jumpToFunction)
  IF deb_arr.getLength()<3 THEN
    --CALL fgl_winmessage("Debugger","No info for \""||funcName||"\" found","error")
    RETURN "",0
  END IF
  RETURN g_deb_out_filename,g_deb_out_line
END FUNCTION

FUNCTION get_function_info_short(funcName,jumpToFunction)
  DEFINE funcName String
  DEFINE jumpToFunction Integer
  DEFINE file String
  DEFINE line Integer
  CALL get_function_info(funcName,jumpToFunction) RETURNING file,line
  LET file= get_short_filename(file)
  RETURN file,line
END FUNCTION

FUNCTION jump_to_breakpoint(breakNum)
  DEFINE breakNum,jumpidx INTEGER
  DEFINE cmd STRING
  LET jumpidx=get_breakpoint_index(breakNum)
  IF jumpidx<>0 THEN
    LET cmd=sfmt("info line %1:%2",break_arr[jumpidx].modName,
                                 break_arr[jumpidx].lineNumber)
    CALL get_info_line(cmd,1)
  END IF
END FUNCTION

FUNCTION input_full_path(srcName)
  DEFINE srcName,path,fname String
  IF NOT windowExist("input_path") THEN OPEN WINDOW input_path WITH FORM "input_path" ELSE CURRENT WINDOW IS input_path END IF CALL set_current_dialog("input_path")
  LET path=g_src_path
  INPUT BY NAME path ATTRIBUTES(UNBUFFERED)
    BEFORE INPUT
      DISPLAY srcName TO srcName
    ON ACTION accept
      IF path.getCharAt(path.getLength())="/" THEN
        LET fname=path||srcName
      ELSE
        LET fname=path||"/"||srcName
      END IF
      IF NOT fileExists(fname) THEN
        CALL fgl_winmessage("Debugger","Can't find \""||srcName||"\" in \""||path||"\"!","error")
      ELSE
        LET g_src_path=path
        RETURN path
      END IF
  END INPUT
  CLOSE WINDOW input_path CALL remove_dialog_name("input_path")
  RETURN ""
END FUNCTION

--still to implement fully
--someone can take a day for this
FUNCTION browse_full_path(srcName,defaultdir)
  DEFINE srcName, defaultdir,linestr ,program String
  DEFINE find_arr DYNAMIC ARRAY OF String
  DEFINE ch base.Channel
  DEFINE idx,result Integer
  IF NOT windowExist("dirlist") THEN OPEN WINDOW dirlist WITH FORM "dirlist" ELSE CURRENT WINDOW IS dirlist END IF CALL set_current_dialog("dirlist")
  LET ch=base.channel.create()
  LET program="find "||defaultdir||" -type d -maxdepth 1"
  CALL ch.openpipe(program,"r")
  CALL ch.setDelimiter("")
  WHILE 1
    LET result=ch.read(linestr)
    IF result= 0 THEN
       --DISPLAY "find ready"
       EXIT WHILE
    END IF
    IF linestr="." THEN
      LET linestr=".."
    END IF
    IF linestr.getIndexOf("./",1)=1 THEN
      LET linestr=linestr.subString(3,linestr.getLength()-2)
    END IF
    --DISPLAY "fgldeb:",linestr

    LET idx=idx+1
    LET find_arr[idx]=linestr
  END WHILE
  CALL ch.close()
  DISPLAY ARRAY find_arr TO dirlist.* ATTRIBUTES(UNBUFFERED)
    ON ACTION accept
      LET idx=arr_curr()
  END DISPLAY
  CLOSE WINDOW dirlist CALL remove_dialog_name("dirlist")
  RETURN ""
END FUNCTION

FUNCTION show_modules()
  DEFINE len,modline,currIdx Integer
  DEFINE srcline String
  DEFINE bsrc_arr DYNAMIC ARRAY OF STRING --TQC-640040
  CALL deb_write("info sources")
  CALL get_deb_out()
  LET len=deb_arr.getLength()
  IF len<3 THEN
    ERROR "wrong line count ",len," from debugger"
    RETURN
  END IF
  IF deb_arr[1]<>"Source files for which symbols have been read in:" THEN
    ERROR "got wrong answer from debugger:",deb_arr[1]
    RETURN
  END IF
  LET srcline=deb_arr[3]
  LET currIdx=parse_module_names(srcline)
  IF NOT windowExist("modules") THEN OPEN WINDOW modules WITH FORM "modules" ELSE CURRENT WINDOW IS modules END IF CALL set_current_dialog("modules")
  MESSAGE "Choose a module"
  LET modline=0
  CALL set_count(mod_arr.getLength())
  DISPLAY ARRAY mod_arr TO src.*
    BEFORE DISPLAY
      CALL fgl_set_arr_curr(currIdx)
    ON ACTION find
      CALL do_find("modules","module names")
    ON KEY(Interrupt)
      EXIT DISPLAY
    AFTER DISPLAY
      LET modline = arr_curr()
  END DISPLAY
  CLOSE WINDOW modules CALL remove_dialog_name("modules")
  IF modline<>0 THEN
  -- TQC-640040 begin
    --CALL read_in_source(mod_arr[modline],src_arr,1)
    CALL read_in_source(mod_arr[modline],bsrc_arr,1)
  -- TQC-640040 end
  END IF
END FUNCTION

FUNCTION show_functions(jumpToFunction)
  DEFINE jumpToFunction Integer
  DEFINE funcLine Integer
  DEFINE funcName,file,lineStr String
  CALL get_function_names()
  IF NOT windowExist("functions") THEN OPEN WINDOW functions WITH FORM "functions" ELSE CURRENT WINDOW IS functions END IF CALL set_current_dialog("functions")
  MESSAGE "Choose a function"
  CALL set_count(g_func_arr.getLength())
  DISPLAY ARRAY g_func_arr TO functions.*
    {
    BEFORE DISPLAY
      IF status="running" THEN
        --jump to the currently active function
        LET len=g_func_arr.getLength()
        FOR i=1 TO len
          IF g_func_arr[i]=g_frame_name THEN
            CALL fgl_set_arr_curr(i)
            EXIT FOR
          END IF
        END FOR
      END IF
    }
    BEFORE ROW
      --DISPLAY informations about the function
      LET funcName=g_func_arr[arr_curr()]
      CALL get_function_info(funcName,0) RETURNING file,lineStr
      DISPLAY get_short_filename(file) TO modName
      DISPLAY file TO fileName
      DISPLAY lineStr TO lineNumber
    ON ACTION find
      CALL do_find("functions","function names")
    ON KEY(Interrupt)
      EXIT DISPLAY
    AFTER DISPLAY
      LET funcLine = arr_curr()
  END DISPLAY
  CLOSE WINDOW functions CALL remove_dialog_name("functions")
  IF funcLine<>0 THEN
    LET funcName=g_func_arr[funcline]
    CALL get_function_info(funcName,jumpToFunction) RETURNING file,lineStr
  ELSE
    LET funcName=NULL
  END IF
  RETURN funcName
END FUNCTION

--shows a dialog to manage breakpoints, enable/disable/delete/add/jump to
FUNCTION show_breakpoints()
  DEFINE i,len,breakNum,curr,idx,jumpidx Integer
  DEFINE cmd,restartinput,enabled String
  DEFINE do_restore ,add_count,cmd_count Integer
  DEFINE add_arr DYNAMIC ARRAY OF INTEGER
  DEFINE cmd_arr DYNAMIC ARRAY OF STRING
  DEFINE b2 DYNAMIC ARRAY OF RECORD
    enabled String, breakNum Integer, breakType String, funcName String, lineNumber Integer, modName String, hits Integer, line String, isFunction Integer
  END RECORD
  CALL update_breakpoints()
  IF NOT windowExist("break") THEN OPEN WINDOW break WITH FORM "break" ELSE CURRENT WINDOW IS break END IF CALL set_current_dialog("break")
  MESSAGE "Enable/Disable/Add/Delete Breakpoints"
  LET curr=1
  --look if we invoked the breakpoint window from an actual breakpoint location
  LET len=break_arr.getLength()
  FOR i=1 TO len
    IF break_arr[i].lineNumber=g_line AND
       break_arr[i].modName =g_file_displayed THEN
      LET curr=i
      EXIT FOR
    END IF
  END FOR

  LET cmd_count=1
  LET add_count=1
  FOR i=1 TO len
    LET b2[i].*=break_arr[i].*
  END FOR
  LET restartinput=1
  WHILE restartinput
    LET restartinput=0
    LET idx=0
    CALL set_count(b2.getLength())
    INPUT ARRAY b2 WITHOUT DEFAULTS FROM brk.* ATTRIBUTES(UNBUFFERED,APPEND ROW=0)
      BEFORE INPUT
        CALL fgl_set_arr_curr(curr)
      ON ACTION addbreak
        LET breakNum=do_add_break()
        LET idx=get_breakpoint_index(breakNum)
        IF breakNum<>0 AND idx<>0 THEN
          LET add_arr[add_count]=breakNum
          LET add_count=add_count+1
          LET restartinput=1
          EXIT INPUT
        END IF
      ON ACTION delete
        LET breakNum=b2[arr_curr()].breakNum
        IF breakNum IS NULL THEN
          CONTINUE INPUT
        END IF
        LET cmd_arr[cmd_count]=sfmt("delete %1",breakNum)
        LET cmd_count=cmd_count+1
        IF arr_curr()=b2.getLength() THEN
          CALL fgl_set_arr_curr(arr_curr()-1)
        END IF
        CALL b2.deleteElement(arr_curr())
      ON CHANGE enable
        LET breakNum=b2[arr_curr()].breakNum
        IF breakNum IS NULL THEN
          CONTINUE INPUT
        END IF
        LET enabled=b2[arr_curr()].enabled
        IF enabled="y" THEN
          LET cmd_arr[cmd_count]=sfmt("enable %1",breakNum)
        ELSE
          LET cmd_arr[cmd_count]=sfmt("disable %1",breakNum)
        END IF
        LET cmd_count=cmd_count+1
      ON ACTION deleteAll
        LET len=b2.getLength()
        FOR i=1 TO len
          LET cmd_arr[cmd_count]=sfmt("delete %1",break_arr[i].breakNum)
          LET cmd_count=cmd_count+1
        END FOR
        CALL b2.clear()
        LET curr=1
        LET restartinput=1
        EXIT INPUT
      ON ACTION jumpto
        LET breakNum=b2[arr_curr()].breakNum
        IF breakNum IS NULL THEN
          CONTINUE INPUT
        END IF
        --DISPLAY "jump to breakpoint no:",breakNum
        LET jumpidx=get_breakpoint_index(breakNum)
        EXIT INPUT
      ON ACTION cancel
        -- throw away all changes
        LET do_restore=1
        EXIT INPUT
    END INPUT
    IF restartinput THEN
      IF idx<>0 THEN
        --adding a record here because inside the input this
        --is not possible
        IF b2.getLength()=0 THEN
          LET curr=1
        ELSE
          IF b2[b2.getLength()].breakNum IS NULL THEN
            LET curr=b2.getLength()
          ELSE
            LET curr=b2.getLength()+1
          END IF
        END IF
        LET b2[curr].*=break_arr[idx].*
      END IF
    END IF
  END WHILE
  IF do_restore THEN
    --delete the additional breakpoints
    LET len=add_arr.getLength()
    FOR i=1 TO len
      LET cmd=sfmt("delete %1",add_arr[i])
      CALL deb_write(cmd)
      CALL get_deb_out()
    END FOR
  ELSE
    --perform the accumulated commands
    LET len=cmd_arr.getLength()
    FOR i=1 TO len
      LET cmd=cmd_arr[i]
      CALL deb_write(cmd)
      CALL get_deb_out()
    END FOR
  END IF
  --finally update the breakpoints
  CALL update_breakpoints()
  IF jumpidx<>0 THEN
    CALL jump_to_breakpoint(breakNum)
  END IF
  CLOSE WINDOW break CALL remove_dialog_name("break")
END FUNCTION

FUNCTION do_add_break()
  DEFINE complete_name,answer STRING
  DEFINE breakNumStart, breakNumEnd,breakNum,idxhist,i,len INTEGER
  DEFINE breakNumStr,file,lineStr,browsefunc STRING
  IF NOT windowExist("addbreak") THEN OPEN WINDOW addbreak WITH FORM "addbreak" ELSE CURRENT WINDOW IS addbreak END IF CALL set_current_dialog("addbreak")
  MESSAGE "Adds a breakpoint in a function"
  INPUT BY NAME g_funcName WITHOUT DEFAULTS ATTRIBUTES(UNBUFFERED)
    ON ACTION history_up IF INFIELD(g_funcName) THEN CALL history_up(func_hist_arr,idxhist,g_funcName) RETURNING g_funcName,idxhist END IF ON ACTION history_down IF INFIELD(g_funcName) THEN CALL history_down(func_hist_arr,idxhist,g_funcName) RETURNING g_funcName,idxhist END IF ON ACTION history_show IF INFIELD(g_funcName) THEN CALL history_show(func_hist_arr,idxhist,g_funcName) RETURNING g_funcName,idxhist DISPLAY "g_funcName" , " is ", g_funcName END IF
    ON ACTION browsefunctions
      LET browsefunc=show_functions(0)
      IF browsefunc.getLength()<>0 THEN
        LET g_funcName=browsefunc
      END IF
    ON ACTION lookup
    --ON KEY(Tab)
      --DISPLAY ">>>> KEY TAB !!!"
      IF g_funcName.getLength()>0 THEN
        LET complete_name=complete_function(g_funcName)
        IF complete_name.getLength()>0 THEN
          LET g_funcName=complete_name
        ELSE
          ERROR "Don't find a function beginning with \""||g_funcName||"\""
          LET g_funcName=""
        END IF
      END IF
    ON ACTION accept
      IF g_funcName.getLength()=0 THEN
        CONTINUE INPUT
      END IF
      CALL get_function_info_short(g_funcName,0) RETURNING file,lineStr
      IF file IS NOT NULL THEN
        CALL deb_write(sfmt("break %1:%2",file,lineStr))
        CALL get_deb_out()
        IF deb_arr.getLength()>0 THEN
          LET answer=deb_arr[1]
          IF answer.getIndexOf("Breakpoint",1)<>1 THEN
            ERROR answer
            CONTINUE INPUT
          ELSE
            LET breakNumStart=length("Breakpoint")+2
            LET breakNumEnd=answer.getIndexOf(" ",breakNumStart)
            LET breakNumStr=answer.subString(breakNumStart,breakNumEnd-1)
            LET breakNum=breakNumStr
            CALL history_insert(func_hist_arr,g_funcName)
            CALL update_breakpoints()
            LET len=break_arr.getLength()
            FOR i=1 TO len
              IF break_arr[i].breakNum=breakNum THEN
                LET break_arr[i].line="FUNCTION "||g_funcName
                LET break_arr[i].isFunction=1
                EXIT FOR
              END IF
            END FOR
            EXIT INPUT
          END IF
        END IF
      END IF
  END INPUT
  CLOSE WINDOW addbreak CALL remove_dialog_name("addbreak")
  RETURN breakNum
END FUNCTION

FUNCTION cant_find ()
    ERROR "Cannot find the string \"",srch_search,"\""
    CALL fgl_winMessage("Debugger", "Cannot find the string \""||srch_search||"\" !", "info")
END FUNCTION


FUNCTION do_find(kind,title)
  DEFINE kind STRING
  DEFINE title STRING
  DEFINE found,currRow,idxhist,idxfound Integer
  IF NOT windowExist("search") THEN OPEN WINDOW search WITH FORM "search" ELSE CURRENT WINDOW IS search END IF CALL set_current_dialog("search")
  --please english natives , search for or search in ?
  CALL fgl_settitle(sfmt("Search in %1",title))
  IF srch_updown IS NULL OR srch_updown.getLength()=0 THEN
    LET srch_updown="Down"
  END IF
  -- use unbuffered, otherwise the searchstring is still not yet available in accept
  INPUT BY NAME srch_search, srch_wholeword, srch_matchcase, srch_useMATCHES,srch_updown WITHOUT DEFAULTS ATTRIBUTES(UNBUFFERED)
    ON ACTION history_up IF INFIELD(srch_search) THEN CALL history_up(search_hist_arr,idxhist,srch_search) RETURNING srch_search,idxhist END IF ON ACTION history_down IF INFIELD(srch_search) THEN CALL history_down(search_hist_arr,idxhist,srch_search) RETURNING srch_search,idxhist END IF ON ACTION history_show IF INFIELD(srch_search) THEN CALL history_show(search_hist_arr,idxhist,srch_search) RETURNING srch_search,idxhist DISPLAY "srch_search" , " is ", srch_search END IF
    BEFORE INPUT
      IF kind="help" THEN
        LET srch_updown="Down"
        LET srch_useMATCHES=0
        CALL dialog.setFieldActive("srch_wholeword",0)
        CALL dialog.setFieldActive("srch_usematches",0)
        CALL dialog.setFieldActive("srch_updown",0)
      END IF
    ON ACTION accept
      IF kind="help" THEN
        CALL help_search(FALSE) RETURNING found,idxfound
      ELSE
        CALL int_search(kind,FALSE) RETURNING found, currRow
      END IF
      IF found=0 THEN
        CONTINUE INPUT
      ELSE
        CALL history_insert(search_hist_arr,srch_search)
        EXIT INPUT
      END IF
  END INPUT
  CLOSE WINDOW search CALL remove_dialog_name("search")
  IF found THEN
    IF kind="help" THEN
      CALL fgl_dialog_setcursor(idxfound)
    ELSE
      CALL fgl_set_arr_curr(currRow)
    END IF
  END IF
END FUNCTION

FUNCTION do_findnext(kind)
  DEFINE kind STRING
  DEFINE found, idxfound, currRow Integer
  IF srch_updown IS NULL OR srch_updown.getLength()=0 THEN
    LET srch_updown="Down"
  END IF
  IF kind="help" THEN
    CALL help_search(TRUE) RETURNING found,idxfound
  ELSE
    CALL int_search(kind,TRUE) RETURNING found, currRow
  END IF
END FUNCTION

FUNCTION subtract_newlines(str,pos)
  DEFINE str STRING
  DEFINE pos INTEGER
  DEFINE i,len,numnl,newpos INTEGER
  LET len=str.getLength()
  IF len<pos THEN
    LET pos=len
  END IF
  FOR i=1 TO pos
    IF str.getCharAt(i)="\n" THEN
      LET numnl=numnl+1
    END IF
  END FOR
  LET newpos=pos-numnl
  RETURN newpos
END FUNCTION

FUNCTION remove_newlines(strnl)
  DEFINE strnl STRING
  DEFINE str STRING
  DEFINE idx,old INTEGER
  LET old=1
  WHILE (idx:=strnl.getIndexOf("\n",old))<>0
    LET str=str.append (strnl.subString(old,idx-1))
    LET old=idx+1
  END WHILE
  RETURN str
END FUNCTION

FUNCTION help_search(set_cursor)
  DEFINE set_cursor Integer
  DEFINE found,idxfound,startpos Integer
  DEFINE helpstr STRING
  --LET startpos=subtract_newlines(g_helpstr,g_helpcursor)
  LET startpos=g_helpcursor
  LET helpstr=remove_newlines(g_helpstr)
  WHILE startpos>0 AND NOT found
    IF srch_matchcase THEN
      LET idxfound=helpstr.getIndexOf(srch_search,startpos)
    ELSE
      LET idxfound=getIndexOfI(helpstr,srch_search,startpos)
    END IF
    LET found=idxfound<>0
    IF NOT found THEN
      IF startpos>1 THEN
        --search from the beginning
        LET startpos=1
      ELSE IF startpos=1 THEN
        --bail out
        LET startpos=0
      END IF
      END IF
    END IF
  END WHILE
  IF NOT found THEN
    CALL cant_find()
  ELSE
    --count the newlines and subtract from the cursor position
    --LET idxfound=subtract_newlines(helpstr,idxfound)
    --DISPLAY "helpcursor is ",g_helpcursor,",startpos is ",startpos," idxfound is ",idxfound
    IF set_cursor THEN
      CALL fgl_dialog_setcursor(idxfound)
    END IF
  END IF
  RETURN found,idxfound
END FUNCTION


FUNCTION int_search(kind,set_arr_curr)
  DEFINE kind STRING
  DEFINE set_arr_curr INTEGER
  DEFINE line ,leftChar , rightChar,mess String
  DEFINE i , len , found , currRow , inc , idx INTEGER
  LET currRow= arr_curr()
  -- at this place having virtual function calls would be really nice...
  CASE kind
    WHEN "src"
      LET len = src_arr.getLength()
    WHEN "functions"
      LET len = g_func_arr.getLength()
    WHEN "modules"
      LET len = mod_arr.getLength()
    WHEN "global"
      LET len = global_var_arr.getLength()
    WHEN "local"
      LET len = local_var_arr.getLength()
    OTHERWISE
      LET len = 0
  END CASE
  -- start search one row later or earlier
  IF srch_updown="Down" THEN
    LET inc=1
  ELSE
    LET inc=-1
  END IF
  LET found = FALSE
  --DISPLAY "srch_updown:",srch_updown,",currRow:",currRow,",len:",len
  FOR i=1 TO len
    -- I spent half an hour for the following f... line
    -- It comes not immediately to the mind of a C-programmer :-)
    LET idx=((len+currRow+i*inc-1) MOD len)+1
    -- again,
    -- at this place having virtual function calls would be really nice...
    IF kind="src" THEN
      LET line = src_arr[idx].line
    ELSE IF kind="functions" THEN
      LET line = g_func_arr[idx]
    ELSE IF kind="modules" THEN
      LET line = mod_arr[idx]
    ELSE IF kind="global" THEN
      LET line = global_var_arr[idx].varname
    ELSE IF kind="local" THEN
      LET line = local_var_arr[idx].varname
    ELSE
      DISPLAY "ERROR:can't get line in int_search, wrong kind:",kind
    END IF
    END IF
    END IF
    END IF
    END IF
    --DISPLAY "idx is ",idx,"line is \"",line,"\"line"
    IF srch_matchcase THEN
      IF srch_useMATCHES THEN
        LET found= line MATCHES srch_search
      ELSE
        LET found = line.getIndexOf(srch_search, 1)
      END IF
    ELSE
      LET line = line.toLowerCase()
      IF srch_useMATCHES THEN
        LET found = line MATCHES srch_search.toLowerCase()
      ELSE
        LET found = line.getIndexOf(srch_search.toLowerCase(),1)
      END IF
    END IF
    IF found AND srch_wholeword THEN
      --try to find out if the left side has whitespace or
      IF found > 1 THEN
        LET leftchar=line.getCharAt(found-1)
        IF NOT isDelimiterChar(leftChar) THEN
          LET found=0
        END IF -- not isDelimiterChar()
      END IF -- found > 1
      IF found > 1 AND found<line.getLength() THEN
        LET rightChar=line.getCharAt(found+srch_search.getLength())
        IF NOT isDelimiterChar(rightChar) THEN
          LET found=0
        END IF -- not isDelimiterChar()
      END IF -- found > 1
    END IF -- found AND srch_wholeword
    IF found THEN
      EXIT FOR
    ELSE
      LET mess=""
      IF idx=len AND srch_updown="Down" THEN
        LET mess="Passed the end of the file"
        MESSAGE mess
      ELSE IF idx=0 AND srch_updown="Up" THEN
        LET mess="Passed the begin of the file"
        MESSAGE mess
      END IF
      END IF
    END IF -- found=0
  END FOR
  IF found=0 THEN
    CALL cant_find()
  ELSE
    -- found the item
    IF set_arr_curr THEN
      CALL fgl_set_arr_curr(idx)
    END IF
  END IF
  RETURN found,idx
END FUNCTION

FUNCTION isDelimiterChar(ch)
  DEFINE ch,delimiters String
  DEFINE idx Integer
  --DISPLAY "ch is \"",ch,"\""
  LET delimiters=" \t()[]{}:,;.?!\"'-+/*=&%$^:#~|@"
  LET idx = delimiters.getIndexOf(ch,1)
  RETURN idx<>0
END FUNCTION

FUNCTION isWhiteSpaceChar(ch)
  DEFINE ch STRING
  IF ch IS NOT NULL THEN
    IF ch=" " OR ch="\t" THEN
      RETURN 1
    END IF
  END IF
  RETURN 0
END FUNCTION

FUNCTION isNumberChar(ch)
  DEFINE ch,numbers STRING
  DEFINE idx Integer
  LET numbers="0123456789"
  LET idx = numbers.getIndexOf(ch,1)
  RETURN idx<>0
END FUNCTION

FUNCTION isNumber(str)
  DEFINE str STRING
  DEFINE i,len INTEGER
  LET len=str.getLength()
  FOR i=1 TO len
    IF NOT isNumberChar(str.getCharAt(i)) THEN
      RETURN 0
    END IF
  END FOR
  RETURN 1
END FUNCTION

--this pretty fuzzy function checks if a given string is a valid
--variable name in 4GL or C
FUNCTION isVarName(varname)
  DEFINE varname STRING
  DEFINE i,len,openbrackets,closebrackets,containsbrackets INTEGER
  DEFINE containspointer INTEGER
  DEFINE c,chars,firstchar STRING
  LET len=varname.getLength()
  LET chars=" \t0123456789.[,]->_abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  IF len=0 THEN
    RETURN 0
  END IF
  LET firstchar= varname.getCharAt(1)
  --first character is a number or a delimiter ?
  IF isNumberChar(firstchar) OR isDelimiterChar(firstchar) THEN
     RETURN 0
  END IF
  LET containsbrackets= (varname.getIndexOf("[",1)<>0) AND
                        (varname.getIndexOf("]",1)<>0)
  LET containspointer=g_isgdb AND (varname.getIndexOf("->",1)<>0)
  FOR i=2 TO len
    LET c= varname.getCharAt(i)
    IF chars.getIndexOf(c,1)=0 THEN
      RETURN 0
    END IF
    IF c="-" THEN
      IF g_isgdb AND i<len THEN
        IF varname.getCharAt(i+1)=">" THEN
          LET i=i+1
          CONTINUE FOR
        END IF
      END IF
      RETURN 0
    ELSE
      CASE c
        WHEN ">"
          RETURN 0
        WHEN " "
          IF NOT containsbrackets AND NOT containspointer THEN
            RETURN 0
          END IF
        WHEN "["
          IF closebrackets>openbrackets THEN
            RETURN 0
          END IF
          LET openbrackets=openbrackets+1
        WHEN "]"
          LET closebrackets=closebrackets+1
          IF closebrackets>openbrackets THEN
            RETURN 0
          END IF
        WHEN ","
          --no comma separator in C
          IF g_isgdb THEN
            RETURN 0
          END IF
          --must be between 2 brackets in 4gl
          IF openbrackets=closebrackets THEN
            RETURN 0
          END IF
      END CASE
    END IF
  END FOR
  RETURN 1
END FUNCTION

FUNCTION isCommon_keyword(name)
  DEFINE name STRING
  DEFINE i,len INTEGER
  DEFINE arr DYNAMIC ARRAY OF STRING
  --this list does not need to be complete
  --it just tries to match common cases
  --you can add further keywords here
  --if they disturb autodetecting variables
  --in g_state<>"running"
  LET arr[1]="let"
  LET arr[2]="if"
  LET arr[3]="then"
  LET arr[4]="else"
  LET arr[5]="for"
  LET arr[6]="return"
  LET arr[7]="define"
  LET arr[8]="case"
  LET arr[9]="while"
  IF NOT g_isgdb THEN
    LET arr[10]="declare"
    LET arr[11]="run"
    LET arr[12]="returning"
    LET arr[13]="call"
    LET arr[14]="function"
    LET arr[15]="end"
    LET arr[16]="and"
    LET arr[17]="or"
    LET arr[18]="when"
  END IF
  LET len=arr.getLength()
  LET name=name.toLowerCase()
  FOR i=1 TO len
    IF arr[i]=name THEN
      RETURN 1
    END IF
  END FOR
  RETURN 0
END FUNCTION

FUNCTION fileExists(f)
  DEFINE f STRING
  DEFINE c base.Channel
  DEFINE result Integer
  LET c=base.channel.create()
  --DISPLAY "CALL fileExists ",f," ?"
  WHENEVER ERROR CONTINUE
  CALL c.openFile(f,"r")
  IF status <> 0 THEN
    LET result=0
  ELSE
    LET result=1
    CALL c.close()
  END IF
  WHENEVER ERROR STOP
  RETURN result
{
-- DEFINE f,l_cmd,f1 String
-- DEFINE l_status,i Integer
-- FOR i=1 TO f.getLength()
-- IF f.getCharAt(i)="\\" THEN
-- LET f1=f1.append("/")
-- ELSE
-- LET f1=f1.append(f.getCharAt(i))
-- END IF
-- END FOR
-- LET l_cmd= "ls ",f1," >/dev/null 2>/dev/null"
-- RUN l_cmd RETURNING l_status
-- IF l_status THEN
-- --DISPLAY "command \"",l_cmd,"\" failed!!!!"
-- RETURN 0
-- ELSE
-- RETURN 1
-- END IF
}
END FUNCTION

FUNCTION _getClientName()
  IF g_fename IS NULL THEN
    CALL ui.Interface.frontcall("standard","feinfo", ["fename"],[g_fename])
    IF g_fename="Genero Desktop Client" THEN
      LET g_fename="GDC"
    END IF
  END IF
  RETURN g_fename
END FUNCTION

FUNCTION _setActiveWindow(w)
  DEFINE w String
  DEFINE prevName string
  CALL ui.Interface.frontcall("debugger","setactivewindow", [w],[prevName])
  RETURN prevName
END FUNCTION

FUNCTION _getActiveWindow()
  DEFINE name string
  CALL ui.Interface.frontcall("debugger","getactivewindow", [],[name])
  RETURN name
END FUNCTION

FUNCTION _getDebuggerWindow()
  DEFINE name string
  CALL ui.Interface.frontcall("debugger","getcurrentwindow", [],[name])
  RETURN name
END FUNCTION

FUNCTION raise_debugger(location)
  DEFINE location,prevWindow,version String
  --RETURN
  LET version=ui.interface.getFrontEndVersion()
  --DISPLAY "raise_debugger ",location,",Version",Version
  IF _getClientName() = "GDC" AND version>="1.21.1c-261" AND g_debugger_raised=0 THEN
    --DISPLAY "_setActiveWindow current"
    LET g_debugger_raised=1
    LET prevWindow = _setActiveWindow("current")
    IF prevWindow.getLength()>0 AND prevWindow<>_getDebuggerWindow() THEN
      --store this as application window
      --DISPLAY "set g_debuggee_widget TO ",prevWindow
      LET g_debuggee_widget = prevWindow
    END IF
  END IF
END FUNCTION

FUNCTION raise_debuggee(location)
  DEFINE location String
  DEFINE dummy,version String
  --RETURN
  LET version=ui.interface.getFrontEndVersion()
  --DISPLAY "raise_debugger ",location,",Version",Version
  IF _getClientName() = "GDC" AND version>="1.21.1c-261" AND g_debuggee_widget.getLength()>0 THEN
    --DISPLAY "_setActiveWindow ",g_debuggee_widget
    LET g_debuggee_raised=1
    LET dummy = _setActiveWindow(g_debuggee_widget)
  END IF
  LET g_debugger_raised=0
END FUNCTION

FUNCTION do_about()
  DEFINE mycomment String
  LET mycomment="fgldeb\t: a Front end for \"fglrun -d\"\n\nVersion\t: " || g_version_str || "\n\nBuild\t: " || sfmt("%1",18)
  MENU "About fgldeb" ATTRIBUTES(style="dialog", comment=mycomment ,image="debug_logo")
    COMMAND "OK"
      EXIT MENU
  END MENU
END FUNCTION

--this function decides whats next if a global action was
--pressed in a (modal) dialog
FUNCTION check_dlg_action(action,da_state)
  DEFINE action STRING
  DEFINE da_state,new_state STRING
  DEFINE do_return INTEGER
  LET new_state=da_state
  CASE action
    WHEN "stepinto"
      CURRENT WINDOW IS fgldeb CALL set_current_dialog("fgldeb")
      CALL do_stepinto()
    WHEN "stepover"
      CURRENT WINDOW IS fgldeb CALL set_current_dialog("fgldeb")
      CALL do_stepover()
    WHEN "run"
      CURRENT WINDOW IS fgldeb CALL set_current_dialog("fgldeb")
      CALL do_run()
    WHEN "rerun"
      CURRENT WINDOW IS fgldeb CALL set_current_dialog("fgldeb")
      CALL do_rerun()
    WHEN "stepout"
      CURRENT WINDOW IS fgldeb CALL set_current_dialog("fgldeb")
      CALL do_stepout()
    WHEN "run2cursor"
      CURRENT WINDOW IS fgldeb CALL set_current_dialog("fgldeb")
      CALL do_run2cursor()
    WHEN "viewlocals"
      LET new_state="local_variables"
      LET do_return=1
    WHEN "viewglobals"
      LET new_state="global_variables"
      LET do_return=1
    WHEN "inspectvariable"
      LET new_state="inspectvariable"
      LET do_return=1
    WHEN "viewstack"
      CALL update_stack()
      IF show_stack()=1 THEN
          RETURN 1,da_state
      END IF
  END CASE
  IF new_state=da_state THEN
    LET do_return=0
  END IF
  RETURN do_return,new_state
END FUNCTION

FUNCTION get_variable_names (local_or_global,var_arr,set_values)
  DEFINE local_or_global String
  DEFINE var_arr DYNAMIC ARRAY OF RECORD
    varname String,
    value String,
    modname String
  END RECORD
  DEFINE set_values Integer
  DEFINE i,j,len,eqidx,maxidx,success Integer
  DEFINE str,modname,result STRING
  CALL var_arr.clear()
  IF (local_or_global="local") THEN
    CALL deb_write("info locals")
    CALL get_deb_out()
    IF deb_arr.getLength()=1 THEN
      IF deb_arr[1]="No frame selected." THEN
         RETURN
      END IF
    END IF
    FOR i=1 TO deb_arr_len
      LET str=deb_arr[i]
      LET eqidx=str.getIndexOf(" =",1)
      LET var_arr[i].varname=str.subString(1,eqidx-1)
      IF set_values THEN
        LET maxidx=str.getLength()
        IF (maxidx>eqidx+403) THEN
          LET maxidx=eqidx+403
        END IF
        LET var_arr[i].value=str.subString(eqidx+3,maxidx)
      END IF
    END FOR
  ELSE --global
    CALL deb_write("info variables")
    CALL get_deb_out()
    FOR i=1 TO deb_arr_len
      LET str=deb_arr[i]
      IF str.getLength()=0 THEN
        CONTINUE FOR
      END IF
      IF str.getCharAt(str.getLength())=":" THEN
        IF str.getIndexOf("File ",1)=1 THEN
          LET modname=str.subString(6,str.getLength()-1)
        ELSE
          LET modname=str.subString(1,str.getLength()-1)
          -- module name
        END IF
        CONTINUE FOR
      END IF
      LET j=j+1
      LET eqidx=str.getIndexOf(" ",1)
      LET var_arr[j].varname=str.subString(1,eqidx-1)
      LET var_arr[j].modname=modname
    END FOR
    IF set_values THEN
      LET len=var_arr.getLength()
      FOR i=1 TO len
        CALL get_print_variable(var_arr[i].varname) RETURNING success,result
        LET result=extract_gdb_variable_value(result)
        LET var_arr[i].value=result
      END FOR
    END IF
  END IF
END FUNCTION

FUNCTION get_print_variable(varname)
  DEFINE varname STRING
  DEFINE cmd,result STRING
  DEFINE success INTEGER
  LET cmd=sfmt("print %1",varname)
  CALL deb_write(cmd)
  CALL get_deb_out()
  CALL check_printresult() RETURNING success,result
  RETURN success,result
END FUNCTION

FUNCTION get_function_names ()
  DEFINE i,j,eqidx Integer
  DEFINE str,func STRING
  IF g_function_names_called>0 THEN
    LET g_function_names_called=g_function_names_called+1
    RETURN
  END IF
  CALL g_func_arr.clear()
  CALL deb_write("info functions")
  CALL get_deb_out()
  IF deb_arr.getLength()=1 THEN
    IF deb_arr[1]="No frame selected." THEN
       RETURN
    END IF
  END IF
  LET j=1
  FOR i=1 TO deb_arr_len
    LET str=deb_arr[i]
    LET eqidx=str.getIndexOf("()",1)
    LET func=str.subString(1,eqidx-1)
    --exclude some cases
    IF func.getLength()=0 THEN
      CONTINUE FOR
    END IF
    IF func="<initializer>" THEN
      CONTINUE FOR
    END IF
    IF func.getIndexOf("native ",1)=1 THEN
      CONTINUE FOR
    END IF
    LET g_func_arr[j]=func
    LET j=j+1
  END FOR
  LET g_function_names_called=1
END FUNCTION

FUNCTION display_variables(title,local_or_global,var_arr)
  DEFINE title STRING
  DEFINE local_or_global STRING
  DEFINE var_arr DYNAMIC ARRAY OF RECORD
    varname String,
    value String,
    modname String
  END RECORD
  DEFINE action STRING
  CALL fgl_settitle(title)
  LET action="noaction"
  DISPLAY ARRAY var_arr TO variables.* ATTRIBUTES(UNBUFFERED)
    ON ACTION stepinto LET action="stepinto" EXIT DISPLAY ON ACTION stepover LET action="stepover" EXIT DISPLAY ON ACTION stepout LET action="stepout" EXIT DISPLAY ON ACTION run LET action="run" EXIT DISPLAY ON ACTION rerun LET action="rerun" EXIT DISPLAY ON ACTION run2cursor LET action="run2cursor" EXIT DISPLAY
    ON ACTION accept
        LET action="inspectvariable"
        LET g_inspectvariable_name=var_arr[arr_curr()].varname
        EXIT DISPLAY
    ON ACTION viewlocals
        IF local_or_global="global" THEN
          LET action="viewlocals"
          EXIT DISPLAY
        END IF
    ON ACTION viewglobals
        IF local_or_global="local" THEN
          LET action="viewglobals"
          EXIT DISPLAY
        END IF
    ON ACTION viewstack
        LET action="viewstack"
        EXIT DISPLAY
    ON ACTION find
        IF local_or_global="local" THEN
          CALL do_find("local","local variables")
        ELSE
          CALL do_find("global","global variables")
        END IF
    ON ACTION findnext
        IF local_or_global="local" THEN
          CALL do_findnext("local")
        ELSE
          CALL do_findnext("global")
        END IF
  END DISPLAY
  RETURN action
END FUNCTION

FUNCTION showvariables (local_or_global)
  DEFINE local_or_global String
  DEFINE title String
  DEFINE da_state,action String
  DEFINE do_return Integer
  IF (local_or_global="local") THEN
    LET title=sfmt("Local Variables of %1",g_frame_name)
    CALL get_variable_names("local",local_var_arr,1)
    IF NOT windowExist("local_variables") THEN OPEN WINDOW local_variables WITH FORM "variables" ELSE CURRENT WINDOW IS local_variables END IF CALL set_current_dialog("local_variables")
    CALL set_count(local_var_arr.getLength())
    LET action=display_variables(title,local_or_global,local_var_arr)
  ELSE
    LET title="Global Variables"
    CALL get_variable_names("global",global_var_arr,1)
    IF NOT windowExist("global_variables") THEN OPEN WINDOW global_variables WITH FORM "variables" ELSE CURRENT WINDOW IS global_variables END IF CALL set_current_dialog("global_variables")
    CALL set_count(local_var_arr.getLength())
    LET action=display_variables(title,local_or_global,global_var_arr)
  END IF
  LET da_state=local_or_global||"_variables"
  CALL check_dlg_action(action,da_state)
         RETURNING do_return,da_state
  --DISPLAY "check_dlg_state in showvar returned ",do_return," ",da_state
  IF do_return THEN
    RETURN da_state
  END IF
  IF action = "noaction" THEN
    IF local_or_global="local" THEN
      CLOSE WINDOW local_variables CALL remove_dialog_name("local_variables")
    ELSE
      CLOSE WINDOW global_variables CALL remove_dialog_name("global_variables")
    END IF
    --DISPLAY "close end of showvariables,current window is ", get_current_dialog()
    --DISPLAY "stack is \"", get_current_window_stack() , "\""
    --LET da_state="fgldeb"
    LET da_state=get_current_dialog()
  END IF
  --DISPLAY "showvariables:",local_or_global," action is ",action," da_state is ",da_state
  RETURN da_state
END FUNCTION

-- this function tries to detect, if the variable contains an array range
-- for example foo[1:20] or foo[8:4].bar
-- returns either the range in from, to or -1,-1
FUNCTION parse_range(variable)
  DEFINE variable STRING
  DEFINE rangestr,oldstate,state,tostr,fromstr,c,newvar,arrayname STRING
  DEFINE i, len, from , to ,arrleft,arrright INTEGER
  LET arrleft = variable.getIndexOf("[",1)
  LET arrright = variable.getIndexOf("]",1)
  IF arrleft=0 OR arrright=0 OR arrleft>arrright THEN
    RETURN -1,-1,"",""
  END IF
  LET arrayname=variable.subString(1,arrleft-1)

  FOR i=arrleft+1 TO arrright-1
    LET c=variable.getCharAt(i)
    IF c<>" " THEN
      LET rangestr = rangestr.append(c)
    END IF
  END FOR
  --DISPLAY "rangestr=",rangestr
  LET state="from"
  LET len=rangestr.getLength()
  FOR i=1 TO len
    LET c=rangestr.getCharAt(i)
    LET oldstate=state
    IF isNumberChar(c) THEN
      CASE state
        WHEN "from"
          LET fromstr=fromstr.append(c)
        WHEN "to"
          LET tostr=tostr.append(c)
        WHEN "colon"
          LET state="to"
          LET tostr=tostr.append(c)
      END CASE
    ELSE IF c=":" THEN
      IF state="from" THEN
        LET from = fromstr
      ELSE
        --DISPLAY "wrong state :",state
        RETURN -1,-1,"",arrayname
      END IF
      LET state="colon"
    ELSE
      --DISPLAY "found wrong character \"",c,"\" , no range"
      RETURN -1,-1,"",""
    END IF
    END IF
    --DISPLAY "character \"",c,"\" old:",oldstate," new:",state
  END FOR
  IF state="from" THEN
    --normal array index without colon
    LET from = fromstr
    IF from=0 THEN
      LET from=1
    END IF
    RETURN from,from,"",arrayname
  END IF
  IF state<>"to" THEN
    --DISPLAY "wrong endstate \"",state,"\" must be \"to\""
    RETURN -1,-1,"",arrayname
  END IF
  LET to = tostr
  IF from = 0 THEN
    LET from=1
  END IF
  IF to = 0 THEN
    LET to=1
  END IF
  IF from=to THEN
    RETURN from,from,sfmt("%1[%2]",arrayname,from),arrayname
  END IF
  LET newvar = variable.subString(1,arrleft)
  LET newvar = newvar.append("%1")
  LET newvar = newvar.append(variable.subString(arrright,variable.getLength()))
  --DISPLAY "got from:",from," to:",to," newvar:",newvar
  RETURN from,to,newvar,arrayname
END FUNCTION

{
FUNCTION fillstep(rangevar,i)
  DEFINE rangevar,istr STRING
  DEFINE i INTEGER
  LET idx=rangevar.getIndexOf("@",1)
  LET stepvar=sfmt(rangevar,i)
  LET istr=i
END FUNCTION
}

FUNCTION complete_variable(varname)
  DEFINE varname,v,result STRING
  DEFINE var_arr DYNAMIC ARRAY OF RECORD
    varname String,
    value String,
    modname String
  END RECORD
  DEFINE result_arr DYNAMIC ARRAY OF RECORD
    varname String,
    global Integer
  END RECORD
  DEFINE i,g,k,len Integer
  LET varname=varname.toLowerCase()
  --DISPLAY "varname is ",varname
  FOR g=0 TO 1
    IF g=0 THEN
      CALL get_variable_names ("local",var_arr,0)
    ELSE
      CALL get_variable_names ("global",var_arr,0)
    END IF
    LET len=var_arr.getLength()
    --DISPLAY "var_arr len is ",len
    FOR i=1 TO len
      LET v=var_arr[i].varname
      --DISPLAY "v[",i,"] is ",v
      LET v=v.toLowerCase()
      IF v.getIndexOf(varname,1) = 1 THEN
        LET k=k+1
        --DISPLAY "add variable \"",v,"\" at ",k
        LET result_arr[k].varname=v
        LET result_arr[k].global =g
      END IF
    END FOR
  END FOR
  --DISPLAY "k is ",k
  CASE k
    WHEN 0
      LET result=""
    WHEN 1
      LET result=result_arr[1].varname
    OTHERWISE
      IF NOT windowExist("complete_variable") THEN OPEN WINDOW complete_variable WITH FORM "complete_variable" ELSE CURRENT WINDOW IS complete_variable END IF CALL set_current_dialog("complete_variable")
      CALL set_count(k)
      DISPLAY ARRAY result_arr TO complete_variable.* ATTRIBUTES(UNBUFFERED)
        ON ACTION accept
          LET result=result_arr[arr_curr()].varname
          EXIT DISPLAY
      END DISPLAY
      CLOSE WINDOW complete_variable CALL remove_dialog_name("complete_variable")
  END CASE
  RETURN result
END FUNCTION

FUNCTION complete_function(funcName)
  DEFINE funcName,v,result STRING
  DEFINE result_arr DYNAMIC ARRAY OF RECORD
    funcName String
  END RECORD
  DEFINE i,k,len Integer
  LET funcName=funcName.toLowerCase()
  --DISPLAY "funcName is ",funcName
  CALL get_function_names ()
  LET len=g_func_arr.getLength()
  --DISPLAY "g_func_arr len is ",len
  FOR i=1 TO len
    LET v=g_func_arr[i]
    --DISPLAY "v[",i,"] is ",str
    LET v=v.toLowerCase()
    IF v.getIndexOf(funcName,1) = 1 THEN
      LET k=k+1
      --DISPLAY "add variable \"",v,"\" at ",k
      LET result_arr[k].funcName=v
    END IF
  END FOR
  --DISPLAY "k is ",k
  CASE k
    WHEN 0
      LET result=""
    WHEN 1
      LET result=result_arr[1].funcName
    OTHERWISE
      IF NOT windowExist("complete_function") THEN OPEN WINDOW complete_function WITH FORM "complete_function" ELSE CURRENT WINDOW IS complete_function END IF CALL set_current_dialog("complete_function")
      CALL set_count(k)
      DISPLAY ARRAY result_arr TO complete_function.* ATTRIBUTES(UNBUFFERED)
        ON ACTION accept
          LET result=result_arr[arr_curr()].funcName
          EXIT DISPLAY
      END DISPLAY
      CLOSE WINDOW complete_function CALL remove_dialog_name("complete_function")
  END CASE
  RETURN result
END FUNCTION

FUNCTION check_printresult()
  DEFINE result,line STRING
  DEFINE success INTEGER
  IF deb_arr.getLength()<1 THEN
    RETURN success,result
  END IF
  LET line=deb_arr[1]
  IF line.getIndexOf("No symbol \"",1)=1 THEN
    LET result=line
  ELSE IF line.getIndexOf("Symbol \"",1)=1 THEN
    LET result=line
  ELSE IF line.getIndexOf("An execution error in expression:",1)=1 THEN
    LET result="ERROR"
    LET result=result.append(":")
    LET result=result.append(deb_arr[2])
    IF deb_arr[2].getIndexOf("An array variable has been referenced",1)<> 0 THEN
       CALL get_variable_names("global",global_var_arr,0)
       IF global_var_arr.getLength()>0 THEN
         CALL deb_write(sfmt("print %1",global_var_arr[1].varname))
         CALL get_deb_out()
       END IF
    END IF
  ELSE IF line.getIndexOf("A parse error in expression.",1)=1 THEN
    LET result=line
  ELSE
    LET success=1
    LET result=line
  END IF
  END IF
  END IF
  END IF
  RETURN success,result
END FUNCTION


FUNCTION get_variable_substring_intern(varname,result,from,to)
  DEFINE varname,result,strvalue,func STRING
  DEFINE from,to INTEGER
  LET result=extract_gdb_variable_value(result)
  IF result.getCharAt(1)<>"\"" THEN
    --this is not a string
    RETURN ""
  END IF
  LET strvalue=result.subString(2,result.getLength()-1)
  LET strvalue=strvalue.subString(from,to)
  IF from=to THEN
    LET func=sfmt("getCharAt(%1)",from)
  ELSE
    LET func=sfmt("subString(%1,%2)",from,to)
  END IF
  LET strvalue=sfmt("%1.%2 = \"%3\"",varname,func,strvalue)
  RETURN strvalue
END FUNCTION

FUNCTION get_variable_substring(varname,result,from,to)
  DEFINE varname,result,oldResult STRING
  DEFINE from,to,success INTEGER
  LET oldResult=result
  --we tried perhaps to get the nth character of a string
  CALL get_print_variable(varname) RETURNING success, result
  IF success THEN
    LET result=get_variable_substring_intern(varname,result,from,to)
    IF result IS NULL THEN
      LET result=oldResult
    END IF
  ELSE
    LET result=oldResult
  END IF
  RETURN success,result
END FUNCTION

--opens up a dialog for inspecting variables, adding and deleting them
--from the watch list
FUNCTION inspectvariable(update_immediate)
  DEFINE update_immediate Integer
  DEFINE result,action,singleres STRING
  DEFINE complete_name,da_state STRING
  DEFINE i,len,go_out,idxhist,insert_in_history Integer
  DEFINE success,numerrors,do_update_watch Integer
  DEFINE var_arr DYNAMIC ARRAY OF STRING
  DEFINE do_return Integer
  IF NOT windowExist("inspectvariable") THEN OPEN WINDOW inspectvariable WITH FORM "inspectvariable" ELSE CURRENT WINDOW IS inspectvariable END IF CALL set_current_dialog("inspectvariable")
  --CALL ui.Form.loadActionDefaults()
  --LET g_inspectvariable_update_immediate=update_immediate
  WHILE NOT go_out
    LET action="noaction"
    LET do_update_watch=0
    IF NOT update_immediate=1 THEN
      INPUT BY NAME g_inspectvariable_name,g_inspectvariable_value
        WITHOUT defaults
        HELP 4711
        ATTRIBUTES(UNBUFFERED)
        BEFORE INPUT
          CALL update_watch()
        ON ACTION history_up IF INFIELD(g_inspectvariable_name) THEN CALL history_up(inspectvar_hist_arr,idxhist,g_inspectvariable_name) RETURNING g_inspectvariable_name,idxhist END IF ON ACTION history_down IF INFIELD(g_inspectvariable_name) THEN CALL history_down(inspectvar_hist_arr,idxhist,g_inspectvariable_name) RETURNING g_inspectvariable_name,idxhist END IF ON ACTION history_show IF INFIELD(g_inspectvariable_name) THEN CALL history_show(inspectvar_hist_arr,idxhist,g_inspectvariable_name) RETURNING g_inspectvariable_name,idxhist DISPLAY "g_inspectvariable_name" , " is ", g_inspectvariable_name END IF
        ON ACTION stepinto LET action="stepinto" EXIT INPUT ON ACTION stepover LET action="stepover" EXIT INPUT ON ACTION stepout LET action="stepout" EXIT INPUT ON ACTION run LET action="run" EXIT INPUT ON ACTION rerun LET action="rerun" EXIT INPUT ON ACTION run2cursor LET action="run2cursor" EXIT INPUT
        ON KEY(Interrupt)
          LET go_out=1
          LET g_inspectvariable_name=""
          EXIT INPUT
        ON ACTION grab
          CURRENT WINDOW IS fgldeb CALL set_current_dialog("fgldeb")
          --LET foundvar=tryfindvar_on_currline()
          LET da_state=do_grab_variables_from("inspectvariable")
          CURRENT WINDOW IS inspectvariable CALL set_current_dialog("inspectvariable")
          IF g_inspectvariable_name IS NOT NULL THEN
            EXIT INPUT
          ELSE
            DISPLAY "didn't find a variable on the current line"
          END IF
        ON ACTION viewlocals
          LET action="viewlocals"
          EXIT INPUT
        ON ACTION viewglobals
          LET action="viewglobals"
          EXIT INPUT
        --ON KEY(Tab)
        ON ACTION lookup
          --DISPLAY ">>>> KEY TAB !!!"
          IF g_inspectvariable_name.getLength()>0 THEN
            LET complete_name=complete_variable(g_inspectvariable_name)
            IF complete_name.getLength()>0 THEN
              LET g_inspectvariable_name=complete_name
              EXIT INPUT
            ELSE
              ERROR "Don't find a variable beginning with \""||g_inspectvariable_name||"\""
              LET g_inspectvariable_name=""
            END IF
          END IF
        ON ACTION addwatch
          IF length(g_inspectvariable_name) <> 0 THEN
            CALL split_vars(g_inspectvariable_name,var_arr)
            LET len=var_arr.getLength()
            FOR i=1 TO len
              CALL add_watch(var_arr[i])
            END FOR
            LET do_update_watch=1
            EXIT INPUT
          END IF
        ON ACTION delwatch
          IF length(g_inspectvariable_name) <> 0 THEN
            CALL split_vars(g_inspectvariable_name,var_arr)
            LET len=var_arr.getLength()
            FOR i=1 TO len
              CALL delete_watch(var_arr[i])
            END FOR
            LET do_update_watch=1
            EXIT INPUT
          END IF
        ON ACTION viewwatchlist
          LET da_state=do_view_watches_from("inspectvariable")
        --ON ACTION help
          --CALL help_dialog(INSPECT_HELP)
      END INPUT
      --LET prevWin=get_current_dialog()
      CALL check_dlg_action(action,"inspectvariable")
         RETURNING do_return,da_state
      IF do_return THEN
        RETURN da_state
      END IF
    --DISPLAY "g_inspectvariable_name is ",g_inspectvariable_name
    END IF
    LET update_immediate=0
    LET numerrors=0
    IF length(g_inspectvariable_name) <> 0 THEN
      IF do_update_watch THEN
        CALL update_watch()
      END IF
      CALL split_vars(g_inspectvariable_name,var_arr)
      LET result=""
      LET len=var_arr.getLength()
      FOR i=1 TO len
        CALL parse_variable(var_arr[i]) RETURNING success,singleres
        IF NOT success THEN
          LET numerrors=numerrors+1
        END IF
        LET result=result.append(singleres)
      END FOR
      IF numerrors=var_arr.getLength() THEN
        LET insert_in_history=0
      ELSE
        LET insert_in_history=1
      END IF
      {
      IF g_state="initial" OR g_state="stopped" THEN
        LET result="Program is not running"
      END IF
      }
      IF insert_in_history THEN
        CALL history_insert(inspectvar_hist_arr,g_inspectvariable_name)
      END IF
      --DISPLAY "result IS ", result
      CURRENT WINDOW IS inspectvariable CALL set_current_dialog("inspectvariable")
      LET g_inspectvariable_value=result
      DISPLAY result TO g_inspectvariable_value
    END IF
    IF action<>"noaction" THEN
       --CURRENT WINDOW IS fgldeb CALL set_current_dialog("fgldeb")
       RETURN "inspectvariable"
    END IF
  END WHILE
  CLOSE WINDOW inspectvariable CALL remove_dialog_name("inspectvariable")
  --DISPLAY "end of inspectvariable ,current dialog is ", get_current_dialog()
  --DISPLAY "stack is \"", get_current_window_stack() , "\""
  --RETURN "fgldeb"
  RETURN get_current_dialog()
END FUNCTION

--heavyweight func to figure out the variable
FUNCTION parse_variable(varname)
  DEFINE varname STRING
  DEFINE result,rangevar,stepresult,stepvar,arrayname STRING
  DEFINE success,success2,prefix Integer
  DEFINE tmp String
  DEFINE i,insert_in_history,from,to,step Integer

  CALL parse_range(varname) RETURNING from,to,rangevar,arrayname
  LET insert_in_history=0
  LET result=""
  IF from=-1 OR to=-1 OR from=to THEN
    --retrieve the variable value(s)
    IF rangevar IS NOT NULL THEN
      CALL get_print_variable(rangevar) RETURNING success,result
    ELSE
      CALL get_print_variable(varname) RETURNING success, result
    END IF
    IF success THEN
      --DISPLAY "deb_arr[1]=",deb_arr[1]
      LET result=extract_gdb_variable_value(result)
      --DISPLAY "result=",result
      LET result=parse_gdb_variable(varname,result)
    ELSE
      --debugger reported an error
      LET prefix=1
      IF result.getIndexOf("is not an array",1)<>0 AND
          arrayname IS NOT NULL AND from>0 THEN
        CALL get_variable_substring(arrayname,result,from,to)
          RETURNING success2,result
        IF success2 THEN
          LET prefix=0
        END IF
      END IF
    END IF
  ELSE
    IF to<from THEN
      LET step=-1
    ELSE
      LET step= 1
    END IF
    FOR i=from TO to STEP step
      LET stepvar=sfmt(rangevar,i)
      CALL get_print_variable(stepvar) RETURNING success, stepresult
      IF NOT success THEN
        LET prefix=1
        IF stepresult.getIndexOf("is not an array",1)<>0 AND
          arrayname IS NOT NULL AND from>0 THEN
          CALL get_variable_substring(arrayname,stepresult,from,to) RETURNING
              success2,result
          IF success2 THEN
            LET success=success2
            LET prefix=0
          END IF
        ELSE
          LET result=stepresult
        END IF
        EXIT FOR
      ELSE
        LET stepresult=extract_gdb_variable_value(stepresult)
        --DISPLAY "result=",stepresult
        LET stepresult=parse_gdb_variable(stepvar,stepresult)
      END IF
      LET result=result.append(stepresult)
    END FOR
  END IF
  IF prefix THEN
    LET tmp=result
    LET result=sfmt("%1 :%2",varname,tmp)
  END IF
  RETURN success,result
END FUNCTION

--splits a string separated by semicolon or white space into
--the given array
FUNCTION split_vars(str,var_arr)
  DEFINE str STRING
  DEFINE var_arr DYNAMIC ARRAY OF STRING
  DEFINE var_count,i,len,check_newvar INTEGER
  DEFINE singlevar,state,c STRING
  CALL var_arr.clear()
  LET var_count=1
  LET singlevar=""
  LET state="startvar"
  LET len=str.getLength()
  FOR i=1 TO len
    LET c=str.getCharAt(i)
    LET check_newvar=0
    CASE c
      WHEN " "
        LET check_newvar=1
      WHEN ";"
        LET check_newvar=1
      OTHERWISE
        LET singlevar=singlevar.append(c)
        LET state="invar"
    END CASE
    IF check_newvar AND state="invar" AND singlevar.getLength()>0 THEN
        LET var_arr[var_count]=singlevar
        LET var_count=var_count+1
        LET singlevar=""
        LET state="startvar"
    END IF
  END FOR
  IF state="invar" AND singlevar.getLength()>0 THEN
      LET var_arr[var_count]=singlevar
  END IF
END FUNCTION

FUNCTION windowExist(name)
  DEFINE name String
  DEFINE rootNode,ch om.DomNode
  LET rootNode=ui.Interface.getRootNode()
  LET ch= rootNode.getFirstChild()
  WHILE ch IS NOT NULL
    IF ch.getTagName()="Window" AND ch.getAttribute("name")=name THEN
      RETURN 1
    END IF
    LET ch=ch.getNext()
  END WHILE
  RETURN 0
END FUNCTION


--case insensitive version of string.getIndexOf
FUNCTION getIndexOfI(src,pattern,idx)
  DEFINE src,pattern STRING
  DEFINE idx INTEGER
  LET src=src.toLowerCase()
  LET pattern=pattern.toLowerCase()
  RETURN src.getIndexOf(pattern,idx)
END FUNCTION

--adds a variable found on a source code line to the
--given array of variable names by removing spaces in
--the variable name and testing for duplicates
FUNCTION append_autodetect_var(var_arr,varname)
  DEFINE var_arr DYNAMIC ARRAY OF STRING
  DEFINE varname STRING
  DEFINE found INTEGER
  LET varname=remove_spaces(varname)
  LET found=find_var_name(varname,var_arr,var_arr.getLength())
  --comment these lines if you are interested in
  --autodetecting variables with the same same like
  --keywords
  IF g_state<>"running" THEN
    IF found=0 THEN
      IF isCommon_keyword(varname) THEN
        LET found=1
      END IF
    END IF
  END IF
  IF found=0 THEN
    LET var_arr[var_arr.getLength()+1]=varname
  END IF
END FUNCTION

--this bloody function tries to find ALL variables on a source line
--it splits the line into identifiers,
--feeds them in "print" statements to the debugger and looks if the
--identifiers were actually variables ...
--the result is left in input_arr
FUNCTION grab_variables(input_arr)
  DEFINE input_arr DYNAMIC ARRAY OF STRING
  DEFINE line,c String
  DEFINE var_arr DYNAMIC ARRAY OF String
  DEFINE startbrackets DYNAMIC ARRAY OF INTEGER
  DEFINE varname,insidevar,quote_value,nextchars,result STRING
  DEFINE i,bracketcount,len,bs_state,quote_state,var_append INTEGER
  DEFINE startidx,dot_seen,success INTEGER
  LET len=input_arr.getLength()
  FOR i=1 TO len
    LET var_arr[i]=input_arr[i]
  END FOR
  CALL input_arr.clear()
  LET line=src_arr[g_line].line
  --it uses btw the same kind of statemachine like in parse_gdb_variable
  LET len=line.getLength()
  FOR i=1 TO len
    LET c=line.getCharAt(i)
    IF bs_state THEN
      IF quote_state THEN
        LET quote_value=quote_value.append(c)
      ELSE
        --DISPLAY c," sign after backslash misplaced"
      END IF
      LET bs_state=0
      CONTINUE FOR
    END IF
    LET var_append=0
    CASE c
      WHEN "\""
        IF NOT quote_state THEN
          LET quote_state = 1
          LET quote_value=""
          LET var_append=1
        ELSE
          LET quote_state=0
          --DISPLAY "quoted string was: \"",quote_value,"\""
        END IF
      WHEN "\\"
        IF quote_state THEN
          IF NOT bs_state THEN
            LET bs_state = 1
          ELSE
            LET bs_state = 0
          END IF
          LET quote_value=quote_value.append("\\")
        ELSE
          LET var_append=1
        END IF
      WHEN "-"
        IF g_isgdb AND i+1<=len THEN
          IF line.getCharAt(i+1)=">" THEN
            LET i=i+1
            CONTINUE FOR
          END IF
        END IF
        LET var_append=1
      WHEN "."
        IF quote_state THEN
          LET quote_value=quote_value.append(c)
        ELSE
          LET dot_seen=1
          LET varname=varname.append(c)
        END IF
      WHEN "\t"
        GOTO :space
      WHEN " "
        LABEL space:
        IF quote_state THEN
          LET quote_value=quote_value.append(c)
        ELSE
          LET nextChars=line.subString(i+1,line.getLength())
          LET nextChars=remove_leading_spaces(nextChars)
          IF bracketcount>0 OR dot_seen OR
              (bracketcount=0 AND
                (nextChars.getIndexOf("[",1)=1 ) OR
                (nextChars.getIndexOf(".",1)=1 ) OR
                (g_isgdb AND nextChars.getIndexOf("->",1)=1)) THEN
            {
            WHILE i+1 <= len
              IF isWhiteSpaceChar(line.getCharAt(i+1)) THEN
                LET i=i+1
                IF varname.getLength()>0 THEN
                  LET varname=varname.append(c)
                END IF
                IF bracketcount>0 THEN
                  LET startbrackets[bracketcount]=
                      startbrackets[bracketcount]-1
                END IF
              ELSE
                EXIT WHILE
              END IF
            END WHILE
            }
            CONTINUE FOR
          ELSE
            LET var_append=1
          END IF
        END IF
      WHEN "["
        IF quote_state THEN
          LET quote_value=quote_value.append(c)
        ELSE
          LET bracketcount=bracketcount+1

          --IF dot_seen AND varname.getLength()>0 THEN
          --DISPLAY "varname is \"",varname,"\",startidx=",startidx
          -- LET startbrackets[bracketcount]=i-varname.getLength()
          --ELSE
          LET startbrackets[bracketcount]=startidx
          --END IF
          LET dot_seen=0
          LET varname=""
        END IF
      WHEN "]"
        IF quote_state THEN
          LET quote_value=quote_value.append(c)
        ELSE
          LET dot_seen=0
          IF bracketcount>0 and bracketcount<=startbrackets.getLength() THEN
            IF isVarName(varname) THEN
              CALL append_autodetect_var(var_arr,varname)
            END IF
            LET insidevar=line.subString(startbrackets[bracketcount],i)
            IF isVarName(insidevar) THEN
              --DISPLAY "insidevar IS ",insidevar
              IF bracketcount=1 AND i+1<=len THEN
                --do nothing
                LET varname=insidevar
                LET startidx=startbrackets[bracketcount]
              ELSE
                CALL append_autodetect_var(var_arr,insidevar)
              END IF
            END IF
          END IF
          IF bracketcount>0 THEN
            CALL startbrackets.deleteElement(bracketcount)
            LET bracketcount=bracketcount-1
          END IF
        END IF
      WHEN "("
        --function call
        IF quote_state THEN
          LET quote_value=quote_value.append(c)
        ELSE
          IF g_state<>"running" THEN
            LET varname=""
            LET dot_seen=0
          ELSE
            LET var_append=1
          END IF
        END IF
      WHEN "{" LET var_append=1
      WHEN "}" LET var_append=1
      WHEN "/" LET var_append=1
      WHEN "*" LET var_append=1
      WHEN "<" LET var_append=1
      WHEN ">" LET var_append=1
      WHEN "=" LET var_append=1
      WHEN "+" LET var_append=1
      WHEN ")" LET var_append=1
      WHEN ";" LET var_append=1
      WHEN "," LET var_append=1
      OTHERWISE
        IF quote_state THEN
          LET quote_value=quote_value.append(c)
        ELSE
          LET dot_seen=0
          LET varname=varname.append(c)
          IF varname.getLength()=1 THEN
            LET startidx=i
          END IF
        END IF
    END CASE
    IF var_append THEN
      IF quote_state THEN
        LET quote_value=quote_value.append(c)
      ELSE
        LET dot_seen=0
        IF isVarName(varname) THEN
          CALL append_autodetect_var(var_arr,varname)
        END IF
        LET varname=""
      END IF
    END IF
    --DISPLAY "i:",i," c:",c," varname:",varname
  END FOR
  IF isVarName(varname) THEN
    CALL append_autodetect_var(var_arr,varname)
  END IF
  LET len=var_arr.getLength()
  IF g_state="running" THEN
    FOR i=1 TO len
      CALL get_print_variable(var_arr[i]) RETURNING success,result
      IF success THEN
        LET input_arr[input_arr.getLength()+1]=var_arr[i]
      END IF
    END FOR
  ELSE
    FOR i=1 TO len
      LET input_arr[input_arr.getLength()+1]=var_arr[i]
    END FOR
  END IF
  LET len=input_arr.getLength()
  --FOR i=1 TO len
  -- DISPLAY "var [",i,"]=",input_arr[i]
  --END FOR
END FUNCTION

FUNCTION tryfindvar_on_currline()
  RETURN 0
END FUNCTION

--this even more bloody function extracts the record information
--from gdb formatted print statements
FUNCTION parse_gdb_variable(variable,line)
  DEFINE variable,line String
  DEFINE c CHAR
  DEFINE levelstart DYNAMIC ARRAY OF INTEGER
  DEFINE countarr DYNAMIC ARRAY OF INTEGER
  DEFINE levelhasvarname DYNAMIC ARRAY OF INTEGER
  DEFINE varnames DYNAMIC ARRAY OF STRING
  DEFINE level,i Integer
  DEFINE maxlevel Integer
  DEFINE levelstr,varname,value String
  DEFINE bs_state ,quote_state,len Integer
  DEFINE res,result String

  --LET level=1
  --LET count_arr[level]=0
  LET len=line.getLength()
  FOR i=1 TO len
   LET c=line.getCharAt(i)
   IF bs_state THEN
     IF quote_state THEN
       LET value=value.append(c)
     ELSE
       DISPLAY c," sign after backslash misplaced"
     END IF
     LET bs_state=0
     CONTINUE FOR
   END IF
   CASE c
     WHEN "{"
       IF quote_state THEN
         LET value=value.append(c)
       ELSE
         IF varname IS NOT NULL THEN
           LET levelhasvarname[level]=1
         END IF
         LET level=level+1
         IF level>maxlevel THEN
           LET maxlevel=1
         END IF
         LET levelstart[level]=i
         LET countarr[level]=0
         LET levelhasvarname[level]=0
       END IF
     WHEN "}"
       IF quote_state THEN
         LET value=value.append(c)
       ELSE
         LET levelstr=line.subString(levelstart[level],i)
         --DISPLAY "string for level ",level," is \"",levelstr,"\""
         IF varname IS NOT NULL THEN
           LET levelhasvarname[level]=1
           --DISPLAY "\} recognized varname+value :",varname,"=",value
         ELSE
           --DISPLAY "\} recognized only value :",value
         END IF
         IF level=1 AND varname IS NULL AND value IS NOT NULL THEN
           LET res=sfmt("%1[%2] = %3\n",variable,countarr[level]+1,value)
           LET result=result.append(res)
         ELSE IF level=1 AND varname IS NOT NULL AND value IS NOT NULL THEN
           LET res=sfmt("%1.%2 = %3\n",variable,varname,value)
           LET result=result.append(res)
         ELSE IF level=2 THEN
           IF levelhasvarname[level-1]=0 THEN
             LET res=sfmt("%1[%2] = %3\n",variable,countarr[level-1]+1,levelstr)
             LET result=result.append(res)
           ELSE
             LET res=sfmt("%1.%2 = %3\n",variable,varnames[level-1],levelstr)
             LET result=result.append(res)
           END IF
         END IF
         END IF
         END IF
         LET countarr[level]=countarr[level]+1
         LET level=level-1
         LET varname=""
         LET value=""
       END IF
     WHEN "\""
       IF NOT quote_state THEN
         LET quote_state = 1
       ELSE
         LET quote_state=0
       END IF
       LET value=value.append(c)
     WHEN "\\"
       IF quote_state THEN
         IF NOT bs_state THEN
           LET bs_state = 1
         ELSE
           LET bs_state = 0
         END IF
         LET value=value.append("\\")
       ELSE
         DISPLAY "illegal backslash"
       END IF
     WHEN "="
       IF quote_state THEN
         LET value=value.append(c)
       ELSE
         LET varname=value
         LET value=""
         LET i=i+1
         LET varnames[level]=varname
         --LET levelhasnames[level]=1
       END IF
     WHEN " "
       IF quote_state THEN
         LET value=value.append(c)
       END IF
     WHEN "\t"
       IF quote_state THEN
         LET value=value.append(c)
       END IF
     WHEN ","
       IF quote_state THEN
         LET value=value.append(c)
       ELSE
         IF varname IS NOT NULL THEN
           --DISPLAY "recognized varname+value :",varname,"=",value
         ELSE
           --DISPLAY "recognized only value :",value
         END IF
         --CALL printlevelresult(variable,level,varname,countarr[level])
         IF level=1 AND varname IS NULL AND value IS NOT NULL THEN
           LET res=sfmt("%1[%2] = %3\n",variable,countarr[level]+1,value)
           LET result=result.append(res)
         ELSE IF level=1 AND varname IS NOT NULL AND value IS NOT NULL THEN
           LET res=sfmt("%1.%2 = %3\n",variable,varname,value)
           LET result=result.append(res)
         END IF
         END IF
         LET varname=""
         LET value=""
         LET countarr[level]=countarr[level]+1
       END IF
     OTHERWISE
       LET value=value.append(c)
   END CASE
   --DISPLAY "i:",i," c:",c," bs:",bs_state," quote:",quote_state," value:",value
  END FOR
  IF maxlevel=0 OR line="{}" THEN
    LET res=sfmt("%1 = %2\n",variable,line)
    LET result=result.append(res)
  END IF
  RETURN result
END FUNCTION

FUNCTION extract_gdb_variable_value(line)
  DEFINE line,line2 String
  DEFINE eqidx Integer
  LET eqidx = line.getIndexOf("=",1)
  --DISPLAY "extract_gdc_variable_value:eqidx:",eqidx,",len:",line.getLength()
  IF eqidx = 0 THEN
    RETURN line
  END IF
  LET line2= line.subString(eqidx+2,line.getLength())
  --DISPLAY "line2=",line2
  RETURN line2
END FUNCTION

FUNCTION get_state_filename(program)
  DEFINE program STRING
  DEFINE fname STRING
  LET fname=get_short_filename(program)
  IF fname.getIndexOf(".42",1)>0 THEN
    LET fname=fname.subString(1,fname.getIndexOf(".42",1)-1)
  END IF
  LET fname=fname.append(".4dd")
  RETURN fname
END FUNCTION


FUNCTION save_state ()
  DEFINE cfile,currentwin String
  DEFINE doc om.DomDocument
  DEFINE root,breakpoints,b,histlists,h,hentry,windows,w om.DomNode
  DEFINE i,len INTEGER
  LET cfile=get_state_filename(g_program)
  IF cfile IS NULL THEN
    ERROR "can't get config file name"
    RETURN
  END IF
  LET currentwin = om_get_current_window_name()
  CURRENT WINDOW IS fgldeb CALL set_current_dialog("fgldeb")
  LET doc=om.DomDocument.create("FglDebugger")
  LET root=doc.getDocumentElement()
  LET breakpoints=root.createChild("Breakpoints")
  LET len=break_arr.getLength()
  FOR i=1 TO len
    LET b=breakpoints.createChild("Breakpoint")
    CALL b.setAttribute("lineNumber",break_arr[i].lineNumber)
    CALL b.setAttribute("funcName" ,break_arr[i].funcName )
    CALL b.setAttribute("modName" ,break_arr[i].modName )
    CALL b.setAttribute("breakType" ,break_arr[i].breakType )
    CALL b.setAttribute("enabled" ,break_arr[i].enabled )
    CALL b.setAttribute("isFunction",break_arr[i].isFunction)
    IF break_arr[i].line IS NOT NULL THEN
      CALL b.setAttribute("line" ,break_arr[i].line )
    END IF
  END FOR
  LET histlists=root.createChild("HistoryLists")
# 4741 "fgldeb.4g"
  LET h=histlists.createChild("search") LET len= search_hist_arr.getLength() FOR i=1 TO len LET hentry=h.createChild("Item") IF search_hist_arr[i].getLength() <> 0 THEN CALL hentry.setAttribute("value",search_hist_arr[i]) END IF END FOR
  LET h=histlists.createChild("inspectvariable") LET len= inspectvar_hist_arr.getLength() FOR i=1 TO len LET hentry=h.createChild("Item") IF inspectvar_hist_arr[i].getLength() <> 0 THEN CALL hentry.setAttribute("value",inspectvar_hist_arr[i]) END IF END FOR
  LET h=histlists.createChild("fdbcommand") LET len= fdb_hist_arr.getLength() FOR i=1 TO len LET hentry=h.createChild("Item") IF fdb_hist_arr[i].getLength() <> 0 THEN CALL hentry.setAttribute("value",fdb_hist_arr[i]) END IF END FOR
  LET h=histlists.createChild("functions") LET len= func_hist_arr.getLength() FOR i=1 TO len LET hentry=h.createChild("Item") IF func_hist_arr[i].getLength() <> 0 THEN CALL hentry.setAttribute("value",func_hist_arr[i]) END IF END FOR
  LET h=histlists.createChild("watches") LET len= watch_arr.getLength() FOR i=1 TO len LET hentry=h.createChild("Item") IF watch_arr[i].getLength() <> 0 THEN CALL hentry.setAttribute("value",watch_arr[i]) END IF END FOR

  LET windows=root.createChild("Windows")
  LET w=windows.createChild("auto_group")
  CALL w.setAttribute("hidden",_deb_getGroupHidden("auto_group"))
  LET w=windows.createChild("watch_group")
  CALL w.setAttribute("hidden",_deb_getGroupHidden("watch_group"))


  CALL root.writeXml(cfile)
  CALL raise_window(currentwin)
END FUNCTION

FUNCTION restore_state()
  DEFINE cfile String
  DEFINE doc om.DomDocument
  DEFINE root,breakpoints,history_list,windows om.DomNode
  DEFINE nlist om.NodeList
  LET cfile=get_state_filename(g_program)
  IF cfile IS NULL THEN
    ERROR "can't get config file name"
    RETURN
  END IF
  LET doc=om.DomDocument.createFromXmlFile(cfile)
  IF doc IS NULL THEN
    MESSAGE "can't file config file"
    RETURN
  END IF
  LET root=doc.getDocumentElement()
  -- read in the breakpoints
  LET nlist=root.selectByPath("//Breakpoints")
  IF nlist.getLength()=1 THEN
    LET breakpoints=nlist.item(1)
    -- CALL restore_breakpoints(breakpoints)
  END IF
  -- now read in the history nodes
  LET nlist=root.selectByPath("//HistoryLists")
  IF nlist.getLength()=1 THEN
    LET history_list=nlist.item(1)
    CALL restore_history(history_list,search_hist_arr ,"search" )
    CALL restore_history(history_list,fdb_hist_arr ,"fdbcommand")
    CALL restore_history(history_list,inspectvar_hist_arr,"inspectvariable")
    CALL restore_history(history_list,func_hist_arr ,"functions")
    CALL restore_history(history_list,watch_arr ,"watches")
  END IF
  LET nlist=root.selectByPath("//Windows")
  IF nlist.getLength()=1 THEN
    LET windows=nlist.item(1)
    CALL restore_windows(windows)
  END IF
END FUNCTION

FUNCTION restore_breakpoints(breakpoints)
  DEFINE breakpoints,b om.DomNode
  DEFINE i INTEGER
  DEFINE modName,funcName,line,breakcmd,breakType,file,lineStr STRING
  DEFINE addlinebreak,lineNumber,enabled,isFunction INTEGER
  DEFINE bsrc_arr DYNAMIC ARRAY OF STRING
  FOR i=1 TO breakpoints.getChildCount()
    LET b=breakpoints.getChildByIndex(i)
    LET modName = b.getAttribute("modName")
    LET funcName = b.getAttribute("funcName")
    LET enabled = b.getAttribute("enabled")
    LET lineNumber = b.getAttribute("lineNumber")
    LET line = b.getAttribute("line")
    LET breakType = b.getAttribute("breakType")
    LET isFunction = b.getAttribute("isFunction")
    LET breakcmd=""
    --we ignore temporary breakpoints
    IF breakType="del" THEN
      CONTINUE FOR
    END IF
    IF line IS NOT NULL THEN
      --lookup in the source file, if the corresponding line
      --is at the right place
      IF g_lastmod <> modName THEN
        CALL read_in_source(modName,bsrc_arr,0)
        IF g_read_in_source_error THEN
          --ignore this breakpoint
          CONTINUE FOR
        END IF
        LET g_lastmod=modName
      END IF
      CALL find_line_in_srcarr(line,lineNumber,funcName,bsrc_arr)
          RETURNING addlinebreak,lineNumber
      IF addlinebreak THEN
        LET breakcmd=sfmt("break %1:%2",modName,lineNumber)
      END IF
    ELSE IF isFunction THEN
      CALL get_function_info_short(funcName,0) RETURNING file,lineStr
      IF file IS NOT NULL THEN
        LET lineNumber=lineStr
        LET breakcmd=sfmt("break %1:%2",file,lineStr)
      END IF
    ELSE
      LET breakcmd=sfmt("break %1:%2",modName,lineNumber)
    END IF
    END IF
    IF breakcmd IS NOT NULL THEN
      CALL deb_write(breakcmd)
      CALL get_deb_out()
      IF line IS NOT NULL THEN
        CALL check_break_line(lineNumber,0,modName,bsrc_arr)
      END IF
    END IF
  END FOR
  CALL update_breakpoints()
END FUNCTION

FUNCTION restore_history(history_list,arr,name)
  DEFINE history_list om.DomNode
  DEFINE arr DYNAMIC ARRAY OF STRING
  DEFINE name,value STRING
  DEFINE nlist om.NodeList
  DEFINE histnode,child om.DomNode
  DEFINE i INTEGER
  LET nlist=history_list.selectByPath("//"||name)
  IF nlist.getLength()=1 THEN
    LET histnode=nlist.item(1)
    CALL arr.clear()
    LET i=1
    LET child= histnode.getFirstChild()
    WHILE child IS NOT NULL
      IF child.getTagName()="Item" THEN
        LET value=child.getAttribute("value")
        IF value.getLength()<> 0 THEN
          LET arr[i]=value
          LET i=i+1
        END IF
      END IF
      LET child=child.getNext()
    END WHILE
  END IF
END FUNCTION

FUNCTION restore_windows(windows)
  DEFINE windows,w om.DomNode
  DEFINE i INTEGER
  DEFINE tagName,hidden STRING
  FOR i=1 TO windows.getChildCount()
    LET w=windows.getChildByIndex(i)
    LET tagName=w.getTagName()
    LET hidden=w.getAttribute("hidden")
    --DISPLAY "tagName:",tagName,",hidden",hidden
    CASE tagName
      WHEN "auto_group"
        CALL do_hide_group_int("auto_group","togglehideauto","&Auto",hidden)
      WHEN "watch_group"
        CALL do_hide_group_int("watch_group","togglehidewatch","&Watch",hidden)
    END CASE
  END FOR
END FUNCTION

FUNCTION remove_leading_spaces(line)
  DEFINE line,c STRING
  DEFINE i,len INTEGER
  LET len=line.getLength()
  FOR i=1 TO len
    LET c=line.getCharAt(i)
    IF c=" " OR c="\t" THEN
      CONTINUE FOR
    ELSE
      LET line=line.subString(i,line.getLength())
      EXIT FOR
    END IF
  END FOR
  RETURN line
END FUNCTION

FUNCTION remove_spaces(line)
  DEFINE line STRING
  DEFINE line2,c STRING
  DEFINE i,len INTEGER
  LET len=line.getLength()
  FOR i=1 TO len
    LET c=line.getCharAt(i)
    IF c=" " OR c="\t" THEN
      CONTINUE FOR
    ELSE
      LET line2=line2.append(c)
    END IF
  END FOR
  RETURN line2
END FUNCTION

--this function checks for
--"FUNCTION foo (" , "MAIN" on a line or
--"END FUNCTION", "END MAIN"
--if it finds the definition,
--it returns : "function",<funcName> ,
--in the end case : "end" ,"function"
--if not find at all : "" ,""
FUNCTION check_function_line(line)
  DEFINE line STRING
  DEFINE i,len INTEGER
  DEFINE ident,c STRING
  LET line=remove_leading_spaces(line)
  LET line=line.toLowerCase()
  IF line.getIndexOf("end",1)=1 THEN
    LET line=line.subString(length("end")+1,line.getLength())
    LET line=remove_leading_spaces(line)
    IF line.getIndexOf("function",1)=1 OR line.getIndexOf("main",1)=1 THEN
      RETURN "end","function"
    END IF
  ELSE IF line.getIndexOf("function",1)=1 THEN
    LET line=line.subString(length("function")+1,line.getLength())
    LET line=remove_leading_spaces(line)
    LEt len=line.getLength()
    FOR i=1 TO len
      LET c=line.getCharAt(i)
      IF c=" " OR c="\t" OR c="(" THEN
        EXIT FOR
      ELSE
        LET ident=ident.append(c)
      END IF
    END FOR
    RETURN "function",ident
  ELSE IF line.getIndexOf("main",1)=1 THEN
    RETURN "function","main"
  END IF
  END IF
  END IF
  RETURN "",""
END FUNCTION

--tries to locate a source code line in an array read from a source
FUNCTION find_line_in_srcarr(line,lineNumber,funcName,arr)
  DEFINE line STRING
  DEFINE lineNumber INTEGER
  DEFINE funcName STRING
  DEFINE arr DYNAMIC ARRAY OF STRING
  DEFINE i,found,len INTEGER
  DEFINE srcline,kind,func STRING

  --normalize the search line and remove trailing blanks
  --DISPLAY "find source line \"",line,"\" in func ",funcName," ,lineno ",lineNumber
  LET funcName=funcName.toLowercase()
  LET line=remove_leading_spaces(line)
  --search forward
  LET len=arr.getLength()
  FOR i=lineNumber TO len
    LET srcline=arr[i]
    --DISPLAY sfmt("line%1:%2",i,srcline)
    IF srcline.getIndexOf(line,1)<> 0 THEN
      --DISPLAY "found at ",i
      RETURN 1,i
    END IF
    CALL check_function_line(srcline) RETURNING kind,func
    IF kind IS NULL THEN
      -- no function stuff detected
      CONTINUE FOR
    END IF
    IF kind="end" THEN
      --DISPLAY "end function found at ",i
      EXIT FOR
    END IF
  END FOR
  IF lineNumber-1>arr.getLength() THEN
    LET lineNumber=arr.getLength()+1
  END IF
  FOR i=lineNumber-1 TO 1 STEP -1
    LET srcline=arr[i]
    --DISPLAY sfmt("line%1:%2",i,srcline)
    IF srcline.getIndexOf(line,1)<> 0 THEN
      --DISPLAY "found at ",i
      RETURN 1,i
    END IF
    CALL check_function_line(srcline) RETURNING kind,func
    IF kind IS NULL THEN
      -- no function stuff detected
      CONTINUE FOR
    END IF
    IF kind="function" THEN
      --DISPLAY "function start found at ",i
      EXIT FOR
    END IF
  END FOR
  --finally, search the whole document, look for the right
  --function and try to find the line within there
  FOR i=1 TO len
    LET srcline=arr[i]
    CALL check_function_line(srcline) RETURNING kind,func
    CASE kind
      WHEN "function"
        IF func=funcName THEN
          --DISPLAY "found function start of ",funcName," at ",i
          LET found=1
        END IF
      WHEN "end"
        IF found THEN
          --DISPLAY "found function end,go out"
          EXIT FOR
        END IF
      OTHERWISE
        IF found AND srcline.getIndexOf(line,1)<> 0 THEN
          --DISPLAY "finally found the line at ",i
          RETURN 1,i
        END IF
    END CASE
  END FOR
  RETURN 0,1
END FUNCTION

FUNCTION set_debug_logo()
  DEFINE root om.DomNode
  LET root = ui.Interface.getRootNode()
  CALL root.setAttribute("image","debug_logo")
END FUNCTION

--adds a variable to the global watch array
--the watch array is inspected/printed after each step instruction
FUNCTION add_watch(varname)
  DEFINE varname STRING
  DEFINE i,found,len INTEGER
  LET len=watch_arr.getLength()
  FOR i=1 TO len
    IF watch_arr[i]=varname THEN
      LET found=1
      EXIT FOR
    END IF
  END FOR
  IF NOT found THEN
    LET watch_arr[watch_arr.getLength()+1]=varname
  END IF
END FUNCTION

--deletes a variable from the watch array
FUNCTION delete_watch(varname)
  DEFINE varname STRING
  DEFINE i,len INTEGER
  LET len=watch_arr.getLength()
  FOR i=1 TO len
    IF watch_arr[i].getIndexOf(varname,1)=1 THEN
      CALL watch_arr.deleteElement(i)
      EXIT FOR
    END IF
  END FOR
END FUNCTION

--goes through the list of variables, gets their values and
--gives back a single result string
FUNCTION format_var_arr_print(var_arr,limit_one_line)
  DEFINE var_arr DYNAMIC ARRAY OF STRING
  DEFINE limit_one_line INTEGER
  DEFINE result,singleres STRING
  DEFINE i,success,len,firstnl INTEGER
  LET len=var_arr.getLength()
  FOR i=1 TO len
    CALL parse_variable(var_arr[i]) RETURNING success,singleres
    IF limit_one_line THEN
      --cut only the first line from the result set
      LET firstnl=singleres.getIndexOf("\n",1)
      IF firstnl<>0 THEN
        LET singleres=singleres.subString(1,firstnl)
      END IF
    END IF
    LET result=result.append(singleres)
    IF result.getLength()>0 THEN
      IF result.getCharAt(result.getLength()) <> "\n" THEN
        LET result=result.append("\n")
      END IF
    END IF
  END FOR
  RETURN result
END FUNCTION

--goes through the list of watched variables and
--gets the current values from the debugger
FUNCTION update_watch()
  DEFINE result,currentwin STRING
  DEFINE hidden INTEGER
  IF NOT windowExist("fgldeb") THEN
    RETURN
  END IF
  --save the current window
  LET currentwin = om_get_current_window_name()
  CURRENT WINDOW IS fgldeb CALL set_current_dialog("fgldeb")
  LET hidden=_deb_getGroupHidden("watch_group")
  IF hidden=0 THEN
    LET result=format_var_arr_print(watch_arr,0)
    DISPLAY result to g_watch
  END IF
  CALL raise_window(currentwin)
END FUNCTION

FUNCTION update_autovars()
  DEFINE currentwin,result,frame_name STRING
  DEFINE i,len INTEGER
  DEFINE hidden INTEGER
  --RETURN
  IF NOT windowExist("fgldeb") THEN
    RETURN
  END IF
  LET currentwin = om_get_current_window_name()
  LET hidden=_deb_getGroupHidden("auto_group")
  CURRENT WINDOW IS fgldeb CALL set_current_dialog("fgldeb")
  CALL raise_window(currentwin)
  IF hidden THEN
    RETURN
  END IF
  IF g_state="running" THEN
    LET frame_name=g_frame_name
  ELSE
    LET frame_name="__INIT__"
  END IF
  LET len=auto_arr.getLength()
  FOR i=1 TO len
    IF auto_arr[i].frame_name=frame_name THEN
      LET result=do_auto_add(auto_arr[i].var_arr)
      EXIT FOR
    END IF
  END FOR
  --save the current window
  LET currentwin = om_get_current_window_name()
  CURRENT WINDOW IS fgldeb CALL set_current_dialog("fgldeb")
  DISPLAY result to g_auto
  CALL raise_window(currentwin)
END FUNCTION



FUNCTION find_var_name(varname,var_arr,len)
  DEFINE varname STRING
  DEFINE var_arr DYNAMIC ARRAY OF STRING
  DEFINE len,i INTEGER
  DEFINE varnameL STRING
  LET varnameL=varname.toLowerCase()
  FOR i=1 TO len
    IF var_arr[i].toLowerCase()=varnameL THEN
      RETURN i
    END IF
  END FOR
  RETURN 0
END FUNCTION

FUNCTION do_auto_add(var_arr)
  DEFINE var_arr, grab_arr, new_arr ,found_arr, res_arr DYNAMIC ARRAY OF STRING
  DEFINE var_arr_len,grab_arr_len,new_arr_len,found_arr_len,res_arr_len INTEGER
  DEFINE i,found,foundall INTEGER
  DEFINE result,varname STRING
  LET var_arr_len=var_arr.getLength()
  CALL grab_variables(grab_arr)
  --first check the newly found variables
  LET i=1
  LET grab_arr_len=grab_arr.getLength()
  FOR i=1 TO grab_arr_len
    LET found=0
    LET found=find_var_name(grab_arr[i],var_arr,var_arr_len)
    IF found <> 0 THEN
      --this variable was already inside var_arr
      LET found_arr[found_arr.getLength()+1]=var_arr[found]
    ELSE
      --this one newly appeared
      LET new_arr[new_arr.getLength()+1]=grab_arr[i]
    END IF
  END FOR
  --CALL print_arr("var_arr",var_arr)
  --CALL print_arr("grab_arr",grab_arr)
  --CALL print_arr("new_arr",new_arr)
  --CALL print_arr("found_arr",found_arr)

  --now the new detected variables are in new_arr, the already
  --known in found_arr
  --first add new_arr at the end
  --then found_arr before , then the rest from var_arr
  LET i=1
  LET new_arr_len=new_arr.getLength()
  LET res_arr_len=res_arr.getLength()
  WHILE res_arr_len<5 AND i<=new_arr_len
    LET res_arr[res_arr_len+1]=new_arr[i]
    LET res_arr_len=res_arr_len+1
    LET i=i+1
  END WHILE
  --CALL print_arr("res_arr",res_arr)

  LET i=1
  LET found_arr_len=found_arr.getLength()
  WHILE res_arr_len<5 AND i<=found_arr_len
    CALL res_arr.insertElement(i)
    LET res_arr[i]=found_arr[i]
    LET res_arr_len=res_arr_len+1
    LET i=i+1
  END WHILE

  --CALL print_arr("res_arr",res_arr)
  --go through var_arr and add the rest of the variables
  --which were not detected in _grab_variables
  LET i=var_arr_len
  WHILE res_arr_len<5 AND i>=1
    LET varname=var_arr[i]
    LET found=0
    LET found=find_var_name(varname,found_arr,found_arr_len)
    IF found=0 THEN
      --DISPLAY "did not find ",varname," in found_arr"
      LET found=find_var_name(varname,new_arr,new_arr_len)
      IF found=0 THEN
        --DISPLAY "did not find ",varname," in new_arr"
        CALL res_arr.insertElement(1)
        LET res_arr[1]=var_arr[i]
        LET res_arr_len=res_arr_len+1
      END IF
    END IF
    LET i=i-1
  END WHILE
  --CALL print_arr("res_arr",res_arr)

  --finally check if the original var_arr names are completely contained
  --in res_arr, then we append only the newly arrived variable names
  LET foundall=1
  FOR i=1 TO var_arr_len
    LET found=0
    LET found=find_var_name(var_arr[i],res_arr,res_arr_len)
    IF found=0 THEN
      LET foundall=0
      EXIT FOR
    END IF
  END FOR
  IF foundall THEN
    IF res_arr_len>var_arr_len THEN
      --add the odd ones out to the end of var_arr
      LET i=1
      WHILE var_arr_len<5 AND i<=res_arr_len
        LET found=find_var_name(res_arr[i],var_arr,var_arr_len)
        IF found=0 THEN
          LET var_arr[var_arr_len+1]=res_arr[i]
          LET var_arr_len=var_arr_len+1
        END IF
        LET i=i+1
      END WHILE
    END IF
    --CALL print_arr("var_arr",res_arr)
    LET result=format_var_arr_print(var_arr,1)
  ELSE
    LET result=format_var_arr_print(res_arr,1)
    CALL var_arr.clear()
    FOR i=1 TO res_arr_len
      LET var_arr[i]=res_arr[i]
    END FOR
  END IF
  RETURN result
END FUNCTION

FUNCTION print_arr(name,var_arr)
  DEFINE name STRING
  DEFINE var_arr DYNAMIC ARRAY OF STRING
  --DEFINE str STRING
  --DEFINE i INTEGER
  RETURN
  --FOR i=1 TO var_arr.getLength()
  -- LET str=str.append(sfmt("%1 ",var_arr[i]))
  --END FOR
  --DISPLAY "Array ",name,"{ ",str,"}"
END FUNCTION

--shows the watched variables and allows to delete them
FUNCTION do_view_watches_from(where)
  DEFINE where STRING
  DEFINE i,len,do_inspect INTEGER
  DEFINE tmp_arr DYNAMIC ARRAY OF STRING
  IF NOT windowExist("edit_watch") THEN OPEN WINDOW edit_watch WITH FORM "edit_watch" ELSE CURRENT WINDOW IS edit_watch END IF CALL set_current_dialog("edit_watch")
  LET len=watch_arr.getLength()
  FOR i=1 TO len
    LET tmp_arr[i]=watch_arr[i]
  END FOR
  DISPLAY ARRAY watch_arr TO edit_watch.*
    ON ACTION delete
      CALL watch_arr.deleteElement(arr_curr())
    ON ACTION deleteall
      CALL watch_arr.clear()
    ON ACTION addwatch
      LET do_inspect=1
      EXIT DISPLAY
    ON ACTION cancel
      LET len=tmp_arr.getLength()
      FOR i=1 TO len
        LET watch_arr[i]=tmp_arr[i]
      END FOR
      EXIT DISPLAY
  END DISPLAY
  CLOSE WINDOW edit_watch CALL remove_dialog_name("edit_watch")
  CALL update_watch()
  IF do_inspect THEN
    IF where="fgldeb" THEN
      RETURN inspectvariable(0)
    ELSE
      RETURN "inspectvariable"
    END IF
  ELSE
    RETURN where
  END IF
END FUNCTION

FUNCTION do_hide_group_int(tagName,actionName,buttontitle,hidden)
  DEFINE tagName,actionName,buttontitle,hidden STRING
  IF hidden IS NOT NULL THEN
    IF hidden="1" THEN
      CALL _deb_setGroupHidden(tagName,"1")
      CALL _deb_setButtonText (actionName,sfmt("Show %1",buttontitle))
    ELSE
      CALL _deb_setGroupHidden(tagName,"0")
      CALL _deb_setButtonText (actionName,sfmt("Hide %1",buttontitle))
    END IF
  END IF
END FUNCTION

FUNCTION toggle_hide_group(tagName,actionName,buttontitle)
  DEFINE tagName,actionName,buttontitle STRING
  DEFINE hidden STRING
  LET hidden=_deb_getGroupHidden(tagName)
  IF hidden IS NOT NULL THEN
    --toggle the visibility
    IF hidden="0" THEN
      LET hidden="1"
    ELSE
      LET hidden="0"
    END IF
    CALL do_hide_group_int(tagName,actionName,buttontitle,hidden)
  END IF
END FUNCTION

--lengthy function to raise the right window,
--may be this is easier with dom
FUNCTION raise_window(window_name)
  DEFINE window_name STRING
  CASE window_name
    WHEN "fgldeb"
      CURRENT WINDOW IS fgldeb CALL set_current_dialog("fgldeb")
    WHEN "finish"
      CURRENT WINDOW IS finish CALL set_current_dialog("finish")
    WHEN "fdbcommand"
      CURRENT WINDOW IS fdbcommand CALL set_current_dialog("fdbcommand")
    WHEN "fdbhistory"
      CURRENT WINDOW IS fdbhistory CALL set_current_dialog("fdbhistory")
    WHEN "fdbcommandlist"
      CURRENT WINDOW IS fdbcommandlist CALL set_current_dialog("fdbcommandlist")
    WHEN "stack"
      CURRENT WINDOW IS stack CALL set_current_dialog("stack")
    WHEN "input_path"
      CURRENT WINDOW IS input_path CALL set_current_dialog("input_path")
    WHEN "dirlist"
      CURRENT WINDOW IS dirlist CALL set_current_dialog("dirlist")
    WHEN "modules"
      CURRENT WINDOW IS modules CALL set_current_dialog("modules")
    WHEN "functions"
      CURRENT WINDOW IS functions CALL set_current_dialog("functions")
    WHEN "break"
      CURRENT WINDOW IS break CALL set_current_dialog("break")
    WHEN "addbreak"
      CURRENT WINDOW IS addbreak CALL set_current_dialog("addbreak")
    WHEN "search"
      CURRENT WINDOW IS search CALL set_current_dialog("search")
    WHEN "variables"
      CURRENT WINDOW IS local_variables CALL set_current_dialog("local_variables")
    WHEN "variables"
      CURRENT WINDOW IS global_variables CALL set_current_dialog("global_variables")
    WHEN "complete_variable"
      CURRENT WINDOW IS complete_variable CALL set_current_dialog("complete_variable")
    WHEN "complete_function"
      CURRENT WINDOW IS complete_function CALL set_current_dialog("complete_function")
    WHEN "inspectvariable"
      CURRENT WINDOW IS inspectvariable CALL set_current_dialog("inspectvariable")
  END CASE
END FUNCTION

FUNCTION update_status(refresh)
  DEFINE refresh INTEGER
  IF om_get_current_window_name()=="fgldeb" THEN
    MESSAGE sfmt("Current function:%1 Status:%2 Line:%3",
                  g_frame_name,g_state,g_status_line_no)
    DISPLAY g_state TO cStatus
    DISPLAY g_frame_name TO currFunc
    DISPLAY g_status_line_no TO cLine
    IF refresh THEN
      CALL fgl_refresh()
    END IF
  END IF
END FUNCTION

FUNCTION help_dialog(str)
  DEFINE str STRING
  --DEFINE helpstr STRING
  DEFINE i,iold,len INTEGER
  --DEFINE node om.DomNode
  IF NOT windowExist("help") THEN OPEN WINDOW help WITH FORM "help" ELSE CURRENT WINDOW IS help END IF CALL set_current_dialog("help")
  LET i=1
  LET len=str.getLength()
  LET g_helpstr=""
  --go through and replace \\\n with real new lines
  WHILE i<len
    LET iold=i
    LET i=str.getIndexOf("\\n",iold)
    IF i<>0 THEN
      LET g_helpstr=g_helpstr.append(str.subString(iold,i-1))
      LET g_helpstr=g_helpstr.append("\n")
      LET i=i+2
    ELSE
      LET g_helpstr=g_helpstr.append(str.subString(iold,len))
      EXIT WHILE
    END IF
  END WHILE
  INPUT BY NAME g_helpstr WITHOUT DEFAULTS
    ON ACTION close
      EXIT INPUT
    ON ACTION find
      LET g_helpcursor=fgl_dialog_getcursor()
      --LET helpstr=remove_newlines(g_helpstr)
      --DISPLAY "at char ",helpstr.getCharAt(g_helpcursor)
      CALL do_find("help","Help items")
    ON ACTION findnext
      LET g_helpcursor=fgl_dialog_getcursor()+1
      --LET helpstr=remove_newlines(g_helpstr)
      --DISPLAY "at char ",helpstr.getCharAt(g_helpcursor)
      CALL do_findnext("help")
    ON ACTION backspace
      --DISPLAY "backspace"
    ON ACTION del
      --DISPLAY "del"
    ON ACTION editcut
      --DISPLAY "editcut"
    ON ACTION editpaste
      --DISPLAY "editpaste"
  END INPUT
  {
  DISPLAY g_helpstr TO helpstr
  MENU "tmp"
    COMMAND "Close"
      EXIT MENU
  END MENU
  }
  CLOSE WINDOW help CALL remove_dialog_name("help")
END FUNCTION
