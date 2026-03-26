clear;
clc;
ww=3;
fw=2;
buy=0;
watersun=3;
foodsun=4;
restsunw=watersun*ww+foodsun*fw;
if buy==0
    restsunm=watersun*5+foodsun*10;
else
    restsunm=2*(watersun*5+foodsun*10);
end
waterhight=9;
foodhight=9;
resthightw=waterhight*ww+foodhight*fw;
if buy==0
    resthightm=waterhight*5+foodhight*10;
else
    resthightm=2*(waterhight*5+foodhight*10);
end
watersand=10;
foodsand=10;
restsandw=watersand*ww+foodsand*fw;
if buy==0
    restsandm=watersand*5+foodsand*10;
else
    restsandm=2*(watersand*5+foodsand*10);
end
usew=[restsunw,resthightw,restsandw];
usem=[restsunm,resthightm,restsandm];
W=[0,1,2];
yorn3=0;
w3=0;
W3=[];
S3=zeros(1,3);
while yorn3~=1
    for i=1:30
        r(i)=rand;
        if r(i)<0.1
            W3=[W3,0];
            S3(1)=S3(1)+1;
        elseif r(i)>=0.1&&r(i)<0.4375
            W3=[W3,1];
            S3(2)=S3(2)+1;
        else
            W3=[W3,2];
            S3(3)=S3(3)+1;
        end
    end
    if S3(1)/30>0.2||S3(2)/30<0.2375||S3(2)/30>0.4375||S3(3)/30<0.4625||S3(3)/30>0.6625
        w3=w3+1;
        W3=[];
        S3=zeros(1,3);
        yorn3=0;
    else
        yorn3=1;
    end
end
P=[0,0];
V1=[5,0];
MM=[7,0];
F=[6,sqrt(8)];
TotM=10000;
Totw=1200;
PD=P;
water=0;
food=0;
DV1=0;
arrvt=0;
arrMMt=0;
usewaterlog=[];
usefoodlog=[];
while PD(1)~=MM(1)
    for d=1:30
        if W3(d)~=0
            v=1;
            if W3(d)~=2
                wateruse=3;
                fooduse=4;
            else
                wateruse=9;
                fooduse=9;
            end
        else
            v=0;
            wateruse=10;
            fooduse=10;
        end
        
        if v==1
            if PD(1)~=V1(1)&&arrvt==0
                PD(1)=PD(1)+1;
            elseif PD(1)==V1(1)&&arrvt==1
                PD(1)=PD(1)+1;
            elseif PD(1)~=MM(1)&&arrMMt==0
                PD(1)=PD(1)+1;
            elseif PD(2)==MM(2)&&arrMMt==1
                break;
            end
            water=water-2*wateruse;
            food=food-2*fooduse;
        else
            water=water-wateruse;
            food=food-fooduse;
        end
        
        totc1=((-3)*water+(-2)*food);
        if PD(1)==V1(1)&&Totw>((-3)*water+(-2)*food)&&arrvt==0
            DV1=d;
            arrvt=arrvt+1;
            usewaterlog=[usewaterlog,-water];
            usefoodlog=[usefoodlog,-food];
            continue;
        elseif PD(1)==MM(1)&&Totw>((-3)*water+(-2)*food)&&arrMMt==0
            DMM1=d;
            arrMMt=arrMMt+1;
            usewaterlog=[usewaterlog,-water];
            usefoodlog=[usefoodlog,-food];
            break;
        end
    end
end
aV1w1=usewaterlog(1)*3+usefoodlog(1)*2;
leftV1w1=Totw-aV1w1;
aMMw1=usewaterlog(2)*3+usefoodlog(2)*2;
V12MMw=aMMw1-aV1w1;
leftMMw1=Totw-V12MMw;
wusew1=0;
lusew1=0;
max_possible_days=20;
wusew1log=zeros(1,max_possible_days);
lusew1log=zeros(1,max_possible_days);
evacuation_days=zeros(1,max_possible_days);
workday1=0;
found=false;
for wday1=1:max_possible_days
    current_day=DMM1+wday1;
    if current_day > 30, break; end
    
    if W3(current_day)==0
        daily_use=150;
    elseif W3(current_day)==1
        daily_use=51;
    else
        daily_use=135;
    end
    
    if wday1==1
        wusew1log(wday1)=daily_use;
    else
        wusew1log(wday1)=wusew1log(wday1-1)+daily_use;
    end
    
    rl=0;
    total_evacuation_use=0;
    evacuation_day_count=0;
    for j=(current_day+1):length(W3)
        evacuation_day_count=evacuation_day_count+1;
        if W3(j)==0
            day_use=50;
        elseif W3(j)==1
            day_use=34;rl=rl+1;
        else
            day_use=90;rl=rl+1;
        end
        total_evacuation_use=total_evacuation_use+day_use;
        if rl>=2
            break;
        end
    end
    lusew1log(wday1)=total_evacuation_use;
    evacuation_days(wday1)=evacuation_day_count;
    total_use=wusew1log(wday1)+lusew1log(wday1);
    if total_use>leftMMw1
        workday1=wday1-1;
        found=true;
        break;
    end
    if wday1==max_possible_days&&total_use<=leftMMw1
        workday1=wday1;
        found=true;
    end
end
if ~found
    workday1=0;
end
DV2=DMM1+workday1+evacuation_days(workday1);
max_possible_days2=min(20,30-DV2-5);
wusew2log=[];
lusew2log=[];
evacuation_days2=[];
workday2=0;
found2=false;
move_to_mine=0;
move_days=0;
actual_move_days=0;
for j=DV2+1:30
    if W3(j)==0
        move_to_mine=move_to_mine+50;
        actual_move_days=actual_move_days+1;
    elseif W3(j)==1
        move_to_mine=move_to_mine+34;
        move_days=move_days+1;
        actual_move_days=actual_move_days+1;
    else
        move_to_mine=move_to_mine+90;
        move_days=move_days+1;
        actual_move_days=actual_move_days+1;
    end
    if move_days>=2
        break;
    end
end
remaining_days=30-(DV2+actual_move_days);
start_mining_day=DV2+actual_move_days+1;
rl2=0;
for wday2=min(max_possible_days2,remaining_days):-1:1
    current_day=start_mining_day+wday2-1;
    if current_day > 30, break; end
    if W3(current_day)==0
        daily_use2=150;
    elseif W3(current_day)==1
        daily_use2=51;
    else
        daily_use2=135;
    end
    if isempty(wusew2log)
        cumulative_mining=daily_use2;
    else
        cumulative_mining=sum(wusew2log)+daily_use2;
    end
    rl2=0;total_evacuation_use2=0;evacuation_day_count2=0;
    for j=current_day+1:30
        if W3(j)==0
            day_use2=50;
        elseif W3(j)==1
            day_use2=34;rl2=rl2+1;
        else
            day_use2=90;rl2=rl2+1;
        end
        total_evacuation_use2=total_evacuation_use2+day_use2;
        evacuation_day_count2=evacuation_day_count2+1;
        if rl2>=3
            break;
        end
    end
    total_use2=move_to_mine+cumulative_mining+total_evacuation_use2;
    if rl2>=3&&total_use2<=Totw
        workday2=wday2;
        found2=true;
        wusew2log=[wusew2log,daily_use2];
        lusew2log=[lusew2log,total_evacuation_use2];
        evacuation_days2=[evacuation_days2,evacuation_day_count2];
        break;
    end
end
if ~found2
    workday2=0;
else
    wusew2log_full=zeros(1,workday2);
    for i=1:workday2
        current_day=start_mining_day+i-1;
        if W3(current_day)==0
            wusew2log_full(i)=150;
        elseif W3(current_day)==1
            wusew2log_full(i)=51;
        else
            wusew2log_full(i)=135;
        end
    end
end
% 策略1资金计算
price_water_start=5;
price_food_start=10;
price_water_village=10;
price_food_village=20;
use_water1=usewaterlog(1);
use_food1=usefoodlog(1);
V2MM2w=usewaterlog(2)-usewaterlog(1);
V2MM2f=usefoodlog(2)-usefoodlog(1);
u2w=0;
u2f=0;
for u2=1:workday1
    if W3(u2+DMM1)==0
        u2w=u2w+10*3;
        u2f=u2f+10*3;
    elseif W3(u2+DMM1)==1
        u2w=u2w+3*3;
        u2f=u2f+4*3;
    else
        u2w=u2w+9*3;
        u2f=u2f+9*3;
    end
end
end_mine1_day=DMM1+workday1;
for l2=1:evacuation_days(workday1)
    if end_mine1_day+l2 > 30, break; end
    if W3(end_mine1_day+l2)==0
        u2w=u2w+10;
        u2f=u2f+10;
    elseif W3(end_mine1_day+l2)==1
        u2w=u2w+3*2;
        u2f=u2f+4*2;
    else
        u2w=u2w+9*2;
        u2f=u2f+9*2;
    end
end
use_water2=V2MM2w+u2w;
use_food2=V2MM2f+u2f;
u3w=0;
u3f=0;
end_mine1_day=DMM1+workday1;
arrive_village2_day=DV2;
arrive_mine2_day=DV2+actual_move_days;
end_mine2_day=arrive_mine2_day+workday2;
arrive_end_day=end_mine2_day+evacuation_days2;
total_days_used=arrive_end_day;
period_start_to_village=1:DV1;
period_village_to_mine1=DV1+1:DMM1;
period_mine1_work=DMM1+1:DMM1+workday1;
period_mine1_to_village2=(DMM1+workday1+1):DV2;
period_village2_to_mine2=DV2+1:(DV2+actual_move_days);
period_mine2_work=(DV2+actual_move_days+1):(DV2+actual_move_days+workday2);
period_mine2_to_end=(DV2+actual_move_days+workday2+1):30;
act1=zeros(1,30);
non_mine_periods=[period_start_to_village,period_village_to_mine1,period_mine1_to_village2,period_village2_to_mine2,period_mine2_to_end];
for d=non_mine_periods
    if d<1||d>30,continue;end
    if W3(d)==0
        act1(d)=0;
    else
        act1(d)=1;
    end
end
mine_periods=[period_mine1_work,period_mine2_work];
for d=mine_periods
    if d<1||d>30,continue;end
    act1(d)=2;
end
for d2=1:(arrive_end_day-arrive_village2_day)
    current_day = arrive_village2_day + d2;
    if current_day > 30, break; end 
    if act1(current_day)==0
        if W3(current_day)==0
            u3w=u3w+10;
            u3f=u3f+10;
        elseif W3(current_day)==1
            u3w=u3w+3;
            u3f=u3f+4;
        else
            u3w=u3w+9;
            u3f=u3f+9;
        end
    elseif act1(current_day)==1
        if W3(current_day)==2
            u3w=u3w+9;
            u3f=u3f+9;
        elseif W3(current_day)==1
            u3w=u3w+3;
            u3f=u3f+4;
        end
    else
        if W3(current_day)==0
            u3w=u3w+3*10;
            u3f=u3f+3*10;
        elseif W3(current_day)==1
            u3w=u3w+3*3;
            u3f=u3f+3*4;
        else
            u3w=u3w+3*9;
            u3f=u3f+3*9;
        end
    end
end
use_water3=u3w;
use_food3=u3f;
uw12=use_water1+use_water2;
uf12=use_food1+use_food2;
u1w=usefoodlog(1)*2+usewaterlog(1)*3;
water2andfood2_from_startw=Totw-u1w;
food2_from_start=min(floor((water2andfood2_from_startw)/2),use_food2);
if(Totw-(u1w+food2_from_start*2))>3
    water2_from_start=floor((Totw-(u1w+food2_from_start*2))/3);
else
    water2_from_start=0;
end
buy_water_start=use_water1+water2_from_start;
buy_food_start=use_food1+food2_from_start;
buy_water_village1=use_water2-water2_from_start;
buy_food_village1=use_food2-food2_from_start;
buy_water_village2=use_water3;
buy_food_village2=use_food3;
cost_start=buy_water_start*5+buy_food_start*10;
cost_village1=buy_water_village1*price_water_village+buy_food_village1*price_food_village;
cost_village2=buy_water_village2*price_water_village+buy_food_village2*price_food_village;
total_cost=cost_start+cost_village1+cost_village2;
mining_days_total=workday1+workday2;
mining_income=1000*mining_days_total;
initial_money=10000;
final_money=initial_money+mining_income-total_cost;
%策略2模拟
str2_ww=3;
str2_fw=2;
str2_TotM=10000;
str2_Totw=1200;
str2_watersun=3;str2_foodsun=4;
str2_waterhight=9;str2_foodhight=9;
str2_watersand=10;str2_foodsand=10;
str2_price_water_start=5;
str2_price_food_start=10;
str2_price_water_village=10;
str2_price_food_village=20;
str2_P=[0,0];
str2_MM=[5,0];
str2_V1=[7,0];
str2_F=[6,sqrt(8)];
str2_PD=str2_P;
str2_water=0;
str2_food=0;
str2_DMM1=0;
str2_arrMMt=0;
str2_usewaterlog1=[];
str2_usefoodlog1=[];
while str2_PD(1)~=str2_MM(1)
    for d=1:30
        str2_weather=W3(d);
        if str2_weather~=0
            str2_v=1;
            if str2_weather==1
                str2_wateruse=str2_watersun;
                str2_fooduse=str2_foodsun;
            else
                str2_wateruse=str2_waterhight;
                str2_fooduse=str2_foodhight;
            end
        else
            str2_v=0;
            str2_wateruse=str2_watersand;
            str2_fooduse=str2_foodsand;
        end       
        if str2_v==1
            str2_PD(1)=str2_PD(1)+1;
            str2_water=str2_water-2*str2_wateruse;
            str2_food=str2_food-2*str2_fooduse;
        else
            str2_water=str2_water-str2_wateruse;
            str2_food=str2_food-str2_fooduse;
        end        
        if str2_PD(1)==str2_MM(1)&&str2_arrMMt==0
            str2_DMM1=d;
            str2_arrMMt=1;
            str2_usewaterlog1=[str2_usewaterlog1,-str2_water];
            str2_usefoodlog1=[str2_usefoodlog1,-str2_food];
            break;
        end
    end
end
str2_aMMw1=str2_usewaterlog1(1)*str2_ww+str2_usefoodlog1(1)*str2_fw;
str2_leftMMw1=str2_Totw-str2_aMMw1;
str2_max_days1=20;
str2_wusew1log=zeros(1,str2_max_days1);
str2_lusew1log=zeros(1,str2_max_days1);
str2_evac_days1=zeros(1,str2_max_days1);
str2_workday1=0;
str2_found1=false;
for str2_wday1=1:str2_max_days1
    str2_current_day=str2_DMM1+str2_wday1;
    if str2_current_day>30,break;end 
    if W3(str2_current_day)==0
        str2_daily_use=150;
    elseif W3(str2_current_day)==1
        str2_daily_use=51;
    else
        str2_daily_use=135;
    end
    if str2_wday1==1
        str2_wusew1log(str2_wday1)=str2_daily_use;
    else
        str2_wusew1log(str2_wday1)=str2_wusew1log(str2_wday1-1)+str2_daily_use;
    end
    str2_rl=0;str2_evac_use=0;str2_evac_days=0;
    for j=str2_current_day+1:length(W3)
        str2_evac_days=str2_evac_days+1;
        if W3(j)==0
            str2_evac_use=str2_evac_use+50;
        elseif W3(j)==1
            str2_evac_use=str2_evac_use+34;
            str2_rl=str2_rl+1;
        else
            str2_evac_use=str2_evac_use+90;
            str2_rl=str2_rl+1;
        end
        if str2_rl>=2,break;end
    end
    str2_lusew1log(str2_wday1)=str2_evac_use;
    str2_evac_days1(str2_wday1)=str2_evac_days;
    str2_total_use=str2_wusew1log(str2_wday1)+str2_lusew1log(str2_wday1);
    if str2_total_use>str2_leftMMw1
        str2_workday1=str2_wday1-1;
        str2_found1=true;
        break;
    end
    if str2_wday1==str2_max_days1&&str2_total_use<=str2_leftMMw1
        str2_workday1=str2_wday1;
        str2_found1=true;
    end
end
if ~str2_found1
    str2_workday1=0;
    str2_evac_days1=zeros(1,1);
end
str2_DV1=str2_DMM1+str2_workday1+str2_evac_days1(str2_workday1);
if str2_DV1>30,str2_DV1=30;end
str2_move_to_mine2=0;
str2_move_days2=0;
str2_actual_move_days2=0;
str2_move_water2=0;
str2_move_food2=0;
for j=str2_DV1+1:30
    str2_weather=W3(j);
    if str2_weather==0
        str2_move_to_mine2=str2_move_to_mine2+50;
        str2_move_water2=str2_move_water2+str2_watersand;
        str2_move_food2=str2_move_food2+str2_foodsand;
        str2_actual_move_days2=str2_actual_move_days2+1;
    elseif str2_weather==1
        str2_move_to_mine2=str2_move_to_mine2+34;
        str2_move_water2=str2_move_water2+2*str2_watersun;
        str2_move_food2=str2_move_food2+2*str2_foodsun;
        str2_move_days2=str2_move_days2+1;
        str2_actual_move_days2=str2_actual_move_days2+1;
    else
        str2_move_to_mine2=str2_move_to_mine2+90;
        str2_move_water2=str2_move_water2+2*str2_waterhight;
        str2_move_food2=str2_move_food2+2*str2_foodhight;
        str2_move_days2=str2_move_days2+1;
        str2_actual_move_days2=str2_actual_move_days2+1;
    end
    if str2_move_days2>=2,break;end
end
str2_DMM2=str2_DV1+str2_actual_move_days2;
str2_remaining_days2=30-str2_DMM2;
str2_max_days2=min(20,str2_remaining_days2);
str2_wusew2log=zeros(1,str2_max_days2);
str2_lusew2log=zeros(1,str2_max_days2);
str2_evac_days2=zeros(1,str2_max_days2);
str2_workday2=0;
str2_found2=false;
for str2_wday2=1:str2_max_days2
    str2_current_day=str2_DMM2+str2_wday2;
    if str2_current_day>30
        break
    end
    if W3(str2_current_day)==0
        str2_daily_use=150;
    elseif W3(str2_current_day)==1
        str2_daily_use=51;
    else
        str2_daily_use=135;
    end
    if str2_wday2==1
        str2_wusew2log(str2_wday2)=str2_daily_use;
    else
        str2_wusew2log(str2_wday2)=str2_wusew2log(str2_wday2-1)+str2_daily_use;
    end
    
    str2_rl2=0;str2_evac_use2=0;str2_evac_days=0;
    for j=str2_current_day+1:30
        str2_evac_days=str2_evac_days+1;
        if W3(j)==0
            str2_evac_use2=str2_evac_use2+50;
        elseif W3(j)==1
            str2_evac_use2=str2_evac_use2+34;
            str2_rl2=str2_rl2+1;
        else
            str2_evac_use2=str2_evac_use2+90;
            str2_rl2=str2_rl2+1;
        end
        if str2_rl2>=3
            break
        end
    end
    str2_lusew2log(str2_wday2)=str2_evac_use2;
    str2_evac_days2(str2_wday2)=str2_evac_days;
    str2_total_use2=str2_move_to_mine2+str2_wusew2log(str2_wday2)+str2_lusew2log(str2_wday2);
    if str2_total_use2>str2_Totw
        str2_workday2=str2_wday2-1;
        str2_found2=true;
        break;
    end
    if str2_wday2==str2_max_days2&&str2_total_use2<=str2_Totw
        str2_workday2=str2_wday2;
        str2_found2=true;
    end
end
if ~str2_found2
    str2_workday2=0;
    str2_evac_days2=zeros(1,1);
end
% 策略2资金计算
str2_use_water1=str2_usewaterlog1(1);
str2_use_food1=str2_usefoodlog1(1);
str2_mine1_water=0;str2_mine1_food=0;
for i=1:str2_workday1
    str2_d=str2_DMM1+i;
    if str2_d > 30, break; end
    if W3(str2_d)==0
        str2_mine1_water=str2_mine1_water+3*str2_watersand;
        str2_mine1_food=str2_mine1_food+3*str2_foodsand;
    elseif W3(str2_d)==1
        str2_mine1_water=str2_mine1_water+3*str2_watersun;
        str2_mine1_food=str2_mine1_food+3*str2_foodsun;
    else
        str2_mine1_water=str2_mine1_water+3*str2_waterhight;
        str2_mine1_food=str2_mine1_food+3*str2_foodhight;
    end
end
str2_evac1_water=0;str2_evac1_food=0;
str2_evac_start=str2_DMM1+str2_workday1+1;
str2_evac_end=str2_evac_start+str2_evac_days1(str2_workday1)-1;
for j=str2_evac_start:str2_evac_end
    if j > 30, break; end
    if W3(j)==0
        str2_evac1_water=str2_evac1_water+str2_watersand;
        str2_evac1_food=str2_evac1_food+str2_foodsand;
    elseif W3(j)==1
        str2_evac1_water=str2_evac1_water+2*str2_watersun;
        str2_evac1_food=str2_evac1_food+2*str2_foodsun;
    else
        str2_evac1_water=str2_evac1_water+2*str2_waterhight;
        str2_evac1_food=str2_evac1_food+2*str2_foodhight;
    end
end
str2_total_water1=str2_use_water1+str2_mine1_water+str2_evac1_water;
str2_total_food1=str2_use_food1+str2_mine1_food+str2_evac1_food;
str2_base_weight1=str2_total_water1*str2_ww+str2_total_food1*str2_fw;
str2_remaining_weight=str2_Totw-str2_base_weight1;
str2_remaining_weight=max(0,str2_remaining_weight);
str2_extra_food=floor(str2_remaining_weight/str2_fw);
str2_buy_water_start=str2_total_water1;
str2_buy_food_start=str2_total_food1+str2_extra_food;
str2_move_water2=str2_move_water2;
str2_move_food2=str2_move_food2;
str2_mine2_water=0;str2_mine2_food=0;
for i=1:str2_workday2
    str2_d=str2_DMM2+i;
    if str2_d > 30, break; end
    if W3(str2_d)==0
        str2_mine2_water=str2_mine2_water+3*str2_watersand;
        str2_mine2_food=str2_mine2_food+3*str2_foodsand;
    elseif W3(str2_d)==1
        str2_mine2_water=str2_mine2_water+3*str2_watersun;
        str2_mine2_food=str2_mine2_food+3*str2_foodsun;
    else
        str2_mine2_water=str2_mine2_water+3*str2_waterhight;
        str2_mine2_food=str2_mine2_food+3*str2_foodhight;
    end
end
str2_evac2_water=0;str2_evac2_food=0;
str2_evac2_start=str2_DMM2+str2_workday2+1;
str2_evac2_end=str2_evac2_start+str2_evac_days2(str2_workday2)-1;
for j=str2_evac2_start:str2_evac2_end
    if j > 30, break; end
    if W3(j)==0
        str2_evac2_water=str2_evac2_water+str2_watersand;
        str2_evac2_food=str2_evac2_food+str2_foodsand;
    elseif W3(j)==1
        str2_evac2_water=str2_evac2_water+2*str2_watersun;
        str2_evac2_food=str2_evac2_food+2*str2_foodsun;
    else
        str2_evac2_water=str2_evac2_water+2*str2_waterhight;
        str2_evac2_food=str2_evac2_food+2*str2_foodhight;
    end
end

str2_total_water2=str2_move_water2+str2_mine2_water+str2_evac2_water;
str2_total_food2=str2_move_food2+str2_mine2_food+str2_evac2_food;

str2_remaining_water=str2_buy_water_start-str2_total_water1;
str2_remaining_food=str2_buy_food_start-str2_total_food1;
str2_buy_water_village=max(0,str2_total_water2-str2_remaining_water);
str2_buy_food_village=max(0,str2_total_food2-str2_remaining_food);

str2_cost_start=str2_buy_water_start*str2_price_water_start+...
    str2_buy_food_start*str2_price_food_start;
str2_cost_village=str2_buy_water_village*str2_price_water_village+...
    str2_buy_food_village*str2_price_food_village;
str2_total_cost=str2_cost_start+str2_cost_village;
str2_mining_days=str2_workday1+str2_workday2;
str2_mining_income=1000*str2_mining_days;
str2_final_money=str2_TotM+str2_mining_income-str2_total_cost;
%由于条件相同，第六关可以照搬第四关的策略1和2
disp('在生成天气序列为')
disp(W3)
if final_money > str2_final_money
    fprintf('第六关的玩家1可以按照策略1行动，达到最优，最终剩余资金%d\n',final_money);
    yorn=1;%可以派出玩家2抢跑矿山挖矿，路径是起点—矿山（挖到玩家1抵达矿山那天的第二天离开）
    %玩家3先在起点休息一天，后以有效移动8天的策略抵达终点
elseif str2_final_money > final_money
    fprintf('第六关的玩家1可以按照策略2行动，达到最优,最终剩余资金%d\n',str2_final_money);
    yorn=0;%不能派出一人抢跑矿山挖矿，故让玩家2以有效移动8天的策略抵达终点
    %玩家3先在起点休息一天，后以有效移动8天的策略抵达终点
else
    fprintf('策略1和策略2效果相同，故选择让玩家1按照策略1行动\n');
    yorn=1;%可以派出玩家2抢跑矿山挖矿，路径是起点—矿山（挖到玩家1抵达矿山那天的第二天离开）
    %玩家3先在起点休息一天，后以有效移动8天的策略抵达终点
end
if final_money > str2_final_money
    %输出策略1完整方案
    fprintf('\n===== 玩家1的最优方案（策略1）完整总结 =====\n');
    fprintf('1. 行动路线：起点→村庄→矿山→村庄→矿山→终点\n');
    fprintf('2. 关键时间节点：\n');
    fprintf(' - 第%d天：首次抵达村庄\n',DV1);
    fprintf(' - 第%d天：首次抵达矿山\n',DMM1);
    fprintf(' - 第%d天：第一次挖矿结束（共%d天）\n',end_mine1_day,workday1);
    fprintf(' - 第%d天：第二次抵达矿山\n',arrive_mine2_day);
    fprintf(' - 第%d天：第二次挖矿结束（共%d天）\n',end_mine2_day,workday2);
    fprintf(' - 第%d天：抵达终点（总耗时%d天）\n',arrive_end_day,total_days_used);
    fprintf('3. 资源购买与消耗：\n');
    fprintf(' - 起点购买：水%d单位，食物%d单位，花费%d元\n',buy_water_start,buy_food_start,cost_start);
    fprintf(' - 村庄购买：第一次水%d单位，第二次水%d单位、食物%d单位，总花费%d元\n',buy_water_village1,buy_water_village2,buy_food_village2,cost_village1+cost_village2);
    fprintf(' - 认为一次补充物资到另一次补充物资之前为一个阶段\n')
    fprintf(' - 阶段1消耗:水%d,食物%d\n',use_water1,use_food1);
    fprintf(' - 阶段2消耗:水%d,食物%d\n',use_water2,use_food2);
    fprintf(' - 阶段3消耗:水%d,食物%d→剩余0\n',use_water3,use_food3);
    fprintf(' - 总花费：%d元，挖矿总收益：%d元\n',total_cost,mining_income);
    fprintf('4. 最终剩余资金：%d元\n',final_money);
elseif str2_final_money > final_money
    fprintf('\n===== 玩家1的最优方案（策略2）完整总结 =====\n');
    fprintf('1. 行动路线：起点→矿山→村庄→矿山→终点\n');
    fprintf('2. 关键时间节点：\n');
    fprintf(' - 第%d天：首次抵达矿山\n',str2_DMM1);
    fprintf(' - 第%d天：第一次挖矿结束（共%d天）\n',str2_DMM1+str2_workday1,str2_workday1);
    fprintf(' - 第%d天：抵达村庄\n',str2_DV1);
    fprintf(' - 第%d天：二次抵达矿山\n',str2_DMM2);
    fprintf(' - 第%d天：第二次挖矿结束（共%d天）\n',str2_DMM2+str2_workday2,str2_workday2);
    fprintf(' - 总耗时：%d天\n',min(str2_DMM2+str2_workday2+str2_evac_days2(str2_workday2),30));
    fprintf('3. 资源购买与消耗：\n');
    fprintf(' - 起点购买：水%d单位，食物%d单位，花费%d元\n',str2_buy_water_start,str2_buy_food_start,str2_cost_start);
    fprintf(' - 村庄购买：水%d单位，食物%d单位，花费%d元\n',str2_buy_water_village,str2_buy_food_village,str2_cost_village);
    fprintf(' - 认为一次补充物资到另一次补充物资之前为一个阶段\n')
    fprintf(' - 阶段1总消耗:水%d, 食物%d\n',str2_total_water1,str2_total_food1);
    fprintf(' - 阶段2总消耗:水%d, 食物%d→剩余0\n',str2_total_water2,str2_total_food2);
    fprintf(' - 总花费：%d元，挖矿总收益：%d元\n',str2_total_cost,str2_mining_income);
    fprintf('4. 最终剩余资金：%d元\n',str2_final_money);
else
    fprintf('\n【由于两种策略结果资金相等，所以玩家1选择策略1行动，给玩家2至少两天的挖矿天数】\n');
    fprintf('策略1与策略2最终资金均为%d元。\n',final_money);
     %输出策略1完整方案
    fprintf('\n===== 为了提高玩家2的收益，玩家1（选择策略1）的最优方案完整总结 =====\n');
    fprintf('1. 行动路线：起点→村庄→矿山→村庄→矿山→终点\n');
    fprintf('2. 关键时间节点：\n');
    fprintf(' - 第%d天：首次抵达村庄\n',DV1);
    fprintf(' - 第%d天：首次抵达矿山\n',DMM1);
    fprintf(' - 第%d天：第一次挖矿结束（共%d天）\n',end_mine1_day,workday1);
    fprintf(' - 第%d天：第二次抵达矿山\n',arrive_mine2_day);
    fprintf(' - 第%d天：第二次挖矿结束（共%d天）\n',end_mine2_day,workday2);
    fprintf(' - 第%d天：抵达终点（总耗时%d天）\n',arrive_end_day,total_days_used);
    fprintf('3. 资源购买与消耗：\n');
    fprintf(' - 起点购买：水%d单位，食物%d单位，花费%d元\n',buy_water_start,buy_food_start,cost_start);
    fprintf(' - 村庄购买：第一次水%d单位，第二次水%d单位、食物%d单位，总花费%d元\n',buy_water_village1,buy_water_village2,buy_food_village2,cost_village1+cost_village2);
    fprintf(' - 认为一次补充物资到另一次补充物资之前为一个阶段\n')
    fprintf(' - 阶段1消耗:水%d,食物%d\n',use_water1,use_food1);
    fprintf(' - 阶段2消耗:水%d,食物%d\n',use_water2,use_food2);
    fprintf(' - 阶段3消耗:水%d,食物%d→剩余0\n',use_water3,use_food3);
    fprintf(' - 所有阶段资源消耗完毕，无剩余（符合要求）\n');
    fprintf(' - 总花费：%d元，挖矿总收益：%d元\n',total_cost,mining_income);
    fprintf('4. 最终剩余资金：%d元\n',final_money);
end
%由于另外两名玩家都是“急行军”，故不考虑负重不足的情况
if yorn==1
    %玩家1按照策略1行动
    %编写玩家2策略,因为与玩家1一同出发，则只需统计玩家1行为矩阵act前几个不等于0的数有5个
    %再统计玩家1行为矩阵act前几个不等于0的数有7个，二者相减就是玩家2的挖矿天数
    %等价于前文的DMM1-DV1.总体看可以分为3部分：1.与玩家1到村庄相同消耗的物资是玩家2到矿山
    %2.挖矿消耗物资。3.3天有效撤离花费的物资。
    p2uw1=usewaterlog(1);
    p2uf1=usefoodlog(1);
    p2workday=DMM1-DV1;%player2简称p2
    for p2w=1:p2workday
        if W3(DMM1+p2w)==0
            %沙暴挖矿
            p2uw1=p2uw1+3*10;
            p2uf1=p2uf1+3*10;
        elseif W3(DMM1+p2w)==1
            %晴朗挖矿
            p2uw1=p2uw1+3*3;
            p2uf1=p2uf1+3*4;
        else
            %高温挖矿
            p2uw1=p2uw1+3*9;
            p2uf1=p2uf1+3*9;
        end
    end
    %从第DMM1+1天开始撤离抵达终点
    rp2l=0;%实际需要3天撤离
    br=DMM1+1;
    while rp2l~=3  
        if W3(br)==0
            p2uw1=p2uw1+10;
            p2uf1=p2uf1+10;
        elseif W3(br)==1
            p2uw1=p2uw1+2*3;
            p2uf1=p2uf1+2*4;
            rp2l=rp2l+1;
        else
            p2uw1=p2uw1+2*9;
            p2uf1=p2uf1+2*9;
            rp2l=rp2l+1;
        end
        br=br+1;
    end
    TotM2=TotM+p2workday*1000-p2uw1*5-p2uf1*10;
    disp(['玩家2总消耗',num2str(p2uw1),'单位的水',num2str(p2uf1),'单位的食物',...
        '总挖矿',num2str(p2workday),'天，在第',num2str(br),...
        '天抵达终点，剩余资金',num2str(TotM2)])
    %接下来编写玩家3，如果第一天不是沙暴，玩家3在起点休息了1天(等前两个玩家出发）
    %也就是说玩家3的出发日期是开局第2个不是沙暴的天气的天数
    no0index=(find(W3~=0));%获取所有非零元素的索引
    secondno0=no0index(2);
    %disp(['第二个非零元素的位置是：', num2str(secondno0)]);disp(['对应的数值是：', num2str(W3(secondno0))]);
    %也就是说secondno0是玩家3的出发日期
    p3uw1=0;
    p3uf1=0;%存储资源消耗
    %先计算前几天的休息消耗
    for ard3=1:(secondno0-1)
            if W3(ard3)==0
                %沙暴休息
                p3uw1=p3uw1+10;
                p3uf1=p3uf1+10;
            elseif W3(ard3)==1
                p3uw1=p3uw1+3;
                p3uf1=p3uf1+4;
            else
                p3uw1=p3uw1+9;
                p3uf1=p3uf1+9;
            end
    end
    rl3=0;%记录有效移动天数
    rd3=0;%记录休息时间
    while rl3~=8
        for d3=secondno0:30
            if W3(d3)==0
                %沙暴休息
                p3uw1=p3uw1+10;
                p3uf1=p3uf1+10;
                rd3=rd3+1;
            elseif W3(d3)==1
                p3uw1=p3uw1+2*3;
                p3uf1=p3uf1+2*4;
                rl3=rl3+1;
            else
                p3uw1=p3uw1+2*9;
                p3uf1=p3uf1+2*9;
                rl3=rl3+1;
            end
            if rl3==8
                break
            end
        end
    end
    Totd3=secondno0+8-1+rd3;%总耗天数
    TotM3=TotM-p3uw1*5-p3uf1*10;
    disp(['玩家3总消耗',num2str(p3uw1),'单位的水',num2str(p3uf1),'单位的食物',...
        '在第',num2str(Totd3),'天抵达终点，剩余资金',num2str(TotM3)])
    disp(['此时三个人剩余的资金总数最多为：',num2str(final_money+TotM2+TotM3)])
else
    %策略2最优，玩家2直达终点，玩家3依旧是第二个非沙暴日出发去终点
    %先编写玩家2的情况
    p2uw1=0;
    p2uf1=0;%存储资源消耗
    rl2=0;%记录有效移动天数
    rd2=0;%记录休息时间
    while rl2~=8
        for d2=1:30
            if W3(d2)==0
                %沙暴休息
                p2uw1=p2uw1+10;
                p2uf1=p2uf1+10;
                rd2=rd2+1;
            elseif W3(d2)==1
                p2uw1=p2uw1+2*3;
                p2uf1=p2uf1+2*4;
                rl2=rl2+1;
            else
                p2uw1=p2uw1+2*9;
                p2uf1=p2uf1+2*9;
                rl2=rl2+1;
            end
            if rl2==8
                break
            end
        end
    end
    Totd2=8+rd2;%总耗天数
    TotM2=TotM-p2uw1*5-p2uf1*10;
    disp(['玩家2总消耗',num2str(p2uw1),'单位的水',num2str(p2uf1),'单位的食物',...
        '在第',num2str(Totd2),'天抵达终点，剩余资金',num2str(TotM2)])
    %接下来编写玩家3内容
    no0index=(find(W3~=0));%获取所有非零元素的索引
    secondno0=no0index(2);
    %disp(['第二个非零元素的位置是：', num2str(secondno0)]);disp(['对应的数值是：', num2str(W3(secondno0))]);
    %也就是说secondno0是玩家3的出发日期
    p3uw1=0;
    p3uf1=0;%存储资源消耗
    %先计算前几天的休息消耗
    for ard3=1:(secondno0-1)
            if W3(ard3)==0
                %沙暴休息
                p3uw1=p3uw1+10;
                p3uf1=p3uf1+10;
            elseif W3(ard3)==1
                p3uw1=p3uw1+3;
                p3uf1=p3uf1+4;
            else
                p3uw1=p3uw1+9;
                p3uf1=p3uf1+9;
            end
    end
    rl3=0;%记录有效移动天数
    rd3=0;%记录休息时间
    while rl3~=8
        for d2=secondno0:30
            if W3(d2)==0
                %沙暴休息
                p3uw1=p3uw1+10;
                p3uf1=p3uf1+10;
                rd3=rd3+1;
            elseif W3(d2)==1
                p3uw1=p3uw1+2*3;
                p3uf1=p3uf1+2*4;
                rl3=rl3+1;
            else
                p3uw1=p3uw1+2*9;
                p3uf1=p3uf1+2*9;
                rl3=rl3+1;
            end
            if rl3==8
                break
            end
        end
    end
    Totd3=secondno0+8-1+rd3;%总耗天数
    TotM3=TotM-p3uw1*5-p3uf1*10;
    disp(['玩家3总消耗',num2str(p3uw1),'单位的水',num2str(p3uf1),'单位的食物',...
        '在第',num2str(Totd3),'天抵达终点，剩余资金',num2str(TotM3)])
    disp(['此时三个人剩余的资金总数最多为：',num2str(final_money+TotM2+TotM3)])
end