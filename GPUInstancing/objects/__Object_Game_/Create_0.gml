CreateQuad = function() {
	vertex_format_begin();
	vertex_format_add_position_3d();
	vertex_format_add_normal();
	vertex_format_add_texcoord();
	vertex_format_add_colour();
	var vf = vertex_format_end();
	
	var vb = vertex_create_buffer();
	
	var r = 100;
	var g = 255;
	var b = 0;
	
	vertex_begin(vb, vf);
		vertex_position_3d(vb, -20, -20, 0);
		vertex_normal(vb, 0, 0, 0);
		vertex_texcoord(vb, 0, 0);
		vertex_colour(vb, make_color_rgb(r, g, b), 1);
		
		vertex_position_3d(vb, -20, 20, 0);
		vertex_normal(vb, 0, 0, 0);
		vertex_texcoord(vb, 0, 0);
		vertex_colour(vb, make_color_rgb(r, g, b), 1);
		
		vertex_position_3d(vb, 20, -20, 0);
		vertex_normal(vb, 0, 0, 0);
		vertex_texcoord(vb, 0, 0);
		vertex_colour(vb, make_color_rgb(r, g, b), 1);
		
		vertex_position_3d(vb, 20, 20, 0);
		vertex_normal(vb, 0, 0, 0);
		vertex_texcoord(vb, 0, 0);
		vertex_colour(vb, make_color_rgb(r, g, b), 1);
		
		vertex_position_3d(vb, 20, -20, 0);
		vertex_normal(vb, 0, 0, 0);
		vertex_texcoord(vb, 0, 0);
		vertex_colour(vb, make_color_rgb(r, g, b), 1);
		
		vertex_position_3d(vb, -20, 20, 0);
		vertex_normal(vb, 0, 0, 0);
		vertex_texcoord(vb, 0, 0);
		vertex_colour(vb, make_color_rgb(r, g, b), 1);
	vertex_end(vb);
	
	return [vb, vf];
};

QuadMatrices = function(amount) {
	var matrices = array_create(amount);
	
	for (var i = 0; i < amount; i++) {
		matrices[i] = matrix_build(random_range(0, room_width), random_range(0, room_height), 0, 0, 0, 0, random_range(0.2, 3), random_range(0.2, 3), 1);
	};
	
	return matrices;
};

maxQuadAmount = 256; // the amount of actual quads can be anything but above 256. but length of the quadMatrices has to be 256 meaning same as in the shader
quad = CreateQuad();

quadMatrices = QuadMatrices(maxQuadAmount);
data = gpu_instancing_create(maxQuadAmount, quad[0]);
gpu_instancing_add_amount(data, 256);
gpu_instancing_build(data);
gpu_instancing_update_matrices(data, quadMatrices);

///////////////////////////////////////////////////////////////////////////////////////// OLD \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
/*CreateQuad = function(offset, size, color) {
	var object = new Object();
	object.Init();
	var model = object.GetModelLOD(object.GenerateLOD(9999));
	var material = new MaterialDefault();
	material.Init();
	var mesh = model.GetMesh(model.GenerateMesh(material));
	
	mesh.VertexAdd(new VertexData(new Vector3(offset.x - size.x, offset.y - size.y, 0), new Vector3(0, 0, 0), new Vector2(0, 0), color));
	mesh.VertexAdd(new VertexData(new Vector3(offset.x - size.x, offset.y + size.y, 0), new Vector3(0, 0, 0), new Vector2(0, 0), color));
	mesh.VertexAdd(new VertexData(new Vector3(offset.x + size.x, offset.y - size.y, 0), new Vector3(0, 0, 0), new Vector2(0, 0), color));
	
	mesh.VertexAdd(new VertexData(new Vector3(offset.x + size.x, offset.y + size.y, 0), new Vector3(0, 0, 0), new Vector2(0, 0), color));
	mesh.VertexAdd(new VertexData(new Vector3(offset.x + size.x, offset.y - size.y, 0), new Vector3(0, 0, 0), new Vector2(0, 0), color));
	mesh.VertexAdd(new VertexData(new Vector3(offset.x - size.x, offset.y + size.y, 0), new Vector3(0, 0, 0), new Vector2(0, 0), color));
	
	mesh.LoadAndFlushVerticies();
	
	return object;
};

CreateQuads = function(amount) {
	var quads = array_create(amount);
	var i = 0;
	repeat (amount) {
		var r = random_range(0, 255) / 255;
		var g = random_range(0, 255) / 255;
		var b = random_range(0, 255) / 255;
		quads[i] = CreateQuad(new Vector2(0, 0), new Vector2(20, 20), new Vector4(r, g, b, 1));
		quads[i].pos = new Vector3(random_range(0, room_width), random_range(0, room_height), 0);
		quads[i].scale = new Vector3(random_range(0.2, 3), random_range(0.2, 3), 1);
		i++;
	};
	return quads;
};

UpdateQuads = function(quads, amount) {
	var i = 0;
	repeat (amount) {
		quads[i].Update();
		i++;
	};
};

DrawQuads = function(quads, amount) {
	var i = 0;
	repeat (amount) {
		quads[i].Draw();
		i++;
	};
};

FreeQuads = function(quads, amount) {
	var i = 0;
	repeat (amount) {
		quads[i].Free();
		i++;
	};
};

EnableGPUInstancing = function(quads, amount) {
	var gpuInstancing = new GPUInstancedObjects(new GPU_INSTANCING_MOC256());
	gpuInstancing.Init();
	
	var i = 0;
	gpuInstancing.InstanceLoadBegin(quads);
	repeat (amount) {
		gpuInstancing.ObjectAddInstance(quads[| i]);
		i++;
	};
	gpuInstancing.InstanceLoadEnd();
	return gpuInstancing;
};

ArrayToList = function(array) {
	var list = ds_list_create();
	for (var i = 0; i < array_length(array); i++) {
		ds_list_add(list, array[i]);
	};
	return list;
};

quadAmount = 256;
quads = CreateQuads(quadAmount);
quadList = ArrayToList(quads);

gpuInstancing = EnableGPUInstancing(quadList, quadAmount);

UpdateQuads(quads, quadAmount); // to update their world matrix to apply positions and scalings



























