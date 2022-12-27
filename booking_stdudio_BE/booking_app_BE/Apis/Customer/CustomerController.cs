using booking_app_BE.Businesses.Boundaries.Customer;
using Microsoft.AspNetCore.Mvc;

namespace booking_app_BE.Apis.Customer
{
    [ApiController]
    [Route("customer")]
    public class CustomerController : ControllerBase
    {
        private readonly IAddCustomer _addCustomer;
        private readonly IGetCustomerDetails _getCustomerDetails;
        private readonly IUpdateCustomer _updateCustomer;
        private readonly IUpdateAvatarCustomer _updateAvatarCustomer;
        private readonly IGetAllCustomer _getAllCustomer;
        private readonly IGetCustomers _getCustomers;
        public CustomerController(IAddCustomer addCustomer, 
            IGetCustomerDetails getCustomerDetails,
            IUpdateCustomer updateCustomer,
            IUpdateAvatarCustomer updateAvatarCustomer,
            IGetAllCustomer getAllCustomer,
            IGetCustomers getCustomers)
        {
            _addCustomer = addCustomer;
            _getCustomerDetails = getCustomerDetails;
            _updateCustomer = updateCustomer;
            _updateAvatarCustomer = updateAvatarCustomer;
            _getAllCustomer = getAllCustomer;
            _getCustomers = getCustomers;
        }

        [HttpGet("pagination")]
        public async Task<IActionResult> GetCustomersByConditions(
            [FromQuery(Name = "Name")] string? name,
            [FromQuery(Name = "Address")] string? address,
            [FromQuery(Name = "CurrentPage")] int currentPage,
            [FromQuery(Name = "RowsPerPage")] int rowsPerPage
            )
        {
            var response = await _getCustomers.ExecuteAsync(
                new IGetCustomers.GetCustomersRequest(name, address, currentPage, rowsPerPage));
            return Ok(response);
        }

        [HttpPost("add")]
        //[Authorize]
        public async Task<IActionResult> AddCustomer([FromForm] IAddCustomer.Request request)
        {
            var response = await _addCustomer.ExecuteAsync(request);
            return Ok(response);
        }

        [HttpPost("details")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> GetCustomerDetails([FromQuery] IGetCustomerDetails.Request request)
        {
            var response = await _getCustomerDetails.ExecuteAsync(request);
            return Ok(response);
        }

        [HttpPost("update")]
        [ProducesResponseType(StatusCodes.Status200OK, Type = typeof(IUpdateCustomer.RequestUpdateCustomer))]
        public async Task<IActionResult> UpdateCustomer([FromBody] IUpdateCustomer.RequestUpdateCustomer request)
        {
            await _updateCustomer.ExecuteAsync(request);
            return Ok();
        }

        [HttpPost("updateImageAvatar")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> UpdateImageAvatar([FromForm] IUpdateAvatarCustomer.RequestUpdateAvatar request)
        {
            await _updateAvatarCustomer.UpdateAsync(request);
            return Ok();
        }

        [HttpGet("getAllCustomer")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<dynamic> GetAllCustomer()
        {
            return await _getAllCustomer.ExecuteAsync();
        }

    }
}
