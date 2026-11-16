# This script opens each sound file in a directory, looks for a corresponding TextGrid in (possibly) a different directory, 
# and extracts f0, F1, F2 and intensity from the midpoint(s) of any labelled interval(s) in the specified TextGrid tier.  
# It also extracts the duration of the labelled interval(s) as well as labels from other intervals located at the same midpoint(s) on other tiers. 
# All these results are written to a tab-delimited text file.
# The script is a modified version of the script "collect_formant_data_from_files.praat" by 
# Mietta Lennes, available here: http://www.helsinki.fi/~lennes/praat-scripts/
# This script was first modified by Dan McCloy (drmccloy@uw.edu) in December 2011 and
# later modified to add intensity and labels from other tiers by Esther Le Grézause (elg1@uw.edu) in May 2016.
# This script is distributed under the GNU General Public License.
# Copyright 4.7.2003 Mietta Lennes
##modified  by E.Ramdinmawii 14/08/2021 10/10/2021		25/11/2021

form Get pitch formants intensity and duration from labeled segments in files
	comment Directory of sound files. Be sure to include the final "/"
	text sound_directory  E:/TU_mtech/4_SEMESTER/current/new_assamese/
	sentence Sound_file_extension .wav
	comment Directory of TextGrid files. Be sure to include the final "/"
	text textGrid_directory E:/TU_mtech/4_SEMESTER/current/new_assamese/
	sentence TextGrid_file_extension .TextGrid
	comment Full path of the resulting text file:	
	text resultsfile  E:/TU_mtech/4_SEMESTER/current/new_assamese/M_ASSAMESE_INTENSITY.txt
	comment Which tier do you want to analyze?	
	integer Tier 3
	#comment Pitch analysis parameters
	positive Time_step 0.01
	#positive Window_length_(s) 0.025
	#real Preemphasis_from_(Hz) 50
	positive Pitch_time_step 0.01
	positive Minimum_pitch_(Hz) 50
	positive Maximum_pitch_(Hz) 300
endform

# Make a listing of all the sound files in a directory:
Create Strings as file list... list 'sound_directory$'*'sound_file_extension$'
numberOfFiles = Get number of strings

# Assigning tier number (this is the tier-number of your annotation in the TextGrid. Since there is only one tier required for our dataset, I have put 1 here for you)
word_tier = 1


# Check if the result file exists:
if fileReadable (resultsfile$)
	pause The file 'resultsfile$' already exists! Do you want to overwrite it?
	filedelete 'resultsfile$'
endif

# Create a header row for the result file:
header$ = "Filename	phoneLabel	intensityMin	intensityMax	intensityAvg	intensityStdev	intensityRange	'newline$'"
fileappend "'resultsfile$'" 'header$'

# Open each sound file in the directory:
for ifile to numberOfFiles
	filename$ = Get string... ifile
	Read from file... 'sound_directory$''filename$'

	# get the name of the sound object:
	soundname$ = selected$ ("Sound", 1)

	# Look for a TextGrid by the same name:
	gridfile$ = "'textGrid_directory$''soundname$''textGrid_file_extension$'"

	# if a TextGrid exists, open it and do the analysis:
	if fileReadable (gridfile$)
		Read from file... 'gridfile$'

		select Sound 'soundname$'
		To Pitch... pitch_time_step minimum_pitch maximum_pitch
		
		select Sound 'soundname$'
		To Intensity... minimum_pitch time_step

		select TextGrid 'soundname$'
		numberOfIntervals = Get number of intervals... tier

		# Pass through all intervals in the designated tier, and if they have a label, do the analysis:
		for interval to numberOfIntervals
			label$ = Get label of interval... tier interval
			if label$ <> ""
				# duration:
				start = Get starting point... tier interval
				end = Get end point... tier interval
				duration = end-start
				midpoint = (start + end) / 2
				# get the matching interval (at the midpoint)
				word_interval = Get interval at time... word_tier midpoint
				# get label of interval in the word tier
				label_word$ = Get label of interval... word_tier word_interval				
				# intensity:
				select Intensity 'soundname$'
				intensityMax = Get maximum... start end Cubic
				intensityMin = Get minimum... start end Cubic
				intensityRange = intensityMax - intensityMin
				intensityStdev = Get standard deviation... start end
				intensityMean = Get mean... start end

				# Save result to text file:
				resultline$ = "'soundname$'	'label_word$'	'intensityMin'	'intensityMax'	'intensityMean'	'intensityStdev'	'intensityRange'	'newline$'"	
				fileappend "'resultsfile$'" 'resultline$'

				# select the TextGrid so we can iterate to the next interval:
				select TextGrid 'soundname$'
			endif
		endfor
		# Remove the TextGrid, Formant, and Pitch objects
		select TextGrid 'soundname$'

		Remove
	endif
	# go on with the next sound file!
	select Strings list
endfor

# When everything is done, remove the list of sound file paths:
Remove