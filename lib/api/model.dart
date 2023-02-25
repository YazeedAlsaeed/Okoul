class TimerModel {
//TimerModel.data[0]["timings"].fagr

  TimerModel({
    required this.code,
    required this.status,
    required this.data,
  });
  late final int code;
  late final String status;
  late final List<Data> data;

  TimerModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    status = json['status'];
    data = List.from(json['data']).map((e) => Data.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['code'] = code;
    _data['status'] = status;
    _data['data'] = data.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Data {
  Data({
    required this.timings,
    required this.date,
  });
  late final Timings timings;
  late final Date date;

  Data.fromJson(Map<String, dynamic> json) {
    timings = Timings.fromJson(json['timings']);
    date = Date.fromJson(json['date']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['timings'] = timings.toJson();
    _data['date'] = date.toJson();
    return _data;
  }
}

class Timings {
  Timings({
    required this.Fajr,
    required this.Sunrise,
    required this.Dhuhr,
    required this.Asr,
    required this.Maghrib,
    required this.Isha,
  });
  late final String Fajr;
  late final String Sunrise;
  late final String Dhuhr;
  late final String Asr;
  late final String Maghrib;
  late final String Isha;

  Timings.fromJson(Map<String, dynamic> json) {
    Fajr = json['Fajr'];
    Sunrise = json['Sunrise'];
    Dhuhr = json['Dhuhr'];
    Asr = json['Asr'];
    Maghrib = json['Maghrib'];
    Isha = json['Isha'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['Fajr'] = Fajr;
    _data['Sunrise'] = Sunrise;
    _data['Dhuhr'] = Dhuhr;
    _data['Asr'] = Asr;
    _data['Maghrib'] = Maghrib;
    _data['Isha'] = Isha;
    return _data;
  }
}

class Date {
  Date({
    required this.readable,
    required this.gregorian,
  });
  late final String readable;
  late final Gregorian gregorian;

  Date.fromJson(Map<String, dynamic> json) {
    readable = json['readable'];
    gregorian = Gregorian.fromJson(json['gregorian']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['readable'] = readable;
    _data['gregorian'] = gregorian.toJson();
    return _data;
  }
}

class Gregorian {
  Gregorian({
    required this.date,
    required this.format,
    required this.day,
    required this.weekday,
    required this.month,
    required this.year,
  });
  late final String date;
  late final String format;
  late final String day;
  late final Weekday weekday;
  late final Month month;
  late final String year;

  Gregorian.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    format = json['format'];
    day = json['day'];
    weekday = Weekday.fromJson(json['weekday']);
    month = Month.fromJson(json['month']);
    year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['date'] = date;
    _data['format'] = format;
    _data['day'] = day;
    _data['weekday'] = weekday.toJson();
    _data['month'] = month.toJson();
    _data['year'] = year;
    return _data;
  }
}

class Weekday {
  Weekday({
    required this.en,
  });
  late final String en;

  Weekday.fromJson(Map<String, dynamic> json) {
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['en'] = en;
    return _data;
  }
}

class Month {
  Month({
    required this.number,
    required this.en,
  });
  late final int number;
  late final String en;

  Month.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['number'] = number;
    _data['en'] = en;
    return _data;
  }
}
