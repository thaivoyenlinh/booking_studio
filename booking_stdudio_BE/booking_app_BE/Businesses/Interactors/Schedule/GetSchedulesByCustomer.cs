using booking_app_BE.Businesses.Boundaries.Schedule;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Schedule
{
    [Interactor]
    public class GetSchedulesByCustomer : IGetSchedulesByCustomer
    {
        private readonly IScheduleService _scheduleService;
        public GetSchedulesByCustomer(IScheduleService scheduleService)
        {
            _scheduleService = scheduleService;
        }

        public async Task<IEnumerable<dynamic>> ExecuteAsync(IGetSchedulesByCustomer.GetSchedulesByCustomerRequest request)
        {
            return await _scheduleService.GetSchedulesByCustomer(request);
        }
    }
}
