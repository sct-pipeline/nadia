#!/bin/bash
#
# This script extract metrics.
#
# NB: add the flag "-x" after "!/bin/bash" for full verbose of commands.
# Julien Cohen-Adad 2018-05-07

mkdir ${PATH_RESULTS}

# mt
# ===========================================================================================
cd mt
# Extract MTR within the white matter at level specified by text file
sct_extract_metric -i mtr.nii.gz -method map -o ${PATH_RESULTS}MTR_in_WM.xls -l 51 -vert `cat ../vertebral_levels.txt`
# compute the spinal cord cross-sectional area (CSA)
sct_process_segmentation -i ${file_seg} -p csa -vert `cat ../vertebral_levels.txt` -ofolder ${PATH_RESULTS}CSA
# Go back to root folder
cd ..


# dmri
# ===========================================================================================
cd dmri
# Extract DTI within the white matter at level specified by text file
sct_extract_metric -i dti_FA.nii.gz -method map -o ${PATH_RESULTS}FA_in_WM.xls -l 51 -vert `cat ../vertebral_levels.txt`
sct_extract_metric -i dti_RD.nii.gz -method map -o ${PATH_RESULTS}RD_in_WM.xls -l 51 -vert `cat ../vertebral_levels.txt`
