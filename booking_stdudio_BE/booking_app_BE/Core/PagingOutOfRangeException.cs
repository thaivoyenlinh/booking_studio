using booking_app_BE.Core.Constants;
using EventId = booking_app_BE.Core.Constants.EventId;

namespace booking_app_BE.Core
{
    public class PagingOutOfRangeException : BaseExceptions
    {
        public PagingOutOfRangeException(EventId eventId, string message, Dictionary<string, object> causes = null) : base(message)
        {
            StatusCode = System.Net.HttpStatusCode.BadRequest;
            EventId = eventId;
            MessageKey = booking_app_BE.Core.Constants.MessageKey.PRE_VALIDATION_FAILED;
            Causes = causes;
        }
    }
}
