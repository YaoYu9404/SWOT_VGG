#! /bin/csh
#
#  script to grid sea surface slopes (east or north) on a 1m grid to match the 
#  global gravity series in cartesian net-cdf foemat.  For example:
#  https://topex.ucsd.edu/pub/global_grav_1min/north_32.1.nc
#
  gmt gmtset D_FORMAT = %.16lg
  gmt set IO_NC4_CHUNK_SIZE auto
#
  if ($#argv < 2) then
        echo " "
        echo "  example: `basename $0` resid.xyz resid_grid.grd"
        echo " "
        exit
  endif
#
  set region = "-180/180/-81/81"
#
#  remove data over land using a high resolution landmask
#
  if(! -f landmask.grd) gmt grdlandmask -Df -R$region -r -I0.5m -Glandmask.grd -N1/NaN/1/NaN/NaN
  gmt grdtrack $1 -Glandmask.grd -s3+a -nn | awk '{print $1,$2,$3}' > tmp.xyz
#
#  prepare the residual data by filling gaps with zero
#
  gmt xyz2grd tmp.xyz -R$region -r -I4m -An -fg -Gnum.grd -di0 -V
  gmt grdfilter num.grd -D3 -Fg20 -Ghit.grd 
  gmt grdmath hit.grd 1 GE 1 NAN = zero.grd
  gmt grd2xyz zero.grd -s > zero.xyz
  echo "generated zero data to fill holes"
#
#  combine the zeros and the residual slopes and blockmedian at 1 minute
#
  cat tmp.xyz zero.xyz > all.xyz
  gmt blockmedian all.xyz -R$region -I1m -V -C -r -bod3 > all_b.xyz
#
#  now grid the residual and zero data
#
  csh surface_tile.csh all_b.xyz $2
#
# clean up
#
  rm num.grd hit.grd zero.grd zero.xyz all.xyz tmp.xyz
  rm all_b.xyz

