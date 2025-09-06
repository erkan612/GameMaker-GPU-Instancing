gpu_instancing_free(data);
FreeQuads(quads);

for (var i = 0; i < global.all_vertex_formats; i++) {
	vertex_format_delete(global.all_vertex_formats[| i]);
};
ds_list_destroy(global.all_vertex_formats);

///////////////////////////////////////////////////////////////////////////////////////// OLD \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
/*
FreeQuads(quads, quadAmount);
if (gpuInstancing != undefined) { gpuInstancing.Free(); };
ds_list_destroy(quadList);










































