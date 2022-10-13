using booking_app_BE.Businesses.Boundaries.Employee;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Employee
{
    [Interactor]
    public class GetEmployees : IGetEmployees
    {
        private readonly IEmployeeService _employeeService;
        public GetEmployees(IEmployeeService employeeService)
        {
                _employeeService = employeeService;
        }
        public Task<PaginatedList<dynamic>> ExecuteAsync(IGetEmployees.Request request)
        {
            return _employeeService.GetEmployee(request);
        }
    }
}
