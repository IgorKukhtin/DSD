unit GuideWorkProgress;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, StdCtrls, ExtCtrls, Grids, DBGrids, Buttons,
  Datasnap.DBClient, dsdDB, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, dxSkinsCore,
  dxSkinsDefaultPainters, cxTextEdit, cxCurrencyEdit, cxStyles,
  dxSkinscxPCPainter, cxCustomData, cxFilter, cxData, cxDataStorage, cxDBData,
  cxGridLevel, cxGridCustomTableView, cxGridTableView, cxGridDBTableView,
  cxClasses, cxGridCustomView, cxGrid,dsdAddOn, Vcl.ActnList,
  dsdAction
 ,UtilScale,DataModul, cxImageComboBox, cxButtonEdit;

type
  TGuideWorkProgressForm = class(TForm)
    GridPanel: TPanel;
    ParamsPanel: TPanel;
    DS: TDataSource;
    ButtonPanel: TPanel;
    bbExit: TSpeedButton;
    bbRefresh: TSpeedButton;
    bbChoice: TSpeedButton;
    spSelect: TdsdStoredProc;
    CDS: TClientDataSet;
    gbGoodsCode: TGroupBox;
    EditGoodsCode: TEdit;
    gbGoodsName: TGroupBox;
    EditGoodsName: TEdit;
    cxDBGrid: TcxGrid;
    cxDBGridDBTableView: TcxGridDBTableView;
    cxDBGridLevel: TcxGridLevel;
    DBViewAddOn: TdsdDBViewAddOn;
    ActionList: TActionList;
    actRefresh: TAction;
    actChoice: TAction;
    actExit: TAction;
    CuterWeight_current: TcxGridDBColumn;
    CuterWeight_total: TcxGridDBColumn;
    Cuter_diff: TcxGridDBColumn;
    RealWeight_current: TcxGridDBColumn;
    RealWeight_total: TcxGridDBColumn;
    Real_diff: TcxGridDBColumn;
    procedure FormCreate(Sender: TObject);
    procedure EditGoodsNameEnter(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsCodeKeyPress(Sender: TObject; var Key: Char);
    procedure EditGoodsCodeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure EditGoodsCodeChange(Sender: TObject);
    procedure EditGoodsNameChange(Sender: TObject);
    procedure EditGoodsCodeEnter(Sender: TObject);
    procedure CDSFilterRecord(DataSet: TDataSet; var Accept: Boolean);
    procedure EditGoodsNameKeyPress(Sender: TObject; var Key: Char);
    procedure FormDestroy(Sender: TObject);
    procedure actRefreshExecute(Sender: TObject);
    procedure actChoiceExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
  private
    fEnterGoodsCode:Boolean;
    fEnterGoodsName:Boolean;

    ParamsGoods_local: TParams;

    procedure CancelCxFilter;
    function Checked: boolean;
  public
    function Execute(var execParamsGoods:TParams): boolean;
  end;

var
  GuideWorkProgressForm: TGuideWorkProgressForm;

implementation

{$R *.dfm}

uses dmMainScale;
{------------------------------------------------------------------------------}
function TGuideWorkProgressForm.Execute(var execParamsGoods:TParams): boolean;
begin
     CopyValuesParamsFrom(execParamsGoods,ParamsGoods_local);

     CancelCxFilter;

     with spSelect do
     begin
       Params.ParamByName('inOperDate').Value      := execParamsGoods.ParamByName('OperDate').AsDateTime;
       if execParamsGoods.ParamByName('MovementItemId').AsInteger < 0
       then Params.ParamByName('inMovementItemId').Value:= -1 * execParamsGoods.ParamByName('MovementItemId').AsInteger
       else Params.ParamByName('inMovementItemId').Value:= 0;
       Params.ParamByName('inGoodsCode').Value     := execParamsGoods.ParamByName('GoodsCode').AsInteger;
       Params.ParamByName('inUnitId').Value        := execParamsGoods.ParamByName('UnitId').AsInteger;
       Params.ParamByName('inDocumentKindId').Value:= execParamsGoods.ParamByName('DocumentKindId').AsInteger;
       Execute;
     end;

     if execParamsGoods.ParamByName('MovementItemId').AsInteger < 0 then
     begin
          Result:=Checked;
          if Result then CopyValuesParamsFrom(ParamsGoods_local,execParamsGoods);
          exit;
     end;

     if execParamsGoods.ParamByName('GoodsCode').AsInteger = 0
     then begin
               fEnterGoodsCode:=true;
               fEnterGoodsName:=false;
               EditGoodsCode.Text:='';
               EditGoodsName.Text:='';
               fEnterGoodsCode:=false;
     end
     else begin
               fEnterGoodsCode:=true;
               fEnterGoodsName:=false;
               EditGoodsCode.Text:='';
               EditGoodsCode.Text:=execParamsGoods.ParamByName('GoodsCode').AsString;
               EditGoodsName.Text:='';
     end;

     //CDS.Filtered:=false;
     //CDS.Filtered:=true;

     if ParamsGoods_local.ParamByName('MovementItemId').AsInteger<>0
     then CDS.Locate('MovementItemId',ParamsGoods_local.ParamByName('MovementItemId').AsString,[])
     else if ParamsGoods_local.ParamByName('GoodsCode').AsInteger<>0
          then CDS.Locate('GoodsCode',ParamsGoods_local.ParamByName('GoodsCode').AsString,[]);


     if (execParamsGoods.ParamByName('GoodsCode').AsInteger = 0) or (CDS.RecordCount = 0)
     then ActiveControl:=EditGoodsCode
     else ActiveControl:=cxDBGrid;

     Application.ProcessMessages;
     Application.ProcessMessages;
     Application.ProcessMessages;

     result:=ShowModal=mrOk;
     if result then CopyValuesParamsFrom(ParamsGoods_local,execParamsGoods);
end;
{------------------------------------------------------------------------------}
procedure TGuideWorkProgressForm.CancelCxFilter;
begin
     if cxDBGridDBTableView.DataController.Filter.Active
     then begin cxDBGridDBTableView.DataController.Filter.Clear;cxDBGridDBTableView.DataController.Filter.Active:=false;end
end;
{------------------------------------------------------------------------------}
procedure TGuideWorkProgressForm.FormKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);
begin
    if Key=13
    then
        if (ActiveControl=cxDBGrid)and(CDS.RecordCount>0)
        then actChoiceExecute(Self)
        else begin
                  if (CDS.RecordCount=1)
                  then actChoiceExecute(Self)
                  else if (ActiveControl=EditGoodsCode)
                       then ActiveControl:=cxDBGrid //EditGoodsName
                       else if (ActiveControl=EditGoodsName)
                            then ActiveControl:=cxDBGrid; //EditGoodsCode;
        end;
    //
    if (Key=27) then
      if cxDBGridDBTableView.DataController.Filter.Active
      then CancelCxFilter
      else actExitExecute(Self);
end;
{------------------------------------------------------------------------------}
procedure TGuideWorkProgressForm.CDSFilterRecord(DataSet: TDataSet;var Accept: Boolean);
begin
     //
     if (fEnterGoodsCode)and(trim(EditGoodsCode.Text)<>'')
     then
       if  (EditGoodsCode.Text=DataSet.FieldByName('GoodsCode').AsString)
       then Accept:=true else Accept:=false;
     //
     //
     if (fEnterGoodsName)and(trim(EditGoodsName.Text)<>'')
     then
       if  (pos(AnsiUpperCase(EditGoodsName.Text),AnsiUpperCase(DataSet.FieldByName('GoodsName').AsString))>0)
       then Accept:=true else Accept:=false;

end;
{------------------------------------------------------------------------------}
function TGuideWorkProgressForm.Checked: boolean; //Проверка корректного ввода в Edit
begin
     Result:=(CDS.RecordCount>0);
     //
     if not Result
     then ActiveControl:=EditGoodsCode
     else with ParamsGoods_local do
          begin
               ParamByName('GoodsId').AsInteger       := CDS.FieldByName('GoodsId').AsInteger;
               ParamByName('GoodsCode').AsInteger     := CDS.FieldByName('GoodsCode').AsInteger;
               ParamByName('GoodsName').asString      := CDS.FieldByName('GoodsName').asString;
               ParamByName('MeasureId').AsInteger     := CDS.FieldByName('MeasureId').AsInteger;
               ParamByName('MeasureCode').AsInteger   := CDS.FieldByName('MeasureCode').AsInteger;
               ParamByName('MeasureName').asString    := CDS.FieldByName('MeasureName').asString;
               ParamByName('MovementItemId').asInteger:= CDS.FieldByName('MovementItemId').asInteger;
               ParamByName('MovementInfo').asString   := CDS.FieldByName('MovementInfo').asString;
          end;
end;
{------------------------------------------------------------------------------}
procedure TGuideWorkProgressForm.EditGoodsCodeChange(Sender: TObject);
begin
     if fEnterGoodsCode then
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditPersonalCode.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuideWorkProgressForm.EditGoodsCodeEnter(Sender: TObject);
begin TEdit(Sender).SelectAll;
      EditGoodsName.Text:='';
      //if CDS.Filtered then CDS.Filtered:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuideWorkProgressForm.EditGoodsCodeKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>32)and(Key<>27)and(Key<>13)then
     begin
          fEnterGoodsCode:=true;
          fEnterGoodsName:=false;
          EditGoodsName.Text:='';
     end
end;
{------------------------------------------------------------------------------}
procedure TGuideWorkProgressForm.EditGoodsCodeKeyPress(Sender: TObject;var Key: Char);
begin if(Key=' ')or(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuideWorkProgressForm.EditGoodsNameChange(Sender: TObject);
begin
     if fEnterGoodsName then
       with CDS do begin
           //***Filtered:=false;
           //***if trim(EditPersonalName.Text)<>'' then begin Filtered:=false;Filtered:=true;end;
           Filtered:=false;
           Filtered:=true;
       end;
end;
{------------------------------------------------------------------------------}
procedure TGuideWorkProgressForm.EditGoodsNameEnter(Sender: TObject);
begin
  TEdit(Sender).SelectAll;
  EditGoodsCode.Text:='';
  //if CDS.Filtered then CDS.Filtered:=false;
end;
{------------------------------------------------------------------------------}
procedure TGuideWorkProgressForm.EditGoodsNameKeyDown(Sender: TObject;var Key: Word; Shift: TShiftState);
begin
     if(Key<>27)and(Key<>13)then
     begin
          fEnterGoodsCode:=false;
          fEnterGoodsName:=true;
          EditGoodsCode.Text:='';
     end
end;
{------------------------------------------------------------------------------}
procedure TGuideWorkProgressForm.EditGoodsNameKeyPress(Sender: TObject; var Key: Char);
begin if(Key='+')then Key:=#0;end;
{------------------------------------------------------------------------------}
procedure TGuideWorkProgressForm.actRefreshExecute(Sender: TObject);
var MovementItemId:String;
begin
    with spSelect do begin
        MovementItemId:= DataSet.FieldByName('MovementItemId').AsString;
        Execute;
        if MovementItemId <> '' then
          DataSet.Locate('MovementItemId',MovementItemId,[loCaseInsensitive]);
    end;
end;
{------------------------------------------------------------------------------}
procedure TGuideWorkProgressForm.actChoiceExecute(Sender: TObject);
begin
     if Checked then ModalResult:=mrOK;
end;
{------------------------------------------------------------------------------}
procedure TGuideWorkProgressForm.actExitExecute(Sender: TObject);
begin
     Close;
end;
{------------------------------------------------------------------------------}
procedure TGuideWorkProgressForm.FormCreate(Sender: TObject);
begin
  Create_ParamsWorkProgress(ParamsGoods_local);

  with spSelect do
  begin
       StoredProcName:='gpSelect_Scale_WorkProgress';
       OutputType:=otDataSet;
       Params.AddParam('inOperDate', ftDateTime, ptInput, ParamsGoods_local.ParamByName('OperDate').AsDateTime);
       Params.AddParam('inMovementItemId', ftInteger, ptInput, 0);
       Params.AddParam('inGoodsCode', ftInteger, ptInput, 0);
       Params.AddParam('inUnitId', ftInteger, ptInput, 0);
       Params.AddParam('inDocumentKindId', ftInteger, ptInput, 0);
       //Execute;
  end;

end;
{------------------------------------------------------------------------------}
procedure TGuideWorkProgressForm.FormDestroy(Sender: TObject);
begin
  ParamsGoods_local.Free;
end;
{------------------------------------------------------------------------------}
end.
