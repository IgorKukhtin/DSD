inherited LikiDniproReceiptDialogForm: TLikiDniproReceiptDialogForm
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #1042#1099#1073#1086#1088' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074' '#1088#1077#1094#1077#1087#1090#1072
  ClientHeight = 263
  ClientWidth = 526
  Position = poScreenCenter
  AddOnFormData.RefreshAction = nil
  ExplicitWidth = 532
  ExplicitHeight = 292
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel [0]
    Left = 0
    Top = 0
    Width = 526
    Height = 90
    Align = alTop
    ShowCaption = False
    TabOrder = 0
    object Label3: TLabel
      Left = 25
      Top = 43
      Width = 89
      Height = 13
      Caption = #1042#1080#1076' '#1089#1086#1094'.'#1087#1088#1086#1077#1082#1090#1072':'
    end
    object Label4: TLabel
      Left = 388
      Top = 43
      Width = 42
      Height = 13
      Caption = #1057#1082#1080#1076#1082#1072':'
    end
    object Label5: TLabel
      Left = 25
      Top = 66
      Width = 58
      Height = 13
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103':'
    end
    object cxLabel13: TcxLabel
      Left = 203
      Top = 1
      Caption = #1044#1072#1090#1072' '#1088#1077#1094#1077#1087#1090#1072
    end
    object cxLabel14: TcxLabel
      Left = 24
      Top = 1
      Caption = #1053#1086#1084#1077#1088' '#1088#1077#1094#1077#1087#1090#1072
    end
    object edRecipe_Number: TcxTextEdit
      Left = 24
      Top = 18
      TabStop = False
      Enabled = False
      Properties.ReadOnly = True
      StyleDisabled.TextColor = clWindowText
      TabOrder = 2
      Width = 170
    end
    object edCreated: TcxDateEdit
      Left = 203
      Top = 18
      TabStop = False
      EditValue = 42261d
      Enabled = False
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      StyleDisabled.TextColor = clWindowText
      TabOrder = 3
      Width = 90
    end
    object edSPKind: TcxButtonEdit
      Left = 124
      Top = 40
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1044#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1052#1077#1076#1080#1094#1080#1085#1089#1082#1086#1075#1086' '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1103' '#1085#1072#1078#1084#1080#1090#1077' [Ctrl+Enter]>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      Style.Color = clWindow
      StyleDisabled.Color = clWindow
      StyleDisabled.TextColor = clWindowText
      TabOrder = 4
      Width = 250
    end
    object edValid_From: TcxDateEdit
      Left = 301
      Top = 18
      TabStop = False
      EditValue = 42261d
      Enabled = False
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      StyleDisabled.TextColor = clWindowText
      TabOrder = 5
      Width = 90
    end
    object cxLabel1: TcxLabel
      Left = 301
      Top = 1
      Caption = #1044#1072#1090#1072' '#1074#1099#1087#1080#1089#1082#1080' '
    end
    object edValid_To: TcxDateEdit
      Left = 405
      Top = 18
      TabStop = False
      EditValue = 42261d
      Enabled = False
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      StyleDisabled.TextColor = clWindowText
      TabOrder = 7
      Width = 90
    end
    object cxLabel2: TcxLabel
      Left = 405
      Top = 1
      Caption = #1057#1088#1086#1082' '#1076#1077#1081#1089#1090#1074#1080#1103
    end
    object edDiscount_Percent: TcxTextEdit
      Left = 437
      Top = 40
      TabStop = False
      Enabled = False
      Properties.ReadOnly = True
      StyleDisabled.TextColor = clWindowText
      TabOrder = 9
      Width = 58
    end
    object edCategory1303: TcxButtonEdit
      Left = 124
      Top = 63
      Enabled = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.UseNullString = True
      StyleDisabled.Color = clWindow
      StyleDisabled.TextColor = clWindowText
      TabOrder = 10
      Width = 371
    end
  end
  object Panel2: TPanel [1]
    Left = 0
    Top = 90
    Width = 526
    Height = 131
    Align = alClient
    ShowCaption = False
    TabOrder = 1
    object Label1: TLabel
      Left = 25
      Top = 10
      Width = 138
      Height = 13
      Caption = #1052#1077#1076#1080#1094#1080#1085#1089#1082#1086#1077' '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1077':'
    end
    object Label2: TLabel
      Left = 25
      Top = 72
      Width = 56
      Height = 13
      Caption = #1060#1048#1054' '#1074#1088#1072#1095#1072
    end
    object cePartnerMedical: TcxButtonEdit
      Left = 25
      Top = 45
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1044#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1052#1077#1076#1080#1094#1080#1085#1089#1082#1086#1075#1086' '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1103' '#1085#1072#1078#1084#1080#1090#1077' [Ctrl+Enter]>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 0
      Text = '<'#1044#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1052#1077#1076#1080#1094#1080#1085#1089#1082#1086#1075#1086' '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1103' '#1085#1072#1078#1084#1080#1090#1077' [Ctrl+Enter]>'
      Width = 470
    end
    object cxLabel22: TcxLabel
      Left = 263
      Top = 68
      Caption = #1060#1048#1054' '#1087#1072#1094#1080#1077#1085#1090#1072
    end
    object edInstitution_Name: TcxTextEdit
      Left = 25
      Top = 23
      TabStop = False
      Enabled = False
      Properties.ReadOnly = True
      Style.BorderStyle = ebsNone
      StyleDisabled.BorderStyle = ebsNone
      StyleDisabled.Color = clBtnFace
      StyleDisabled.TextColor = clHotLight
      TabOrder = 2
      Width = 470
    end
    object edMedicKashtan: TcxButtonEdit
      Left = 25
      Top = 91
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 3
      Text = '<'#1044#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1060#1048#1054' '#1074#1088#1072#1095#1072' '#1085#1072#1078#1084#1080#1090#1077' [Ctrl+Enter]>'
      Width = 232
    end
    object edMemberKashtan: TcxButtonEdit
      Left = 263
      Top = 91
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 4
      Text = '<'#1044#1083#1103' '#1074#1099#1073#1086#1088#1072' '#1060#1048#1054' '#1087#1072#1094#1080#1077#1085#1090#1072' '#1085#1072#1078#1084#1080#1090#1077' [Ctrl+Enter]>'
      Width = 232
    end
  end
  object Panel4: TPanel [2]
    Left = 0
    Top = 221
    Width = 526
    Height = 42
    Align = alBottom
    ShowCaption = False
    TabOrder = 2
    object bbCancel: TcxButton
      Left = 308
      Top = 8
      Width = 75
      Height = 25
      Caption = #1054#1090#1084#1077#1085#1072
      ModalResult = 2
      TabOrder = 1
    end
    object bbOk: TcxButton
      Left = 134
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Ok'
      Default = True
      TabOrder = 0
      OnClick = bbOkClick
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 459
    Top = 64
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 368
    Top = 72
  end
  inherited ActionList: TActionList
    Left = 39
    Top = 87
    object actFormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actFormClose'
      ShortCut = 27
    end
  end
  object GuidesPartnerMedical: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePartnerMedical
    FormNameParam.Value = 'TPartnerMedical_SPKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartnerMedical_SPKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPartnerMedical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPartnerMedical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 104
    Top = 128
  end
  object GuidesMedicKashtan: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMedicKashtan
    Key = '0'
    FormNameParam.Value = 'TMedicKashtanForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMedicKashtanForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMedicKashtan
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMedicKashtan
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPartnerMedicalId'
        Value = ''
        Component = GuidesPartnerMedical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPartnerMedicalName'
        Value = ''
        Component = GuidesPartnerMedical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerMedicalId'
        Value = Null
        Component = GuidesPartnerMedical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerMedicalName'
        Value = Null
        Component = GuidesPartnerMedical
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterOperDate'
        Value = Null
        Component = edCreated
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitId'
        Value = Null
        ComponentItem = 'MasterUnitId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterUnitName'
        Value = Null
        ComponentItem = 'MasterUnitName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterSPKindId'
        Value = Null
        Component = GuidesSPKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterSPKindName'
        Value = Null
        Component = GuidesSPKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 128
    Top = 176
  end
  object GuidesSPKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edSPKind
    DisableGuidesOpen = True
    FormNameParam.Value = 'TSPKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TSPKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesSPKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesSPKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Tax'
        Value = Null
        ComponentItem = 'SPTax'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 25
  end
  object spGet_SPKind: TdsdStoredProc
    StoredProcName = 'gpGet_Object_SPKind_1303'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = GuidesSPKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = Null
        Component = GuidesSPKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 224
    Top = 113
  end
  object GuidesMemberKashtan: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMemberKashtan
    FormNameParam.Value = 'TMemberKashtanForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMemberKashtanForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMemberKashtan
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMemberKashtan
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
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPartnerMedicalId'
        Value = ''
        Component = GuidesPartnerMedical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MasterPartnerMedicalName'
        Value = ''
        Component = GuidesPartnerMedical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Address'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Passport'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Inn'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 416
    Top = 184
  end
  object spSelect_SearchData: TdsdStoredProc
    StoredProcName = 'gpSelect_SearchData_SPKind_Kashtan'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inInstitution_Id'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInstitution_Edrpou'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDoctor_Id'
        Value = ''
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDoctor_Name'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPatient_Id'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPatient_Name'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCategory1303_Id'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCategory1303_Name'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPartnerMedicalId'
        Value = Null
        Component = GuidesPartnerMedical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPartnerMedicalName'
        Value = Null
        Component = GuidesPartnerMedical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMedicKashtanId'
        Value = Null
        Component = GuidesMedicKashtan
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMedicKashtanName'
        Value = Null
        Component = GuidesMedicKashtan
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMemberKashtanId'
        Value = Null
        Component = GuidesMemberKashtan
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMemberKashtanName'
        Value = Null
        Component = GuidesMemberKashtan
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCategory1303Id'
        Value = Null
        Component = GuidesCategory1303
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCategory1303Name'
        Value = Null
        Component = GuidesCategory1303
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 296
    Top = 96
  end
  object spGet_Movement_InvNumberSP: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_InvNumberSP'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inSPKindId'
        Value = Null
        Component = GuidesSPKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumberSP'
        Value = ''
        Component = edRecipe_Number
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
    Left = 432
    Top = 112
  end
  object GuidesCategory1303: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCategory1303
    DisableGuidesOpen = True
    FormNameParam.Value = 'TCategory1303Form'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCategory1303Form'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCategory1303
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCategory1303
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Tax'
        Value = Null
        ComponentItem = 'SPTax'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 240
    Top = 49
  end
end
