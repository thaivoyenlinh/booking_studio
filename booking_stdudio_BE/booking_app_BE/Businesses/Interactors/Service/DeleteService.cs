using booking_app_BE.Businesses.Boundaries.Service;
using booking_app_BE.Businesses.Services;
using booking_app_BE.Core.AutoInit;

namespace booking_app_BE.Businesses.Interactors.Service
{
    [Interactor]
    public class DeleteService : IDeleteService
    {
        private readonly IServiceService _serviceService;
        private readonly IWebHostEnvironment _webHostEnvironment;
        public DeleteService(IServiceService serviceService, IWebHostEnvironment webHostEnvironment)
        {
            _serviceService = serviceService;
            _webHostEnvironment = webHostEnvironment;
        }
        public async Task<IDeleteService.Response> DeleteAsync(IDeleteService.Request request)
        {
            var service = await _serviceService.FindByIdAsync(e => e.Id.Equals(request.ServiceId));
            if (service != null)
            {
                List<string> fileNameList = new List<string>();
                fileNameList = service.Image;
                string path = _webHostEnvironment.WebRootPath + '\\' + "Images" + '\\' + "Services";
                System.GC.Collect();
                System.GC.WaitForPendingFinalizers();
                foreach (string fileName in fileNameList)
                {
                    if (File.Exists(Path.Combine(path, fileName)))
                    {
                        File.Delete(Path.Combine(path, fileName));
                    }
                }
                

                await _serviceService.DeleteAsync(service);
                return new IDeleteService.Response(200, "success");
            }
            return new IDeleteService.Response(500, "error");
        }
    }
}
