function plot_boundary(reg_ray_scan,dim,varargin)
parser = inputParser;
addRequired(parser,'reg_ray_scan',@(x) isa(x,'function_handle'));
addRequired(parser,'dim',@(x) (x==1)||(x==2)||(x==3) );
addParameter(parser,'orig',zeros(dim,1), @(x) isnumeric(x));
addParameter(parser,'n_rays',1e4,@(x) isnumeric(x));
parse(parser,reg_ray_scan,dim,varargin{:});
orig=parser.Results.orig;
n_rays=parser.Results.n_rays;

% Create grid of unit vectors
if dim==1
    n=1;
elseif dim==2
    dth=pi/n_rays;
    th=0:dth:pi;
    n=[cos(th);sin(th)];
elseif dim==3
    n=fibonacci_sphere(n_rays);
end

[~,x]=reg_ray_scan(n,orig);
bd_pts_rel=cellfun(@(x,y) x.*y,x,num2cell(n,1),'un',0); % convert to co-ordinates
bd_pts=horzcat(bd_pts_rel{:})+orig;

if dim==1
    for x=bd_pts
        xline(x,'linewidth',1);
    end
elseif dim==2
     plot(bd_pts(1,:),bd_pts(2,:),'.k','markersize',3)
elseif dim==3
    plot3(bd_pts(1,:),bd_pts(2,:),bd_pts(3,:),'.k','markersize',1);
    grid on
end