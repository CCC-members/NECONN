function [] = define_ico(hFigure)
warning off;
javaFrame    = get(hFigure,'JavaFrame');
iconFilePath = strcat('icon.GIF'); 
javaFrame.setFigureIcon(javax.swing.ImageIcon(iconFilePath));
warning on;
end