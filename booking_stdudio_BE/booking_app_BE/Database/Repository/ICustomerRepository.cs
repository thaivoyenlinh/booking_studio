using booking_app_BE.Businesses.Boundaries.Customer;
using booking_app_BE.Core.Database;
using booking_app_BE.Database.Entity;

namespace booking_app_BE.Database.Repository
{
    public interface ICustomerRepository : IBaseRepository<Customer>
    {
        Task<IAddCustomer.Response> CreateCustomer(IAddCustomer.Request request);
        Task<dynamic> GetAllCustomer();
        Task<IQueryable<dynamic>> GetCustomersByCondition(string name, string address);
    }
}
