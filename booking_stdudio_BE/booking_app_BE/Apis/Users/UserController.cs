using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace booking_app_BE.Apis.Users
{
    [ApiController]
    [Route("user")]
    public class UserController : ControllerBase
    {
        [HttpGet("administrators")]
        [Authorize(Roles = "Administrator")]
        public IEnumerable<string> GetAdministrators()
        {
            return new string[] { "Administrator1", "Administrator2" };
        }

        [HttpGet("managers")]
        [Authorize(Roles = "Manager")]
        public IEnumerable<string> GetManagers()
        {
            return new string[] { "Manager1", "Manager2" };
        }

        [HttpGet("users")]
        [Authorize(Roles = "User")]
        public IEnumerable<string> GetUsers()
        {
            return new string[] { "User1", "User2", "User3" };
        }
    }
}
