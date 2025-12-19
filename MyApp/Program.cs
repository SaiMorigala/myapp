var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/weatherforecast", () =>
{
    return new[] { "Sunny", "Cloudy", "Rainy" };
});

// Make the app listen on all network interfaces and port 80
app.Urls.Add("http://0.0.0.0:80");

app.Run();
