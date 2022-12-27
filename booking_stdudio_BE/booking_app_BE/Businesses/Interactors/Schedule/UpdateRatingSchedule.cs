using booking_app_BE.Businesses.Boundaries.Schedule;
using booking_app_BE.Businesses.Services;

namespace booking_app_BE.Businesses.Interactors.Schedule
{
    public class UpdateRatingSchedule : IUpdateRatingSchedule
    {
        private readonly IScheduleService _scheduleService;
        public UpdateRatingSchedule(IScheduleService scheduleService)
        {
            _scheduleService = scheduleService;
        }
        public async Task ExecuteAsync(IUpdateRatingSchedule.UpdateRatingRequest request)
        {
            await _scheduleService.UpdateRatingSchedule(request);
        }
    }
}
