%由第一关已知内容进行第二关的编写
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
%拟定最优解，购买3次水，一次食物
%前十天抵达村庄，第13天到达矿山
%在村庄1购买一次水，在村庄2，第一次购买水，第二次购买水和食物
%初步根据天气情况推断，两次挖矿天数可能是4/5/6+7，4/5+8，4+9，它们的和为11-13
%实际天气情况舍弃4+9这种情况，它将会导致第31天才能到达终点
%根据这种思想去判断5+8只需要判断在满负重情况下，能否支持高温行进三天，晴朗挖5天，高温挖两天，沙暴挖一天
%3*72+5*87+2*108+150=1017，故是可行的。又已知挖矿天数越多收益越高，故舍去4+7的情况。6+7的情况与5+8类似，故保留
%故实际上需要考虑的情况是5/6+7，4/5+8这四种情况，但根据贪心原则，可以舍去5+7与4+8的情况
%本题实际上考虑6+7还是5+8哪个更优，不管是67还是58，这边优先写出抵达矿山的情况
P=[0,0];%起点
V1=[8,0];%村庄1
MM=[10,0];%矿山
V2=[11,0];%村庄2
F=[10.5,sqrt(3.75)];%终点
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
usewaterlog=[];
usefoodlog=[];
while PC(1)~=MM(1)
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
            if PC(1)~=V1(1)&&arrvt==0
                PC(1)=PC(1)+1;%没到村庄1
            elseif PC(1)==V1(1)&&arrvt==1
                PC(1)=PC(1)+1;%到村庄1
            elseif PC(1)~=MM(1)&&arrMMt==0
                %没到矿山
                PC(1)=PC(1)+1;
            elseif PC(2)==MM(2)&&arrMMt==1
                %到矿山，这里强制挖矿。
                return
            end
            water=water-2*wateruse;
            food=food-2*fooduse;
        else
            water=water-wateruse;
            food=food-fooduse;
        end
        totc1=((-3)*water+(-2)*food);%总负重
        if PC(1)==V1(1)&&Totw>((-3)*water+(-2)*food)&&arrvt==0
            DV1=d;
            arrvt=arrvt+1;
            disp(['抵达村庄1！共花费天数:',num2str(DV1),'共花费水数'...
                ,num2str(-water),'共花费食物数', num2str(-food)])
            usewaterlog=[usewaterlog,-water];
            usefoodlog=[usefoodlog,-food];
            continue
        elseif PC(1)==MM(1)&&Totw>((-3)*water+(-2)*food)&&arrMMt==0
            DMM1=d;
            arrMMt=arrMMt+1;
            disp(['抵达矿山！共花费天数:',num2str(DMM1),'共花费水数'...
                ,num2str(-water),'共花费食物数', num2str(-food)])
            usewaterlog=[usewaterlog,-water];
            usefoodlog=[usefoodlog,-food];
            break
        end
    end
end
%食物比较贵重，故认为全局游戏的大部分食物消耗在起点处购买
%上述内容输出结果：
%抵达村庄1！,共花费天数:10共花费水数130共花费食物数122，故可知开局买了130单位的水和（1200-3*130）/2=405单位的食物，到村庄还剩283，先买10单位水，沙暴休息一天是273
%抵达矿山！,共花费天数:13共花费水数166共花费食物数158，%由于村庄1不买食物，故目前还有247单位的食物，
% 最多购（1200-2*273）/3=218水，带到矿山最多剩余192的水和247单位的食物
%沙暴留在村庄休息消耗10的水，故可以认为是两天消耗水26，消耗食物26，即130负重，在第一次挖矿在最多负重为1070，为192的水和247的食物
%计算第九天与第十天消耗，两天均为高温行进
%计算第12天与第13天消耗，两天为高温+晴朗行进
usewater1213=usewaterlog(2)-usewaterlog(1)-10;
usefood1213=usefoodlog(2)-usefoodlog(1)-10;
w1213=usewater1213*3+usefood1213*2;
%下计算最大可能负载量结果应该是1070
totwamm1=Totw-w1213;
%同理，算出一天高温移动，一天晴朗移动消耗负重量
sunw=2*usew(1);
hightw=2*(usew(2));
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
for mmd=5:6%第一次在矿山待的天数，不管呆5天还是呆6天都是以高温天气离开，不过5天是高温回来，6天是晴朗回来
    totwamm1=Totw-w1213-hightw;%第一次挖矿的最大负重
    if W(mmd+15)==2
        %高温天气回矿山，计算第二次挖矿时拥有的合理负重量
        %连挖八天，两天高温到达终点，即支持高温行进三天，晴朗挖5天，高温挖两天，沙暴挖一天的第二次在村庄2购买量
        totwamm2=Totw-3*hightw;
    elseif W(mmd+15)==1
        %晴朗天气回矿山，计算第二次挖矿时拥有的合理最大负重量
        %练挖7天，其中4天晴天，2天高温，1天沙暴，然后两天高温回去，共计购买量为前述内容+一天晴朗移动
        totwamm2=Totw-sunw-2*hightw;
    end
    %已知晴朗，高温沙暴挖矿负重消耗为87,108,105，利润为430-715，400-700,100-550
    %故选择晴朗高温优先挖矿，沙暴优先休息
    %第一次挖矿天数较短，故忽略天气，实打实挖矿
    %则mmd=5情况下，挖5天
    %mmd=6情况下，挖6天
    %下编写合理性检验
    if mmd==5
        worklog15=ones(1,mmd);
        mmwateruse15=mmwateruse;
        mmfooduse15=mmfooduse;
        mmusew15=mmusew;
        for mmdm=1:5
            mmusew15=mmusew15+workCost(mmdm+13);
            if W(mmdm+10)==0
                mmwateruse15=mmwateruse15+30;
                mmfooduse15=mmfooduse15+30;
            elseif W(mmdm+10)==1
                mmwateruse15=mmwateruse15+15;
                mmfooduse15=mmfooduse15+21;
            else
                mmwateruse15=mmwateruse15+24;
                mmfooduse15=mmfooduse15+18;
            end
        end
        %计算上述行为的合理性
        if totwamm1>=(mmwateruse15*3+mmfooduse15*2)
            disp('挖矿5天的行为合理，足够挖完到达村庄2')
            %计算第二次挖矿的消耗与合理性
            mmd2=8;
            worklog28=ones(1,mmd2);
            mmwateruse28=mmwateruse;
            mmfooduse28=mmfooduse;
            mmusew28=mmusew;
            for mmdm=1:8
                mmusew28=mmusew28+workCost(mmdm+20);
                if W(mmdm+10)==0
                    mmwateruse28=mmwateruse28+30;
                    mmfooduse28=mmfooduse28+30;
                elseif W(mmdm+10)==1
                    mmwateruse28=mmwateruse28+15;
                    mmfooduse28=mmfooduse28+21;
                else
                    mmwateruse28=mmwateruse28+24;
                    mmfooduse28=mmfooduse28+18;
                end
            end
            if totwamm2>=(mmwateruse28*3+mmfooduse28*2)
                disp('挖矿5天后又挖8天的行为合理，足够挖完到达终点')
                %根据上述情况反推资金剩余，首先计算全部水和食物的消耗量，消耗量减去起点购买量等于村庄总购买量
                %资金剩余=初始资金-起点购买花费资金-村庄购买花费资金+挖矿收益
                %首先编写行动逻辑矩阵
                act58=[];%0休息，1移动，2挖矿
                %已知，1-13，19-20,29-30都在尽可能的行动,14-18的行动策略与worklog15相关
                %21-28的行动策略与worklog28相关
                for i=1:13
                    if W(i)==0
                        act58=[act58,0];
                    else
                        act58=[act58,1];
                    end
                end
                for j=1:5
                    if worklog15(j)==1
                        act58=[act58,2];
                    else
                        act58=[act58,0];
                    end
                end
                for k=19:20
                    if W(k)==0
                        act58=[act58,0];
                    else
                        act58=[act58,1];
                    end
                end
                for o=1:8
                    if worklog28(o)==1
                        act58=[act58,2];
                    else
                        act58=[act58,0];
                    end
                end
                for q=29:30
                    if W(q)==0
                        act58=[act58,0];
                    else
                        act58=[act58,1];
                    end
                end
                %根据行动矩阵计算实际食物和水的消耗量
                wlog=0;
                flog=0;
                for dl=1:30
                    if W(dl)==0
                        if act58(dl)==0
                            wlog=wlog-10;
                            flog=flog-10;
                        elseif act58(dl)==2
                            wlog=wlog-30;
                            flog=flog-30;
                        end
                    elseif W(dl)==1
                        if act58(dl)==0
                            wlog=wlog-5;
                            flog=flog-7;
                        elseif act58(dl)==1
                            wlog=wlog-10;
                            flog=flog-14;
                        elseif act58(dl)==2
                            wlog=wlog-15;
                            flog=flog-21;
                        end
                    elseif W(dl)==2
                        if act58(dl)==0
                            wlog=wlog-8;
                            flog=flog-6;
                        elseif act58(dl)==1
                            wlog=wlog-16;
                            flog=flog-12;
                        elseif act58(dl)==2
                            wlog=wlog-24;
                            flog=flog-18;
                        end
                    end
                end
                flog58=-flog;
                wlog58=-wlog;
                totbuywater58=wlog58-usewaterlog(1);
                beginwater58=usewaterlog(1);
                beginfood58=floor((Totw-usewaterlog(1)*3)/2);
                totbuyfood58=flog58-beginfood58;
                liftm58=TotM+(5+8)*workward-beginwater58*5-beginfood58*10-totbuywater58*10-totbuyfood58*20;
                disp(['最后剩余的资金为：',num2str(liftm58)])
                mayliftm=[mayliftm,liftm58];
            else
                disp('挖矿5天后又挖8天的行为不合理，不够挖完到达终点')
                break
            end
        end
    else
        %编写挖矿6+7的情况
        worklog16=ones(1,mmd);
        mmwateruse16=mmwateruse;
        mmfooduse16=mmfooduse;
        mmusew16=mmusew;
        for mmdm=1:6
            mmusew16=mmusew16+workCost(mmdm+13);
            if W(mmdm+10)==0
                mmwateruse16=mmwateruse16+30;
                mmfooduse16=mmfooduse16+30;
            elseif W(mmdm+10)==1
                mmwateruse16=mmwateruse16+15;
                mmfooduse16=mmfooduse16+21;
            else
                mmwateruse16=mmwateruse16+24;
                mmfooduse16=mmfooduse16+18;
            end
        end
        %计算上述行为的合理性
        if totwamm2>=(mmwateruse16*3+mmfooduse16*2)
            disp('挖矿6天的行为合理，足够挖完到达村庄2')
            %计算第二次挖矿的消耗与合理性
            mmd2=7;
            worklog27=ones(1,mmd2);
            mmwateruse27=mmwateruse;
            mmfooduse27=mmfooduse;
            mmusew27=mmusew;
            for mmdm=1:7
                mmusew27=mmusew27+workCost(mmdm+21);
                if W(mmdm+10)==0
                    mmwateruse27=mmwateruse27+30;
                    mmfooduse27=mmfooduse27+30;
                elseif W(mmdm+10)==1
                    mmwateruse27=mmwateruse27+15;
                    mmfooduse27=mmfooduse27+21;
                else
                    mmwateruse27=mmwateruse27+24;
                    mmfooduse27=mmfooduse27+18;
                end
            end
            if totwamm2>=(mmwateruse27*3+mmfooduse27*2)
                disp('挖矿6天后又挖7天的行为合理，足够挖完到达终点')
                %根据上述情况反推资金剩余，首先计算全部水和食物的消耗量，消耗量减去起点购买量等于村庄总购买量
                %资金剩余=初始资金-起点购买花费资金-村庄购买花费资金+挖矿收益
                %首先编写行动逻辑矩阵
                act67=[];%0休息，1移动，2挖矿
                %已知，1-13，20-21,29-30都在尽可能的行动,14-19的行动策略与worklog16相关
                %22-28的行动策略与worklog27相关
                for i=1:13
                    if W(i)==0
                        act67=[act67,0];
                    else
                        act67=[act67,1];
                    end
                end
                for j=1:6
                    if worklog16(j)==1
                        act67=[act67,2];
                    else
                        act67=[act67,0];
                    end
                end
                for k=20:21
                    if W(k)==0
                        act67=[act67,0];
                    else
                        act67=[act67,1];
                    end
                end
                for o=1:7
                    if worklog27(o)==1
                        act67=[act67,2];
                    else
                        act67=[act67,0];
                    end
                end
                for q=29:30
                    if W(q)==0
                        act67=[act67,0];
                    else
                        act67=[act67,1];
                    end
                end
                %根据行动矩阵计算实际食物和水的消耗量
                wlog=0;
                flog=0;
                for dl=1:30
                    if W(dl)==0
                        if act67(dl)==0
                            wlog=wlog-10;
                            flog=flog-10;
                        elseif act67(dl)==2
                            wlog=wlog-30;
                            flog=flog-30;
                        end
                    elseif W(dl)==1
                        if act67(dl)==0
                            wlog=wlog-5;
                            flog=flog-7;
                        elseif act67(dl)==1
                            wlog=wlog-10;
                            flog=flog-14;
                        elseif act67(dl)==2
                            wlog=wlog-15;
                            flog=flog-21;
                        end
                    elseif W(dl)==2
                        if act67(dl)==0
                            wlog=wlog-8;
                            flog=flog-6;
                        elseif act67(dl)==1
                            wlog=wlog-16;
                            flog=flog-12;
                        elseif act67(dl)==2
                            wlog=wlog-24;
                            flog=flog-18;
                        end
                    end
                end
                flog67=-flog;
                wlog67=-wlog;
                totbuywater67=wlog67-usewaterlog(1);
                beginwater67=usewaterlog(1);
                beginfood67=floor((Totw-usewaterlog(1)*3)/2);
                totbuyfood67=flog67-beginfood67;
                liftm67=TotM+(6+7)*workward-beginwater67*5-beginfood67*10-totbuywater67*10-totbuyfood67*20;
                disp(['最后剩余的资金为：',num2str(liftm67)])
                mayliftm=[mayliftm,liftm67];
            else
                disp('挖矿6天后又挖7天的行为不合理，不够挖完到达终点')
                break
            end
        end
    end
end
%接下来比较输出结果输出最优解，反推结果，打印到文件
[max_money,best_index]=max(mayliftm);
if best_index == 1
    disp('最优解为第一次在矿山挖矿5天，第二次在矿山挖矿8天');
    disp(['实际游玩天数为30天，最终资金为', num2str(max_money)]);
else
    disp('最优解为第一次在矿山挖矿6天，第二次在矿山挖矿7天');
    disp(['实际游玩天数为30天，最终资金为', num2str(max_money)]);
end
%最后编写文件输出内容
%在此之前，要计算两次补充物资，即第一次购买水量buywater15
%与第二次购买的水量buywater28。食物量购买量buyfood28=flog58-beginfood58
%由上述已知输出结果得到的分析内容：
%抵达村庄1！,共花费天数:10共花费水数130共花费食物数122，故可知开局买了130单位的水和（1200-3*130）/2=405单位的食物，到村庄还剩283，先买10单位水，沙暴休息一天是273
%抵达矿山！,共花费天数:13共花费水数166共花费食物数158，%由于村庄1不买食物，故目前还有247单位的食物，
% 最多购（1200-2*273）/3=218水，带到矿山最多剩余192的水和247单位的食物
%沙暴留在村庄休息消耗10的水，故可以认为是两天消耗水26，消耗食物26，即130负重，在第一次挖矿在最多负重为1070，为192的水和247的食物
%可以假设第一次尽可能的买水，当然，第一次买水分了两次，即第十天买10单位的水
% 第11天买192+26=218单位的水，第二次买水则是总消耗水wlog58-beginwater58-buywater15(218)
buywater10=10;
buywater15=192+26;
buywater28=wlog58-beginwater58-buywater15-buywater10;
buyfood28=flog58-beginfood58;
%提取worklog15与worklog28是矿山工作记录，beginwater58是开局购买水量，beginfood58是开局购买食物量
%故第0天剩余资金：
beginm=TotM-beginwater58*5-beginfood58*10;
%第10天补充物资一次，第11天补充物资一次，第19天补充物资一次，资金减少
%从第14-18,21-28天开始挖矿,资金增加，创建矩阵记录钱数。
mdata=[];
mdata=ones(1,10).*beginm;%0-9
abuym1=beginm-buywater10*10;
mdata=[mdata,abuym1];%0-10
abuym3=abuym1-buywater15*10;
mdata=[mdata,ones(1,3).*abuym3];%11-13
%记录第一次挖矿资金增长
mmm1=abuym3;
for dmm=1:5
    if worklog15(dmm)==1
        mmm1=mmm1+1000;
        mdata=[mdata,mmm1];
    else
        mmm1=mmm1;
        mdata=[mdata,mmm1];
    end
end
%0-18资金记录完毕
%19号第二次补充物资资金变动
abuym2=mmm1-buywater28*10-buyfood28*20;
mdata=[mdata,ones(1,2).*abuym2];%19-10
%记录第二次挖矿资金增长
mmm2=abuym2;
for dmm=1:8
    if worklog28(dmm)==1
        mmm2=mmm2+1000;
        mdata=[mdata,mmm2];
    else
        mmm2=mmm2;
        mdata=[mdata,mmm2];
    end
end%21-28
mdata=[mdata,ones(1,2).*mmm2]';%29-30
%以列的形式记录的0-30的31个当天资金数据
%接下来反编译记录区域，起点-村庄1：[1,2,3,4,5,13,22,30,39]
%村庄1-矿山[39,46,55],矿山-村庄2[55,62],村庄2-矿山[62,55]，矿山-终点[55,56,64]
%已知起点-村庄1花费10天，村庄1-矿山花费2天,呆在矿山5天,矿山-村庄1花费1天回来同理
% 呆在矿山8天，矿山-终点2天
plog1=[1,2,3,4,5,13,22,30,39];
for d1=1:10
    if W(d1)==0
        py=plog1(d1);
        plog1=[plog1(1:d1),py,plog1(d1+1:end)];
    end
end%0-10天位置记录
plog2=[46,55];
for d1=11:13
    if W(d1)==0
        py2=plog2(d1-10);
        plog2=[plog2(1:d1-10),py2,plog2(d1-10+1:end)];
    end
end
%11-13
plog3=ones(1,5).*55;%14-18
plog4=[62];%19
plog5=ones(1,9).*55;%20-28
plog6=[56,64];%29-30
plog=[plog1,plog2,plog3,plog4,plog5,plog6]';%一列记录0-30天位置情况
%最后编译水和食物的记录
waterlog=[beginwater58];
foodlog=[beginfood58];
%已知起点购买水和食物量,可根据天气矩阵W和行动策略矩阵act以时间为基础反编译水和食物情况
wlog=beginwater58;
flog=beginfood58;
for dl=1:30
    %首先编写资源补充判断
    if dl==10
        wlog=wlog+buywater10;
    end
    if dl==11
        wlog=wlog+buywater15;
    end
    if dl==19
        wlog=wlog+buywater28;
        flog=flog+buyfood28;
    end
    %其次编写资源消耗记录矩阵
    if W(dl)==0
        if act58(dl)==0
            wlog=wlog-10;
            flog=flog-10;
            waterlog=[waterlog,wlog];
            foodlog=[foodlog,flog];
        elseif act58(dl)==2
            wlog=wlog-30;
            flog=flog-30;
            waterlog=[waterlog,wlog];
            foodlog=[foodlog,flog];
        end
    elseif W(dl)==1
        if act58(dl)==0
            wlog=wlog-5;
            flog=flog-7;
            waterlog=[waterlog,wlog];
            foodlog=[foodlog,flog];
        elseif act58(dl)==1
            wlog=wlog-10;
            flog=flog-14;
            waterlog=[waterlog,wlog];
            foodlog=[foodlog,flog];
        elseif act58(dl)==2
            wlog=wlog-15;
            flog=flog-21;
            waterlog=[waterlog,wlog];
            foodlog=[foodlog,flog];
        end
    elseif W(dl)==2
        if act58(dl)==0
            wlog=wlog-8;
            flog=flog-6;
            waterlog=[waterlog,wlog];
            foodlog=[foodlog,flog];
        elseif act58(dl)==1
            wlog=wlog-16;
            flog=flog-12;
            waterlog=[waterlog,wlog];
            foodlog=[foodlog,flog];
        elseif act58(dl)==2
            wlog=wlog-24;
            flog=flog-18;
            waterlog=[waterlog,wlog];
            foodlog=[foodlog,flog];
        end
    end
end
waterlog=waterlog';
foodlog=foodlog';
%至此，整理好所需输出的四列31行数据，分别是plog,mdata,waterlog,foodlog
%它们分别对应:所在区域	剩余资金数	剩余水量	剩余食物量
%打开现有的Excel文件
filename='Result.xlsx';
[~,~,raw]=xlsread(filename,'Sheet1');%读取第一张工作表
% 准备要写入的数据（31行×4列）
output_data=[plog,mdata,waterlog,foodlog];
% 确定写入位置（第二关的数据从H4开始）
start_row=4;%从第4行开始（对应日期0）
start_col=8;%从H列开始（第二关数据）
% 更新数据到raw单元格数组
for i=1:31
    for j=1:4
        raw{start_row+i-1,start_col+j-1}=output_data(i,j);
    end
end
% 写入更新后的数据
xlswrite(filename,raw,'Sheet1');
% 输出完成提示
disp('数据已成功更新到Result.xlsx文件中');