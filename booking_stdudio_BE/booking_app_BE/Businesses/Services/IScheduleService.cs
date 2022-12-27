using booking_app_BE.Businesses.Boundaries.Schedule;
using booking_app_BE.Core;
using booking_app_BE.Core.Businesses;
using booking_app_BE.Database.Entity;

namespace booking_app_BE.Businesses.Services
{
    public interface IScheduleService : IBaseService<Schedule>
    {
        Task<IAddSchedule.AddScheduleResponse> CreateSchedule(IAddSchedule.AddScheduleRequest request);
        Task<List<DateDays>> GetDaysByEmployee(int employeeId);
        Task<IEnumerable<dynamic>> GetSchedulesByCustomer(IGetSchedulesByCustomer.GetSchedulesByCustomerRequest request);
        Task UpdateStatusSchedule(IUpdateStatusSchedule.UpdateRequest request);
        Task UpdateRatingSchedule(IUpdateRatingSchedule.UpdateRatingRequest request);
        Task<IGetRatingBySchedule.RatingByScheduleResponse> GetRatingBySchedule(int scheduleId);
        Task UpdateRescheduleSchedule(IUpdateRescheduleSchedule.UpdateRescheduleRequest request);
        Task<IGetScheduleDetails.ScheduleDetailsResponse> GetScheduleDetails (int scheduleId);
        Task<IEnumerable<dynamic>> GetSchedulesByEmployee(IGetSchedulesByEmployee.GetSchedulesByEmployeeRequest request);
        Task<PaginatedList<dynamic>> GetSchedules(IGetSchedules.GetSchedulesRequest request);
    }
}
