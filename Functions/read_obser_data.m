function [rcvr_tow,isvid,pr,phase] =read_obs(file)
       
rcvr_tow =zeros(8,1);
isvid=zeros(8,1);
pr =zeros(8,1);
phase  =zeros(8,1);
frac   =zeros(8,1);

sat_id=1;

fid=fopen(file,'rt');

while(~feof(fid))
    
    line=fgetl(fid);
    if (length(line)>1)
        str=sscanf(line(1:16),'%c');
        rcvr_tow(sat_id,1)=str2double(str);
        str=sscanf(line(18:19),'%c');
        isvid(sat_id,1)=str2double(str);
        str=sscanf(line(25:36),'%c');
        pr(sat_id,1)=str2double(str);
        str=sscanf(line(43:49),'%c');
        phase(sat_id,1)=str2double(str);
        str=sscanf(line(51:54),'%c');
        frac(sat_id,1)=str2double(str);
        phase(sat_id,1)=phase(sat_id,1)+(frac(sat_id,1)/2048);
        
        sat_id=sat_id+1;    
    end
end
fclose(fid);