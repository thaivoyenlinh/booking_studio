

using booking_app_BE.Apis.Service.Dto;
using booking_app_BE.Businesses.Boundaries.Service;
using booking_app_BE.Core.Database;
using booking_app_BE.Database.Entity;

namespace booking_app_BE.Database.Repository
{
    public interface IServiceRepository : IBaseRepository<Service>
    {
        Task<IAddService.Response> CreateService(IAddService.Request request);
        Task<IQueryable<dynamic>> GetServicesByCondition(string category, string type, string serviceName, ServiceEnum.Status? status, SortOrderDto.SortHeaderService? sortHeader, SortOrderDto.SortOrderService? sortOrder);
        Task<IQueryable<dynamic>> GetBanners();
    }
}
