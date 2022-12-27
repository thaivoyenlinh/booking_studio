using booking_app_BE.Businesses.Boundaries.MapEmployeeToService;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.MapEmployeeToService
{
    [Interactor]
    public class AddMapEmployeeToService : IAddMapEmployeeToService
    {
        private readonly IMapEmployeeToServiceService _mapEmployeeToServiceService;
        public AddMapEmployeeToService(IMapEmployeeToServiceService mapEmployeeToServiceService)
        {
            _mapEmployeeToServiceService = mapEmployeeToServiceService;
        }

        public async Task ExecuteAsync(int employeeId, int serviceId)
        {
            await _mapEmployeeToServiceService.AddMapEmployeeToService(employeeId, serviceId);
        }
    }
}
