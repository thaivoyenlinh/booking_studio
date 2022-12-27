using booking_app_BE.Apis.Schedule.Dtos;
using booking_app_BE.Businesses.Boundaries.Schedule;
using booking_app_BE.Core.Database;
using booking_app_BE.Database.Entity;
using static booking_app_BE.Database.Repository.ScheduleRepository;

namespace booking_app_BE.Database.Repository
{
    public interface IScheduleRepository : IBaseRepository<Schedule>
    {
        Task<IAddSchedule.AddScheduleResponse> CreateSchedule(IAddSchedule.AddScheduleRequest request);
        Task<List<MyDate>> GetScheduleByEmployee(int employeeId);
        Task<List<IGetSchedulesByCustomer.GetSchedulesByCustomerReponse>> GetSchedulesByCustomer(IGetSchedulesByCustomer.GetSchedulesByCustomerRequest request);
        Task<List<IGetSchedulesByEmployee.GetSchedulesByEmployeeReponse>> GetSchedulesByEmployee(IGetSchedulesByEmployee.GetSchedulesByEmployeeRequest request);
        Task<IQueryable<dynamic>> GetSchedulesByCondition(string date, string status, SortOrderDto.SortHeaderSchedule? sortHeder, SortOrderDto.SortOrderSchedule? sortOrder);

        //Task GetSchedulesDetails(int scheduleId);

        //Task GetRatingBySchedule(int schedulId);
    }
}
