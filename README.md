# SWOT_VGG

SWOT L2 low-rate data processing is done at process_one.ipynb
After getting the stack VGG file containing 7 columns (lon lat, east slope residual, north slope residual, vertical gravity gradient (vgg), rms of VGG, L1 norm of VGG), we use test_allcycles_grid_total.csh to make global grids.


Nadir models (east_32.1.nc, north_32.1.nc, curve_32.1.nc) are from:
https://topex.ucsd.edu/pub/global_grav_1min/

mean dynamic topography: dot.cls21.grd

make_plot.ipynb is used to make plots used in the paper.


Google earth overlay of the SWOT VGG: VGG SWOT.kmz
