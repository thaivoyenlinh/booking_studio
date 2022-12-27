namespace booking_app_BE.Businesses.Boundaries.Customer
{
    public interface IUpdateCustomer
    {
        Task ExecuteAsync(RequestUpdateCustomer request);
        public class RequestUpdateCustomer
        {
            public int Id { get; set; }
            public string FullName { get; set; }
            public string Address { get; set; }
            public string PhoneNumber { get; set; }
        }
    }
}
