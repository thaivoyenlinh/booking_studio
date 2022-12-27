using booking_app_BE.Businesses.Boundaries.Service;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Service
{
    [Interactor]
    public class GetServiceDetails : IGetServiceDetails
    {
        private readonly IServiceService _serviceService;
        public GetServiceDetails(IServiceService serviceService)
        {
            _serviceService = serviceService;
        }
        public async Task<Database.Entity.Service> ExecuteAsync(IGetServiceDetails.Request request)
        {
            return await _serviceService.GetServiceDetails(request);
        }
    }
}
