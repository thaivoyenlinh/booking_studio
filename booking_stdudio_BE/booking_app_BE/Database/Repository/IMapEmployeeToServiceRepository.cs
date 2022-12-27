using booking_app_BE.Core.Database;
using booking_app_BE.Database.Entity;

namespace booking_app_BE.Database.Repository
{
    public interface IMapEmployeeToServiceRepository : IBaseRepository<MapEmployeeToService>
    {
        Task<List<int>> GetEmployeeByService(int serviceId);
        Task CreateMapEmployeeToService(int employeeId, int serviceId);
    }
}
