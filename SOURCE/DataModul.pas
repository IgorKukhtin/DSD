unit DataModul;

interface

uses
  SysUtils, Classes, ImgList, Controls, frxClass, cxClasses, cxStyles,
  cxGridBandedTableView, cxGridTableView;

type

  {форма содержит компоненты с картинками}
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
    cxStyle1: TcxStyle;
  end;

var dmMain: TdmMain;
implementation

{$R *.dfm}

end.
