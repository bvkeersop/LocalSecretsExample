using LocalSecretsExample.Extensions;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();

// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Set values from the configuration file on the options object
builder.Services.AddExampleOptions(builder.Configuration);

AddSecretsJsonFileIsEnvironmentIsDev(builder);

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();

// Adds a json file as configuration, an absolute path such as 'C:\Secrets' could also be used.
static void AddSecretsJsonFileIsEnvironmentIsDev(WebApplicationBuilder builder)
{
    if (builder.Environment.IsDevelopment())
    {
        var localDirectory = AppContext.BaseDirectory;
        var relativePathToJson = @"..\..\..\..\..\Secrets\secrets-through-json-file.json";
        var absolutePathToJson = Path.Combine(localDirectory, relativePathToJson);
        builder.Configuration.AddJsonFile(absolutePathToJson, optional: true);
    }
}