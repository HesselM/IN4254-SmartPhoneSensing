function x = auto_cor(signal,m,t)	
    y = 0;
    mean1 = mean(signal(m:m+t-1));
    mean2 = mean(signal(m+t):m+t+t-1);
	for k = 0:t-1
		y = y + (signal(m+k)-mean1)*(signal(m+k+t)-mean2);
	end  
     x = y / (t*std(signal(m:m+t-1)) * std(signal(m+t:m+t+t-1)));
end
