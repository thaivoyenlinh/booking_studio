using booking_app_BE.Apis.Service.Dto;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace booking_app_BE.Database.Entity
{
    public class Service
    {
        [Key]
        public int Id { get; set; }
        public string Category { get; set; }
        public string Type { get; set; }
        public string ServiceName { get; set; }
        public string ServiceDetails { get; set; }
        public decimal Price { get; set; }
        [Column(TypeName = "nvarchar(10)")] public ServiceEnum.Status Status { get; set; } 
        public string? BannerImage { get; set; }
        public bool BannerSlider  { get; set; }
        public List<string> Image { get; set; }
        public string? Discount { get; set; }
    }
}
