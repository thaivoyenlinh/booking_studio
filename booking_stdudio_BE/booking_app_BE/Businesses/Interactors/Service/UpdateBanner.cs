using booking_app_BE.Businesses.Boundaries.Service;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Service
{
    [Interactor]
    public class UpdateBanner : IUpdateBanner
    {
        private readonly IServiceService _serviceService;
        public UpdateBanner(IServiceService serviceService)
        {
            _serviceService = serviceService;
        }

        public async Task<IUpdateBanner.UpdateBannerResponse> ExecuteAsync(IUpdateBanner.UpdateBannerRequest request)
        {
            var result = await _serviceService.UpdateBanner(request);
            return result;
        }
    }
}
