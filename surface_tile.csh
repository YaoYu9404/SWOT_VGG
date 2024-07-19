#! /bin/csh
#
# routine to take the giant surface run for gravity and break it up into 6 tiles
# according to latitude.  This reduces the memory requirement but also allows
# an anisotropy factor at higher latitudes
#
gmt gmtset D_FORMAT = %.16lg
gmt gmtset VERBOSE = TRUE
gmt set IO_NC4_CHUNK_SIZE auto
#
if ($#argv < 2) then
	echo " "
	echo "  example: `basename $0` median.xyz full_grid.grd"
	echo " "
	exit
endif

set bxyz	= $1;   shift
set out		= $1;   shift
set opts	= "-T0.35 -fg"

#/bin/rm -rf *out.grd
#
set B1 = -180./180./58./80.;
set B2 = -180./180./28./62.;
set B3 = -180./180./-2./32.;
set B4 = -180./180./-32./02.;
set B5 = -180./180./-62./-28.;
set B6 = -180./180./-80./-58.;
#
set C1 = -180./180./60./80.;
set C2 = -180./180./30./60.;
set C3 = -180./180./00./30.;
set C4 = -180./180./-30./00.;
set C5 = -180./180./-60./-30.;
set C6 = -180./180./-80./-60.;
#
# make the blend file
#
echo B1.grd -R$C1 1 > blend.txt
echo B2.grd -R$C2 1 >> blend.txt
echo B3.grd -R$C3 1 >> blend.txt
echo B4.grd -R$C4 1 >> blend.txt
echo B5.grd -R$C5 1 >> blend.txt
echo B6.grd -R$C6 1 >> blend.txt
#
#  do all the subgrids
#
# 1
#
echo $bxyz -V -r -bi3d -I1m -A0.6 -R$B1 $opts -GB1$out
gmt blockmedian $bxyz -r -I1m -bi3d -bo3d -R$B1 -V > B1.xyz
gmt surface B1.xyz -V -r -bi3d -I1m -A.60  -R$B1 $opts -GB1.grd &
#
# 2
#
echo $bxyz -V -r -bi3d -I1m -A.707 -R$B2 $opts -GB2$out
gmt blockmedian $bxyz -r -I1m -bi3d -bo3d -R$B2 -V > B2.xyz
gmt surface B2.xyz -V -r -bi3d -I1m -A.707  -R$B2 $opts -GB2.grd &
#
# 3
#
echo $bxyz -V -r -bi3d -I1m -A.966 -R$B3 $opts -GB3.grd
gmt blockmedian $bxyz -r -I1m -bi3d -bo3d -R$B3 -V > B3.xyz
gmt surface B3.xyz -V -r -bi3d -I1m -A.966  -R$B3 $opts -GB3.grd &
#
# 4
#
echo $bxyz -V -r -bi3d -I1m -A.966 -R$B4 $opts -GB4.grd
gmt blockmedian $bxyz -r -I1m -bi3d -bo3d -R$B4 -V > B4.xyz
gmt surface B4.xyz -V -r -bi3d -I1m -A.966  -R$B4 $opts -GB4.grd &
#
# 5
#
echo $bxyz -V -r -bi3d -I1m -A.707 -R$B5 $opts -GB5.grd
gmt blockmedian $bxyz -r -I1m -bi3d -bo3d -R$B5 -V > B5.xyz
gmt surface B5.xyz -V -r -bi3d -I1m -A.707  -R$B5 $opts -GB5.grd &
#
# 6
#
echo $bxyz -V -r -bi3d -I1m -A.60 -R$B6 $opts -GB6.grd
gmt blockmedian $bxyz -r -I1m -bi3d -bo3d -R$B6 -V > B6.xyz
gmt surface B6.xyz -V -r -bi3d -I1m -A.60  -R$B6 $opts -GB6.grd &
wait;
#
#  now blend all the files together
#
gmt grdblend blend.txt -G$out -R-180/180/-80/80 -r -I1m -V
#
#   now clean up the mess
#
rm B1.xyz B2.xyz B3.xyz B4.xyz B5.xyz B6.xyz
rm B*.grd
rm blend.txt
