namespace booking_app_BE.Businesses.Boundaries.Customer
{
    public interface IGetCustomerDetails
    {
        Task<Response> ExecuteAsync(Request request);

        public class Request
        {
            public Guid CustomerAccountId { get; set; }
        }

        public class Response
        {
            public int Id { get; set; }
            public string? FullName { get; set; }
            public string? Address { get; set; }
            public string? PhoneNumber { get; set; }
            public string? Email { get; set; }
            public string? Image { get; set; }
        }
    }
}
