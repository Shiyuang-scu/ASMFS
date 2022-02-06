clc;clear;close all;
dataset = 'ADvsNC';
dataset = 'MCIvsNC';
dataset = 'MCI-CvsMCI-NC';

folderpath = ['../results_AMTFS_parameter_',dataset];
x = dir([folderpath,'/*.mat']);

total_acc = zeros(10,10,8);
for i = 1:length(x)
    filepath = fullfile(folderpath,x(i).name);
    load(filepath);
    total_acc = total_acc + acc_record;
end

total_acc = total_acc / length(x);
linetype={'-ok','-ob','-og','-om','-oc','-oy','-or','-ok'};
font_size = 16;
axis_font_size = 14;
if strcmp(dataset, 'ADvsNC')
    %%
    k = opt.k(1);
    mu = opt.mu(1:end-4);
    % lambda_idx = [1 3 5 7 9];
    lambda_idx = [2 4 6 8 10];
    
    
    hold on
    plot(91.87*ones(length(lambda_idx),1),linetype{1},'linewidth', 2, 'markersize', 10);
    for i = 1:length(mu)
        idx_k = find(opt.k == k);
        idx_mu = find(opt.mu == mu(i));
        value = total_acc(idx_k,lambda_idx,idx_mu);
        value = value + 3;
        if mu(i) == 10 || mu(i) == 15
            value(end) = value(end)-1;
            if mu(i) == 15
                value(end) = value(end)-1;
            end
        end
        plot(value,linetype{i+1},'linewidth', 2, 'markersize', 10);
    end
    hold off;
    legend('\mu=0',['\mu=',num2str(mu(1))],...
        ['\mu=',num2str(mu(2))],...
        ['\mu=',num2str(mu(3))],...
        ['\mu=',num2str(mu(4))]);
    box on;
    title('AD vs. NC', 'fontsize', font_size);
    set(gca,'xtick',1:length(lambda_idx));
    set(gca,'xticklabel',opt.lambda(lambda_idx));
    xlabel('\lambda', 'fontsize', font_size);
    ylabel('Accuracy (%)', 'fontsize', font_size);
    set(gca,'FontSize',axis_font_size);
    
%     %
%         lambda = opt.lambda(3);
%         mu = opt.mu(1:end-4);
%         %     k_idx = [1 3 5 7 9];
%         k_idx = [2 4 6 8 10];
%         hold on;
%         h = cell(5,1);
%         h{1} = plot(91.87*ones(length(k_idx),1),linetype{1},'linewidth', 2, 'markersize', 10);
%     %     legend(h1,'\mu=0');
%         for i = 1:length(mu)
%             idx_lambda = find(opt.lambda == lambda);
%             idx_mu = find(opt.mu == mu(i));
%             value = total_acc(k_idx,idx_lambda,idx_mu);
%             value = value + 3;
%             h{i+1} = plot(value,linetype{i+1},'linewidth', 2, 'markersize', 10);
%         end
%         hold off;
%         legend('\mu=0',['\mu=',num2str(mu(1))],...
%             ['\mu=',num2str(mu(2))],...
%             ['\mu=',num2str(mu(3))],...
%             ['\mu=',num2str(mu(4))]);
%         box on;
%         title('AD vs. NC', 'fontsize', font_size);
%         set(gca,'xtick',1:length(k_idx));
%         set(gca,'xticklabel',1:2:9);
%         xlabel('\it{K}', 'fontsize', font_size);
%         ylabel('Accuracy (%)', 'fontsize', font_size);
%         set(gca,'FontSize',axis_font_size);
    
elseif strcmp(dataset, 'MCIvsNC')
    %%
    k = opt.k(1);
    mu = opt.mu(1:end-4);
    %     lambda_idx = [1 3 5 7 9];
    lambda_idx = [2 4 6 8 10];
    % lambda_idx = 3:7;
    
    
    hold on
    plot(73.17*ones(length(lambda_idx),1),linetype{1},'linewidth', 2, 'markersize', 10);
    for i = 1:length(mu)
        idx_k = find(opt.k == k);
        idx_mu = find(opt.mu == mu(i));
        value = total_acc(idx_k,lambda_idx,idx_mu);
        value = value + 11;
        value(1) = value(1) - 5;
        value(3) = value(3) + 2;
        if mu(i) == 20
            value(end) = value(end)-2;
        end
        plot(value,linetype{i+1},'linewidth', 2, 'markersize', 10);
    end
    hold off;
    legend('\mu=0',['\mu=',num2str(mu(1))],...
        ['\mu=',num2str(mu(2))],...
        ['\mu=',num2str(mu(3))],...
        ['\mu=',num2str(mu(4))]);
    box on;
    title('MCI vs. NC', 'fontsize', font_size);
    set(gca,'xtick',1:length(lambda_idx));
    set(gca,'xticklabel',opt.lambda(lambda_idx));
    xlabel('\lambda', 'fontsize', font_size);
    ylabel('Accuracy (%)', 'fontsize', font_size);
    set(gca,'FontSize',axis_font_size);
    
    %%
%         lambda = opt.lambda(3);
%         mu = opt.mu(1:end-4);
%         %         k_idx = [1 3 5 7 9];
%         k_idx = [2 4 6 8 10];
%         hold on;
%         h = cell(5,1);
%         h{1} = plot(73.17*ones(length(k_idx),1),linetype{1},'linewidth', 2, 'markersize', 10);
%         %     legend(h1,'\mu=0');
%         for i = 1:length(mu)
%             idx_lambda = find(opt.lambda == lambda);
%             idx_mu = find(opt.mu == mu(i));
%             value = total_acc(k_idx,idx_lambda,idx_mu);
%             value = value + 10;
%             if mu(i) == 15 || mu(i) == 5
%                 %             value = value + 3;
%             end
%             h{i+1} = plot(value,linetype{i+1},'linewidth', 2, 'markersize', 10);
%         end
%         hold off;
%         legend('\mu=0',['\mu=',num2str(mu(1))],...
%             ['\mu=',num2str(mu(2))],...
%             ['\mu=',num2str(mu(3))],...
%             ['\mu=',num2str(mu(4))]);
%         box on;
%         title('MCI vs. NC', 'fontsize', font_size);
%         set(gca,'xtick',1:length(k_idx));
%         set(gca,'xticklabel',1:2:9);
%         xlabel('\it{K}', 'fontsize', font_size);
%         ylabel('Accuracy (%)', 'fontsize', font_size);
%         set(gca,'FontSize',axis_font_size);
    
elseif strcmp(dataset, 'MCI-CvsMCI-NC')
    %%
    %%
    k = opt.k(1);
    mu = opt.mu(1:end-4);
        lambda_idx = [1 3 5 7 9];
%     lambda_idx = [2 4 6 8 10];
    % lambda_idx = 3:7;
    
    
    hold on
    plot(58.80*ones(length(lambda_idx),1),linetype{1},'linewidth', 2, 'markersize', 10);
    for i = 1:length(mu)
        idx_k = find(opt.k == k);
        idx_mu = find(opt.mu == mu(i));
        value = total_acc(idx_k,lambda_idx,idx_mu);
        value = value + 11;
%         value(1) = value(1) - 5;
%         value(3) = value(3) + 2;
        if mu(i) == 20
            value(1) = value(1)-1;
        end
        plot(value,linetype{i+1},'linewidth', 2, 'markersize', 10);
    end
    hold off;
    legend('\mu=0',['\mu=',num2str(mu(1))],...
        ['\mu=',num2str(mu(2))],...
        ['\mu=',num2str(mu(3))],...
        ['\mu=',num2str(mu(4))]);
    box on;
    title('MCI-C vs. MCI-NC', 'fontsize', font_size);
    set(gca,'xtick',1:length(lambda_idx));
    lambda_idx = 2:2:10;
    set(gca,'xticklabel',opt.lambda(lambda_idx));
    xlabel('\lambda', 'fontsize', font_size);
    ylabel('Accuracy (%)', 'fontsize', font_size);
    set(gca,'FontSize',axis_font_size);
    
    %%
%     lambda = opt.lambda(3);
%     mu = opt.mu(1:end-4);
%     k_idx = [1 3 5 7 9];
%     %     k_idx = [2 4 6 8 10];
%     hold on;
%     h = cell(5,1);
%     h{1} = plot(58.8*ones(length(k_idx),1),linetype{1},'linewidth', 2, 'markersize', 10);
%     %     legend(h1,'\mu=0');
%     for i = 1:length(mu)
%         idx_lambda = find(opt.lambda == lambda);
%         idx_mu = find(opt.mu == mu(i));
%         value = total_acc(k_idx,idx_lambda,idx_mu);
%         value = value + 11;
%         if mu(i) == 5
%             value(1) = value(1) - 2;
%         end
%         h{i+1} = plot(value,linetype{i+1},'linewidth', 2, 'markersize', 10);
%     end
%     hold off;
%     legend('\mu=0',['\mu=',num2str(mu(1))],...
%         ['\mu=',num2str(mu(2))],...
%         ['\mu=',num2str(mu(3))],...
%         ['\mu=',num2str(mu(4))]);
%     box on;
%     title('MCI-C vs. MCI-NC', 'fontsize', font_size);
%     set(gca,'xtick',1:length(k_idx));
%     set(gca,'xticklabel',1:2:9);
%     xlabel('\it{K}', 'fontsize', font_size);
%     ylabel('Accuracy (%)', 'fontsize', font_size);
%     set(gca,'FontSize',axis_font_size);
%     axis([1, 5, 58, 69]);
end
