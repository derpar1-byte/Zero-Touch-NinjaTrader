using Xunit;
using ZeroTouchNinjaTrader.Common;

namespace ZeroTouchNinjaTrader.Tests;

public class ConfigValidatorTests
{
    [Fact]
    public void Validate_AllRequiredFields_Passes()
    {
        var settings = new DeploySettings
        {
            Name = "ZeroTouchNinjaTrader",
            Version = "1.0.0",
            StrategyName = "SampleStrategy",
            TargetEnvironment = "sim",
            ArtifactRoot = "artifacts",
            DropFolder = "C:\\Drop",
            LogFolder = "C:\\Logs"
        };

        ConfigValidator.Validate(settings);
    }

    [Fact]
    public void Validate_InvalidEnvironment_Throws()
    {
        var settings = new DeploySettings
        {
            Name = "ZeroTouchNinjaTrader",
            Version = "1.0.0",
            StrategyName = "SampleStrategy",
            TargetEnvironment = "prod",
            ArtifactRoot = "artifacts",
            DropFolder = "C:\\Drop",
            LogFolder = "C:\\Logs"
        };

        Assert.Throws<InvalidOperationException>(() => ConfigValidator.Validate(settings));
    }
}
