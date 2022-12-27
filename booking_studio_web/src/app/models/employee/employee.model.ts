export interface IEmployeeDetail {
  id: number;
  badgeId: number;
  name: string; 
  email: string;
  image: string;
  username: string;
  password: string;
  phoneNumber: string;
  employeeAccountId: string;
  rating: number;
}

export interface IEmployeesListQuery {
  name: string;
  sortHeader: string;
  sortOrder: string;
  currentPage: number;
  rowsPerPage: number;
}

export class EmployeeListQuery implements IEmployeesListQuery {
  name: string;
  sortHeader: string;
  sortOrder: string;
  currentPage: number;
  rowsPerPage: number;
}

export interface IEmployeesList{
  currentPage: number;
  totalPages: number;
  totalRecords: number;
  rows: IEmployeeDetail[];
}

export class EmployeeEdit{
  id: number;
  badgeId: number;
  firstName: string;
  lastName: string;
  email: string;
  phoneNumber: string;
}

export interface IAccountInfo {
  userId: string;
  passwordGenerate: string;
}
