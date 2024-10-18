 function [value] = re_scale(map)
        minn = min(map(:));
        maxx=max(map(:));
        if maxx ==0 && minn ==0
         value = map;
        else
        value=(map-minn)/(maxx-minn);
        end
        
    end