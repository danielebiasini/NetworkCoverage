mappa2=zeros(500,500);
dim_mappa2=size(mappa2);

Q=0;
W=0;

for x=1:3:1500
    W=W+1;
    Q=0;
    for y=1:3:1500
          Q=Q+1;
          disp(['iterazione x=' num2str(x) ' y= ' num2str(y)]);
          n=[mappa2(y,x),mappa2(y,x+1),mappa2(y,x+2),...
               mappa2(y+1,x),mappa2(y+1,x+1),mappa2(y+1,x+2),...
               mappa2(y+2,x),mappa2(y+2,x+1),mappa2(y+2,x+2)];
          V=find(n);
          dim_V=size(V);
          if dim_V>=1
              h0=find(n==0);
              h15=find(n==15);
              h13=find(n==13);
              h7=find(n==7);
              h17=find(n==17);
              h3=find(n==3);
              h6=find(n==6);
              h10=find(n==10);
              dim=[size(h0,2),size(h15,2),size(h13,2),size(h7,2),size(h17,2),size(h3,2),...
                    size(h6,2),size(h10,2)];
              [~,CO]=max(dim);
              switch CO
                  case 1
                      mappa1(Q,W)=0;
                  case 2
                      mappa1(Q,W)=15;
                  case 3
                      mappa1(Q,W)=13;
                  case 4
                      mappa1(Q,W)=7;
                  case 5
                      mappa1(Q,W)=17;
                  case 6
                      mappa1(Q,W)=3;
                  case 7
                      mappa1(Q,W)=6;
                  case 8
                      mappa1(Q,W)=10;
              end
              
          end
    end
end

save mappa_pixel_3
figure
image(mappa1)
colormap(gca, flipud(gray(max(max(mappa1)))));
title('Mappa zona Roma');
xLabel('PIXEL - 1pixel=3m -')
yLabel('PIXEL - 1pixel=3m -')

figure
image(mappa2)
colormap(gca, flipud(gray(max(max(mappa1)))));
title('Mappa zona Roma');
xLabel('PIXEL - 1pixel=1m -')
yLabel('PIXEL - 1pixel=1m -')