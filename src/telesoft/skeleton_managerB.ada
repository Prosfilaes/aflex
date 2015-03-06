-- Copyright (c) 1990 Regents of the University of California.
-- All rights reserved.
--
-- This software was developed by John Self of the Arcadia project
-- at the University of California, Irvine.
--
-- Redistribution and use in source and binary forms are permitted
-- provided that the above copyright notice and this paragraph are
-- duplicated in all such forms and that any documentation,
-- advertising materials, and other materials related to such
-- distribution and use acknowledge that the software was developed
-- by the University of California, Irvine.  The name of the
-- University may not be used to endorse or promote products derived
-- from this software without specific prior written permission.
-- THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
-- IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
-- WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.

-- TITLE skeleton manager
-- AUTHOR: John Self (UCI)
-- DESCRIPTION outputs skeleton sections when called by gen.
-- NOTES allows use of internal or external skeleton
-- $Header: /dc/uc/self/arcadia/aflex/ada/src/telesoft/RCS/skeleton_managerB.ada,v 1.3 1993/06/01 19:30:13 self Exp $ 

with MISC_DEFS, TEXT_IO, FILE_STRING;
package body SKELETON_MANAGER is 
  use FILE_STRING; -- to save having to type FILE_STRING 177 times
  USE_EXTERNAL_SKELETON : BOOLEAN := FALSE; 
                                          -- are we using an external skelfile?
  CURRENT_LINE          : INTEGER := 1; 
  type FILE_ARRAY is array(POSITIVE range <>) of FILE_STRING.VSTRING; 
  SKEL_TEMPLATE : constant FILE_ARRAY := (
  -- START OF SKELETON
  -- START OF S1
VSTR("-- A lexical scanner generated by aflex"),
VSTR("with text_io; use text_io;"),
VSTR("%% user's code up to the double pound goes right here"),
-- BEGIN S2
VSTR("function YYLex return Token is"),
VSTR("subtype short is integer range -32768..32767;"),
VSTR("    yy_act : integer;"),
VSTR("    yy_c : short;"),
VSTR(""),
VSTR("-- returned upon end-of-file"),
VSTR("YY_END_TOK : constant integer := 0;"),
VSTR("%% tables get generated here."),
-- BEGIN S3
VSTR(""),
VSTR("-- copy whatever the last rule matched to the standard output"),
VSTR(""),
VSTR("procedure ECHO is"),
VSTR("begin"),
VSTR("   if (text_io.is_open(user_output_file)) then"),
VSTR("     text_io.put( user_output_file, yytext );"),
VSTR("   else"),
VSTR("    text_io.put( yytext );"),
VSTR("   end if;"),
VSTR("end ECHO;"),
VSTR(""),
VSTR("-- enter a start condition."),
VSTR("-- Using procedure requires a () after the ENTER, but makes everything"),
VSTR("-- much neater."),
VSTR(""),
VSTR("procedure ENTER( state : integer ) is"),
VSTR("begin"),
VSTR("     yy_start := 1 + 2 * state;"),
VSTR("end ENTER;"),
VSTR(""),
VSTR("-- action number for EOF rule of a given start state"),
VSTR("function YY_STATE_EOF(state : integer) return integer is"),
VSTR("begin"),
VSTR("     return YY_END_OF_BUFFER + state + 1;"),
VSTR("end YY_STATE_EOF;"),
VSTR(""),
VSTR("-- return all but the first 'n' matched characters back to the input stream"),
VSTR("procedure yyless(n : integer) is"),
VSTR("begin"),
VSTR("        yy_ch_buf(yy_cp) := yy_hold_char; -- undo effects of setting up yytext"),
VSTR("        yy_cp := yy_bp + n;"),
VSTR("        yy_c_buf_p := yy_cp;"),
VSTR("        YY_DO_BEFORE_ACTION; -- set up yytext again"),
VSTR("end yyless;"),
VSTR(""),
VSTR("-- redefine this if you have something you want each time."),
VSTR("procedure YY_USER_ACTION is"),
VSTR("begin"),
VSTR("        null;"),
VSTR("end;"),
VSTR(""),
VSTR("-- yy_get_previous_state - get the state just before the EOB char was reached"),
VSTR(""),
VSTR("function yy_get_previous_state return yy_state_type is"),
VSTR("    yy_current_state : yy_state_type;"),
VSTR("    yy_c : short;"),
VSTR("%% a local declaration of yy_bp goes here if bol_needed"),
VSTR("begin"),
VSTR("%% code to get the start state into yy_current_state goes here"), 
-- BEGIN S3A
VSTR(""),
VSTR("    for yy_cp in yytext_ptr..yy_c_buf_p - 1 loop"),
VSTR("%% code to find the next state goes here"),
-- BEGIN S4
VSTR("    end loop;"),
VSTR(""),
VSTR("    return yy_current_state;"),
VSTR("end yy_get_previous_state;"),
VSTR(""),
VSTR("procedure yyrestart( input_file : file_type ) is"),
VSTR("begin"),
VSTR("   open_input(text_io.name(input_file));"),
VSTR("end yyrestart;"),
VSTR(""),
VSTR("begin -- of YYLex"),
VSTR("<<new_file>>"),
VSTR("        -- this is where we enter upon encountering an end-of-file and"),
VSTR("        -- yywrap() indicating that we should continue processing"),
VSTR(""),
VSTR("    if ( yy_init ) then"),
VSTR("        if ( yy_start = 0 ) then"),
VSTR("            yy_start := 1;      -- first start state"),
VSTR("        end if;"),
VSTR(""),
VSTR("        -- we put in the '\n' and start reading from [1] so that an"),
VSTR("        -- initial match-at-newline will be true."),
VSTR(""),
VSTR("        yy_ch_buf(0) := ASCII.LF;"),
VSTR("        yy_n_chars := 1;"),
VSTR(""),
VSTR("        -- we always need two end-of-buffer characters.  The first causes"),
VSTR("        -- a transition to the end-of-buffer state.  The second causes"),
VSTR("        -- a jam in that state."),
VSTR(""),
VSTR("        yy_ch_buf(yy_n_chars) := YY_END_OF_BUFFER_CHAR;"),
VSTR("        yy_ch_buf(yy_n_chars + 1) := YY_END_OF_BUFFER_CHAR;"),
VSTR(""),
VSTR("        yy_eof_has_been_seen := false;"),
VSTR(""),
VSTR("        yytext_ptr := 1;"),
VSTR("        yy_c_buf_p := yytext_ptr;"),
VSTR("        yy_hold_char := yy_ch_buf(yy_c_buf_p);"),
VSTR("        yy_init := false;"),
VSTR("-- UMASS CODES :"),
VSTR("--   Initialization"),
VSTR("        tok_begin_line := 1;"),
VSTR("        tok_end_line := 1;"),
VSTR("        tok_begin_col := 0;"),
VSTR("        tok_end_col := 0;"),
VSTR("        token_at_end_of_line := false;"),
VSTR("        line_number_of_saved_tok_line1 := 0;"),
VSTR("        line_number_of_saved_tok_line2 := 0;"),
VSTR("-- END OF UMASS CODES."),
VSTR("    end if; -- yy_init"),
VSTR(""),
VSTR("    loop                -- loops until end-of-file is reached"),
VSTR(""),
VSTR("-- UMASS CODES :"),
VSTR("--    if last matched token is end_of_line, we must"),
VSTR("--    update the token_end_line and reset tok_end_col."),
VSTR("    if Token_At_End_Of_Line then"),
VSTR("      Tok_End_Line := Tok_End_Line + 1;"),
VSTR("      Tok_End_Col := 0;"),
VSTR("      Token_At_End_Of_Line := False;"),
VSTR("    end if;"),
VSTR("-- END OF UMASS CODES."),
VSTR(""),
VSTR("        yy_cp := yy_c_buf_p;"),
VSTR(""),
VSTR("        -- support of yytext"),
VSTR("        yy_ch_buf(yy_cp) := yy_hold_char;"),
VSTR(""),
VSTR("        -- yy_bp points to the position in yy_ch_buf of the start of the"),
VSTR("        -- current run."),
VSTR("%%"),
-- BEGIN S5
VSTR(""),
VSTR("<<next_action>>"),
VSTR("%% call to gen_find_action goes here"),
-- BEGIN S6
VSTR("            YY_DO_BEFORE_ACTION;"),
VSTR("            YY_USER_ACTION;"),
VSTR(""),
VSTR("        if aflex_debug then  -- output acceptance info. for (-d) debug mode"),
VSTR("            text_io.put( ""--accepting rule #"" );"),
VSTR("            text_io.put( INTEGER'IMAGE(yy_act) );"),
VSTR("            text_io.put_line( ""("""""" & yytext & """""")"");"),
VSTR("        end if;"),
VSTR(""),
VSTR("-- UMASS CODES :"),
VSTR("--   Update tok_begin_line, tok_end_line, tok_begin_col and tok_end_col"),
VSTR("--   after matching the token."),
VSTR("        if yy_act /= YY_END_OF_BUFFER and then yy_act /= 0 then"),
VSTR("-- Token are matched only when yy_act is not yy_end_of_buffer or 0."),
VSTR("          Tok_Begin_Line := Tok_End_Line;"),
VSTR("          Tok_Begin_Col := Tok_End_Col + 1;"),
VSTR("          Tok_End_Col := Tok_Begin_Col + yy_cp - yy_bp - 1;"),
VSTR("          if yy_ch_buf ( yy_bp ) = ASCII.LF then"),
VSTR("            Token_At_End_Of_Line := True;"),
VSTR("          end if;"),
VSTR("        end if;"),
VSTR("-- END OF UMASS CODES."),
VSTR(""),
VSTR("<<do_action>>   -- this label is used only to access EOF actions"),
VSTR("            case yy_act is"), VSTR("%% actions go here"),
-- BEGIN S7
VSTR("                when YY_END_OF_BUFFER =>"),
VSTR("                    -- undo the effects of YY_DO_BEFORE_ACTION"),
VSTR("                    yy_ch_buf(yy_cp) := yy_hold_char;"),
VSTR(""),
VSTR("                    yytext_ptr := yy_bp;"), VSTR(""),
VSTR("                    case yy_get_next_buffer is"),
VSTR("                        when EOB_ACT_END_OF_FILE =>"),
VSTR("                            begin"),
VSTR("                            if ( yywrap ) then"),
VSTR("                                -- note: because we've taken care in"),
VSTR("                                -- yy_get_next_buffer() to have set up yytext,"),
VSTR("                                -- we can now set up yy_c_buf_p so that if some"),
VSTR("                                -- total hoser (like aflex itself) wants"),
VSTR("                                -- to call the scanner after we return the"),
VSTR("                                -- End_Of_Input, it'll still work - another"),
VSTR("                                -- End_Of_Input will get returned."),
VSTR(""),
VSTR("                                yy_c_buf_p := yytext_ptr;"),
VSTR(""),
VSTR("                                yy_act := YY_STATE_EOF((yy_start - 1) / 2);"),
VSTR(""),
VSTR("                                goto do_action;"),
VSTR("                            else"),
VSTR("                                --  start processing a new file"),
VSTR("                                yy_init := true;"),
VSTR("                                goto new_file;"),
VSTR("                            end if;"),
VSTR("                            end;"),
VSTR("                        when EOB_ACT_RESTART_SCAN =>"),
VSTR("                            yy_c_buf_p := yytext_ptr;"),
VSTR("                            yy_hold_char := yy_ch_buf(yy_c_buf_p);"),
VSTR("                        when EOB_ACT_LAST_MATCH =>"),
VSTR("                            yy_c_buf_p := yy_n_chars;"),
VSTR("                            yy_current_state := yy_get_previous_state;"),
VSTR(""),
VSTR("                            yy_cp := yy_c_buf_p;"),
VSTR("                            yy_bp := yytext_ptr;"),
VSTR("                            goto next_action;"),
VSTR("                        when others => null;"),
VSTR("                        end case; -- case yy_get_next_buffer()"),
VSTR("                when others =>"),
VSTR("                    text_io.put( ""action # "" );"),
VSTR("                    text_io.put( INTEGER'IMAGE(yy_act) );"),
VSTR("                    text_io.new_line;"),
VSTR("                    raise AFLEX_INTERNAL_ERROR;"),
VSTR("            end case; -- case (yy_act)"),
VSTR("        end loop; -- end of loop waiting for end of file"),
VSTR("end YYLex;"),
VSTR("%%"),
VSTR("ERROR tried to output beyond end of skeleton file")
-- END OF SKELETON
); 

  -- set_external_skeleton
  --
  -- DESCRIPTION
  -- sets flag so we know to use an external skelfile

  procedure SET_EXTERNAL_SKELETON is 
  begin
    USE_EXTERNAL_SKELETON := TRUE; 
  end SET_EXTERNAL_SKELETON; 

  procedure GET_INTERNAL(BUFFER : in out FILE_STRING.VSTRING) is 
  begin
    BUFFER := SKEL_TEMPLATE(CURRENT_LINE); 
    CURRENT_LINE := CURRENT_LINE + 1; 
  end GET_INTERNAL; 

  procedure GET_EXTERNAL(BUFFER : in out FILE_STRING.VSTRING) is 
  begin
    FILE_STRING.GET_LINE(MISC_DEFS.SKELFILE, BUFFER); 
  end GET_EXTERNAL; 

  -- end_of_skeleton
  --
  -- DESCRIPTION
  -- returns true if there are no more lines left to output in the skeleton

  function END_OF_SKELETON return BOOLEAN is 
  begin
    if (USE_EXTERNAL_SKELETON) then 

      -- we're using an external skelfile
      return TEXT_IO.END_OF_FILE(MISC_DEFS.SKELFILE); 
    else 

      -- internal skeleton
      return CURRENT_LINE > SKEL_TEMPLATE'LAST; 
    end if; 
  end END_OF_SKELETON; 

  procedure GET_FILE_LINE(BUFFER : in out FILE_STRING.VSTRING) is 
  begin
    if (USE_EXTERNAL_SKELETON) then 
      GET_EXTERNAL(BUFFER); 
    else 
      GET_INTERNAL(BUFFER); 
    end if; 
  end GET_FILE_LINE; 

  -- skelout - write out one section of the skeleton file
  --
  -- DESCRIPTION
  --    Either outputs internal skeleton, or from a file with "%%" dividers
  --    if a skeleton file is specified by the user.
  --    Copies from skelfile to stdout until a line beginning with "%%" or
  --    EOF is found.

  procedure SKELOUT is 
    BUF      : FILE_STRING.VSTRING; 
    LINE_LEN : INTEGER; 
-- UMASS CODES :
    Umass_Codes : Boolean := False;
    -- Indicates whether or not current line of the template
    -- is the Umass codes.
-- END OF UMASS CODES.
  begin
    while (not END_OF_SKELETON) loop
      GET_FILE_LINE(BUF); 
      if ((FILE_STRING.LEN(BUF) >= 2)
          and then ((FILE_STRING.CHAR(BUF, 1) = '%')
                     and (FILE_STRING.CHAR(BUF, 2) = '%'))) then 
        exit; 
      else 
-- UMASS CODES :
--   In the template, the codes between "-- UMASS CODES : " and
--   "-- END OF UMASS CODES." are specific to be used by Ayacc
--   extension. Ayacc extension has more power in error recovery.
--   So we generate those codes only when Ayacc_Extension_Flag is True.
        if FILE_STRING.STR(BUF) = "-- UMASS CODES :" then
          Umass_Codes := True;
        end if;

        if not Umass_Codes or else
           MISC_DEFS.Ayacc_Extension_Flag then 
          FILE_STRING.PUT_LINE(BUF); 
        end if;

        if FILE_STRING.STR(BUF) = "-- END OF UMASS CODES." then
          Umass_Codes := False;
        end if;
-- END OF UMASS CODES.

-- UCI CODES commented out :
--   The following line is commented out because it is done in Umass codes.
--      FILE_STRING.PUT_LINE(BUF);

      end if; 
    end loop; 
  end SKELOUT; 

end SKELETON_MANAGER; 
