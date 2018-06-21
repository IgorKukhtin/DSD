object DataTimeDialogForm: TDataTimeDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1086#1088' '#1076#1072#1090#1099'/'#1074#1088#1077#1084#1077#1085#1080
  ClientHeight = 119
  ClientWidth = 295
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 33
    Top = 79
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 192
    Top = 79
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deOperDate: TcxDateEdit
    Left = 116
    Top = 29
    EditValue = 43435d
    Properties.DateButtons = [btnClear, btnNow, btnToday]
    Properties.Kind = ckDateTime
    Properties.PostPopupValueOnTab = True
    TabOrder = 2
    Width = 146
  end
  object cxLabel6: TcxLabel
    Left = 34
    Top = 30
    Caption = #1044#1072#1090#1072' / '#1074#1088#1077#1084#1103':'
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 255
    Top = 54
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Left'
          'Top')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 8
    Top = 52
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inOperDate'
        Value = 43435d
        Component = deOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 55
    Top = 62
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deOperDate
    Left = 144
    Top = 64
  end
end
