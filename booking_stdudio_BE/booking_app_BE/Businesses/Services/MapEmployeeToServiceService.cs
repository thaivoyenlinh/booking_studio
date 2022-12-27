using booking_app_BE.Core.AutoInit;
using booking_app_BE.Core.Businesses;
using booking_app_BE.Database;
using booking_app_BE.Database.Entity;
using booking_app_BE.Database.Repository;

namespace booking_app_BE.Businesses.Services
{
    [Service]
    public class MapEmployeeToServiceService : BaseService<MapEmployeeToService, IMapEmployeeToServiceRepository>, IMapEmployeeToServiceService
    {
        private readonly BookingStudioContext _dbContext;
        public MapEmployeeToServiceService(
            IMapEmployeeToServiceRepository mapEmployeeToServiceRepository,
            BookingStudioContext dbContext) : base(mapEmployeeToServiceRepository)
        {
            _dbContext = dbContext;
        }

        public async Task AddMapEmployeeToService(int employeeId, int serviceId)
        {
            await Repository.CreateMapEmployeeToService(employeeId, serviceId);
        }

        public Task<List<int>> GetEmployeeByService(int serviceId)
        {
            return Repository.GetEmployeeByService(serviceId);
        }
    }
}
