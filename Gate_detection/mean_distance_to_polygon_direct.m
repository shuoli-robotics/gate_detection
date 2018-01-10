function fit = mean_distance_to_polygon_direct(genome, params, weights)
% function fit = mean_distance_to_polygon_direct(genome, params, weights)

[im_coords, visible] = translate_direct_genome_to_image_coords(genome);
fit = mean_distance_to_polygon(im_coords, visible, params, weights);