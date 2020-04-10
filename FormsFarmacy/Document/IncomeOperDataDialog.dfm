inherited IncomeOperDataDialogForm: TIncomeOperDataDialogForm
  Caption = #1044#1072#1085#1085#1099#1077' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' '#1087#1086' '#1087#1088#1080#1093#1086#1076#1091
  ClientHeight = 121
  ClientWidth = 277
  ExplicitWidth = 283
  ExplicitHeight = 150
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 49
    Top = 80
    TabOrder = 2
    ExplicitLeft = 49
    ExplicitTop = 80
  end
  inherited bbCancel: TcxButton
    Left = 130
    Top = 80
    TabOrder = 3
    ExplicitLeft = 130
    ExplicitTop = 80
  end
  object cxLabel9: TcxLabel [2]
    Left = 29
    Top = 15
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object edInvNumber: TcxTextEdit [3]
    Left = 130
    Top = 14
    Properties.ReadOnly = False
    TabOrder = 0
    Width = 105
  end
  object cxLabel11: TcxLabel [4]
    Left = 29
    Top = 42
    Caption = #1044#1072#1090#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object edPaymentDate: TcxDateEdit [5]
    Left = 130
    Top = 41
    EditValue = 42381d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 1
    Width = 105
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
        Name = 'InvNumber'
        Value = Null
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 'NULL'
        Component = edPaymentDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 8
    Top = 48
  end
end
