#!/bin/bash
##### To prepare many inputs for qbox from an xyz file using xyz2qbox.sh but avoiding the prompt
##### It is basically a wrapper for xyz2qbox.py
##### Author: Arpan Kundu


module unload python
module load python
clear

executable=/home/arpank/Scripts/Qbox/util/XYZ2QBOX/xyz2qbox.py

function xyz2qbox {
python3 $executable $1 $2
                  }

tot_arg=`echo "$#"`
if [ "$tot_arg" -lt 1 ]; then
   echo -e "\e[31m No xyz file given as input. Use: many_xyz2qbox.sh file.xyz\e[39m"
   exit
fi

xyz2qbox $1 quit

prompt="\e[32m"
colorexit="\e[39m"
statement="\e[34m"
warning="\e[31m"

#default values
cell_param_default="14.173000 0.000000 0.000000 0.000000 14.173000 0.000000 0.000000 0.000000 14.173000"
qbox_cmd1='' # randomize_wf, run -atomic_density 0 20 10, set xc SCAN, run 0 100 10'       # placeholder for qbox command for 1st iteration 
qbox_cmd2='' # run 0 100 10'       # run command for other iteration  
cube_dir='cube_files/'
plot_cmd=""
save_wf=''     
xc='LDA'
wf_dyn='JD'
ecut='50.0'
scf_tol='1.00e-7'
nempty='120'
pseudo=''


echo 
echo
echo -e "${statement}-----------------------------------${colorexit}"
echo -e "${statement}        File related inputs        ${colorexit}"
echo -e "${statement}-----------------------------------${colorexit}" 

echo -n -e "${prompt}File prefix: ${colorexit}"
read file_prefix
echo -n -e "${prompt}File start index: ${colorexit}"
read it_start
echo -n -e "${prompt}File end index: ${colorexit}"
read it_end

echo -e "${statement}---------------------------------------------${colorexit}"
echo -e "${statement}     XYZ2QBOX related inputs       ${colorexit}"
echo -e "${statement}---------------------------------------------${colorexit}" 
echo -n -e "${prompt} Enter start frame number : ${colorexit}"
read shift_from_origin
echo -n -e "${prompt} Trajectory length (in terms of $1) you want to put in a single qbox input : ${colorexit}"
read length
echo -n -e "${prompt} Enter step frame number : ${colorexit}"
read step_frame
echo -n -e "${prompt} Cell parameter string (inactivated for i-PI output) : ${colorexit}"
read cell_param
if [ -z "$cell_param" ]; then
   #echo "cell_param empty"
   cell_param=`echo $cell_param_default`
fi

echo -e "$statement-----------------------------------------------------$colorexit"
echo -e "$statement         Starting preparing Qbox input               $colorexit"
echo -e "$statement  using $executable  $colorexit"
echo -e "$statement-----------------------------------------------------$colorexit"




for it in `seq ${it_start} ${it_end}`
do
    let start_frame=(${it}-${it_start})*${length}+${shift_from_origin}
    let end_frame=(${it}-${it_start}+1)*${length}+${shift_from_origin}-1
    printf "$start_frame\n$end_frame\n$step_frame\n$qbox_cmd1\n$qbox_cmd2\n$plot_cmd\n$save_wf\n${file_prefix}-${it}.i\n$xc\n$wf_dyn\n$ecut\n$scf_tol\n$nempty\n$pseudo\n" | xyz2qbox $1 no-info
    if [ `grep -c 'set cell' ${file_prefix}-${it}.i` -eq 0 ]; then 
      sed -i "/# Frame/a \ set cell $cell_param" ${file_prefix}-${it}.i
      echo -e "\e[44m For all configurations, cell parameters (in bohr) are set to: $cell_param \e[49m" 
    fi
    echo -e "$statement-----------------------------------------------------$colorexit"
    echo -e "$statement          Iteration No $it finished                  $colorexit"
    echo -e "$statement-----------------------------------------------------$colorexit"
done

module unload python
