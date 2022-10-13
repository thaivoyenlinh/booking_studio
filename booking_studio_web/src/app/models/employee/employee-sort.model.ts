export enum Direction {
  asc = 'ASC',
  desc = 'DESC'
}

export enum SortBy {
  name = 'Name',
  badgeId = "BadgeId"
}

export interface Sort {
  direction: Direction;
  sortBy: SortBy;
}