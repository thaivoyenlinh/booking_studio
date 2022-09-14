using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace booking_app_BE.Apis.Users
{
    [ApiController]
    [Route("[controller]")]
    public class UserController : ControllerBase
    {
        [HttpGet, Authorize]
        public IEnumerable<string> Get()
        {
            return new string[] { "John Doe", "Jane Doe" };
        }
    }
}
