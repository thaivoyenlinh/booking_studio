namespace booking_app_BE.Businesses.Boundaries.Absence
{
    public interface IGetAbsencesByEmployee
    {
        Task<IEnumerable<dynamic>> ExecuteAsync(GetAbsencesByEmployeeRequest request);
        public class GetAbsencesByEmployeeRequest
        {
            public int EmployeeId { get; set; }
        }

        public class GetAbsencesByEmployeeReponse
        {
            public List<string> Date { get; set; }
            public string Status { get; set; }
            public string Reason { get; set; }
        }
    }
}
