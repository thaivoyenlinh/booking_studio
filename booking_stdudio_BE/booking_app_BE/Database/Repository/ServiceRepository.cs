using booking_app_BE.Apis.Service.Dto;
using booking_app_BE.Businesses.Boundaries.Service;
using booking_app_BE.Core.AutoInit;
using booking_app_BE.Core.Database;
using booking_app_BE.Database.Entity;
using Microsoft.EntityFrameworkCore;

namespace booking_app_BE.Database.Repository
{
    [Repository]
    public class ServiceRepository : BaseRepository<Service>, IServiceRepository
    {
        private readonly DbSet<Service> _dbSet;
        private readonly IWebHostEnvironment _webHostEnvironment;
        public ServiceRepository(BookingStudioContext bookingStudioContext,
            IWebHostEnvironment webHostEnvironment) : base(bookingStudioContext)
        {
            _dbSet = _dbContext.Set<Service>();
            _webHostEnvironment = webHostEnvironment;
        }

        public async Task<IAddService.Response> CreateService(IAddService.Request request)
        {
            try
            {
                var fileNameBanner = "";

                if (request.BannerImage != null)
                {
                    string folder = "Images\\Services";
                    fileNameBanner = request.ServiceName + "_" + request.BannerImage.FileName;
                    string path = _webHostEnvironment.WebRootPath + '\\' + folder;
                    string serverFolder = Path.Combine(path, fileNameBanner);
                    await request.BannerImage.CopyToAsync(new FileStream(serverFolder, FileMode.Create));
                }
                /*System.GC.Collect();
                System.GC.WaitForPendingFinalizers();*/
                List<string> filePathList = new List<string>();
                foreach(var image in request.Image)
                {
                    var fileName = "";                                                                        
                    string folder = "Images\\Services";
                    fileName = request.ServiceName + "_" + image.FileName;
                    string path = _webHostEnvironment.WebRootPath + '\\' + folder;
                    string serverFolder = Path.Combine(path, fileName);
                    await image.CopyToAsync(new FileStream(serverFolder, FileMode.Create));
                    filePathList.Add(fileName);
                }
                var service = new Service
                {
                    Category = request.Category.ToString(),
                    Type = request.Type.ToString(),
                    ServiceName = request.ServiceName,
                    ServiceDetails = request.ServiceDetails,
                    Price = request.Price,
                    Status = request.Status,
                    BannerSlider = request.BannerSlider,
                    BannerImage = fileNameBanner,
                    Image = filePathList,
                    Discount = request.Discount
                };
                _dbContext.Set<Service>().Add(service);
                await _dbContext.SaveChangesAsync();
                return new IAddService.Response(200, "success");
            } catch
            {
                return new IAddService.Response(500, "error");
            }
        }

        public async Task<IQueryable<dynamic>> GetBanners()
        {
            var result = _dbSet.AsNoTracking().Where(x => x.BannerSlider.Equals(true)).Select(s => new 
            {
                Id = s.Id,
                ImageBanner = s.BannerImage,
                ServiceName = s.ServiceName,
            });
            await Task.Delay(1);
            return result;
        }

        public async Task<IQueryable<dynamic>> GetServicesByCondition(string category, string type, string serviceName, ServiceEnum.Status? status, SortOrderDto.SortHeaderService? sortHeader, SortOrderDto.SortOrderService? sortOrder)
        {
            var queryable = _dbSet.AsNoTracking();
            if (!string.IsNullOrEmpty(category))
            {
                queryable = queryable.Where(x => x.Category.Contains(category));
            }
            if (!string.IsNullOrEmpty(serviceName))
            {
                queryable = queryable.Where(x => x.ServiceName.Contains(serviceName));
            }
            if (!string.IsNullOrEmpty(type))
            {
                queryable = queryable.Where(x => x.Type.Contains(type));
            }
            if (status != null)
            {
                queryable = queryable.Where(x => x.Status == status);
            }
            var result = queryable.Select(s => new
            {
                id = s.Id,
                category = s.Category,
                type = s.Type,
                serviceName = s.ServiceName,
                serviceDetails = s.ServiceDetails,  
                price = s.Price,
                discont = s.Discount,
                status = s.Status,
                banner = s.BannerImage,
                image = s.Image,
                rating = _dbContext.Set<Schedule>().AsNoTracking().Where(e => e.ServiceId == s.Id).Select(e => e.ServiceRating).Average(),
            });

            switch (sortHeader)
            {
                case SortOrderDto.SortHeaderService.Price:
                    result = sortOrder == SortOrderDto.SortOrderService.ASC
                        ? result.OrderBy(x => x.price).ThenBy(x => x.serviceName)
                        : result.OrderByDescending(x => x.price).ThenBy(x => x.serviceName);
                    break;
                case SortOrderDto.SortHeaderService.Rating:
                    result = sortOrder == SortOrderDto.SortOrderService.ASC
                        ? result.OrderBy(x => x.rating).ThenBy(x => x.serviceName)
                        : result.OrderByDescending(x => x.rating).ThenBy(x => x.serviceName);
                    break;
            }
            await Task.Delay(1);
            return result;
        }

    }
}
