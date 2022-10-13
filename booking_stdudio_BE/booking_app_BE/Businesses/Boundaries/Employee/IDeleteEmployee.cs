namespace booking_app_BE.Businesses.Boundaries.Employee
{
    public interface IDeleteEmployee
    {
        Task<Response> DeleteAsync(Request request);

        public class Request
        {
            public int EmployeeId { get; set; }
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
