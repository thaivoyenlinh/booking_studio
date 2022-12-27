export interface IServiceDetail {
  id: number;
  category: string;
  type: string;
  serviceName: string;
  serviceDetails: string;
  price: number;
  discount: string;
  status: boolean;
  bannerSlider: boolean;
  bannerImage: string; 
  image: string[];
}

export interface IServicesListQuery {
  category: string;
  type: string;
  serviceName: string;
  status: string;
  sortHeader: string;
  sortOrder: string;
  currentPage: number;
  rowsPerPage: number;
}

export class ServicesListQuery implements IServicesListQuery {
  category: string;
  type: string;
  serviceName: string;
  status: string;
  sortHeader: string;
  sortOrder: string;
  currentPage: number;
  rowsPerPage: number;
}

export interface IServicesList{
  currentPage: number;
  totalPages: number;
  totalRecords: number;
  rows: IServiceDetail[];
}

export class ServiceEdit {
  id: number;
  category: string;
  type: string;
  serviceName: string;
  serviceDetails: string;
  price: number;
  status: boolean; 
}

export class IBannersService {
  id: number;
  image: string;
}

