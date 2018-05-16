#!/bin/bash
#
# This script processes data: centerline extraction, vertebral labeling, segmentation and registration to the template.
#
# NB: add the flag "-x" after "!/bin/bash" for full verbose of commands.
# Julien Cohen-Adad 2018-04-24


# mt
# ===========================================================================================
cd mt
# segment cord (if manual correction exists, skip that step)
if [ -d "mt1_seg_manual.nii.gz" ]; then
  file_seg="mt1_seg_manual.nii.gz"
else
  # segment cord
  sct_deepseg_sc -i mt1.nii.gz -c t2 -qc ${PATH_QC}
  file_seg="mt1_seg.nii.gz"
fi
# create mask for faster processing
sct_create_mask -i mt1.nii.gz -p centerline,${file_seg} -size 45mm
# crop data
sct_crop_image -i mt1.nii.gz -m mask_mt1.nii.gz -o mt1_crop.nii.gz
sct_crop_image -i mt0.nii.gz -m mask_mt1.nii.gz -o mt0_crop.nii.gz
# Create close mask around spinal cord (for more accurate registration results)
sct_create_mask -i mt1_crop.nii.gz -p centerline,${file_seg} -size 35mm -f cylinder
# Register mt0 on mt1
# Tips: here we only use rigid transformation because both images have very similar sequence parameters. We don't want to use SyN/BSplineSyN to avoid introducing spurious deformations.
sct_register_multimodal -i mt0_crop.nii.gz -d mt1_crop.nii.gz -param step=1,type=im,algo=rigid,slicewise=1,metric=CC -m mask_mt1_crop.nii.gz -x spline
# Register template to mt1
# Tips: First step: slice-wise translation based on segs to capture potential motion between anat and mt, then at second step: bpslinesyn in order to adapt the shape of the cord to the mt modality (in case there are distortions between anat and mt).
sct_register_to_template -i mt1_crop.nii.gz -s ${file_seg} -ldisc ../t2/label_discs.nii.gz -ref subject -param step=1,type=seg,algo=centermassrot:step=2,type=seg,algo=bsplinesyn,slicewise=1,iter=3:step=3,type=im,algo=bsplinesyn,slicewise=1,iter=3 -qc ${PATH_QC}
# Warp template
sct_warp_template -d mt1_crop.nii.gz -w warp_template2anat.nii.gz
# Compute mtr
sct_compute_mtr -mt0 mt0_crop_reg.nii.gz -mt1 mt1_crop.nii.gz
# Go back to root folder
cd ..


# dmri
# ===========================================================================================
cd dmri
# average DWI data
sct_dmri_separate_b0_and_dwi -i dmri.nii.gz -bvec bvecs.txt -a 1
# detect cord centerline
sct_get_centerline -i dwi_mean.nii.gz -c dwi
# create VOI centered around spinal cord
sct_create_mask -i dwi_mean.nii.gz -p centerline,dwi_mean_centerline_optic.nii.gz -size 45 -f cylinder -o mask_dwi.nii.gz
# crop data (for faster processing)
sct_crop_image -i dmri.nii.gz -m mask_dwi.nii.gz -o dmri_crop.nii.gz
# motion correction across volumes
# tips: here we use -g 5 because the SNR is abnormally low
sct_dmri_moco -i dmri_crop.nii.gz -bvec bvecs.txt -g 5 -x spline -r 0
# compute DWI
sct_dmri_compute_dti -i dmri_crop_moco.nii.gz -bvec bvecs.txt -bval bvals.txt
# if manual correction exists, select it.
if [ -d "dwi_moco_mean_seg_manual.nii.gz" ]; then
  file_seg="dwi_moco_mean_seg_manual.nii.gz"
else
  # segment cord
  sct_propseg -i dwi_moco_mean.nii.gz -c dwi -qc ${PATH_QC}
  file_seg="dwi_moco_mean_seg.nii.gz"
fi
# Register to template
sct_register_to_template -i dwi_moco_mean.nii.gz -s ${file_seg} -ldisc ../t2/label_discs.nii.gz -c t1 -ref subject -param step=1,type=seg,algo=centermassrot:step=2,type=seg,algo=bsplinesyn,slicewise=1,iter=3 -qc ${PATH_QC}
# warp template
sct_warp_template -d dwi_moco_mean.nii.gz -w warp_template2anat.nii.gz
