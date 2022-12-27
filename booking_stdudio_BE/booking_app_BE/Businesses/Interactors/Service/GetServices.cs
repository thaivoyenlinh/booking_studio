using booking_app_BE.Businesses.Boundaries.Service;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core;

namespace booking_app_BE.Businesses.Interactors.Service
{
    public class GetServices : IGetServices
    { 
        private readonly IServiceService _serviceService;
        public GetServices(IServiceService serviceService)
        {
            _serviceService = serviceService;   
        }

        public async Task<PaginatedList<dynamic>> ExecuteAsync(IGetServices.Request request)
        {
            var response = await _serviceService.GetServices(request);
            return response;
        }
    }
}
