#!/bin/bash

programs=(
	jpegoptim
	jpegtran
	jpegrescan
	mozjpeg
)

declare -A program_arguments
program_arguments=(
	[jpegoptim]="--strip-all --all-progressive -q --dest=[output] [file]"
	[jpegtran]="-copy none -optimize -progressive -outfile [output][file] [file]"
	[jpegrescan]="-s -q [file] [output][file]"
	[mozjpeg]="-copy none -outfile [output][file] [file]"
)

# gets current timestamp in milliseconds
getTime() {
        echo $(($(date +%s%N)/1000000))
}

# create dirs for saving optimised images in
for program in "${programs[@]}"; do
	mkdir $program
done

# navigate to the files dir
cd files

# loop through all jpgs
for file in *.jpg; do

	# get original file size
	filesize=$(stat -c%s "$file")
	
	echo "$file | $filesize bytes"
	echo "-------------"

	# process file using each program
	for program in "${programs[@]}"; do
	
		# new file name
		new_file="../$program/$file"
		
		# generate arguments
		arguments=${program_arguments[$program]}
		arguments=${arguments//"[file]"/$file}
		arguments=${arguments//"[output]"/"../$program/"}
		
		# generate command
		command="$program $arguments"
		
		# register start time
		start_time=$(getTime)
	
		# run command
		$command
		
		# register time taken
		time_taken=$(($(getTime) - $start_time))

		# get optimized filesize
                if [ -e "$new_file" ]
                then
                        new_filesize=$(stat -c%s "$new_file")
                        rm $new_file
                else
                        new_filesize=$filesize
                fi

                # get real and percentage filesize differences
		filesize_diff=$(($filesize - $new_filesize))
		filesize_percent="reduction of $(echo "scale=5; ($filesize_diff / $filesize) * 100" | bc)%"

		if [ "$filesize_diff" -gt "0" ]; then
			output_filesize_diff="$filesize_diff bytes smaller"
		else
			output_filesize_diff="$filesize_diff bytes bigger"
		fi

		echo "$program | ${time_taken}ms | $output_filesize_diff | ${filesize_percent}"

	done

	echo ""

done

# clean up
cd ..
for program in "${programs[@]}"; do
	rm -R $program
done

exit
