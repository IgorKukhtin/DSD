inherited Member_TrasportDateDialogForm: TMember_TrasportDateDialogForm
  Caption = #1043#1088#1091#1087#1087#1086#1074#1072#1103' '#1091#1089#1090#1072#1085#1086#1074#1082#1072' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074
  ClientHeight = 134
  ClientWidth = 340
  ExplicitWidth = 346
  ExplicitHeight = 162
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 75
    Top = 96
    ExplicitLeft = 75
    ExplicitTop = 96
  end
  inherited bbCancel: TcxButton
    Left = 219
    Top = 96
    ExplicitLeft = 219
    ExplicitTop = 96
  end
  object cxLabel5: TcxLabel [2]
    Left = 20
    Top = 11
    Caption = #1053#1072#1095'.'#1076#1072#1090#1072' '#1076#1083#1103' '#1085#1086#1088#1084#1099' '#1072#1074#1090#1086' '#1083#1077#1090#1086
  end
  object edStartSummer: TcxDateEdit [3]
    Left = 189
    Top = 8
    EditValue = 42384d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 3
    Width = 100
  end
  object cxLabel3: TcxLabel [4]
    Left = 20
    Top = 40
    Caption = #1050#1086#1085'.'#1076#1072#1090#1072' '#1076#1083#1103' '#1085#1086#1088#1084#1099' '#1072#1074#1090#1086' '#1083#1077#1090#1086
  end
  object edEndSummer: TcxDateEdit [5]
    Left = 189
    Top = 43
    EditValue = 42384d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 5
    Width = 100
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 163
    Top = 96
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = edStartSummer
        Properties.Strings = (
          'EditValue'
          'Value')
      end
      item
        Component = edEndSummer
      end>
    Left = 24
    Top = 88
  end
  inherited ActionList: TActionList
    Left = 151
    Top = 31
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartSummerDate'
        Value = 'NULL'
        Component = edStartSummer
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'EndSummerDate'
        Value = 'NULL'
        Component = edEndSummer
        DataType = ftDateTime
        ParamType = ptInput
      end>
    Left = 280
    Top = 32
  end
  object cxPropertiesStore1: TcxPropertiesStore
    Components = <
      item
        Component = edStartSummer
        Properties.Strings = (
          'EditValue'
          'Value')
      end
      item
        Component = edEndSummer
        Properties.Strings = (
          'EditValue'
          'Value')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 76
    Top = 16
  end
end
