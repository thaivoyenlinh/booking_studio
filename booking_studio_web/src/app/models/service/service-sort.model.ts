export enum Direction {
  asc = 'ASC',
  desc = 'DESC'
}

export enum SortBy {
  price = 'Price',
}

export interface Sort {
  direction: Direction;
  sortBy: SortBy;
}