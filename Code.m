clear;
% Satellite coordinates
xyzsat=zeros(8,6); 

% Broadcast satellite clock error
dtxyzsat=zeros(8,1);

% Data files in matrix
file_nav='eph.dat';
file_obs='rcvr.dat';

% Speed of Light
c = 299792458.d0;

% Number of unknowns
m = 4; 

% Read satellite navigation data
[rcvr_tow,isvid_orb,toe,af0,af1,af2,e,sqrta,dn,m0,w,omg0,i0,odot,idot,cus,cuc,cis,cic,crs,crc] =read_broadc_data(file_nav);

% Read observation data
[rcvr_tow,isvid_obs,pr,phase] =read_obser_data(file_obs);

% Number of pseudorange observations
n = length(pr);   

% Compute satellite positions and clocks 
for i=1:length(isvid_obs)
    isvid = isvid_obs(i);
    index = find(isvid_orb==isvid);
    [xyzsat(i,1:3), dtxyzsat(i,1)] = satellite_position((rcvr_tow(index,1)),pr(index,1),toe(index,1),af0(index,1),af1(index,1),af2(index,1), toe(index,1), m0(index,1),sqrta(index,1)^2,dn(index,1),e(index,1),i0(index,1), odot(index,1), idot(index,1),omg0(index,1), w(index,1),cus(index,1),cuc(index,1),cis(index,1),cic(index,1),crs(index,1),crc(index,1),toe(index,1));

end

% Initial receiver coordinates
receiver_position   = [-2694685.473; -4293642.366; 3857878.924];
clock_bias = 0;

%Conversion to geodetic coordinates
[wlat, wlon, walt] = Wgsxyz2lla(receiver_position);

% Code pseudorange observation loop

while (1)
    icount=1;
    for sat_id=1:n

%Computation of azimuth, distance and elevation to satellites
   [azimuth(sat_id,1),elevation(sat_id,1),distance(sat_id,1)]=Sat_Azi_Elev(receiver_position(1),receiver_position(2),receiver_position(3),wlat*pi/180,wlon*pi/180,xyzsat(sat_id,1),xyzsat(sat_id,2),xyzsat(sat_id,3));
   [distance2,e] = Geometric([xyzsat(sat_id,1),xyzsat(sat_id,2),xyzsat(sat_id,3)], receiver_position);

%Coefficient Matrix for X,Y,Z coordinates and clock offset of receiver
   A(icount,1) = (receiver_position(1) - xyzsat(sat_id,1))/distance(sat_id,1);
   A(icount,2) = (receiver_position(2) - xyzsat(sat_id,2))/distance(sat_id,1); 
   A(icount,3) = (receiver_position(3) - xyzsat(sat_id,3))/distance(sat_id,1); 
   A(icount,4) =  1;                                

% Range computation 
        Computed(icount,1) = distance(sat_id,1) + clock_bias - c*dtxyzsat(sat_id,1);
        
        Observed(icount,1) = pr(sat_id,1) ;

%Observation covariance matrix
        B(icount,icount) = 1 ;
        
        icount=icount+1;
  
     
    end
    
% Misclosure (Error in range)
    error = Observed-Computed;
    
% Least squares adjustment 
% W is representing weight.
    W=diag((diag(B).^-1));
    
% Normal matrix
    N = (A'*(W)*A);
    
    if (n >= m) 
        % Least squares solution
        x   = (N^-1)*A'*(W)*(Observed-Computed);
        
        % Estimation of the variance of the observation error
        Residuals = (A*x + Computed)-Observed;
    end
    
    receiver_position   = receiver_position   + x(1:3);
    clock_bias = clock_bias + x(4);
    
    dx = norm(x(1:3));
    
    if (dx<1e-4), break; end
end

