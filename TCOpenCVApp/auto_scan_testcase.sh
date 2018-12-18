#! /bin/sh

path=$(pwd)/TCOpenCVApp/TestCase
infoPath=$(pwd)/testcase.info

echo "begin auto scan test case in $path"

result=""

for file in $(ls $path)
do

    if [ -f $path/$file ] && [ ${file##*.} == "h" ]
    then
        name=${file%%.*}
        echo "find $name"
        result=$result","$name
    fi
done

(
    rm -rf $infoPath
    echo $result >> $infoPath
)
echo "save in $infoPath"