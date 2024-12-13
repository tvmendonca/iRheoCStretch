# iRheoCStretch
An app to extract complex viscoelasticity from optical tweezer stretch-strain rheology measurements of chromosomes and other single molecules

A detailed explanation of the stretch-strain rheology method can be found in the publication:  
Mendonca, T., et al. *Broadband rheology of single chromosomes reveals new insights into the mitotic chromosome periphery*

Briefly, individual chromosomes are captured between optically trapped beads with an optical tweezer instrument and a stretching force is applied at a rate of 100μm/s. Following this, the optical traps are left stationary and the chromosome response is recorded over 2 minutes. Data from this 2 minute dwell period is input in the iRheo C-Stretch app to generate complex stiffness values. Complex stiffness is defined as the ratio of the Fourier transforms of force F(t), measured as the picoNewton force exerted by the optical traps on the chromosome with time, and strain ε(t), the relative extension of the chromosome in nanometres over time. κ*(ω) is a complex number with real and imaginary parts that describe the elastic κ'(ω) and viscous κ''(ω) components of the chromosome mechanical response.  

#### Installation:
Installer for the i-Rheo C-Stretch app can be downloaded from [https://github.com/tvmendonca/iRheoCStretch/iRheoCStretch_Installer.exe](https://github.com/tvmendonca/iRheoCStretch/blob/main/iRheoCStretch_Installer.exe)  
The installation includes MATLAB Runtime that enables the standalone and free use of the code without a full installation of MATLAB.

#### Useage:
![App Screenshot](https://github.com/tvmendonca/iRheoCStretch/blob/main/img/FigS2_iRheoCStretch.png)

#### Inputs:
A 3xn text ('.txt') file of *data recorded at high frequency*  with the following columns: 
1. time 
2. summed force at both beads over experiment duration 
3. change in length of chromosome over duration of experiment <br/>

#### Outputs:
The app displays four plots: 
1. *Input* **Summed Force vs Time** 
2. *Input* **Extension vs Time** 
3. *Output* **Complex Stiffness - real (elastic k') and imaginary (viscous k'') parts vs Frequency**
4. *Output* **tanδ  (k''/k') vs Lag Time in seconds**

*A text file of frequency, k' and k'' can be exported from the app. Plots can be saved as image files.*

#### Parameters to adjust:
-Initial Extension: chromosome extension relative to its original length at time 0 (start of 2 min recording after extension)
-Initial Force: summed force on both beads at time 0
-Gradient of Extension at Infinite Time: gradient in chromosome extension data at infinite time (default value 0)
-Gradient of Force at Infinite Time: gradient in force at infinite time (default value 0)
-Number of Interpolated Points: upsampling data if needed. Higher values can result in noisy data while too low values can result in errors.
-Number of Plotting Points: plotting density for graphs

## Citing this work
If you use our work, please cite it:

[![DOI](https://zenodo.org/badge/902349673.svg)](https://doi.org/10.5281/zenodo.14422787)

Related publications:

>Smith, M. G., Gibson, G. M. & Tassieri, M. *i-RheoFT: Fourier transforming sampled functions without artefacts.* Sci Rep 11, 24047 (2021).

>Tassieri, M. et al. *i-Rheo: Measuring the materials’ linear viscoelastic properties “in a step ”!* Journal of Rheology 60, 649–660 (2016).
