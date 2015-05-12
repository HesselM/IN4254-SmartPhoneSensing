function h = histogram(varargin)
%HISTOGRAM  Plots a histogram.
%   HISTOGRAM(X) plots a histogram of X. HISTOGRAM determines the bin edges 
%   using an automatic binning algorithm that returns uniform bins of a width 
%   that is chosen to cover the range of values in X and reveal the shape 
%   of the underlying distribution. 
%
%   HISTOGRAM(X,M), where M is a scalar, uses M bins.
%
%   HISTOGRAM(X,EDGES), where EDGES is a vector, specifies the edges of 
%   the bins.
%
%   The value X(i) is in the kth bin if EDGES(k) <= X(i) < EDGES(k+1). The 
%   last bin will also include the right edge such that it will contain X(i)
%   if EDGES(end-1) <= X(i) <= EDGES(end).
%
%   HISTOGRAM(...,'BinWidth',BW) uses bins of width BW. To prevent from 
%   accidentally creating too many bins, a limit of 65536 bins can be 
%   created when specifying 'BinWidth'. If BW is too small such that more 
%   than 65536 bins are needed, HISTOGRAM uses wider bins instead.
%
%   HISTOGRAM(...,'BinLimits',[BMIN,BMAX]) plots a histogram with only 
%   elements in X between BMIN and BMAX inclusive, X(X>=BMIN & X<=BMAX).
%
%   HISTOGRAM(...,'Normalization',NM) specifies the normalization scheme 
%   of the histogram values. The normalization scheme affects the scaling 
%   of the histogram along the vertical axis (or horizontal axis if 
%   Orientation is 'horizontal'). NM can be:
%                  'count'   The height of each bar is the number of 
%                            observations in each bin, and the sum of the
%                            bar heights is NUMEL(X).
%            'probability'   The height of each bar is the relative 
%                            number of observations (number of observations
%                            in bin / total number of observations), and
%                            the sum of the bar heights is 1.
%           'countdensity'   The height of each bar is the number of 
%                            observations in each bin / width of bin. The 
%                            area (height * width) of each bar is the number
%                            of observations in the bin, and the sum of
%                            the bar areas is NUMEL(X).
%                    'pdf'   Probability density function estimate. The height 
%                            of each bar is, (number of observations in bin)
%                            / (total number of observations * width of bin).
%                            The area of each bar is the relative number of
%                            observations, and the sum of the bar areas is 1.
%               'cumcount'   The height of each bar is the cumulative 
%                            number of observations in each bin and all
%                            previous bins. The height of the last bar
%                            is NUMEL(X).
%                    'cdf'   Cumulative density function estimate. The height 
%                            of each bar is the cumulative relative number
%                            of observations in each bin and all previous bins.
%                            The height of the last bar is 1.
%
%   HISTOGRAM(...,'DisplayStyle',STYLE) specifies the display style of the 
%   histogram. STYLE can be:
%                    'bar'   Display a histogram bar plot. This is the default.
%                 'stairs'   Display a stairstep plot, which shows the 
%                            outlines of the histogram without filling the 
%                            interior. 
%
%   HISTOGRAM(...,'BinMethod',BM), uses the specified automatic binning 
%   algorithm to determine the number and width of the bins. BM can be:
%                   'auto'   The default 'auto' algorithm chooses a bin 
%                            width to cover the data range and reveal the 
%                            shape of the underlying distribution.
%                  'scott'   Scott's rule is optimal if the data is close  
%                            to being normally distributed, but is also 
%                            appropriate for most other distributions. It 
%                            uses a bin width of 
%                            3.49*STD(X(:))*NUMEL(X)^(-1/3).
%                     'fd'   The Freedman-Diaconis rule is less sensitive  
%                            to outliers in the data, and may be more 
%                            suitable for data with heavy-tailed 
%                            distributions. It uses a bin width of 
%                            2*IQR(X(:))*NUMEL(X)^(-1/3), where IQR is the 
%                            interquartile range.
%               'integers'   The integer rule is useful with integer data, 
%                            as it creates a bin for each integer. It uses 
%                            a bin width of 1 and places bin edges halfway 
%                            between integers. To prevent from accidentally 
%                            creating too many bins, a limit of 65536 bins 
%                            can be created with this rule. If the data 
%                            range is greater than 65536, then wider bins
%                            are used instead.
%                'sturges'   Sturges' rule is a simple rule that is popular
%                            due to its simplicity. It chooses the number 
%                            of bins to be CEIL(1 + LOG2(NUMEL(X))).
%                   'sqrt'   The Square Root rule is another simple rule 
%                            widely used in other software packages. It 
%                            chooses the number of bins to be
%                            CEIL(SQRT(NUMEL(X))).
%
%   HISTOGRAM(...,NAME,VALUE) set the property NAME to VALUE. 
%     
%   HISTOGRAM(AX,...) plots into AX instead of the current axes.
%       
%   H = HISTOGRAM(...) also returns a histogram object. Use this to inspect 
%   and adjust the properties of the histogram.
%
%   Class support for inputs X, EDGES:
%      float: double, single
%      integers: uint8, int8, uint16, int16, uint32, int32, uint64, int64
%
%   See also HISTCOUNTS, matlab.graphics.chart.primitive.Histogram

%   Copyright 1984-2014 The MathWorks, Inc.

[cax,args] = axescheck(varargin{:});
narginchk(1,inf);
x = args{1};
args(1) = [];

validateattributes(x,{'numeric'},{'real'}, mfilename, 'x', 1)

[opts,args] = parseinput(args);

cax = newplot(cax);

[~,autocolor] = nextstyle(cax,true,false,false);
optscell = binspec2cell(opts); 
hObj = matlab.graphics.chart.primitive.Histogram('Parent', cax, ...
    'Data', x, 'AutoColor', autocolor, optscell{:}, args{:});
% disable brushing, basic fit, and data statistics
hbrush = hggetbehavior(hObj,'brush');  
hbrush.Enable = false;
hbrush.Serialize = true;
hdatadescriptor = hggetbehavior(hObj,'DataDescriptor');
hdatadescriptor.Enable = false;
hdatadescriptor.Serialize = true;

if ~ishold(cax)
    cax.Box = 'on';
end

if nargout > 0
    h = hObj;
end
end

function [opts,input] = parseinput(input)

opts = struct('NumBins',[],'BinEdges',[],'BinLimits',[],...
    'BinWidth',[],'Normalization','','BinMethod','auto');
funcname = mfilename;

% Parse second input in the function call
if ~isempty(input)
    in = input{1};
    numposinput = 0;
    if isnumeric(in)
        if isscalar(in)
            validateattributes(in,{'numeric'},{'integer', 'positive'}, ...
                funcname, 'm', 2)
            opts.NumBins = in;
            opts.BinMethod = [];
        else
            validateattributes(in,{'numeric'},{'vector','nonempty', ...
                'real', 'nondecreasing'}, funcname, 'edges', 2)
            opts.BinEdges = in;
            opts.BinMethod = [];
        end
        input(1) = [];
        numposinput = 1;
    end
    
    % All the rest are name-value pairs
    if rem(length(input),2) ~= 0
        error(message('MATLAB:histogram:ArgNameValueMismatch'))
    end
    
    inputlen = length(input);
    i=1;
    while i <= inputlen
        try 
            name = validatestring(input{i},{'NumBins','BinEdges','BinWidth',...
                'BinLimits', 'Normalization', 'BinMethod'}); 
        catch 
            % Do not process other options now
            i = i + 2;
            continue
        end
        value = input{i+1};
        switch name
            case 'NumBins'
                validateattributes(value,{'numeric'},{'scalar', ...
                    'integer', 'positive'}, funcname, 'NumBins', i+2+numposinput)
                opts.NumBins = value;
                if ~isempty(opts.BinEdges)
                    error(message('MATLAB:histogram:InvalidMixedBinInputs'))
                end
                opts.BinMethod = [];
                opts.BinWidth = [];
                input(i:i+1) = [];
                inputlen = inputlen - 2;
            case 'BinEdges'
                validateattributes(value,{'numeric'},{'vector', ...
                    'real', 'nondecreasing'}, funcname, 'BinEdges', i+2+numposinput);
                if length(value) < 2
                    error(message('MATLAB:histogram:EmptyOrScalarBinEdges'));
                end
                opts.BinEdges = value;
                opts.BinMethod = [];
                opts.BinWidth = [];
                opts.NumBins = [];
                opts.BinLimits = [];
                input(i:i+1) = [];
                inputlen = inputlen - 2;
            case 'BinWidth'
                validateattributes(value, {'numeric'}, {'scalar', 'real', ...
                    'positive', 'finite'}, funcname, 'BinWidth', i+2+numposinput);
                opts.BinWidth = value;
                if ~isempty(opts.BinEdges)
                    error(message('MATLAB:histogram:InvalidMixedBinInputs'))
                end
                opts.BinMethod = [];
                opts.NumBins = [];
                input(i:i+1) = [];
                inputlen = inputlen - 2;
            case 'BinLimits'
                validateattributes(value, {'numeric'}, {'numel', 2, 'real', ...
                    'nondecreasing', 'finite'}, funcname, 'BinLimits', i+2+numposinput)
                opts.BinLimits = value;
                if ~isempty(opts.BinEdges)
                    error(message('MATLAB:histogram:InvalidMixedBinInputs'))
                end
                input(i:i+1) = [];
                inputlen = inputlen - 2;
            case 'Normalization'
                opts.Normalization = validatestring(value, {'count', 'countdensity', 'cumcount',...
                    'probability', 'pdf', 'cdf'}, funcname, 'Normalization', i+2+numposinput);
                input(i:i+1) = [];
                inputlen = inputlen - 2;
            otherwise % 'BinMethod' 
                opts.BinMethod = validatestring(value, {'auto','scott', 'fd', ...
                    'integers', 'sturges', 'sqrt'}, funcname, 'BinMethod', i+2+numposinput);
                if ~isempty(opts.BinEdges)
                    error(message('MATLAB:histogram:InvalidMixedBinInputs'))
                end
                opts.BinWidth = [];
                opts.NumBins = [];
                input(i:i+1) = [];
                inputlen = inputlen - 2;
        end
    end
end
end

function binargs = binspec2cell(binspec)
% Construct a cell array of name-value pairs given a binspec struct
binspecn = fieldnames(binspec);  % extract field names
empties = structfun(@isempty,binspec);
binspec = rmfield(binspec,binspecn(empties));  % remove empty fields
binspecn = binspecn(~empties);
binspecv = struct2cell(binspec);
binargs = [binspecn binspecv]';
end

