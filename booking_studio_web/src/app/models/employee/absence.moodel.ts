export interface IAbsenceDetail {
  id: number;
  status: string;
  date: string[];
  employeeName: string
}

export interface IAbsencesListQuery {
  name: string;
  // sortHeader: string;
  // sortOrder: string;
  currentPage: number;
  rowsPerPage: number;
}

export class AbsencesListQuery implements IAbsencesListQuery {
  name: string;
  // sortHeader: string;
  // sortOrder: string;
  currentPage: number;
  rowsPerPage: number;
}

export interface IAbsencesList{
  currentPage: number;
  totalPages: number;
  totalRecords: number;
  rows: IAbsenceDetail[];
}
