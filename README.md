# LocalSecretsExample

This repository contains a demonstration of how to manage secrets for local development in C#.

It contains these directories:

1. Src
 - Contains the source code
2. Scripts
 - Contains the script to set local user secrets
3. Secrets
 - Contains the secret file that is used to manage the user secrets.

> IMPORTANT: DO NOT CHECK YOUR USER SECRETS INTO SOURCE CONTROL.

In this example, the secrets are stored in the `Secrets` directory. The content of this directory is added to the `.gitignore` file.

## How it works

When running the solution in a development environment, an `MSBuildTask` is executed that calls the `Scripts\Update-Secrets`.ps1` PowerShell script.
The first time this script is run, it creates a `Secrets\user-secrets.json` file based on the `Scripts\secrets-template.json` file.
When running it again, the secrets are stored in your user profile and can be accessed by your application. This is achieved by using the [Secret Manager tool](https://learn.microsoft.com/en-us/aspnet/core/security/app-secrets).

This application also demonstrates how you can add a JSON file to the configuration provider. This could also be used to configure secrets, but the above solution is preferred.
See [Configuration Providers](https://learn.microsoft.com/en-us/dotnet/core/extensions/configuration-providers) documentation for more information on this.

To run the Powershell script that updates the user secrets, you need to set Powershell's execution policy to unrestricted, this can be done by executing the following command in an elevated Powershell: `Set-ExecutionPolicy -ExecutionPolicy Unrestricted`. Note that this has consequences if you run other untrusted scripts by accident.