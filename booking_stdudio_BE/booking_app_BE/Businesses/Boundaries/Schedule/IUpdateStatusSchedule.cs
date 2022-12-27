using booking_app_BE.Apis.Schedule.Dtos;

namespace booking_app_BE.Businesses.Boundaries.Schedule
{
    public interface IUpdateStatusSchedule
    {
        Task ExecuteAsync(UpdateRequest request);

        public class UpdateRequest
        {
            public int ScheduleId { get; set; }
            public StatusEnumSchedule Status { get; set; }
        }
    }
}
