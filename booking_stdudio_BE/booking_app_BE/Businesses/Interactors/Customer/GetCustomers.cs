using booking_app_BE.Businesses.Boundaries.Customer;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Customer
{
    [Interactor]
    public class GetCustomers : IGetCustomers
    {
        private readonly ICustomerService _customerService;
        public GetCustomers(ICustomerService customerService)
        {
            _customerService = customerService;
        }

        public Task<PaginatedList<dynamic>> ExecuteAsync(IGetCustomers.GetCustomersRequest request)
        {
            return _customerService.GetCustomers(request);
        }
    }
}
