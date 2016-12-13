function x_t = unframe( x_mat, hop_size )
%x_t = unframe( x_mat, hop_size )
%   does over lap and add on a signal matrix, treating each column as a
%   window. hop_size is in samples
[w_size, w_n] = size(x_mat);

x_length = w_size + hop_size * (w_n-1);
x_t = zeros(1,x_length);

for n = 0:(w_n-1)
    offset = n * hop_size;
    x_t( (1+offset) : (w_size+offset) ) = x_mat(:,n+1)' + x_t( (1+offset) : (w_size+offset) ); %OLA
end

