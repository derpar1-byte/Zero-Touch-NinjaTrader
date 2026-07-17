using ZeroTouchNinjaTrader.Common;

if (args.Length != 1)
{
    Console.Error.WriteLine("Usage: ConfigValidatorCli <path-to-appsettings.json>");
    return 1;
}

try
{
    var settings = ConfigValidator.Load(args[0]);
    Console.WriteLine($"Configuration valid for {settings.Name} {settings.Version} ({settings.TargetEnvironment}).");
    return 0;
}
catch (Exception ex)
{
    Console.Error.WriteLine(ex.Message);
    return 2;
}
