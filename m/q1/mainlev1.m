clear
clc
TotM=10000;
Totw=1200;
water=0;
food=0;
ww=3;
fw=2;
%先计算休息消耗
buy=0;%资源来自于起点
%晴天
watersun=5;
foodsun=7;
restsunw=watersun*ww+foodsun*fw;%晴天休息消耗负重
if buy==0
    restsunm=watersun*5+foodsun*10;
else
    restsunm=2*(watersun*5+foodsun*10);
end%晴天休息资金花费
%高温
waterhight=8;
foodhight=6;
resthightw=waterhight*ww+foodhight*fw;%高温休息消耗负重
if buy==0
    resthightm=waterhight*5+foodhight*10;
else
    resthightm=2*(waterhight*5+foodhight*10);
end%高温休息资金花费
%沙暴
watersand=10;
foodsand=10;
restsandw=watersand*ww+foodsand*fw;%沙暴休息消耗负重
if buy==0
    restsandm=watersand*5+foodsand*10;
else
    restsandm=2*(watersand*5+foodsand*10);
end%沙暴休息资金花费
usew=[restsunw,resthightw,restsandw];
usem=[restsunm,resthightm,restsandm];
W=[0,1,2];%0沙暴1晴朗2高温
%下面编写输出内容
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
%拟定最优解，购买两次物品
%1-8天，到村庄补物资（行进6天休息2天，消耗98水98食物，负重减少98*5，资金减少98*15，剩余负重
%710，剩余资金8530）
%9—10天，到矿山（行进两天高温消耗144）
%11-16挖矿，17-19休息，20-21返回村庄
%补充三天水资源
%22-24抵达终点（休息3天挖矿6天行进3天）
%总结挖矿6天，3晴朗4高温，休息5天，行进13天
%前十天抵达矿山毋庸置疑
P=[0,0];%起点
V=[0,6];%村庄
MM=[0,8];%矿山
F=[3,0];%终点
% 天气序列（1-晴朗，2-高温，0-沙暴）
W=[...
    2, 2, 1, 0, 1, 2, 0, 1, 2, 2, ...
    0, 2, 1, 2, 2, 2, 0, 0, 2, 2, ...
    1, 1, 2, 1, 0, 2, 1, 1, 2, 2];%30天天气情况
TotM=10000;
Totw=1200;
PC=P;
water=0;
food=0;
DV1=0;
arrvt=0;%抵达村庄的次数
arrMMt=0;%抵达矿山的次数
usewaterlog=[];%
usefoodlog=[];
while PC(2)~=MM(2)
    for d=1:30
        if W(d)~=0
            v=1;%可以行动
            if W(d)~=2
                %晴朗情况
                wateruse=5;
                fooduse=7;
            else
                %高温情况
                wateruse=8;
                fooduse=6;
            end
        else
            %沙暴情况
            v=0;%不能移动
            wateruse=10;
            fooduse=10;
        end
        if v==1
            if PC(2)~=V(2)&&arrvt==0
                PC(2)=PC(2)+1;%没到村庄
            elseif PC(2)==V(2)&&arrvt==1
                PC(2)=PC(2)+1;%到村庄
            elseif PC(2)~=MM(2)&&arrMMt==0
                %没到矿山
                PC(2)=PC(2)+1;
            elseif PC(2)==MM(2)&&arrMMt==1
                %到矿山，这里强制挖矿，已知直达余额9410，纯观光余额6990
                %二者相差2420，纯观光花费16天且无需额外购买物资，从起点到矿山需要10天，从矿山到终点实际需要行进5天
                %故实际可挖矿时间不足15天，挖矿收益1000/天，消耗介于300-450之间，如果消耗的物资来自村庄，则在600-900之间
                %故可认为，尽可能的挖矿有利于提高收益。
                return
            end
            water=water-2*wateruse;
            food=food-2*fooduse;
        else
            water=water-wateruse;
            food=food-fooduse;
        end
        totc1=((-3)*water+(-2)*food);%总负重
        if PC(2)==V(2)&&Totw>((-3)*water+(-2)*food)&&arrvt==0
            DV1=d;
            arrvt=arrvt+1;
            disp(['第一次抵达村庄！,共花费天数:',num2str(DV1),'共花费水数'...
                ,num2str(-water),'共花费食物数', num2str(-food)])
            usewaterlog=[usewaterlog,-water];
            usefoodlog=[usefoodlog,-food];
            continue
        elseif PC(2)==MM(2)&&Totw>((-3)*water+(-2)*food)&&arrMMt==0
            DMM1=d;
            arrMMt=arrMMt+1;
            disp(['第一次抵达矿山！,共花费天数:',num2str(DMM1),'共花费水数'...
                ,num2str(-water),'共花费食物数', num2str(-food)])
            usewaterlog=[usewaterlog,-water];
            usefoodlog=[usefoodlog,-food];
            break
        end
    end
end
%食物比较贵重，故认为全局游戏的食物消耗在起点处购买
%计算第九天与第十天消耗，两天均为高温行进
usewater910=usewaterlog(2)-usewaterlog(1);
usefood910=usefoodlog(2)-usefoodlog(1);
w910=usewater910*3+usefood910*2;
%下计算最大可能负载量
totwamm=Totw-w910;
%同理，算出一天高温与一天晴朗移动与两天晴朗移动消耗负重量
dousunw=2*2*usew(1);
sunandhightw=2*(usew(1)+usew(2));
restCost=[];%构造休息资源负重消耗矩阵
for rd=1:30
    if W(rd)==0
        reastw=usew(3);

    elseif W(rd)==1
        reastw=usew(1);
    else
        reastw=usew(2);
    end
    restCost=[restCost,reastw];
end
%构造休息资源负重消耗矩阵weatherCost（根据天气变化）
%下面开始实际挖矿迭代计算
% 参数设置
workCost=3*restCost; % 挖矿时的资源消耗是休息的三倍
workward=1000; % 挖矿的固定收益
%下面开始迭代计算
Totworklog=[];
Totwlog=[];
mmusew=0;
mmwateruse=0;
mmfooduse=0;
maymmwateruse=[];
maymmfooduse=[];
mayliftm=[];
action=[];
for mmd=8:10%在矿山待的天数
    if W(mmd+11)==2&&W(mmd+12)==2
        %双高温天气离开，计算挖矿时拥有最大负重量
        totwamm=Totw-2*w910;
    elseif W(mmd+11)==2&&W(mmd+12)==1
        totwamm=Totw-w910-sunandhightw;
    elseif W(mmd+11)==1&&W(mmd+12)==1
        totwamm=Totw-w910-dousunw;
    end
    %已知晴朗，高温沙暴挖矿负重消耗为87,108,105，利润为430-715，400-700,100-550
    %故选择晴朗高温优先挖矿，沙暴优先休息
    %则mmd=8情况下，12-16挖矿，如有余力，11,17,18三天可则天继续挖
    %mmd=9情况下，12-16,19挖矿，如有余力，11,17,18三天可则天继续挖
    %mmd=10情况下，12-16,19-20挖矿，其余休息，下依次计算合理性与实际收益
    %先计算12-16挖矿，19挖矿，20挖矿的消耗负重
    workw1216=sum(workCost(12:16));
    work19=workCost(19);
    work20=workCost(20);
    %计算三天沙暴消耗
    sand12=(3+2)*usew(3);%挖一天休两天
    sand21=(6+1)*usew(3);%挖二天休一天
    sand3=9*usew(3);%挖三天
    restsand3=3*usew(3);%休三天
    if mmd==8

        liftw8=totwamm-workw1216;
        worklog8=[0,1,1,1,1,1,0,0];
        if liftw8>=restsand3&&liftw8<sand12
            %沙暴休三天,工作表不变
        elseif liftw8>=sand12&&liftw8<sand21
            %沙暴挖一休二
            worklog8(1)=1;
        elseif liftw8>=sand21&&liftw8<sand3
            %沙暴挖二休一
            worklog8(1)=1;
            worklog8(7)=1;
        else
            %沙暴挖三天
            worklog8=ones(size(worklog8));
        end
        mmwateruse8=mmwateruse;
        mmfooduse8=mmfooduse;
        mmusew8=mmusew;
        for mmdm=1:8
            if worklog8(mmdm)==0
                mmusew8=mmusew8+restCost(mmdm+10);
                if W(mmdm+10)==0
                    mmwateruse8=mmwateruse8+10;
                    mmfooduse8=mmfooduse8+10;
                elseif W(mmdm+10)==1
                    mmwateruse8=mmwateruse8+5;
                    mmfooduse8=mmfooduse8+7;
                else
                    mmwateruse8=mmwateruse8+8;
                    mmfooduse8=mmfooduse8+6;
                end
            elseif worklog8(mmdm)==1
                mmusew8=mmusew8+workCost(mmdm+10);
                if W(mmdm+10)==0
                    mmwateruse8=mmwateruse8+30;
                    mmfooduse8=mmfooduse8+30;
                elseif W(mmdm+10)==1
                    mmwateruse8=mmwateruse8+15;
                    mmfooduse8=mmfooduse8+21;
                else
                    mmwateruse8=mmwateruse8+24;
                    mmfooduse8=mmfooduse8+18;
                end
            end%实际消耗负重mmusew
        end
        %挖矿行为的多余负重自动转化为在起点购入的食物
        leftfood8=floor((Totw-mmwateruse8*3-mmfooduse8*2-w910*2)/fw);
        %如果还有剩余，应该转化为水
        leftwater8=floor((Totw-mmwateruse8*3-mmfooduse8*2-w910*2-fw*leftfood8)/ww);
        maymmwateruse=[maymmwateruse,mmwateruse8];%记录挖矿水消耗量
        maymmfooduse=[maymmfooduse,mmfooduse8];%记录挖矿食物消耗量
        %下计算返程消耗移动晴天*2高温*1在村庄购买的食物数量
        buywater82=0;
        buyfood82=0;
        if leftfood8<(2*(2*7+6))
            buyfood82=2*(2*7+6)-leftfood8;
            %如进入该判断，即buyfood不为0，此挖矿行为需要购买食物或者调整策略。如果少挖矿一天，则认为是沙暴天气下少挖一天，相比原策略多出20单位的水和食物，即150负重
            % 收益减少1000，补足缺少食物26，还有150-26*2=98负重，可以买32单位的水，少花160元，是赔本卖买。
            %故选择不调整挖矿策略，购买食物
        end%加入是否需要购买食物或者调整策略的判断
        totfooduse8=usefoodlog(2)+mmfooduse8+2*2*6+2*(2*7+6);
        totwateruse8=usewaterlog(2)+mmwateruse8+2*2*8+2*(2*5+8);
        beginfood8=totfooduse8-buyfood82;
        beginwater8=floor((Totw-beginfood8*2)/ww);
        buywater81=usewaterlog(2)+mmwateruse8+2*2*8-beginwater8;
        buywater82=totwateruse8-beginwater8-buywater81;
        ward8=sum(worklog8)*workward;
        liftm8=TotM-(totfooduse8-buyfood82)*10-buyfood82*20-...
            (totwateruse8-buywater82-buywater81)*5-(buywater82+buywater81)*10+ward8;
        mayliftm=[mayliftm,liftm8];%记录剩余资金
        disp(['在矿山停留天数为', num2str(mmd), ' 时，总水消耗: ', num2str(totwateruse8)]);
        disp([' 总食物消耗: ', num2str(totfooduse8),' 剩余资金: ', num2str(liftm8)]);

    elseif mmd==9
        liftw9=totwamm-workw1216-work19;
        worklog9=[0,1,1,1,1,1,0,0,1];
        if liftw9>=restsand3&&liftw9<sand12
            %沙暴休三天,工作表不变
        elseif liftw9>=sand12&&liftw9<sand21
            %沙暴挖一休二
            worklog9(1)=1;
        elseif liftw9>=sand21&&liftw9<sand3
            %沙暴挖二休一
            worklog9(1)=1;
            worklog9(7)=1;
        elseif liftw9>sand3
            %沙暴挖三天
            worklog9=ones(size(worklog9));
        else
            disp('此情况不成立，需要削减挖矿天数')
            continue
        end
        mmwateruse9=mmwateruse;
        mmfooduse9=mmfooduse;
        mmusew9=mmusew;
        for mmdm=1:9

            if worklog9(mmdm)==0
                mmusew9=mmusew9+restCost(mmdm+10);
                if W(mmdm+10)==0
                    mmwateruse9=mmwateruse9+10;
                    mmfooduse9=mmfooduse9+10;
                elseif W(mmdm+10)==1
                    mmwateruse9=mmwateruse9+5;
                    mmfooduse9=mmfooduse9+7;
                else
                    mmwateruse9=mmwateruse9+8;
                    mmfooduse9=mmfooduse9+6;
                end
            else
                mmusew9=mmusew9+workCost(mmdm+10);
                if W(mmdm+10)==0
                    mmwateruse9=mmwateruse9+30;
                    mmfooduse9=mmfooduse9+30;
                elseif W(mmdm+10)==1
                    mmwateruse9=mmwateruse9+15;
                    mmfooduse9=mmfooduse9+21;
                else
                    mmwateruse9=mmwateruse9+24;
                    mmfooduse9=mmfooduse9+18;
                end
            end%实际消耗负重mmusew
        end
        %挖矿行为的多余负重自动转化为在起点购入的食物
        leftfood9=floor((Totw-mmwateruse9*3-mmfooduse9*2-w910-sunandhightw)/fw);
        %如果还有剩余，应该转化为水
        leftwater9=floor((Totw-mmwateruse9*3-mmfooduse9*2-w910-sunandhightw-fw*leftfood9)/ww);
        maymmwateruse=[maymmwateruse,mmwateruse9];%记录挖矿水消耗量
        maymmfooduse=[maymmfooduse,mmfooduse9];%记录挖矿食物消耗量
        %下计算返程消耗移动晴天*2高温*1在村庄购买食物数量
        buyfood92=0;
        if leftfood9<(2*(2*7+6))
            buyfood92=2*(2*7+6)-leftfood9;
            %如进入该判断，即buyfood不为0，此挖矿行为需要购买食物或者调整策略。如果少挖矿一天，则认为是沙暴天气下少挖一天，相比原策略多出20单位的水和食物，即150负重
            % 收益减少1000，补足缺少食物16，还有150-16*2=118负重，可以买42单位的水，少花16*20+42*10=740元，是赔本卖买。
            %故选择不调整挖矿策略，购买食物
        end%加入是否需要购买食物或者调整策略的判断
        totfooduse9=usefoodlog(2)+mmfooduse9+2*7+2*6+2*(2*7+6);
        totwateruse9=usewaterlog(2)+mmwateruse9+2*5+2*8+2*(2*5+8);
        beginfood9=totfooduse9-buyfood92;
        beginwater9=floor((Totw-beginfood9*2)/ww);
        buywater91=usewaterlog(2)+mmwateruse9+2*5+2*8-floor((Totw-beginfood9*2)/ww);
        buywater92=totwateruse9-beginwater9-buywater91;
        ward9=sum(worklog9)*workward;
        liftm9=TotM-(totfooduse9-buyfood92)*10-buyfood92*20-...
            (totwateruse9-buywater92-buywater91)*5-(buywater92+buywater91)*10+ward9;
        mayliftm=[mayliftm,liftm9];%记录剩余资金
        disp(['在矿山停留天数为', num2str(mmd), ' 时，总水消耗: ', num2str(totwateruse9)]);
        disp([' 总食物消耗: ', num2str(totfooduse9),' 剩余资金: ', num2str(liftm9)]);
    elseif mmd==10
        liftw10=totwamm-workw1216-work19-work20;
        worklog10=[0,1,1,1,1,1,0,0,1,1];
        if liftw10>=restsand3&&liftw10<sand12
            %沙暴休三天,工作表不变
        elseif liftw10>=sand12&&liftw10<sand21
            %沙暴挖一休二
            worklog10(1)=1;
        elseif liftw10>=sand21&&liftw10<sand3
            %沙暴挖二休一
            worklog10(1)=1;
            worklog10(7)=1;
        elseif liftw10>sand3
            %沙暴挖三天
            worklog10=ones(size(worklog10));
        else
            disp('此情况不成立，需要削减挖矿天数')
            continue
        end
        mmwateruse10=mmwateruse;
        mmfooduse10=mmfooduse;
        mmusew10=mmusew;
        for mmdm=1:10
            if worklog10(mmdm)==0
                mmusew10=mmusew10+restCost(mmdm+10);
                if W(mmdm+10)==0
                    mmwateruse10=mmwateruse10+10;
                    mmfooduse10=mmfooduse10+10;
                elseif W(mmdm+10)==1
                    mmwateruse10=mmwateruse10+5;
                    mmfooduse10=mmfooduse10+7;
                else
                    mmwateruse10=mmwateruse10+8;
                    mmfooduse10=mmfooduse10+6;
                end
            else
                mmusew10=mmusew10+workCost(mmdm+10);
                if W(mmdm+10)==0
                    mmwateruse10=mmwateruse10+30;
                    mmfooduse10=mmfooduse10+30;
                elseif W(mmdm+10)==1
                    mmwateruse10=mmwateruse10+15;
                    mmfooduse10=mmfooduse10+21;
                else
                    mmwateruse10=mmwateruse10+24;
                    mmfooduse10=mmfooduse10+18;
                end
            end%实际消耗负重mmusew
        end
        %挖矿行为的多余负重自动转化为在起点购入的食物
        leftfood10=floor((Totw-mmwateruse10*3-mmfooduse10*2-w910-dousunw)/fw);
        %如果还有剩余，应该转化为水
        leftwater9=floor((Totw-mmwateruse10*3-mmfooduse10*2-w910-dousunw-fw*leftfood10)/ww);
        maymmwateruse=[maymmwateruse,mmwateruse10];%记录挖矿水消耗量
        maymmfooduse=[maymmfooduse,mmfooduse10];%记录挖矿食物消耗量
        %下计算返程消耗移动晴天*2高温*1沙暴休息*1在村庄购买的食物数量
        buyfood102=0;
        if leftfood10<2*(2*8+5)+10
            buyfood102=2*(2*8+5)+10-leftfood10;
            %如进入该判断，即buyfood不为0，此挖矿行为需要购买食物或者调整策略。如果少挖矿一天，则认为是沙暴天气下少挖一天，相比原策略多出20单位的水和食物，即150负重
            % 收益减少1000，同理，是赔本卖买。
            %故选择不调整挖矿策略，购买食物
        end%加入是否需要购买食物或者调整策略的判断
        totfooduse10=usefoodlog(2)+mmfooduse10+2*2*7+2*(2*6+7)+10;
        totwateruse10=usewaterlog(2)+mmwateruse10+2*2*5+2*(2*8+5)+10;
        beginfood10=totfooduse10-buyfood102;
        beginwater10=floor((Totw-beginfood10*2)/ww);
        buywater101=usewaterlog(2)+mmwateruse10+2*2*5-beginwater10;
        buywater102=totwateruse10-beginwater10-buywater101;
        ward10=sum(worklog10)*workward;
        liftm10=TotM-(totfooduse10-buyfood102)*10-buyfood102*20-...
            (totwateruse10-buywater102-buywater101)*5-(buywater102+buywater101)*10+ward10;
        mayliftm=[mayliftm,liftm10];%记录剩余资金
        action=[worklog8,2,2;worklog9,2;worklog10];%记录工作情况,2代表已经离开矿山
        disp(['在矿山停留天数为', num2str(mmd), ' 时，总水消耗: ', num2str(totwateruse10)]);
        disp([' 总食物消耗: ', num2str(totfooduse10),' 剩余资金: ', num2str(liftm10)]);
    end
end
%接下来比较最优剩余资金输出停留矿山的天数与最优解
[max_money, best_index] = max(mayliftm);
if best_index == 1
    disp('最优解为在矿山停留8天');
    disp(['实际游玩天数为23天，最终资金为', num2str(max_money)]);
elseif best_index == 2
    disp('最优解为在矿山停留9天');
    disp(['实际游玩天数为24天，最终资金为', num2str(max_money)]);
else
    disp('最优解为在矿山停留10天');
    disp(['实际游玩天数为25天，最终资金为', num2str(max_money)]);
end
%最后编写文件输出内容
%观察上述输出结果，停留9天有最优解
%提取worklog9是矿山工作记录，beginwater9是开局购买水量，beginfood9是开局购买食物量
%故第0天剩余资金：
beginm=TotM-beginwater9*5-beginfood9*10;
%第八天补充物资一次，第21天补充物资一次，资金减少
%从第11天开始挖矿,资金增加，创建矩阵记录钱数。
mdata=[];
mdata=ones(1,8).*beginm;%0-7
abuym1=beginm-buywater91*10;
mdata=[mdata,ones(1,3).*abuym1];%0-10
%记录挖矿资金增长
mmm=abuym1;
for dmm=1:9
    if worklog9(dmm)==1
        mmm=mmm+1000;
        mdata=[mdata,mmm];
    else
        mmm=mmm;
        mdata=[mdata,mmm];
    end
end
%0-19资金记录完毕
mdata=[mdata,mmm];%0-20
%第二次补充物资资金变动
abuym2=mmm-buywater92*10-buyfood92*20;
mdata=[mdata,ones(1,4).*abuym2]';%以列的形式记录的0-24的25个当天资金数据
%接下来反编译记录区域，起点-村庄：[1,25,24,23,22,9,15]
%村庄-矿山[15,14,12],矿山-村庄[12,14,15],村庄-终点[15,9,22,27]
%已知起点-村庄花费8天，村庄-矿山花费2天回来同理，呆在矿山9天，村庄-终点3天
plog1=[1,25,24,23,22,9,15];
for d1=1:7
    if W(d1)==0
        py=plog1(d1);
        plog1=[plog1(1:d1),py,plog1(d1+1:end)];
    end
end%0-8天位置记录
plog2=[14,12];%9-10
plog3=ones(1,9).*12;%11-19
plog4=[14,15];%20-21
plog5=[9,22,27];%22-24
plog=[plog1,plog2,plog3,plog4,plog5]';%一列记录0-24天位置情况
%最后编译水和食物的记录
waterlog=[beginwater9];
foodlog=[beginfood9];
act=[];%行动策略:0休息，1移动，2挖矿
%已知，1-10，20-24都在尽可能的行动,11-19的行动策略与worklog9相关
for i=1:10
    if W(i)==0
        act=[act,0];
    else
        act=[act,1];
    end
end
for j=1:9
    if worklog9(j)==1
        act=[act,2];
    else
        act=[act,0];
    end
end
for k=20:24
    if W(k)==0
        act=[act,0];
    else
        act=[act,1];
    end
end
%已知起点购买水和食物量,可根据天气矩阵W和行动策略矩阵act以时间为基础反编译水和食物情况
wlog=beginwater9;
flog=beginfood9;
for dl=1:24
    %首先编写资源补充判断
    if dl==8
        wlog=wlog+buywater91;
    end
    if dl==21
        wlog=wlog+buywater92;
        flog=flog+buyfood92;
    end
    %其次编写资源消耗记录矩阵
    if W(dl)==0
        if act(dl)==0
            wlog=wlog-10;
            flog=flog-10;
            waterlog=[waterlog,wlog];
            foodlog=[foodlog,flog];
        elseif act(dl)==2
            wlog=wlog-30;
            flog=flog-30;
            waterlog=[waterlog,wlog];
            foodlog=[foodlog,flog];
        end
    elseif W(dl)==1
        if act(dl)==0
            wlog=wlog-5;
            flog=flog-7;
            waterlog=[waterlog,wlog];
            foodlog=[foodlog,flog];
        elseif act(dl)==1
            wlog=wlog-10;
            flog=flog-14;
            waterlog=[waterlog,wlog];
            foodlog=[foodlog,flog];
        elseif act(dl)==2
            wlog=wlog-15;
            flog=flog-21;
            waterlog=[waterlog,wlog];
            foodlog=[foodlog,flog];
        end
    elseif W(dl)==2
        if act(dl)==0
            wlog=wlog-8;
            flog=flog-6;
            waterlog=[waterlog,wlog];
            foodlog=[foodlog,flog];
        elseif act(dl)==1
            wlog=wlog-16;
            flog=flog-12;
            waterlog=[waterlog,wlog];
            foodlog=[foodlog,flog];
        elseif act(dl)==2
            wlog=wlog-24;
            flog=flog-18;
            waterlog=[waterlog,wlog];
            foodlog=[foodlog,flog];
        end
    end
end
waterlog=waterlog';
foodlog=foodlog';
%至此，整理好所需输出的四列25行数据，分别是plog,mdata,waterlog,foodlog
%它们分别对应:所在区域	剩余资金数	剩余水量	剩余食物量
%打开现有的Excel文件
filename='Result.xlsx';
[~,~,raw]=xlsread(filename,'Sheet1');%读取第一张工作表
% 准备要写入的数据（25行×4列）
output_data=[plog,mdata,waterlog,foodlog];
% 确定写入位置（第一关的数据从B4开始）
start_row=4;%从第4行开始（对应日期0）
start_col=2;%从C列开始（第一关数据）
% 更新数据到raw单元格数组
for i=1:25
    for j=1:4
        raw{start_row+i-1,start_col+j-1}=output_data(i,j);
    end
end
% 写入更新后的数据
xlswrite(filename,raw,'Sheet1');
% 输出完成提示
disp('数据已成功更新到Result.xlsx文件中');