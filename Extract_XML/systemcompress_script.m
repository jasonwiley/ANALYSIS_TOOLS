if exist('chainstats','var')
    system=systemcompress(attype,bonds,dim,mass,pos,angles,chainstats);
else
    system=systemcompress(attype,bonds,dim,mass,pos,angles);
end