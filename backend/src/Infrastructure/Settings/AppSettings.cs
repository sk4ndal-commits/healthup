using Application.Interfaces;
using Microsoft.Extensions.Configuration;

namespace Infrastructure.Settings;

public class AppSettings : IAppSettings
{
    public string FrontendUrl { get; }

    public AppSettings(IConfiguration configuration)
    {
        FrontendUrl = configuration["AppSettings:FrontendUrl"] ?? "http://localhost:5173";
    }
}
