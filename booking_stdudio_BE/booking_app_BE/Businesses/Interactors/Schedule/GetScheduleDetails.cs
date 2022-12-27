using booking_app_BE.Businesses.Boundaries.Schedule;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Schedule
{
    [Interactor]
    public class GetScheduleDetails : IGetScheduleDetails
    {
        private readonly IScheduleService _scheduleService;
        public GetScheduleDetails(IScheduleService scheduleService)
        {
            _scheduleService = scheduleService;
        }

        public async Task<IGetScheduleDetails.ScheduleDetailsResponse> ExecuteAsync(int scheduleId)
        {
            return await _scheduleService.GetScheduleDetails(scheduleId); 
        }
    }
}
