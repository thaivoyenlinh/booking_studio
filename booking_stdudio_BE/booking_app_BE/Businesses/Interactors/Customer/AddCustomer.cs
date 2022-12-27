using booking_app_BE.Businesses.Boundaries.Customer;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Customer
{
    [Interactor]
    public class AddCustomer : IAddCustomer
    {
        private readonly ICustomerService _customerService;
        public AddCustomer(ICustomerService customerService)
        {
            _customerService = customerService;
        }
        public async Task<IAddCustomer.Response> ExecuteAsync(IAddCustomer.Request request)
        {
            var response = await _customerService.CreateCustomer(request);
            return response;
        }
    }
}
