using booking_app_BE.Businesses.Boundaries.Service;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Service
{
    [Interactor]
    public class GetBanners : IGetBanners
    {
        private readonly IServiceService _serviceService;
        public GetBanners(IServiceService serviceService)
        {
            _serviceService = serviceService;
        }

        public async Task<PaginatedList<dynamic>> ExecuteAsync()
        {
            var result = await _serviceService.GetBanners();
            return result;
        }
    }
}
