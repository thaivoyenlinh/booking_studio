import { Subscription } from 'rxjs';

const isFunction = (fn: any) => typeof fn === 'function';

export class SubSink {
  private subscriptions: Subscription[];
  
  constructor(){
    this.subscriptions = [];  
  }

  add(sub: Subscription){
    this.subscriptions.push(sub);
  }

  unsubscribe(){
    this.subscriptions.forEach(sub => sub && isFunction(sub.unsubscribe) && sub.unsubscribe());
    this.subscriptions = [];
  }

  getSubscriptions(){
    return this.subscriptions;
  }

}