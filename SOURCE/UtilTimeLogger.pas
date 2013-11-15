unit UtilTimeLogger;

interface

type

 TTimeLogger = class (TObject)
 strict private
    class var
      Instance: TTimeLogger;
 protected
   class function NewInstance: TObject; override;
 public
   procedure Start;
   procedure AddAction(AMessage: String);
   procedure Finish;
 end;

 TTimeLoggerFactory = class (TObject)
   class function GetTimeLogger: TTimeLogger;
 end;

implementation

{ TTimeLoggerFactory }

class function TTimeLoggerFactory.GetTimeLogger: TTimeLogger;
begin

end;

{ TTimeLogger }

procedure TTimeLogger.AddAction(AMessage: String);
begin

end;

procedure TTimeLogger.Finish;
begin

end;

class function TTimeLogger.NewInstance: TObject;
begin

end;

procedure TTimeLogger.Start;
begin

end;

end.
