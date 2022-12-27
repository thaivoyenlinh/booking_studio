using booking_app_BE.Businesses.Boundaries.Schedule;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Schedule
{
    [Interactor]
    public class GetSchedules : IGetSchedules
    {
        private readonly IScheduleService _scheduleService;
        public GetSchedules(IScheduleService scheduleService)
        {
            _scheduleService = scheduleService;
        }

        public Task<PaginatedList<dynamic>> ExecuteAsync(IGetSchedules.GetSchedulesRequest request)
        {
            return _scheduleService.GetSchedules(request);
        }
    }
}
