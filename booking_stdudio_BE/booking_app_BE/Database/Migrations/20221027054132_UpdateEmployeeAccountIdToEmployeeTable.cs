using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace booking_app_BE.Database.Migrations
{
    public partial class UpdateEmployeeAccountIdToEmployeeTable : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Employee_AspNetUsers_CreatedByEmployeeId",
                table: "Employee");

            migrationBuilder.RenameColumn(
                name: "employeeAccountId",
                table: "Employee",
                newName: "EmployeeAccountId");

            migrationBuilder.RenameColumn(
                name: "CreatedByEmployeeId",
                table: "Employee",
                newName: "IdentityUserId");

            migrationBuilder.RenameIndex(
                name: "IX_Employee_CreatedByEmployeeId",
                table: "Employee",
                newName: "IX_Employee_IdentityUserId");

            migrationBuilder.AddForeignKey(
                name: "FK_Employee_AspNetUsers_IdentityUserId",
                table: "Employee",
                column: "IdentityUserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Employee_AspNetUsers_IdentityUserId",
                table: "Employee");

            migrationBuilder.RenameColumn(
                name: "EmployeeAccountId",
                table: "Employee",
                newName: "employeeAccountId");

            migrationBuilder.RenameColumn(
                name: "IdentityUserId",
                table: "Employee",
                newName: "CreatedByEmployeeId");

            migrationBuilder.RenameIndex(
                name: "IX_Employee_IdentityUserId",
                table: "Employee",
                newName: "IX_Employee_CreatedByEmployeeId");

            migrationBuilder.AddForeignKey(
                name: "FK_Employee_AspNetUsers_CreatedByEmployeeId",
                table: "Employee",
                column: "CreatedByEmployeeId",
                principalTable: "AspNetUsers",
                principalColumn: "Id");
        }
    }
}
