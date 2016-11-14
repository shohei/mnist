function classify_by_em_algorithm

clear all;
close all;

global img;
global img2;
open_and_read_mnist();
binarize();

global uk;
init_generator();
global pk;
init_pickup_probability();

compute_generation_probability();
recreate_generator();

    function open_and_read_mnist
        fid=fopen('train-images-idx3-ubyte','r','b')
        magic_number = fread(fid,1,'int32')
        number_of_items = fread(fid, 1, 'int32')
        number_of_rows = fread(fid,1,'int32')
        number_of_columns = fread(fid,1,'int32')
        img = fread(fid, [28*28 60000],'uint8');
        img = reshape(img,28,28,60000);
        for idx=1:60000
            img2(:,:,idx)  = uint8(img(:,:,idx)');            
        end
    end

    function binarize
        thresh = 10;
        img2(img2<=thresh)=1;
        img2(img2>thresh)=0;
    end

    function init_generator
        for idx=1:10
            u = [];
            for jdx=1:784
                u(end+1) = round(rand(1));
            end
            u = reshape(u,[28,28]);
            uk(end+1)=u;
        end
    end

    function init_pickup_probability
        for idx=1:10
            pk(end+1)=1/10;
        end
    end

    function compute_generation_probability
        gamma_nk
    end

    function recreate_generator
    end



end