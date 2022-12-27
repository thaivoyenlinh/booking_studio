using booking_app_BE.Core;

namespace booking_app_BE.Businesses.Boundaries.Service
{
    public interface IGetBanners
    {
        Task<PaginatedList<dynamic>> ExecuteAsync();

        public class BannerReponse
        {
           public int Id { get; set; }
           public string ImageBanner { get; set; }
        }
    }
}
