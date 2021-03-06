%%
%%Principal Component Analysis with Image Compression
clear all;clc; 
%Take in any image
fullImage = imread('312.jpg'); 

%Convert the image to Grayscale. If the image is not grayscale, we will 
%have a 3 dimensional matrix. For the purposes of this assignment, we will 
%only be looking at a 2 dimensional matrix.
greyImage = rgb2gray(fullImage);  

%Convert image data to double for processing (currently an unsigned int)
image = im2double(greyImage);     

%Show original figure for comparison
figure(1)
    imshow(image)
    axis off

%Find the emperical mean along each dimension. Put in 1 dimensional matrix
columnMean = mean(image);   

%Find the dimensions (actually the image resolution) of the image
[m,n] = size(greyImage); 

%Create a matrix of the means, where each row is the computed means
%(above), and the number of rows is the number of rows in our image
means = repmat(columnMean,m,1); 

%Subtract the means from every row to find the deviations from the mean.
meanDeviations = image - means; 

%Generate a covariance matrix from the deviations from the mean
covariance = cov(meanDeviations);   

%Find the eigenvalues (D) and eigenvectors (V) of the covariance matrix
%*Eigenvalues are in ASCENDING order! This is important in the next steps*
[V,D] = eig(covariance); 

%Pick a number of components, subtract it from the number of columns.
components = n - 2;                                                     
principalVectors = V;

%Clear from left to right (ascending) the vectors we do not want.
for i = 1:components,                                                         
principalVectors(:,1) =[]; 
end 

%%
%%Image Processing!

%Now multiply the principle vectors by the means of each row!
compressedImage=principalVectors*(principalVectors' * meanDeviations.');

%Then, add the means!
compressedImage=compressedImage'+means;

%Draw the final image
    figure(2)     
    imshow(compressedImage)
    axis off
    
 %%
 %Error
 %{
 iterations = 200;
 iterationsMatrix=zeros(iterations,2);
 
 for i=1:iterations
    components = n - i;                                                     
    principalVectors = V;
    for k = 1:components,                                                         
    principalVectors(:,1) =[]; 
    end 
   
    compressedImage=principalVectors*(principalVectors' * meanDeviations.');

    compressedImage=compressedImage'+means;
    iterationsMatrix(i,2)=norm(image-compressedImage);
    iterationsMatrix(i,1)=i;

 end
 
 figure(3)
    plot(iterationsMatrix(1:200,1),iterationsMatrix(1:200,2));
    
    title('Normalized Error vs Number of components used')
    xlabel('Components used')
    ylabel('Normalized Error')
 %}
 
%%
%Information Lost

 iterations = 200;
 totalsum = sum(sum(D,2));
 lostInfoMatrix=zeros(iterations,2);
 for i=1:iterations
    components = n - i;                                                     
    eigenValues = D;
    for k = 1:components,     
    eigenValues(:,1) =[]; 
    end 
    
    lostInfoMatrix(i,1)=(sum(sum(eigenValues,2))/totalsum)*100;
    lostInfoMatrix(i,2)=201-i;

    
 end
 
 figure(3)
    plot(lostInfoMatrix(1:200,2),lostInfoMatrix(1:200,1));
    title('Information lost with different number of components')
    xlabel('Components used')
    ylabel('Information Lost')