using booking_app_BE.Apis.Service.Dto;
using booking_app_BE.Businesses.Boundaries.Service;
using Microsoft.AspNetCore.Mvc;

namespace booking_app_BE.Apis.Service
{
    [ApiController]
    [Route("service")]
    public class ServiceController : ControllerBase
    {
        private readonly IAddService _addService;
        private readonly IGetServices _getServices;
        private readonly IGetServiceDetails _getServiceDetails;
        private readonly IUpdateService _updateService;
        private readonly IDeleteService _deleteService;
        private readonly IUpdateBanner _updateBanner;
        private readonly IGetBanners _getBanners;
        private readonly IRemoveServiceFromBanner _removeServiceFromBanner;
        public ServiceController(
            IAddService addService, 
            IGetServices getServices,
            IGetServiceDetails getServiceDetails,
            IUpdateService updateService,
            IDeleteService deleteService,
            IUpdateBanner updateBanner,
            IGetBanners getBanners,
            IRemoveServiceFromBanner removeServiceFromBanner)
        {
            _addService = addService;
            _getServices = getServices;
            _getServiceDetails = getServiceDetails;
            _updateService = updateService;
            _deleteService = deleteService;
            _updateBanner = updateBanner;
            _getBanners = getBanners;
            _removeServiceFromBanner = removeServiceFromBanner;
        }

        [HttpPost("add")]
        //[Authorize]
        public async Task<IActionResult> AddService([FromForm] IAddService.Request request)
        {
            var response = await _addService.ExecuteAsync(request);
            return Ok(response);
        }

        [HttpGet("pagination")]
        public async Task<IActionResult> GetServicesByConditions(
            [FromQuery(Name = "Category")] string? category,
            [FromQuery(Name = "Type")] string? type,
            [FromQuery(Name = "ServiceName")] string? serviceName,
            [FromQuery(Name = "Status")] ServiceEnum.Status? status,
            [FromQuery(Name = "SortHeader")] SortOrderDto.SortHeaderService? sortHeader,
            [FromQuery(Name = "SortOrder")] SortOrderDto.SortOrderService? sortOrder,
            [FromQuery(Name = "CurrentPage")] int currentPage,
            [FromQuery(Name = "RowsPerPage")] int rowsPerPage
            )
        {
            var response = await _getServices.ExecuteAsync(
                new IGetServices.Request(category, type, serviceName, status, sortHeader, sortOrder, currentPage, rowsPerPage));
            return Ok(response);
        }

        [HttpGet("details")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> GetServiceDetails([FromQuery] IGetServiceDetails.Request request)
        {
            var response = await _getServiceDetails.ExecuteAsync(request);
            return Ok(response);
        }

        [HttpPut("update")]
        //[ProducesResponseType(StatusCodes.Status200OK, Type = typeof(IUpdateService.Request))]
        public async Task<IActionResult> UpdateService([FromBody] IUpdateService.RequestService request)
        {
            await _updateService.ExecuteAsync(request);
            return Ok();
        }

        [HttpDelete("delete")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        public async Task<IActionResult> DeleteService([FromQuery] IDeleteService.Request request)
        {
            var response = await _deleteService.DeleteAsync(request);
            return Ok(response);
        }

        [HttpPost("update-banner")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> UpdateBanner([FromBody] IUpdateBanner.UpdateBannerRequest request)
        {
            var response = await _updateBanner.ExecuteAsync(request);
            return Ok(response);
        }

        [HttpGet("banners")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task<IActionResult> UpdateBanner()
        {
            var response = await _getBanners.ExecuteAsync();
            return Ok(response);
        }

        [HttpPost("removeServiceFromBanner")]
        [ProducesResponseType(StatusCodes.Status200OK)]
        public async Task RemoveServiceFromBanner(int serviceId)
        {
             await _removeServiceFromBanner.ExecuteAsync(serviceId);
            //return Ok(response);
        }
    }
}
