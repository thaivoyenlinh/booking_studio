using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace booking_app_BE.Database.Migrations
{
    public partial class ModifyColumnName : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "BagdeID",
                table: "Employee",
                newName: "BadgeId");

            migrationBuilder.RenameIndex(
                name: "IX_Employee_BagdeID",
                table: "Employee",
                newName: "IX_Employee_BadgeId");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.RenameColumn(
                name: "BadgeId",
                table: "Employee",
                newName: "BagdeID");

            migrationBuilder.RenameIndex(
                name: "IX_Employee_BadgeId",
                table: "Employee",
                newName: "IX_Employee_BagdeID");
        }
    }
}
