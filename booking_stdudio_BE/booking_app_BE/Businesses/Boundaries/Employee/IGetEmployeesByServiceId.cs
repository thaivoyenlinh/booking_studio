namespace booking_app_BE.Businesses.Boundaries.Employee
{
    public interface IGetEmployeesByServiceId
    {
        Task<List<DetailsEmployee>> ExecuteAsync(int serviceId);

        public class DetailsEmployee
        {
            public int Id { get; set; }
            public int BadgeId { get; set; }
            public string Name { get; set; }
            public string Email { get; set; }
            public string Image { get; set; }
            public string PhoneNumber { get; set; }
        }
    }
}
