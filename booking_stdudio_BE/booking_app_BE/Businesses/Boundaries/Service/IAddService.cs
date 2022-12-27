using booking_app_BE.Apis.Service.Dto;

namespace booking_app_BE.Businesses.Boundaries.Service
{
    public interface IAddService
    {
        Task<Response> ExecuteAsync(Request request);
        public class Request
        {
            public ServiceEnum.Category Category { get; set; }
            public ServiceEnum.Type Type { get; set; }
            public string ServiceName { get; set; }
            public string ServiceDetails { get; set; }
            public decimal Price { get; set; }
            public ServiceEnum.Status Status { get; set; }
            public bool BannerSlider { get; set; }
            public IFormFile BannerImage { get; set; }
            public List<IFormFile> Image { get; set; }
            public string? Discount { get; set; }
        }

        public class Response
        {
            public int Status { get; set; }
            public string Message { get; set; }
            public Response(int status, string message)
            {
                Status = status;
                Message = message;
            }
        }
    }
}
