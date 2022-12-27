namespace booking_app_BE.Businesses.Boundaries.Service
{
    public interface IDeleteService
    {
        Task<Response> DeleteAsync(Request request);

        public class Request
        {
            public int ServiceId { get; set; }
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
