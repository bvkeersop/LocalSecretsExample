namespace LocalSecretsExample.Options;

public class LocalSecretManagementOptions
{
    public const string SectionName = nameof(LocalSecretManagementOptions);
    public string Greeting { get; set; } = string.Empty;
    public string Person { get; set; } = string.Empty;
}
