function [rs, dts] = satellite_position(time,pr,toc,af0,af1,af2, toe, M0,A,deln,e,omg,OMG0,OMGd,i0,idot,cus,cuc,cis,cic,crs,crc,toes)
c = 299792458.d0;

% Transmission time by satellite clock 
time=time-(pr/c);

% Satellite clock bias using broadcast ephemeris 
dt = eph2clk(time, toc, af0, af1, af2);
time = time-dt;

% Satellite position and clock at transmission time 
[rs, dts] = eph2pos(time,toe,M0,A,deln,e,omg,OMG0,OMGd,i0,idot,cus,cuc,cis,cic,crs,crc,toes,af0,af1,af2);
end 

function eph2clk = eph2clk(time, toc, af0, af1, af2)
% implicit none
% % type(gtime_t),intent(in) :: time
% type(eph_t), intent(in) :: eph
% real*8 t
% integer*4 i
t=time-toc;
for i=1:2
    t=t-(af0+af1*t+af2*t*t);
end
eph2clk=af0+af1*t+af2*t*t;
end


function [rs, dts] = eph2pos(time,toe,M0,A,deln,e,omg,OMG0,OMGd,i0,idot,cus,cuc,cis,cic,crs,crc,toes,af0,af1,af2)

c = 299792458.d0;
MU_GPS = 3.9860050d14; % Gravitational constant
OMGE   = 7.292115d-5;  % Earth angular velocity (rad/s) 
RTOL_KEPLER = 1d-13;   % Relative tolerance for Kepler's equation 
MAX_ITER_KEPLER = 30;  % Maximum number of iterations of Kepler 

if(A<=0.d0)
    rs=0.d0; dts=0.d0;
    return;
end

tk=(time-toe);
mu=MU_GPS; omge1=OMGE;
M=M0+(sqrt(mu/(A*A*A))+deln)*tk;
n=0;E=M;Ek=0.d0;

while(abs(E-Ek)>RTOL_KEPLER && n<MAX_ITER_KEPLER)
    Ek=E; E=E-(E-e*sin(E)-M)/(1.d0-e*cos(E));
    n=n+1;
end

if(n>=MAX_ITER_KEPLER), return; end
sinE=sin(E); cosE=cos(E);

u=atan2(sqrt(1.d0-e*e)*sinE,cosE-e)+omg;
r=A*(1.d0-e*cosE);
i=i0+idot*tk;
sin2u=sin(2.d0*u); cos2u=cos(2.d0*u);
u=u+cus*sin2u+cuc*cos2u;
r=r+crs*sin2u+crc*cos2u;
i=i+cis*sin2u+cic*cos2u;
x=r*cos(u); y=r*sin(u); cosi=cos(i);


O=OMG0+(OMGd-omge1)*tk-omge1*toes;
sinO=sin(O); cosO=cos(O);
rs(1)=x*cosO-y*cosi*sinO;
rs(2)=x*sinO+y*cosi*cosO;
rs(3)=y*sin(i);

tk=(time-toe);
dts=af0+af1*tk+af2*tk*tk;

% relativity correction 
dts=dts-2.d0*sqrt(mu*A)*e*sinE/(c*c);

end 

