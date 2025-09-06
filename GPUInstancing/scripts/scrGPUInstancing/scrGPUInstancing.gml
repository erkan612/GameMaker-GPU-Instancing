/// @param							instance_amount																				  amount of instances
/// @param							target_shader																				  shader that will be used to draw
/// @param							uniform_name																				  name of the uniform that contains the matrices
/// @return							GPU Instancing object data
function gpu_instancing_create(instance_amount, target_shader, uniform_name) {
	var data = {
		iamount				:		instance_amount,																			// amount of instances (best to keep it as power of two)
		wmatrices			:		array_create(instance_amount * 16),															// array of world matrices for each vertex buffer
		shdMatrixArrUniform	:		shader_get_uniform(target_shader, uniform_name),											// uniform of the matrix array
		combined_vbuffer	:		undefined,																					// combined vertex buffer
		vertex_format		:		undefined,																					// vertex format
		awaiting_buffer		:		undefined																					// buffer that will be convertex to vertex buffer and be flushed after loading into gpu
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
																																
/// @param							gpu_instancing_data																			  the data that is created using 'gpu_instancing_create(...)'
/// @param							vertex_buffers																				  vertex buffers to load
function gpu_instancing_load(gpu_instancing_data, vertex_buffers) {																
	var vbuffers_size = array_length(vertex_buffers);																			
	var data = gpu_instancing_data;																								
	var total_vertex_amount = 0;																								
																																
	for (var i = 0; i < vbuffers_size; i++) {																					// vertex buffer index
		var vbuffer = vertex_buffers[i];																						
		var buffer = buffer_create_from_vertex_buffer(vbuffer, buffer_fixed, 1);												
		var buffer_size = buffer_get_size(buffer);																				
		var vertex_amount = buffer_size / 36;																					// position(xyz) + normal(xyz) + texcoord(xy) + colour(rgba as unorm8, 1 byte each)
		total_vertex_amount += vertex_amount;
		buffer_delete(buffer);
	};
	
	data.awaitingBuffer = buffer_create(data.iamount * (total_vertex_amount + buffer_sizeof(buffer_f32)), buffer_fixed, 1);		// extra buffer_f32 for ID
	buffer_seek(data.awaitingBuffer, buffer_seek_start, 0);
	
	for (var i = 0; i < vbuffers_size; i++) {																					// vertex buffer index
		var vbuffer = vertex_buffers[i];
		var buffer = buffer_create_from_vertex_buffer(vbuffer, buffer_fixed, 1);
		buffer_seek(buffer, buffer_seek_start, 0);
		
		for (var j = 0; j < buffer_get_size(buffer) / 36; j++) {																// vertex index
			repeat(3) {																											// position
				buffer_write(data.awaitingBuffer, buffer_f32, buffer_read(buffer, buffer_f32));
			};
			
			repeat(3) {																											// normal
				buffer_write(data.awaitingBuffer, buffer_f32, buffer_read(buffer, buffer_f32));
			};
			
			repeat(2) {																											// texcoord
				buffer_write(data.awaitingBuffer, buffer_f32, buffer_read(buffer, buffer_f32));
			};
			
			repeat(4) {																											// colour
				buffer_write(data.awaitingBuffer, buffer_u8, buffer_read(buffer, buffer_u8));
			};
			
			buffer_write(data.awaitingBuffer, buffer_f32, i);																	// ID
		};
		
		buffer_delete(buffer);
	};
	
	data.combined_vbuffer = vertex_create_buffer_from_buffer(data.awaitingBuffer, data.vertex_format);
	buffer_delete(data.awaitingBuffer);
};

/// @param							gpu_instancing_data																			  the data that is created using 'gpu_instancing_create(...)'
/// @param							world_matrices																				  world matrices to send to the shader
function gpu_instancing_update_matrices(gpu_instancing_data, world_matrices) {
	if (array_length(world_matrices) != gpu_instancing_data.iamount) {
		return;
	};
	
	for (var i = 0; i < gpu_instancing_data.iamount; i++) {
		array_copy(gpu_instancing_data.wmatrices, i * 16, world_matrices[i], 0, 16);
	};
};

/// @param							gpu_instancing_data																			  the data that is created using 'gpu_instancing_create(...)'
function gpu_instancing_draw(gpu_instancing_data) {
	var data = gpu_instancing_data;
	
	shader_set_uniform_matrix_array(data.shdMatrixArrUniform, data.wmatrices);
	vertex_submit(data.combined_vbuffer, pr_trianglelist, -1);
};

/// @param							gpu_instancing_data																			  the data that is created using 'gpu_instancing_create(...)'
function gpu_instancing_free(gpu_instancing_data) {
	vertex_delete_buffer(gpu_instancing_data.combined_vbuffer);
	vertex_format_delete(gpu_instancing_data.vertex_format);
};











































































