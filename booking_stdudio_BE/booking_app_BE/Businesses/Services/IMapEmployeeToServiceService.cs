using booking_app_BE.Core.Businesses;
using booking_app_BE.Database.Entity;

namespace booking_app_BE.Businesses.Services
{
    public interface IMapEmployeeToServiceService : IBaseService<MapEmployeeToService>
    {
        Task<List<int>> GetEmployeeByService(int serviceId);
        Task AddMapEmployeeToService(int employeeId, int serviceId);
    }
}
