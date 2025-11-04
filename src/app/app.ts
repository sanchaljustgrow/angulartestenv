import { Component } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { RouterOutlet } from '@angular/router';
import { JsonPipe } from '@angular/common';
import { AppConfigService } from './app-config.service';

@Component({
  selector: 'app-root',
  imports: [RouterOutlet, JsonPipe],
  templateUrl: './app.html',
  styleUrls: ['./app.css'],
})
export class App {
  protected title = 'TestEnv';
  data: any = null;
  private testURL: string;

  constructor(private http: HttpClient, private appConfig: AppConfigService) {
    this.testURL = this.appConfig.get('NG_APP_URL', 'https://task.thingsrms.com/v1');
  }

  ngOnInit() {
    console.log('API URL:', this.testURL);
    this.http.get<any>(this.testURL).subscribe((data) => {
      this.data = data;
    });
  }
}
