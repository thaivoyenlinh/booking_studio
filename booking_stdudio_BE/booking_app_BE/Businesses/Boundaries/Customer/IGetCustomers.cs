using booking_app_BE.Core;

namespace booking_app_BE.Businesses.Boundaries.Customer
{
    public interface IGetCustomers
    {
        Task<PaginatedList<dynamic>> ExecuteAsync(GetCustomersRequest request);
        public class GetCustomersRequest
        {
            public string Name { get; set; }
            public string Address { get; set; }

            /*public SortOrderDto.SortHeader? SortHeader { get; set; }
            public SortOrderDto.SortOrder? SortOrder { get; set; }*/
            public int CurrentPage { get; set; }
            public int RowsPerPage { get; set; }

            public GetCustomersRequest(string name, string address, int currentPage, int rowsPerPage)
            {
                Name = name;
                Address = address;
                /* SortHeader = sortHeader;
                SortOrder = sortOrder;*/
                CurrentPage = currentPage;
                RowsPerPage = rowsPerPage;
            }
        }
    }
}
