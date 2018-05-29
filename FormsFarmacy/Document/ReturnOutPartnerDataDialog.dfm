inherited ReturnOutPartnerDataDialogForm: TReturnOutPartnerDataDialogForm
  Caption = #1044#1072#1085#1085#1099#1077' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' '#1087#1086' '#1074#1086#1079#1074#1088#1072#1090#1091
  ClientHeight = 142
  ClientWidth = 284
  ExplicitWidth = 290
  ExplicitHeight = 171
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 60
    Top = 99
    TabOrder = 2
    ExplicitLeft = 60
    ExplicitTop = 99
  end
  inherited bbCancel: TcxButton
    Left = 141
    Top = 99
    TabOrder = 3
    ExplicitLeft = 141
    ExplicitTop = 99
  end
  object cxLabel9: TcxLabel [2]
    Left = 17
    Top = 15
    Caption = #8470' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
  end
  object edInvNumberPartner: TcxTextEdit [3]
    Left = 168
    Top = 14
    Properties.ReadOnly = False
    TabOrder = 0
    Width = 105
  end
  object cxLabel11: TcxLabel [4]
    Left = 17
    Top = 42
    Caption = #1044#1072#1090#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
  end
  object edOperDatePartner: TcxDateEdit [5]
    Left = 168
    Top = 41
    EditValue = 42381d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 1
    Width = 105
  end
  object edAdjustingOurDate: TcxDateEdit [6]
    Left = 168
    Top = 69
    EditValue = 42381d
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 6
    Width = 105
  end
  object cxLabel1: TcxLabel [7]
    Left = 17
    Top = 70
    Caption = #1050#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072' '#1085#1072#1096#1077#1081' '#1076#1072#1090#1099
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 203
    Top = 91
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 8
    Top = 99
  end
  inherited ActionList: TActionList
    Left = 231
    Top = 90
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'InvNumberPartner'
        Value = Null
        Component = edInvNumberPartner
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDatePartner'
        Value = 'NULL'
        Component = edOperDatePartner
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'AdjustingOurDate'
        Value = 'NULL'
        Component = edAdjustingOurDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 8
    Top = 67
  end
end
