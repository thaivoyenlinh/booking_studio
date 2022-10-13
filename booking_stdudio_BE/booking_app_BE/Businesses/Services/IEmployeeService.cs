using booking_app_BE.Apis.Employee.Dtos;
using booking_app_BE.Businesses.Boundaries.Employee;
using booking_app_BE.Core;
using booking_app_BE.Core.Businesses;
using booking_app_BE.Database.Entity;

namespace booking_app_BE.Businesses.Services
{
    public interface IEmployeeService : IBaseService<Employee>
    {
        Task<IAddEmployee.Response> CreateEmployee(IAddEmployee.Request request);
        Task<PaginatedList<dynamic>> GetEmployee(IGetEmployees.Request request);
        Task<Employee> GetEmployeeDetails(IGetEmployeeDetails.Request request);
        Task UpdateEmployee(IUpdateEmployee.Request request);
    }
}
