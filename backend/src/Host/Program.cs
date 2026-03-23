using System.Globalization;
using Hangfire;
using Host;
using Host.Extensions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Localization;
using Microsoft.FeatureManagement;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddLocalization(options => options.ResourcesPath = "Resources");

builder.Services.AddControllers();

builder.Services.AddInfrastructure(builder.Configuration);
builder.Services.AddCustomAuth(builder.Configuration);
builder.Services.AddCustomCors(builder.Configuration);
builder.Services.AddCustomRateLimiting();
builder.Services.AddCustomApiVersioning();
builder.Services.AddCustomSwagger();
builder.Services.AddCustomHealthChecks(builder.Configuration);
builder.Services.AddFeatureManagement();

var app = builder.Build();

var supportedCultures = new[]
{
    new CultureInfo("de"),
    new CultureInfo("en")
};

app.UseRequestLocalization(new RequestLocalizationOptions
{
    DefaultRequestCulture = new RequestCulture("de"),
    SupportedCultures = supportedCultures,
    SupportedUICultures = supportedCultures
});

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
else
{
    app.UseHsts();
}

app.UseHttpsRedirection();

app.UseCors("Frontend");
app.UseRateLimiter();

app.UseRouting();

app.UseAuthentication();
app.UseAuthorization();

app.UseHangfireDashboard("/admin/hangfire", new Hangfire.DashboardOptions
{
    Authorization = new[] { new Host.Extensions.HangfireAdminAuthorizationFilter() }
});

// Schedule recurring jobs
using (var scope = app.Services.CreateScope())
{
    // Register recurring jobs here
}

app.UseSeedData();

app.MapControllers();
app.MapHealthChecks("/health");

app.Run();

public partial class Program { }
