namespace booking_app_BE.Businesses.Boundaries.Employee
{
    public interface IUpdateAvatarEmployee
    {
        Task UpdateAsync(RequestUpdateAvatar request);
        public class RequestUpdateAvatar
        {
            public int Id { get; set; }
            public IFormFile Image { get; set; }
        }
    }
}
