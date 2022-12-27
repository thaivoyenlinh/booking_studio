using booking_app_BE.Businesses.Boundaries.Customer;
using booking_app_BE.Core;
using booking_app_BE.Core.Businesses;
using booking_app_BE.Database.Entity;

namespace booking_app_BE.Businesses.Services
{
    public interface ICustomerService : IBaseService<Customer>
    {
        Task<IAddCustomer.Response> CreateCustomer(IAddCustomer.Request request);
        Task<IGetCustomerDetails.Response> GetCustomerDetails(IGetCustomerDetails.Request request);
        Task UpdateCustomer(IUpdateCustomer.RequestUpdateCustomer request);
        Task UpdateAvatarCustomer(IUpdateAvatarCustomer.RequestUpdateAvatar request);
        Task<dynamic> GetAllCustomer();
        Task<PaginatedList<dynamic>> GetCustomers(IGetCustomers.GetCustomersRequest request);
    }
}
