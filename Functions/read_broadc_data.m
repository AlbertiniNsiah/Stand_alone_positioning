function [rcvr_tow,isvid,toe,af0,af1,af2,e,sqrta,dn,m0,w,omg0,i0,odot,idot,cus,cuc,cis,cic,crs,crc] =read_broadcast_info(file)
       
rcvr_tow =zeros(8,1);
isvid =zeros(8,1);
toe =zeros(8,1);
af0 =zeros(8,1);
af1 =zeros(8,1);
af2 =zeros(8,1);
e =zeros(8,1);
sqrta =zeros(8,1);
dn =zeros(8,1);
m0 =zeros(8,1);
w =zeros(8,1);
omg0 =zeros(8,1);
i0 =zeros(8,1);
odot =zeros(8,1);
idot =zeros(8,1);
cus =zeros(8,1);
cuc =zeros(8,1);
cis =zeros(8,1);
cic =zeros(8,1);
crs =zeros(8,1);
crc =zeros(8,1);

sat_id=1;

fid=fopen(file,'rt');

while(~feof(fid))
    
    line=fgetl(fid);
    if (length(line)>1)
        str=sscanf(line(1:16),'%c');
        rcvr_tow(sat_id,1)=str2double(str);
        str=sscanf(line(18:19),'%c');
        isvid(sat_id,1)=str2double(str);
        str=sscanf(line(41:53),'%c');
        toe(sat_id,1)=str2double(str);
        str=sscanf(line(57:70),'%c');
        af0(sat_id,1)=str2double(str);
        str=sscanf(line(74:87),'%c');
        af1(sat_id,1)=str2double(str);
        str=sscanf(line(92:104),'%c');
        af2(sat_id,1)=str2double(str);
        str=sscanf(line(134:146),'%c');
        e(sat_id,1)=str2double(str);
        str=sscanf(line(159:171),'%c');
        sqrta(sat_id,1)=str2double(str);
        str=sscanf(line(184:196),'%c');
        dn(sat_id,1)=str2double(str);
        str=sscanf(line(208:221),'%c');
        m0(sat_id,1)=str2double(str);
        str=sscanf(line(233:246),'%c');
        i0(sat_id,1)=str2double(str);
        str=sscanf(line(258:271),'%c');
        odot(sat_id,1)=str2double(str);
        str=sscanf(line(284:296),'%c');
        omg0(sat_id,1)=str2double(str);
        str=sscanf(line(300:313),'%c');
        idot(sat_id,1)=str2double(str);
        str=sscanf(line(317:330),'%c');
        w(sat_id,1)=str2double(str);
        str=sscanf(line(335:347),'%c');
        cus(sat_id,1)=str2double(str);
        str=sscanf(line(351:364),'%c');
        cuc(sat_id,1)=str2double(str);
        str=sscanf(line(368:381),'%c');
        cis(sat_id,1)=str2double(str);
        str=sscanf(line(385:398),'%c');
        cic(sat_id,1)=str2double(str);
        str=sscanf(line(402:415),'%c');
        crs(sat_id,1)=str2double(str);
        str=sscanf(line(420:432),'%c');
        crc(sat_id,1)=str2double(str);
        
        sat_id=sat_id+1;    
    end
end
fclose(fid);