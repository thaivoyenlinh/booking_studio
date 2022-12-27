using booking_app_BE.Businesses.Boundaries.Employee;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Employee
{
    [Interactor]
    public class GetEmployeesByServiceId : IGetEmployeesByServiceId
    {
        private readonly IMapEmployeeToServiceService _mapEmployeeToServiceService;
        private readonly IEmployeeService _employeeService;
        public GetEmployeesByServiceId(
            IMapEmployeeToServiceService mapEmployeeToServiceService,
            IEmployeeService employeeService
            )
        {
            _mapEmployeeToServiceService = mapEmployeeToServiceService;
            _employeeService = employeeService;
        }

        public async Task<List<IGetEmployeesByServiceId.DetailsEmployee>> ExecuteAsync(int serviceId)
        {
            List<int> employeeId = await _mapEmployeeToServiceService.GetEmployeeByService(serviceId);
            var result = await _employeeService.GetEmployeesByService(employeeId);
            return result;
        }
    }
}
