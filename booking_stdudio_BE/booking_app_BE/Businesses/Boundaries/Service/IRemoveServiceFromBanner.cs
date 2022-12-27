namespace booking_app_BE.Businesses.Boundaries.Service
{
    public interface IRemoveServiceFromBanner
    {
        Task ExecuteAsync(int serviceId);
    }
}
