object ContactPersonEditForm: TContactPersonEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100' / '#1080#1079#1084#1077#1085#1080#1090#1100' '#1082#1086#1085#1090#1072#1082#1090#1085#1086#1077' '#1083#1080#1094#1086
  ClientHeight = 423
  ClientWidth = 377
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
    Width = 294
  end
  object cxLabel1: TcxLabel
    Left = 40
    Top = 52
    Caption = #1060#1048#1054
  end
  object cxButton1: TcxButton
    Left = 87
    Top = 382
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    ModalResult = 8
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 237
    Top = 382
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
    Width = 294
  end
  object cxLabel2: TcxLabel
    Left = 41
    Top = 98
    Caption = #1058#1077#1083#1077#1092#1086#1085
  end
  object edPhone: TcxTextEdit
    Left = 41
    Top = 114
    TabOrder = 7
    Width = 121
  end
  object cxLabel3: TcxLabel
    Left = 41
    Top = 187
    Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
  end
  object ceJuridical: TcxButtonEdit
    Left = 39
    Top = 206
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 9
    Width = 298
  end
  object ceContract: TcxButtonEdit
    Left = 39
    Top = 247
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 10
    Width = 296
  end
  object cxLabel5: TcxLabel
    Left = 41
    Top = 146
    Caption = #1050#1086#1085#1090#1088#1072#1075#1077#1085#1090
  end
  object cePartner: TcxButtonEdit
    Left = 41
    Top = 162
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 12
    Width = 296
  end
  object cxLabel6: TcxLabel
    Left = 41
    Top = 231
    Caption = #1044#1086#1075#1086#1074#1086#1088
  end
  object cxLabel4: TcxLabel
    Left = 175
    Top = 98
    Caption = #1069#1083#1077#1082#1090#1088#1086#1085#1085#1072#1103' '#1087#1086#1095#1090#1072
  end
  object edMail: TcxTextEdit
    Left = 175
    Top = 114
    TabOrder = 15
    Width = 159
  end
  object edComment: TcxTextEdit
    Left = 41
    Top = 340
    TabOrder = 16
    Width = 296
  end
  object cxLabel7: TcxLabel
    Left = 41
    Top = 320
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object cxLabel8: TcxLabel
    Left = 42
    Top = 274
    Caption = #1042#1080#1076' '#1082#1086#1085#1090#1072#1082#1090#1072
  end
  object ceContactPersonKind: TcxButtonEdit
    Left = 40
    Top = 293
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 296
  end
  object ActionList: TActionList
    Left = 272
    Top = 20
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
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ContactPerson'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inCode'
        Value = 0.000000000000000000
        Component = ceCode
        ParamType = ptInput
      end
      item
        Name = 'inName'
        Value = ''
        Component = edName
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inPhone'
        Value = ''
        Component = edPhone
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'Mail'
        Value = ''
        Component = edMail
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'Comment'
        Value = ''
        Component = edComment
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inObjectId_Partner'
        Value = ''
        Component = PartnerGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inObjectId_Juridical'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inObjectId_Contract'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inContactPersonKindId'
        Value = ''
        Component = ContactPersonKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
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
      end
      item
        Name = 'PartnerId'
        Value = ''
        Component = PartnerGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ContactPersonKindId'
        Value = ''
        Component = ContactPersonKindGuides
        ComponentItem = 'Key'
      end>
    Left = 32
    Top = 356
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_ContactPerson'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = dsdFormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'inPartnerId'
        Value = ''
        Component = dsdFormParams
        ComponentItem = 'PartnerId'
        ParamType = ptInput
      end
      item
        Name = 'inContactPersonKindId'
        Value = ''
        Component = dsdFormParams
        ComponentItem = 'ContactPersonKindId'
        ParamType = ptInput
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = ceCode
      end
      item
        Name = 'Name'
        Value = ''
        Component = edName
        DataType = ftString
      end
      item
        Name = 'Phone'
        Value = ''
        Component = edPhone
        DataType = ftString
      end
      item
        Name = 'Mail'
        Value = ''
        Component = edMail
        DataType = ftString
      end
      item
        Name = 'Comment'
        Value = ''
        Component = edComment
        DataType = ftString
      end
      item
        Name = 'PartnerId'
        Value = ''
        Component = PartnerGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'PartnerName'
        Value = ''
        Component = PartnerGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'ContractId'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ContractName'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end
      item
        Name = 'ContactPersonKindId'
        Value = ''
        Component = ContactPersonKindGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'ContactPersonKindName'
        Value = ''
        Component = ContactPersonKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    PackSize = 1
    Left = 344
    Top = 16
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 208
    Top = 7
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
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceJuridical
    FormNameParam.Value = 'TJuridicalForm'
    FormNameParam.DataType = ftString
    FormName = 'TJuridicalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 151
    Top = 200
  end
  object ContractGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceContract
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContractGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 175
    Top = 248
  end
  object PartnerGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = cePartner
    FormNameParam.Value = 'TPartner_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TPartner_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PartnerGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PartnerGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 177
    Top = 144
  end
  object ContactPersonKindGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceContactPersonKind
    FormNameParam.Value = 'TContactPersonKindForm'
    FormNameParam.DataType = ftString
    FormName = 'TContactPersonKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ContactPersonKindGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ContactPersonKindGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 255
    Top = 288
  end
end
