CreateQuad = function(offset, size, color) {
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
		var s = random_range(10, 30);
		var r = random_range(0, 255) / 255;
		var g = random_range(0, 255) / 255;
		var b = random_range(0, 255) / 255;
		quads[i] = CreateQuad(new Vector2(random_range(0, room_width), random_range(0, room_height)), new Vector2(s, s), new Vector4(r, g, b, 1));
		i++;
	};
	return quads;
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



























