--
-- Backup all my Evernote things!
--

-- Backup file
set f to "/Users/rob/Desktop/Export.enex"

with timeout of (30 * 60) seconds
    tell application "Evernote"
        -- Set date to 1990 so it finds all notes
        set matches to find notes "created:19900101"
        -- export to file set above
        export matches to f
    end tell
end timeout

-- Compress the file
set p to POSIX path of f
do shell script "/usr/bin/gzip " & quoted form of p
