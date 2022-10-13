using Microsoft.AspNetCore.Identity;
using System.Security.Claims;

namespace booking_app_BE.Apis.Identity.Services.Token
{
    public interface IJWTTokenGenerator
    {
        string GenerateToken(IdentityUser user, IList<string> roles);
    }
}
