function x = auto_cor(sign,m,t)	
    y = 0;
    mean1 = mean(sign(m:m+t));
    mean2 = mean(sign(m+t:m+t+t));
	for k = 0:t-1
		y = y + (sign(m+k)-mean1 )*(sign(m+k+t)-mean2);
	end  
     x = y / (t*std(sign(m:m+t))* std(sign(m+t:m+t+t)));
end
