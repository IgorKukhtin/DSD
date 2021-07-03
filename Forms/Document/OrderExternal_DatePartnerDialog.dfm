object OrderExternal_DatePartnerDialogForm: TOrderExternal_DatePartnerDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1086#1088' '#1044#1072#1090#1099' '#1086#1090#1075#1088#1091#1079#1082#1080
  ClientHeight = 142
  ClientWidth = 285
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
    Left = 18
    Top = 88
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 192
    Top = 88
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deOperDatePartner: TcxDateEdit
    Left = 131
    Top = 49
    EditValue = 42705d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 2
    Width = 90
  end
  object cxLabel6: TcxLabel
    Left = 34
    Top = 50
    Caption = #1044#1072#1090#1072' '#1086#1090#1075#1088#1091#1079#1082#1080':'
  end
  object cbAuto: TcxCheckBox
    Left = 34
    Top = 15
    Caption = #1088#1077#1078#1080#1084' '#1088#1072#1089#1095#1077#1090#1072' '#1072#1074#1090#1086#1084#1072#1090'. ('#1076#1072' / '#1085#1077#1090')'
    TabOrder = 4
    Width = 207
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
    Left = 256
    Top = 20
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inOperDatePartner'
        Value = 41579d
        Component = deOperDatePartner
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAuto'
        Value = Null
        Component = cbAuto
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsAuto'
        Value = Null
        Component = cbAuto
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 63
    Top = 99
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deOperDatePartner
    Left = 136
    Top = 93
  end
end
