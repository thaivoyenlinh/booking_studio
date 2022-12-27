namespace booking_app_BE.Businesses.Boundaries.Schedule
{
    public interface IGetRatingBySchedule
    {
        Task<RatingByScheduleResponse> ExecuteAsync(int scheduleId);

        public class RatingByScheduleResponse
        {
            public double? EmployeeRating { get; set; }
        }
    }
}
