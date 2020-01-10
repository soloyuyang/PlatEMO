clc;
clear;

%% 添加路径
cd(fileparts(mfilename('fullpath')));
addpath(genpath(cd));


%% 源程序的调用格式：
%  main('-algorithm',@NSGAII,'-problem',@UF4,'-N',100,'-M',2,'-D',4)


%% 改了一下源程序main
%% 运行前添加所有路径
a=main('-algorithm',@MOPSO,'-problem',@ZDT4,'-N',100,'-M',2,'-D',10,'-evaluation',10000);% 

% 测试函数的真实前端
turePF=a.PF;
% 调取具体的参数和cost值
Feasible     = find(all(a.result{end}.cons<=0,2));% 寻找可行解， cons这个属性有的测试函数有（如doc类的函数有），有的测试函数没有，直接被记作零
NonDominated = NDSort(a.result{end}(Feasible).objs,1) == 1; %使用排序算法寻找非支配解对应的个体序号
% Population   = a.result{end}(Feasible(NonDominated));% population 的个体即为非支配解集
Population   = a.result{end};%选一个计算指标的种群，这里选最后一个，也可以轮盘赌，（下面有代码）

% Score = IGD(PopObj,a.PF)
best_positions = Population(Feasible(NonDominated)).decs;%选定的非支配解(未筛选最终唯一值)
best_scores = Population(Feasible(NonDominated)).objs;%选定的非支配解对应的适应度（未筛选）
% Draw(best_scores,'ro');hold on; Draw(turePF,'b-'); % 可以先注释掉GLOBAL中的326-329行，不然，main函数会有图像输出


IGD_Score = IGD(best_scores,a.PF);
Coverage_Score = Coverage(best_scores,a.PF);
CPF_Score = CPF(best_scores,a.PF);
DeltaP_Score = DeltaP(best_scores,a.PF);
DM_Score = DM(best_scores,a.PF);
GD_Score = GD(best_scores,a.PF);
[HV_Score,PopObj] = HV(best_scores,a.PF);
PD_Score = PD(best_scores,a.PF);
Spacing_Score = Spacing(best_scores,a.PF);
Spread_Score = Spread(best_scores,a.PF);
runtime=a.runtime;



% % 最优值筛选可以使用分位数、或者轮盘赌的方法(MOALO中)
% %轮盘赌：
%         Archive_mem_ranks=RankingProcess(Archive_F, ArchiveMaxSize, obj_no);
%         
%         % Chose the archive member in the least population area as arrtactor
%         % to improve coverage
%         index=RouletteWheelSelection(1./Archive_mem_ranks);
%         if index==-1
%             index=1;
%         end
%         Elite_fitness=Archive_F(index,:);
%         Elite_position=Archive_X(index,:)';



% 删除工具箱路径
% rmpath(genpath(cd));

% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % 多次迭代获取结果
% for i = 1 : 5
%   main('-algorithm',@NSGAII,'-problem',@ZDT1,'-run',i,'-save',5,'-D',10,'-M',2,'-N',100)
% end
% % 获取前端,随便一个测试函数都可以,有多种获取方法
% % % 方法1，利用GLOBAL类直接定义
% % obj=GLOBAL('-problem',@MaF1,'-M',3);
% % turePF=obj.problem.PF(1000);
% % Draw(turePF);% 画出前端
% 
% % 或者使用 ,这种方法更好一点
% fun = ZDT1();
% turePF = fun.PF(200);% 括号中的即是计算PF的样本点的个数
% 
% %%%
% obj.problem.PF(10000);
% obj.algorithm   %查看使用的什么算法
% Population=obj.Initialization   %查看现在使用的算法的初始个体参数和对应的目标值




