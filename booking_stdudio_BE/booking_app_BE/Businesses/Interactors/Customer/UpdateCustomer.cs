using booking_app_BE.Businesses.Boundaries.Customer;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Customer
{
    [Interactor]
    public class UpdateCustomer : IUpdateCustomer
    {
        private readonly ICustomerService _customerService;
        public UpdateCustomer(ICustomerService customerService)
        {
            _customerService = customerService;
        }
        public async Task ExecuteAsync(IUpdateCustomer.RequestUpdateCustomer request)
        {
            await _customerService.UpdateCustomer(request);
        }
    }
}
