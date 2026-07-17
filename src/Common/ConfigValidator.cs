using System.Text.Json;

namespace ZeroTouchNinjaTrader.Common;

public static class ConfigValidator
{
    public static DeploySettings Load(string path)
    {
        var json = File.ReadAllText(path);
        var settings = JsonSerializer.Deserialize<DeploySettings>(json, new JsonSerializerOptions
        {
            PropertyNameCaseInsensitive = true
        });

        if (settings is null)
        {
            throw new InvalidOperationException("Configuration could not be parsed.");
        }

        Validate(settings);
        return settings;
    }

    public static void Validate(DeploySettings settings)
    {
        if (string.IsNullOrWhiteSpace(settings.Name))
            throw new InvalidOperationException("Name is required.");

        if (string.IsNullOrWhiteSpace(settings.Version))
            throw new InvalidOperationException("Version is required.");

        if (string.IsNullOrWhiteSpace(settings.StrategyName))
            throw new InvalidOperationException("StrategyName is required.");

        if (!string.Equals(settings.TargetEnvironment, "sim", StringComparison.OrdinalIgnoreCase) &&
            !string.Equals(settings.TargetEnvironment, "paper", StringComparison.OrdinalIgnoreCase))
            throw new InvalidOperationException("TargetEnvironment must be sim or paper.");

        if (string.IsNullOrWhiteSpace(settings.ArtifactRoot))
            throw new InvalidOperationException("ArtifactRoot is required.");

        if (string.IsNullOrWhiteSpace(settings.DropFolder))
            throw new InvalidOperationException("DropFolder is required.");

        if (string.IsNullOrWhiteSpace(settings.LogFolder))
            throw new InvalidOperationException("LogFolder is required.");
    }
}
