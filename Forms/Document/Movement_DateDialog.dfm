object Movement_DateDialogForm: TMovement_DateDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1042#1099#1073#1086#1088' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074' '#1076#1083#1103' '#1078#1091#1088#1085#1072#1083#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074
  ClientHeight = 191
  ClientWidth = 392
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
    Left = 34
    Top = 151
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 208
    Top = 151
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 131
    Top = 70
    EditValue = 42370d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 90
  end
  object deStart: TcxDateEdit
    Left = 131
    Top = 29
    EditValue = 42370d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 90
  end
  object cxLabel6: TcxLabel
    Left = 34
    Top = 30
    Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
  end
  object cxLabel7: TcxLabel
    Left = 15
    Top = 71
    Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
  end
  object edIsPartnerDate: TcxCheckBox
    Left = 15
    Top = 109
    Caption = #1055#1077#1088#1080#1086#1076' '#1076#1083#1103' <'#1044#1072#1090#1072' '#1091' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'/'#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' / '#1044#1072#1090#1072' '#1088#1077#1075#1080#1089#1090#1088#1072#1094#1080#1080'>'
    TabOrder = 6
    Width = 369
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 160
    Top = 136
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 215
    Top = 46
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
    Left = 248
    Top = 12
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = 41579d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = 41608d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsPartnerDate'
        Value = Null
        Component = edIsPartnerDate
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 103
    Top = 30
  end
end
