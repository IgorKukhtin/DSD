unit ChoicePeriod;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, Vcl.ComCtrls, dxCore, cxDateUtils,
  cxGroupBox, cxRadioGroup, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCalendar,
  cxLabel, cxSpinEdit, Vcl.Menus, Vcl.StdCtrls, cxButtons, cxPropertiesStore;

const
  pcDay = 0;
  pcWeek = 1;
  pcMonth = 2;
  pcQuarter = 3;
  pcYear = 4;

type

  // Компонент выбора периода
  TPeriodChoice = class(TComponent)
  private
    FDateStart: TcxDateEdit;
    FDateEnd: TcxDateEdit;
    FDateEndDblClick, FDateStartDblClick: TNotifyEvent;
    FDateEndChange, FDateStartChange: TNotifyEvent;
    FonChange: TNotifyEvent;
    FUpdateDateEdit: boolean;
    procedure SetDateEnd(const Value: TcxDateEdit);
    procedure SetDateStart(const Value: TcxDateEdit);
    procedure OnDblClick(Sender: TObject);
    procedure OnDateEditChange(Sender: TObject);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    property onChange: TNotifyEvent read FonChange write FonChange;
    procedure Execute;
    constructor Create(AOwner: TComponent); override;
  published
    property DateStart: TcxDateEdit read FDateStart write SetDateStart;
    property DateEnd: TcxDateEdit read FDateEnd write SetDateEnd;
  end;

  TPeriodChoiceForm = class(TForm)
    cxDateEnd: TcxDateEdit;
    cxDateStart: TcxDateEdit;
    cxRadioGroup: TcxRadioGroup;
    cbMonth: TcxComboBox;
    cbQuarter: TcxComboBox;
    cxLabel1: TcxLabel;
    seYear: TcxSpinEdit;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    cxLabel5: TcxLabel;
    cbWeek: TcxComboBox;
    cxLabel2: TcxLabel;
    cxLabel6: TcxLabel;
    bbOk: TcxButton;
    bbCancel: TcxButton;
    cxPropertiesStore: TcxPropertiesStore;
    procedure FormCreate(Sender: TObject);
    procedure cxRadioGroupClick(Sender: TObject);
    procedure seYearPropertiesChange(Sender: TObject);
  private
    WeekList: TList;
  public
    { Public declarations }
  end;

  procedure Register;

implementation

{$R *.dfm}

uses DateUtils, ParentForm, UtilConst;

type
  TWeek = class
    DateStart, DateEnd: TDateTime;
    constructor Create(DateStart, DateEnd: TDateTime);
  end;

procedure Register;
begin
   RegisterComponents('DSDComponent', [TPeriodChoice]);
end;

procedure TPeriodChoiceForm.cxRadioGroupClick(Sender: TObject);
begin
  with cxRadioGroup do begin
     case ItemIndex of
       pcDay: ;
       pcWeek:
          with TWeek(WeekList[cbWeek.ItemIndex]) do begin
            cxDateStart.Date := DateStart;
            cxDateEnd.Date := DateEnd;
          end;
       pcMonth:
         begin
            cxDateStart.Date := EncodeDate(seYear.Value, cbMonth.ItemIndex + 1, 1);
            cxDateEnd.Date := EndOfTheMonth(cxDateStart.Date) - gc_Minute;
          end;
       pcQuarter:
          begin
            cxDateStart.Date := EncodeDate(seYear.Value, cbQuarter.ItemIndex * 3 + 1, 1);
            cxDateEnd.Date := EndOfTheMonth(EncodeDate(seYear.Value, cbQuarter.ItemIndex * 3 + 3, 1)) - gc_Minute;
          end;
       pcYear:
          begin
            cxDateStart.Date := EncodeDate(seYear.Value, 1, 1);
            cxDateEnd.Date := EndOfTheYear(cxDateStart.Date) - gc_Minute;
          end;
     end;
  end;
end;

procedure TPeriodChoiceForm.FormCreate(Sender: TObject);
var i: integer;
begin
  for i := 1 to 12 do
    cbMonth.Properties.Items.Add(LongMonthNames[i]);
  // Заполняем недели
  WeekList := TList.Create;

  for i := 1 to WeeksInYear(Now) do begin
    WeekList.Add(TWeek.Create(EncodeDateWeek(YearOf(Now), i, 1), EncodeDateWeek(YearOf(Now), i, 7)));
    with TWeek(WeekList[WeekList.Count-1]) do
      cbWeek.Properties.Items.Add(IntToStr(i) + '   ' + FormatDateTime('dd.mm', DateStart) + '-' + FormatDateTime('dd.mm', DateEnd));
  end;
end;

procedure TPeriodChoiceForm.seYearPropertiesChange(Sender: TObject);
begin
  cxRadioGroupClick(Sender);
end;

{ TPeriodChoice }

constructor TPeriodChoice.Create(AOwner: TComponent);
begin
  inherited;
  FUpdateDateEdit := false;
end;

procedure TPeriodChoice.Execute;
begin
   with TPeriodChoiceForm.Create(nil) do
   begin
     try
       cxDateStart.Date := DateStart.Date;
       cxDateEnd.Date := DateEnd.Date;
       seYear.Value := YearOf(cxDateStart.Date);
       cbMonth.ItemIndex := MonthOf(cxDateStart.Date) - 1;
       cbQuarter.ItemIndex := (cbMonth.ItemIndex div 3);
       cbWeek.ItemIndex := WeekOf(cxDateStart.Date) - 1;
       if ShowModal = mrOk then
       begin
         FUpdateDateEdit := true;
         try
           DateStart.Date := cxDateStart.Date;
           DateEnd.Date := cxDateEnd.Date;
           if Assigned(onChange) then
              onChange(Self);
         finally
           FUpdateDateEdit := false
         end;
       end;
     finally
       Free;
     end;
   end;
end;

procedure TPeriodChoice.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited;
  if csDesigning in ComponentState then
    if Operation = opRemove then begin
      if AComponent = DateStart then begin
         FDateStartDblClick := nil;
         FDateStartChange := nil;
         DateStart := nil;
      end;
      if AComponent = DateEnd then begin
         FDateEndDblClick := nil;
         FDateEndChange := nil;
         DateEnd := nil;
      end;
    end;
end;

procedure TPeriodChoice.OnDateEditChange(Sender: TObject);
begin
  if Sender = FDateStart then
     if Assigned(FDateStartChange) then
        FDateStartChange(Sender);
  if Sender = FDateEnd then
     if Assigned(FDateEndChange) then
        FDateEndChange(Sender);
   // Вызываем только если форма видима!!!
   if (not FUpdateDateEdit) then
      if Assigned(FOnChange) then
         FOnChange(Sender);
end;

procedure TPeriodChoice.OnDblClick(Sender: TObject);
begin
  Execute;
  if (Sender = DateStart) and Assigned(FDateStartDblClick) then
     FDateStartDblClick(Sender);
  if (Sender = DateEnd) and Assigned(FDateEndDblClick) then
     FDateEndDblClick(Sender);
end;

procedure TPeriodChoice.SetDateEnd(const Value: TcxDateEdit);
begin
  FDateEnd := Value;
  if Assigned(FDateEnd) then begin
     FDateEndDblClick := FDateEnd.OnDblClick;
     FDateEnd.OnDblClick := OnDblClick;
//     FDateEndChange := FDateEnd.Properties.OnChange;
//     FDateEnd.Properties.OnChange := OnDateEditChange;
  end;
end;

procedure TPeriodChoice.SetDateStart(const Value: TcxDateEdit);
begin
  FDateStart := Value;
  if Assigned(FDateStart) then begin
     FDateStartDblClick := FDateStart.OnDblClick;
     FDateStart.OnDblClick := OnDblClick;
//     FDateStartChange := FDateStart.Properties.OnChange;
//     FDateStart.Properties.OnChange := OnDateEditChange;
  end;
end;

{ TWeek }

constructor TWeek.Create(DateStart, DateEnd: TDateTime);
begin
  inherited Create;
  Self.DateStart := DateStart;
  Self.DateEnd := DateEnd;
end;

end.
