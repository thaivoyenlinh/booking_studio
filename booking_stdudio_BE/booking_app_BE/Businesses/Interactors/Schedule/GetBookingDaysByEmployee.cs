using booking_app_BE.Businesses.Boundaries.Schedule;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Schedule
{
    [Interactor]
    public class GetBookingDaysByEmployee : IGetBookingDaysByEmployee
    {
        private readonly IScheduleService _scheduleService;
        public GetBookingDaysByEmployee(IScheduleService scheduleService)
        {
            _scheduleService = scheduleService;
        }
        public async Task<List<DateDays>> ExecuteAsync(int employeeId)
        {
            return await _scheduleService.GetDaysByEmployee(employeeId);
        }
    }
}
