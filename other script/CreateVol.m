%This script creates volumetric mat file from binary image automatically
%By Anis Maysami
%8 november
%type one:depth 22mm

%dir_img='F:\dars\master project\CreateDataset\mask_type_one\Img\mamo\';
%dir_img='F:\dars\master project\CreateDataset\mask_type_one\Img\benign\';
%dir_img='F:\dars\master project\CreateDataset\mask_type_one\Img\malignant\';
%dir_img='F:\dars\master project\CreateDataset\mask_type_two\Img\mamo\';
%dir_img='F:\dars\master project\CreateDataset\mask_type_one\Img\isic\';
dir_img='F:\dars\my article\English\1\added dataset\added_img\new_dir_img\resize_img\';
%dir_vol='F:\dars\master project\CreateDataset\mask_type_one\Vol\';
%dir_vol='F:\dars\master project\CreateDataset\mask_type_two\Vol\';
%dir_vol='F:\dars\master project\CreateDataset\mask_type_one\vol_2\';
dir_vol='F:\dars\my article\English\1\added dataset\added_vol\';
num=[3001:1:3593];
for i=1:1:length(num)
    %img = [dir_img,'new_mamography (',num2str(num(i)) ,').png'];
    %img = [dir_img,'new_ISIC_HAM10000_segmentation (',num2str(num(i)) ,').png'];
    %img = [dir_img,'new_benign_mask   (',num2str(num(i)) ,').png'];
    %img = [dir_img,'new_malignant_mask  (',num2str(num(i)) ,').png'];
    img = [dir_img,'new_augment_mamography (',num2str(num(i)) ,').png'];
    %volin=[dir_vol,'MaskTypeOne (',num2str(num(i)+3000) ,').mat'];
    %volin=[dir_vol,'new_benign_mask  (',num2str(num(i)) ,').mat'];
    %volin=[dir_vol,'new_malignant_mask  (',num2str(num(i)) ,').mat'];
    volin=[dir_vol,'augmentMaskTypeOne (',num2str(num(i)) ,').mat'];
    
    %type_one
     I=imread(img);
    vol=zeros(64,64,21);
    vol(:,:,22:42)=repmat(I,1,1,21);
    B=zeros(64,64,22);
    vol=cat(3,vol,B);
    %type_two
%     vol=zeros(64,64,33);
%     vol(:,:,34:54)=repmat(I,1,1,21);
%     B=zeros(64,64,10);
%     vol=cat(3,vol,B);
    save(volin,'vol');
end