using booking_app_BE.Apis.Schedule.Dtos;

namespace booking_app_BE.Businesses.Boundaries.Schedule
{
    public interface IUpdateRescheduleSchedule
    {
        Task ExecuteAsync(UpdateRescheduleRequest request);

        public class UpdateRescheduleRequest
        {
            public int ScheduleId { get; set; }
            public ReScheduleType? RescheduleType { get; set; }
            public string? Days { get; set; }
        }
    }
}
