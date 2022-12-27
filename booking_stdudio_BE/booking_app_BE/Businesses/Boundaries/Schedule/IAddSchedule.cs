using booking_app_BE.Apis.Schedule.Dtos;

namespace booking_app_BE.Businesses.Boundaries.Schedule
{
    public interface IAddSchedule
    {
        Task<AddScheduleResponse> ExecuteAsync(AddScheduleRequest request);

        public class AddScheduleRequest
        {
            public int CustomerId { get; set; }
            public int EmployeeId { get; set; }
            public int ServiceId { get; set; }
            public string Date { get; set; }
            public StatusEnumSchedule Status { get; set; }
            public string Total { get; set; }
        }

        public class AddScheduleResponse
        {
            public int Status { get; set; }
            public string Message { get; set; }
            public AddScheduleResponse(int status, string message)
            {
                Status = status;
                Message = message;
            }
        }
    }
}
