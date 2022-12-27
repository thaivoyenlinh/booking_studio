using booking_app_BE.Businesses.Boundaries.Schedule;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Schedule
{
    [Interactor]
    public class AddSchedule : IAddSchedule
    {
        private readonly IScheduleService _scheduleService;
        public AddSchedule(IScheduleService scheduleService)
        {
            _scheduleService = scheduleService;
        }
        public async Task<IAddSchedule.AddScheduleResponse> ExecuteAsync(IAddSchedule.AddScheduleRequest request)
        {
            var response = await _scheduleService.CreateSchedule(request);
            return response;
        }
    }
}
