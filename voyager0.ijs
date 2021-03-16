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

yr   =: replacenan 0{"1 vy
doy  =: replacenan 1{"1 vy
dist =: replacenan 2{"1 vy
bmag =: replacenan 3{"1 vy
vsw  =: replacenan 4{"1 vy
den  =: replacenan 5{"1 vy
ti   =: replacenan 6{"1 vy

dy=:doy%365
ydd=:yr+dy
