namespace booking_app_BE.Apis.Identity.Dtos
{
    public class UpdatePasswordDto
    {
        public string Username { get; set; }
        public string CurrentPassword { get; set; }
        public string NewPassword { get; set; }
        public string ConfirmNewPassword { get; set; }
    }
}
