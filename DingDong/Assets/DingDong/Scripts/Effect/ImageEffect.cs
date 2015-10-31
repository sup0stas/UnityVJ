using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class ImageEffect : MonoBehaviour
{
  public enum ShaderName { Complex, Vinyl, Depth }

  public ShaderName shaderName = ShaderName.Depth;
	private Material material;

	// Creates a private material used to the effect
	void Awake ()
	{
		material = new Material( Shader.Find( GetShaderName(this.shaderName) ) );
    this.GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
	}

	// Postprocess the image
	void OnRenderImage (RenderTexture source, RenderTexture destination)
	{
		Graphics.Blit (source, destination, material);
	}

  public string GetShaderName (ShaderName shaderName)
  {
    string name = "DingDong/Simple";
    switch (shaderName)
    {
        case ShaderName.Complex : name = "Hidden/ComplexDistortion"; break;
        case ShaderName.Vinyl : name = "Hidden/Vinyl"; break;
        case ShaderName.Depth : name = "Hidden/Depth"; break;
    }
    return name;
  }
}