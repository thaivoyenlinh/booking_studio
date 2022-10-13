using booking_app_BE.Core.Constants;
using System.Net;
using EventId = booking_app_BE.Core.Constants.EventId;

namespace booking_app_BE.Core
{
    public abstract class BaseExceptions : Exception
    {
        public Dictionary<string, object> Causes { get; protected set; }
        public HttpStatusCode StatusCode { get; protected set; }
        public EventId EventId { get; protected set; }
        public string MessageKey { get; protected set; }
        public BaseExceptions(HttpStatusCode statusCode, EventId eventId, string messageKey, string message, Dictionary<string, object> causes = null) : base(message)
        {
            EventId = eventId;
            StatusCode = statusCode;
            MessageKey = messageKey;
            Causes = causes;
        }

        public BaseExceptions(string message) : base(message)
        {
        }
    }
}
