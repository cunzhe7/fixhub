# Replication, Made Easy!
# A Zachary Ferretti Script

# ..............................................................................
#   The Point of This file is to be a one-stop shop for replicating the results
#   of SimFix! The way that it works is that you would move this shell script
#   into the '(pathToReplicationPackage)/simfix/' directory where you have downloaded the replica-
#   tion study. Then you would run this script and it will automatically for
#   each of the bugs in the SimFix paper that it correctly patched (34) it will
#   automatically download them and then run SimFix on them, resulting in
#   eventually a marking of "Successfully Repaired!"
# ..............................................................................

# Chart Script Section - 4 Bugs
declare -a arr=(1 3 7 20)
for i in "${arr[@]}"
do
    echo $i
    ./run.sh chart "$i"
done


# Closure Script Section - 6 Bugs
declare -a arr=(14 57 62 63 73 115)
for i in "${arr[@]}"
do
    echo $i
    ./run.sh closure "$i"
done


# Lang Script Section - 9 Bugs
declare -a arr=(16 27 33 39 41 43 50 58 60)
for i in "${arr[@]}"
do
    echo $i
    ./run.sh chart "$i"
done


# Math Script Section - 14 Bugs
declare -a arr=(5 33 35 41 50 53 57 59 63 70 71 75 79 98)
for i in "${arr[@]}"
do
    echo $i
    ./run.sh closure "$i"
done


# Time Script Section - 1 Bugs
declare -a arr=(7)
for i in "${arr[@]}"
do
    echo $i
    ./run.sh closure "$i"
done
