# nadia
Pipeline for computing MT and DTI metrics using various vertebral levels

## Introduction

This is an analysis pipeline to output the following metrics:
- MT1/MT0 —> MTR
- MT1 —> CSA
- DWI —> FA, RD
Uses a txt file for selecting vertebral level

## Dependencies

[SCT v3.1.2](https://github.com/neuropoly/spinalcordtoolbox/releases/tag/v3.1.2) or above.

## File structure

```
data
  |- 001
  |- 002
  |- 003
      |- t2
        |- t2.nii.gz
      |- mt
	      |- mt1.nii.gz
        |- mt0.nii.gz
      |- dmri
        |- dmri.nii.gz
        |- bvecs.txt
        |- bvals.txt
      |- vertebral_levels.txt  # file that indicates which levels to compute metrics on. E.g.: 3:5 for C3 to C5.
```

## How to run

- Download (or `git clone`) this repository.
- Edit [parameters.sh](./parameters.sh) according to your needs, then save the file.
- **Manual Labeling**: `./run_process.sh 1_label_data.sh`: Click at the posterior tip of two inter-vertebral discs. The discs are indicated on the left of the window. For example, label 3 corresponds to disc C2-C3
- **Process data:** `./run_process.sh 2_process_data.sh`
- **Compute metrics:** `./run_process.sh 3_compute_metrics.sh`

## Contributors

Julien Cohen-Adad

## License

The MIT License (MIT)

Copyright (c) 2018 École Polytechnique, Université de Montréal

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
