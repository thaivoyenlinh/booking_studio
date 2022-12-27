namespace booking_app_BE.Businesses.Boundaries.Employee
{
    public interface IGetEmployeeDetails
    {
        Task<Response> ExecuteAsync(Request request);

        public class Request
        {
            public Guid EmployeeAccountId { get; set; }
        }

        public class Response
        {
            public int Id { get; set; }
            public int BadgeId { get; set; }
            public string Name { get; set; }
            public string Email { get; set; }
            public string Image { get; set; }
            public string Username { get; set; }
            public string Password { get; set; }
            public string PhoneNumber { get; set; }
            public string Rating { get; set; }
        }
    }
}
