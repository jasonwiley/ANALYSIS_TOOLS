function system=Extract_XML_DCD(XML_filename,DCD_filename,savename,timesteps)
%Extract_XML_DCD(XML_filename,DCD_filename,savename,timesteps)
% timesteps=0 extracts all time steps

fid=fopen(XML_filename);

y='NO';
while strcmp(y,'NO')
    x=fgetl(fid);
    if strcmp(x(1:3),'</h')
        y='YES';
    end
    
    % Box Size
   if strcmp(x(1:4),'<box')
        A=strread(x,'%s');
        [row col]=size(A);
        for i=1:row
            if A{i}(1)=='l'
                [row2 col2]=size(A{i});
                if A{i}(col2)=='>'
                    col2=col2-2;
                end
                if A{i}(2)=='x'
                    xdim=str2double(A{i}(5:col2-1));
                elseif A{i}(2)=='y'
                    ydim=str2double(A{i}(5:col2-1));
                elseif A{i}(2)=='z'
                    zdim=str2double(A{i}(5:col2-1));
                end
            end
        end
   end
   
%    Position
   if strcmp(x(1:4),'<pos')
%        if exist('nat')
%        else
           [row col]=size(x);
           if x(col)==' '
               nat=str2double(x(16:col-4));
           else
               nat=str2double(x(16:col-2));
           end
%        end
       x=textscan(fid,'%f %f %f',nat,'CollectOutput',1);
       pos=x{1};
       x=fgetl(fid);
       x=fgetl(fid);
   end
   
   % Type
   if strcmp(x(1:4),'<typ')
       if exist('nat')
       else
           [row col]=size(x);
           nat=str2double(x(12:col-2));
       end
       x=textscan(fid,'%s',nat,'CollectOutput',1);
       attype=char(x{1});
       x=fgetl(fid);
       x=fgetl(fid);
   end
   
   %bond
   if strcmp(x(1:4),'<bon')
       [row col]=size(x);
       if col>12
           nbond=str2double(x(12:col-2));
           x=textscan(fid,'%s %f %f',nbond,'CollectOutput',1);
           bonds=x{2};
           x=fgetl(fid);
           x=fgetl(fid);
       else
           bonds=zeros(nat,2);
           i=1;
           x=fgetl(fid);
           while strcmp(x(1:4),'poly')
               A=strread(x,'%s');
               bonds(i,1)=str2double(A{2});
               bonds(i,2)=str2double(A{3});
               x=fgetl(fid);
               i=i+1;
           end
           bonds=bonds(1:i-1,:);
       end 
   end

   %angle
   if strcmp(x(1:4),'<ang')
       [row col]=size(x);
       if col>13
           nangle=str2double(x(13:col-2));
           x=textscan(fid,'%s %f %f %f',nangle,'CollectOutput',1);
           angles=x{2};
           x=fgetl(fid);
           x=fgetl(fid);
       else
           angles=zeros(nat,3);
           i=1;
           x=fgetl(fid);
           while strcmp(x(1:4),'</an')==0
               A=strread(x,'%s');
               angles(i,1)=str2double(A{2});
               angles(i,2)=str2double(A{3});
               angles(i,3)=str2double(A{4});
               x=fgetl(fid);
               i=i+1;
           end
           angles=angles(1:i-1,:);
       end 
   end
   
   % Body
   if strcmp(x(1:4),'<bod')
       x=textscan(fid,'%f',nat,'CollectOutput',1);
       x=fgetl(fid);
       x=fgetl(fid);
   end
   
   % Diameter
   if strcmp(x(1:4),'<dia')
       x=textscan(fid,'%f',nat,'CollectOutput',1);
       x=fgetl(fid);
       x=fgetl(fid);
   end
   
   % Mass
   if strcmp(x(1:4),'<mas')
       x=textscan(fid,'%f',nat,'CollectOutput',1);
       mass=x{1};
       x=fgetl(fid);
       x=fgetl(fid);
   end
   
   %image
   if strcmp(x(1:4),'<ima')
       x=textscan(fid,'%f %f %f',nat,'CollectOutput',1);
       x=fgetl(fid);
       x=fgetl(fid);
   end
   
   %charge
   if strcmp(x(1:4),'<cha')
       x=textscan(fid,'%f %f %f',nat,'CollectOutput',1);
       x=fgetl(fid);
       x=fgetl(fid);
   end
end

clear 'pos'
pos=readdcd(DCD_filename,timesteps);
dim=[xdim ydim zdim];
systemcompress_script;
if savename~=0
    save_simulation;
end
    
fclose('all');
end