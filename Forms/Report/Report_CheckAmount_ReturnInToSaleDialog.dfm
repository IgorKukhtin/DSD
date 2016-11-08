object Report_CheckAmount_ReturnInToSaleDialogForm: TReport_CheckAmount_ReturnInToSaleDialogForm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 
    #1055#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072' <'#1055#1088#1086#1074#1077#1088#1082#1072' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1072' '#1074' '#1087#1088#1080#1074#1103#1079#1082#1077' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1082' '#1087#1088#1086#1076 +
    #1072#1078#1072#1084'>'
  ClientHeight = 226
  ClientWidth = 478
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
    Left = 114
    Top = 189
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 288
    Top = 189
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object deEnd: TcxDateEdit
    Left = 62
    Top = 56
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 2
    Width = 90
  end
  object deStart: TcxDateEdit
    Left = 62
    Top = 19
    EditValue = 42005d
    Properties.ShowTime = False
    TabOrder = 3
    Width = 90
  end
  object cxLabel6: TcxLabel
    Left = 8
    Top = 20
    Caption = #1044#1072#1090#1072' '#1089' :'
  end
  object cxLabel7: TcxLabel
    Left = 8
    Top = 56
    Caption = #1044#1072#1090#1072' '#1087#1086' :'
  end
  object cxLabel3: TcxLabel
    Left = 8
    Top = 146
    Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
  end
  object edPartner: TcxButtonEdit
    Left = 78
    Top = 144
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 7
    Width = 379
  end
  object cxLabel13: TcxLabel
    Left = 8
    Top = 100
    Caption = #1070#1088'. '#1083#1080#1094#1086':'
  end
  object edJuridical: TcxButtonEdit
    Left = 62
    Top = 99
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 9
    Width = 395
  end
  object cbOnlyError: TcxCheckBox
    Left = 205
    Top = 56
    Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1090#1086#1083#1100#1082#1086' '#1086#1096#1080#1073#1082#1080' ('#1076#1072'/'#1085#1077#1090')'
    TabOrder = 10
    Width = 218
  end
  object cxLabel5: TcxLabel
    Left = 205
    Top = 1
    Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
  end
  object edInvNumber: TcxTextEdit
    Left = 205
    Top = 19
    Properties.ReadOnly = True
    TabOrder = 12
    Text = ' '
    Width = 114
  end
  object edOperDate: TcxDateEdit
    Left = 345
    Top = 19
    EditValue = 42132d
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 13
    Width = 100
  end
  object cxLabel4: TcxLabel
    Left = 345
    Top = 1
    Caption = #1044#1072#1090#1072' ('#1089#1082#1083#1072#1076')'
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 424
    Top = 16
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 336
    Top = 16
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
    Left = 216
    Top = 20
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
        Name = 'PartnerId'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inJuridicalId'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOnlyError'
        Value = Null
        Component = cbOnlyError
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = Null
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 'NULL'
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 40
    Top = 152
  end
  object GuidesPartner: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartner
    FormNameParam.Value = 'TPartner_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartner_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalId'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterJuridicalName'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 141
    Top = 144
  end
  object GuidesJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 73
  end
end
