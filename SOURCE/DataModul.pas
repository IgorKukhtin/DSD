unit DataModul;

interface

uses
  SysUtils, Classes, ImgList, Controls, frxClass;

type

  {форма содержит компоненты с картинками}
  TdmMain = class(TDataModule)
    ImageList: TImageList;
    MainImageList: TImageList;
    TreeImageList: TImageList;
    frxReport: TfrxReport;
  end;

var dmMain: TdmMain;
implementation

{$R *.dfm}

end.
