

using booking_app_BE.Businesses.Boundaries.Service;
using booking_app_BE.Core;
using booking_app_BE.Core.AutoInit;
using booking_app_BE.Core.Businesses;
using booking_app_BE.Database;
using booking_app_BE.Database.Entity;
using booking_app_BE.Database.Repository;

namespace booking_app_BE.Businesses.Services
{
    [Service]
    public class ServiceService : BaseService<Service, IServiceRepository>, IServiceService
    {
        private readonly BookingStudioContext _dbContext;
        public ServiceService(
            IServiceRepository serviceRepository,
            BookingStudioContext dbContext) : base(serviceRepository)
        {
            _dbContext = dbContext;
        }

        public Task<IAddService.Response> CreateService(IAddService.Request request)
        {
            var response = Repository.CreateService(request);
            return response;
        }

        public async Task<PaginatedList<dynamic>> GetServices(IGetServices.Request request)
        {
            var serviceList = await Repository.GetServicesByCondition(request.Category, request.Type, request.ServiceName, request.Status, request.SortHeader, request.SortOrder);
            return await PaginatedList<dynamic>.CreateAsync(serviceList, request.CurrentPage, request.RowsPerPage);
        }

        public async Task<Service> GetServiceDetails(IGetServiceDetails.Request request)
        {
            return await Repository.FindByIdAsync(x => x.Id == request.Id);
        }

        public async Task UpdateService(IUpdateService.RequestService request)
        {
            var service = await Repository.FindByIdAsync(x => x.Id == request.Id);
            if (service != null)
            {
                service.Category = request.Category;
                service.Type = request.Type;
                service.ServiceName = request.ServiceName;
                service.ServiceDetails = request.ServiceDetails;
                service.Price = request.Price;
                service.Status = request.Status;
            }
            await Repository.UpdateAsync(service);
        }

        public async Task<IUpdateBanner.UpdateBannerResponse> UpdateBanner(IUpdateBanner.UpdateBannerRequest request)
        {
            try
            {
                foreach(var id in request.Id)
                {
                    var service = await Repository.FindByIdAsync(x => x.Id == id);
                    if(service != null)
                    {
                        service.BannerSlider = true;
                    }
                    await Repository.UpdateAsync(service);
                }
                return new IUpdateBanner.UpdateBannerResponse(200, "success");
            }
            catch 
            {
                return new IUpdateBanner.UpdateBannerResponse(500, "error");
            } 
            
        }

        public async Task<PaginatedList<dynamic>> GetBanners()
        {
            var result = await Repository.GetBanners();
            var pageSize = result.Count();
            return await PaginatedList<dynamic>.CreateAsync(result, 1, pageSize);
        }

        public async Task RemoveServiceFromBanner(int serviceId)
        {
            var service = await Repository.FindByIdAsync(x => x.Id == serviceId);
            if (service != null)
            {
                service.BannerSlider = false;
            }
            await Repository.UpdateAsync(service);
        }
    }
}
