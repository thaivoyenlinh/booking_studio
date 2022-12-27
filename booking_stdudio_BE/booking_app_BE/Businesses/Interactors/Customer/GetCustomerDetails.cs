using booking_app_BE.Businesses.Boundaries.Customer;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Customer
{   
    [Interactor]
    public class GetCustomerDetails : IGetCustomerDetails
    { 
        private readonly ICustomerService _customerService;
        public GetCustomerDetails(ICustomerService customerService)
        {
            _customerService = customerService;
        }
        public async Task<IGetCustomerDetails.Response> ExecuteAsync(IGetCustomerDetails.Request request)
        {
            return await _customerService.GetCustomerDetails(request);
        }
    }
}
