opts = delimitedTextImportOptions("NumVariables", 18);
opts.DataLines = [2, Inf];
opts.Delimiter = ",";
opts.VariableNames = ["Var1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "item1"];
opts.SelectedVariableNames = "item1";
opts.VariableTypes = ["char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char", "char"];
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "item1"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "Var9", "Var10", "Var11", "Var12", "Var13", "Var14", "Var15", "Var16", "Var17", "item1"], "EmptyFieldRule", "auto");
% Import the data
tbl = readtable("G:\My Drive\Machin learning\ML COD PRACTICE\hoome work 1 (buying items and supp)\apriori_train_pre_prossesed.csv", opts);
item = tbl.item1;
clear opts tbl

item_number = 16;
supp_troshold = 30;

[total_supp,all_item] = finding_supp_count (item,item_number,supp_troshold);

clearvars -except item relations total_supp
titi=0;
Var1="_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-";
Var2=Var1;
Var3 = "_-_-_-_-_-";
ta=table(Var1,Var2,Var3);
tt=ta;

for k = 1: length(total_supp{1,5})
    temp1 = total_supp{1,5}{k,1};
    temp2 = total_supp{1,5}{k,2};
    [relations] = confidence_table(temp1,temp2,total_supp);
    clearvars -except item relations total_supp tt titi k
    
    r=0;
    
    
    for i=1:length(relations)
        if relations{i,1}{1,2}/relations{i,2}{1,2}>0.7
            titi=1;
            r=r+1;
            % r=i;
            temp1=erase (evalc("disp(relations{i,2}{1,1})"),' ');
            a{r} = temp1;
            temp2=erase (evalc("disp(relations{i,3}{1,1})"),' ');
            b{r} = temp2;
            confiden{r} = relations{i,1}{1,2}/relations{i,2}{1,2};
        end
    end
    for j=1:length(relations)
        if relations{1,1}{1,2}/relations{j,3}{1,2}>0.7
            r=r+1;
            titi=1;
            % r=i+j;
            temp3=erase (evalc("disp(relations{j,3}{1,1})"),' ');
            a{r} = temp3;
            temp4 =erase (evalc("disp(relations{j,2}{1,1})"),' ');
            b{r} = temp4;
            confiden{r} = relations{1,1}{1,2}/relations{j,3}{1,2};
        end
    end
    
    if titi==1
        t = table(a',b',confiden');
        % tt=t;
        tt=[tt;t];
        titi=0;
    end
end
A=table2array(tt);
B = strrep(A,'i16','chocolate');
B = strrep(B,'i17','Yogurt');
B = strrep(B,'i16','Unicorn');
B = strrep(B,'i15','Sugar');
B = strrep(B,'i14','Onion');
B = strrep(B,'i13','Nutmeg');
B = strrep(B,'i12','Milk');
B = strrep(B,'i11','Beans');
B = strrep(B,'i10','Kidney');
B = strrep(B,'i9','cream');
B = strrep(B,'i8','Ice');
B = strrep(B,'i7','Eggs');
B = strrep(B,'i6','Dill');
B = strrep(B,'i5','Corn');
B = strrep(B,'i4','Cheese');
B = strrep(B,'i3','Butter');
B = strrep(B,'i2','Bread');
B = strrep(B,'i1','Apple');
B(1,:)=[];
B = strrep(B,'}{','}^{');
C=[B(:,1) B(:,2)];
C=join(C);
C = strrep(C,newline,'');
C = strrep(C,'} {','}||{');
inde = [1:length(C)]';
D = [inde,C,B(:,3)];
writematrix(D,'priori_result.csv');
%%
function [total_supp,all_item] = finding_supp_count (item,number_of_items,minimum_supp_troshold)
item = item;
clc
clearvars -except item number_of_items minimum_supp_troshold
for i=1 : length (item)
    item_processed{i} = erase (item{i},' ');
    bought_item{i,:} = split(item_processed{i},',')';
end
number_of_items = number_of_items;

for i=1: number_of_items
    all_item{i} = "i"+i;
    all_item{i} = char(all_item{i});
end
minimum_supp_troshold = minimum_supp_troshold;
% bought_item = erase_repitation(bought_item);
clearvars -except item all_item bought_item minimum_supp_troshold
k_step_number = 1;
item_k_steps = all_item';
supp_number = zeros (length(item_k_steps),1);
%count the supps
for i=1:length (item_k_steps)
    [supp, item_repitation] = comper_items (bought_item,{item_k_steps{i,1}});
    supp_number(i)=supp;
    temp_supp(i,k_step_number) = {supp};
end
% total_supp=total_supp';
%filter
temp6=0;
for i=1:length (item_k_steps)
    if supp_number(i)<minimum_supp_troshold
        item_k_steps(i-temp6) = [];
        temp_supp(i-temp6) = [];
        temp6 = temp6 + 1;
    end
end

total_supp = {[item_k_steps,temp_supp]};

k = length({item_k_steps{1,1}}) + 1 ;
temp5 = 0;
%produce new items
for i=1: length(item_k_steps)
    for j=i+1: length(item_k_steps)
        temp1 = {item_k_steps{i,1}};
        temp2 = {item_k_steps{j,1}};
        temp3 = comper_items_2_by_2 (temp1,temp2);
        if temp3 >= k-2
            temp4 = [temp1,temp2];
            temp5 = temp5+1;
            new_item_k_steps (temp5,1) = erase_repitation({temp4});
        end

    end
end
clearvars -except item all_item bought_item new_item_k_steps total_supp minimum_supp_troshold
item_k_steps = new_item_k_steps;
k_step_number = 1;
while length(item_k_steps)>2
    clearvars temp_supp temp1 temp2 temp3 temp4 temp5 temp6
    item_k_steps = new_item_k_steps;
    supp_number = zeros (length(item_k_steps),1);
    for i=1:length (item_k_steps)
        [supp, item_repitation] = comper_items (bought_item,item_k_steps{i,1});
        supp_number(i)=supp;
        temp_supp(i,k_step_number) = {supp};
    end

    temp6 = 0;
    for i=1:length (item_k_steps)
        if supp_number(i)<minimum_supp_troshold
            item_k_steps(i-temp6) = [];
            temp_supp(i-temp6) = [];
            temp6 = temp6+1;

        end
    end

    total_supp_temp = {[item_k_steps,temp_supp]};
if length(total_supp_temp{1,1})<1
    break
end
    total_supp = [total_supp,total_supp_temp];

    clearvars new_item_k_steps
    % new_item_k_steps ={};
    k = length(item_k_steps{1,1}) + 1 ;
    temp5 = 0;
    for i=1: length(item_k_steps)
        for j=i+1: length(item_k_steps)
            temp1 = item_k_steps{i,1};
            temp2 = item_k_steps{j,1};
            temp3 = comper_items_2_by_2 (temp1,temp2);
            if temp3 >= k-2
                temp4 = [temp1,temp2];
                temp5 = temp5+1;
                new_item_k_steps (temp5,1) = erase_repitation({temp4});
            end

        end
    end

    new_item_k_steps = erase_repeted_cells (new_item_k_steps);

end
item_k_steps = new_item_k_steps;
supp_number = zeros (length(item_k_steps),1);
for i=1:length (item_k_steps)
    [supp, item_repitation] = comper_items (bought_item,item_k_steps{i,1});
    supp_number(i)=supp;
    temp_supp(i,k_step_number) = {supp};
end
temp6 = 0;
for i=1:length (item_k_steps)
    if supp_number(i)<minimum_supp_troshold
        item_k_steps(i-temp6) = [];
        temp_supp(i-temp6) = [];
        temp6 = temp6+1;
    end
end
if length(item_k_steps)>=1
    total_supp_temp = {[new_item_k_steps,temp_supp]};
    total_supp = [total_supp,total_supp_temp];
    clearvars -except item all_item bought_item new_item_k_steps total_supp
end
end
function [relation] = suppnumber_for_confidence (supp_count,total_supp)

    k_lvl_items = supp_count'; %tranfered already a
    temp_klvl = k_lvl_items;
    second_condition = temp_klvl;
    
    % cereate first and second condition
    first_condition = {temp_klvl{1,1}};
    for i=1:length(first_condition)
        idx = cellfun (@(x) isequal(x,first_condition{1,i}),temp_klvl);
        second_condition(idx)=[];
    end
    
    %find the supp of each condition
    L_first_condition = length (first_condition);
    L_second_condition = length(second_condition);
    
    idx_supp_count_first_condition = total_supp{1,L_first_condition}(:,1);
    idx_supp_count_second_condition = total_supp{1,L_second_condition}(:,1);
    %first condition supp number
    for i=1: length(idx_supp_count_first_condition)
        if L_first_condition == 1
            supp_count_first_condition = comper_items_2_by_2 (first_condition,idx_supp_count_first_condition(i));
            temp1 = length(idx_supp_count_first_condition(1));
        else
            supp_count_first_condition = comper_items_2_by_2 (first_condition',idx_supp_count_first_condition{i});
            temp1 = length(idx_supp_count_first_condition{1});
        end
    
        if supp_count_first_condition == temp1
            number_of_supp_first =  total_supp{1,L_first_condition}{i,2};
        end
    end
    %secon condition supp number
    for i=1: length(idx_supp_count_second_condition)
        if L_second_condition == 1
            supp_count_second_condition = comper_items_2_by_2 (second_condition,idx_supp_count_second_condition(i));
            temp1 = length(idx_supp_count_second_condition(1));
        else
            supp_count_second_condition = comper_items_2_by_2 (second_condition',idx_supp_count_second_condition{i});
            temp1 = length(idx_supp_count_second_condition{1});
        end
    
        if supp_count_second_condition == temp1
            number_of_supp_second =  total_supp{1,L_second_condition}{i,2};
        end
    end
    
    supp_first_and_second = total_supp{1,5}{1,2};
    
    relation = { {k_lvl_items',supp_first_and_second} ,...
        {first_condition',number_of_supp_first} ,...
        {second_condition',number_of_supp_second} };
end
function [total_relation] = confidence_table(temp1,temp2,total_supp)

supp_count = temp1;
supp_count_number = temp2;
total_relation={};

    k_lvl_items = supp_count'; %tranfered already a
    
    temp_klvl = k_lvl_items;
%%%%$$$%%% here is for just first temp_klvl    
for ii=1: length(temp_klvl)    
    second_condition = temp_klvl;
    % cereate first and second condition
    first_condition = {temp_klvl{ii,1}};
    for i=1:length(first_condition)
        idx = cellfun (@(x) isequal(x,first_condition{1,i}),temp_klvl);
        second_condition(idx)=[];
    end
    
    %find the supp of each condition
    L_first_condition = length (first_condition);
    L_second_condition = length(second_condition);
    
    idx_supp_count_first_condition = total_supp{1,L_first_condition}(:,1);
    idx_supp_count_second_condition = total_supp{1,L_second_condition}(:,1);
    %first condition supp number
    for i=1: length(idx_supp_count_first_condition)
        if L_first_condition == 1
            supp_count_first_condition = comper_items_2_by_2 (first_condition,idx_supp_count_first_condition(i));
            temp1 = length(idx_supp_count_first_condition(1));
        else
            supp_count_first_condition = comper_items_2_by_2 (first_condition',idx_supp_count_first_condition{i});
            temp1 = length(idx_supp_count_first_condition{1});
        end
    
        if supp_count_first_condition == temp1
            number_of_supp_first =  total_supp{1,L_first_condition}{i,2};
        end
    end
    %secon condition supp number
    for i=1: length(idx_supp_count_second_condition)
        if L_second_condition == 1
            supp_count_second_condition = comper_items_2_by_2 (second_condition,idx_supp_count_second_condition(i));
            temp1 = length(idx_supp_count_second_condition(1));
        else
            supp_count_second_condition = comper_items_2_by_2 (second_condition',idx_supp_count_second_condition{i});
            temp1 = length(idx_supp_count_second_condition{1});
        end
    
        if supp_count_second_condition == temp1
            number_of_supp_second =  total_supp{1,L_second_condition}{i,2};
        end
    end
    
    supp_first_and_second = supp_count_number;
    
    relation = { {k_lvl_items',supp_first_and_second} ,...
        {first_condition',number_of_supp_first} ,...
        {second_condition',number_of_supp_second} };
    total_relation = [total_relation; relation];
end
% clearvars -except total_relation k_lvl_items item total_supp temp_klvl



%%%##@@#$%%%% produce 2 lvl of temp_klvl
%%
temp5 = 1;
for i=1: length(temp_klvl)
    for j=i+1: length(temp_klvl)
        temp1 = {temp_klvl{i,1}};
        temp2 = {temp_klvl{j,1}};
        temp4 = [temp1,temp2];
        new_temp_klvl (temp5,1) = erase_repitation({temp4});
        temp5=temp5+1;
    end
end

temp_klvl = new_temp_klvl;
temp_klvl = erase_repeted_cells(temp_klvl);

clearvars -except total_relation k_lvl_items item total_supp temp_klvl...
    supp_count_number 



while length(temp_klvl{1,1})<=(length(k_lvl_items)/2)
    %%%%$$$%%% here is for more than first temp_klvl

    for ii=1: length(temp_klvl)
        second_condition = k_lvl_items;
        % cereate first and second condition
        first_condition = temp_klvl{ii,1};
        first_condition = first_condition';
        for i=1:length(first_condition)
            idx = cellfun (@(x) isequal(x,first_condition{i,1}),second_condition);
            second_condition(idx)=[];
        end

        %find the supp of each condition
        L_first_condition = length (first_condition);
        L_second_condition = length(second_condition);

        idx_supp_count_first_condition = total_supp{1,L_first_condition}(:,1);
        idx_supp_count_second_condition = total_supp{1,L_second_condition}(:,1);
        %first condition supp number
        for i=1: length(idx_supp_count_first_condition)
            supp_count_first_condition = comper_items_2_by_2 (first_condition',idx_supp_count_first_condition{i});
            temp1 = length(idx_supp_count_first_condition{1});
            if supp_count_first_condition == temp1
                number_of_supp_first =  total_supp{1,L_first_condition}{i,2};
            end
        end
        %secon condition supp number
        for i=1: length(idx_supp_count_second_condition)
            if L_second_condition == 1
                supp_count_second_condition = comper_items_2_by_2 (second_condition,idx_supp_count_second_condition(i));
                temp1 = length(idx_supp_count_second_condition(1));
            else
                supp_count_second_condition = comper_items_2_by_2 (second_condition',idx_supp_count_second_condition{i});
                temp1 = length(idx_supp_count_second_condition{1});
            end

            if supp_count_second_condition == temp1
                number_of_supp_second =  total_supp{1,L_second_condition}{i,2};
            end
        end

        supp_first_and_second = supp_count_number;

        relation = { {k_lvl_items',supp_first_and_second} ,...
            {first_condition',number_of_supp_first} ,...
            {second_condition',number_of_supp_second} };
        total_relation = [total_relation; relation];
    end

    clearvars -except total_relation k_lvl_items item total_supp temp_klvl...
        supp_count_number 

    %%%##@@#$%%%% produce other lvl of temp_klvl
    temp5 = 1;
    for i=1: length(temp_klvl)
        for j=i+1: length(temp_klvl)
            temp1 = temp_klvl{i,1};
            temp2 = temp_klvl{j,1};
            temp4 = [temp1,temp2];
            new_temp_klvl (temp5,1) = erase_repitation({temp4});
            temp5=temp5+1;
        end
    end

    temp_klvl = new_temp_klvl;
    temp_klvl = erase_repeted_cells(temp_klvl);
end

end
function [supp_number,item_repitation]=comper_items (main_item, comper_item)

    
    [m,~]=size (main_item);
    l = length (comper_item);
    
    item_repitation = zeros(m,1);
    match = zeros(m,1);
    for i=1: length(main_item)
        for j=1: length(comper_item)
            for k=1:length(main_item{i,1})
                temp1=main_item{i,1}{1,k};
                temp2=comper_item{1,j};
                
                if strcmp(temp1,temp2) == 1
                    item_repitation(i,1) = item_repitation(i,1)+1;
                end
            end     
        end
    end
    
    for i=1: length(main_item)
        if item_repitation(i,1)== l
             match(i,1) = 1;          
        else
            match(i,1) = 0;
        end
    end
    supp_number = sum(match);
    
    
end
function [number_comon]= comper_items_2_by_2 (comp1, comp2)

m=length (comp1);
item_repitation = zeros(m,1);
for i=1: length(comp1)
    for j=1: length(comp2)

        temp1=comp1{1,i};
        temp2=comp2{1,j};

        if strcmp(temp1,temp2) == 1
            item_repitation(i,1) = item_repitation(i,1)+1;
        end
    end
end
number_comon = sum(item_repitation);

end
function [main_cell]=erase_repeted_cells (main_cell) 
L= length(main_cell {1});
temp3=0;

    for i=1: length (main_cell)
        i=i-temp3;
        for j=i+1: length (main_cell)
            temp1 = main_cell {i};
            temp2 = main_cell {j};
            comen_nember = comper_items_2_by_2 (temp1,temp2);
            if comen_nember == L
                main_cell (j) = [];
                temp3 = temp3+1;
                break
            end
        end
    end
    
end
function [item_without_repet] = erase_repitation(list)
main_item = list;

    for i=1: length(main_item)
        for j=1:length(main_item{i,1})
            if j>length(main_item{i,1})
                break
            end
            temp2=0;
            temp1=0;
            item_to_check = main_item{i,1}{1,j-temp2};
            for k=1: length(main_item{i,1})
                if strcmp(item_to_check , main_item{i,1}{1,k-temp2}) ==1
                    temp1 = temp1+1;
                end
                if temp1>1
                    main_item{i,1}(k-temp2) =[];
                    k=k-1;
                    temp2=temp2+1;
                    temp1 = 1;
                end
            end
        end
    end
    item_without_repet = main_item;
end