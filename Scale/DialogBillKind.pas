unit DialogBillKind;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  AncestorDialog, dsdDB, Data.DB, Datasnap.DBClient, Vcl.Grids, Vcl.DBGrids,
  Data.Bind.EngExt, Vcl.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  Vcl.Bind.Editors, Data.Bind.Components, dsdAddOn, Util, Data.FMTBcd,
  Data.SqlExpr;

type
  TDialogBillKindForm = class(TAncestorDialogForm)
    gbPartnerAll: TGroupBox;
    PanelPartner: TPanel;
    gbPartnerCode: TGroupBox;
    EditPartnerCode: TEdit;
    gbPartnerName: TGroupBox;
    PanelPartnerName: TPanel;
    PanelRouteUnit: TPanel;
    gbRouteUnitCode: TGroupBox;
    EditRouteUnitCode: TEdit;
    gbRouteUnitName: TGroupBox;
    PanelRouteUnitName: TPanel;
    gbGrid: TGroupBox;
    ClientDataSet: TClientDataSet;
    DataSource: TDataSource;
    spData: TdsdStoredProc;
    DBGrid: TDBGrid;
    PanelPriceList: TPanel;
    gbPriceListCode: TGroupBox;
    EditPriceListCode: TEdit;
    gbPriceListName: TGroupBox;
    PanelPriceListName: TPanel;
    procedure bbOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure DBGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure DBGridCellClick(Column: TColumn);
    procedure EditPartnerCodeExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure EditRouteUnitCodeExit(Sender: TObject);
    procedure EditPriceListCodeExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);

  private
    function Checked: boolean; override;//Проверка корректного ввода в Edit
  public
    function Execute: boolean; override;
  end;

var
  DialogBillKindForm: TDialogBillKindForm;

implementation

{$R *.dfm}

uses Main;

function TDialogBillKindForm.Execute: boolean; //Проверка корректного ввода в Edit
begin
      result:=(ShowModal=mrOk);
end;

function TDialogBillKindForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     Result:=True;
//     spData.fi
//     SQLQuery1.FieldByName()
end;


procedure TDialogBillKindForm.bbOkClick(Sender: TObject);
begin
 if ClientDataSet.FieldByName('GroupSubNum').AsInteger=0 then Exit;
// EditPartnerCodeExit(Sender);
// EditRouteUnitCodeExit(Sender);
// EditPartnerCodeExit(Sender);
      if ActiveControl=EditPartnerCode then EditPartnerCodeExit(Sender)
      else if ActiveControl=EditRouteUnitCode then EditRouteUnitCodeExit(Sender)
           else if ActiveControl=EditPriceListCode then EditPriceListCodeExit(Sender);


// ShowMessage(ClientDataSet.FieldByName('DisplayName').asString);
 NewSetting.ToolsCode:= ClientDataSet.FieldByName('Code').asInteger;
 NewSetting.DescId:= ClientDataSet.FieldByName('DescId').asInteger;
 NewSetting.DescName:= ClientDataSet.FieldByName('DescName').asString;
 NewSetting.FromId:= ClientDataSet.FieldByName('FromId').asInteger;
 NewSetting.FromName:= ClientDataSet.FieldByName('FromName').asString;
 NewSetting.ToId:= ClientDataSet.FieldByName('ToId').asInteger;
 NewSetting.ToName:= ClientDataSet.FieldByName('ToName').asString;
 NewSetting.PaidKindId:= ClientDataSet.FieldByName('PaidKindId').asInteger;
 NewSetting.PaidKindName:= ClientDataSet.FieldByName('PaidKindName').asString;
 NewSetting.ColorGridName:= ClientDataSet.FieldByName('ColorGridName').asString;

 CurSetting := NewSetting;
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
     try NewSetting.PartnerCode:=StrToInt(trim(EditPartnerCode.Text));except NewSetting.PartnerCode:=0;end;
     PartnerObject := GetObject_byCode(NewSetting.PartnerCode, 30);
     PanelPartnerName.Caption := PartnerObject.Name;
     NewSetting.PartnerId := PartnerObject.Id;
     NewSetting.PartnerName := PartnerObject.Name;
     NewSetting.PartnerCode := PartnerObject.Code;
//     try RouteUnitCode:=StrToInt(trim(EditRouteUnitCode.Text));except RouteUnitCode:=0;end;
end;

procedure TDialogBillKindForm.EditPriceListCodeExit(Sender: TObject);
var
 PriceListObject: TDBObject;
begin
  inherited;
     try NewSetting.PriceListCode:=StrToInt(trim(EditPriceListCode.Text));except NewSetting.PriceListCode:=0;end;
     PriceListObject := GetObject_byCode(NewSetting.PriceListCode, 34);
     PanelPriceListName.Caption := PriceListObject.Name;
     NewSetting.PriceListId := PriceListObject.Id;
     NewSetting.PriceListName := PriceListObject.Name;
     NewSetting.PriceListCode := PriceListObject.Code;

end;

procedure TDialogBillKindForm.EditRouteUnitCodeExit(Sender: TObject);
var
 RouteSortingObject: TDBObject;
begin
  inherited;
     try NewSetting.RouteSortingCode:=StrToInt(trim(EditRouteUnitCode.Text));except NewSetting.RouteSortingCode:=0;end;
     RouteSortingObject := GetObject_byCode(NewSetting.RouteSortingCode, 33);
     PanelRouteUnitName.Caption := RouteSortingObject.Name;
     NewSetting.RouteSortingId := RouteSortingObject.Id;
     NewSetting.RouteSortingName := RouteSortingObject.Name;
     NewSetting.RouteSortingCode := RouteSortingObject.Code;
end;

procedure TDialogBillKindForm.FormCreate(Sender: TObject);
begin
  inherited;
  spData.Params.AddParam('inRootId', ftInteger, ptInput, CurSetting.ScaleNum);
  spData.Execute;
  ClientDataSet.Locate('Code',CurSetting.DefaultToolsCode,[]);
  bbOk.Visible := false;
  ActiveControl:=EditPartnerCode;
end;

procedure TDialogBillKindForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

     if Key = VK_RETURN then
      if (ActiveControl=EditPartnerCode)and(PanelRouteUnit.Visible)then ActiveControl:=EditRouteUnitCode
      else if (ActiveControl=EditPartnerCode)and(not PanelRouteUnit.Visible)then ActiveControl:=EditPriceListCode
           else if ActiveControl=EditRouteUnitCode then ActiveControl:=EditPriceListCode
                else if ActiveControl=EditPriceListCode then bbOkClick(self);

end;

procedure TDialogBillKindForm.FormShow(Sender: TObject);
begin
  inherited;
  if CurSetting.PartnerCode<>0 then
  EditPartnerCode.Text := IntToStr(CurSetting.PartnerCode)
  else EditPartnerCode.Text:='';
  PanelPartnerName.Caption := CurSetting.PartnerName;

  if CurSetting.RouteSortingId<>0 then
  EditRouteUnitCode.Text := IntToStr(CurSetting.RouteSortingCode)
  else EditRouteUnitCode.Text:='';
  PanelRouteUnitName.Caption := CurSetting.RouteSortingName;

  if CurSetting.PriceListId<>0 then
  EditPriceListCode.Text := IntToStr(CurSetting.PriceListCode)
  else EditPriceListCode.Text:='';
  PanelPriceListName.Caption := CurSetting.PriceListName;

end;

end.
