namespace booking_app_BE.Businesses.Boundaries.Service
{
    public interface IGetServiceDetails
    {
        Task<Database.Entity.Service> ExecuteAsync(Request request);

        public class Request
        {
            public int Id { get; set; }
        }
    }
}
