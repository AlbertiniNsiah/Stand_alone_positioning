function [distance,e] = Geometric(rs, rr)
% ! Computes geometric distance and receiver to satellite unit vector
% ! args   : real*8 *rs       I   satellilte position (ecef at transmission) (m)
% !          real*8 *rr       I   receiver position (ecef at reception) (m)
% !          real*8 *e        O   line-of-sight vector (ecef)
% ! return : geometric distance (m) (0>:error/no satellite position)
% ! notes  : distance includes sagnac effect correction

c = 299792458.d0;
OMGE   = 7.2921151467d-5;
RE_WGS84 = 6378137.d0;

if(norm(rs)<RE_WGS84)
    distance=-1.d0; 
    return;
end
e=rs-rr';
r=norm(e);
e=e/r;
distance=r+OMGE*(rs(1)*rr(2)-rs(2)*rr(1))/c;
end