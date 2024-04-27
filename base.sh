#!/usr/bin/bash
#------------------------------------------------------------------------------#
#                            Programmed By Liz                                 #
#------------------------------------------------------------------------------#
# base.sh fr to nn
#
# base converter 2 -> 36
# need to define 'obase' first because after 'ibase' defined it's all ibase
#     echo "obase=$o;ibase=$i;y=$x;print y" | bc)
# base > 16   accepts A -> Z input but outputs 00 -> 36
#     00 -> 36 converted to A -> Z using hex
#-------------------------------------------------------------------------------
if [[ "$1" == "-h" ]] || (($#<3))
then
   echo "usage: base.sh base_from base_to number [-v]"
   echo "       -v optional verbose output"
else
   if [[ "$*" =~ "-v" ]]                           # verbose flag
   then
      f=1
   else
      f=0
   fi
   o=$2
   i=$1
   x=${3^^}                                        # all caps
   if ((f))                                        # verbose
   then
      echo -n "$x b$i -> "
   fi
   y=$(echo "obase=$o;ibase=$i;y=$x;print y" | bc) # convert bases
   if ((o>16))
   then                                            # special processing
      read -a a <<< "$y"                           # array processing
      for ((i=0;i<${#a[*]};i++))                   # scan array
      do
         q=$(echo "${a[$i]}")                      # get array element
         q=${q#0}                                  # strip leading 0 octal
         if [[ $q == "" ]]                         # single zero glitch
         then
            q=0
         fi
         if ((q<10))
         then                                      # 0 -> 9
            echo -n "$q"
         else                                      # 10 -> 36 ->-> A -> Z
            x=$((q+55))                            # add chr offset
            c="\\x"$(echo "obase=16;ibase=10;y=$x;print y" | bc) # q -> hex
            printf "%b" "$c"                       # print hex chr
         fi
      done
      if ((f))                                     # verbose
      then
         echo " b$o"
      else
         echo
      fi
   else                                            # standard processing
      if ((f))                                     # verbose
      then
         echo "$y b$o"
      else
         echo "$y"
      fi
   fi
fi
#-------------------------------------------------------------------------------
