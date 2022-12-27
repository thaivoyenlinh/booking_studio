namespace booking_app_BE.Apis.Service.Dto
{
    public class ServiceEnum
    {
        public enum Category
        {
            Wedding = 0,
            Other = 1,
        }

        public enum Type
        {
            Outdoor,
            Studio,
            Film
        }

        public enum Status
        {
            Active,
            InActive
        }
    }
}
