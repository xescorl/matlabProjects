function [SOS_LP,G_LP,SOS_BP,G_BP,SOS_HP,G_HP] = retrieveSOS(filtersSOSfilename)
    filtersSOS = struct2cell(load(filtersSOSfilename,"-mat"));
    filtersSOS = filtersSOS{1,1};
    SOS_LP = filtersSOS{1,1}{1,1};
    G_LP = filtersSOS{1,1}{1,2};
    SOS_BP = filtersSOS{1,2}{1,1};
    G_BP = filtersSOS{1,2}{1,2};
    SOS_HP = filtersSOS{1,3}{1,1};
    G_HP = filtersSOS{1,3}{1,2};
end