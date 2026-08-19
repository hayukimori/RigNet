using Godot;

[GlobalClass]
public partial class RigPageWrapper : Resource
{
    [Export] public string Title     { get; set; } = "";
    [Export] public string Author    { get; set; } = "";
    [Export] public ulong  Timestamp { get; set; } = 0;
    [Export] public Godot.Collections.Array<RigNodeWrapper> Nodes { get; set; } = new();

    public RigPageWrapper() {}

    public RigPageWrapper(Rignet.RigPage page)
    {
        Title     = page.Title;
        Author    = page.Author;
        Timestamp = page.Timestamp;
        foreach (var node in page.Nodes)
            Nodes.Add(new RigNodeWrapper(node));
    }
}
