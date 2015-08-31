inherited RecalcMCS_DialogForm: TRecalcMCS_DialogForm
  ActiveControl = edPeriod
  Caption = 'RecalcMCS_DialogForm'
  ClientHeight = 128
  ExplicitHeight = 153
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Top = 88
    ExplicitTop = 88
  end
  inherited bbCancel: TcxButton
    Top = 88
    ExplicitTop = 88
  end
  object cxLabel1: TcxLabel [2]
    Left = 54
    Top = 16
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1085#1077#1081' '#1076#1083#1103' '#1072#1085#1072#1083#1080#1079#1072
  end
  object cxLabel2: TcxLabel [3]
    Left = 54
    Top = 44
    Caption = #1057#1090#1088#1072#1093#1086#1074#1086#1081' '#1079#1072#1087#1072#1089' '#1076#1083#1103' '#1061' '#1076#1085#1077#1081
  end
  object edPeriod: TcxCurrencyEdit [4]
    Left = 218
    Top = 12
    EditValue = 1
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.MinValue = 1.000000000000000000
    TabOrder = 4
    Width = 55
  end
  object edDay: TcxCurrencyEdit [5]
    Left = 218
    Top = 39
    EditValue = 1.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.MinValue = 1.000000000000000000
    TabOrder = 5
    Width = 55
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Top = 80
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = edDay
        Properties.Strings = (
          'EditValue'
          'Value')
      end
      item
        Component = edPeriod
        Properties.Strings = (
          'EditValue'
          'Value')
      end>
    Top = 80
  end
  inherited ActionList: TActionList
    Top = 79
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'RecalcMCS_Period'
        Value = Null
        Component = edPeriod
        ParamType = ptInput
      end
      item
        Name = 'RecalcMCS_Day'
        Value = Null
        Component = edDay
        ParamType = ptInput
      end>
    Top = 48
  end
end
