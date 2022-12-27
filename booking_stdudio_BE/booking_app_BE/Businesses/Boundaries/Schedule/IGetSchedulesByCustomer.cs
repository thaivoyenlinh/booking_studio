using booking_app_BE.Apis.Schedule.Dtos;
using booking_app_BE.Database.Entity;
namespace booking_app_BE.Businesses.Boundaries.Schedule
{
    public interface IGetSchedulesByCustomer
    {
        Task<IEnumerable<dynamic>> ExecuteAsync(GetSchedulesByCustomerRequest request);
        public class GetSchedulesByCustomerRequest
        {
            public int CustomerId { get; set; }
            public bool ScheduleComplete { get; set; }
            public bool? WaitingConfirmReschedule { get; set; }
        }

        public class GetSchedulesByCustomerReponse
        {
            public int Id { get; set; }
            public string Date { get; set; }
            public string Status { get; set; }
            public string Total { get; set; }
            public string EmployeeName { get; set; }
            public string EmployeePhoneNumber { get; set; }
            public double? EmployeeRating { get; set; }
            public string EmployeeImage { get; set; }
            public string ServiceName { get; set; }
            public double? ServiceRating { get; set; }
            public string? DateReschedule { get; set; }
            public string? ReScheduleType { get; set; }
        }
    }
}
