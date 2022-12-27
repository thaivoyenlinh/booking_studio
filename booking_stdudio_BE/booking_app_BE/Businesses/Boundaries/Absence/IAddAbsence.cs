using booking_app_BE.Apis.Absence.Dto;

namespace booking_app_BE.Businesses.Boundaries.Absence
{
    public interface IAddAbsence
    {
        Task<AddAbsenceResponse> ExecuteAsync(AddAbsenceRequest request);

        public class AddAbsenceRequest
        {
            public int EmployeeId { get; set; }
            public List<string> Date { get; set; }
            public string Reason { get; set; }
            public StatusEnumAbsence Status { get; set; }
        }

        public class AddAbsenceResponse
        {
            public int Status { get; set; }
            public string Message { get; set; }
            public AddAbsenceResponse(int status, string message)
            {
                Status = status;
                Message = message;
            }
        }
    }
}
