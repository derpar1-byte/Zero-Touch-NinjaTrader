namespace ZeroTouchNinjaTrader.Common;

public sealed class DeploySettings
{
    public string Name { get; set; } = string.Empty;
    public string Version { get; set; } = string.Empty;
    public string StrategyName { get; set; } = string.Empty;
    public string TargetEnvironment { get; set; } = "sim";
    public string ArtifactRoot { get; set; } = "artifacts";
    public string DropFolder { get; set; } = string.Empty;
    public string LogFolder { get; set; } = string.Empty;
}
