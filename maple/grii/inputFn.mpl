##*************************************************************************
#
# GRTENSOR II MODULE: inputFn.mpl
#
# (C) 1992-2016 Peter Musgrave, Kayll Lake, Denis Pollney
#
# Date:       		Description:
# 14 Sept. 2016 	Created. Move grF_readstat from makeg [pm]
#-------------------------------------------------------------------

#-------------------------------------------------------------------
# grF_input
#
#-------------------------------------------------------------------
grF_input := proc (userprompt, default_value, prompt_string)

	global grG_test_list, grG_test_index:
	local result;

    # test input support
    if assigned(grG_test_list) and numelems(grG_test_list) > 1 then
    	# use test input
    	if grG_test_index <= numelems(grG_test_list) then
    	   result := grG_test_list[grG_test_index]:
    	   grG_test_index := grG_test_index + 1:
    	   printf("GRTEST: For prompt: %s", userprompt):
    	   printf("GRTEST: Entered: %a\n", result):
    	   return result:

    	else
    	   printf("GRTEST: For prompt: %s", userprompt):
    	   printf(`GRTEST: Out of test data -> QUIT`):
    	   quit:
    	fi:
    else

		if grOptionMapletInput = true then
			return grF_maplet_input(userprompt, default_value, prompt_string):
		else
			return grF_readstat(userprompt, default_value, prompt_string):
		fi:
	fi:
end:

#-------------------------------------------------------------------
# grF_readstat
#-------------------------------------------------------------------

grF_readstat := proc (userprompt, default_value, caller)
local	s, val, oprompt:
	if not assigned ( `readstat/doparse` ) then
          eval (readstat):
    fi:

	oprompt := interface (prompt):
	interface (prompt = ``||caller||`>`):

	# flush stdio to see any preceeding printf
	fflush(default);

	val := 'val':
	while not assigned ( val ) do
		printf ( `%s\n`, userprompt ):
		s := readline():
        # Some inputs parse without a ; on the end, some do not
        # add a semi-colon if not present
        if s[length(s)] <> ";" then
           s := cat(s, ";");
        fi:
		val := traperror (`readstat/doparse` ( s )):
		while val = "incorrect syntax in parse" do
			printf ( `syntax error %s %s`, s, userprompt ):
			s := readline():
			val := `readstat/doparse` ( s ):
		od:
		if val = NULL or val = lasterror 
			or val = "invalid expression" then
			if default_value <> [] then
				val := default_value:
				printf ( `%a\n \n`, val ):
			else
				printf ( `Error in input. Please try again. val=%a\n`, val ):
				val := 'val':
			fi:
		elif val = exit then
                        interface (prompt = oprompt):
			ERROR ( `Exit requested.` ):
		fi:
	od:

	interface (prompt = oprompt):
	RETURN ( val ):
end:


# Invoke the Maplets Elements subpackage.
with(Maplets[Elements]):

# Define the procedure MyProc.
# Prototype from: https://www.maplesoft.com/support/help/maple/view.aspx?path=examples/GetInputMaplet

#-------------------------------------------------------------------
# grF_maplet_input
#-------------------------------------------------------------------

grF_maplet_input := proc (userprompt, default_value, caller)

    # Declare maplet and result as local 
    # variables.
    local maplet, result;

    # Define the Maplet application.
    maplet := Maplet( 'abnormalshutdown' = "FAIL",
        InputDialog['ID1'](
            userprompt,
            'title' = caller,
            'onapprove' = Shutdown( ['ID1'] ),
            'oncancel' = Shutdown( "FAIL" )
        )
    );

    # Run the Maplet application. Assign result to the value
    # returned by the Maplet application.
    result := Maplets[Display]( maplet );
    if result = "exit" then
    	ERROR(`Exit requested`):
    fi:

    if result = "FAIL" then
    	quit
        #error "request failure, an integer was not entered";
    else
        do
            try

                # Try to parse the result.
                result := parse( result[1] );
                return result;
            catch:

                # Define the Maplet application that returns to the user
                # if the result does not parse.
                maplet := Maplet( 'abnormalshutdown' = "FAIL",
                    InputDialog['ID1'](
                        cat("The input does not parse\nTry again.\n", userprompt),
                        'title' = "errordialog",
                        'value' = result[1],
                        'onapprove' = Shutdown( ['ID1'] ),
                        'oncancel' = Shutdown( "FAIL" )
                    )
                );

                result := Maplets:-Display( maplet );

                if result = "FAIL" then
                	quit
                    #error "request failure, an integer was not entered";
                end if;
            end try;
        end do;
    end if;
end proc:

#-------------------------------------------------------------------
# grtestinput([list of prompt, response pairs in order])
#-------------------------------------------------------------------

grtestinput := proc(test_list)

	global grG_test_list, grG_test_index:

	grG_test_list := test_list:
	grG_test_index := 1;

	printf("Added %d test entries", numelems(grG_test_list)):

end proc:

