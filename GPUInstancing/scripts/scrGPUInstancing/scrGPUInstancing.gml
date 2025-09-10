/// @param							max_instance_amount																			   amount of instances
/// @param							instance_vertex_buffer																		   vertex buffer of the instance
/// @return							GPU Instancing object data
function gpu_instancing_create(max_instance_amount, instance_vertex_buffer) {
	var data = {
		imamount			:		max_instance_amount,																		// amount of instances (best to keep it as power of two)
		wmatrices			:		array_create(max_instance_amount * 16),														// array of world matrices for each vertex buffer
		combined_vbuffer	:		undefined,																					// combined vertex buffer
		vertex_format		:		undefined,																					// vertex format
		awaiting_buffer		:		undefined,																					// buffer that will be convertex to vertex buffer and be flushed after loading into gpu
		instance_buffer		:		buffer_create_from_vertex_buffer(instance_vertex_buffer, buffer_fixed, 1),					// buffer created from provided vertex buffer
		count				:		0																							// instance count
	};																															
																																
	vertex_format_begin();																										
	vertex_format_add_position_3d();																							
	vertex_format_add_normal();																									
	vertex_format_add_texcoord();																								
	vertex_format_add_color();																									
	vertex_format_add_custom(vertex_type_float1, vertex_usage_texcoord);														// ID of the mesh that vertex belongs to
	data.vertex_format = vertex_format_end();																					
																																
	return data;																												
};

/// @param							gpu_instancing_data																			   the data that is created using 'gpu_instancing_create(...)'
function gpu_instancing_add(gpu_instancing_data) {
	var data = gpu_instancing_data;
	var buffer_size = buffer_get_size(data.instance_buffer);
	var vertex_data_size = 36;
	var vertex_count = buffer_size / vertex_data_size;
	
	if (data.awaiting_buffer == undefined) {
		data.awaiting_buffer = buffer_create(buffer_size + buffer_sizeof(buffer_f32) * vertex_count, buffer_fixed, 1);
	}
	else {
		var buff_copy = buffer_create(buffer_get_size(data.awaiting_buffer) + buffer_size + buffer_sizeof(buffer_f32) * vertex_count, buffer_fixed, 1);
		buffer_copy(data.awaiting_buffer, 0, buffer_get_size(data.awaiting_buffer), buff_copy, 0);
		buffer_delete(data.awaiting_buffer);
		data.awaiting_buffer = buff_copy;
	};
	
	buffer_seek(data.instance_buffer, buffer_seek_start, 0);
	for (var i = buffer_get_size(data.awaiting_buffer) - (buffer_get_size(data.instance_buffer) + buffer_sizeof(buffer_f32) * vertex_count); i < buffer_get_size(data.awaiting_buffer); i += vertex_data_size + buffer_sizeof(buffer_f32)) {
		buffer_seek(data.awaiting_buffer, buffer_seek_start, i);
		
		repeat (3) {
			buffer_write(data.awaiting_buffer, buffer_f32, buffer_read(data.instance_buffer, buffer_f32));
		};
		
		repeat (3) {
			buffer_write(data.awaiting_buffer, buffer_f32, buffer_read(data.instance_buffer, buffer_f32));
		};
		
		repeat (2) {
			buffer_write(data.awaiting_buffer, buffer_f32, buffer_read(data.instance_buffer, buffer_f32));
		};
		
		repeat (4) {
			buffer_write(data.awaiting_buffer, buffer_u8, buffer_read(data.instance_buffer, buffer_u8));
		};
		
		buffer_write(data.awaiting_buffer, buffer_f32, data.count);
	};
	data.count++;
};

/// @param							gpu_instancing_data																			   the data that is created using 'gpu_instancing_create(...)'
/// @param							amount																						   amount of instances to add
function gpu_instancing_add_amount(gpu_instancing_data, amount) {
	repeat (amount) {
		gpu_instancing_add(gpu_instancing_data);
	};
};

/// @param							gpu_instancing_data																			   the data that is created using 'gpu_instancing_create(...)'
function gpu_instancing_build(gpu_instancing_data) {
	data.combined_vbuffer = vertex_create_buffer_from_buffer(data.awaiting_buffer, data.vertex_format);
	buffer_delete(data.awaiting_buffer);
};

/// @param							gpu_instancing_data																			   the data that is created using 'gpu_instancing_create(...)'
/// @param							world_matrices																				   world matrices to send to the shader
function gpu_instancing_update_matrices(gpu_instancing_data, world_matrices) {
	if (array_length(world_matrices) != gpu_instancing_data.imamount) {
		return;
	};
	
	for (var i = 0; i < gpu_instancing_data.imamount; i++) {
		array_copy(gpu_instancing_data.wmatrices, i * 16, world_matrices[i], 0, 16);
	};
};

/// @param							gpu_instancing_data																			   the data that is created using 'gpu_instancing_create(...)'
/// @param							world_matrix																				   world matrices to send to the shader
/// @param							index																						   index of the matrix in the array
function gpu_instancing_update_matrices_set(gpu_instancing_data, world_matrix, index) {
	array_copy(gpu_instancing_data.wmatrices, index * 16, world_matrix, 0, 16);
};

/// @param							gpu_instancing_data																			   the data that is created using 'gpu_instancing_create(...)'
/// @param							matrices_uniform_name																		   name of the max matrices uniform array in the shader
function gpu_instancing_draw(gpu_instancing_data, matrices_uniform_name) {
	var data = gpu_instancing_data;
	
	shader_set_uniform_matrix_array(shader_get_uniform(shader_current(), matrices_uniform_name), data.wmatrices);
	vertex_submit(data.combined_vbuffer, pr_trianglelist, -1);
};

/// @param							gpu_instancing_data																			   the data that is created using 'gpu_instancing_create(...)'
function gpu_instancing_free(gpu_instancing_data) {
	vertex_delete_buffer(gpu_instancing_data.combined_vbuffer);
	vertex_format_delete(gpu_instancing_data.vertex_format);
};











































































