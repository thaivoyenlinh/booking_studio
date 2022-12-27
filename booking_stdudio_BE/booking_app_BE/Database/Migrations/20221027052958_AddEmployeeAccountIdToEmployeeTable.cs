using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace booking_app_BE.Database.Migrations
{
    public partial class AddEmployeeAccountIdToEmployeeTable : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "CreatedByEmployeeId",
                table: "Employee",
                type: "nvarchar(450)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "employeeAccountId",
                table: "Employee",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateIndex(
                name: "IX_Employee_CreatedByEmployeeId",
                table: "Employee",
                column: "CreatedByEmployeeId");

            migrationBuilder.AddForeignKey(
                name: "FK_Employee_AspNetUsers_CreatedByEmployeeId",
                table: "Employee",
                column: "CreatedByEmployeeId",
                principalTable: "AspNetUsers",
                principalColumn: "Id");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Employee_AspNetUsers_CreatedByEmployeeId",
                table: "Employee");

            migrationBuilder.DropIndex(
                name: "IX_Employee_CreatedByEmployeeId",
                table: "Employee");

            migrationBuilder.DropColumn(
                name: "CreatedByEmployeeId",
                table: "Employee");

            migrationBuilder.DropColumn(
                name: "employeeAccountId",
                table: "Employee");
        }
    }
}
