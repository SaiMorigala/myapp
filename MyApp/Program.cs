using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.Identity.Web;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

var b2cConfig = builder.Configuration.GetSection("AzureAdB2C");
var tenantId = builder.Configuration["AzureAdB2C:TenantId"];

//builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
//    .AddMicrosoftIdentityWebApi(builder.Configuration.GetSection("AzureAdB2C"));

app.MapGet("/weatherforecast", () =>
{
    return new[] { tenantId, "Sunny", "Cloudy", "Rainy", "Spring", "Chilled" };
});

// Make the app listen on all network interfaces and port 80
//app.Urls.Add("http://0.0.0.0:80");

app.Run();
