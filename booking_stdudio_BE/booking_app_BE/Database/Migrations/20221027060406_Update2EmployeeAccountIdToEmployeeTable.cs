using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace booking_app_BE.Database.Migrations
{
    public partial class Update2EmployeeAccountIdToEmployeeTable : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Employee_AspNetUsers_EmployeeAccountIdId",
                table: "Employee");

            migrationBuilder.RenameColumn(
                name: "EmployeeAccountIdId",
                table: "Employee",
                newName: "UserAccountId");

            migrationBuilder.RenameIndex(
                name: "IX_Employee_EmployeeAccountIdId",
                table: "Employee",
                newName: "IX_Employee_UserAccountId");

            migrationBuilder.AddColumn<string>(
                name: "EmployeeAccountId",
                table: "Employee",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddForeignKey(
                name: "FK_Employee_AspNetUsers_UserAccountId",
                table: "Employee",
                column: "UserAccountId",
                principalTable: "AspNetUsers",
                principalColumn: "Id");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Employee_AspNetUsers_UserAccountId",
                table: "Employee");

            migrationBuilder.DropColumn(
                name: "EmployeeAccountId",
                table: "Employee");

            migrationBuilder.RenameColumn(
                name: "UserAccountId",
                table: "Employee",
                newName: "EmployeeAccountIdId");

            migrationBuilder.RenameIndex(
                name: "IX_Employee_UserAccountId",
                table: "Employee",
                newName: "IX_Employee_EmployeeAccountIdId");

            migrationBuilder.AddForeignKey(
                name: "FK_Employee_AspNetUsers_EmployeeAccountIdId",
                table: "Employee",
                column: "EmployeeAccountIdId",
                principalTable: "AspNetUsers",
                principalColumn: "Id");
        }
    }
}
