using booking_app_BE.Businesses.Boundaries.Employee;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Employee
{
    [Interactor]
    public class UpdateAvatarEmployee : IUpdateAvatarEmployee
    {
        private readonly IEmployeeService _employeeService;
        public UpdateAvatarEmployee(IEmployeeService employeeService)
        {
            _employeeService = employeeService;
        }

        public async Task UpdateAsync(IUpdateAvatarEmployee.RequestUpdateAvatar request)
        {
            await _employeeService.UpdateAvatarEmployee(request);
        }
    }
}
