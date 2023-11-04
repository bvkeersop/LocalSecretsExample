using LocalSecretsExample.Options;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;

namespace LocalSecretsExample.Controllers;

[ApiController]
[Route("[controller]")]
public class MessageController : ControllerBase
{
    private readonly IOptions<LocalSecretManagementOptions> _options;

    public MessageController(IOptions<LocalSecretManagementOptions> options)
    {
        _options = options;
    }

    [HttpGet(Name = "GetMessage")]
    public ActionResult<string> GetMessage() => Ok($"{_options.Value.Greeting} from {_options.Value.Person}");
}
