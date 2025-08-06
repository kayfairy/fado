#!/bin/bash
wcll () {
    if [ $2 == 0 ]; then
        cat "$1/c.txt"
        cdir="$1"
    elif [true]; then
        cdir="$3"
        d="$2"
    fi
    cat "$cdir/c.txt"
    i=$(( $? ))
    y=""
    z=""
    for s in $(ls -x $1)
    do
        stat "$1/$s"
        y=$(echo "$?" | grep File)
        stat "$1/$s"
        z=$(echo "$?" | grep directory)
        if [ "$z" != ""  ]; then
           echo "Enter $1/$s"
           cd "$1/$s/"
           d=$(( $d + 1 ))
           wcll "$1/$s" "$d" "$cdir"
           i=$(( $i + $? ))
           cd "$1"
        elif [ "$y" != "" ]; then
            wc -l "$1/$s" | grep -o -E '(^[0-9]+?)[[:space:]].+?$'
            if [ "$?" != "" ]; then
                wc -l "$1/$s" | grep -o -E '(^[0-9]+?)[[:space:]].+?$'
                i=$(( $i + $? ))
            fi
        fi
    done
    echo "$i" > "$cdir/c.txt"
    return "$i";
}
echo 0 > "$FWD/c.txt"
wcll $PWD 0 $PWD
echo $?
echo "word count is "
cat $PWD/c.txt
exit 0
