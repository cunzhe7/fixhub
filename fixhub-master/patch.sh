#!/bin/bash

# Patch Testing, The FixHub Way!
# A Zachary Ferretti Script

# ..............................................................................
#		MAKE SURE TO RUN THIS FROM WITHIN THIS FOLDER:
#				- (replicationPackagePath)/simfix/runnable/patch
#
#   The point of this file is to make it easy for us to automatically test the
#   patches that we generate using SimFix when we run either the
#   "automateReplication.sh" script. The gist of this script is to for each
#		folder in this directory take all of the patches it has within it, and first
#		compile/test the current buggy version , it will fail , then replace the
#		problematic file with the patched version and re-compile/re-test it.
#
#		This script is primarily how we extended our research to actually check the
#		the patches that we generated.
# ..............................................................................

if [ -d "bugs" ]; then rm -rf bugs; fi
mkdir bugs
array=( $(find -name "*.java") )
for i in "${array[@]}"
do
	:
	# For every file path in the array entry we separate it here
	#	into the corresponding parts (what project it is in,
	#	what bug id, as well as create the corresponding direc-
	#	tories for each one. We then cd out of those directories
	#	back into the main /patch/ directory.
	IFS='/' read -ra ADDR <<< "$i"
	upperCaseProject="${ADDR[1]^}"
	bugID="${ADDR[2]}"
	cd bugs
	mkdir "$upperCaseProject"
	cd "$upperCaseProject"
	mkdir "$bugID"
	cd ..
	cd ..

	# Now we check out the corresponding buggy version from defects4j
	#	into the " /patch/bugs/'project'/'bugID' " directory. Then
	#	we find the name of the file we will be replacing with the
	#	patch and also remove the first two characters (which will
	#	be "1_" as that is how the patches are named when they are
	#	generated.
	defects4j checkout -p "$upperCaseProject" -v "$bugID"b -w ./bugs/"$upperCaseProject"/"$bugID"
	fileName=$(echo "${ADDR[4]}" | cut -d"_" -f 2)

	# At this point we now move to " patch/bugs/'project'/'id' "
	# 	for example.We now will need to copy the file at index $i
	# 	to the corresponding directory at strippedPath.
	echo ""
	echo ""
	echo ""
	echo "###################"
	cd bugs
	cd "$upperCaseProject"
	cd "$bugID"
	defects4j compile
	defects4j test
	buggyFile=( $(find -name "$fileName") )
	pathTo=$(dirname $buggyFile)

	cd ..
	cd ..
	cd ..
	# We are now back to the /runnable/patch directory. From here we will
	#	copy the patched Java file at $i to the $pathTo.
	strippedPath="${pathTo:2}"
	rm ./bugs/"$upperCaseProject"/"$bugID"/"$strippedPath"/"$fileName"
	cp $i ./bugs/"$upperCaseProject"/"$bugID"/"$strippedPath"/"$fileName"
	cd ./bugs/"$upperCaseProject"/"$bugID"
	echo "Successfully copied the patched file!"
	defects4j compile
	defects4j test

	echo "###################"
	echo ""
	echo ""
	echo ""

	cd ..
	cd ..
	find -name "$fileName" -delete
done
