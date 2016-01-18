inherited Member_TrasportDialogForm: TMember_TrasportDialogForm
  Caption = #1043#1088#1091#1087#1087#1086#1074#1072#1103' '#1091#1089#1090#1072#1085#1086#1074#1082#1072' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074
  ClientHeight = 209
  ClientWidth = 354
  ExplicitWidth = 360
  ExplicitHeight = 237
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 90
    Top = 162
    ExplicitLeft = 90
    ExplicitTop = 162
  end
  inherited bbCancel: TcxButton
    Left = 234
    Top = 162
    ExplicitLeft = 234
    ExplicitTop = 162
  end
  object cxLabel6: TcxLabel [2]
    Left = 28
    Top = 8
    Caption = #1053#1086#1088#1084#1072' '#1072#1074#1090#1086' '#1083#1077#1090#1086', '#1083#1080#1090#1088#1099
  end
  object cxLabel8: TcxLabel [3]
    Left = 28
    Top = 129
    Caption = #1051#1080#1084#1080#1090', '#1082#1084
  end
  object cxLabel4: TcxLabel [4]
    Left = 28
    Top = 98
    Caption = #1051#1080#1084#1080#1090', '#1075#1088#1085
  end
  object cxLabel7: TcxLabel [5]
    Left = 28
    Top = 38
    Caption = #1053#1086#1088#1084#1072' '#1072#1074#1090#1086' '#1079#1080#1084#1072', '#1083#1080#1090#1088#1099
  end
  object cxLabel9: TcxLabel [6]
    Left = 28
    Top = 68
    Caption = #1040#1084#1086#1088#1090#1080#1079#1072#1094#1080#1103' '#1079#1072' 1 '#1082#1084'., '#1075#1088#1085'.'
  end
  object edLimit: TcxCurrencyEdit [7]
    Left = 197
    Top = 97
    EditValue = '0'
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 7
    Width = 100
  end
  object edReparation: TcxCurrencyEdit [8]
    Left = 197
    Top = 70
    EditValue = '0'
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 8
    Width = 100
  end
  object edSummerFuel: TcxCurrencyEdit [9]
    Left = 197
    Top = 8
    EditValue = '0'
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 9
    Width = 100
  end
  object edWinterFuel: TcxCurrencyEdit [10]
    Left = 197
    Top = 40
    EditValue = '0'
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 10
    Width = 100
  end
  object edLimitDistance: TcxCurrencyEdit [11]
    Left = 197
    Top = 124
    EditValue = '0'
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 11
    Width = 100
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 171
    Top = 162
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 32
    Top = 154
  end
  inherited ActionList: TActionList
    Left = 319
    Top = 41
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'SummerFuel'
        Value = 30
        Component = edSummerFuel
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'WinterFuel'
        Value = 30
        Component = edWinterFuel
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'Reparation'
        Value = 30
        Component = edReparation
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'LimitMoney'
        Value = 30
        Component = edLimit
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'LimitDistance'
        Value = 30
        Component = edLimitDistance
        DataType = ftFloat
        ParamType = ptInput
      end>
    Left = 320
    Top = 114
  end
  object cxPropertiesStore1: TcxPropertiesStore
    Components = <>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 324
    Top = 16
  end
end
