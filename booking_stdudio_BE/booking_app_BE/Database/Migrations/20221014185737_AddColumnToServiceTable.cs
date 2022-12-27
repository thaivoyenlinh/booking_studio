using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace booking_app_BE.Database.Migrations
{
    public partial class AddColumnToServiceTable : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "Description",
                table: "Service",
                newName: "ServiceName");

            migrationBuilder.AddColumn<string>(
                name: "ServiceDetails",
                table: "Service",
                type: "nvarchar(max)",
                nullable: true,
                defaultValue: "");

            migrationBuilder.AddColumn<bool>(
                name: "Status",
                table: "Service",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ServiceDetails",
                table: "Service");

            migrationBuilder.DropColumn(
                name: "Status",
                table: "Service");

            migrationBuilder.RenameColumn(
                name: "ServiceName",
                table: "Service",
                newName: "Description");
        }
    }
}
