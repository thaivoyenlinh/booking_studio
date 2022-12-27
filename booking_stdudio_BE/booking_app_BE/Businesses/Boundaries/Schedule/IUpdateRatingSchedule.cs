namespace booking_app_BE.Businesses.Boundaries.Schedule
{
    public interface IUpdateRatingSchedule
    {
        Task ExecuteAsync(UpdateRatingRequest request);

        public class UpdateRatingRequest
        {
            public int ScheduleId { get; set; }
            public double EmployeeRating { get; set; }
            public double ServiceRating { get; set; }
        }
    }
}
