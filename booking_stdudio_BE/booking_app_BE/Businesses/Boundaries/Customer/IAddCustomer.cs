namespace booking_app_BE.Businesses.Boundaries.Customer
{
    public interface IAddCustomer
    {
        Task<Response> ExecuteAsync(Request request);

        public class Request
        {
            public string? FullName { get; set; }
            public string? Address { get; set; }
            public string? PhoneNumber { get; set; }
            public IFormFile? Image { get; set; }
            public string CustomerAccountId { get; set; }
        }

        public class Response
        {
            public int Status { get; set; }
            public string Message { get; set; }
            public Response(int status, string message)
            {
                Status = status;
                Message = message;
            }
        }
    }
}
