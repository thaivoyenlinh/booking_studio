﻿namespace booking_app_BE.Apis.Identity.Dtos
{
    public class RegisterDto
    {
        public string UserName { get; set; }
        public string Password { get; set; }
        public string Email { get; set; }
        public string Role { get; set; }

    }
}
