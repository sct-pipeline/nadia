#!/bin/bash
#
# This script deals with manual labeling of C2-C3 disc.
#
# NB: add the flag "-x" after "!/bin/bash" for full verbose of commands.
# Julien Cohen-Adad 2018-04-24


# t2
# ===========================================================================================
cd t2
# first, parse vertebral level file to change : in ,
string=`cat ../vertebral_levels.txt`
labels="${string//:/$','}"
# create labels as defined by the txt file. These labels will be used for template registration.
sct_label_utils -i t2.nii.gz -create-viewer ${labels} -o label_discs.nii.gz
cd ..
