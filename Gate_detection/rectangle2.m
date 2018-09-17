function lh=rectangle2(h,Xleft,Ytop,Xright,Ybot,c)
figure(h);
lh=line([Xleft Xright Xright Xleft Xleft],[Ytop Ytop Ybot Ybot Ytop],'color',c, 'LineWidth', 2);