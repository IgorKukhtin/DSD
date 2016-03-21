object Report_PriceInterventionDialogForm: TReport_PriceInterventionDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1062#1077#1085#1086#1074#1072#1103' '#1080#1085#1090#1077#1088#1074#1077#1085#1094#1080#1103'>'
  ClientHeight = 294
  ClientWidth = 438
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
    Left = 102
    Top = 257
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 276
    Top = 257
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 241
    Top = 28
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 90
  end
  object deStart: TcxDateEdit
    Left = 82
    Top = 28
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 90
  end
  object cxLabel6: TcxLabel
    Left = 31
    Top = 29
    Caption = #1044#1072#1090#1072' '#1089' :'
  end
  object cxLabel7: TcxLabel
    Left = 186
    Top = 29
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object cxLabel3: TcxLabel
    Left = 8
    Top = 261
    Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082' 1:'
    Visible = False
  end
  object cxLabel5: TcxLabel
    Left = 8
    Top = 238
    Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082' 2:'
    Visible = False
  end
  object ceJuridical1: TcxButtonEdit
    Left = 33
    Top = 238
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
    Properties.ReadOnly = True
    Properties.UseNullString = True
    TabOrder = 8
    Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
    TextHint = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
    Visible = False
    Width = 49
  end
  object ceJuridical2: TcxButtonEdit
    Left = 43
    Top = 261
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
    Properties.ReadOnly = True
    Properties.UseNullString = True
    TabOrder = 9
    Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
    TextHint = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
    Visible = False
    Width = 39
  end
  object cePrice1: TcxCurrencyEdit
    Left = 240
    Top = 64
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 10
    Width = 142
  end
  object cxLabel4: TcxLabel
    Left = 31
    Top = 65
    Caption = #1055#1088#1077#1076#1077#1083' '#1087#1088#1086#1084#1077#1078#1091#1090#1082#1072' 1 ('#1074' '#1094#1077#1085#1077' '#1079#1072#1082#1091#1087#1082#1080')'
  end
  object cePrice2: TcxCurrencyEdit
    Left = 240
    Top = 94
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 12
    Width = 142
  end
  object cxLabel8: TcxLabel
    Left = 30
    Top = 95
    Caption = #1055#1088#1077#1076#1077#1083' '#1087#1088#1086#1084#1077#1078#1091#1090#1082#1072' 2 ('#1074' '#1094#1077#1085#1077' '#1079#1072#1082#1091#1087#1082#1080')'
  end
  object cePrice3: TcxCurrencyEdit
    Left = 240
    Top = 124
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 14
    Width = 142
  end
  object cxLabel9: TcxLabel
    Left = 31
    Top = 125
    Caption = #1055#1088#1077#1076#1077#1083' '#1087#1088#1086#1084#1077#1078#1091#1090#1082#1072' 3 ('#1074' '#1094#1077#1085#1077' '#1079#1072#1082#1091#1087#1082#1080')'
  end
  object cePrice4: TcxCurrencyEdit
    Left = 240
    Top = 154
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 16
    Width = 142
  end
  object cxLabel10: TcxLabel
    Left = 31
    Top = 155
    Caption = #1055#1088#1077#1076#1077#1083' '#1087#1088#1086#1084#1077#1078#1091#1090#1082#1072' 4 ('#1074' '#1094#1077#1085#1077' '#1079#1072#1082#1091#1087#1082#1080')'
  end
  object cePrice5: TcxCurrencyEdit
    Left = 240
    Top = 184
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 18
    Width = 142
  end
  object cxLabel11: TcxLabel
    Left = 31
    Top = 185
    Caption = #1055#1088#1077#1076#1077#1083' '#1087#1088#1086#1084#1077#1078#1091#1090#1082#1072' 5 ('#1074' '#1094#1077#1085#1077' '#1079#1072#1082#1091#1087#1082#1080')'
  end
  object cePrice6: TcxCurrencyEdit
    Left = 240
    Top = 214
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 20
    Width = 142
  end
  object cxLabel12: TcxLabel
    Left = 31
    Top = 215
    Caption = #1055#1088#1077#1076#1077#1083' '#1087#1088#1086#1084#1077#1078#1091#1090#1082#1072' 6 ('#1074' '#1094#1077#1085#1077' '#1079#1072#1082#1091#1087#1082#1080')'
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 392
    Top = 88
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 380
    Top = 9
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
    Left = 392
    Top = 132
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
      end
      item
        Name = 'Price1'
        Value = Null
        Component = cePrice1
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'Price2'
        Value = Null
        Component = cePrice2
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'Price3'
        Value = Null
        Component = cePrice3
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'Price4'
        Value = Null
        Component = cePrice4
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'Price5'
        Value = Null
        Component = cePrice5
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'Price6'
        Value = Null
        Component = cePrice6
        DataType = ftFloat
        ParamType = ptInput
      end>
    Left = 399
    Top = 38
  end
  object Juridical1Guides: TdsdGuides
    KeyField = 'Id'
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Juridical1Guides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Juridical1Guides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 16
    Top = 240
  end
  object Juridical2Guides: TdsdGuides
    KeyField = 'Id'
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Juridical2Guides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Juridical2Guides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 8
    Top = 264
  end
end
