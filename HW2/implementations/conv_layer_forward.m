function [output] = conv_layer_forward(input, layer, param)
    % Conv layer forward
    % input: struct with input data
    % layer: convolution layer struct
    % param: weights for the convolution layer

    % output:

    h_in = input.height;
    w_in = input.width;
    c = input.channel;
    batch_size = input.batch_size;
    k = layer.k;
    pad = layer.pad;
    stride = layer.stride;
    num = layer.num;
    % resolve output shape
    h_out = (h_in + 2*pad - k) / stride + 1;
    w_out = (w_in + 2*pad - k) / stride + 1;

    output.height = h_out;
    output.width = w_out;
    output.channel = num;
    output.batch_size = batch_size;

    assert(h_out == floor(h_out), 'h_out is not integer')
    assert(w_out == floor(w_out), 'w_out is not integer')
    input_n.height = h_in;
    input_n.width = w_in;
    input_n.channel = c;

    %% Fill in the code
    % Iterate over the each image in the batch, compute response,
    % Fill in the output datastructure with data, and the shape.
    output.data = zeros([h_out, w_out, num, batch_size]);
    for idx = 1:batch_size
        data = reshape(input.data(:, idx), [h_in, w_in, c]);
        convol_array = zeros([h_out, w_out, num]);
        for n = 1:num
            w = reshape(param.w(:, n), [k, k, c]);
            b = param.b(:, n);
            for i = 1:h_out
                for j = 1:w_out
                    region = data(i:i+k-1, j:j+k-1, :);
                    % convol_array(i, j, n) = sum(times(region, w), 'all') + b;
                    convol_array(i, j, n) = sum(times(region, w)(:)) + b;
                end
            end
        end
        output.data(:, :, :, idx) = convol_array;
    end

    output.data = reshape(output.data, [h_out*w_out*num, batch_size]);
end
