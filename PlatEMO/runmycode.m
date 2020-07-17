% gyy

clc;
clear;

%% ���·��
cd(fileparts(mfilename('fullpath')));
addpath(genpath(cd));



                         

%% ����һ��Դ����main
%% ����ǰ�������·��


% galgrithoms={@NSGAII,@MOEAD,@SPEA2,@PESAII,@NSGAIII,@MOPSO};
galgrithoms={@NSGAII,@MOEAD};
% gproblems={@ZDT1,@ZDT2,@ZDT3,@ZDT4,@ZDT6,@UF1,@UF2,@UF3,@UF4,@UF5,@UF6,@UF7,@UF8,@UF9,@UF10};
% @CF1,@CF2,@CF3,@CF4,@CF5,@CF6,@CF7,@CF8,@CF9,
 gproblems={@ZDT1,@ZDT2};
%% ���Ժ������ص㣺
% ��Ŀ�꣺CF10(�������˵��׼�����ܵõ��յ�best_score����dim���м���);
%         UF8,UF9,UF10
% ��Ŀ�꣺UF11��@UF12
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
            
            % ���Ժ�������ʵǰ��
            turePF=gmodel.PF;
            % ��ȡ����Ĳ�����costֵ
            Feasible     = find(all(gmodel.result{end}.cons<=0,2));% Ѱ�ҿ��н⣬ cons��������еĲ��Ժ����У���doc��ĺ����У����еĲ��Ժ���û�У�ֱ�ӱ�������
            NonDominated = NDSort(gmodel.result{end}(Feasible).objs,1) == 1; %ʹ�������㷨Ѱ�ҷ�֧����Ӧ�ĸ������
            % Population   = a.result{end}(Feasible(NonDominated));% population �ĸ��弴Ϊ��֧��⼯
            Population   = gmodel.result{end};%ѡһ������ָ�����Ⱥ������ѡ���һ����Ҳ�������̶ģ��������д��룩
            
            % Score = IGD(PopObj,a.PF)
            best_positions = Population(Feasible(NonDominated)).decs;%ѡ���ķ�֧���(δɸѡ����Ψһֵ)
            best_scores = Population(Feasible(NonDominated)).objs;%ѡ���ķ�֧����Ӧ����Ӧ�ȣ�δɸѡ��
            % Draw(best_scores,'ro');hold on; Draw(turePF,'b-'); % ������ע�͵�GLOBAL�е�326-329�У���Ȼ��main��������ͼ�����
            
            
            
            
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
%                         model(j).problem(s).igd{i,:}=IGD(best_scores,gmodel.PF);% ����պ���
                        % ������
                        problem(s).model(j).GD_Score{i,:} = GD(best_scores,gmodel.PF);
                        problem(s).model(j).Coverage_Score{i,:} = Coverage(best_scores,gmodel.PF);
                        % ������
                        problem(s).model(j).Spacing_Score{i,:}  = Spacing(best_scores,gmodel.PF);
                        problem(s).model(j).Spread_Score{i,:}  = Spread(best_scores,gmodel.PF);
                        % �ۺ������ԺͶ�����
                        problem(s).model(j).IGD_Score{i,:}=IGD(best_scores,gmodel.PF);
                        problem(s).model(j).HV_Score{i,:}= HV(best_scores,gmodel.PF);
                        

                       
                        
            close all;
        end
    end
    %     IGDstore(i)={IGD_Score};
    %     cell2mat( arrayfun(@(c) c.x(2,:), (1:length(s)).', 'Uniform', 0) )
    %     ��ȡIGDstore{1,1}(1,1)

    
    
    
    
end

 %% ���������� 
    index=1;
    for ss=1:length(gproblems)
        for jj=1:length(galgrithoms)
%             metric_matrix���ȱ�����������1��1����1��2��������
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
    
    
    
    
    
    
    
% ��ȡģ��һ������һ����� ��model(1).problem(1).igd
% ��ȡģ�Ͷ�������һ����� ��model(2).problem(1).igd

% % ����ֵɸѡ����ʹ�÷�λ�����������̶ĵķ���(MOALO��)
% %���̶ģ�
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



% ɾ��������·��
% rmpath(genpath(cd));

% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % ��ε�����ȡ���
% for i = 1 : 5
%   main('-algorithm',@NSGAII,'-problem',@ZDT1,'-run',i,'-save',5,'-D',10,'-M',2,'-N',100)
% end
% % ��ȡǰ��,���һ�����Ժ���������,�ж��ֻ�ȡ����
% % % ����1������GLOBAL��ֱ�Ӷ���
% % obj=GLOBAL('-problem',@MaF1,'-M',3);
% % turePF=obj.problem.PF(1000);
% % Draw(turePF);% ����ǰ��
% 
% % ����ʹ�� ,���ַ�������һ��
% fun = ZDT1();
% turePF = fun.PF(200);% �����еļ��Ǽ���PF��������ĸ���
% 
% %%%
% obj.problem.PF(10000);
% obj.algorithm   %�鿴ʹ�õ�ʲô�㷨
% Population=obj.Initialization   %�鿴����ʹ�õ��㷨�ĳ�ʼ��������Ͷ�Ӧ��Ŀ��ֵ




