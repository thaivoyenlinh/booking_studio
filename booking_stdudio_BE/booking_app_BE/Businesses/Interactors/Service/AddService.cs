using booking_app_BE.Businesses.Boundaries.Service;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Service
{
    [Interactor]
    public class AddService : IAddService
    {
        private readonly IServiceService _serviceService;
        public AddService(IServiceService serviceService)
        {
            _serviceService = serviceService;
        }
        public async Task<IAddService.Response> ExecuteAsync(IAddService.Request request)
        {
            var response =  await _serviceService.CreateService(request);
            return response;
        }
    }
}
