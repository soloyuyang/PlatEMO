%% �ܽ᣺
%%% 
% ���þ��庯����ʱ���Ƚ�����ʵ������Ȼ�����ú�����ʵ���������е�...
% ���������ú����ľ������ݣ�������ʵ��PF;�������������ľ������,���������½������ʵ������ʱ�����ɺ�
% ���磺gfun=MaF1(); %�����Ŀ��ά���Ѿ����ú��ˣ���Ĭ��ֵ
%       PopObj2=gfun.CalObj(PopDec); %PopObj1��PopObj2�Ľ��һ�£�Ҳ����a.result{end}(end).obj
%       TurePF=gfun.PF(1000)
%%%


% ������Ժ����ļ������
a=main('-algorithm',@NSGAII,'-problem',@MaF1,'-N',100,'-M',3,'-D',10,'-evaluation',1000);% �е���Ϣ����
PopDec=a.result{end}(end).dec;% ���������һ���������ϵĲ�����������
% ����õ���PopDec��Ϊһ��population�� ��������Ĳ���


%% Ŀ�꺯���ļ��㲿��
% Example MaF1
M= 3; %Ŀ�����
% �����ļ��㹫ʽȥProblem�ļ�������
g      = sum((PopDec(:,M:end)-0.5).^2,2);
PopObj1 = repmat(1+g,1,M) - repmat(1+g,1,M).*fliplr(cumprod([ones(size(g,1),1),PopDec(:,1:M-1)],2)).*[ones(size(g,1),1),1-PopDec(:,M-1:-1:1)];
% PopObj �õ���,��ֵ��ΪPopDec���ϲ�����Ӧ��Ŀ�꺯��ֵ

% ����ֱ��ʹ��ʵ������Ķ��������ú�������,this one is better
gfun=MaF1(); %�����Ŀ��ά���Ѿ����ú��ˣ���Ĭ��ֵ
PopObj2=gfun.CalObj(PopDec); %PopObj1��PopObj2�Ľ��һ�£�Ҳ����a.result{end}(end).obj





