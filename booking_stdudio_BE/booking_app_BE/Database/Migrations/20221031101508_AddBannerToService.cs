using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace booking_app_BE.Database.Migrations
{
    public partial class AddBannerToService : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Banner",
                table: "Service",
                type: "nvarchar(max)",
                nullable: true,
                defaultValue: "");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Banner",
                table: "Service");
        }
    }
}
