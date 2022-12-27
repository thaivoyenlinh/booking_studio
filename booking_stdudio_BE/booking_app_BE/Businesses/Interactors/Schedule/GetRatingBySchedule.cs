using booking_app_BE.Businesses.Boundaries.Schedule;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Schedule
{
    [Interactor]
    public class GetRatingBySchedule : IGetRatingBySchedule
    {
        private readonly IScheduleService _scheduleService;
        public GetRatingBySchedule(IScheduleService scheduleService)
        {
            _scheduleService = scheduleService;
        }

        public async Task<IGetRatingBySchedule.RatingByScheduleResponse> ExecuteAsync(int scheduleId)
        {
            return await _scheduleService.GetRatingBySchedule(scheduleId);
        }
    }
}
