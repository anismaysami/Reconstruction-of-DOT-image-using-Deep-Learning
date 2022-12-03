dir_old='F:\dars\my article\English\1\added dataset\added_img\new_dir_img\';
dir_img='F:\dars\my article\English\1\added dataset\added_img\new_dir_img\resize_img\';
for i=3001:1:3594
    x=imread([dir_old,'new_augment_mamography  (' num2str(i) ').png']);
    new_x=imresize(x,[64 64]);
    imwrite(new_x, [dir_img,'new_augment_mamography (' num2str(i) ').png']);
end