function [azimuth,elevation,distance]=Sat_Azi_Elev(x1,y1,z1,phi,plam,x2,y2,z2)

rlat=phi-pi/2.0;
rlon=plam-pi;
srlat=sin(rlat);
crlat=cos(rlat);
srlon=sin(rlon);
crlon=cos(rlon);

dx=x2-x1;
dy=y2-y1;
dz=z2-z1;

du=crlat*crlon*dx+ crlat*srlon*dy -srlat*dz;
dv=srlon*dx      - crlon*dy;
dw=srlat*crlon*dx+ srlat*srlon*dy+ crlat*dz;

distance= sqrt(du^2+dv^2+dw^2);
azimuth  = atan2(dv,du)/pi*180;
elevation  = asin(dw/distance)/pi*180;