object Report_ProfitDialogForm: TReport_ProfitDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1044#1086#1093#1086#1076#1085#1086#1089#1090#1080'>'
  ClientHeight = 290
  ClientWidth = 392
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
    Left = 70
    Top = 257
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 244
    Top = 257
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 272
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
    Left = 217
    Top = 29
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object cxLabel3: TcxLabel
    Left = 8
    Top = 65
    Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082' 1:'
  end
  object cxLabel5: TcxLabel
    Left = 8
    Top = 93
    Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082' 2:'
  end
  object ceJuridical1: TcxButtonEdit
    Left = 82
    Top = 64
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
    Width = 280
  end
  object ceJuridical2: TcxButtonEdit
    Left = 82
    Top = 92
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
    Width = 280
  end
  object cxLabel1: TcxLabel
    Left = 8
    Top = 126
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
  end
  object edUnit: TcxButtonEdit
    Left = 8
    Top = 144
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 354
  end
  object cxLabel2: TcxLabel
    Left = 8
    Top = 179
    Caption = #1070#1088'. '#1083#1080#1094#1086' ('#1085#1072#1096#1077'):'
  end
  object edJuridical: TcxButtonEdit
    Left = 104
    Top = 178
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 258
  end
  object ceMonth: TcxCurrencyEdit
    Left = 244
    Top = 217
    Properties.DecimalPlaces = 2
    Properties.DisplayFormat = ',0.'
    TabOrder = 14
    Width = 92
  end
  object cxLabel9: TcxLabel
    Left = 8
    Top = 218
    Caption = #1055#1086#1082#1072#1079#1099#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1088#1086#1096#1083#1086#1075#1086' '#1087#1077#1088#1080#1086#1076#1072', '#1084#1077#1089'.'
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 320
    Top = 112
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 215
    Top = 54
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
    Left = 56
    Top = 52
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = 41579d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = 41608d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Juridical1Id'
        Value = ''
        Component = Juridical1Guides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Juridical1Name'
        Value = ''
        Component = Juridical1Guides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Juridical2Id'
        Value = Null
        Component = Juridical2Guides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Juridical2Name'
        Value = Null
        Component = Juridical2Guides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalOurId'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalOurName'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Month'
        Value = Null
        Component = ceMonth
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 343
    Top = 30
  end
  object Juridical1Guides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridical1
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Juridical1Guides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Juridical1Guides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 48
  end
  object Juridical2Guides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridical2
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = Juridical2Guides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = Juridical2Guides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 144
    Top = 80
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 130
  end
  object GuidesJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridicalCorporateForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridicalCorporateForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 138
  end
end
