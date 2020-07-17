% gyy

clc;
clear;

%% 添加路径
cd(fileparts(mfilename('fullpath')));
addpath(genpath(cd));



                         

%% 改了一下源程序main
%% 运行前添加所有路径


% galgrithoms={@NSGAII,@MOEAD,@SPEA2,@PESAII,@NSGAIII,@MOPSO};
galgrithoms={@NSGAII,@MOEAD};
% gproblems={@ZDT1,@ZDT2,@ZDT3,@ZDT4,@ZDT6,@UF1,@UF2,@UF3,@UF4,@UF5,@UF6,@UF7,@UF8,@UF9,@UF10};
% @CF1,@CF2,@CF3,@CF4,@CF5,@CF6,@CF7,@CF8,@CF9,
 gproblems={@ZDT1,@ZDT2};
%% 测试函数的特点：
% 三目标：CF10(这个函数说不准，可能得到空的best_score，换dim运行几次);
%         UF8,UF9,UF10
% 五目标：UF11，@UF12
% gproblems={@UF12};
numpop=100;
popdim=6;
objnum=2;

% IGDstore={};


for i=1:2
    i
    for s=1:length(gproblems)
        
        for j=1:length(galgrithoms)
           
            gmodel=main('-algorithm',galgrithoms(j),'-problem',gproblems(s),'-N',numpop,'-M',objnum,'-D',popdim,'-evaluation',10000);%
            
            % 测试函数的真实前端
            turePF=gmodel.PF;
            % 调取具体的参数和cost值
            Feasible     = find(all(gmodel.result{end}.cons<=0,2));% 寻找可行解， cons这个属性有的测试函数有（如doc类的函数有），有的测试函数没有，直接被记作零
            NonDominated = NDSort(gmodel.result{end}(Feasible).objs,1) == 1; %使用排序算法寻找非支配解对应的个体序号
            % Population   = a.result{end}(Feasible(NonDominated));% population 的个体即为非支配解集
            Population   = gmodel.result{end};%选一个计算指标的种群，这里选最后一个，也可以轮盘赌，（下面有代码）
            
            % Score = IGD(PopObj,a.PF)
            best_positions = Population(Feasible(NonDominated)).decs;%选定的非支配解(未筛选最终唯一值)
            best_scores = Population(Feasible(NonDominated)).objs;%选定的非支配解对应的适应度（未筛选）
            % Draw(best_scores,'ro');hold on; Draw(turePF,'b-'); % 可以先注释掉GLOBAL中的326-329行，不然，main函数会有图像输出
            
            
            
            
            %             IGD_Score = IGD(best_scores,gmodel.PF);
            %
            %             Coverage_Score = Coverage(best_scores,gmodel.PF);
            %             CPF_Score = CPF(best_scores,gmodel.PF);
            %             DeltaP_Score = DeltaP(best_scores,gmodel.PF);
            %             DM_Score = DM(best_scores,gmodel.PF);
            %             GD_Score = GD(best_scores,gmodel.PF);
            %             [HV_Score,PopObj] = HV(best_scores,gmodel.PF);
            %             PD_Score = PD(best_scores,gmodel.PF);
            %             Spacing_Score = Spacing(best_scores,gmodel.PF);
            %             Spread_Score = Spread(best_scores,gmodel.PF);
            %             runtime=gmodel.runtime;
            
            
            %             IGD_Score(j,s)=IGD(best_scores,gmodel.PF);
%             IGDstore(i).model(j).problem(s)=IGD(best_scores,gmodel.PF);
%                         model(j).problem(s).igd{i,:}=IGD(best_scores,gmodel.PF);% 这个凑合用
                        % 收敛性
                        problem(s).model(j).GD_Score{i,:} = GD(best_scores,gmodel.PF);
                        problem(s).model(j).Coverage_Score{i,:} = Coverage(best_scores,gmodel.PF);
                        % 多样性
                        problem(s).model(j).Spacing_Score{i,:}  = Spacing(best_scores,gmodel.PF);
                        problem(s).model(j).Spread_Score{i,:}  = Spread(best_scores,gmodel.PF);
                        % 综合收敛性和多样性
                        problem(s).model(j).IGD_Score{i,:}=IGD(best_scores,gmodel.PF);
                        problem(s).model(j).HV_Score{i,:}= HV(best_scores,gmodel.PF);
                        

                       
                        
            close all;
        end
    end
    %     IGDstore(i)={IGD_Score};
    %     cell2mat( arrayfun(@(c) c.x(2,:), (1:length(s)).', 'Uniform', 0) )
    %     调取IGDstore{1,1}(1,1)

    
    
    
    
end

 %% 调整试验结果 
    index=1;
    for ss=1:length(gproblems)
        for jj=1:length(galgrithoms)
%             metric_matrix中先遍历方法：测1算1，测1算2。。。。
            metric_matrix{index}=cell2mat([problem(ss).model(jj).GD_Score , problem(ss).model(jj).Coverage_Score, ...
                problem(ss).model(jj).Spacing_Score,problem(ss).model(jj).Spread_Score,...
                problem(ss).model(jj).IGD_Score, problem(ss).model(jj).HV_Score]);
            index=index+1 ;
        end
    end
    for exnum=1:length(galgrithoms)*length(gproblems)
        
        experiment_results{exnum}=[min(metric_matrix{exnum});max(metric_matrix{exnum});mean(metric_matrix{exnum});std(metric_matrix{exnum});median(metric_matrix{exnum})];
            %     gmin(exnum,:)=min(metric_matrix{exnum})
            %     gmax(exnum,:)=max(metric_matrix{exnum})
            %     gmean(exnum,:)=mean(metric_matrix{exnum})
            %     gstd(exnum,:)=std(metric_matrix{exnum})
            %     gmedian=median(metric_matrix{exnum})
    end
    
    
    
    
    
    
    
% 调取模型一，测试一的五次 ：model(1).problem(1).igd
% 调取模型二，测试一的五次 ：model(2).problem(1).igd

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




