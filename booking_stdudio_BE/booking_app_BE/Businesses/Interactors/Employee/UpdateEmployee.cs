using booking_app_BE.Businesses.Boundaries.Employee;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Employee
{
    [Interactor]
    public class UpdateEmployee : IUpdateEmployee
    {
        private readonly IEmployeeService _employeeService;
        public UpdateEmployee(IEmployeeService employeeService)
        {
            _employeeService = employeeService;
        }

        public async Task ExecuteAsync(IUpdateEmployee.Request request)
        {
            await _employeeService.UpdateEmployee(request);
        }
    }
}
