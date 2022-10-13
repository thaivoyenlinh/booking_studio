using booking_app_BE.Apis.Employee.Dtos;
using booking_app_BE.Core;

namespace booking_app_BE.Businesses.Boundaries.Employee
{
    public interface IGetEmployees
    {
        Task<PaginatedList<dynamic>> ExecuteAsync(Request request);
        public class Request
        {
            public string Name { get; set; }
            public SortOrderDto.SortHeader? SortHeader { get; set; }
            public SortOrderDto.SortOrder? SortOrder { get; set; }
            public int CurrentPage { get; set; }
            public int RowsPerPage { get; set; }

            public Request(string name, SortOrderDto.SortHeader? sortHeader, SortOrderDto.SortOrder? sortOrder, int currentPage, int rowsPerPage)
            {
                Name = name;
                SortHeader = sortHeader;
                SortOrder = sortOrder;
                CurrentPage = currentPage;
                RowsPerPage = rowsPerPage;
            }
        }
    }
}
