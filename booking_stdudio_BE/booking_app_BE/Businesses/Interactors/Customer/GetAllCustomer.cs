using booking_app_BE.Businesses.Boundaries.Customer;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Customer
{
    [Interactor]
    public class GetAllCustomer : IGetAllCustomer
    {
        private readonly ICustomerService _customerService;
        public GetAllCustomer(ICustomerService customerService)
        {
            _customerService = customerService;
        }

        public async Task<dynamic> ExecuteAsync()
        {
            return await _customerService.GetAllCustomer();
        }
    }
}
