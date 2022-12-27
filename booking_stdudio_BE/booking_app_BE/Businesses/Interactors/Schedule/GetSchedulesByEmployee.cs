using booking_app_BE.Businesses.Boundaries.Schedule;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Schedule
{
    [Interactor]
    public class GetSchedulesByEmployee : IGetSchedulesByEmployee
    {
        private readonly IScheduleService _scheduleService;
        public GetSchedulesByEmployee(IScheduleService scheduleService)
        {
            _scheduleService = scheduleService;
        }
        public async Task<IEnumerable<dynamic>> ExecuteAsync(IGetSchedulesByEmployee.GetSchedulesByEmployeeRequest request)
        {
            return await _scheduleService.GetSchedulesByEmployee(request);
        }
    }
}
