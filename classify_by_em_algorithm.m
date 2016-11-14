function classify_by_em_algorithm

clear all;
close all;

global img;
global img2;
open_and_read_mnist();
binarize();
global img3;
prepare_serialized_image();

global uk;
init_generator();
global pk;
init_pickup_probability();

global gamma_nk;

for idx=1:100
    compute_generation_probability();
    recreate_generator();
end

disp 'comutation done';

save_result();

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

    function prepare_serialized_image
        img3 = reshape(img2,[28*28 60000]);
    end

    function init_generator
        for k=1:10
            u = [];
            for jdx=1:784
                u(end+1) = round(rand(1));
            end
            uk(:,end+1)=u;
        end
        uk = reshape(uk,[28*28 10]);
    end

    function init_pickup_probability
        for idx=1:10
            pk(end+1)=1/10;
        end
    end

    function compute_generation_probability        
        for k=1:10
            puk = [];
            for n=1:60000
                puk(k,n)=1;
                for pixel=1:28*28
                    puk(k,n) = puk(k,n) * uk(pixel,k)^img3(pixel,n) * (1-uk(pixel,k))^(1-img3(pixel,n));
                end
            end
            denominator = 0;
            denominator = denominator + pk(k)*puk(k,n);
            gamma_nk(k,n) = pk(k)*puk(k,n)/denominator;
            disp( sprintf( 'cycle %d done!', k ) );
        end    
    end

    global count=0;
    function recreate_generator
        numerator = 0;
        denominator = 0;
        for k=1:10
            for n=1:60000
                numerator = numerator + gamma_nk(k,n)*img3(:,n);
                denominator = denominator + gamma_nk(k,n);
            end
            uk(:,k) = numerator / denominator;
            pk(k) = denominator/60000;            
        end                
        count = count+1;
        disp( sprintf( '** Epoch %d finished. **', k ) );
    end

    function save_result
        save('',pk,uk);
    end


end