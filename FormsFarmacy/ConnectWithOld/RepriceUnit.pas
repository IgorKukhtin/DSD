unit RepriceUnit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.CheckLst, Data.DB,
  Datasnap.DBClient, dsdDB, cxGraphics, cxControls, cxLookAndFeels,
  cxLookAndFeelPainters, cxContainer, cxEdit, cxCheckListBox, cxDBCheckListBox,
  Vcl.Grids, Vcl.DBGrids;

type
  TRepriceUnitForm = class(TForm)
    Button1: TButton;
    GetUnitsList: TdsdStoredProc;
    UnitsCDS: TClientDataSet;
    UnitsDS: TDataSource;
    CheckListBox: TCheckListBox;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}

procedure TRepriceUnitForm.FormCreate(Sender: TObject);
begin
  GetUnitsList.Execute;

  UnitsCDS.First;
  while not UnitsCDS.Eof do begin
    CheckListBox.Items.Add(UnitsCDS.FieldByName('UnitName').asString);
    UnitsCDS.Next;
  end;
end;

end.
