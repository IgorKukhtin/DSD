unit EDI;

interface

uses Classes, dsdDB;

type

  // Компонент работы с EDI. Пока все засунем в него
  // Ну не совсем все, конечно, но много
  TEDI = class(TComponent)
  private
    FDESADVHeader: TdsdStoredProc;
    FDESADVList: TdsdStoredProc;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure DESADV(Id: integer);
  published
    property DESADVHeader: TdsdStoredProc read FDESADVHeader write FDESADVHeader;
    property DESADVList: TdsdStoredProc read FDESADVList write FDESADVList;
  end;

  procedure Register;

implementation

uses DBClient;

procedure Register;
begin
   RegisterComponents('DSDComponent', [TEDI]);
end;

{ TEDI }

constructor TEDI.Create(AOwner: TComponent);
begin
  inherited;
  DESADVHeader := TdsdStoredProc.Create(Self);
end;

procedure TEDI.DESADV(Id: integer);
var
  HeaderDataSet, ListDataSet: TClientDataSet;
begin
  HeaderDataSet := TClientDataSet.Create(nil);
  ListDataSet := TClientDataSet.Create(nil);
  try

  finally
    HeaderDataSet.Free;
    ListDataSet.Free;
  end;
end;

destructor TEDI.Destroy;
begin
  DESADVHeader.Free;
  inherited;
end;

end.
