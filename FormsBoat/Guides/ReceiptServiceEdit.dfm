object ReceiptServiceEditForm: TReceiptServiceEditForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1073#1072#1074#1080#1090#1100'/'#1048#1079#1084#1077#1085#1080#1090#1100' <'#1056#1072#1073#1086#1090#1099'/'#1059#1089#1083#1091#1075#1080'>'
  ClientHeight = 304
  ClientWidth = 532
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = dsdDataSetRefresh
  AddOnFormData.Params = FormParams
  PixelsPerInch = 96
  TextHeight = 13
  object edName: TcxTextEdit
    Left = 10
    Top = 72
    TabOrder = 0
    Width = 269
  end
  object cxLabel1: TcxLabel
    Left = 10
    Top = 52
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077
  end
  object cxButton1: TcxButton
    Left = 169
    Top = 266
    Width = 75
    Height = 25
    Action = dsdInsertUpdateGuides
    Default = True
    TabOrder = 2
  end
  object cxButton2: TcxButton
    Left = 313
    Top = 266
    Width = 75
    Height = 25
    Action = dsdFormClose
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 3
  end
  object cxLabel2: TcxLabel
    Left = 10
    Top = 8
    Caption = #1050#1086#1076
  end
  object edCode: TcxCurrencyEdit
    Left = 10
    Top = 27
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 5
    Width = 127
  end
  object cxLabel3: TcxLabel
    Left = 294
    Top = 197
    Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
  end
  object edComment: TcxTextEdit
    Left = 296
    Top = 218
    TabOrder = 7
    Width = 225
  end
  object edArticle: TcxTextEdit
    Left = 168
    Top = 27
    TabOrder = 8
    Width = 111
  end
  object cxLabel18: TcxLabel
    Left = 168
    Top = 8
    Caption = 'Artikel Nr'
  end
  object cxLabel17: TcxLabel
    Left = 10
    Top = 151
    Caption = #1058#1080#1087' '#1053#1044#1057
  end
  object edTaxKind: TcxButtonEdit
    Left = 10
    Top = 170
    Properties.Buttons = <
      item
        Default = True
        Enabled = False
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 269
  end
  object cxLabel15: TcxLabel
    Left = 10
    Top = 201
    Hint = #1062#1077#1085#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
    Caption = #1062#1077#1085#1072' '#1074#1093'. '#1073#1077#1079' '#1053#1044#1057
  end
  object edEKPrice: TcxCurrencyEdit
    Left = 10
    Top = 218
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 13
    Width = 125
  end
  object edSalePrice: TcxCurrencyEdit
    Left = 154
    Top = 218
    Properties.DecimalPlaces = 4
    Properties.DisplayFormat = ',0.####'
    TabOrder = 14
    Width = 125
  end
  object cxLabel4: TcxLabel
    Left = 154
    Top = 201
    Hint = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
    Caption = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1053#1044#1057
  end
  object edPartner: TcxButtonEdit
    Left = 10
    Top = 123
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 16
    Width = 269
  end
  object cxLabel5: TcxLabel
    Left = 10
    Top = 102
    Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082' '#1091#1089#1083#1091#1075
  end
  object cxLabel6: TcxLabel
    Left = 296
    Top = 52
    Caption = #1043#1088#1091#1087#1087#1072' '#1056#1072#1073#1086#1090#1099'/'#1059#1089#1083#1091#1075#1080
  end
  object edReceiptServiceGroup: TcxButtonEdit
    Left = 296
    Top = 72
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 19
    Width = 225
  end
  object cxLabel7: TcxLabel
    Left = 296
    Top = 102
    Caption = #1056#1072#1073#1086#1090#1099'/'#1059#1089#1083#1091#1075#1080' ('#1084#1086#1076#1077#1083#1100')'
  end
  object edReceiptServiceModel: TcxButtonEdit
    Left = 296
    Top = 124
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 21
    Width = 225
  end
  object cxLabel8: TcxLabel
    Left = 296
    Top = 150
    Caption = #1056#1072#1073#1086#1090#1099'/'#1059#1089#1083#1091#1075#1080' ('#1057#1099#1088#1100#1077')'
  end
  object edReceiptServiceMaterial: TcxButtonEdit
    Left = 296
    Top = 170
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 23
    Width = 225
  end
  object cxLabel9: TcxLabel
    Left = 410
    Top = 8
    Caption = #1047#1072#1084#1077#1085#1072' '#1089#1099#1088#1100#1103
  end
  object edNumReplace: TcxTextEdit
    Left = 410
    Top = 27
    TabOrder = 25
    Width = 111
  end
  object edNPP: TcxCurrencyEdit
    Left = 296
    Top = 27
    EditValue = 0.000000000000000000
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 26
    Width = 104
  end
  object cxLabel10: TcxLabel
    Left = 296
    Top = 8
    Caption = #8470' '#1087'/'#1087
  end
  object ActionList: TActionList
    Left = 240
    Top = 8
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
      MoveParams = <>
      PostDataSetBeforeExecute = False
    end
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_ReceiptService'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCode'
        Value = 0.000000000000000000
        Component = edCode
        ParamType = ptInputOutput
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
        Name = 'inArticle'
        Value = Null
        Component = edArticle
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNumReplace'
        Value = Null
        Component = edNumReplace
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = edComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTaxKindId'
        Value = Null
        Component = GuidesTaxKind
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartnerId'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptServiceGroupId'
        Value = Null
        Component = GuidesReceiptServiceGroup
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEKPrice'
        Value = Null
        Component = edEKPrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSalePrice'
        Value = Null
        Component = edSalePrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNPP'
        Value = Null
        Component = edNPP
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptServiceModelName'
        Value = Null
        Component = edReceiptServiceModel
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inReceiptServiceMaterialName'
        Value = Null
        Component = edReceiptServiceMaterial
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 464
    Top = 240
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 148
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_ReceiptService'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
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
        Component = edCode
        DataType = ftUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'Article'
        Value = Null
        Component = edArticle
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = edComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'EKPrice'
        Value = Null
        Component = edEKPrice
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'SalePrice'
        Value = Null
        Component = edSalePrice
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindId'
        Value = Null
        Component = GuidesTaxKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindName'
        Value = Null
        Component = GuidesTaxKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = Null
        Component = GuidesPartner
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptServiceGroupId'
        Value = Null
        Component = GuidesReceiptServiceGroup
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptServiceGroupName'
        Value = Null
        Component = GuidesReceiptServiceGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptServiceMaterialId'
        Value = Null
        Component = GuidesReceiptServiceMaterial
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptServiceMaterialName'
        Value = Null
        Component = GuidesReceiptServiceMaterial
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptServiceModelId'
        Value = Null
        Component = GuidesReceiptServiceModel
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReceiptServiceModelName'
        Value = Null
        Component = GuidesReceiptServiceModel
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'NPP'
        Value = Null
        Component = edNPP
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'NumReplace'
        Value = Null
        Component = edNumReplace
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 400
    Top = 240
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
    Left = 216
    Top = 56
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 136
    Top = 196
  end
  object GuidesTaxKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTaxKind
    DisableGuidesOpen = True
    FormNameParam.Value = 'TTaxKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TTaxKindForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTaxKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTaxKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 111
    Top = 152
  end
  object GuidesPartner: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartner
    FormNameParam.Value = 'TPartnerForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartnerForm'
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
        Name = 'TaxKindId'
        Value = Null
        Component = GuidesTaxKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindName'
        Value = Null
        Component = GuidesTaxKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 103
    Top = 97
  end
  object GuidesReceiptServiceGroup: TdsdGuides
    KeyField = 'Id'
    LookupControl = edReceiptServiceGroup
    Key = '0'
    FormNameParam.Value = 'TReceiptServiceGroupForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TReceiptServiceGroupForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesReceiptServiceGroup
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesReceiptServiceGroup
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindId'
        Value = ''
        Component = GuidesTaxKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindName'
        Value = ''
        Component = GuidesTaxKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 423
    Top = 46
  end
  object GuidesReceiptServiceModel: TdsdGuides
    KeyField = 'Id'
    LookupControl = edReceiptServiceModel
    FormNameParam.Value = 'TReceiptServiceModelForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TReceiptServiceModelForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesReceiptServiceModel
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesReceiptServiceModel
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindId'
        Value = ''
        Component = GuidesTaxKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindName'
        Value = ''
        Component = GuidesTaxKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 415
    Top = 113
  end
  object GuidesReceiptServiceMaterial: TdsdGuides
    KeyField = 'Id'
    LookupControl = edReceiptServiceMaterial
    FormNameParam.Value = 'TReceiptServiceMaterialForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TReceiptServiceMaterialForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesReceiptServiceMaterial
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesReceiptServiceMaterial
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindId'
        Value = ''
        Component = GuidesTaxKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TaxKindName'
        Value = ''
        Component = GuidesTaxKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 407
    Top = 176
  end
end
