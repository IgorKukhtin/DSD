inherited SPDialogForm: TSPDialogForm
  ActiveControl = cePartnerMedical
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1042#1099#1073#1086#1088' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074' - '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090
  ClientHeight = 166
  ClientWidth = 571
  Position = poDesktopCenter
  ExplicitWidth = 577
  ExplicitHeight = 191
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel [0]
    Left = 16
    Top = 8
    Width = 138
    Height = 13
    Caption = #1052#1077#1076#1080#1094#1080#1085#1089#1082#1086#1077' '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1077':'
  end
  object Label2: TLabel [1]
    Left = 25
    Top = 58
    Width = 56
    Height = 13
    Caption = #1060#1048#1054' '#1074#1088#1072#1095#1072
  end
  object Label3: TLabel [2]
    Left = 297
    Top = 8
    Width = 89
    Height = 13
    Caption = #1042#1080#1076' '#1089#1086#1094'.'#1087#1088#1086#1077#1082#1090#1072':'
  end
  inherited bbOk: TcxButton
    Left = 190
    Top = 123
    ModalResult = 0
    OnClick = bbOkClick
    ExplicitLeft = 190
    ExplicitTop = 123
  end
  inherited bbCancel: TcxButton
    Left = 311
    Top = 123
    ExplicitLeft = 311
    ExplicitTop = 123
  end
  object cePartnerMedical: TcxButtonEdit [5]
    Left = 16
    Top = 27
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.Nullstring = '<'#1044#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1052#1077#1076#1080#1094#1080#1085#1089#1082#1086#1075#1086' '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1103' '#1085#1072#1078#1084#1080#1090#1077' [Ctrl+Enter]>'
    Properties.ReadOnly = True
    Properties.UseNullString = True
    TabOrder = 2
    Text = '<'#1044#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1052#1077#1076#1080#1094#1080#1085#1089#1082#1086#1075#1086' '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1103' '#1085#1072#1078#1084#1080#1090#1077' [Ctrl+Enter]>'
    Width = 265
  end
  object cxLabel13: TcxLabel [6]
    Left = 433
    Top = 54
    Caption = #1044#1072#1090#1072' '#1088#1077#1094#1077#1087#1090#1072
  end
  object edOperDateSP: TcxDateEdit [7]
    Left = 433
    Top = 74
    EditValue = 42261d
    Properties.ReadOnly = False
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 4
    Width = 90
  end
  object cxLabel14: TcxLabel [8]
    Left = 297
    Top = 56
    Caption = #1053#1086#1084#1077#1088' '#1088#1077#1094#1077#1087#1090#1072
  end
  object edInvNumberSP: TcxTextEdit [9]
    Left = 297
    Top = 74
    Properties.ReadOnly = False
    TabOrder = 6
    Width = 116
  end
  object cxLabel17: TcxLabel [10]
    Left = 406
    Top = 4
    Caption = #8470' '#1072#1084#1073#1091#1083#1072#1090#1086#1088#1080#1080' '
    Visible = False
  end
  object edAmbulance: TcxTextEdit [11]
    Left = 447
    Top = 0
    Properties.ReadOnly = False
    TabOrder = 8
    Visible = False
    Width = 116
  end
  object edMedicSP: TcxButtonEdit [12]
    Left = 16
    Top = 74
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    Properties.UseNullString = True
    TabOrder = 9
    Text = '<'#1044#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1060#1048#1054' '#1074#1088#1072#1095#1072' '#1085#1072#1078#1084#1080#1090#1077' [Ctrl+Enter]>'
    Width = 265
  end
  object edSPKind: TcxButtonEdit [13]
    Left = 297
    Top = 27
    ParentColor = True
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.Nullstring = '<'#1044#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1052#1077#1076#1080#1094#1080#1085#1089#1082#1086#1075#1086' '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1103' '#1085#1072#1078#1084#1080#1090#1077' [Ctrl+Enter]>'
    Properties.ReadOnly = True
    Properties.UseNullString = True
    TabOrder = 10
    Text = '<'#1044#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1042#1080#1076#1072' '#1089#1086#1094'.'#1087#1088#1086#1077#1082#1090#1072' '#1085#1072#1078#1084#1080#1090#1077' [Ctrl+Enter]>'
    Width = 266
  end
  object bbSP_Prior: TcxButton [14]
    Left = 35
    Top = 123
    Width = 97
    Height = 25
    Caption = #1040#1074#1090#1086#1079#1072#1087#1086#1083#1085#1080#1090#1100
    TabOrder = 11
    OnClick = bbSP_PriorClick
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Top = 80
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 8
    Top = 80
  end
  inherited ActionList: TActionList
    Top = 79
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'SPTax'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 104
    Top = 80
  end
  object PartnerMedicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePartnerMedical
    FormNameParam.Value = 'TPartnerMedicalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartnerMedicalForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PartnerMedicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PartnerMedicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MedicSPId'
        Value = '0'
        Component = MedicSPGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MedicSPName'
        Value = ''
        Component = MedicSPGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 120
    Top = 16
  end
  object MedicSPGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMedicSP
    Key = '0'
    FormNameParam.Value = 'TMedicSPForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMedicSPForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = MedicSPGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MedicSPGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPartnerMedicalId'
        Value = ''
        Component = PartnerMedicalGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPartnerMedicalName'
        Value = ''
        Component = PartnerMedicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerMedicalId'
        Value = Null
        Component = PartnerMedicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerMedicalName'
        Value = Null
        Component = PartnerMedicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 232
    Top = 48
  end
  object SPKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edSPKind
    FormNameParam.Value = 'TSPKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TSPKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = SPKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = SPKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Tax'
        Value = Null
        Component = FormParams
        ComponentItem = 'SPTax'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 520
    Top = 80
  end
  object spGet_SPKind_def: TdsdStoredProc
    StoredProcName = 'gpGet_Object_SPKind_def'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = SPKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = Null
        Component = SPKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Tax'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 472
    Top = 104
  end
  object spGet_SP_Prior: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Check_SP_Prior'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'outPartnerMedicalId'
        Value = ''
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPartnerMedicalName'
        Value = ''
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMedicSPId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMedicSPName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 152
    Top = 96
  end
end
