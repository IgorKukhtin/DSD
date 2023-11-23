inherited AncestorDialog_boatForm: TAncestorDialog_boatForm
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
    Width = 90
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object bbCancel: TcxButton [1]
    Left = 218
    Top = 272
    Width = 90
    Height = 25
    Action = actFormClose
    Cancel = True
    ModalResult = 8
    TabOrder = 1
  end
  inherited ActionList: TActionList
    Images = dmMain.ImageList
    object actFormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1054#1090#1084#1077#1085#1072
      Hint = #1054#1090#1084#1077#1085#1072
      ImageIndex = 52
    end
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 16
    Top = 232
  end
end
