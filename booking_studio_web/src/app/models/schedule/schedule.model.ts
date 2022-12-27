export interface IScheduleDetail {
  id: number;
  status: number;
  customerName: string; 
  employeeName: string;
  serviceName: string;
  date: string;
  total: string;
}

export interface ISchedulesListQuery {
  date: string;
  status: string;
  sortHeader: string;
  sortOrder: string;
  currentPage: number;
  rowsPerPage: number;
}

export class SchedulesListQuery implements ISchedulesListQuery {
  date: string;
  status: string;
  sortHeader: string;
  sortOrder: string;
  currentPage: number;
  rowsPerPage: number;
}

export interface ISchedulesList{
  currentPage: number;
  totalPages: number;
  totalRecords: number;
  rows: IScheduleDetail[];
}