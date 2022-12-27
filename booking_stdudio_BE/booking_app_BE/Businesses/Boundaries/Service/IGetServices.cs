using booking_app_BE.Apis.Service.Dto;
using booking_app_BE.Core;

namespace booking_app_BE.Businesses.Boundaries.Service
{
    public interface IGetServices
    {
        Task<PaginatedList<dynamic>> ExecuteAsync(Request request);
        public class Request
        {
            public string Category { get; set; }
            public string Type{ get; set; }
            public string ServiceName { get; set; }
            public ServiceEnum.Status? Status { get; set; }
            public SortOrderDto.SortHeaderService? SortHeader { get; set; }
            public SortOrderDto.SortOrderService? SortOrder { get; set; }
            public int CurrentPage { get; set; }
            public int RowsPerPage { get; set; }

            public Request(string category, 
                string type,  
                string serviceName, 
                ServiceEnum.Status? status,
                SortOrderDto.SortHeaderService? sortHeader,
                SortOrderDto.SortOrderService? sortOrder,
                int currentPage, 
                int rowsPerPage)
            {
                Category = category;
                Type = type;
                ServiceName = serviceName;
                Status = status;
                SortHeader = sortHeader;
                SortOrder = sortOrder;
                CurrentPage = currentPage;
                RowsPerPage = rowsPerPage;
            }
        }
    }
}
