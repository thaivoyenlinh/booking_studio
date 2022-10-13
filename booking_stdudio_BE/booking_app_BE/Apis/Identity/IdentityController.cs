using booking_app_BE.Apis.Identity.Dtos;
using booking_app_BE.Apis.Identity.Services.Token;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace booking_app_BE.Apis.Identity
{
    [Route("identity")]
    [ApiController]
    public class IdentityController : ControllerBase
    {
        private readonly UserManager<IdentityUser> _userManager;
        private readonly SignInManager<IdentityUser> _signInManager;
        private readonly IJWTTokenGenerator _jwtToken;
        private readonly RoleManager<IdentityRole> _roleManager;

        public IdentityController(
            UserManager<IdentityUser> userManager, 
            SignInManager<IdentityUser> signInManager,
            IJWTTokenGenerator jwtToken,
            RoleManager<IdentityRole> roleManager
            )
        {
            _userManager = userManager;
            _signInManager = signInManager;
            _jwtToken = jwtToken;
            _roleManager = roleManager;
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login(LoginDto request)
        {
            var userFromDb = await _userManager.FindByNameAsync(request.UserName);
            if(userFromDb == null)
            {
                return BadRequest();
            }
            var result = await _signInManager.CheckPasswordSignInAsync(userFromDb, request.Password, false);
            if (!result.Succeeded)
            {
                return BadRequest();
            }
            var roles = await _userManager.GetRolesAsync(userFromDb);
            return Ok(new
            {
                result = result,
                username = userFromDb.UserName,
                email = userFromDb.Email,
                token = _jwtToken.GenerateToken(userFromDb, roles)
            });
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register(RegisterDto request)
        {
            if(!(await _roleManager.RoleExistsAsync(request.Role)))
            {
                await _roleManager.CreateAsync(new IdentityRole(request.Role));
            }

            var registerInfor = new IdentityUser
            {
                UserName = request.UserName,
                Email = request.Email,
            };

            var result = await _userManager.CreateAsync(registerInfor, request.Password);

            if (result.Succeeded)
            {
                var userFromDb = await _userManager.FindByNameAsync(registerInfor.UserName);
                //Add role to user
                await _userManager.AddToRoleAsync(userFromDb, request.Role);
                return Ok();
            }
            return BadRequest(result);

        }

        /*[HttpPost("confirm-email")]
        public IActionResult ConfirmEmail(RegisterModel model)
        {
            return Ok();
        }*/

    }
}
