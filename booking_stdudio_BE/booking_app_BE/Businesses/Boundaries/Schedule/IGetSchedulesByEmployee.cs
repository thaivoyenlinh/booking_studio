using booking_app_BE.Apis.Schedule.Dtos;

namespace booking_app_BE.Businesses.Boundaries.Schedule
{
    public interface IGetSchedulesByEmployee
    {
        Task<IEnumerable<dynamic>> ExecuteAsync(GetSchedulesByEmployeeRequest request);
        public class GetSchedulesByEmployeeRequest
        {
            public int EmployeeId { get; set; }
            public StatusEnumSchedule? Status { get; set; }
            public bool History { get; set; }
        }

        public class GetSchedulesByEmployeeReponse
        {
            public int Id { get; set; }
            public string Date { get; set; }
            public string Status { get; set; }
            public string Total { get; set; }
            public string CustomerName { get; set; }
            public string CustomerPhoneNumber { get; set; }
            public double? EmployeeRating { get; set; }
            public string CustomerImage { get; set; }
            public string ServiceName { get; set; }
            public double? ServiceRating { get; set; }
            public string? UpdateTime { get; set; }
            public string? ReScheduleType { get; set; }
            public string? DateReschedule { get; set; }
        }
    }
}

