function do_classify

global img;
global img2;
open_and_read_mnist();
binarize();
global img3;
prepare_serialized_image();

classify_image(img3(:,1));
% classify_image(img3(:,2));
% classify_image(img3(:,3));
% classify_image(img3(:,4));
% classify_image(img3(:,5));
% classify_image(img3(:,6));

disp 'stop here.';


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

    function classify_image(input)
        for k=1:10
            puk = [];
            puk(k)=1;
            for pixel=1:28*28
                puk(k) = puk(k) * uk(pixel,k)^input(pixel) * (1-uk(pixel,k))^(1-input(pixel));
            end
            denominator = 0;
            denominator = denominator + pk(k)*puk(k);
            gamma_nk(k) = pk(k)*puk(k)/denominator;
        end    
        [maximum,index]=max(gamma_nk(:));
        disp( sprintf( 'input number classified as %d !', index ) );        
    end





end