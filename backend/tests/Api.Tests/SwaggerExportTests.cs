using Microsoft.AspNetCore.Mvc.Testing;
using Xunit;
using System.IO;
using System.Threading.Tasks;

namespace Api.Tests;

public class SwaggerExportTests : IClassFixture<WebApplicationFactory<Program>>
{
    private readonly WebApplicationFactory<Program> _factory;

    public SwaggerExportTests(WebApplicationFactory<Program> factory)
    {
        _factory = factory;
    }

    [Fact]
    public async Task ExportSwaggerJson()
    {
        // Arrange
        var client = _factory.CreateClient();

        // Act
        var response = await client.GetAsync("/swagger/v1/swagger.json");
        response.EnsureSuccessStatusCode();
        var json = await response.Content.ReadAsStringAsync();

        // Assert
        var outputPath = Path.Combine(Directory.GetCurrentDirectory(), "../../../../../docs/swagger.json");
        outputPath = Path.GetFullPath(outputPath);
        var directory = Path.GetDirectoryName(outputPath);
        if (!Directory.Exists(directory))
        {
            Directory.CreateDirectory(directory!);
        }
        await File.WriteAllTextAsync(outputPath, json);
        
        // Print path to help debugging
        System.Console.WriteLine($"Swagger exported to: {outputPath}");
    }
}
