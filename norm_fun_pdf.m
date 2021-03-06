function f=norm_fun_pdf(x,mu,v,fun,varargin)
	% NORM_FUN_PDF Compute the pdf of a scalar function of a (multi)normal
	% variable.
	%
	% Abhranil Das <abhranil.das@utexas.edu>
	% Center for Perceptual Systems, University of Texas at Austin
	% If you use this code, please cite:
	% <a href="matlab:web('https://arxiv.org/abs/2012.14331')"
	% >A method to integrate and classify normal distributions</a>.
	%
	% Example:
	% mu=[1;2]; v=[1 0.5; 0.5 4];
	% fun=@(x,y) sin(x)+cos(y);
	% norm_fun_pdf(0.5,mu,v,fun)
	%
	% Required inputs:
	% x             point(s) to evaluate the cdf at
	% mu            normal mean as column vector
	% v             normal variance-covariance matrix
	% fun           scalar function of the normal, in one of two forms:
	%               • struct containing coefficients a2 (matrix), a1 (column
	%                 vector) and a0 (scalar) of a quadratic function:
	%                 x'*a2*x + a1'*x + a0 > 0
	%               • handle to a scalar-valued function
	%
	% Optional name-value inputs:
	% dx            step-size for numerically differentiating cdf
	% fun_span      scan radius (in Mahalanobis distance) for function.
	%               Default=5.
	% fun_resol     resolution of scanning (finding roots) of function.
	%               Default=100.
	% AbsTol        absolute tolerance for the output
	% RelTol        relative tolerance for the output
	%               The absolute OR the relative tolerance will be satisfied.
	%
	% Outputs:
	% f             pdf
	%
	% See also:
	% <a href="matlab:open(strcat(fileparts(which('integrate_normal')),filesep,'doc',filesep,'GettingStarted.mlx'))">Interactive demos</a>
	% norm_fun_cdf
	% norm_fun_inv
	
	% parse inputs
	parser=inputParser;
	parser.KeepUnmatched=true;
	addRequired(parser,'x',@isnumeric);
	addRequired(parser,'mu',@isnumeric);
	addRequired(parser,'v',@isnumeric);
	addRequired(parser,'fun',@(x) isstruct(x)|| isa(x,'function_handle'));
	addParameter(parser,'dx',1e-3,@(x) isreal(x) && isscalar(x) && (x>=0));
	
	parse(parser,x,mu,v,fun,varargin{:});
	dx=parser.Results.dx;
	
	if isa(fun,'function_handle')
		p_left=norm_fun_cdf(x-dx,mu,v,fun,varargin{:});
		p_right=norm_fun_cdf(x+dx,mu,v,fun,varargin{:});
		f=max((p_right-p_left)/(2*dx),0);
	elseif isstruct(fun)
		[lambda,m,delta,sigma,c]=gx2_params_norm_quad(mu,v,fun);
		f=gx2pdf(x,lambda,m,delta,sigma,c,varargin{:});
	end	
end