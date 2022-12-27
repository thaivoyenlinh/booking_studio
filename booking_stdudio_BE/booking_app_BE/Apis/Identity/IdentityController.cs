using booking_app_BE.Apis.Identity.Dtos;
using booking_app_BE.Apis.Identity.Services.Token;
using booking_app_BE.Businesses.Boundaries.Customer;
using booking_app_BE.Database.Repository;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using System.Security.Claims;

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
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly ICustomerRepository _customerRepository;

        public IdentityController(
            UserManager<IdentityUser> userManager, 
            SignInManager<IdentityUser> signInManager,
            IJWTTokenGenerator jwtToken,
            RoleManager<IdentityRole> roleManager,
            IHttpContextAccessor httpContextAccessor,
            ICustomerRepository customerRepository
            )
        {
            _userManager = userManager;
            _signInManager = signInManager;
            _jwtToken = jwtToken;
            _roleManager = roleManager;
            _httpContextAccessor = httpContextAccessor;
            _customerRepository = customerRepository;
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody]LoginDto request)
        {
            var userFromDb = await _userManager.FindByNameAsync(request.UserName);
            if(userFromDb == null)
            {
                return StatusCode(StatusCodes.Status404NotFound, new { Status = "Error", Message = "User does not exists!" });
            }
            var result = await _signInManager.CheckPasswordSignInAsync(userFromDb, request.Password, false);
            if (!result.Succeeded)
            {
                return BadRequest(new { Status = "Error", Message = "Bad Password!" });
            }
            var roles = await _userManager.GetRolesAsync(userFromDb);
            if (roles != null && roles.First() == "Manager")
            {
                return Ok(new
                {
                    result = result,
                    id = userFromDb.Id,
                    username = userFromDb.UserName,
                    email = userFromDb.Email,
                    role = roles.First(),
                    token = _jwtToken.GenerateToken(userFromDb, roles)
                });
            }         
            return Ok(new
            {
                //result = result,
                id = userFromDb.Id,
                username = userFromDb.UserName,
                email = userFromDb.Email,
                role = roles.First(),
                token = _jwtToken.GenerateToken(userFromDb, roles)
            });
        }

        [HttpPost("register")]
        public async Task<IActionResult> Register([FromForm] RegisterDto request)
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
                string userId = registerInfor.Id;
                string userRole = request.Role;
                var userFromDb = await _userManager.FindByNameAsync(registerInfor.UserName);
                //Add role to user
                await _userManager.AddToRoleAsync(userFromDb, request.Role); 
                if(userRole == "Customer")
                {
                    var requestAddCustomer = new IAddCustomer.Request
                    {
                        CustomerAccountId = userId
                    };
                    await _customerRepository.CreateCustomer(requestAddCustomer);
                    return Ok(new
                    {
                        userId = userId
                    }
                );
                }
                return Ok(new
                    {
                        userId = userId,
                        passwordGenerate = request.Password
                    }
                );
            }
            return BadRequest(result);

        }

        [HttpPost("updatePassword")]
        public async Task<IActionResult> UpdatePassword([FromBody] UpdatePasswordDto request)
        {
            var user = await _userManager.FindByNameAsync(request.Username);
            if(user == null)
            {
                return StatusCode(StatusCodes.Status404NotFound, new { Status = "Error", Message = "User does not exists!" }); 
            }
            if(string.Compare(request.NewPassword, request.ConfirmNewPassword) != 0)
            {
                return StatusCode(StatusCodes.Status400BadRequest, new { Status = "Error", Message = "The new password and confirm new password not match!" });
            }
            var result = await _userManager.ChangePasswordAsync(user, request.CurrentPassword, request.NewPassword);
            if (!result.Succeeded)
            {
                var errors = new List<string>();
                foreach(var error in result.Errors)
                {
                    errors.Add(error.Description);
                }
                return StatusCode(StatusCodes.Status500InternalServerError, new { Status = "Error", Message = string.Join(",", errors) }); 
            }
            return Ok(new {Status = "Success", Message = "Password changed successfully!"});
        }


        [Authorize]
        [HttpPost("getProfileUser")]
        public async Task<IActionResult> GetProfileUserByToken()
        {
            var userId = HttpContext.User.FindFirstValue(ClaimTypes.NameIdentifier); // will give the user's userId
            /*var userName = User.FindFirstValue(ClaimTypes.Name); // will give the user's userName*/
            return Ok(userId);
        }

        /*[HttpPost("confirm-email")]
        public IActionResult ConfirmEmail(RegisterModel model)
        {
            return Ok();
        }*/



    }
}
