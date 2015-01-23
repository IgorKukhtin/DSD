unit Scales;

interface

uses dsdAction, Classes, dsdDb;

type

  TScaleType = (stBI, stDB);

  TScale = class(TObject)
  private
    FScale: OleVariant;
    FComPort: String;
    FComSpeed: Integer;
    FScaleType: TScaleType;
    class function NewInstance: TObject; override;
    procedure Active;
    function GetWeight: double;
  public
    property Weight: Double read GetWeight;
  end;

  TScaleAction = class (TdsdCustomAction)
  private
    FComPort: String;
    FComSpeed: Integer;
    FScaleType: TScaleType;
    FWeight: TdsdParam;
  protected
    function LocalExecute: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Caption;
    property Hint;
    property ImageIndex;
    property ShortCut;
    property SecondaryShortCuts;
    property ScaleType: TScaleType read FScaleType write FScaleType default stBI;
    property ComPort: String read FComPort write FComPort;
    property ComSpeed: Integer read FComSpeed write FComSpeed;
    property Weight: TdsdParam read FWeight write FWeight;
  end;

  procedure Register;

implementation

uses VCL.ActnList, Variants, ComObj, IniFiles, SysUtils, TypInfo;

procedure Register;
begin
  RegisterActions('DSDLib', [TScaleAction], TScaleAction);
end;

type

  TScaleFactory = class
     strict private
       class var
         FScale: TScale;
  private
     class function GetScale(ScaleType: TScaleType; ComPort: string; ComSpeed: integer): TScale;
  end;

{ TScaleFactory }

class function TScaleFactory.GetScale(ScaleType: TScaleType; ComPort: string;
  ComSpeed: integer): TScale;
begin
  if Assigned(FScale) then
     result := FScale
  else begin
       result := TScale(TScale.NewInstance);
       result.FScaleType := ScaleType;
       result.FComPort  := ComPort;
       result.FComSpeed := ComSpeed;
       result.Active;
  end;
end;

{ TScaleAction }

constructor TScaleAction.Create(AOwner: TComponent);
begin
  inherited;
  ScaleType := stBI;
  FWeight := TdsdParam.Create(nil);
end;

function TScaleAction.LocalExecute: Boolean;
begin
  FWeight.Value := TScaleFactory.GetScale(ScaleType, ComPort, ComSpeed).Weight;
end;

{ TScale }

procedure TScale.Active;
const
  CLASS_CasDB: TGUID = '{B6D98687-BC2C-4E24-A0CD-2C5339DE1388}';
  CLASS_CasBI: TGUID = '{D7B9499D-59B2-4951-AD37-06227C403315}';
  IniFileName = 'scale.ini';
  Section = 'ScaleInit';
var
  IniFile: TIniFile;
begin
  if FScale = Unassigned then begin
     IniFile := TIniFile.Create( ExtractFilePath(ParamStr(0)) + IniFileName);
     try
       FComPort := IniFile.ReadString(Section, 'ComPort', 'COM1');
       FComSpeed := IniFile.ReadInteger(Section, 'ComSpeed', 9600);
       FScaleType := TScaleType(GetEnumValue(TypeInfo(TScaleType), IniFile.ReadString(Section, 'ScaleType', 'stBI')));
       case FScaleType of
          stBI: FScale := CreateComObject(CLASS_CasBI) as IDispatch;
          stDB: FScale := CreateComObject(CLASS_CasDB) as IDispatch;
       end;
       FScale.CommPort := FComPort;
       FScale.CommSpeed := FComSpeed;
     finally
       IniFile.WriteString(Section, 'ComPort', FComPort);
       IniFile.WriteInteger(Section, 'ComSpeed', FComSpeed);
       IniFile.WriteString(Section, 'ScaleType', GetEnumName(TypeInfo(TScaleType), ord(FScaleType)));
       IniFile.Free;
     end;
  end;
end;

function TScale.GetWeight: Double;
begin
  FScale.Active := 1;
  try
    result := FScale.Weight
  finally
    FScale.Active := 0;
  end;
end;

class function TScale.NewInstance: TObject;
begin
  result := TScale(inherited NewInstance);
  TScale(result).FScale := Unassigned;
end;

initialization

  RegisterClass(TScaleAction);

end.
