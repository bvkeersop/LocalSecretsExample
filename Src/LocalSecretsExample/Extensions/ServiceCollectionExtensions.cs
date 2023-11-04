using LocalSecretsExample.Options;

namespace LocalSecretsExample.Extensions;

public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddExampleOptions(this IServiceCollection services, IConfiguration configuration)
    {
        var exampleOptions = configuration
            .GetSection(LocalSecretManagementOptions.SectionName)
            .Get<LocalSecretManagementOptions>();

        return services.AddExampleOptions(options =>
        {
            options.Greeting = exampleOptions.Greeting;
            options.Person = exampleOptions.Person;
        });
    }

    public static IServiceCollection AddExampleOptions(this IServiceCollection services, Action<LocalSecretManagementOptions> configureOptions)
        => services.Configure(configureOptions);
}
