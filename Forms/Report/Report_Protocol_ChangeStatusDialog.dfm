inherited Report_Protocol_ChangeStatusDialogForm: TReport_Protocol_ChangeStatusDialogForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1088#1086#1090#1086#1082#1086#1083' '#1080#1079#1084#1077#1085#1077#1085#1080#1081' '#1089#1090#1072#1090#1091#1089#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074'>'
  ClientHeight = 210
  ClientWidth = 296
  ExplicitWidth = 302
  ExplicitHeight = 239
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbOk: TcxButton
    Left = 26
    Top = 176
    Height = 26
    ExplicitLeft = 26
    ExplicitTop = 176
    ExplicitHeight = 26
  end
  inherited bbCancel: TcxButton
    Left = 166
    Top = 176
    Height = 26
    ExplicitLeft = 166
    ExplicitTop = 176
    ExplicitHeight = 26
  end
  object cxLabel1: TcxLabel [2]
    Left = 8
    Top = 9
    Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072' ('#1087#1088#1086#1090#1086#1082#1086#1083'):'
  end
  object deStart: TcxDateEdit [3]
    Left = 183
    Top = 8
    EditValue = 45658d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 80
  end
  object cxLabel2: TcxLabel [4]
    Left = 8
    Top = 32
    Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072' ('#1087#1088#1086#1090#1086#1082#1086#1083'):'
  end
  object deEnd: TcxDateEdit [5]
    Left = 183
    Top = 31
    EditValue = 45658d
    Properties.ShowTime = False
    TabOrder = 5
    Width = 80
  end
  object cbIsComplete_yes: TcxCheckBox [6]
    Left = 8
    Top = 108
    Caption = #1048#1079#1084#1077#1085#1080#1103' '#1074' '#1089#1090#1072#1090#1091#1089' '#1055#1088#1086#1074#1077#1076#1077#1085
    State = cbsChecked
    TabOrder = 6
    Width = 233
  end
  object cxLabel3: TcxLabel [7]
    Left = 8
    Top = 82
    Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072' ('#1076#1086#1082#1091#1084#1077#1085#1090'):'
  end
  object edEndDate_mov: TcxDateEdit [8]
    Left = 183
    Top = 81
    EditValue = 45658d
    Properties.ShowTime = False
    TabOrder = 8
    Width = 80
  end
  object edStartDate_mov: TcxDateEdit [9]
    Left = 184
    Top = 58
    EditValue = 45658d
    Properties.ShowTime = False
    TabOrder = 9
    Width = 80
  end
  object cxLabel4: TcxLabel [10]
    Left = 8
    Top = 59
    Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072' ('#1076#1086#1082#1091#1084#1077#1085#1090'):'
  end
  object cbIsComplete_from: TcxCheckBox [11]
    Left = 8
    Top = 133
    Caption = #1048#1079#1084#1077#1085#1080#1103' '#1089#1086' '#1089#1090#1072#1090#1091#1089#1072' '#1055#1088#1086#1074#1077#1076#1077#1085
    State = cbsChecked
    TabOrder = 11
    Width = 233
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 224
    Top = 103
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = cbIsComplete_yes
        Properties.Strings = (
          'Checked')
      end
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end>
    Left = 61
    Top = 132
  end
  inherited ActionList: TActionList
    Left = 212
    Top = 150
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate_mov'
        Value = Null
        Component = edStartDate_mov
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate_mov'
        Value = Null
        Component = edEndDate_mov
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsComplete_yes'
        Value = Null
        Component = cbIsComplete_yes
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsComplete_from'
        Value = Null
        Component = cbIsComplete_from
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 29
    Top = 132
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 248
    Top = 15
  end
end
