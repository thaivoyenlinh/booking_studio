using booking_app_BE.Businesses.Boundaries.Schedule;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Schedule
{
    [Interactor]
    public class UpdateRescheduleSchedule : IUpdateRescheduleSchedule
    {
        private readonly IScheduleService _scheduleService;
        public UpdateRescheduleSchedule(IScheduleService scheduleService)
        {
            _scheduleService = scheduleService;
        }

        public async Task ExecuteAsync(IUpdateRescheduleSchedule.UpdateRescheduleRequest request)
        {
            await _scheduleService.UpdateRescheduleSchedule(request);
        }
    }
}
