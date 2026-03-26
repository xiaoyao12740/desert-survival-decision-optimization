clear;
clc
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
PB=P;
water=0;
food=0;
DV1=0;
arrvt=0;%抵达村庄的次数
arrMMt=0;%抵达矿山的次数
while PB(1)~=F(1)
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
if PB(2)~=V(2)&&arrvt==0
PB(2)=PB(2)+1;%没到村庄
elseif PB(2)==V(2)&&arrvt==1
PB(2)=PB(2)+1;%到村庄
elseif PB(2)~=MM(2)&&arrMMt==0
%没到矿山
PB(2)=PB(2)+1;
elseif PB(2)==MM(2)&&arrMMt==1
%到矿山，这里不挖矿
PB(2)=PB(2)-1;
elseif PB(2)~=V(2)&&arrvt~=2%第二次没到村庄
PB(2)=PB(2)-1;
elseif PB(2)==V(2)&&arrvt==2%第二次到村庄
PB(1)=PB(1)+1;
elseif PB(1)~=F(1)
PB(1)=PB(1)+1;
end
water=water-2*wateruse;
food=food-2*fooduse;
else
water=water-wateruse;
food=food-fooduse;
end
totB1=((-3)*water+(-2)*food);%总负重
if PB(2)==V(2)&&Totw>((-3)*water+(-2)*food)&&arrvt==0
DV1=d;
arrvt=arrvt+1;
disp(['第一次抵达村庄！共花费天数:',num2str(DV1),'共花费水数'...
,num2str(-water),'共花费食物数', num2str(-food)])
continue
elseif PB(2)==MM(2)&&Totw>((-3)*water+(-2)*food)&&arrMMt==0
DMM1=d;
arrMMt=arrMMt+1;
disp(['第一次抵达矿山！共花费天数:',num2str(DMM1),'共花费水数'...
,num2str(-water),'共花费食物数', num2str(-food)])
continue
elseif PB(2)==V(2)&&Totw>((-3)*water+(-2)*food)&&arrMMt==1 
DV2=d;
arrvt=arrvt+1;
PB(2)=P(2);
disp(['第二次抵达村庄！共花费天数:',num2str(DV2),'共花费水数'...
,num2str(-water),'共花费食物数', num2str(-food)])
continue
elseif PB(1)==F(1)&&Totw>((-3)*water+(-2)*food)
disp('抵达终点，找到该方案的最优解')
DB=d;
arrvt=arrvt+1;
TotMB=TotM+water*5+food*10;
disp(['共花费天数:',num2str(DB),'共花费水数',num2str(-water),...
    '共花费食物数',num2str(-food),'方案B剩余钱数',num2str(TotMB)])
break
elseif Totw<totB1
buytotB=totB1-Totw;
disp('负重不足，需要购买两种物资，它们总共负重为：')
disp(buytotB)
Totw=totB1;
continue
end
end
end