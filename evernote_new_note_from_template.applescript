global template_notebook -- notebook which contains the template notes
global template_tag -- tag for template notes
global show_note_in_new_window
global new_note_notebook
set new_note_notebook to "_Inbox" -- notebook where the new note will be placed
set meeting_template to "Meeting Notes"
set template_notebook to "_Templates" -- change this if your template notebook has another name
set template_tag to "template" -- change this if you will; tag your template notes with this tag
set show_note_in_new_window to true

if not check_template_notebook_existence() then -- check if template notebook exists; if not: quit
	no_template_notebook_found()
	return
end if

set template_name to meeting_template -- user chooses a template note

set new_note to create_note_using_template from template_name -- create new note from template				

show_note(new_note)

tell application "System Events" to set frontmost of process "Evernote" to true

on create_note_using_template from template_title
	
	tell application "Evernote"
		set query_string to "notebook:\"" & template_notebook & "\" tag:\"" & template_tag & "\" inTitle:\"" & template_title & "\""
		set template_list to find notes query_string
		set template_note to item 1 of template_list
		tell me to set new_note_title to create_new_note_title from template_title
		set template_content to ENML content of template_note
	end tell
	
	-- Insert current date in template note
	set today_string to (date string of (current date))
	-- set the template_content to replaceText(template_content, "DATEHERE", today_string)
	tell application "Evernote"
		set new_note to Â
			create note title new_note_title with html template_content Â
				notebook new_note_notebook
		set the_tags to (the tags of template_note)
		assign the_tags to new_note
		repeat with t in the_tags --remove tag named template
			if (name of t) is equal to template_tag then
				unassign t from new_note
			end if
		end repeat
		count (every item of the_tags)
		return new_note
	end tell
end create_note_using_template

on create_new_note_title from template_title
	-- create default note title
	set today_string to (date string of (current date)) as text
	set new_note_title to (template_title & " (" & today_string as string) & ")"
	-- see if user wants to enter his/her own note title
	-- set dialogResult to display dialog Â
	--	"Enter new note title or accept the default title" buttons {"OK"} Â
	--	default button Â
	--	"OK" default answer (new_note_title)
	-- set new_note_title to text returned of dialogResult
	return new_note_title
end create_new_note_title

on show_note(new_note)
	tell application "Evernote"
		if show_note_in_new_window then
			open note window with new_note
		else
			set query string of window 1 to "notebook:\"" & new_note_notebook & "\""
			
		end if
	end tell
end show_note

on check_template_notebook_existence()
	tell application "Evernote"
		try
			get the first notebook whose name is equal to template_notebook
		on error
			return false
		end try
	end tell
	return true
end check_template_notebook_existence

on no_notebooks_found()
	display dialog ("Evernote does not contain any notebooks.")
end no_notebooks_found


on no_template_notebook_found()
	display dialog "The notebook for templates: \"" & template_notebook & "\" does not exist"
end no_template_notebook_found

on no_template_found()
	display dialog ("No templates found ") Â
		& ("in notebook \"" & template_notebook & "\"" & return & return) Â
		& ("with tag \"" & template_tag & "\"")
end no_template_found

on simple_sort(my_list)
	set the index_list to {}
	set the sorted_list to {}
	repeat (the number of items in my_list) times
		set the low_item to ""
		repeat with i from 1 to (number of items in my_list)
			if i is not in the index_list then
				set this_item to item i of my_list as text
				if the low_item is "" then
					set the low_item to this_item
					set the low_item_index to i
				else if this_item comes before the low_item then
					set the low_item to this_item
					set the low_item_index to i
				end if
			end if
		end repeat
		set the end of sorted_list to the low_item
		set the end of the index_list to the low_item_index
	end repeat
	return the sorted_list
end simple_sort