using booking_app_BE.Businesses.Boundaries.Service;
using booking_app_BE.Core;
using booking_app_BE.Core.Businesses;
using booking_app_BE.Database.Entity;


namespace booking_app_BE.Businesses.Services
{
    public interface IServiceService : IBaseService<Service>
    {
        Task<IAddService.Response> CreateService(IAddService.Request request);
        Task<PaginatedList<dynamic>> GetServices(IGetServices.Request request);
        Task<Service> GetServiceDetails(IGetServiceDetails.Request request);
        Task UpdateService(IUpdateService.RequestService request);
        Task<IUpdateBanner.UpdateBannerResponse> UpdateBanner(IUpdateBanner.UpdateBannerRequest request);
        Task<PaginatedList<dynamic>> GetBanners();
        Task RemoveServiceFromBanner(int serviceId);
    }
}
