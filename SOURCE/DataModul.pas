unit DataModul;

interface

uses
  SysUtils, Classes, ImgList, Controls, frxClass, cxClasses, cxStyles,
  cxGridBandedTableView, cxGridTableView, cxTL, Data.DB, Datasnap.DBClient;

type

  {����� �������� ���������� � ����������}
  TdmMain = class(TDataModule)
    ImageList: TImageList;
    MainImageList: TImageList;
    TreeImageList: TImageList;
    frxReport: TfrxReport;
    cxStyleRepository: TcxStyleRepository;
    cxGridBandedTableViewStyleSheet: TcxGridBandedTableViewStyleSheet;
    cxHeaderStyle: TcxStyle;
    cxGridTableViewStyleSheet: TcxGridTableViewStyleSheet;
    SortImageList: TImageList;
    cxTreeListStyleSheet: TcxTreeListStyleSheet;
    cxFooterStyle: TcxStyle;
    cxSelection: TcxStyle;
  end;

var dmMain: TdmMain;
implementation

{$R *.dfm}

end.
