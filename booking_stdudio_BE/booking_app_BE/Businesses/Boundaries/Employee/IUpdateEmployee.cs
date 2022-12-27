namespace booking_app_BE.Businesses.Boundaries.Employee
{
    public interface IUpdateEmployee
    {
        Task ExecuteAsync(Request request);
        public class Request
        {
            public int Id { get; set; }
            public int BadgeId { get; set; }
            public string FirstName { get; set; }
            public string LastName { get; set; }
            public string Email { get; set; }
            public string PhoneNumber { get; set; }
        }
    }
}
