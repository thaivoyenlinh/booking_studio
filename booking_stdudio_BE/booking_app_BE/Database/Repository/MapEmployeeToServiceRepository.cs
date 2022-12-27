using booking_app_BE.Core.AutoInit;
using booking_app_BE.Core.Database;
using booking_app_BE.Database.Entity;
using Microsoft.EntityFrameworkCore;
using System.Linq.Expressions;

namespace booking_app_BE.Database.Repository
{
    [Repository]
    public class MapEmployeeToServiceRepository : BaseRepository<MapEmployeeToService>, IMapEmployeeToServiceRepository
    {
        private readonly DbSet<MapEmployeeToService> _dbSet;
        private readonly IWebHostEnvironment _webHostEnvironment;
        public MapEmployeeToServiceRepository(BookingStudioContext bookingStudioContext,
            IWebHostEnvironment webHostEnvironment) : base(bookingStudioContext)
        {
            _dbSet = _dbContext.Set<MapEmployeeToService>();
            _webHostEnvironment = webHostEnvironment;
        }

        public async Task CreateMapEmployeeToService(int employeeId, int serviceId)
        {
            if (employeeId != null && serviceId != null)
            {
                var mapEmployeeToService = new MapEmployeeToService
                {
                    EmployeeID = employeeId,
                    ServiceID = serviceId
                };
                _dbContext.Set<MapEmployeeToService>().Add(mapEmployeeToService);
                await _dbContext.SaveChangesAsync();
            }
        }

        public async Task<List<int>> GetEmployeeByService(int serviceId)
        {
            //var result = queryable.Select(s => new
            return await _dbContext.Set<MapEmployeeToService>().AsNoTracking()
                            .Where(m => m.ServiceID == serviceId).Select(x => x.EmployeeID).ToListAsync();
        }
    }
}
