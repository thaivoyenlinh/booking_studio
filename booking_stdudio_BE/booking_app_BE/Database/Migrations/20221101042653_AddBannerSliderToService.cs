using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace booking_app_BE.Database.Migrations
{
    public partial class AddBannerSliderToService : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Banner",
                table: "Service");

            migrationBuilder.AddColumn<string>(
                name: "BannerImage",
                table: "Service",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "BannerSlider",
                table: "Service",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "BannerImage",
                table: "Service");

            migrationBuilder.DropColumn(
                name: "BannerSlider",
                table: "Service");

            migrationBuilder.AddColumn<string>(
                name: "Banner",
                table: "Service",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");
        }
    }
}
