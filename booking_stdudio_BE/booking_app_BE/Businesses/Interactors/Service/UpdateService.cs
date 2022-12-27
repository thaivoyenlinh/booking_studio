using booking_app_BE.Businesses.Boundaries.Service;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Service
{
    [Interactor]
    public class UpdateService : IUpdateService
    {
        private readonly IServiceService _serviceService;
        public UpdateService(IServiceService serviceService)
        {
            _serviceService = serviceService;
        }
        public async Task ExecuteAsync(IUpdateService.RequestService request)
        {
            await _serviceService.UpdateService(request);
        }
    }
}
