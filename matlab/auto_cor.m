function x = auto_cor(sign,m,t)	
    y = 0;
	for k = 0:t-1
		y = y + (sign(m+k)-mad(sign(m-t:m)))*(sign(m+k+t)-mad(sign(m:m+t)));
	end  
     x = y / t*std(sign(m-t:m))* std(sign(m:m+t));
end
