#!/bin/bash
wcll () {
    if [ $2 = 0 ]; then
        cat "$1/c.txt"
        cdir="$1"
    elif [ true ]; then
        cdir="$3"
        d="$2"
    fi
    i=$( cat "$cdir/c.txt" | xargs expr )
    y=""
    z=""
    for s in $( ls -x $1 )
    do
        y=$( stat $s | grep file )
        z=$( stat $s | grep directory )
        if [ "$z" != ""  ]; then
           cd "$1/$s/"
           d=$(( $d + 1 ))
           zz=$( wcll "$1/$s" "$d" "$cdir" )
           i=$(( $i + $zz ))
           cd "$1"
        elif [ "$y" != "" ]; then
            x=$( wc -l "$1/$s" | grep -o -E "[0-9]+[[:space:]]" | grep -o -E "[0-9]+" )
            if [ "$x" != "" ]; then
                i=$(( $i + $x ))
            fi
        fi
    done
    rm "$cdir/c.txt"
    echo "$i" > "$cdir/c.txt"
    echo "$i"
    return 0;
}
echo 0 > "$PWD/c.txt"
wcll $PWD 0 $PWD
echo "line count is "
cat $PWD/c.txt
exit 0
