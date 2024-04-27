#!/usr/bin/bash
#------------------------------------------------------------------------------#
#                            Programmed By Liz                                 #
#------------------------------------------------------------------------------#
# roll of dice, 1 based
#-------------------------------------------------------------------------------
if (( $# != 2 ))
then
   echo "dice.sh n s"
   echo "n number of dice"
   echo "s sides"
   exit 1
fi
# clear
source ~/data/global.dat
s=$2                                         # sides: values for now 4 6 8
n=$1                                         # number of dice: 2 3 4
e=$(echo "scale=6;$s ^ $n" | bc)
#-------------------------------------------------------------------------------
function fx_disp ()
{                                            # printf here exe before display...
   l=""
   while read a b
   do
      c=${b:0:1}
      h=1                                    # match counter
      for((i=1;i<n;i++))                     # check for doubles...
      do
         d=${b:$i:1}
         if [[ $c == $d ]]
         then
            ((h++))
         fi
         c=$d
      done
      if (( $h == $n ))
      then
         f="$Wht%s$nrm $Mag%s$nrm"           # hilite formatting
         g=" $Mag%s$nrm"
      else
         f="$Wht%s$nrm %s"                   # normal formatting
         g=" %s"
      fi
      if [[ $l == "" ]]
      then
         printf "%15s\r$f" "" "$a" "$b"
      elif [[ $l != $a ]]
      then
         printf "\n$f" "$a" "$b"
      else
         printf "$g" "$b"
      fi
      l=$a
   done
   echo
}
#-------------------------------------------------------------------------------
title-80.sh "1 Based Dice Roll $n x $s Sided\n A:10 B:11 C:12 D:13 E:14 F:15 G:16 H:17 I:18 J:19 K:20\nCombinations: $e   Lowest Sum: $n   Highest Sum: $((s*n))"
echo "SM DICE"
for((i=0;i<$e;i++))                          # decimal scan
do
   b=$(base.sh 10 $s $i)
   l=${#b}
   for((j=0;j<(n-l);j++))
   do
      b="0$b"
   done
   t=0
   z=""
   for((j=0;j<n;j++))                        # pull apart base number
   do
      c=${b:$j:1}
      x=$(base.sh $s 10 $c)                  # for summing
      y=$(base.sh 10 $((s+1)) $((x+1)))      # +1 for dice
      z="$z$y"                               # dice string
      t=$((t+x))                             # sum
   done
   t=$((t+n))                                # adjust sum for dice
   printf "%04d %02d %s\r" "$((e-i))" "$t" "$z" > /dev/stderr
   printf "%02d %s\n" "$t" "$z"
done | sort | fx_disp
#-------------------------------------------------------------------------------
