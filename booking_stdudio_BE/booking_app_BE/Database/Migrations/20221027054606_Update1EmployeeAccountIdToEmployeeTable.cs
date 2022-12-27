using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace booking_app_BE.Database.Migrations
{
    public partial class Update1EmployeeAccountIdToEmployeeTable : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Employee_AspNetUsers_IdentityUserId",
                table: "Employee");

            migrationBuilder.DropColumn(
                name: "EmployeeAccountId",
                table: "Employee");

            migrationBuilder.RenameColumn(
                name: "IdentityUserId",
                table: "Employee",
                newName: "EmployeeAccountIdId");

            migrationBuilder.RenameIndex(
                name: "IX_Employee_IdentityUserId",
                table: "Employee",
                newName: "IX_Employee_EmployeeAccountIdId");

            migrationBuilder.AddForeignKey(
                name: "FK_Employee_AspNetUsers_EmployeeAccountIdId",
                table: "Employee",
                column: "EmployeeAccountIdId",
                principalTable: "AspNetUsers",
                principalColumn: "Id");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Employee_AspNetUsers_EmployeeAccountIdId",
                table: "Employee");

            migrationBuilder.RenameColumn(
                name: "EmployeeAccountIdId",
                table: "Employee",
                newName: "IdentityUserId");

            migrationBuilder.RenameIndex(
                name: "IX_Employee_EmployeeAccountIdId",
                table: "Employee",
                newName: "IX_Employee_IdentityUserId");

            migrationBuilder.AddColumn<string>(
                name: "EmployeeAccountId",
                table: "Employee",
                type: "nvarchar(max)",
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddForeignKey(
                name: "FK_Employee_AspNetUsers_IdentityUserId",
                table: "Employee",
                column: "IdentityUserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id");
        }
    }
}
