inherited AncestorDialogForm: TAncestorDialogForm
  BorderStyle = bsDialog
  ClientHeight = 320
  ClientWidth = 378
  AddOnFormData.Params = FormParams
  ExplicitWidth = 384
  ExplicitHeight = 349
  PixelsPerInch = 96
  TextHeight = 13
  object bbOk: TcxButton [0]
    Left = 74
    Top = 272
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object bbCancel: TcxButton [1]
    Left = 218
    Top = 272
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 1
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 16
    Top = 232
  end
end
