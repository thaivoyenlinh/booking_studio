using booking_app_BE.Businesses.Boundaries.Schedule;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Schedule
{
    [Interactor]
    public class UpdateStatusSchedule : IUpdateStatusSchedule
    {
        private readonly IScheduleService _scheduleService;
        public UpdateStatusSchedule(IScheduleService scheduleService)
        {
            _scheduleService = scheduleService;
        }

        public async Task ExecuteAsync(IUpdateStatusSchedule.UpdateRequest request)
        {
            await _scheduleService.UpdateStatusSchedule(request);
        }
    }
}
