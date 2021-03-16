load 'tables/csv'
load 'plot numeric'
max =: >./
min =: <./
range =: min,max
NB. READ particular columns from a csv file
readcolumns=: 3 : 0
 'filename columns' =. y
 makenum columns {"1 readcsv filename
)
NB. Replace max value of line by NaN
replacenan =: 3 : 0
maxy =. max y
mask =. (y = maxy)
y - _*mask
)

NB. Data from:
NB. https://cdaweb.gsfc.nasa.gov/pub/data/voyager/voyager2/merged/voyager2_daily.asc
inputfile=: '~/WorkSpace/jprojects/Voyager/voyager2_daily.csv'

NB. Read yr(0), doy(1), dist(3), bmag(7), vsw(11), den(14) and Ti(15) columns
NB. from the Voyager datafile
vy =: readcolumns inputfile; 0 1 3 7 11 14 15
cols=:'yr';'doy';'dist';'bmag';'vsw';'den';'ti'
col =: 3 : ';vy {~"1 cols i.<y'
yr   =: replacenan col 'yr'
doy  =: replacenan col 'doy'
dist =: replacenan col 'dist'
bmag =: replacenan col 'bmag'
vsw  =: replacenan col 'vsw'
den  =: replacenan col 'den'
ti   =: replacenan col 'ti'

dy=:doy%365
ydd=:yr+dy
