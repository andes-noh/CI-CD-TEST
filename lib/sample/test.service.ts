import { Injectable } from '@nestjs/common'
import { Cron, CronExpression } from '@nestjs/schedule'

@Injectable()
export class TestService {
  @Cron(CronExpression.EVERY_SECOND)
  async ConsoleTime() {
    // console.log(time)
    const time = new Date().toISOString()
    console.log('v.1.3-22-08-25 : ' + time)
  }
}
