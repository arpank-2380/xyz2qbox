#!/bin/bash
module unload python
module load python
clear
python3 /home/arpank/Scripts/Qbox/util/XYZ2QBOX/xyz2qbox.py $1 
module unload python 
