using booking_app_BE.Businesses.Boundaries.Customer;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Customer
{
    [Interactor]
    public class UpdateAvatarCustomer : IUpdateAvatarCustomer
    {
        private readonly ICustomerService _customerService;
        public UpdateAvatarCustomer(ICustomerService customerService)
        {
            _customerService = customerService;
        }
        public async Task UpdateAsync(IUpdateAvatarCustomer.RequestUpdateAvatar request)
        {
            await _customerService.UpdateAvatarCustomer(request);    
        }
    }
}
