using booking_app_BE.Apis.Employee.Dtos;
using booking_app_BE.Businesses.Boundaries.Employee;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Employee
{
    [Interactor]
    public class AddEmployee : IAddEmployee
    {
        private readonly IEmployeeService _employeeService;
        public AddEmployee(IEmployeeService employeeService)
        {
            _employeeService = employeeService;
        }

        public async Task<IAddEmployee.Response> ExecuteAsync(IAddEmployee.Request request)
        {
            var response = await _employeeService.CreateEmployee(request);
            return response;
        }
    }
}
