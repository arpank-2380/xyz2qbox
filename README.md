-----------------------------------------------------------------------------------------------------------------
XYZ2Qbox is a command line tool to sample a XYZ trajectory and create an input file containing qbox command stream.
This can be used to resample a trajectory and run specific things such as Kohn-Sham eigenvalues with an user 
specified sampling frequency.  
The code would ask specific questions in command prompt which are self explanatory.
-----------------------------------------------------------------------------------------------------------------
File                     description
-----------------------------------------------------------------------------------------------------------------
xyz2qbox.py        This is the main code
xyz2qbox.sh        A bash wrapper which loads the useful modules required to run on RCC,U Chicago, Midway cluster.
many_xyz2qbox.sh   Another bash wrapper where A trajectory can be divided into many input files so that they can be
                   submitted as separate qbox jobs. This too will use xyz2qbox.py script.
