Data80s = readmatrix('C:\Users\Seann\Documents\Climate Model Research\ccsm4_KSEA_1980s.dat');      %making matricies from imported data
Data90s = readmatrix('C:\Users\Seann\Documents\Climate Model Research\ccsm4_KSEA_1990s.dat');
Data00s = readmatrix('C:\Users\Seann\Documents\Climate Model Research\ccsm4_KSEA_2000s.dat');
Data30s = readmatrix('C:\Users\Seann\Documents\Climate Model Research\ccsm4_KSEA_2030s.dat');      %making matricies from imported data
Data40s = readmatrix('C:\Users\Seann\Documents\Climate Model Research\ccsm4_KSEA_2040s.dat');
Data50s = readmatrix('C:\Users\Seann\Documents\Climate Model Research\ccsm4_KSEA_2050s.dat');
Data2070s = readmatrix('C:\Users\Seann\Documents\Climate Model Research\ccsm4_KSEA_2070s.dat');      %making matricies from imported data
Data2080s = readmatrix('C:\Users\Seann\Documents\Climate Model Research\ccsm4_KSEA_2080s.dat');
Data2090s = readmatrix('C:\Users\Seann\Documents\Climate Model Research\ccsm4_KSEA_2090s.dat');

LengVec80 = Data80s(:,1);           %length vectors to find size of data matrix
LengVec90 = Data90s(:,1);
LengVec00 = Data00s(:,1);
LengVec30 = Data30s(:,1);           
LengVec40 = Data40s(:,1);
LengVec50 = Data50s(:,1);
LengVec2070 = Data2070s(:,1);           
LengVec2080 = Data2080s(:,1);
LengVec2090 = Data2090s(:,1);

L80 = length(LengVec80);            %lenght, total number of data points(hourly)
L90 = length(LengVec90);
L00 = length(LengVec00);
LT_his = L80 + L90 + L00;               %total length of the 30 year historical dataset

L30 = length(LengVec30);            %lenght, total number of data points(hourly)
L40 = length(LengVec40);
L50 = length(LengVec50);
LT_mid = L30 + L40 + L50;               %total length of the 30 year dataset

L2070 = length(LengVec2070);            %lenght, total number of data points(hourly)
L2080 = length(LengVec2080);
L2090 = length(LengVec2090);
LT_end = L2070 + L2080 + L2090;             %total length of the 30 year dataset

DataHis = zeros(LT_his,8);              %initialize historic data matrix %change eight to variable dependant of size of matrix ie number of variables
DataMid = zeros(LT_mid,8);              %initialize mid data matrix %change eight to variable dependant of size of matrix ie number of variables
DataEnd = zeros(LT_end,8);              %initialize end data matrix %change eight to variable dependant of size of matrix ie number of variables

%%%his matrix%%%
for n = 1:L80
    DataHis(n,:) =  Data80s(n,:);   %loop to fill historic matrix with first 10 years
end
for n = 1:L90
    k = n + L80;
    DataHis(k,:) = Data90s(n,:);    %loop to fill historic matrix with second 10 years
end
for n = 1:L00
    k = n + L80 + L90;
    DataHis(k,:) = Data00s(n,:);    %loop to fill historic matrix with third 10 years
end
%%%mid matrix%%%
for n = 1:L30
    DataMid(n,:) =  Data30s(n,:);   %loop to fill matrix with first 10 years
end
for n = 1:L40
    k = n + L30;
    DataMid(k,:) = Data40s(n,:);    %loop to fill matrix with second 10 years
end
for n = 1:L50
    k = n + L30 + L40;
    DataMid(k,:) = Data50s(n,:);    %loop to fill matrix with third 10 years
end
%%%end matrix%%%
for n = 1:L2070
    DataEnd(n,:) =  Data2070s(n,:);     %loop to fill matrix with first 10 years
end
for n = 1:L2080
    k = n + L2070;
    DataEnd(k,:) = Data2080s(n,:);      %loop to fill matrix with second 10 years
end
for n = 1:L2090
    k = n + L2070 + L2080;
    DataEnd(k,:) = Data2090s(n,:);      %loop to fill matrix with third 10 years
end


%%%%above code forms data matrices%%%%
%%%%below code get historic daily temperatures and wind%%%%


yr_his=DataHis(:,1);                            %positive is on shore, negative offshore
mo_his=DataHis(:,2);
dy_his=DataHis(:,3);
hr_his=DataHis(:,4);
T2_his=DataHis(:,5) - 273.15;                   % deg C Air Temperature 2m abourve surface
pcp_his=DataHis(:,6);                           % mm/hr precip accumulated in previous hour
u10_his=DataHis(:,7);                           % m/s  eastward componnent of horizontal wind 10m
                                            % above surface
v10_his=DataHis(:,8);                           % m/s northward componnent of horizontal wind 10m
                                            % above surface
if mo_his(1) == 7 || mo_his(1) == 8
    T_his = T2_his(1);
    W_his = u10his(1);
else
    T_his = -999;
    W_his = 0;
end
DayMaxT_his = 0;                                %initialize daily temp vector
DayAveW_his = 0;                                %initialize daily wind vecotr
K_his = 1;                                      %day counter
Zh_his = 0;                                     %hour counter for daily wind average
                                           
for in = 2:length(yr_his)                       %loop through full data set
        if mo_his(in) == 7 && mo_his(in-1) == 6     %specific boundary condition for first data on july 1st
            T_his = T2_his(in);
            Zh_his = Zh_his + 1;
            W_his = u10_his(in);
        elseif mo_his(in) == 7 || mo_his(in) == 8   %only check july and august temps
           if dy_his(in) == dy_his(in-1)            %hourly check to provide max temperature for each day
                 if T2_his(in) > T_his               
                     T_his = T2_his(in);
                 end
                 Zh_his = Zh_his + 1;
                 W_his = W_his + u10_his(in);           %sum up hourly wind values
           else                             %begininng of new day
                DayMaxT_his(K_his) = T_his;             %fill daymaxT vector with prior days temp
                T_his = T2_his(in);                 %reset temp track for new day 
                DayAveW_his(K_his) = W_his/Zh_his;          %fill dayaveW vector with prior days average  wind
                W_his = u10_his(in);                %reset wind value for new day
                K_his = K_his + 1;                  %add to day counter
                Zh_his = 0;
           end
        elseif mo_his(in) == 9 && mo_his(in-1) == 8 %specific boundary condition to fill august 31
            DayMaxT_his(K_his) = T_his;
            DayAveW_his(K_his) = W_his/Zh_his;
                K_his = K_his + 1;
                T_his = -999;
                W_his = 0;
                Zh_his = 0;
        end
end

LengTemps_his = length(DayMaxT_his);                %length of day temp vector (number of days)
LengWind_his = length(DayAveW_his);                 %length of ave wind vector (number of days)

DailyMatrix_his = zeros(LengTemps_his,2);           %Initialize and create matrix with daily data
DailyMatrix_his(1:LengTemps_his,1) = DayMaxT_his;       %Column 1 is the max temperature for each day
DailyMatrix_his(1:LengWind_his,2) = DayAveW_his;        %Column 2 is the ave E/W wind value for each day

SorMat_his = sortrows(DailyMatrix_his,1);           %Sorted by temperature, matrix of daily temp and corresponding wind


%%%%above forms sorted historic temp/wind matrix%%%
    %%%%%below forms sorted mid temp/wind matrix%%%

    
yr_mid=DataMid(:,1);                            %positive is on shore, negative offshore
mo_mid=DataMid(:,2);
dy_mid=DataMid(:,3);
hr_mid=DataMid(:,4);
T2_mid=DataMid(:,5) - 273.15;                   % deg C Air Temperature 2m abourve surface
pcp_mid=DataMid(:,6);                           % mm/hr precip accumulated in previous hour
u10_mid=DataMid(:,7);                           % m/s  eastward componnent of horizontal wind 10m
                                            % above surface
v10_mid=DataMid(:,8);                           % m/s northward componnent of horizontal wind 10m
                                            % above surface
if mo_mid(1) == 7 || mo_mid(1) == 8
    T_mid = T2_mid(1);
    W_mid = u10_mid(1);
else
    T_mid = -999;
    W_mid = 0;
end
DayMaxT_mid = 0;                                %initialize daily temp vector
DayAveW_mid = 0;                                %initialize daily wind vecotr
K_mid = 1;                                      %day counter
Zh_mid = 0;                                     %hour counter for daily wind average
                                           
for in = 2:length(yr_mid)                       %loop through full data set
        if mo_mid(in) == 7 && mo_mid(in-1) == 6     %specific boundary condition for first data on july 1st
            T_mid = T2_mid(in);
            Zh_mid = Zh_mid + 1;
            W_mid = u10_mid(in);
        elseif mo_mid(in) == 7 || mo_mid(in) == 8   %only check july and august temps
           if dy_mid(in) == dy_mid(in-1)            %hourly check to provide max temperature for each day
                 if T2_mid(in) > T_mid               
                     T_mid = T2_mid(in);
                 end
                 Zh_mid = Zh_mid + 1;
                 W_mid = W_mid + u10_mid(in);           %sum up hourly wind values
           else                             %begininng of new day
                DayMaxT_mid(K_mid) = T_mid;             %fill daymaxT vector with prior days temp
                T_mid = T2_mid(in);                 %reset temp track for new day 
                DayAveW_mid(K_mid) = W_mid/Zh_mid;          %fill dayaveW vector with prior days average  wind
                W_mid = u10_mid(in);                %reset wind value for new day
                K_mid = K_mid + 1;                  %add to day counter
                Zh_mid = 0;
           end
        elseif mo_mid(in) == 9 && mo_mid(in-1) == 8 %specific boundary condition to fill august 31
            DayMaxT_mid(K_mid) = T_mid;
            DayAveW_mid(K_mid) = W_mid/Zh_mid;
                K_mid = K_mid + 1;
                T_mid = -999;
                W_mid = 0;
                Zh_mid = 0;
        end
end

LengTemps_mid = length(DayMaxT_mid);                %length of day temp vector (number of days)
LengWind_mid = length(DayAveW_mid);                 %length of ave wind vector (number of days)

DailyMatrix_mid = zeros(LengTemps_mid,2);           %Initialize and create matrix with daily data
DailyMatrix_mid(1:LengTemps_mid,1) = DayMaxT_mid;       %Column 1 is the max temperature for each day
DailyMatrix_mid(1:LengWind_mid,2) = DayAveW_mid;        %Column 2 is the ave E/W wind value for each day

SorMat_mid = sortrows(DailyMatrix_mid,1);           %Sorted by temperature, matrix of daily temp and corresponding wind


%%%%above forms sorted mid temp/wind matrix%%%
%%%%%below forms sorted end temp/wind matrix%%%

yr_end=DataEnd(:,1);                            %positive is on shore, negative offshore
mo_end=DataEnd(:,2);
dy_end=DataEnd(:,3);
hr_end=DataEnd(:,4);
T2_end=DataEnd(:,5) - 273.15;                   % deg C Air Temperature 2m abourve surface
pcp_end=DataEnd(:,6);                           % mm/hr precip accumulated in previous hour
u10_end=DataEnd(:,7);                           % m/s  eastward componnent of horizontal wind 10m
                                            % above surface
v10_end=DataEnd(:,8);                           % m/s northward componnent of horizontal wind 10m
                                            % above surface
if mo_end(1) == 7 || mo_end(1) == 8
    T_end = T2_end(1);
    W_end = u10_end(1);
else
    T_end = -999;
    W_end = 0;
end
DayMaxT_end = 0;                                %initialize daily temp vector
DayAveW_end = 0;                                %initialize daily wind vecotr
K_end = 1;                                      %day counter
Zh_end = 0;                                     %hour counter for daily wind average
                                           
for in = 2:length(yr_end)                       %loop through full data set
        if mo_end(in) == 7 && mo_end(in-1) == 6     %specific boundary condition for first data on july 1st
            T_end = T2_end(in);
            Zh_end = Zh_end + 1;
            W_end = u10_end(in);
        elseif mo_end(in) == 7 || mo_end(in) == 8   %only check july and august temps
           if dy_end(in) == dy_end(in-1)            %hourly check to provide max temperature for each day
                 if T2_end(in) > T_end               
                     T_end = T2_end(in);
                 end
                 Zh_end = Zh_end + 1;
                 W_end = W_end + u10_end(in);           %sum up hourly wind values
           else                             %begininng of new day
                DayMaxT_end(K_end) = T_end;             %fill daymaxT vector with prior days temp
                T_end = T2_end(in);                 %reset temp track for new day 
                DayAveW_end(K_end) = W_end/Zh_end;          %fill dayaveW vector with prior days average  wind
                W_end = u10_end(in);                %reset wind value for new day
                K_end = K_end + 1;                  %add to day counter
                Zh_end = 0;
           end
        elseif mo_end(in) == 9 && mo_end(in-1) == 8 %specific boundary condition to fill august 31
            DayMaxT_end(K_end) = T_end;
            DayAveW_end(K_end) = W_end/Zh_end;
                K_end = K_end + 1;
                T_end = -999;
                W_end = 0;
                Zh_end = 0;
        end
end

LengTemps_end = length(DayMaxT_end);                %length of day temp vector (number of days)
LengWind_end = length(DayAveW_end);                 %length of ave wind vector (number of days)

DailyMatrix_end = zeros(LengTemps_end,2);           %Initialize and create matrix with daily data
DailyMatrix_end(1:LengTemps_end,1) = DayMaxT_end;       %Column 1 is the max temperature for each day
DailyMatrix_end(1:LengWind_end,2) = DayAveW_end;        %Column 2 is the ave E/W wind value for each day

SorMat_end = sortrows(DailyMatrix_end,1);           %Sorted by temperature, matrix of daily temp and corresponding wind

%%%%above forms sorted end temp/wind matrix%%%
%%%%%below analyzes temps/winds%%%

ExHeatBase = SorMat_his(round(.95*LengTemps_his),1);    %Historic baseline temp for extreme heat
disp(ExHeatBase)


B_mid = SorMat_mid(:,1) > ExHeatBase;               %gets heat over the historic 95% baseline and corresponding wind
BB_mid(:,1) = B_mid;                                
BB_mid(:,2) = B_mid;                               
C_mid = SorMat_mid(BB_mid);                             
ExHeatDays_mid(:,1) = C_mid(1:length(C_mid)/2);         %Fills extreme heat matrix
ExHeatDays_mid(:,2) = C_mid((length(C_mid)/2)+1:end);   %first column is temp, second is wind


B_end = SorMat_end(:,1) > ExHeatBase;               %gets heat over the historic 95% baseline and corresponding wind
BB_end(:,1) = B_end;                                
BB_end(:,2) = B_end;                                
C_end = SorMat_end(BB_end);                             
ExHeatDays_end(:,1) = C_end(1:(length(C_end)/2));           
ExHeatDays_end(:,2) = C_end((length(C_end)/2)+1:end);




%histogram(DayMaxT_his)
%plot(SorMat_his(:,1),SorMat_his(:,2))

%histogram(DayMaxT_mid)
%plot(SorMat_mid(:,1),SorMat_mid(:,2))

%histogram(DayMaxT_end)
%plot(SorMat_end(:,1),SorMat_end(:,2))




