namespace booking_app_BE.Apis.Employee.Dtos
{
    public class SortOrderDto
    {
        public enum SortOrder
        {
            ASC,
            DESC
        }

        public enum SortHeader
        {
            Name,
            BadgeId,
            Rating
        }
    }
}
