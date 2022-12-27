using booking_app_BE.Businesses.Boundaries.Service;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Service
{
    [Interactor]
    public class RemoveServiceFromBanner : IRemoveServiceFromBanner
    {
        private readonly IServiceService _serviceService;
        public RemoveServiceFromBanner(IServiceService serviceService)
        {
            _serviceService = serviceService;
        }

        public async Task ExecuteAsync(int serviceId)
        {
            await _serviceService.RemoveServiceFromBanner(serviceId);
        }
    }
}
