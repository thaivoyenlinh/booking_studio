namespace booking_app_BE.Businesses.Boundaries.Service
{
    public interface IUpdateBanner
    {
        Task<UpdateBannerResponse> ExecuteAsync(UpdateBannerRequest request);

        public class UpdateBannerRequest
        {
            public List<int> Id { get; set; }
        }

        public class UpdateBannerResponse
        {
            public int Status { get; set; }
            public string Message { get; set; }
            public UpdateBannerResponse(int status, string message)
            {
                Status = status;
                Message = message;
            }
        }
    }
}
