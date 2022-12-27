using booking_app_BE.Apis.Service.Dto;

namespace booking_app_BE.Businesses.Boundaries.Service
{
    public interface IUpdateService
    {
        Task ExecuteAsync(RequestService request);
        public class RequestService
        {
            public int Id { get; set; }
            public string Category { get; set; }
            public string Type { get; set; }
            public string ServiceName { get; set; }
            public string ServiceDetails { get; set; }
            public decimal Price { get; set; }
            public ServiceEnum.Status Status { get; set; }
        }
    }
}
