unit DataModul;

interface

uses
  SysUtils, Classes, ImgList, Controls;

type

  {форма содержит компоненты с картинками}
  TdmMain = class(TDataModule)
    ImageList: TImageList;
    MainImageList: TImageList;
  end;

var dmMain: TdmMain;
implementation

{$R *.dfm}

end.
