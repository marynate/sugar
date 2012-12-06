﻿namespace RemObjects.Oxygene.Sugar;
{$HIDE W0} //supress case-mismatch errors
interface

{$IF COOPER}
uses
  java.util;
{$ELSEIF NOUGAT}
uses
  Foundation;
{$ENDIF}

type
  {$IF COOPER}
  DateTime = public record
  private
    fDate: Date; readonly;
    fCalendar: Calendar := Calendar.Instance; readonly;

    method InternalGetDate: DateTime;
    method AddComponent(Component: Integer; Value: Integer): Calendar;
    constructor(aDate: Date);
  public
    constructor;    
    method AddDays(Value: Integer): DateTime;
    method AddHours(Value: Integer): DateTime;
    method AddMilliseconds(Value: Integer): DateTime;
    method AddMinutes(Value: Integer): DateTime;
    method AddMonths(Value: Integer): DateTime;
    method AddSeconds(Value: Integer): DateTime;
    method AddYears(Value: Integer): DateTime;

    method CompareTo(Value: DateTime): Integer;
    method ToString: java.lang.String; override;
    method ToString(Format: String): String;
	  method ToLongDateString: String;
    method ToLongTimeString: String;
    method ToShortDateString: String;
	  method ToShortTimeString: String;

    property Date: DateTime read InternalGetDate;
    property Day: Integer read fCalendar.get(Calendar.DAY_OF_MONTH);
    property Hour: Integer read fCalendar.get(Calendar.HOUR);
    property Minute: Integer read fCalendar.get(Calendar.MINUTE);
    property Millisecond: Integer read fCalendar.get(Calendar.MILLISECOND);
    property Month: Integer read fCalendar.get(Calendar.MONTH)+1;
    class property Now: DateTime read new DateTime;
    property Second: Integer read fCalendar.get(Calendar.SECOND);
    class property Today: DateTime read Now.Date;
    property Year: Integer read fCalendar.get(Calendar.Year);    
  end;
  {$ELSEIF ECHOES}
  [System.Runtime.InteropServices.StructLayout(System.Runtime.InteropServices.LayoutKind.Auto, Size := 1)]
  DateTime = public record mapped to System.DateTime
  public
    method AddDays(Value: Integer): DateTime; mapped to AddDays(Value);
    method AddHours(Value: Integer): DateTime; mapped to AddHours(Value);
    method AddMilliseconds(Value: Integer): DateTime; mapped to AddMilliseconds(Value);
    method AddMinutes(Value: Integer): DateTime; mapped to AddMinutes(Value);
    method AddMonths(Value: Integer): DateTime; mapped to AddMonths(Value);
    method AddSeconds(Value: Integer): DateTime; mapped to AddSeconds(Value);
    method AddYears(Value: Integer): DateTime; mapped to AddYears(Value);
    
    method CompareTo(Value: DateTime): Integer; mapped to CompareTo(Value);
    method ToString(Format: String): String; mapped to ToString(Format);
	  method ToLongDateString: String; mapped to ToLongDateString;
    method ToLongTimeString: String; mapped to ToLongTimeString;
    method ToShortDateString: String; mapped to ToShortDateString;
	  method ToShortTimeString: String; mapped to ToShortTimeString;

    property Date: DateTime read mapped.Date;
    property Day: Integer read mapped.Day;
    property Hour: Integer read mapped.Hour;
    property Minute: Integer read mapped.Minute;
    property Millisecond: Integer read mapped.Millisecond;
    property Month: Integer read mapped.Month;
    class property Now: DateTime read mapped.Now;
    property Second: Integer read mapped.Second;
    class property Today: DateTime read mapped.Today;
    property Year: Integer read mapped.Year;
  end;
  {$ELSEIF NOUGAT}
  DateTime = public class
  private
    fDate: NSDate;
    fCalendar: NSCalendar := NSCalendar.currentCalendar;  readonly;

    method InternalGetDate: DateTime;
    method GetComponent(Component: NSCalendarUnit): Integer;
    method FormatWithStyle(DateStyle, TimeStyle: NSDateFormatterStyle): String;
  public
    constructor;    
    method initWithDate(aDate: NSDate): dynamic;
    method AddDays(Value: Integer): DateTime;
    method AddHours(Value: Integer): DateTime;
    method AddMilliseconds(Value: Integer): DateTime;
    method AddMinutes(Value: Integer): DateTime;
    method AddMonths(Value: Integer): DateTime;
    method AddSeconds(Value: Integer): DateTime;
    method AddYears(Value: Integer): DateTime;

    method CompareTo(Value: DateTime): Integer;
    method ToString: String;
    method ToString(Format: String): String;
	  method ToLongDateString: String;
    method ToLongTimeString: String;
    method ToShortDateString: String;
	  method ToShortTimeString: String;

    property Date: DateTime read InternalGetDate;
    property Day: Integer read GetComponent(NSCalendarUnit.NSDayCalendarUnit);
    property Hour: Integer read GetComponent(NSCalendarUnit.NSHourCalendarUnit);
    property Minute: Integer read GetComponent(NSCalendarUnit.NSMinuteCalendarUnit); //TODO: Milliseconds for Nougat
    //property Millisecond: Integer read fCalendar.get(Calendar.MILLISECOND);
    property Month: Integer read GetComponent(NSCalendarUnit.NSMonthCalendarUnit);
    class property Now: DateTime read new DateTime;
    property Second: Integer read GetComponent(NSCalendarUnit.NSSecondCalendarUnit);
    class property Today: DateTime read Now.Date;
    property Year: Integer read GetComponent(NSCalendarUnit.NSYearCalendarUnit);
  end;
  {$ENDIF}

implementation

{$IF COOPER}
constructor DateTime;
begin
  constructor(new Date);
end;

constructor DateTime(aDate: Date);
begin
  fDate := aDate;
  fCalendar.Time := fDate;
end;

method DateTime.InternalGetDate: DateTime;
begin
  var lCalendar := Calendar.Instance;
  lCalendar.Time := fDate;
  lCalendar.set(Calendar.HOUR_OF_DAY, 0);
  lCalendar.set(Calendar.MINUTE, 0);
  lCalendar.set(Calendar.SECOND, 0);
  lCalendar.set(Calendar.MILLISECOND, 0);
  exit new DateTime(lCalendar.Time);
end;

method DateTime.AddDays(Value: Integer): DateTime;
begin
  exit new DateTime(AddComponent(Calendar.DATE, Value).Time);
end;

method DateTime.AddHours(Value: Integer): DateTime;
begin
  exit new DateTime(AddComponent(Calendar.HOUR, Value).Time);
end;

method DateTime.AddMilliseconds(Value: Integer): DateTime;
begin
  exit new DateTime(AddComponent(Calendar.MILLISECOND, Value).Time);
end;

method DateTime.AddMinutes(Value: Integer): DateTime;
begin
  exit new DateTime(AddComponent(Calendar.MINUTE, Value).Time);
end;

method DateTime.AddMonths(Value: Integer): DateTime;
begin
  exit new DateTime(AddComponent(Calendar.MONTH, Value).Time);
end;

method DateTime.AddSeconds(Value: Integer): DateTime;
begin
  exit new DateTime(AddComponent(Calendar.SECOND, Value).Time);
end;

method DateTime.AddYears(Value: Integer): DateTime;
begin
  exit new DateTime(AddComponent(Calendar.YEAR, Value).Time);
end;

method DateTime.AddComponent(Component: Integer; Value: Integer): Calendar;
begin
  result := Calendar.Instance;
  result.Time := fDate;
  result.add(Component, Value);
end;

method DateTime.CompareTo(Value: DateTime): Integer;
begin
  exit fDate.compareTo(Value.fDate);
end;

method DateTime.ToString: java.lang.String;
begin
  Result := fDate.toString;
end;

method DateTime.ToString(Format: String): String;
begin
  var lFormat: java.text.SimpleDateFormat := new java.text.SimpleDateFormat(Format);
  exit lFormat.format(fDate);
end;

method DateTime.ToLongDateString: String;
begin
  exit java.text.DateFormat.getDateInstance(java.text.DateFormat.LONG).format(fDate);
end;

method DateTime.ToLongTimeString: String;
begin
  exit java.text.DateFormat.getTimeInstance(java.text.DateFormat.LONG).format(fDate);
end;

method DateTime.ToShortDateString: String;
begin
  exit java.text.DateFormat.getDateInstance(java.text.DateFormat.SHORT).format(fDate);
end;

method DateTime.ToShortTimeString: String;
begin
  exit java.text.DateFormat.getTimeInstance(java.text.DateFormat.SHORT).format(fDate);
end;
{$ELSEIF NOUGAT}
constructor DateTime;
begin
  fDate := new NSDate();
end;

method DateTime.initWithDate(aDate: NSDate): dynamic;
begin
  fDate := aDate;
  result := self;
end;

method DateTime.AddDays(Value: Integer): DateTime;
begin
  var Component: NSDateComponents := new NSDateComponents();  
  Component.setDay(Value);
  exit new DateTime withDate(fCalendar.dateByAddingComponents(Component) toDate(fDate) options(0));  
end;

method DateTime.AddHours(Value: Integer): DateTime;
begin
  var Component: NSDateComponents := new NSDateComponents();  
  Component.setHour(Value);
  exit new DateTime withDate(fCalendar.dateByAddingComponents(Component) toDate(fDate) options(0));
end;

method DateTime.AddMilliseconds(Value: Integer): DateTime;
begin
  exit new DateTime withDate(fDate.dateByAddingTimeInterval(Value / 1000));
end;

method DateTime.AddMinutes(Value: Integer): DateTime;
begin
  var Component: NSDateComponents := new NSDateComponents();  
  Component.setMinute(Value);
  exit new DateTime withDate(fCalendar.dateByAddingComponents(Component) toDate(fDate) options(0));
end;

method DateTime.AddMonths(Value: Integer): DateTime;
begin
  var Component: NSDateComponents := new NSDateComponents();  
  Component.setMonth(Value);
  exit new DateTime withDate(fCalendar.dateByAddingComponents(Component) toDate(fDate) options(0));
end;

method DateTime.AddSeconds(Value: Integer): DateTime;
begin
 exit new DateTime withDate(fDate.dateByAddingTimeInterval(Value / 1000));
end;

method DateTime.AddYears(Value: Integer): DateTime;
begin
  var Component: NSDateComponents := new NSDateComponents();  
  Component.setYear(Value);
  exit new DateTime withDate(fCalendar.dateByAddingComponents(Component) toDate(fDate) options(0));
end;

method DateTime.CompareTo(Value: DateTime): Integer;
begin
  exit fDate.compare(Value.fDate);
end;

method DateTime.ToString: String;
begin
  exit fDate.description;
end;

method DateTime.ToString(Format: String): String;
begin
  var lFormater: NSDateFormatter := new NSDateFormatter();
  lFormater.setDateFormat(Format);
  exit lFormater.stringFromDate(fDate);
end;

method DateTime.FormatWithStyle(DateStyle, TimeStyle: NSDateFormatterStyle): String;
begin
  var lFormater: NSDateFormatter := new NSDateFormatter();
  lFormater.setDateStyle(DateStyle);
  lFormater.setTimeStyle(TimeStyle);
  exit lFormater.stringFromDate(fDate);
end;

method DateTime.ToLongDateString: String;
begin
  exit FormatWithStyle(NSDateFormatterStyle.NSDateFormatterLongStyle, NSDateFormatterStyle.NSDateFormatterNoStyle);
end;

method DateTime.ToLongTimeString: String;
begin
  exit FormatWithStyle(NSDateFormatterStyle.NSDateFormatterNoStyle, NSDateFormatterStyle.NSDateFormatterLongStyle);
end;

method DateTime.ToShortDateString: String;
begin
  exit FormatWithStyle(NSDateFormatterStyle.NSDateFormatterShortStyle, NSDateFormatterStyle.NSDateFormatterNoStyle);
end;

method DateTime.ToShortTimeString: String;
begin
  exit FormatWithStyle(NSDateFormatterStyle.NSDateFormatterNoStyle, NSDateFormatterStyle.NSDateFormatterShortStyle);
end;

method DateTime.GetComponent(Component: NSCalendarUnit): Integer;
begin
  var lComponents := fCalendar.components(Integer(Component)) fromDate(fDate);
  case Component of
    NSCalendarUnit.NSDayCalendarUnit: exit lComponents.day;
    NSCalendarUnit.NSHourCalendarUnit: exit lComponents.hour;
    NSCalendarUnit.NSMinuteCalendarUnit: exit lComponents.minute;
    NSCalendarUnit.NSMonthCalendarUnit: exit lComponents.month;
    NSCalendarUnit.NSSecondCalendarUnit: exit lComponents.second;
    NSCalendarUnit.NSYearCalendarUnit: exit lComponents.year;
  end;
end;

method DateTime.InternalGetDate: DateTime;
begin
  var lCalendar: NSCalendar := NSCalendar.currentCalendar;
  var lDate: NSDate := new NSDate();
  var lComponents := lCalendar.components(Integer(NSCalendarUnit.NSYearCalendarUnit or 
    NSCalendarUnit.NSMonthCalendarUnit or NSCalendarUnit.NSDayCalendarUnit)) fromDate(lDate);
  exit new DateTime withDate(lCalendar.dateFromComponents(lComponents));
end;
{$ENDIF}

end.
