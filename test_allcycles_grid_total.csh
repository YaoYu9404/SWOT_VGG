#! /bin/csh
#
#  script to grid the full VGG from SWOT only
#
gmt gmtset D_FORMAT = %.16lg
gmt set IO_NC4_CHUNK_SIZE auto
#
#  remove the nan from the real data
#
#rm resid_vgg.xyz
#awk '{ if($5 != nan) print $1-360,$2,$5 }' < sn_se_vgg_res.out >  resid_vgg.xyz
#awk '{ if($5 != nan) print $1-360,$2,$5 }' < sn_se_vgg_res_1day.out >>  resid_vgg.xyz
./grid_resid.csh tot_vgg.xyz tot_vgg_grid.grd
#
#  low-pass filter the tot
#
gmt grdfilter tot_vgg_grid.grd -D3 -Fg8 -Gtot_filt.grd -V
