object MemberSPEditForm: TMemberSPEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1080#1079#1084#1077#1085#1080#1090#1100' '#1060#1048#1054' '#1087#1072#1094#1080#1077#1085#1090#1072'('#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090')'
  ClientHeight = 354
  ClientWidth = 369
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.Params = dsdFormParams
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 40
    Top = 71
    TabOrder = 0
    Width = 296
  end
  object cxLabel1: TcxLabel
    Left = 40
    Top = 48
    Caption = #1060#1048#1054' '#1087#1072#1094#1080#1077#1085#1090#1072
  end
  object cxButton1: TcxButton
    Left = 71
    Top = 322
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 221
    Top = 322
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 8
    TabOrder = 3
  end
  object Код: TcxLabel
    Left = 40
    Top = 3
    Caption = #1050#1086#1076
  end
  object ceCode: TcxCurrencyEdit
    Left = 40
    Top = 26
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 177
  end
  object cxLabel10: TcxLabel
    Left = 40
    Top = 102
    Caption = #1052#1077#1076#1080#1094#1080#1085#1089#1082#1086#1077' '#1091#1095#1088#1077#1078#1076#1077#1085#1080#1077
  end
  object cePartnerMedical: TcxButtonEdit
    Left = 40
    Top = 122
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 296
  end
  object cxLabel2: TcxLabel
    Left = 40
    Top = 158
    Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103' '#1087#1072#1094#1080#1077#1085#1090#1072
  end
  object edGroupMemberSP: TcxButtonEdit
    Left = 40
    Top = 178
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 296
  end
  object cxLabel3: TcxLabel
    Left = 243
    Top = 8
    Caption = #1043#1086#1076' '#1088#1086#1078#1076#1077#1085#1080#1103
  end
  object edHappyDate: TcxTextEdit
    Left = 243
    Top = 26
    TabOrder = 11
    Width = 93
  end
  object edAddress: TcxTextEdit
    Left = 40
    Top = 229
    TabOrder = 12
    Width = 296
  end
  object cxLabel4: TcxLabel
    Left = 40
    Top = 211
    Caption = #1040#1076#1088#1077#1089' '#1087#1072#1094#1080#1077#1085#1090#1072
  end
  object edINN: TcxTextEdit
    Left = 40
    Top = 277
    TabOrder = 14
    Width = 124
  end
  object cxLabel5: TcxLabel
    Left = 40
    Top = 259
    Caption = #1048#1053#1053' '#1087#1072#1094#1080#1077#1085#1090#1072
  end
  object edPassport: TcxTextEdit
    Left = 173
    Top = 277
    TabOrder = 16
    Width = 163
  end
  object cxLabel6: TcxLabel
    Left = 173
    Top = 259
    Caption = #1057#1077#1088#1080#1103' '#1080' '#1053#1086#1084#1077#1088' '#1087#1072#1089#1087#1086#1088#1090#1072
  end
  object ActionList: TActionList
    Left = 280
    Top = 84
    object dsdDataSetRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object dsdInsertUpdateGuides: TdsdInsertUpdateGuides
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'Ok'
    end
    object dsdFormClose: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_MemberSP'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = ceCode
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerMedicalId'
        Value = Null
        Component = GuidesPartnerMedical
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGroupMemberSPId'
        Value = Null
        Component = GuidesGroupMemberSP
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHappyDate'
        Value = 'NULL'
        Component = edHappyDate
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAddress'
        Value = Null
        Component = edAddress
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inINN'
        Value = Null
        Component = edINN
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPassport'
        Value = Null
        Component = edPassport
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 112
  end
  object dsdFormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 272
    Top = 72
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_MemberSP'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerMedicalid'
        Value = Null
        Component = GuidesPartnerMedical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerMedicalName'
        Value = Null
        Component = GuidesPartnerMedical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GroupMemberSPId'
        Value = Null
        Component = GuidesGroupMemberSP
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GroupMemberSPName'
        Value = Null
        Component = GuidesGroupMemberSP
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'HappyDate'
        Value = Null
        Component = edHappyDate
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Address'
        Value = Null
        Component = edAddress
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'INN'
        Value = Null
        Component = edINN
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Passport'
        Value = Null
        Component = edPassport
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 16
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 200
    Top = 79
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 344
    Top = 64
  end
  object GuidesPartnerMedical: TdsdGuides
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
    Left = 160
    Top = 108
  end
  object GuidesGroupMemberSP: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGroupMemberSP
    FormNameParam.Value = 'TGroupMemberSPForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGroupMemberSPForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesGroupMemberSP
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesGroupMemberSP
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 180
  end
end
