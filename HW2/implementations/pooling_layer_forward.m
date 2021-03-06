function [output] = pooling_layer_forward(input, layer)

    h_in = input.height;
    w_in = input.width;
    c = input.channel;
    batch_size = input.batch_size;
    k = layer.k;
    pad = layer.pad;
    stride = layer.stride;


    h_out = (h_in + 2*pad - k) / stride + 1;
    w_out = (w_in + 2*pad - k) / stride + 1;
    assert(h_out == floor(h_out), 'h_out is not integer')
    assert(w_out == floor(w_out), 'w_out is not integer')


    output.height = h_out;
    output.width = w_out;
    output.channel = c;
    output.batch_size = batch_size;

    % Replace the following line with your implementation.
    output.data = zeros([h_out, w_out, c, batch_size]);
    for idx = 1:batch_size
        data = reshape(input.data(:, idx), [h_in, w_in, c]);
        pooling_values = [];
        for i = 1:stride:(h_in + 2*pad)
            for j = 1:stride:(w_in + 2*pad)
                mat = data(j:j+k-1, i:i+k-1, :);
                max_value = max(max(mat, [], 2), [], 1);
                pooling_values = [pooling_values, max_value];
            end
        end
        output.data(:, :, :, idx) =  reshape(pooling_values, [h_out, w_out, c]);
    end

    output.data = reshape(output.data, [h_out*w_out*c, batch_size]);
end

