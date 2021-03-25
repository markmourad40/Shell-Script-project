#!/usr/bin/bash
select choice in "Create Databases" "List Databases" "Connect to Databases" "Drop Databases" "Exit"
do
	case $choice in
		"Create Databases")
			echo What is the name of the database you want to create?
			mkdir -p db
			read dbname
			cd db
			mkdir $dbname
			cd $dbname
			cd ..
			cd ..
			;;
		"List Databases") 
			cd db
			ls
			cd ..
			;;
		"Connect to Databases") 
			echo Which database do you want to connect?
			cd db
			ls
			read dbname
			cd $dbname
			select choice in CreateTables  ListTables  DropTable InsertIntoTable SelectFromTable DeleteFromTable exit
			do
				case $choice in
					CreateTables)
						echo How many tables do you want to create?
						read num 
						for (( c=1; c<=$num; c++ ))
						do
							echo What is the name of the table?
							read tname
							touch $tname.csv
							echo How many columns do you want this table to contain?
							read colmnum
							for (( t=1; t<=$colmnum; t++ ))
							do
								echo What is the name of the column?
								read colmname
								sep=${colmname}':'
								printf $sep >> $tname.csv
							done;
							printf '\n' >> $tname.csv
						done
						;;
					ListTables)
						ls | grep '\.csv$' 
						;;
					InsertIntoTable)
						echo What is the name of the table that you want to insert into the data? 
						ls | grep '\.csv$'
						read tableName
						awk -F: '{ print (NR==1) ?  NF :""}' $tableName.csv > c.txt
						tableAttr=$(awk '{ print (NR==1) ?  $0 :""}' $tableName.csv)
						var=$(<c.txt)
						echo ${tableAttr[0]}
						for (( c=1; c<var; c++ ))
						do
							echo Enter the value
							read value
							sep=${value}':'
							printf $sep >> $tableName.csv
						done
						printf '\n' >> $tableName.csv
						;;
					SelectFromTable)
						echo What is the name of the table that you want to from it the data? 
						ls | grep '\.csv$'						
						read name
						cat $name.csv
						;;
					DeleteFromTable)
						echo What is the name of the table that you want to delete from it?
						ls | grep '\.csv$'
						read name
						echo What is the number of the row that you want to delete?
						read num
						declare -i x=1
						declare -i y=$num
						declare -i z=0
						z=$(( y + x ))
						sed -i $z'd' $name.csv
						;;
					exit)
						exit
						;;
					DropTable) echo What is the name of the table that you want to drop it? 
						ls | grep '\.csv$' 
						read tname
						rm $tname.csv
						;;
				esac
			done
			;;
		"Drop Databases")
			echo What is the name of the database that you want to drop it? 
			cd db
			ls			
			read dbname 
			rm -r $dbname
			cd ..
			;;
		"Exit")
			exit
			;;
		*) echo $REPLY is a wrong choice! 
			;;
	esac
done

