using Godot;
using Rignet;

[GlobalClass]
public partial class RigPageWrapper : Resource
{
    [Export] public string Title     { get; set; } = "";
    [Export] public string Author    { get; set; } = "";
    [Export] public ulong  Timestamp { get; set; } = 0;
    [Export] public Godot.Collections.Array<RigSectionWrapper> Sections { get; set; } = new();

    public RigPageWrapper() {}
    public RigPageWrapper(RigPage page)
    {
        Title     = page.Title;
        Author    = page.Author;
        Timestamp = page.Timestamp;
        foreach (var section in page.Sections)
            Sections.Add(new RigSectionWrapper(section));
    }
}
