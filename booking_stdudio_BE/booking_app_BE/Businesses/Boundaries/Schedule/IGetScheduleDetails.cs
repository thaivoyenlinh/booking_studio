using booking_app_BE.Businesses.Services;

namespace booking_app_BE.Businesses.Boundaries.Schedule
{
    public interface IGetScheduleDetails
    {
        Task<ScheduleDetailsResponse> ExecuteAsync(int scheduleId);
        public class ScheduleDetailsResponse
        {
            public int ScheduleId { get; set; }
            public string Date { get; set; }
            public string Status { get; set; }
            public int EmployeeId { get; set; }
            public string EmployeeName { get; set; }
            public string EmployeePhoneNumber { get; set; }
            public string EmployeeImage { get; set; }
            public string ServiceName { get; set; }
            public string Total { get; set; }
            public string CustomerName { get; set; }
            public string CustomerPhoneNumber { get; set; }
            public string CustomerImage { get; set; }
            public List<DateDays> EmployeeBookingDays { get; set; }
        }
    }
}
