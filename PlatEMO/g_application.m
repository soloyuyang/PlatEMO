clc;
clear;

%% ���·��
cd(fileparts(mfilename('fullpath')));
addpath(genpath(cd));


%% Դ����ĵ��ø�ʽ��
%  main('-algorithm',@NSGAII,'-problem',@UF4,'-N',100,'-M',2,'-D',4)


%% ����һ��Դ����main
%% ����ǰ�������·��
a=main('-algorithm',@MOPSO,'-problem',@ZDT4,'-N',100,'-M',2,'-D',10,'-evaluation',10000);% 

% ���Ժ�������ʵǰ��
turePF=a.PF;
% ��ȡ����Ĳ�����costֵ
Feasible     = find(all(a.result{end}.cons<=0,2));% Ѱ�ҿ��н⣬ cons��������еĲ��Ժ����У���doc��ĺ����У����еĲ��Ժ���û�У�ֱ�ӱ�������
NonDominated = NDSort(a.result{end}(Feasible).objs,1) == 1; %ʹ�������㷨Ѱ�ҷ�֧����Ӧ�ĸ������
% Population   = a.result{end}(Feasible(NonDominated));% population �ĸ��弴Ϊ��֧��⼯
Population   = a.result{end};%ѡһ������ָ�����Ⱥ������ѡ���һ����Ҳ�������̶ģ��������д��룩

% Score = IGD(PopObj,a.PF)
best_positions = Population(Feasible(NonDominated)).decs;%ѡ���ķ�֧���(δɸѡ����Ψһֵ)
best_scores = Population(Feasible(NonDominated)).objs;%ѡ���ķ�֧����Ӧ����Ӧ�ȣ�δɸѡ��
% Draw(best_scores,'ro');hold on; Draw(turePF,'b-'); % ������ע�͵�GLOBAL�е�326-329�У���Ȼ��main��������ͼ�����


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




