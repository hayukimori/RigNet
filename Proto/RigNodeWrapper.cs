using Godot;
using Rignet;
using System.Collections.Generic;

[GlobalClass]
public partial class RigNodeWrapper : Resource
{
    [Export] public int    Type  { get; set; }
    [Export] public string Text  { get; set; } = "";
    [Export] public string Url   { get; set; } = "";
    [Export] public string Color { get; set; } = "";

    public RigNodeWrapper() {}
    public RigNodeWrapper(RigNode node)
    {
        Type  = (int)node.Type;
        Text  = node.Text;
        Url   = node.Url;
        Color = node.Color;
    }
}
