using Godot;
using Rignet;

[GlobalClass]
public partial class RigSectionWrapper : Resource
{
    [Export] public int    Layout { get; set; }
    [Export] public string Title  { get; set; } = "";
    [Export] public Godot.Collections.Array<RigNodeWrapper> Nodes { get; set; } = new();

    public RigSectionWrapper() {}
    public RigSectionWrapper(RigSection section)
    {
        Layout = (int)section.Layout;
        Title  = section.Title;
        foreach (var node in section.Nodes)
            Nodes.Add(new RigNodeWrapper(node));
    }
}
