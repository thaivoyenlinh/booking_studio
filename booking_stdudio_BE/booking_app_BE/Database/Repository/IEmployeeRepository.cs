using booking_app_BE.Apis.Employee.Dtos;
using booking_app_BE.Businesses.Boundaries.Employee;
using booking_app_BE.Core;
using booking_app_BE.Core.Database;
using booking_app_BE.Database.Entity;

namespace booking_app_BE.Database.Repository
{
    public interface IEmployeeRepository : IBaseRepository<Employee>
    {
        Task<IAddEmployee.Response> CreateEmployee(IAddEmployee.Request request);
        Task<IQueryable<dynamic>> GetEmployeeByCondition(string name, SortOrderDto.SortHeader? sortHeder, SortOrderDto.SortOrder? sortOrder);
    }
}
