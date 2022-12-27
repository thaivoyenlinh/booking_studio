namespace booking_app_BE.Businesses.Boundaries.Customer
{
    public interface IUpdateAvatarCustomer
    {
        Task UpdateAsync(RequestUpdateAvatar request);
        public class RequestUpdateAvatar
        {
            public int Id { get; set; }
            public IFormFile Image { get; set; }
        }
    }
}
