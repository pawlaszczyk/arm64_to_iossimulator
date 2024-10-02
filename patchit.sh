# Bash
#!/bin/sh
get_current_directory() {
    current_file="${PWD}/${0}"
    echo "${current_file%/*}"
}

patch(){

  xcrun vtool -arch arm64 -set-build-version 7 12.0 12.0 -replace -output  "$f"  "$f" &>/dev/null
  codesign -f -s -  "$f" &>/dev/null
  echo "done."
}

patchplist(){
(
   defaults write ${PWD}/Info.plist "DTPlatformName" 'iphonesimulator'
   defaults write ${PWD}/Info.plist "DTSDKName" ''
   defaults write ${PWD}/Info.plist "CFBundleSupportedPlatforms" -array "iPhoneSimulator"
   codesign -f -s -  ${PWD}/Info.plist
)
echo "patching" ${PWD}/Info.plist "done."
}


i=0

if [ $# -eq 0 ]
  then
    echo "No arguments supplied, please specify <Appname.app>"
fi

if [[ $1 == *".app"* ]]; then
  echo "It seems to be an app directory "
fi

now="$(cut -d . -f 1 <<< $1)"
# now= echo "$f" | sed -r "s/.+\/(.+)\..+/\1/"
echo $1 "/" $now
xcrun vtool -arch arm64 -set-build-version 7 12.0 12.0 -replace -output $1/$now $1/$now
codesign -f -s - $1/$now
let "i+=1"

cd $1

RESULT=$(patchplist)

if [ -d "Frameworks" ]; then
  echo " Frameworks folder does exist."
  cd Frameworks
  CWD=$(get_current_directory)
  echo "$CWD"

  for f in ${CWD}/*.dylib
  do
	   echo patching dylib file - "$f" ...
     RESULT=$(patch)
     let "i+=1"
  done

  for f in ${CWD}/*.framework
  do
	   echo patching xcframework file - "$f" ...
     value=$( echo "$f" | sed -r "s/.+\/(.+)\..+/\1/" )
     echo "$value"
     # f= $( echo "$f/$value" )
     f+="/$value"
     RESULT=$(patch)
     let "i+=1"
  done

  for f in ${CWD}/*.framework
  do
	   cd $f
     RESULT=$(patchplist)
     cd ..
  done


fi

echo "Successfully patched " "$i" "files in " $1
