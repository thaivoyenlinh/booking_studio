using booking_app_BE.Businesses.Boundaries.MapEmployeeToService;
using Microsoft.AspNetCore.Mvc;

namespace booking_app_BE.Apis.MapEmployeeToService
{
    [ApiController]
    [Route("mapEmployeeToService")]
    public class MapEmployeeToServiceController : Controller
    {
        private readonly IAddMapEmployeeToService _addMapEmployeeToServicel;
        public MapEmployeeToServiceController(IAddMapEmployeeToService addMapEmployeeToService)
        {
            _addMapEmployeeToServicel = addMapEmployeeToService;
        }

        [HttpPost("add")]
        public async Task AddMapEmployeeToService(int employeeId, int serviceId)
        {
             await _addMapEmployeeToServicel.ExecuteAsync(employeeId, serviceId);
        }
    }
}
