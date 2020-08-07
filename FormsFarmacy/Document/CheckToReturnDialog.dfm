inherited CheckToReturnDialogForm: TCheckToReturnDialogForm
  Caption = #1042#1099#1073#1086#1088' '#1095#1077#1082#1072' '#1076#1083#1103' '#1074#1086#1079#1074#1088#1072#1090#1072
  ClientHeight = 134
  ClientWidth = 276
  ExplicitWidth = 282
  ExplicitHeight = 163
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 49
    Top = 80
    ExplicitLeft = 49
    ExplicitTop = 80
  end
  inherited bbCancel: TcxButton
    Left = 130
    Top = 80
    ExplicitLeft = 130
    ExplicitTop = 80
  end
  object ceTotalSumm: TcxCurrencyEdit [2]
    Left = 107
    Top = 38
    Properties.DisplayFormat = ',0.00;-,0.00'
    TabOrder = 2
    Width = 121
  end
  object cxLabel2: TcxLabel [3]
    Left = 10
    Top = 39
    Caption = #1057#1091#1084#1084#1072' '#1095#1077#1082#1072':'
  end
  object deOperDate: TcxDateEdit [4]
    Left = 107
    Top = 5
    EditValue = 42370d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 4
    Width = 121
  end
  object cxLabel1: TcxLabel [5]
    Left = 10
    Top = 6
    Caption = #1044#1072#1090#1072' '#1095#1077#1082#1072':'
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 203
    Top = 72
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 8
    Top = 80
  end
  inherited ActionList: TActionList
    Left = 231
    Top = 71
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'OperDate'
        Value = 'NULL'
        Component = deOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Summa'
        Value = Null
        Component = ceTotalSumm
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 8
    Top = 48
  end
end
