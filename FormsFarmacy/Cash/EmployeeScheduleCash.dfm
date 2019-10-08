inherited EmployeeScheduleCashForm: TEmployeeScheduleCashForm
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1042#1074#1086#1076' '#1074#1088#1077#1084#1077#1085#1080' '#1087#1088#1080#1093#1086#1076#1072' '#1080' '#1091#1093#1086#1076#1072
  ClientHeight = 135
  ClientWidth = 631
  Position = poScreenCenter
  ExplicitWidth = 637
  ExplicitHeight = 164
  PixelsPerInch = 96
  TextHeight = 13
  inherited bbCancel: TcxButton [0]
    Left = 393
    Top = 88
    TabOrder = 0
    ExplicitLeft = 393
    ExplicitTop = 88
  end
  inherited bbOk: TcxButton [1]
    Left = 104
    Top = 88
    ModalResult = 0
    TabOrder = 1
    OnClick = bbOkClick
    ExplicitLeft = 104
    ExplicitTop = 88
  end
  object cbEndHour: TcxComboBox [2]
    Left = 371
    Top = 57
    Properties.Items.Strings = (
      ''
      '0'
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12'
      '13'
      '14'
      '15'
      '16'
      '17'
      '18'
      '19'
      '20'
      '21'
      '22'
      '23')
    TabOrder = 2
    Width = 54
  end
  object cbEndMin: TcxComboBox [3]
    Left = 438
    Top = 57
    Properties.Items.Strings = (
      ''
      '00'
      '30')
    TabOrder = 3
    Width = 54
  end
  object cbServiceExit: TcxCheckBox [4]
    Left = 26
    Top = 53
    Hint = #1057#1083#1091#1078#1077#1073#1085#1099#1081' '#1074#1099#1093#1086#1076' ('#1074#1088#1077#1084#1103' '#1087#1088#1080#1093#1086#1076#1072' '#1080' '#1091#1093#1086#1076#1072' '#1085#1077' '#1079#1072#1087#1086#1083#1085#1103#1090#1100')'
    Caption = #1057#1083#1091#1078#1077#1073#1085#1099#1081' '#1074#1099#1093#1086#1076
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
  end
  object cbStartHour: TcxComboBox [5]
    Left = 371
    Top = 26
    Properties.Items.Strings = (
      ''
      '0'
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '10'
      '11'
      '12'
      '13'
      '14'
      '15'
      '16'
      '17'
      '18'
      '19'
      '20'
      '21'
      '22'
      '23')
    TabOrder = 5
    Width = 54
  end
  object cbStartMin: TcxComboBox [6]
    Left = 438
    Top = 26
    Properties.Items.Strings = (
      ''
      '00'
      '30')
    TabOrder = 6
    Width = 54
  end
  object cxLabel2: TcxLabel [7]
    Left = 26
    Top = 26
    Caption = #1057#1077#1075#1086#1076#1085#1103
  end
  object cxLabel3: TcxLabel [8]
    Left = 206
    Top = 26
    Caption = #1042#1088#1077#1084#1103' '#1092#1072#1082#1090#1080#1095#1077#1089#1082#1086#1075#1086' '#1087#1088#1080#1093#1086#1076#1072':'
  end
  object cxLabel4: TcxLabel [9]
    Left = 206
    Top = 57
    Caption = #1042#1088#1077#1084#1103' '#1092#1072#1082#1090#1080#1095#1077#1089#1082#1086#1075#1086' '#1091#1093#1086#1076#1072':'
  end
  object cxLabel5: TcxLabel [10]
    Left = 206
    Top = 7
    Caption = 
      #1042#1088#1077#1084#1103' '#1092#1072#1082#1090#1080#1095#1077#1089#1082#1086#1075#1086' '#1087#1088#1080#1093#1086#1076#1072' '#1080' '#1091#1093#1086#1076#1072'  '#1074#1074#1086#1076#1080#1090#1089#1103' '#1082#1088#1072#1090#1085#1086' 30 '#1084#1080#1085'. '#1074' '#1074#1080 +
      #1076#1077' '#1063#1063':MM'
  end
  object cxLabel6: TcxLabel [11]
    Left = 425
    Top = 27
    Caption = ' : '
  end
  object cxLabel7: TcxLabel [12]
    Left = 425
    Top = 58
    Caption = ' : '
  end
  object edOperDate: TcxDateEdit [13]
    Left = 79
    Top = 25
    TabStop = False
    EditValue = 42132d
    Properties.DisplayFormat = 'dd.mm.yyyy'
    Properties.EditFormat = 'dd.mm.yyyy'
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 100
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 219
    Top = 80
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 536
    Top = 88
  end
  inherited ActionList: TActionList
    Left = 327
    Top = 79
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'PromoCodeGUID'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoCodeID'
        Value = 0
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'BayerName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PromoCodeChangePercent'
        Value = 0c
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 544
    Top = 24
  end
end
