%% 总结：
%%% 
% 调用具体函数的时候，先将函数实例化，然后利用函数的实例化对象中的...
% 方法来调用函数的具体内容，例如真实的PF;函数输入参数后的具体计算,参数的上下界会在类实例化的时候生成好
% 例如：gfun=MaF1(); %里面的目标维度已经设置好了，有默认值
%       PopObj2=gfun.CalObj(PopDec); %PopObj1与PopObj2的结果一致，也等于a.result{end}(end).obj
%       TurePF=gfun.PF(1000)
%%%


% 检验测试函数的计算过程
a=main('-algorithm',@NSGAII,'-problem',@MaF1,'-N',100,'-M',3,'-D',10,'-evaluation',1000);% 中的信息调用
PopDec=a.result{end}(end).dec;% 可以随便找一个个体身上的参数来做测试
% 上面得到的PopDec即为一个population， 用于下面的测试


%% 目标函数的计算部分
% Example MaF1
M= 3; %目标个数
% 函数的计算公式去Problem文件夹中找
g      = sum((PopDec(:,M:end)-0.5).^2,2);
PopObj1 = repmat(1+g,1,M) - repmat(1+g,1,M).*fliplr(cumprod([ones(size(g,1),1),PopDec(:,1:M-1)],2)).*[ones(size(g,1),1),1-PopDec(:,M-1:-1:1)];
% PopObj 得到行,其值即为PopDec身上参数对应的目标函数值

% 或者直接使用实例化后的对象来调用函数运算,this one is better
gfun=MaF1(); %里面的目标维度已经设置好了，有默认值
PopObj2=gfun.CalObj(PopDec); %PopObj1与PopObj2的结果一致，也等于a.result{end}(end).obj





