export enum Direction {
  asc = 'ASC',
  desc = 'DESC'
}

export enum SortBy {
  date = 'Date',
}

export interface Sort {
  direction: Direction;
  sortBy: SortBy;
}