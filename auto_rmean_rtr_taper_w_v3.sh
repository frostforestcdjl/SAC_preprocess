#!/bin/bash

ls 19* 20* > log_before

PZsE=$(ls response/*BHE*)
PZsN=$(ls response/*BHN*)
PZsZ=$(ls response/*BHZ*)

st=${PZsZ:20:4}

for i in 19* 20* ; do

echo "python begin ---"
python SAC_trim_raw_day_window_BHEN*.py $i 0
echo "python end -----"

        sac <<EOF
        echo on
        read $i/*BHE.trim.SAC
        rmean; rtr; taper
        transfer from polezero subtype ${PZsE} to vel freqlimits 0.001 0.002 8 10
        w $i/${st}.BHE.SAC

        read $i/*BHN.trim.SAC
        rmean; rtr; taper
        transfer from polezero subtype ${PZsN} to vel freqlimits 0.001 0.002 8 10
        w $i/${st}.BHN.SAC

        read $i/*BHZ.trim.SAC
        rmean; rtr; taper
        transfer from polezero subtype ${PZsZ} to vel freqlimits 0.001 0.002 8 10
        w $i/${st}.BHZ.SAC

        quit
EOF
rm $i/TW.*SAC
rm $i/*trim.SAC
done

ls 19* 20* > log_after
