﻿namespace RemObjects.Oxygene.Sugar;

{$HIDE W0} // sometimes case differs between .NET and Java; no sense needlessly IFDEF'ing that

interface

type
  {$IFDEF COOPER}
  String = public class mapped to java.lang.String
  {$ENDIF}
  {$IFDEF ECHOES}
  String = public class mapped to System.String
  {$ENDIF}
  {$IFDEF NOUGAT}
  String = public class mapped to Foundation.NSString
  {$ENDIF}
  public
    class method FormatDotNet(aFormat: String; params aParams: array of Object): String;
    class method FormatC(aFormat: String; params aParams: array of Object): String;

    method Length: Int32; mapped to length;

    {$IFNDEF NOUGAT}
    method IndexOf(aString: String): Int32; mapped to IndexOf(aString);
    method Substring(aStartIndex: Int32): String; mapped to Substring(aStartIndex);
    {$ELSE}
    method IndexOf(aString: String): Int32;
    method Substring(aStartIndex: Int32): String; mapped to substringFromIndex(aStartIndex);
    {$ENDIF}

    {$IFDEF COOPER}
    method Substring(aStartIndex: Int32; aLength: Int32): String; mapped to Substring(aStartIndex, aStartIndex+aLength);
    {$ENDIF}
    {$IFDEF ECHOES}
    method Substring(aStartIndex: Int32; aLength: Int32): String; mapped to Substring(aStartIndex, aLength);
    {$ENDIF}
    {$IFDEF NOUGAT}
    method Substring(aStartIndex: Int32; aLength: Int32): String;
    {$ENDIF}

    {$IFDEF COOPER}
    method ToLower: String; mapped to toLowerCase;
    method ToUpper: String; mapped to toUpperCase;
    {$ENDIF}
    {$IFDEF NOUGAT}
    method ToLower: String; mapped to lowercaseString;
    method ToUpper: String; mapped to uppercaseString;
    {$ENDIF}
  end;

implementation

class method String.FormatDotNet(aFormat: String; params aParams: array of Object): String;
begin
  {$IFDEF ECHOES}
  result := System.String.Format(System.String(aFormat), aParams);
  {$ELSE}
  raise new SugarNotImplementedException();
  {$ENDIF}
end;

class method String.FormatC(aFormat: String; params aParams: array of Object): String;
begin
  {$IFDEF NOUGAT}
  result := Foundation.NSString.stringWithFormat(aFormat, aParams);
  {$ELSE}
  raise new SugarNotImplementedException();
  {$ENDIF}
end;

{$IFDEF NOUGAT}
method String.IndexOf(aString: String): Int32;
begin
  result := mapped.rangeOfString(aString).location;
end;

method String.Substring(aStartIndex: Int32; aLength: Int32): String;
begin
  result := mapped.substringWithRange(NSMakeRange(aStartIndex, aLength)).location;

end;
{$ENDIF}

end.
