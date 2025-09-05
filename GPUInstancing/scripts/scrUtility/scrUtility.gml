function Smoothstep(edge0, edge1, v) {
    if (edge1 == edge0) return (v >= edge0);

    var t = clamp((v - edge0) / (edge1 - edge0), 0, 1);
    return t * t * (3 - 2 * t);
};

function Vector2(_x = 0, _y = 0) constructor {
	x = _x;
	y = _y;
	
	Add = function Add(a) {
		x += a.x;
		y += a.y;
		
		return self;
	};
	
	Subtract = function Subtract(a) {
		x -= a.x;
		y -= a.y;
		
		return self;
	};
};

function Vector2Dot(a, b) {
	return a.x * b.x + a.y * b.y;
};

function Vector2Smoothstep(a, b, v) {
	return new Vector2(Smoothstep(a, b, v.x), Smoothstep(a, b, v.y));
};

function Vector2Difference(a, b) {
	return new Vector2(
		b.x - a.x, 
		b.y - a.y
	);
};

function Vector3(_x = 0, _y = 0, _z = 0) constructor {
	x = _x;
	y = _y;
	z = _z;
	
	Add = function Add(a) {
		x += a.x;
		y += a.y;
		z += a.z;
		
		return self;
	};
	
	Subtract = function Subtract(a) {
		x -= a.x;
		y -= a.y;
		z -= a.z;
		
		return self;
	};
	
	Multiply = function Multiply(a) {
		x *= a.x;
		y *= a.y;
		z *= a.z;
		
		return self;
	};
	
	Divide = function Divide(a) {
		x /= a.x;
		y /= a.y;
		z /= a.z;
		
		return self;
	};
	
	Length = function Length() {
		return sqrt(x * x + y * y + z * z);
	};
	
	Normalize = function Normalize() {
		var length = Length();
		
		x /= length;
		y /= length;
		z /= length;
		
		return self;
	};
	
	Dot = function Dot(a) {
		return x * a.x + y * a.y + z * a.z;
	};
};

function Vector3Mix(a, b, c) {
	return new Vector3(
		lerp(a.x, b.x, c), 
		lerp(a.y, b.y, c), 
		lerp(a.z, b.z, c)
	);
};

function Vector3Cross(a, b) {
	return new Vector3(
		a.y * b.z - a.z * b.y, 
		a.z * b.x - a.x * b.z, 
		a.x * b.y - a.y * b.x
	);
};

function Vector3Difference(a, b) {
	return new Vector3(
		b.x - a.x, 
		b.y - a.y, 
		b.z - a.z
	);
};

function Vector3Sum(a, b) {
	return new Vector3(
		a.x + b.x, 
		a.y + b.y, 
		a.z + b.z
	);
};

function Vector3Multiply(a, b) {
	return new Vector3(
		a.x * b.x, 
		a.y * b.y, 
		a.z * b.z
	);
};

function Vector3Divide(a, b) {
	return new Vector3(
		a.x / b.x, 
		a.y / b.y, 
		a.z / b.z
	);
};

function Vector3Length(vec) {
	return sqrt(vec.x * vec.x + vec.y * vec.y + vec.z * vec.z);
};

function Vector3Normalize(vec) {
	var length = Vector3Length(vec);
	return new Vector3(vec.x / length, vec.y / length, vec.z / length);
};

function Vector3Dot(a, b) {
	return a.x * b.x + a.y * b.y + a.z * b.z;
};

function Vector4(_x = 0, _y = 0, _z = 0, _w = 0) constructor {
	x = _x;
	y = _y;
	z = _z;
	w = _w;
};

function Texture() {
	surface = undefined;
	
	Init = function (size = new Vector2(1, 1), surface_type = surface_rgba8unorm) {
		surface = surface_create(size.x, size.y, surface_type);
	};
	
	Free = function() {
		if (surface) {
			surface_free(surface);
		};
	};
	
	Set = function(clearColor = new Vector4()) {
		surface_set_target(surface);
		draw_clear_alpha(make_color_rgb(clearColor.x, clearColor.y, clearColor.z), clearColor.w / 255);
	};
	
	Reset = function(clearColor = new Vector4()) {
		surface_reset_target();
	};
};

function Shader(_shader = shdDefault) constructor {
	shader = _shader;
	
	uniforms = ds_list_create();
	uniformNames = ds_list_create();
	uniformDatas = ds_map_create();
	
	uniformsV2 = ds_list_create();
	uniformNamesV2 = ds_list_create();
	uniformDatasV2 = ds_map_create();
	
	uniformsV3 = ds_list_create();
	uniformNamesV3 = ds_list_create();
	uniformDatasV3 = ds_map_create();
	
	uniformsV4 = ds_list_create();
	uniformNamesV4 = ds_list_create();
	uniformDatasV4 = ds_map_create();
	
	uniformsTX = ds_list_create();
	uniformNamesTX = ds_list_create();
	uniformDatasTX = ds_map_create();
	
	Set = function Set() {
		shader_set(shader);
		
		// s
		for (var i = 0; i < ds_list_size(uniforms); i++) {
			shader_set_uniform_f(uniforms[| i], uniformDatas[? uniformNames[| i]]);
		};
		
		// v2
		for (var i = 0; i < ds_list_size(uniformsV2); i++) {
			shader_set_uniform_f(uniformsV2[| i], uniformDatasV2[? uniformNamesV2[| i]].x, uniformDatasV2[? uniformNamesV2[| i]].y);
		}; 
		
		// v3
		for (var i = 0; i < ds_list_size(uniformsV3); i++) {
			shader_set_uniform_f(uniformsV3[| i], uniformDatasV3[? uniformNamesV3[| i]].x, uniformDatasV3[? uniformNamesV3[| i]].y, uniformDatasV3[? uniformNamesV3[| i]].z);
		}; 
		
		// v4
		for (var i = 0; i < ds_list_size(uniformsV4); i++) {
			shader_set_uniform_f(uniformsV4[| i], uniformDatasV4[? uniformNamesV4[| i]].x, uniformDatasV4[? uniformNamesV4[| i]].y, uniformDatasV4[? uniformNamesV4[| i]].z, uniformDatasV4[? uniformNamesV4[| i]].w);
		}; 
		
		// tx
		for (var i = 0; i < ds_list_size(uniformsTX); i++) {
			var texture = uniformDatasTX[? uniformNamesTX[| i]];
			texture_set_stage(uniformsTX[| i], surface_get_texture(texture.surface));
		}; 
	};
	
	Reset = function Reset() {
		shader_reset();
	};
	
	Free = function Free() {
		ds_list_destroy(uniforms);
		ds_list_destroy(uniformNames);
		ds_map_destroy(uniformDatas);
		
		ds_list_destroy(uniformsV2);
		ds_list_destroy(uniformNamesV2);
		ds_map_destroy(uniformDatasV2);
		
		ds_list_destroy(uniformsV3);
		ds_list_destroy(uniformNamesV3);
		ds_map_destroy(uniformDatasV3);
		
		ds_list_destroy(uniformsV4);
		ds_list_destroy(uniformNamesV4);
		ds_map_destroy(uniformDatasV4);
		
		ds_list_destroy(uniformsTX);
		ds_list_destroy(uniformNamesTX);
		ds_map_destroy(uniformDatasTX);
	};
	
	RegisterUniform = function RegisterUniform(name, data) {
		ds_list_add(uniformNames, name);
		uniformDatas[? name] = data;
		
		ds_list_add(uniforms, shader_get_uniform(shader, name));
		return ds_list_size(uniforms) - 1;
	};
	
	RegisterUniformVector2 = function RegisterUniformVector2(name, data) {
		ds_list_add(uniformNamesV2, name);
		uniformDatasV2[? name] = data;
		
		ds_list_add(uniformsV2, shader_get_uniform(shader, name));
		return ds_list_size(uniformsV2) - 1;
	};
	
	RegisterUniformVector3 = function RegisterUniformVector3(name, data) {
		ds_list_add(uniformNamesV3, name);
		uniformDatasV3[? name] = data;
		
		ds_list_add(uniformsV3, shader_get_uniform(shader, name));
		return ds_list_size(uniformsV3) - 1;
	};
	
	RegisterUniformVector4 = function RegisterUniformVector4(name, data) {
		ds_list_add(uniformNamesV4, name);
		uniformDatasV4[? name] = data;
		
		ds_list_add(uniformsV4, shader_get_uniform(shader, name));
		return ds_list_size(uniformsV4) - 1;
	};
	
	RegisterTexture = function RegisterTexture(name, data) {
		ds_list_add(uniformNamesTX, name);
		uniformDatasTX[? name] = data;
		
		var sampler = shader_get_sampler_index(shader, name);
		ds_list_add(uniformsTX, sampler);
		return ds_list_size(uniformsTX) - 1;
	};
	
	SetUniformData = function SetUniformData(name, data) {
		uniformDatas[? name] = data;
	};
	
	SetUniformDataVector2 = function SetUniformDataVector2(name, data) {
		uniformDatasV2[? name] = data;
	};
	
	SetUniformDataVector3 = function SetUniformDataVector3(name, data) {
		uniformDatasV3[? name] = data;
	};
	
	SetUniformDataVector4 = function SetUniformDataVector4(name, data) {
		uniformDatasV4[? name] = data;
	};
	
	SetTexture = function SetTexture(name, data) {
		uniformDatasTX[? name] = data;
	};
	
	GetUniformData = function GetUniformData(name) {
		return uniformDatas[? name];
	};
	
	GetUniformDataVector2 = function GetUniformDataVector2(name) {
		return uniformDatasV2[? name];
	};
	
	GetUniformDataVector3 = function GetUniformDataVector3(name) {
		return uniformDatasV3[? name];
	};
	
	GetUniformDataVector4 = function GetUniformDataVector4(name) {
		return uniformDatasV4[? name];
	};
	
	GetTexture = function GetTexture(name) {
		return uniformDatasTX[? name];
	};
};

function Material() constructor {
	shader = undefined;
	
	Init = function() {
	};
	
	Free = function() {
		if (shader != undefined) {
			shader.Free();
		};
	};
	
	Set = function() {
		shader.Set();
	};
	
	Reset = function() {
		shader.Reset();
	};
};

function MaterialDefault() : Material() constructor {
	shader = new Shader(shdDefault);
};

global.__GPU_INSTANCING_SHADER_MOC256_ = shdGPUInstancingMOC256;

function MaterialGPUInstancingMOC256() : Material() constructor {
	shader = new Shader(global.__GPU_INSTANCING_SHADER_MOC256_);
	
	handleArrayMatricies = undefined;
	arrayMatricies = array_create(256 * 16);
	
	Init = function() {
		handleArrayMatricies = shader_get_uniform(shader.shader, "uWorldMatricies");
	};
	
	Set = function() {
		shader.Set();
		
		if (arrayMatricies != undefined) {
			shader_set_uniform_matrix_array(handleArrayMatricies, arrayMatricies);
		};
	};
};

function vertex_get_buffer_size_fixed(buffer) {
	var buff = buffer_create_from_vertex_buffer(buffer, buffer_fixed, 1);
	var size = buffer_get_size(buff);
	buffer_delete(buff);
	return size;
};

function VertexData(_pos = Vector3(0, 0, 0), _nor = Vector3(0, 0, 1), _tcoord = Vector2(0, 0), _color = Vector4(1, 1, 1, 1)) constructor {
	pos = _pos;
	nor = _nor;
	tcoord = _tcoord;
	color = _color;
};

function VBVertexAdd(buff, vertex) {
	vertex_position_3d(buff, vertex.pos.x, vertex.pos.y, vertex.pos.z);
	vertex_normal(buff, vertex.nor.x, vertex.nor.y, vertex.nor.z);
	vertex_texcoord(buff, vertex.tcoord.x, vertex.tcoord.y);
	vertex_color(buff, make_color_rgb(vertex.color.x * 255, vertex.color.y * 255, vertex.color.z * 255), vertex.color.w);
};

function Mesh(_material = new MaterialDefault()) constructor {
	verticies = ds_list_create();
	vertexFormat = noone;
	vertexBuffer = noone;
	material = _material;
	cullMode = cull_noculling;
	
	Init = function() {
		vertexBuffer = vertex_create_buffer();
		
		vertex_format_begin();
		vertex_format_add_position_3d();
		vertex_format_add_normal();
		vertex_format_add_texcoord();
		vertex_format_add_color();
		vertexFormat = vertex_format_end();
	};
	
	Free = function() {
		ds_list_destroy(verticies);
		vertex_format_delete(vertexFormat);
		vertex_delete_buffer(vertexBuffer);
		material.Free();
	};
	
	VertexAdd = function(vData) {
		ds_list_add(verticies, vData);
	};
	
	LoadVerticies = function() {
		vertex_begin(vertexBuffer, vertexFormat);
		for (var i = 0; i < ds_list_size(verticies); i++) {
			VBVertexAdd(vertexBuffer, verticies[| i]);
		};
		vertex_end(vertexBuffer);
	};
	
	VertexLoadBegin = function() {
		vertex_begin(vertexBuffer, vertexFormat);
	};
	
	VertexLoad = function(vData) {
		VBVertexAdd(vertexBuffer, vData);
	};
	
	VertexLoadEnd = function() {
		vertex_end(vertexBuffer);
	};
	
	FlushVerticies = function() {
		ds_list_clear(verticies);
	};
	
	LoadAndFlushVerticies = function() {
		LoadVerticies();
		FlushVerticies();
	};
	
	Draw = function(mat = undefined) {
		var m = mat == undefined ? material : mat;
		m.Set();
		gpu_set_cullmode(cullMode);
		vertex_submit(vertexBuffer, pr_trianglelist, -1);
		gpu_set_cullmode(cull_noculling);
		m.Reset();
	};
};

function Model() constructor {
	meshes = ds_list_create();
	
	Free = function() {
		for (var i = 0; i < ds_list_size(meshes); i++) {
			meshes[| i].Free();
		};
		ds_list_destroy(meshes);
	};
	
	GenerateMesh = function(material = undefined) {
		ds_list_add(meshes, new Mesh(material));
		meshes[| ds_list_size(meshes) - 1].Init();
		return meshes[| ds_list_size(meshes) - 1];
	};
	
	AddMesh = function(mesh) {
		ds_list_add(meshes, mesh);
		return meshes[| ds_list_size(meshes) - 1];
	};
	
	GetMesh = function(index) {
		return meshes[| index];
	};
	
	Draw = function(mat = undefined) {
		for (var i = 0; i < ds_list_size(meshes); i++) {
			meshes[| i].Draw(mat);
		};
	};
};

function Object() constructor {
	modelLODs = undefined;
	modelLODsDistances = undefined;
	pos = new Vector3(0, 0, 0);
	rot = new Vector3(0, 0, 0);
	scale = new Vector3(1, 1, 1);
	ppos = new Vector3(0, 0, 0);
	prot = new Vector3(0, 0, 0);
	pscale = new Vector3(1, 1, 1);
	matWorld = undefined;
	matIdentity = undefined;
	isTargetGPUInstance = false;
	
	Init = function() {
		modelLODs = ds_list_create();
		modelLODsDistances = ds_list_create();
		matWorld =  matrix_build(pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, scale.x, scale.y, scale.z);
		matIdentity = matrix_build_identity();
	};
	
	Free = function() {
		if (isTargetGPUInstance) {
			return; // because it is already free'd
		};
		
		for (var i = 0; i < ds_list_size(modelLODs); i++) {
			var model = modelLODs[| i];
			model.Free();
		};
		
		ds_list_destroy(modelLODs);
		ds_list_destroy(modelLODsDistances);
	};
	
	SetTargetGPUInstance = function() {
		isTargetGPUInstance = true;
	};
	
	GenerateLOD = function(distance) {
		ds_list_add(modelLODs, new Model());
		ds_list_add(modelLODsDistances, distance);
		return ds_list_size(modelLODs) - 1;
	};
	
	GetModelLOD = function(index) {
		return modelLODs[| index];
	};
	
	AddModelLOD = function(model, distance) {
		ds_list_add(modelLODs, model);
		ds_list_add(modelLODsDistances, distance);
	};
	
	Draw = function(camPos = new Vector3(), mat = undefined) {
		if (
			( ppos.x != pos.x || ppos.y != pos.y || ppos.z != pos.z ) 
			||
			( prot.x != rot.x || prot.y != rot.y || prot.z != rot.z ) 
			||
			( pscale.x != scale.x || pscale.y != scale.y || pscale.z != scale.z ) 
		) {
			matWorld =  matrix_build(pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, scale.x, scale.y, scale.z);
			
			ppos.x = pos.x; ppos.y = pos.y; ppos.z = pos.z;
			prot.x = rot.x; prot.y = rot.y; prot.z = rot.z;
			pscale.x = scale.x; pscale.y = scale.y; pscale.z = scale.z;
		};
		
		if (isTargetGPUInstance) {
			return;
		};
		
		matrix_set(matrix_world, matWorld);
		
		var distance = Vector3Difference(pos, camPos).Length();
		var idx = 0;
		
		for (var i = 0; i < ds_list_size(modelLODsDistances); i++) {
			if (distance < modelLODsDistances[| i]) {
				idx = i;
			};
		};
		
		modelLODs[| idx].Draw(mat);
		
		matrix_set(matrix_world, matIdentity);
	};
};

function GPU_INSTANCING() constructor {
	moc = undefined;
};

function GPU_INSTANCING_MOC256() : GPU_INSTANCING() constructor {
	moc = 256;
};

function GPUInstancedObjects(_gpu_instancing) constructor {
	objects = undefined;
	verticies = undefined;
	vertexFormat = undefined;
	vertexBuffer = undefined;
	awaitingBuffer = undefined;
	worldMatricies = undefined;
	modelCount = 0;
	material = undefined;
	isMatrixUpdateRequired = true;
	gpu_instancing = _gpu_instancing;
	
	UpdateMOC = function(_gpu_instancing) {
		gpu_instancing = _gpu_instancing;
		
		if (material != undefined) {
			material.Free();
		};
		
		switch (gpu_instancing.moc) {
		case 256: {
			material = new MaterialGPUInstancingMOC256();
		} break;
		};
		
		material.Init();
	};
	
	Init = function() {
		objects = ds_list_create();
		
		UpdateMOC(gpu_instancing);
		
		vertex_format_begin();
		vertex_format_add_position_3d();
		vertex_format_add_normal();
		vertex_format_add_texcoord();
		vertex_format_add_color();
		vertex_format_add_custom(vertex_type_float1, vertex_usage_texcoord);
		vertexFormat = vertex_format_end();
	};
	
	Free = function() {
		material.Free();
		ds_list_destroy(objects);
		vertex_format_delete(vertexFormat);
		if (vertexBuffer) {
			vertex_delete_buffer(vertexBuffer);
		};
		if (buffer_exists(awaitingBuffer)) {
			buffer_delete(awaitingBuffer);
		};
	};
	
	InstanceLoadBegin = function(objectList) {
		var sizeofPosition = buffer_sizeof(buffer_f32) * 3;
		var sizeofNormal = buffer_sizeof(buffer_f32) * 3;
		var sizeofTexcoord = buffer_sizeof(buffer_f32) * 2;
		var sizeofColour = buffer_sizeof(buffer_u8) * 4;
		var sizeofID = buffer_sizeof(buffer_f32);
		var totalVertexDataSize = sizeofPosition + sizeofNormal + sizeofTexcoord + sizeofColour;
		
		var totalVerticies = 0;
		
		for (var oid = 0; oid < ds_list_size(objectList); oid++) { // object index
			var object = objectList[| oid];
			for (var i = 0; i < ds_list_size(object.modelLODs); i++) { // model index
				var model = object.GetModelLOD(i);
				for (var j = 0; j < ds_list_size(model.meshes); j++) { // mesh index
					var mesh = model.GetMesh(j);
					
					var vertexCount = vertex_get_buffer_size_fixed(mesh.vertexBuffer) / totalVertexDataSize;
					
					totalVerticies += vertexCount;
				};
			};
		};
		
		awaitingBuffer = buffer_create(totalVerticies * (totalVertexDataSize + sizeofID), buffer_fixed, 1);
		buffer_seek(awaitingBuffer, buffer_seek_start, 0);
	};
	
	ObjectAddInstance = function(object) {
		// get each model's buffer and mix them under the world matrix of the object
		for (var i = 0; i < ds_list_size(object.modelLODs); i++) { // model index, no need for this because every object must have one LOD, more than one is non sense?
			var model = object.GetModelLOD(i);
			for (var j = 0; j < ds_list_size(model.meshes); j++) { // mesh index
				var mesh = model.GetMesh(j);
				var buffer = buffer_create_from_vertex_buffer(mesh.vertexBuffer, buffer_fixed, 1);
				buffer_seek(buffer, buffer_seek_start, 0);
				
				var sizeofPosition = buffer_sizeof(buffer_f32) * 3;
				var sizeofNormal = buffer_sizeof(buffer_f32) * 3;
				var sizeofTexcoord = buffer_sizeof(buffer_f32) * 2;
				var sizeofColour = buffer_sizeof(buffer_u8) * 4;
				
				var totalVertexDataSize = sizeofPosition + sizeofNormal + sizeofTexcoord + sizeofColour;
				
				for (var k = 0; k < buffer_get_size(buffer) / totalVertexDataSize; k++) { // vertex index
					// pos
					repeat (3) {
						buffer_write(awaitingBuffer, buffer_f32, buffer_read(buffer, buffer_f32));
					};
					
					// normal
					repeat (3) {
						buffer_write(awaitingBuffer, buffer_f32, buffer_read(buffer, buffer_f32));
					};
					
					// texcoord
					repeat (2) {
						buffer_write(awaitingBuffer, buffer_f32, buffer_read(buffer, buffer_f32));
					};
					
					// colour
					repeat (4) {
						buffer_write(awaitingBuffer, buffer_u8, buffer_read(buffer, buffer_u8));
					};
					
					// id
					var modelIndex = modelCount;
					buffer_write(awaitingBuffer, buffer_f32, modelIndex);
				};
				buffer_delete(buffer);
			};
			
			modelCount++;
		};
		
		object.Free();
		object.SetTargetGPUInstance();
		ds_list_add(objects, object);
		return ds_list_size(objects) - 1;
	};
	
	InstanceLoadEnd = function() {
		// load the buffer
		vertexBuffer = vertex_create_buffer_from_buffer(awaitingBuffer, vertexFormat);
		
		buffer_delete(awaitingBuffer); // flush it afterwards
	};
	
	Draw = function() {
		if (isMatrixUpdateRequired) {
			for (var i = 0; i < ds_list_size(objects); i++) {
				if (i >= gpu_instancing.moc) { break; };
				var matrixToAppend = objects[| i].matWorld;
				array_copy(material.arrayMatricies, i * 16, matrixToAppend, 0, 16);
			};
			
			isMatrixUpdateRequired = false;
		};
		material.Set();
		vertex_submit(vertexBuffer, pr_trianglelist, -1);
		material.Reset();
	};
};






















































