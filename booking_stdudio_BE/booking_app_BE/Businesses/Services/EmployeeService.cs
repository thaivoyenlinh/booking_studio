using booking_app_BE.Apis.Employee.Dtos;
using booking_app_BE.Businesses.Boundaries.Employee;
using booking_app_BE.Core;
using booking_app_BE.Core.AutoInit;
using booking_app_BE.Core.Businesses;
using booking_app_BE.Database;
using booking_app_BE.Database.Entity;
using booking_app_BE.Database.Repository;

namespace booking_app_BE.Businesses.Services
{
    [Service]
    public class EmployeeService : BaseService<Employee, IEmployeeRepository>, IEmployeeService
    {
        private readonly BookingStudioContext _dbContext;
        public EmployeeService(
            IEmployeeRepository employeeRepository,
            BookingStudioContext dbContext) : base(employeeRepository)
        {
            dbContext = _dbContext;
        }

        public async Task<IAddEmployee.Response> CreateEmployee(IAddEmployee.Request request)
        {
            var response = await Repository.CreateEmployee(request);
            return response;
        }
        public async Task<PaginatedList<dynamic>> GetEmployee(IGetEmployees.Request request)
        {
            var employeesList = await Repository.GetEmployeeByCondition(request.Name, request.SortHeader, request.SortOrder);
            return await PaginatedList<dynamic>.CreateAsync(employeesList, request.CurrentPage, request.RowsPerPage);
        }

        public async Task<Employee> GetEmployeeDetails(IGetEmployeeDetails.Request request)
        {
            return await Repository.FindByIdAsync(x => x.Id == request.Id);
        }

        public async Task UpdateEmployee(IUpdateEmployee.Request request)
        {
            var employee = await Repository.FindByIdAsync(x => x.Id == request.Id);
            if(employee != null)
            {
                /*employee.Id = employee.Id;
                employee.BadgeId = employee.BadgeId;*/
                employee.Name = request.FirstName + ' ' + request.LastName;
                employee.Email = request.Email;
            }
            await Repository.UpdateAsync(employee);
        }

    }
}
