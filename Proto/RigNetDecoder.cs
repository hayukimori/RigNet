using Godot;
using Google.Protobuf;
using Rignet;
using System.Net.Http;

[GlobalClass]
public partial class RigNetDecoder : Node
{
    private static readonly System.Net.Http.HttpClient _http = new();

    [Signal]
    public delegate void PageLoadedEventHandler(RigPageWrapper page);

    [Signal]
    public delegate void PageFailedEventHandler(string error);

    public async void FetchPage(string url)
    {
        try
        {
            string httpUrl = url.Replace("rignet://", "https://");
            byte[] data = await _http.GetByteArrayAsync(httpUrl);
            var page = RigPage.Parser.ParseFrom(data);
            EmitSignal(SignalName.PageLoaded, new RigPageWrapper(page));
        }
        catch (System.Exception e)
        {
            EmitSignal(SignalName.PageFailed, e.Message);
        }
    }
}
