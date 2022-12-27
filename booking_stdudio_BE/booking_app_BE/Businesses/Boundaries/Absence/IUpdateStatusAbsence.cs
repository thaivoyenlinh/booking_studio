using booking_app_BE.Apis.Absence.Dto;

namespace booking_app_BE.Businesses.Boundaries.Absence
{
    public interface IUpdateStatusAbsence
    {
        Task ExecuteAsync(UpdateStatusRequest request);

        public class UpdateStatusRequest
        {
            public int AbsenceId { get; set; }
            public StatusEnumAbsence Status { get; set; }
        }
    }
}
