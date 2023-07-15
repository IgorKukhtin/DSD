object Report_PriceList_BestPriceDialogForm: TReport_PriceList_BestPriceDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1051#1091#1095#1096#1072#1103' '#1094#1077#1085#1072'>'
  ClientHeight = 144
  ClientWidth = 299
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 24
    Top = 95
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 147
    Top = 95
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
  object deEnd: TcxDateEdit
    Left = 137
    Top = 31
    EditValue = 42370d
    Properties.ShowTime = False
    TabOrder = 1
    Width = 85
  end
  object cxLabel2: TcxLabel
    Left = 137
    Top = 8
    Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
  end
  object deStart: TcxDateEdit
    Left = 8
    Top = 31
    EditValue = 42370d
    Properties.ShowTime = False
    TabOrder = 0
    Width = 85
  end
  object cxLabel1: TcxLabel
    Left = 8
    Top = 8
    Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
  end
  object cxLabel4: TcxLabel
    Left = 12
    Top = 59
    Caption = '% '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1077' '
  end
  object edProcent: TcxCurrencyEdit
    Left = 99
    Top = 58
    EditValue = 10.000000000000000000
    Properties.DisplayFormat = ',0.00;-,0.00'
    TabOrder = 7
    Width = 74
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 39
    Top = 19
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 182
    Top = 17
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
    Left = 183
    Top = 87
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'Procent'
        Value = Null
        Component = edProcent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 46
    Top = 73
  end
end
