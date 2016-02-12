object Report_ProfitLossDialogForm: TReport_ProfitLossDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1054' '#1055#1088#1080#1073#1099#1083#1103#1093' '#1080' '#1059#1073#1099#1090#1082#1072#1093'>'
  ClientHeight = 154
  ClientWidth = 301
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
    Left = 26
    Top = 119
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 200
    Top = 119
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
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 152
    Top = 104
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
      end
      item
        Name = 'EndDate'
        Value = 41608d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end>
    Left = 23
    Top = 102
  end
end
