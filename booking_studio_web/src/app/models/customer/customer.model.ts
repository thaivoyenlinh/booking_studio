export interface ICustomerDetail {
  id: number;
  fullName: string; 
  address: string;
  phoneNumber: string;
  image: string;
  customerAccountId: string;
}

export interface ICustomersListQuery {
  name: string;
  address: string
  // sortHeader: string;
  // sortOrder: string;
  currentPage: number;
  rowsPerPage: number;
}

export class CustomersListQuery implements ICustomersListQuery {
  name: string;
  address: string
  // sortHeader: string;
  // sortOrder: string;
  currentPage: number;
  rowsPerPage: number;
}

export interface ICustomersList{
  currentPage: number;
  totalPages: number;
  totalRecords: number;
  rows: ICustomerDetail[];
}
