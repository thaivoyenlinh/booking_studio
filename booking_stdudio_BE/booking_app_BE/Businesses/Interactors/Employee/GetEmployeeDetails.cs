using booking_app_BE.Businesses.Boundaries.Employee;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Employee
{
    [Interactor]
    public class GetEmployeeDetails : IGetEmployeeDetails
    {
        private readonly IEmployeeService _employeeService;
        public GetEmployeeDetails(IEmployeeService employeeService)
        {
            _employeeService = employeeService;
        }
        public async Task<Database.Entity.Employee> ExecuteAsync(IGetEmployeeDetails.Request request)
        {
            return await _employeeService.GetEmployeeDetails(request);
        }
    }
}
