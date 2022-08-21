object GoodsAdditionalEditDialogForm: TGoodsAdditionalEditDialogForm
  Left = 0
  Top = 0
  Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1086#1074' '#1073#1072#1083#1072#1085#1089#1072
  BorderStyle = bsDialog
  Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
  ClientHeight = 401
  ClientWidth = 852
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  AddOnFormData.ClosePUSHMessage = actPUSHClose
  PixelsPerInch = 96
  TextHeight = 13
  object cxButton1: TcxButton
    Left = 265
    Top = 359
    Width = 75
    Height = 25
    Caption = 'Ok'
    Default = True
    ModalResult = 1
    TabOrder = 0
  end
  object cxButton2: TcxButton
    Left = 529
    Top = 359
    Width = 75
    Height = 25
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 1
  end
  object cb_MakerName: TcxCheckBox
    Left = 346
    Top = 22
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    Width = 73
  end
  object cb_FormDispensing: TcxCheckBox
    Left = 346
    Top = 102
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    Width = 73
  end
  object cb_NumberPlates: TcxCheckBox
    Left = 346
    Top = 139
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    Width = 73
  end
  object cb_QtyPackage: TcxCheckBox
    Left = 346
    Top = 180
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    Width = 73
  end
  object cxLabel2: TcxLabel
    Left = 8
    Top = 3
    Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
  end
  object edMakerName: TcxButtonEdit
    Left = 8
    Top = 22
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 7
    Width = 332
  end
  object edNumberPlates: TcxCurrencyEdit
    Left = 7
    Top = 139
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 8
    Width = 109
  end
  object cxLabel3: TcxLabel
    Left = 7
    Top = 122
    Caption = #1050#1086#1083'-'#1074#1086' '#1087#1083#1072#1089#1090#1080#1085' '#1074' '#1091#1087#1072#1082#1086#1074#1082#1077':'
  end
  object cxLabel7: TcxLabel
    Left = 7
    Top = 163
    Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1091#1087#1072#1082#1086#1074#1082#1077':'
  end
  object ceQtyPackage: TcxCurrencyEdit
    Left = 7
    Top = 180
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    TabOrder = 11
    Width = 109
  end
  object cbIsRecipe: TcxCheckBox
    Left = 426
    Top = 172
    Caption = #1056#1077#1094#1077#1087#1090#1091#1088#1072
    TabOrder = 12
    Width = 96
  end
  object edFormDispensing: TcxButtonEdit
    Left = 8
    Top = 102
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 13
    Width = 332
  end
  object cxLabel14: TcxLabel
    Left = 7
    Top = 85
    Caption = #1060#1086#1088#1084#1072' '#1086#1090#1087#1091#1089#1082#1072
  end
  object cb_IsRecipe: TcxCheckBox
    Left = 763
    Top = 164
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 15
    Width = 73
  end
  object edMakerNameUkr: TcxTextEdit
    Left = 8
    Top = 62
    TabOrder = 16
    Width = 332
  end
  object cxLabel1: TcxLabel
    Left = 8
    Top = 44
    Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100' '#1059#1082#1088'. '#1085#1072#1079#1074#1072#1085#1080#1077
  end
  object cb_MakerNameUkr: TcxCheckBox
    Left = 346
    Top = 62
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 18
    Width = 73
  end
  object cb_Dosage: TcxCheckBox
    Left = 762
    Top = 22
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 19
    Width = 73
  end
  object edDosage: TcxTextEdit
    Left = 424
    Top = 22
    TabOrder = 20
    Width = 332
  end
  object cxLabel4: TcxLabel
    Left = 424
    Top = 4
    Caption = #1044#1086#1079#1080#1088#1086#1074#1082#1072
  end
  object cb_Volume: TcxCheckBox
    Left = 762
    Top = 62
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 22
    Width = 73
  end
  object edVolume: TcxTextEdit
    Left = 424
    Top = 62
    TabOrder = 23
    Width = 332
  end
  object cxLabel5: TcxLabel
    Left = 424
    Top = 44
    Caption = #1054#1073#1098#1077#1084
  end
  object cb_GoodsWhoCan: TcxCheckBox
    Left = 346
    Top = 228
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 25
    Width = 73
  end
  object cxLabel6: TcxLabel
    Left = 8
    Top = 207
    Caption = #1050#1086#1084#1091' '#1084#1086#1078#1085#1086
  end
  object cb_GoodsMethodAppl: TcxCheckBox
    Left = 763
    Top = 102
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 27
    Width = 73
  end
  object edGoodsMethodAppl: TcxButtonEdit
    Left = 425
    Top = 102
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 28
    Width = 332
  end
  object cxLabel8: TcxLabel
    Left = 425
    Top = 84
    Caption = #1057#1087#1086#1089#1086#1073' '#1087#1088#1080#1084#1077#1085#1077#1085#1080#1103
  end
  object cb_GoodsSignOrigin: TcxCheckBox
    Left = 763
    Top = 139
    Hint = #1055#1086' '#1091#1084#1086#1083#1095#1072#1085#1080#1102' ('#1076#1083#1103' '#1074#1093'. '#1087#1083#1072#1090#1077#1078#1077#1081')'
    Caption = #1080#1079#1084#1077#1085#1080#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 30
    Width = 73
  end
  object edGoodsSignOrigin: TcxButtonEdit
    Left = 425
    Top = 139
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 31
    Width = 332
  end
  object cxLabel9: TcxLabel
    Left = 425
    Top = 121
    Caption = #1055#1088#1080#1079#1085#1072#1082' '#1087#1088#1086#1080#1089#1093#1086#1078#1076#1077#1085#1080#1103
  end
  object cblGoodsWhoCan: TcxCheckListBox
    Left = 8
    Top = 228
    Width = 332
    Height = 109
    Columns = 2
    Items = <>
    TabOrder = 33
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 641
    Top = 125
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
    Top = 134
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'MakerName'
        Value = Null
        Component = edMakerName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'MakerNameUkr'
        Value = Null
        Component = edMakerNameUkr
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormDispensingId'
        Value = 0
        Component = FormDispensingGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'NumberPlates'
        Value = Null
        Component = edNumberPlates
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'QtyPackage'
        Value = Null
        Component = ceQtyPackage
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Dosage'
        Value = Null
        Component = edDosage
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Volume'
        Value = Null
        Component = edVolume
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsWhoCanList'
        Value = Null
        Component = CheckListBoxAddOnWhoCanGuides
        ComponentItem = 'KeyList'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsMethodApplId'
        Value = Null
        Component = GoodsMethodApplGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsSignOriginId'
        Value = Null
        Component = GoodsSignOriginGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsRecipe'
        Value = Null
        Component = cbIsRecipe
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_MakerName'
        Value = Null
        Component = cb_MakerName
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_MakerNameUkr'
        Value = Null
        Component = cb_MakerNameUkr
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_FormDispensing'
        Value = Null
        Component = cb_FormDispensing
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_NumberPlates'
        Value = Null
        Component = cb_NumberPlates
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_QtyPackage'
        Value = Null
        Component = cb_QtyPackage
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_Dosage'
        Value = Null
        Component = cb_Dosage
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_Volume'
        Value = Null
        Component = cb_Volume
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_GoodsWhoCan'
        Value = Null
        Component = cb_GoodsWhoCan
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_GoodsMethodAppl'
        Value = Null
        Component = cb_GoodsMethodAppl
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_GoodsSignOrigin'
        Value = Null
        Component = cb_GoodsSignOrigin
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_IsRecipe'
        Value = Null
        Component = cb_IsRecipe
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 143
    Top = 134
  end
  object GoodsMakerNameGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMakerName
    FormNameParam.Value = 'TGoodsMakerNameForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsMakerNameForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsMakerNameGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsMakerNameGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'GoodsMainId'
        MultiSelectSeparator = ','
      end>
    Left = 231
    Top = 11
  end
  object FormDispensingGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFormDispensing
    Key = '0'
    FormNameParam.Value = 'TFormDispensingForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TFormDispensingForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = FormDispensingGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = FormDispensingGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 199
    Top = 77
  end
  object GoodsMethodApplGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsMethodAppl
    Key = '0'
    FormNameParam.Value = 'TGoodsMethodApplForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsMethodApplForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GoodsMethodApplGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsMethodApplGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 471
    Top = 77
  end
  object GoodsSignOriginGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsSignOrigin
    Key = '0'
    FormNameParam.Value = 'TGoodsSignOriginForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsSignOriginForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GoodsSignOriginGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsSignOriginGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 527
    Top = 133
  end
  object spShowPUSH: TdsdStoredProc
    StoredProcName = 'gpSelect_ShowPUSH_GoodsAdditionalFilter'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        ComponentItem = 'GoodsMainId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMakerName'
        Value = ''
        Component = edMakerName
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_MakerName'
        Value = False
        Component = cb_MakerName
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFormDispensingId'
        Value = '0'
        Component = FormDispensingGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_FormDispensing'
        Value = False
        Component = cb_FormDispensing
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNumberPlates'
        Value = '0'
        Component = edNumberPlates
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_NumberPlates'
        Value = False
        Component = cb_NumberPlates
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inQtyPackage'
        Value = '0'
        Component = ceQtyPackage
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_QtyPackage'
        Value = False
        Component = cb_QtyPackage
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsRecipe'
        Value = False
        Component = cbIsRecipe
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_IsRecipe'
        Value = False
        Component = cb_IsRecipe
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMakerNameUkr'
        Value = ''
        Component = edMakerNameUkr
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_MakerNameUkr'
        Value = False
        Component = cb_MakerNameUkr
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDosage'
        Value = ''
        Component = edDosage
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_Dosage'
        Value = False
        Component = cb_Dosage
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inVolume'
        Value = ''
        Component = edVolume
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_Volume'
        Value = False
        Component = cb_Volume
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsWhoCanList'
        Value = '0'
        Component = CheckListBoxAddOnWhoCanGuides
        ComponentItem = 'KeyList'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_GoodsWhoCan'
        Value = False
        Component = cb_GoodsWhoCan
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsMethodApplId'
        Value = '0'
        Component = GoodsMethodApplGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_GoodsMethodAppl'
        Value = False
        Component = cb_GoodsMethodAppl
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsSignOriginId'
        Value = '0'
        Component = GoodsSignOriginGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_GoodsSignOrigin'
        Value = False
        Component = cb_GoodsSignOrigin
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outShowMessage'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPUSHType'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'outText'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 648
    Top = 64
  end
  object ActionList1: TActionList
    Left = 288
    Top = 128
    object actPUSHClose: TdsdShowPUSHMessage
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spShowPUSH
      StoredProcList = <
        item
          StoredProc = spShowPUSH
        end
        item
        end
        item
        end>
      Caption = 'actPUSHInfo'
    end
    object actSetDefaultParams: TdsdSetDefaultParams
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actSetDefaultParams'
      DefaultParams = <
        item
          Param.Value = Null
          Param.Component = cb_MakerName
          Param.MultiSelectSeparator = ','
          Value = 'False'
        end
        item
          Param.Value = Null
          Param.Component = cb_MakerNameUkr
          Param.MultiSelectSeparator = ','
          Value = 'False'
        end
        item
          Param.Value = Null
          Param.Component = cb_FormDispensing
          Param.MultiSelectSeparator = ','
          Value = 'False'
        end
        item
          Param.Value = Null
          Param.Component = cb_NumberPlates
          Param.MultiSelectSeparator = ','
          Value = 'False'
        end
        item
          Param.Value = Null
          Param.Component = cb_QtyPackage
          Param.MultiSelectSeparator = ','
          Value = 'False'
        end
        item
          Param.Value = Null
          Param.Component = cb_Dosage
          Param.MultiSelectSeparator = ','
          Value = 'False'
        end
        item
          Param.Value = Null
          Param.Component = cb_Volume
          Param.MultiSelectSeparator = ','
          Value = 'False'
        end
        item
          Param.Value = Null
          Param.Component = cb_GoodsWhoCan
          Param.MultiSelectSeparator = ','
          Value = 'False'
        end
        item
          Param.Value = Null
          Param.Component = cb_GoodsMethodAppl
          Param.MultiSelectSeparator = ','
          Value = 'False'
        end
        item
          Param.Value = Null
          Param.Component = cb_GoodsSignOrigin
          Param.MultiSelectSeparator = ','
          Value = 'False'
        end
        item
          Param.Value = Null
          Param.Component = cb_IsRecipe
          Param.MultiSelectSeparator = ','
          Value = 'False'
        end>
    end
    object actRefresh: TdsdDataSetRefresh
      Category = 'Refresh'
      MoveParams = <>
      BeforeAction = actSetDefaultParams
      StoredProc = spSelect_GoodsWhoCan
      StoredProcList = <
        item
          StoredProc = spSelect_GoodsWhoCan
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
  end
  object WhoCanGuidesCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 264
    Top = 288
  end
  object spSelect_GoodsWhoCan: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_GoodsWhoCan_Active'
    DataSet = WhoCanGuidesCDS
    DataSets = <
      item
        DataSet = WhoCanGuidesCDS
      end>
    Params = <>
    PackSize = 1
    Left = 264
    Top = 232
  end
  object CheckListBoxAddOnWhoCanGuides: TCheckListBoxAddOn
    CheckListBox = cblGoodsWhoCan
    DataSet = WhoCanGuidesCDS
    IdParam.Value = 'Id'
    IdParam.DataType = ftString
    IdParam.MultiSelectSeparator = ','
    NameParam.Value = 'Name'
    NameParam.DataType = ftString
    NameParam.MultiSelectSeparator = ','
    Left = 104
    Top = 256
  end
end
