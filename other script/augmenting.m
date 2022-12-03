%This script make augment images
%By Anis Maysami
%20 April 2022
dir_img='F:\dars\master project\MY DATASET\my_data\augment_img_mamo\';
dir_new_img='F:\dars\master project\MY DATASET\my_data\augment_img_mamo\new_dir_img\';

for i=225:1:236%start from 221
    img_file=[dir_img,'augment_mamography (',num2str(i),').png'];
    img=imread(img_file);
    for j=1:1:20
      a=input('please enter something:  ','s');
    
      if a=='n'
         break;
      end
      
      cropped_img=imcrop(img);
      cropped_name=[dir_new_img,'new_augment_mamography (',num2str(i),')(',num2str(j),').png'];
      imwrite(cropped_img,cropped_name);
    end

    for k=1:1:20
      b=input('please enter something:  ','s');
    
      if b=='n'
        break;
      end
      angle=[90,180,270];
      for l=1:1:length(angle)
         rotated_img=imrotate(img,angle(l));
         rot_crop_img=imcrop(rotated_img);
         rotated_name=[dir_new_img,'new_augment_mamography (',num2str(i),')(',num2str(k+j-1),')(',num2str(l),').png'];
         imwrite(rot_crop_img,rotated_name);
      end
    end
    
end

    