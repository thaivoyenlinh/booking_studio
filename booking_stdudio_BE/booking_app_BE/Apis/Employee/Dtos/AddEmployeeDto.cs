namespace booking_app_BE.Apis.Employee.Dtos
{
    public class AddEmployeeDto
    {
        public int BagdeID { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Email { get; set; }
        public IFormFile Image { get; set; }
    }
}
