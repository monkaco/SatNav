%% Example 1
% MAE 561: SatNav, Dr. Gross
%% Truth position
xyzTruth=1.0e+06 *[3.138121819771608,
                   -2.736024319874311,  
                   4.815801177833931];
clockBiasTruth=10e-3; %10 ms
%% Given Inputs
% rough guess ( for this, I simply truncated the position truth to km-level)
xyzNom=1.0e+06*[3.13  -2.73   4.81]'; % meters
clockBiasNom=0; % seconds,( truth is 10 ms)
%  constant
speedOfLight=299792458; % m/s 


% this would come from from broadcast navigation message
satXYZ=[1.579876587251324  -1.969642732410638  -0.824114218988931;
        0.896856861287937   1.232264245497990   2.175279452593552;
        1.761730776084601   1.600064661213446   1.179306733747653;
       -0.805041133149880  -2.446570409700347   0.648744381639101]*1e7;
% this would come from from GPS receiver
prObserved=1.0e+07*[2.786625871793187;
                    2.639924033357759;
                    2.768384848515108;
                    2.749608411703467];
% pre allocate sizes
prComputed=zeros(4,1);
uNom2Sat=zeros(4,3);

for i=1:4
    % calculate computed or expected psuedorange
    prComputed(i)=norm(satXYZ(i,:)-xyzNom')+clockBiasNom*speedOfLight;
    
    % calculate the unit vectors from nominal position
    % to satellite location 
    % which make up the partials 
    % of the observation model
    uNom2Sat(i,:)=(satXYZ(i,:)-xyzNom')/norm(satXYZ(i,:)-xyzNom');
end

% add the partial of the clock bias, 
% observation model

G=horzcat(-uNom2Sat,ones(4,1));

H=inv(G'*G);
PDOP=sqrt(H(1,1)+H(2,2)+H(3,3));


% form the innovation vector

deltaRho=prObserved-prComputed;
% find the delta solution

dX=inv(G)*deltaRho;
xyzEst=xyzNom+dX(1:3);
% the clock bias in has a negative sign that must be handled
clockBiasEst=clockBiasNom+dX(4)/speedOfLight;

% determine performance
initErr=norm(xyzNom-xyzTruth);
finalErr=norm(xyzEst-xyzTruth);

initClockErr=norm(clockBiasNom-clockBiasTruth);
finalClockErr=norm(clockBiasEst-clockBiasTruth);
solStr=sprintf('Initial 3D Error %.2f m, Final 3D Error %.2f m',initErr,finalErr);
disp(solStr)
% report clock estimation performance in meters
clockSolStr=sprintf('Initial Clk Error %.4f m, Final Clk Error %.4f m',...
    speedOfLight*initClockErr,speedOfLight*finalClockErr);
disp(clockSolStr)
%Initial 3D Error 54778.66 m, Final 3D Error 106.19 m
%Initial Clk Error 1498962.2900 m, Final Clk Error 138.9913 m
