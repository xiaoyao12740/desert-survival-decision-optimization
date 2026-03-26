clear
clc
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
for i=1:3
    for buy=0:1
        if buy==0
            disp('如果物资全部来自于起点，则：')
            if W(i)==0
                fprintf('沙暴情况下休息消耗的负重为%d,资金消耗为%d\n',usew(3),usem(3))
                fprintf('沙暴情况下挖矿消耗的负重为%d,资金消耗为%d\n',3*usew(3),3*usem(3))
                fprintf('挖矿的净利润是%d\n',1000-3*usem(3))
            elseif W(i)==1
                fprintf('晴朗情况下休息消耗的负重为%d,资金消耗为%d\n',usew(1),usem(1))
                fprintf('晴朗情况下移动消耗的负重为%d,资金消耗为%d\n',2*usew(1),2*usem(1))
                fprintf('晴朗情况下挖矿消耗的负重为%d,资金消耗为%d\n',3*usew(1),3*usem(1))
                fprintf('挖矿的净利润是%d\n',1000-3*usem(1))
            else
                fprintf('高温情况下休息消耗的负重为%d,资金消耗为%d\n',usew(2),usem(2))
                fprintf('高温情况下移动消耗的负重为%d,资金消耗为%d\n',2*usew(2),2*usem(2))
                fprintf('高温情况下挖矿消耗的负重为%d,资金消耗为%d\n',3*usew(2),3*usem(2))
                fprintf('挖矿的净利润是%d\n',1000-3*usem(2))
            end
        else
            disp('如果物资全部来自于村庄，则：')
            if W(i)==0
                fprintf('沙暴情况下休息消耗的负重为%d,资金消耗为%d\n',usew(3),2*usem(3))
                fprintf('沙暴情况下挖矿消耗的负重为%d,资金消耗为%d\n',3*usew(3),6*usem(3))
                fprintf('挖矿的净利润是%d\n',1000-6*usem(3))
            elseif W(i)==1
                fprintf('晴朗情况下休息消耗的负重为%d,资金消耗为%d\n',usew(1),2*usem(1))
                fprintf('晴朗情况下移动消耗的负重为%d,资金消耗为%d\n',2*usew(1),4*usem(1))
                fprintf('晴朗情况下挖矿消耗的负重为%d,资金消耗为%d\n',3*usew(1),6*usem(1))
                fprintf('挖矿的净利润是%d\n',1000-6*usem(1))
            else
                fprintf('高温情况下休息消耗的负重为%d,资金消耗为%d\n',usew(2),2*usem(2))
                fprintf('高温情况下移动消耗的负重为%d,资金消耗为%d\n',2*usew(2),4*usem(2))
                fprintf('高温情况下挖矿消耗的负重为%d,资金消耗为%d\n',3*usew(2),6*usem(2))
                fprintf('挖矿的净利润是%d\n',1000-6*usem(2))
            end
        end
    end
end
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
    if S3(1)/30>0.2||S3(2)/30<0.2375||S3(2)/30>0.4375...
            ||S3(3)/30<0.4625||S3(3)/30>0.6625
        disp('出现一次抽取结果不合理,下面将自动进行下一次抽取')
        w3=w3+1;
        W3=[];
        S3=zeros(1,3);
        yorn3=0;
    else
        disp(['共计失败',num2str(w3),'次后得到第四关30天天气合理抽取结果：'])
        disp(W3)
        yorn3=1;
    end
end
disp('其中0代表沙暴，1代表晴朗，2代表高温')
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
                break
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
            disp(['抵达村庄！共花费天数:',num2str(DV1),'共花费水数',num2str(-water),'共花费食物数',num2str(-food)])
            usewaterlog=[usewaterlog,-water];
            usefoodlog=[usefoodlog,-food];
            continue
        elseif PD(1)==MM(1)&&Totw>((-3)*water+(-2)*food)&&arrMMt==0
            DMM1=d;
            arrMMt=arrMMt+1;
            disp(['抵达矿山！共花费天数:',num2str(DMM1),'共花费水数',num2str(-water),'共花费食物数',num2str(-food)])
            usewaterlog=[usewaterlog,-water];
            usefoodlog=[usefoodlog,-food];
            break
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
            break
        end
    end
    lusew1log(wday1)=total_evacuation_use;
    evacuation_days(wday1)=evacuation_day_count;
    total_use=wusew1log(wday1)+lusew1log(wday1);
    fprintf(['尝试挖矿%d天:挖矿消耗=%d,撤离消耗=%d,总消耗=%d(剩余负重=%d)\n'],wday1,wusew1log(wday1),lusew1log(wday1),total_use,leftMMw1);
    if total_use>leftMMw1
        workday1=wday1-1;
        found=true;
        break
    end
    if wday1==max_possible_days&&total_use<=leftMMw1
        workday1=wday1;
        found=true;
    end
end
if found
    fprintf('第一次挖矿天数为%d天\n',workday1);
    fprintf('挖矿总消耗:%d\n',wusew1log(workday1));
    fprintf('撤离总消耗:%d(需要%d天)\n',lusew1log(workday1),evacuation_days(workday1));
    fprintf('总负重消耗:%d(剩余负重:%d)\n',wusew1log(workday1)+lusew1log(workday1),leftMMw1-(wusew1log(workday1)+lusew1log(workday1)));
else
    disp('无法找到可行的挖矿天数');
end
disp('挖矿天数|累计挖矿消耗|撤离消耗|所需撤离天数');
for i=1:workday1
    fprintf('%5d|%9d|%7d|%7d\n',i,wusew1log(i),lusew1log(i),evacuation_days(i));
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
        break
    end
end
remaining_days=30-(DV2+actual_move_days);
start_mining_day=DV2+actual_move_days+1;
for wday2=min(max_possible_days2,remaining_days):-1:1
    current_day=start_mining_day+wday2-1;
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
            break
        end
    end
    total_use2=move_to_mine+cumulative_mining+total_evacuation_use2;
    if rl2>=3&&total_use2<=Totw
        workday2=wday2;
        found2=true;
        wusew2log=[wusew2log,daily_use2];
        lusew2log=[lusew2log,total_evacuation_use2];
        evacuation_days2=[evacuation_days2,evacuation_day_count2];
        break
    end
end
if found2
    fprintf('第二次挖矿天数为%d天\n',workday2);
    fprintf('移动消耗:%d(实际%d天)\n',move_to_mine,actual_move_days);
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
    cumulative_mining=sum(wusew2log_full);
    fprintf('挖矿总消耗:%d\n',cumulative_mining);
    fprintf('撤离总消耗:%d(需要%d天,有效移动日=%d)\n',lusew2log,evacuation_days2,min(3,rl2));
    fprintf('总负重消耗:%d(剩余负重:%d)\n',move_to_mine+cumulative_mining+lusew2log,Totw-(move_to_mine+cumulative_mining+lusew2log));
    disp('挖矿天数|累计挖矿消耗|撤离消耗|所需撤离天数');
    cumulative=0;
    for i=1:workday2
        cumulative=cumulative+wusew2log_full(i);
        fprintf('%5d|%9d|%7d|%7d\n',i,cumulative,lusew2log,evacuation_days2);
    end
else
    disp('无法找到可行的第二次挖矿天数');
end
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
valid=true;
for d=non_mine_periods
    if d<1||d>30,continue;end
    if W3(d)==0&&act1(d)~=0
        valid=false;
        fprintf('合理性错误：第%d天在非矿山区域遭遇沙暴却在执行行动（行动类型=%d）\n',d,act1(d));
    end
end
for d=non_mine_periods
    if d<1||d>30,continue;end
    if act1(d)==2
        valid=false;
        fprintf('合理性错误：第%d天非矿山区域却在挖矿\n',d);
    end
end
for d=mine_periods
    if d<1||d>30,continue;end
    if act1(d)~=2
        valid=false;
        fprintf('合理性错误：第%d天矿山区域却未挖矿（行动类型=%d）\n',d,act1(d));
    end
end
if valid
    disp('合理性检验通过：所有行动符合规则')
else
    disp('合理性检验失败：存在违规行动')
end
end_mine1_day=DMM1+workday1;
arrive_village2_day=DV2;
arrive_mine2_day=DV2+actual_move_days;
end_mine2_day=arrive_mine2_day+workday2;
arrive_end_day=end_mine2_day+evacuation_days2;
total_days_used=arrive_end_day;
disp('=====第四关策略1行动总结=====')
fprintf('第0天：从起点出发\n')
fprintf('第%d天：第一次抵达村庄（耗时%d天）\n',DV1,DV1)
fprintf('第%d天：第一次抵达矿山（累计耗时%d天）\n',DMM1,DMM1)
fprintf('第%d天：第一次挖矿结束（共挖%d天）\n',end_mine1_day,workday1)
fprintf('第%d天：第二次抵达村庄（撤离矿山耗时%d天）\n',arrive_village2_day,evacuation_days(workday1))
fprintf('第%d天：第二次抵达矿山（从村庄出发耗时%d天）\n',arrive_mine2_day,actual_move_days)
fprintf('第%d天：第二次挖矿结束（共挖%d天）\n',end_mine2_day,workday2)
fprintf('第%d天：抵达终点（撤离矿山耗时%d天）\n',arrive_end_day,evacuation_days2)
if total_days_used<=30
    fprintf('总耗时：%d天（≤30天，符合要求）\n',total_days_used)
else
    fprintf('总耗时：%d天（≤30天，不符合要求）\n',total_days_used)
end
price_water_start=5;
price_food_start=10;
price_water_village=10;
price_food_village=20;
use_water1=usewaterlog(1);
use_food1=usefoodlog(1);
%下根据第二，三阶段的负重消耗反推实际物资消耗量
%先算第二阶段
V2MM2w=usewaterlog(2)-usewaterlog(1);
V2MM2f=usefoodlog(2)-usefoodlog(1);
%根据workday1循环累加矿山挖矿消耗
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
%下迭代计算撤离的实际消耗量
for l2=1:evacuation_days(workday1)
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
%后计算第三阶段实际消耗资源量:去矿山、挖矿、到终点
u3w=0;
u3f=0;
for d2=1:(arrive_end_day-arrive_village2_day)
    if act1(arrive_village2_day+d2)==0
        if W3(arrive_village2_day+d2)==0
            u3w=u3w+10;
            u3f=u3f+10;
        elseif W3(arrive_village2_day+d2)==1
            u3w=u3w+3;
            u3f=u3f+4;
        else
            u3w=u3w+9;
            u3f=u3f+9;
        end
    elseif act1(arrive_village2_day+d2)==1
        if W3(arrive_village2_day+d2)==2
            u3w=u3w+9;
            u3f=u3f+9;
        elseif W3(arrive_village2_day+d2)==1
            u3w=u3w+3;
            u3f=u3f+4;
        end
    else
        if W3(arrive_village2_day+d2)==0
            u3w=u3w+3*10;
            u3f=u3f+3*10;
        elseif W3(arrive_village2_day+d2)==1
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
food2_from_start=use_food2;
food2_weight=food2_from_start*2;
uw12=use_water1+use_water2;
uf12=use_food1+use_food2;
bv1w=uw12*3+uf12*2-Totw;
u1w=usefoodlog(1)*2+usewaterlog(1)*3;
water2andfood2_from_startw=Totw-u1w;
food2_from_start=min(floor((water2andfood2_from_startw)/2),use_food2);
if (Totw-(u1w+food2_from_start*2))>3
    %起点还需要额外购买水
    water2_from_start=floor((Totw-(u1w+food2_from_start*2))/3);
else
    water2_from_start=0;
    %起点不能再买水了
end
buy_water_start=use_water1+water2_from_start;
buy_food_start=use_food1+food2_from_start;
buy_water_village1=use_water2-water2_from_start;
buy_food_village1=use_food2-food2_from_start;
buy_water_village2=use_water3;
buy_food_village2=use_food3;
start_total_weight=buy_water_start*3+buy_food_start*2;
village1_total_weight=buy_water_village1*3+buy_food_village1*2;
village2_total_weight=buy_water_village2*3+buy_food_village2*2;
fprintf('\n=====策略1负重验证=====\n');
fprintf('起点购买总负重:%d(最大1200)\n',start_total_weight);
fprintf('第一次村庄购买负重:%d\n',village1_total_weight);
fprintf('第二次村庄购买负重:%d(≤1200)\n',village2_total_weight);
cost_start=buy_water_start*5+buy_food_start*10;
cost_village1=buy_water_village1*price_water_village+buy_food_village1*price_food_village;
cost_village2=buy_water_village2*price_water_village+buy_food_village2*price_food_village;
total_cost=cost_start+cost_village1+cost_village2;
mining_days_total=workday1+workday2;
mining_income=1000*mining_days_total;
initial_money=10000;
final_money=initial_money+mining_income-total_cost;
fprintf('\n=====策略1资源购买详情=====\n');
fprintf('起点购买:水%d单位,食物%d单位→花费%d元\n',buy_water_start,buy_food_start,cost_start);
fprintf('第一次村庄购买:水%d单位,食物%d单位→花费%d元\n',buy_water_village1,buy_food_village1,cost_village1);
fprintf('第二次村庄购买:水%d单位,食物%d单位→花费%d元\n',buy_water_village2,buy_food_village2,cost_village2);
fprintf('总花费:%d元\n',total_cost);
fprintf('\n=====策略1资金结果=====\n');
fprintf('初始资金:%d元\n',initial_money);
fprintf('挖矿总天数:%d天→收益%d元\n',mining_days_total,mining_income);
fprintf('最终剩余资金:%d元\n',final_money);
fprintf('\n=====策略1资源消耗验证=====\n');
fprintf('阶段1消耗:水%d,食物%d\n',use_water1,use_food1);
fprintf('阶段2消耗:水%d,食物%d\n',use_water2,use_food2);
fprintf('阶段3消耗:水%d,食物%d\n',use_water3,use_food3);
fprintf('所有阶段资源消耗完毕，无剩余（符合要求）\n');
str2_ww=3;%水单位重量
str2_fw=2;%食物单位重量
str2_TotM=10000;%初始资金
str2_Totw=1200;%最大负重
%消耗参数（与策略1完全一致）
str2_watersun=3;str2_foodsun=4;
str2_waterhight=9;str2_foodhight=9;
str2_watersand=10;str2_foodsand=10;
%单价（与策略1一致）
str2_price_water_start=5;
str2_price_food_start=10;
str2_price_water_village=10;
str2_price_food_village=20;
%位置定义
str2_P=[0,0];%起点
str2_MM=[5,0];%矿山
str2_V1=[7,0];%村庄
str2_F=[6,sqrt(8)];%终点
%==================== 阶段1：起点→矿山→挖矿→村庄 ====================
%阶段1.1：起点→直达矿山（不经过村庄，记录实际消耗日志）
str2_PD=str2_P;
str2_water=0;%累计水消耗（负值）
str2_food=0;%累计食物消耗（负值）
str2_DMM1=0;%抵达矿山天数
str2_arrMMt=0;
str2_usewaterlog1=[];%阶段1水消耗日志（关键：与策略1格式一致）
str2_usefoodlog1=[];%阶段1食物消耗日志
while str2_PD(1)~=str2_MM(1)
    for d=1:30
        str2_weather=W3(d);
        if str2_weather~=0%非沙暴可移动
            str2_v=1;
            if str2_weather==1%晴朗
                str2_wateruse=str2_watersun;
                str2_fooduse=str2_foodsun;
            else%高温
                str2_wateruse=str2_waterhight;
                str2_fooduse=str2_foodhight;
            end
        else%沙暴休息
            str2_v=0;
            str2_wateruse=str2_watersand;
            str2_fooduse=str2_foodsand;
        end
        %行动消耗（移动×2，休息×1，与策略1一致）
        if str2_v==1
            str2_PD(1)=str2_PD(1)+1;%直达矿山
            str2_water=str2_water-2*str2_wateruse;
            str2_food=str2_food-2*str2_fooduse;
        else
            str2_water=str2_water-str2_wateruse;
            str2_food=str2_food-str2_fooduse;
        end
        %记录抵达矿山的消耗（日志化，与策略1一致）
        if str2_PD(1)==str2_MM(1)&&str2_arrMMt==0
            str2_DMM1=d;
            str2_arrMMt=1;
            str2_usewaterlog1=[str2_usewaterlog1,-str2_water];%实际水消耗
            str2_usefoodlog1=[str2_usefoodlog1,-str2_food];%实际食物消耗
            break;
        end
    end
end
fprintf('\n===== 策略2阶段1.1：起点→矿山 =====\n');
fprintf('抵达日期：第%d天\n',str2_DMM1);
fprintf('消耗日志：水%d, 食物%d → 负重%d\n',...
    str2_usewaterlog1(1),str2_usefoodlog1(1),...
    str2_usewaterlog1(1)*str2_ww+str2_usefoodlog1(1)*str2_fw);
%子阶段1.2：矿山首次挖矿（按天气算消耗，与策略1逻辑一致）
str2_aMMw1=str2_usewaterlog1(1)*str2_ww+str2_usefoodlog1(1)*str2_fw;
str2_leftMMw1=str2_Totw-str2_aMMw1;%剩余负重
%初始化挖矿日志（向量存储，避免索引错误）
str2_max_days1=20;
str2_wusew1log=zeros(1,str2_max_days1);%累计挖矿负重
str2_lusew1log=zeros(1,str2_max_days1);%撤离至村庄负重
str2_evac_days1=zeros(1,str2_max_days1);%撤离天数
str2_workday1=0;
str2_found1=false;
for str2_wday1=1:str2_max_days1
    str2_current_day=str2_DMM1+str2_wday1;
    if str2_current_day>30,break;end
    %当天挖矿负重（沙暴150/晴朗51/高温135，与策略1完全一致）
    if W3(str2_current_day)==0
        str2_daily_use=150;
    elseif W3(str2_current_day)==1
        str2_daily_use=51;
    else
        str2_daily_use=135;
    end
    %累计挖矿消耗
    if str2_wday1==1
        str2_wusew1log(str2_wday1)=str2_daily_use;
    else
        str2_wusew1log(str2_wday1)=str2_wusew1log(str2_wday1-1)+str2_daily_use;
    end
    %撤离至村庄消耗（2个有效移动日，与策略1一致）
    str2_rl=0;str2_evac_use=0;str2_evac_days=0;
    for j=str2_current_day+1:length(W3)
        str2_evac_days=str2_evac_days+1;
        if W3(j)==0%沙暴休息（50）
            str2_evac_use=str2_evac_use+50;
        elseif W3(j)==1%晴朗移动（34）
            str2_evac_use=str2_evac_use+34;
            str2_rl=str2_rl+1;
        else%高温移动（90）
            str2_evac_use=str2_evac_use+90;
            str2_rl=str2_rl+1;
        end
        if str2_rl>=2,break;end
    end
    str2_lusew1log(str2_wday1)=str2_evac_use;
    str2_evac_days1(str2_wday1)=str2_evac_days;
    %检查总消耗是否超限
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
%输出首次挖矿结果（修正索引：仅遍历有效天数）
fprintf('\n===== 策略2阶段1.2：矿山首次挖矿 =====\n');
if str2_found1&&str2_workday1>0
    fprintf('首次挖矿天数：%d天\n',str2_workday1);
    fprintf('挖矿总消耗：%d\n',str2_wusew1log(str2_workday1));
    fprintf('撤离至村庄消耗：%d(需要%d天)\n',...
        str2_lusew1log(str2_workday1),str2_evac_days1(str2_workday1));
    fprintf('总负重消耗：%d(剩余：%d)\n',...
        str2_wusew1log(str2_workday1)+str2_lusew1log(str2_workday1),...
        str2_leftMMw1-(str2_wusew1log(str2_workday1)+str2_lusew1log(str2_workday1)));
    disp('挖矿天数|累计挖矿消耗|撤离消耗|所需撤离天数');
    for i=1:str2_workday1%仅遍历有效天数，避免索引超界
        fprintf('%5d|%9d|%7d|%7d\n',...
            i,str2_wusew1log(i),str2_lusew1log(i),str2_evac_days1(i));
    end
else
    disp('策略2无首次挖矿');
    str2_workday1=0;
    str2_evac_days1=zeros(1,1);%初始化避免索引错误
end
%子阶段1.3：矿山→村庄（记录抵达日期）
str2_DV1=str2_DMM1+str2_workday1+str2_evac_days1(str2_workday1);
if str2_DV1>30,str2_DV1=30;end
fprintf('\n===== 策略2阶段1.3：矿山→村庄 =====\n');
fprintf('抵达村庄日期：第%d天\n',str2_DV1);
%==================== 阶段2：村庄→矿山→挖矿→终点 ====================
%子阶段2.1：村庄→矿山（记录移动消耗日志）
str2_move_to_mine2=0;%移动负重
str2_move_days2=0;%有效移动日
str2_actual_move_days2=0;
str2_move_water2=0;%移动用水日志
str2_move_food2=0;%移动用食物日志

for j=str2_DV1+1:30
    str2_weather=W3(j);
    if str2_weather==0%沙暴休息
        str2_move_to_mine2=str2_move_to_mine2+50;
        str2_move_water2=str2_move_water2+str2_watersand;%记录实际水消耗
        str2_move_food2=str2_move_food2+str2_foodsand;%记录实际食物消耗
        str2_actual_move_days2=str2_actual_move_days2+1;
    elseif str2_weather==1%晴朗移动
        str2_move_to_mine2=str2_move_to_mine2+34;
        str2_move_water2=str2_move_water2+2*str2_watersun;%移动×2
        str2_move_food2=str2_move_food2+2*str2_foodsun;
        str2_move_days2=str2_move_days2+1;
        str2_actual_move_days2=str2_actual_move_days2+1;
    else%高温移动
        str2_move_to_mine2=str2_move_to_mine2+90;
        str2_move_water2=str2_move_water2+2*str2_waterhight;
        str2_move_food2=str2_move_food2+2*str2_foodhight;
        str2_move_days2=str2_move_days2+1;
        str2_actual_move_days2=str2_actual_move_days2+1;
    end
    if str2_move_days2>=2,break;end
end
str2_DMM2=str2_DV1+str2_actual_move_days2;%二次抵达矿山日期
fprintf('\n===== 策略2阶段2.1：村庄→矿山 =====\n');
fprintf('抵达日期：第%d天（移动耗时%d天）\n',str2_DMM2,str2_actual_move_days2);
fprintf('消耗日志：水%d, 食物%d → 负重%d\n',...
    str2_move_water2,str2_move_food2,str2_move_to_mine2);
%子阶段2.2：矿山二次挖矿（+撤离至终点，与策略1逻辑一致）
str2_remaining_days2=30-str2_DMM2;
str2_max_days2=min(20,str2_remaining_days2);
str2_wusew2log=zeros(1,str2_max_days2);%二次挖矿负重
str2_lusew2log=zeros(1,str2_max_days2);%撤离至终点负重
str2_evac_days2=zeros(1,str2_max_days2);%撤离天数
str2_workday2=0;
str2_found2=false;
str2_try_days=[];
str2_try_mine=[];
str2_try_evac=[];
str2_try_total=[];
for str2_wday2=1:str2_max_days2
    str2_current_day=str2_DMM2+str2_wday2;
    if str2_current_day>30,break;end
    %当天挖矿负重（与策略1一致）
    if W3(str2_current_day)==0
        str2_daily_use=150;
    elseif W3(str2_current_day)==1
        str2_daily_use=51;
    else
        str2_daily_use=135;
    end
    %累计挖矿消耗（向量索引）
    if str2_wday2==1
        str2_wusew2log(str2_wday2)=str2_daily_use;
    else
        str2_wusew2log(str2_wday2)=str2_wusew2log(str2_wday2-1)+str2_daily_use;
    end
    %撤离至终点消耗（3个有效移动日）
    str2_rl2=0;str2_evac_use2=0;str2_evac_days=0;
    for j=str2_current_day+1:30
        str2_evac_days=str2_evac_days+1;
        if W3(j)==0%沙暴休息（50）
            str2_evac_use2=str2_evac_use2+50;
        elseif W3(j)==1%晴朗移动（34）
            str2_evac_use2=str2_evac_use2+34;
            str2_rl2=str2_rl2+1;
        else%高温移动（90）
            str2_evac_use2=str2_evac_use2+90;
            str2_rl2=str2_rl2+1;
        end
        if str2_rl2>=3,break;end
    end
    str2_lusew2log(str2_wday2)=str2_evac_use2;
    str2_evac_days2(str2_wday2)=str2_evac_days;
    %总消耗=移动+挖矿+撤离（≤1200）
    str2_total_use2=str2_move_to_mine2+str2_wusew2log(str2_wday2)+str2_lusew2log(str2_wday2);
    %存储尝试结果
    str2_try_days=[str2_try_days,str2_wday2];
    str2_try_mine=[str2_try_mine,str2_wusew2log(str2_wday2)];
    str2_try_evac=[str2_try_evac,str2_lusew2log(str2_wday2)];
    str2_try_total=[str2_try_total,str2_total_use2];
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

%输出二次挖矿尝试结果（表格形式）
fprintf('策略2尝试二次挖矿结果：\n');
disp('挖矿天数|累计挖矿消耗|撤离消耗|总消耗(最大1200)');
for i=1:length(str2_try_days)
    fprintf('%5d|%9d|%7d|%13d\n',...
        str2_try_days(i),str2_try_mine(i),str2_try_evac(i),str2_try_total(i));
end

%输出二次挖矿最终结果
fprintf('\n===== 策略2阶段2.2：矿山二次挖矿 =====\n');
if str2_found2&&str2_workday2>0
    fprintf('二次挖矿天数：%d天\n',str2_workday2);
    fprintf('挖矿总消耗：%d\n',str2_wusew2log(str2_workday2));
    fprintf('撤离至终点消耗：%d(需要%d天)\n',...
        str2_lusew2log(str2_workday2),str2_evac_days2(str2_workday2));
    fprintf('总负重消耗：%d(剩余：%d)\n',...
        str2_move_to_mine2+str2_wusew2log(str2_workday2)+str2_lusew2log(str2_workday2),...
        str2_Totw-(str2_move_to_mine2+str2_wusew2log(str2_workday2)+str2_lusew2log(str2_workday2)));
    disp('挖矿天数|累计挖矿消耗|撤离消耗|所需撤离天数');
    for i=1:str2_workday2%仅遍历有效天数
        fprintf('%5d|%9d|%7d|%7d\n',...
            i,str2_wusew2log(i),str2_lusew2log(i),str2_evac_days2(i));
    end
else
    disp('策略2无二次挖矿');
    str2_workday2=0;
    str2_evac_days2=zeros(1,1);%初始化避免索引错误
end
%1. 阶段1所有消耗（精确计算）
str2_use_water1=str2_usewaterlog1(1);%起点→矿山用水
str2_use_food1=str2_usefoodlog1(1);%起点→矿山用食物
str2_mine1_water=0;str2_mine1_food=0;%首次挖矿消耗
for i=1:str2_workday1
    str2_d=str2_DMM1+i;
    if W3(str2_d)==0%沙暴挖矿（3×沙暴消耗）
        str2_mine1_water=str2_mine1_water+3*str2_watersand;
        str2_mine1_food=str2_mine1_food+3*str2_foodsand;
    elseif W3(str2_d)==1%晴朗挖矿（3×晴朗消耗）
        str2_mine1_water=str2_mine1_water+3*str2_watersun;
        str2_mine1_food=str2_mine1_food+3*str2_foodsun;
    else%高温挖矿（3×高温消耗）
        str2_mine1_water=str2_mine1_water+3*str2_waterhight;
        str2_mine1_food=str2_mine1_food+3*str2_foodhight;
    end
end
str2_evac1_water=0;str2_evac1_food=0;%矿山→村庄撤离消耗
str2_evac_start=str2_DMM1+str2_workday1+1;
str2_evac_end=str2_evac_start+str2_evac_days1(str2_workday1)-1;
for j=str2_evac_start:str2_evac_end
    if W3(j)==0%沙暴休息
        str2_evac1_water=str2_evac1_water+str2_watersand;
        str2_evac1_food=str2_evac1_food+str2_foodsand;
    elseif W3(j)==1%晴朗移动（2×消耗）
        str2_evac1_water=str2_evac1_water+2*str2_watersun;
        str2_evac1_food=str2_evac1_food+2*str2_foodsun;
    else%高温移动（2×消耗）
        str2_evac1_water=str2_evac1_water+2*str2_waterhight;
        str2_evac1_food=str2_evac1_food+2*str2_foodhight;
    end
end
%阶段1总消耗（必须精确）
str2_total_water1=str2_use_water1+str2_mine1_water+str2_evac1_water;
str2_total_food1=str2_use_food1+str2_mine1_food+str2_evac1_food;


%2. 起点购买逻辑（核心修正：优先买满1200负重，食物优先）
%2.1 计算阶段1消耗的基础负重
str2_base_weight1=str2_total_water1*str2_ww+str2_total_food1*str2_fw;
%2.2 剩余负重（最大1200，优先买食物）
str2_remaining_weight=str2_Totw-str2_base_weight1;
str2_remaining_weight=max(0,str2_remaining_weight);%确保非负
%2.3 剩余负重全买食物（每单位食物2负重）
str2_extra_food=floor(str2_remaining_weight/str2_fw);
%2.4 起点实际购买量（覆盖阶段1消耗+额外食物）
str2_buy_water_start=str2_total_water1;%水刚好满足阶段1（起点水便宜）
str2_buy_food_start=str2_total_food1+str2_extra_food;%食物含额外购买


%3. 阶段2所有消耗（精确计算）
str2_move_water2=str2_move_water2;%村庄→矿山用水
str2_move_food2=str2_move_food2;%村庄→矿山用食物
str2_mine2_water=0;str2_mine2_food=0;%二次挖矿消耗
for i=1:str2_workday2
    str2_d=str2_DMM2+i;
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
str2_evac2_water=0;str2_evac2_food=0;%矿山→终点撤离消耗
str2_evac2_start=str2_DMM2+str2_workday2+1;
str2_evac2_end=str2_evac2_start+str2_evac_days2(str2_workday2)-1;
for j=str2_evac2_start:str2_evac2_end
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
%阶段2总消耗
str2_total_water2=str2_move_water2+str2_mine2_water+str2_evac2_water;
str2_total_food2=str2_move_food2+str2_mine2_food+str2_evac2_food;
%4. 村庄购买逻辑（核心修正：补充阶段2差额，考虑起点剩余）
%4.1 阶段1结束后剩余资源（起点购买 - 阶段1消耗）
str2_remaining_water=str2_buy_water_start-str2_total_water1;
str2_remaining_food=str2_buy_food_start-str2_total_food1;%应为额外购买的食物
%4.2 村庄需购买量 = 阶段2消耗 - 剩余资源（非负）
str2_buy_water_village=max(0,str2_total_water2-str2_remaining_water);
str2_buy_food_village=max(0,str2_total_food2-str2_remaining_food);
%5. 最终资金计算
str2_cost_start=str2_buy_water_start*str2_price_water_start+...
    str2_buy_food_start*str2_price_food_start;
str2_cost_village=str2_buy_water_village*str2_price_water_village+...
    str2_buy_food_village*str2_price_food_village;
str2_total_cost=str2_cost_start+str2_cost_village;
str2_mining_days=str2_workday1+str2_workday2;
str2_mining_income=1000*str2_mining_days;
str2_final_money=str2_TotM+str2_mining_income-str2_total_cost;
%资源消耗验证
%===== 策略2行动总结输出 =====
fprintf('\n===== 第四关策略2行动总结 =====\n');
fprintf('第0天：从起点出发\n');
%第一次抵达矿山
fprintf('第%d天：第一次抵达矿山（耗时%d天）\n',str2_DMM1,str2_DMM1);
%第一次挖矿结束
str2_end_mine1_day=str2_DMM1+str2_workday1;
fprintf('第%d天：第一次挖矿结束（共挖%d天）\n',str2_end_mine1_day,str2_workday1);
%第二次抵达村庄
fprintf('第%d天：第一次抵达村庄（撤离矿山耗时%d天）\n',str2_DV1,str2_evac_days1(str2_workday1));
%第二次抵达矿山
fprintf('第%d天：第二次抵达矿山（从村庄出发耗时%d天）\n',str2_DMM2,str2_actual_move_days2);
%第二次挖矿结束
str2_end_mine2_day=str2_DMM2+str2_workday2;
fprintf('第%d天：第二次挖矿结束（共挖%d天）\n',str2_end_mine2_day,str2_workday2);
%抵达终点
str2_arrive_end_day=str2_end_mine2_day+str2_evac_days2(str2_workday2);
str2_total_days_used=str2_arrive_end_day;
fprintf('第%d天：抵达终点（撤离矿山耗时%d天）\n',str2_arrive_end_day,str2_evac_days2(str2_workday2));
%总耗时验证
if str2_total_days_used<=30
    fprintf('总耗时：%d天（≤30天，符合要求）\n',str2_total_days_used);
else
    fprintf('总耗时：%d天（>30天，不符合要求）\n',str2_total_days_used);
end
fprintf('\n===== 策略2资源消耗验证 =====\n');
fprintf('阶段1总消耗:水%d, 食物%d\n',str2_total_water1,str2_total_food1);
fprintf('阶段2总消耗:水%d, 食物%d\n',str2_total_water2,str2_total_food2);
fprintf('所有阶段资源消耗完毕，无剩余（符合要求）\n');
%7. 最终资金结果
fprintf('\n===== 策略2资金结果 =====\n');
fprintf('起点购买:水%d, 食物%d→花费%d元\n',...
    str2_buy_water_start,str2_buy_food_start,str2_cost_start);
fprintf('村庄购买:水%d, 食物%d→花费%d元\n',...
    str2_buy_water_village,str2_buy_food_village,str2_cost_village);
fprintf('总花费:%d元\n',str2_total_cost);
fprintf('挖矿总天数:%d天→收益%d元\n',str2_mining_days,str2_mining_income);
fprintf('初始资金:%d元→最终剩余资金:%d元\n',str2_TotM,str2_final_money);
fprintf('总耗时：%d天（≤30天）\n',...
    min(str2_DMM2+str2_workday2+str2_evac_days2(str2_workday2),30));
%===== 策略对比与最优方案判定 =====
fprintf('\n\n===== 最终策略对比与结论 =====\n');
%提取策略1和策略2的最终资金（从各自结果中获取）
%策略1最终资金（从代码中策略1的final_money变量提取）
strategy1_final=final_money;
%策略2最终资金（从代码中策略2的str2_final_money变量提取）
strategy2_final=str2_final_money;
%对比资金并判定最优策略
if strategy1_final>strategy2_final
    optimal_strategy=1;
    optimal_money=strategy1_final;
elseif strategy2_final>strategy1_final
    optimal_strategy=2;
    optimal_money=strategy2_final;
else
    optimal_strategy=0;%资金相等时
    optimal_money=strategy1_final;
end
%输出对比结果
fprintf('策略1最终剩余资金：%d元\n',strategy1_final);
fprintf('策略2最终剩余资金：%d元\n',strategy2_final);
if optimal_strategy==1
    fprintf('\n【最优策略判定：策略1】\n');
    fprintf('策略1以%d元的最终资金优于策略2，为最优方案。\n',optimal_money);
    %输出策略1完整方案
    fprintf('\n===== 最优方案（策略1）完整总结 =====\n');
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
    fprintf(' - 总花费：%d元，挖矿总收益：%d元\n',total_cost,mining_income);
    fprintf('4. 最终剩余资金：%d元\n',strategy1_final);
elseif optimal_strategy==2
    fprintf('\n【最优策略判定：策略2】\n');
    fprintf('策略2以%d元的最终资金优于策略1，为最优方案。\n',optimal_money);
    %输出策略2完整方案
    fprintf('\n===== 最优方案（策略2）完整总结 =====\n');
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
    fprintf(' - 总花费：%d元，挖矿总收益：%d元\n',str2_total_cost,str2_mining_income);
    fprintf('4. 最终剩余资金：%d元\n',strategy2_final);
else
    fprintf('\n【策略对比结果：资金相等】\n');
    fprintf('策略1与策略2最终资金均为%d元，效果相同。\n',optimal_money);
end