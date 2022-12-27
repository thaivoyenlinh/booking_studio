import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'status',
})
export class StatusPipe implements PipeTransform {
  transform(value: number) {
    if (value === 0) {
      var status = "Active";
      return status;
    }
    if (value === 1) {
      var status = "InActive";
      return status;
    }
  }
}
