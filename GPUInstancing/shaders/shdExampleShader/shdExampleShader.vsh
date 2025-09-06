attribute vec3 in_Position;                  // (x,y,z)
attribute vec3 in_Normal;					 // (x,y,z)
attribute vec2 in_TextureCoord;              // (u,v)
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute float in_MeshIDf;                    // ID of the mesh/model that vertex belongs to

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

const int MAX_OBJECT_COUNT = 256;
uniform mat4 uWorldMatricies[MAX_OBJECT_COUNT];

void main() {
	int meshID = int(in_MeshIDf) < MAX_OBJECT_COUNT ? int(in_MeshIDf) : MAX_OBJECT_COUNT;
	mat4 matrixWorld = uWorldMatricies[meshID];
	mat4 matrixView = gm_Matrices[MATRIX_VIEW];
	mat4 matrixProjection = gm_Matrices[MATRIX_PROJECTION];
	mat4 matrixCombined = matrixProjection * matrixView * matrixWorld;
	vec4 spacePos = vec4(in_Position, 1.0);
	vec4 pos = matrixCombined * spacePos;
	
	gl_Position = pos;
	
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord;
}
