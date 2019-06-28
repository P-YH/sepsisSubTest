function [score, label] = get_sepsis_score(data, model)
    
    num_rows = size(data,1);
    % process
    if num_rows<13
        current_data = data(:, 1:end);
        B = processInput(current_data);
    else
        current_data = data(num_rows-12:num_rows, 1:end);
        B = processInput(current_data);
    end
    
    % process data
    
    
    % evaluation
    
    %{
    imageSize = [224 224 3];
    imdTest = augmentedImageDatastore(imageSize,B);
    pred = predict(model.trainImResNet,imdTest);
    
    if pred(1)>pred(2)
        score = pred(1);
        label = 0;
    else
        score = pred(2);
        label = 1;
    end
    %}
    
    imageSize = [80 80 3];
    %{
    
    if num_rows<10
        imageSize = [224 224 3];
    else
        imageSize = [80 80 3];
    end    
    
    %}
    imdTest = augmentedImageDatastore(imageSize,B);
    
    pred = predict(model.long.trainImSeqNet,imdTest);
    %{
    if num_rows<9
        pred = predict(model.short.trainImshortSeqNet,imdTest);
        %pred = predict(model.long.trainImSeqNet,imdTest);
    else
        pred = predict(model.long.trainImSeqNet,imdTest);
    end
    %}
    
    
    
    listPred = cell2mat(pred);
    
    % intuitive
    %
     if listPred(1)>listPred(2)
        score = listPred(1);
        label = 0;
            
    else
        score = listPred(2);
        label = 1;
    end
    %}
    
    %{
    if num_rows<9
       listPred = cell2mat(pred);
        if listPred(1)>listPred(2)
            score = listPred(1);
            label = 0;
        else
            score = listPred(2);
            label = 1;
        end
    else
        listPred = cell2mat(pred);
        if listPred(1)>listPred(2)
            score = listPred(1);
            label = 0;
        else
            score = listPred(2);
            label = 1;
        end
    end
    %}
end

function Im = processInput(data)

procdata = fillmissing(data,'pchip');

proc2data = fillmissing(procdata,'constant',0);

resizeIm = imresize(proc2data,[227,227]);

% convert to an RGB image

cmap = jet(100);

maxVal = max(resizeIm(:));
minVal = min(resizeIm(:));
resizeIm = resizeIm - minVal;
resizeIm = ( resizeIm / (maxVal-minVal) ) * 99; % for jet(100)
resizeIm = resizeIm + 1;

resizeIm = round(resizeIm);
Im = reshape(cmap(resizeIm(:),:),[size(resizeIm),3]);
end