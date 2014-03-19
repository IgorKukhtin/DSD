unit DialogBillKind;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  AncestorDialog, dsdDB, Data.DB, Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids,
  Data.Bind.EngExt, Vcl.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  Vcl.Bind.Editors, Data.Bind.Components, dsdAddOn;

type
  TDialogBillKindForm = class(TAncestorDialogForm)
    gbPartnerAll: TGroupBox;
    PanelPartner: TPanel;
    LabelPartner: TLabel;
    gbPartnerCode: TGroupBox;
    EditPartnerCode: TEdit;
    gbPartnerName: TGroupBox;
    PanelPartnerName: TPanel;
    PanelRouteUnit: TPanel;
    LabelRouteUnit: TLabel;
    gbRouteUnitCode: TGroupBox;
    EditRouteUnitCode: TEdit;
    gbRouteUnitName: TGroupBox;
    PanelRouteUnitName: TPanel;
    gbGrid: TGroupBox;
    ClientDataSet: TClientDataSet;
    DataSource: TDataSource;
    spData: TdsdStoredProc;
    DBGrid: TDBGrid;
    procedure bbOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGridCellClick(Column: TColumn);
    procedure EditPartnerCodeExit(Sender: TObject);

  private
    function Checked: boolean; override;//Проверка корректного ввода в Edit
  public
    { Public declarations }
  end;

var
  DialogBillKindForm: TDialogBillKindForm;

implementation

{$R *.dfm}

uses Main, DM;

function TDialogBillKindForm.Checked: boolean; //Проверка корректного ввода в Edit

begin
     Result:=True;
end;


procedure TDialogBillKindForm.bbOkClick(Sender: TObject);
begin
 if ClientDataSet.FieldByName('GroupSubNum').AsInteger=0 then Exit;
 ShowMessage(ClientDataSet.FieldByName('DisplayName').asString);
// DialogBillKindForm.Checked:=true;
 inherited;
end;


procedure TDialogBillKindForm.DBGridCellClick(Column: TColumn);
begin
  inherited;
  bbOkClick(Self);
end;

procedure TDialogBillKindForm.DBGridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
  inherited;
     if ClientDataSet.FieldByName('GroupSubNum').AsInteger=0 then
     with (Sender as TDBGrid).Canvas do
     begin
          Font.Color:=clBlack;
          FillRect(Rect);
          TextOut(Rect.Left + 2, Rect.Top + 2, Column.Field.Text);
     end;

end;

procedure TDialogBillKindForm.EditPartnerCodeExit(Sender: TObject);
var
 PartnerObject: TDBObject;
begin
  inherited;
     try CurSetting.PartnerCode:=StrToInt(trim(EditPartnerCode.Text));except CurSetting.PartnerCode:=0;end;
     PartnerObject := GetObject_byCode(CurSetting.PartnerCode);
     PanelPartnerName.Caption := PartnerObject.Name;
//     try RouteUnitCode:=StrToInt(trim(EditRouteUnitCode.Text));except RouteUnitCode:=0;end;

end;

procedure TDialogBillKindForm.FormCreate(Sender: TObject);
begin
  inherited;
  spData.Execute;
//  TDrawGrid(DBGrid).ScrollBars:=ssNone;
end;

end.
