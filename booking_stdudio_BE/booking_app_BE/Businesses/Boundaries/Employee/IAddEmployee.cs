using booking_app_BE.Apis.Employee.Dtos;

namespace booking_app_BE.Businesses.Boundaries.Employee
{
    public interface IAddEmployee
    {
        Task<Response> ExecuteAsync(Request request);

        public class Request
        {
            public int BadgeId { get; set; }
            public string FirstName { get; set; }
            public string LastName { get; set; }
            public string Email { get; set; }
            public IFormFile Image { get; set; }
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
