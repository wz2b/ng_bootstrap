import "package:angular2/angular2.dart";
import "package:ng_bootstrap/components/timepicker/timepicker.dart";

@Component(selector: "timepicker-demo",
    templateUrl: 'timepicker_demo.html',
    directives: const [NgBsTimePicker])
class TimepickerDemo {
  String hstep = '1';
  get hstepInt => int.parse(hstep);
  String mstep = '15';
  get mstepInt => int.parse(mstep);
  bool ismeridian = true;
  String mytime = new DateTime.now().toString();
  dynamic options = {
    "hstep": [1, 2, 3],
    "mstep": [1, 5, 10, 15, 25, 30]
  };
  void toggleMode() {
    this.ismeridian = !this.ismeridian;
  }

  void update() {
    var d = new DateTime(0, 1, 1, 14);
    this.mytime = d.toString();
  }

  void changed() {
    print("Time changed to: ${mytime}");
  }

  void clear() {
    this.mytime = null;
  }
}
