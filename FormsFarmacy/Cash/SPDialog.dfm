inherited SPDialogForm: TSPDialogForm
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1042#1099#1073#1086#1088' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074' - '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090
  ClientHeight = 227
  ClientWidth = 577
  Position = poScreenCenter
  ExplicitWidth = 583
  ExplicitHeight = 256
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel [0]
    Left = 0
    Top = 0
    Width = 577
    Height = 103
    Align = alClient
    ShowCaption = False
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 8
      Width = 138
      Height = 13
      Caption = #1052#1077#1076#1080#1094#1080#1085#1089#1082#1086#1077' '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1077':'
    end
    object Label2: TLabel
      Left = 25
      Top = 58
      Width = 56
      Height = 13
      Caption = #1060#1048#1054' '#1074#1088#1072#1095#1072
    end
    object Label3: TLabel
      Left = 297
      Top = 8
      Width = 89
      Height = 13
      Caption = #1042#1080#1076' '#1089#1086#1094'.'#1087#1088#1086#1077#1082#1090#1072':'
    end
    object cePartnerMedical: TcxButtonEdit
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
      Properties.OnChange = cePartnerMedicalPropertiesChange
      TabOrder = 0
      Text = '<'#1044#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1052#1077#1076#1080#1094#1080#1085#1089#1082#1086#1075#1086' '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1103' '#1085#1072#1078#1084#1080#1090#1077' [Ctrl+Enter]>'
      Width = 265
    end
    object cxLabel13: TcxLabel
      Left = 473
      Top = 54
      Caption = #1044#1072#1090#1072' '#1088#1077#1094#1077#1087#1090#1072
    end
    object cxLabel14: TcxLabel
      Left = 297
      Top = 56
      Caption = #1053#1086#1084#1077#1088' '#1088#1077#1094#1077#1087#1090#1072
    end
    object cxLabel17: TcxLabel
      Left = 406
      Top = 4
      Caption = #8470' '#1072#1084#1073#1091#1083#1072#1090#1086#1088#1080#1080' '
      Visible = False
    end
    object edAmbulance: TcxTextEdit
      Left = 447
      Top = 0
      Properties.ReadOnly = False
      TabOrder = 4
      Visible = False
      Width = 116
    end
    object edInvNumberSP: TcxTextEdit
      Left = 297
      Top = 76
      Properties.ReadOnly = False
      TabOrder = 5
      Width = 170
    end
    object edMedicSP: TcxButtonEdit
      Left = 16
      Top = 76
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 6
      Text = '<'#1044#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1060#1048#1054' '#1074#1088#1072#1095#1072' '#1085#1072#1078#1084#1080#1090#1077' [Ctrl+Enter]>'
      Width = 265
    end
    object edOperDateSP: TcxDateEdit
      Left = 473
      Top = 76
      EditValue = 42261d
      Properties.ReadOnly = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 7
      Width = 90
    end
    object edSPKind: TcxButtonEdit
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
      Properties.OnChange = edSPKindPropertiesChange
      TabOrder = 8
      Text = '<'#1044#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1042#1080#1076#1072' '#1089#1086#1094'.'#1087#1088#1086#1077#1082#1090#1072' '#1085#1072#1078#1084#1080#1090#1077' [Ctrl+Enter]>'
      Width = 266
    end
  end
  object Panel2: TPanel [1]
    Left = 0
    Top = 103
    Width = 577
    Height = 124
    Align = alBottom
    ShowCaption = False
    TabOrder = 1
    object cxLabel22: TcxLabel
      Left = 16
      Top = 1
      Caption = #1060#1048#1054' '#1087#1072#1094#1080#1077#1085#1090#1072
    end
    object cxLabel23: TcxLabel
      Left = 249
      Top = 1
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1087#1072#1094'-'#1090#1072
    end
    object cxLabel24: TcxLabel
      Left = 352
      Top = 1
      Caption = #1053#1086#1084#1077#1088'/'#1089#1077#1088#1080#1103' '#1087#1072#1089#1087#1086#1088#1090#1072' '#1087#1072#1094'-'#1090#1072
    end
    object cxLabel25: TcxLabel
      Left = 16
      Top = 40
      Caption = #1048#1053#1053' '#1087#1072#1094#1080#1077#1085#1090#1072
    end
    object cxLabel26: TcxLabel
      Left = 117
      Top = 40
      Caption = #1040#1076#1088#1077#1089' '#1087#1072#1094#1080#1077#1085#1090#1072
    end
    object edMemberSP: TcxButtonEdit
      Left = 16
      Top = 17
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 227
    end
    object edPassport: TcxTextEdit
      Left = 352
      Top = 17
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 211
    end
    object edInn: TcxTextEdit
      Left = 16
      Top = 58
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 95
    end
    object edAddress: TcxTextEdit
      Left = 117
      Top = 58
      Properties.ReadOnly = True
      TabOrder = 8
      Width = 446
    end
    object edGroupMemberSP: TcxTextEdit
      Left = 249
      Top = 17
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 95
    end
  end
  inherited bbCancel: TcxButton [2]
    Left = 494
    Top = 189
    Anchors = [akTop, akRight]
    TabOrder = 2
    ExplicitLeft = 494
    ExplicitTop = 189
  end
  inherited bbOk: TcxButton [3]
    Left = 378
    Top = 191
    Anchors = [akTop, akRight]
    ModalResult = 0
    TabOrder = 3
    OnClick = bbOkClick
    ExplicitLeft = 378
    ExplicitTop = 191
  end
  object bbSP_Prior: TcxButton [4]
    Left = 191
    Top = 191
    Width = 97
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #1040#1074#1090#1086#1079#1072#1087#1086#1083#1085#1080#1090#1100
    TabOrder = 4
    OnClick = bbSP_PriorClick
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 251
    Top = 72
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 8
    Top = 64
  end
  inherited ActionList: TActionList
    Left = 199
    Top = 63
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'SPTax'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 88
    Top = 56
  end
  object PartnerMedicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePartnerMedical
    FormNameParam.Value = 'TPartnerMedical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartnerMedical_ObjectForm'
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
      end
      item
        Name = 'MasterOperDate'
        Value = Null
        Component = edOperDateSP
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MasterUnitId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitName'
        Value = Null
        Component = FormParams
        ComponentItem = 'MasterUnitName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterSPKindId'
        Value = Null
        Component = SPKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterSPKindName'
        Value = Null
        Component = SPKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GuidesMemberSPId'
        Value = Null
        Component = GuidesMemberSP
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GuidesMemberSPName'
        Value = Null
        Component = GuidesMemberSP
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GroupMemberSP'
        Value = Null
        Component = edGroupMemberSP
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Passport'
        Value = Null
        Component = edPassport
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Inn'
        Value = Null
        Component = edInn
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'eAddress'
        Value = Null
        Component = edAddress
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
    FormNameParam.Value = 'TMedicSP_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMedicSP_ObjectForm'
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
      end
      item
        Name = 'MasterOperDate'
        Value = Null
        Component = edOperDateSP
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MasterUnitId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitName'
        Value = Null
        Component = FormParams
        ComponentItem = 'MasterUnitName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterSPKindId'
        Value = Null
        Component = SPKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterSPKindName'
        Value = Null
        Component = SPKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
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
    Left = 448
    Top = 32
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
      end
      item
        Name = 'outOperDateSP'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSPKindId'
        Value = Null
        Component = SPKindGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outSPKindName'
        Value = Null
        Component = SPKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMemberSPId'
        Value = Null
        Component = GuidesMemberSP
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMemberSPName'
        Value = Null
        Component = GuidesMemberSP
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outGroupMemberSP'
        Value = Null
        Component = edGroupMemberSP
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPassport'
        Value = Null
        Component = edPassport
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outInn'
        Value = Null
        Component = edInn
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAddress'
        Value = Null
        Component = edAddress
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 312
    Top = 168
  end
  object GuidesMemberSP: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMemberSP
    FormNameParam.Value = 'TMemberSPForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMemberSPForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMemberSP
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMemberSP
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GroupMemberSPId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GroupMemberSPName'
        Value = ''
        Component = edGroupMemberSP
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
        Name = 'Address'
        Value = ''
        Component = edAddress
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Passport'
        Value = ''
        Component = edPassport
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Inn'
        Value = ''
        Component = edInn
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 104
  end
  object spSelect_Object_MemberSP: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_MemberSP_Cash'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMemberSPId'
        Value = ''
        Component = GuidesMemberSP
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = ''
        Component = edMemberSP
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GroupMemberSPName'
        Value = Null
        Component = edGroupMemberSP
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Passport'
        Value = Null
        Component = edPassport
        MultiSelectSeparator = ','
      end
      item
        Name = 'INN'
        Value = Null
        Component = edInn
        MultiSelectSeparator = ','
      end
      item
        Name = 'Address'
        Value = Null
        Component = edAddress
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 368
    Top = 112
  end
  object spGet_Movement_InvNumberSP: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_InvNumberSP'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inSPKindId'
        Value = Null
        Component = SPKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumberSP'
        Value = ''
        Component = edInvNumberSP
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outIsExists'
        Value = ''
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 80
    Top = 168
  end
end
