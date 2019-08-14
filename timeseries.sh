#!/bin/bash
paths=`pwd`		#allocates the present working directory (pwd) to the variable paths. Whenever the paths is invoked, it gives the pwd.

echo
echo "#####################################################"
echo "#  This script was written by Gyerph.  Feel         #"
echo "# free to modify any part of the code for your use. #"
echo "#####################################################"
echo
echo `date`
echo


echo "What is your starting year?"
read yr_start
echo "What is your ending year?"
read yr_end

#######################################Create a dummy file to allow for creation of date.###############################
# In place of the dummy argument, you could place any file. But then, in such a case, you have to comment 
# echo ${yr_end} > ${dummy_file} else it will overwrite your earlier file. Take extra caution.
########################################################################################################################
dummy=out.dat

dummy_file=${paths}/${dummy}
echo ${yr_end} > ${dummy_file}


output=${paths}/timeseries_${yr_start}_${yr_end}.csv

	if [ -s $output ] ; then  # remove (rm) output if already exists before saving
	rm $output
	fi

     yyyy=$yr_start		#the initial year.

     while [ $yyyy -le $yr_end ]			#while the year is less or equal to the final year.
     do						#loop over the years.

    # Loop over the months in the year
    #################################
     mm=1					#for months. 
     while [ $mm -le 12 ]
     do
      if [ $mm -le 9 ] ; then			#if the month is less or equal to 9, precede it with zero.
        mm=0${mm}
      fi
    
	################################# Days of each of month.
if [ "$mm" = "01" -o "$mm" = "03" -o "$mm" = "05" -o "$mm" = "07" -o  "$mm" = "08" -o "$mm" = "10" -o "$mm" = "12" ] ; then
      days=31
    elif [ "$mm" -eq "04" -o "$mm" -eq "06" -o "$mm" -eq "09" -o "$mm" -eq "11" ] ; then
      days=30
    elif [[ "$mm" = "02" ]]; then
	
	if [[ `expr $yyyy%4` -eq "0" ]] ; then
        days=29				#leap year 
	elif [[ `expr $yyyy%4` -ne "0" ]] ; then
	days=28 
	fi   
     fi

        dd=1
          while [ $dd -le $days ]
          do				#loop from day1 to final day for each individual month.

           if [ $dd -le 9 ] ; then
	      dd=0${dd}
           fi


############## This line creates the timeseries. If you need spaces between your dates, then precede the % with a space.
awk -v yyyy=$yyyy -v mm=$mm -v dd=$dd 'END{printf("%4.4d%2.2d%2.2d \n",yyyy,mm,dd)}' out.dat >> ${output}



	dd=`expr $dd + 1` 	#daily increment
	done

     echo 'Done with', ${mm}
     mm=`expr $mm + 1`	#monthly increment
     done

 echo 'Done with', ${yyyy}
 yyyy=`expr $yyyy + 1`		#annual increment
 done

# The next line removes the dummy file that was created. If you replaced the dummy file, you might have to comment the next line so 
# you don't lose your file.
 rm ${dummy_file}  

 exit
