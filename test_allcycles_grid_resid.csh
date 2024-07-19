#! /bin/csh
#
#  script to test the grid_resid script
#
gmt gmtset D_FORMAT = %.16lg
gmt set IO_NC4_CHUNK_SIZE auto
#
#   create come fake data
#
#gmt grdcut north_32.1.nc -R-150/-120/-80/80 -Gtmp.grd
#gmt grd2xyz tmp.grd > resid.xyz
#rm tmp.grd
#
#  remove the nan from the real data
#
awk '{ if($3 != nan) print $1-360,$2,$3 }' < sn_se_vgg_res.out >  resid_n.xyz
awk '{ if($3 != nan) print $1-360,$2,$3 }' < sn_se_vgg_res_1day.out >>  resid_n.xyz
./grid_resid.csh resid_n.xyz resid_n_grid.grd
wait
awk '{ if($4 != nan) print $1-360,$2,$4 }' < sn_se_vgg_res.out >  resid_e.xyz
awk '{ if($4 != nan) print $1-360,$2,$4 }' < sn_se_vgg_res_1day.out >>  resid_e.xyz
./grid_resid.csh resid_e.xyz resid_e_grid.grd
wait
awk '{ if($5 != nan) print $1-360,$2,$5 }' < sn_se_vgg_res.out >  resid_vgg.xyz
awk '{ if($5 != nan) print $1-360,$2,$5 }' < sn_se_vgg_res_1day.out >>  resid_vgg.xyz
./grid_resid.csh resid_vgg.xyz resid_vgg_grid.grd
#wait
#awk '{ if($6 != nan) print $1-360,$2,$6 }' < sn_se_vgg_res.out >  vgg_rms.xyz
#awk '{ if($6 != nan) print $1-360,$2,$6 }' < sn_se_vgg_res_1day.out >> vgg_rms.xyz
#./grid_resid.csh vgg_rms.xyz vgg_rms_grid.grd
wait
#awk '{ if($7 != nan) print $1-360,$2,$7 }' < sn_se_vgg_res.out > vgg_L1.xyz
#awk '{ if($7 != nan) print $1-360,$2,$7 }' < sn_se_vgg_res_1day.out >> vgg_L1.xyz
#./grid_resid.csh vgg_L1.xyz vgg_L1_grid.grd
#
#  low-pass filter the resid
#
gmt grdfilter resid_vgg_grid.grd -D3 -Fg8 -Gtmp_resid_filt.grd -V
#gmt grdfilter vgg_rms_grid.grd -D3 -Fg8 -Gswot_vgg_rms.grd -V
#gmt grdfilter vgg_L1_grid.grd -D3 -Fg8 -Gswot_vgg_L1.grd -V
#
#  add the reference grid
#
gmt grdmath north_32.1.nc resid_n_grid.grd ADD = north_swot.grd
gmt grdmath east_32.1.nc resid_e_grid.grd ADD = east_swot.grd
gmt grdmath curv_32.1.nc tmp_resid_filt.grd SUB = vgg_swot.grd
