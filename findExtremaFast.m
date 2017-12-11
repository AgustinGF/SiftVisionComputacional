function[x, y] = findExtremaFast(array, WL, HL, centerlevel)
    level=squeeze(array(centerlevel,:,:));
    up = squeeze(array(centerlevel+1,:,:));
	down = squeeze(array(centerlevel-1,:,:));
    sy=WL;
    sx=HL;

    local_maxima=(level(2:sx-1,2:sy-1)>level(1:sx-2,1:sy-2))&(level(2:sx-1,2:sy-1) > level(1:sx-2,2:sy-1) )&(level(2:sx-1,2:sy-1)>level(1:sx-2,3:sy))&(level(2:sx-1,2:sy-1)>level(2:sx-1,1:sy-2))& (level(2:sx-1,2:sy-1)>level(2:sx-1,3:sy))& (level(2:sx-1,2:sy-1)>level(3:sx,1:sy-2))&(level(2:sx-1,2:sy-1)>level(3:sx,2:sy-1))&(level(2:sx-1,2:sy-1)>level(3:sx,3:sy)) ;
    local_maxima=local_maxima & (level(2:sx-1,2:sy-1)>up(1:sx-2,1:sy-2)) & ( level(2:sx-1,2:sy-1) > up(1:sx-2,2:sy-1) ) & (level(2:sx-1,2:sy-1)>up(1:sx-2,3:sy)) & (level(2:sx-1,2:sy-1)>up(2:sx-1,1:sy-2)) & (level(2:sx-1,2:sy-1)>up(2:sx-1,2:sy-1)) & (level(2:sx-1,2:sy-1)>up(2:sx-1,3:sy)) &(level(2:sx-1,2:sy-1)>up(3:sx,1:sy-2))&(level(2:sx-1,2:sy-1)>up(3:sx,2:sy-1)) & (level(2:sx-1,2:sy-1)>up(3:sx,3:sy)) ;
    local_maxima=local_maxima&(level(2:sx-1,2:sy-1)>down(1:sx-2,1:sy-2)) & ( level(2:sx-1,2:sy-1) > down(1:sx-2,2:sy-1) ) & (level(2:sx-1,2:sy-1)>down(1:sx-2,3:sy)) & (level(2:sx-1,2:sy-1)>down(2:sx-1,1:sy-2)) &(level(2:sx-1,2:sy-1)>down(2:sx-1,2:sy-1)) & (level(2:sx-1,2:sy-1)>down(2:sx-1,3:sy)) &(level(2:sx-1,2:sy-1)>down(3:sx,1:sy-2)) & (level(2:sx-1,2:sy-1)>down(3:sx,2:sy-1)) & (level(2:sx-1,2:sy-1)>down(3:sx,3:sy)) ;

 %look for a local minima
 local_minima=(level(2:sx-1,2:sy-1)>level(1:sx-2,1:sy-2)) & ( level(2:sx-1,2:sy-1) > level(1:sx-2,2:sy-1) ) & (level(2:sx-1,2:sy-1)>level(1:sx-2,3:sy)) & (level(2:sx-1,2:sy-1)>level(2:sx-1,1:sy-2))& (level(2:sx-1,2:sy-1)>level(2:sx-1,3:sy)) &(level(2:sx-1,2:sy-1)>level(3:sx,1:sy-2)) &(level(2:sx-1,2:sy-1)>level(3:sx,2:sy-1)) & (level(2:sx-1,2:sy-1)>level(3:sx,3:sy)) ;
 local_minima=local_minima & (level(2:sx-1,2:sy-1)>up(1:sx-2,1:sy-2)) & ( level(2:sx-1,2:sy-1) > up(1:sx-2,2:sy-1) ) & (level(2:sx-1,2:sy-1)>up(1:sx-2,3:sy)) & (level(2:sx-1,2:sy-1)>up(2:sx-1,1:sy-2)) &(level(2:sx-1,2:sy-1)>up(2:sx-1,2:sy-1)) & (level(2:sx-1,2:sy-1)>up(2:sx-1,3:sy)) & (level(2:sx-1,2:sy-1)>up(3:sx,1:sy-2)) & (level(2:sx-1,2:sy-1)>up(3:sx,2:sy-1)) &(level(2:sx-1,2:sy-1)>up(3:sx,3:sy)) ;
 local_minima=local_minima & (level(2:sx-1,2:sy-1)>down(1:sx-2,1:sy-2)) &( level(2:sx-1,2:sy-1) > down(1:sx-2,2:sy-1) ) & (level(2:sx-1,2:sy-1)>down(1:sx-2,3:sy)) & (level(2:sx-1,2:sy-1)>down(2:sx-1,1:sy-2)) &(level(2:sx-1,2:sy-1)>down(2:sx-1,2:sy-1)) & (level(2:sx-1,2:sy-1)>down(2:sx-1,3:sy)) & (level(2:sx-1,2:sy-1)>down(3:sx,1:sy-2)) &(level(2:sx-1,2:sy-1)>down(3:sx,2:sy-1)) & (level(2:sx-1,2:sy-1)>down(3:sx,3:sy)) ;

 
 extrema=local_maxima | local_minima;
 [x,y]=find(extrema);
end