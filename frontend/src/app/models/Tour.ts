import {CheckPoint} from "./CheckPoint";
import {Pause} from "./Pause";

export interface Tour{
  uid: string,
  tourId: string,
  startTime: string,
  endTime: string,
  totalTime: string,
  totalPauseTime: string,
  startPoint: string,
  endPoint: string,
  note: string,
  pause: Pause,
  checkPoint: CheckPoint,
}
