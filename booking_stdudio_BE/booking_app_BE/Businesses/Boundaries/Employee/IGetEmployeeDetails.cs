namespace booking_app_BE.Businesses.Boundaries.Employee
{
    public interface IGetEmployeeDetails
    {
        Task<Database.Entity.Employee> ExecuteAsync(Request request);

        public class Request
        {
            public int Id { get; set; }
        }
    }
}
