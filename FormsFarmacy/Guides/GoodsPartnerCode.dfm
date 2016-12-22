﻿inherited GoodsPartnerCodeForm: TGoodsPartnerCodeForm
  Caption = #1050#1086#1076#1099' '#1087#1088#1086#1076#1072#1074#1094#1086#1074
  ClientHeight = 558
  ClientWidth = 1069
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 1085
  ExplicitHeight = 596
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1069
    Height = 532
    ExplicitWidth = 1063
    ExplicitHeight = 406
    ClientRectBottom = 532
    ClientRectRight = 1069
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1063
      ExplicitHeight = 406
      inherited cxGrid: TcxGrid
        Width = 1069
        Height = 532
        ExplicitLeft = -56
        ExplicitTop = 63
        ExplicitWidth = 1069
        ExplicitHeight = 532
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = colGoodsMainName
            end>
          OptionsBehavior.IncSearch = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colCommonCode: TcxGridDBColumn
            Caption = #1082#1086#1076' '#1052#1086#1088#1080#1086#1085
            DataBinding.FieldName = 'CommonCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colGoodsMainCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsMainCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = OpenChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
          end
          object colGoodsMainName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsMainName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 161
          end
          object clCodeInt: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1072#1088#1090#1085#1077#1088#1072
            DataBinding.FieldName = 'GoodsCodeInt'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 64
          end
          object clCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1072#1088#1090#1085#1077#1088#1072' ('#1089#1090#1088#1086#1082')'
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object clName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1091' '#1087#1072#1088#1090#1085#1077#1088#1072
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 177
          end
          object clMakerName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'MakerName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object clMinimumLot: TcxGridDBColumn
            Caption = #1052#1080#1085'. '#1086#1082#1088#1091#1075#1083'.'
            DataBinding.FieldName = 'MinimumLot'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0'
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1086#1077' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1077
            Width = 58
          end
          object colIsUpload: TcxGridDBColumn
            Caption = #1042#1099#1075#1088'.'
            DataBinding.FieldName = 'IsUpload'
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1099#1075#1088#1091#1078#1072#1077#1090#1089#1103' '#1074' '#1086#1090#1095#1077#1090#1077' '#1076#1083#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Width = 41
          end
          object colIsPromo: TcxGridDBColumn
            Caption = #1040#1082#1094#1080#1103
            DataBinding.FieldName = 'IsPromo'
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1086#1074#1072#1088' '#1091#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1072#1082#1094#1080#1080
            Width = 48
          end
          object сolisSpecCondition: TcxGridDBColumn
            Caption = #1057#1087#1077#1094'. '#1091#1089#1083#1086#1074#1080#1103
            DataBinding.FieldName = 'isSpecCondition'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1086#1074#1072#1088' '#1087#1086#1076' '#1089#1087#1077#1094'.'#1091#1089#1083#1086#1074#1080#1103
            Width = 55
          end
          object colUpdateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateDate'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 48
          end
          object colUpdateName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object colisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 30
          end
        end
      end
      object edPartnerCode: TcxButtonEdit
        Left = 184
        Top = 63
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 1
        Width = 187
      end
      object cxLabel1: TcxLabel
        Left = 184
        Top = 40
        Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082':'
      end
    end
  end
  inherited ActionList: TActionList
    object actStartLoadIsSpecCondition: TMultiAction [0]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072' isSpecCondition'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_Goods_IsSpecCondition
        end
        item
          Action = actDelete_ObjectFloat_Goods_IsSpecCondition
        end
        item
          Action = actDoLoadIsSpecCondition
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1087#1088#1080#1079#1085#1072#1082#1072' <'#1058#1086#1074#1072#1088' '#1087#1086#1076' '#1089#1087#1077#1094'.'#1091#1089#1083#1086#1074#1080#1103'>?'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1057#1087#1077#1094'. '#1091#1089#1083#1086#1074#1080#1103'>'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1058#1086#1074#1072#1088' '#1087#1086#1076' '#1089#1087#1077#1094'.'#1091#1089#1083#1086#1074#1080#1103'>'
      ImageIndex = 74
    end
    object actGetImportSetting_Goods_IsSpecCondition: TdsdExecStoredProc [2]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072' isSpecCondition'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSetting_Goods_IsSpecCondition
      StoredProcList = <
        item
          StoredProc = spGetImportSetting_Goods_IsSpecCondition
        end>
      Caption = 'actGetImportSetting_Goods_SpecCondition'
    end
    object actDelete_ObjectFloat_Goods_IsSpecCondition: TdsdExecStoredProc [4]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072' isSpecCondition'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDelete_ObjectBoolean_Goods_IsSpecCondition
      StoredProcList = <
        item
          StoredProc = spDelete_ObjectBoolean_Goods_IsSpecCondition
        end>
      Caption = 'actDelete_ObjectFloat_Goods_IsSpecCondition'
    end
    inherited actInsert: TInsertUpdateChoiceAction
      Enabled = False
      FormName = 'TGoodsMainEditForm'
      FormNameParam.Value = 'TGoodsMainEditForm'
      DataSource = nil
    end
    object actDoLoadIsSpecCondition: TExecuteImportSettingsAction [6]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072' isSpecCondition'
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingIsSpecConditionId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inObjectId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'ObjectId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actShowErased: TBooleanStoredProcAction [7]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndex = 64
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1085#1077' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077
      ImageIndexTrue = 65
      ImageIndexFalse = 64
    end
    inherited actUpdate: TdsdInsertUpdateAction
      Enabled = False
      FormName = 'TGoodsMainEditForm'
      FormNameParam.Value = 'TGoodsMainEditForm'
      isShowModal = True
      DataSource = nil
    end
    inherited dsdSetUnErased: TdsdUpdateErased
      Enabled = False
      DataSource = nil
    end
    inherited dsdSetErased: TdsdUpdateErased
      Category = 'Delete'
      ImageIndex = -1
      ShortCut = 0
    end
    inherited dsdChoiceGuides: TdsdChoiceGuides
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Code'
          MultiSelectSeparator = ','
        end>
    end
    object mactDelete: TMultiAction
      Category = 'Delete'
      MoveParams = <>
      ActionList = <
        item
          Action = actDeleteLink
        end
        item
          Action = DataSetPost
        end>
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080' '#1089#1074#1103#1079#1080'?'
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
    end
    object actDeleteLink: TdsdExecStoredProc
      Category = 'Delete'
      MoveParams = <
        item
          FromParam.Value = '0'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = MasterCDS
          ToParam.ComponentItem = 'GoodsId'
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = '0'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = MasterCDS
          ToParam.ComponentItem = 'GoodsMainId'
          ToParam.MultiSelectSeparator = ','
        end>
      PostDataSetBeforeExecute = False
      StoredProc = spDeleteLink
      StoredProcList = <
        item
          StoredProc = spDeleteLink
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
    end
    object DataSetPost: TDataSetPost
      Category = 'DataSet'
      Caption = 'P&ost'
      Hint = 'Post'
      ImageIndex = 73
      DataSource = MasterDS
    end
    object mactSetLink: TMultiAction
      Category = 'Insert'
      MoveParams = <>
      ActionList = <
        item
          Action = DataSetEdit
        end
        item
          Action = OpenChoiceForm
        end
        item
          Action = actSetLink
        end
        item
          Action = DataSetPost
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1074#1103#1079#1100
      ImageIndex = 1
    end
    object DataSetEdit: TDataSetEdit
      Category = 'DataSet'
      Caption = '&Edit'
      Hint = 'Edit'
      ImageIndex = 74
    end
    object OpenChoiceForm: TOpenChoiceForm
      Category = 'Insert'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'OpenChoiceForm'
      FormName = 'TGoodsMainLiteForm'
      FormNameParam.Value = 'TGoodsMainLiteForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsMainId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsMainCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsMainName'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actSetLink: TdsdExecStoredProc
      Category = 'Insert'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInserUpdateGoodsLink
      StoredProcList = <
        item
          StoredProc = spInserUpdateGoodsLink
        end>
      Caption = 'actSetLink'
    end
    object dsdUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInserUpdateGoodsLink
      StoredProcList = <
        item
          StoredProc = spInserUpdateGoodsLink
        end
        item
          StoredProc = spUpdate_Goods_MinimumLot
        end
        item
          StoredProc = spUpdate_Goods_IsUpload
        end
        item
          StoredProc = spUpdate_Goods_Promo
        end
        item
          StoredProc = spUpdate_Goods_IsSpecCondition
        end>
      Caption = 'dsdUpdateDataSet'
      DataSource = MasterDS
    end
    object actStartLoad: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_Goods_MinimumLot
        end
        item
          Action = actDelete_ObjectFloat_Goods_MinimumLot
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1084#1080#1085#1080#1084#1072#1083#1100#1085#1086#1075#1086' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1103'?'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1084#1080#1085#1080#1084#1072#1083#1100#1085#1086#1077' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1077
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1084#1080#1085#1080#1084#1072#1083#1100#1085#1086#1077' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1077
      ImageIndex = 41
    end
    object actGetImportSetting_Goods_MinimumLot: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSetting_Goods_MinimumLot
      StoredProcList = <
        item
          StoredProc = spGetImportSetting_Goods_MinimumLot
        end>
      Caption = 'actGetImportSetting_Goods_MinimumLot'
    end
    object actDelete_ObjectFloat_Goods_MinimumLot: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDelete_ObjectFloat_Goods_MinimumLot
      StoredProcList = <
        item
          StoredProc = spDelete_ObjectFloat_Goods_MinimumLot
        end>
      Caption = 'actDelete_ObjectFloat_Goods_MinimumLot'
    end
    object actDoLoad: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inObjectId'
          Value = Null
          Component = FormParams
          ComponentItem = 'ObjectId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actStartLoadIsUpload: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072' isUpload'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_Goods_IsUpload
        end
        item
          Action = actDelete_ObjectFloat_Goods_IsUpload
        end
        item
          Action = actDoLoadIsUpload
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1087#1088#1080#1079#1085#1072#1082#1072' <'#1042#1099#1075#1088#1091#1078#1072#1077#1090#1089#1103' '#1074' '#1086#1090#1095#1077#1090#1077' '#1076#1083#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'>?'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1042#1099#1075#1088'.>'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1042#1099#1075#1088#1091#1078#1072#1077#1090#1089#1103' '#1074' '#1086#1090#1095#1077#1090#1077' '#1076#1083#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'>'
      ImageIndex = 43
    end
    object actGetImportSetting_Goods_IsUpload: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072' isUpload'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSetting_Goods_IsUpload
      StoredProcList = <
        item
          StoredProc = spGetImportSetting_Goods_IsUpload
        end>
      Caption = 'actGetImportSetting_Goods_IsUpload'
    end
    object actDelete_ObjectFloat_Goods_IsUpload: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072' isUpload'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spDelete_ObjectBoolean_Goods_IsUpload
      StoredProcList = <
        item
          StoredProc = spDelete_ObjectBoolean_Goods_IsUpload
        end>
      Caption = 'actDelete_ObjectFloat_Goods_IsUpload'
    end
    object actDoLoadIsUpload: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072' isUpload'
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingIsUploadId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inObjectId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'ObjectId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object dsdSetUnErasedGoods: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErasedGoods
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedGoods
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 46
      ErasedFieldName = 'isErased'
      isSetErased = False
      DataSource = MasterDS
    end
    object dsdSetErasedGoogs: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErasedGoods
      StoredProcList = <
        item
          StoredProc = spErasedUnErasedGoods
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1089#1090#1088#1086#1082#1091
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1089#1090#1088#1086#1082#1091
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = MasterDS
    end
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 56
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
    Top = 48
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Goods_Juridical'
    Params = <
      item
        Name = 'inObjectId'
        Value = ''
        Component = PartnerCodeGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = Null
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 144
    Top = 88
  end
  inherited BarManager: TdxBarManager
    Top = 48
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbSetLink'
        end
        item
          Visible = True
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbSetErasedGoogs'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErasedGoods'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbChoiceGuides'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          UserDefine = [udPaintStyle]
          UserPaintStyle = psCaptionGlyph
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          UserDefine = [udPaintStyle]
          UserPaintStyle = psCaptionGlyph
          Visible = True
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          UserDefine = [udPaintStyle]
          UserPaintStyle = psCaptionGlyph
          Visible = True
          ItemName = 'bbSpecCondition'
        end>
    end
    inherited bbInsert: TdxBarButton
      Visible = ivNever
    end
    inherited bbErased: TdxBarButton
      Action = mactDelete
    end
    inherited bbUnErased: TdxBarButton
      Visible = ivNever
    end
    object bbSetLink: TdxBarButton
      Action = mactSetLink
      Category = 0
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel1
    end
    object dxBarControlContainerItem2: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edPartnerCode
    end
    object dxBarButton1: TdxBarButton
      Action = actStartLoad
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1084#1080#1085'-'#1086#1077' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1077
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actStartLoadIsUpload
      Category = 0
    end
    object bbSpecCondition: TdxBarButton
      Action = actStartLoadIsSpecCondition
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1088'. <'#1057#1087#1077#1094'. '#1091#1089#1083#1086#1074#1080#1103'>'
      Category = 0
    end
    object bbSetErasedGoogs: TdxBarButton
      Action = dsdSetErasedGoogs
      Category = 0
    end
    object bbSetUnErasedGoods: TdxBarButton
      Action = dsdSetUnErasedGoods
      Category = 0
    end
    object bbShowErased: TdxBarButton
      Action = actShowErased
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
        Action = actUpdate
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        Action = actUpdate
        ShortCut = 13
      end>
    SearchAsFilter = False
    Left = 256
    Top = 216
  end
  inherited spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_LinkGoods'
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
  end
  object PartnerCodeGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPartnerCode
    Key = '0'
    FormNameParam.Value = 'TPartnerCodeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartnerCodeForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = PartnerCodeGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = PartnerCodeGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 288
    Top = 108
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PartnerCodeGuides
      end>
    Left = 216
    Top = 112
  end
  object spDeleteLink: TdsdStoredProc
    StoredProcName = 'gpDelete_Object_LinkGoods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsMainCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsMainCode'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsMainName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsMainName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 392
    Top = 160
  end
  object spInserUpdateGoodsLink: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_LinkGoods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsMainId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsMainId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 248
  end
  object spUpdate_Goods_MinimumLot: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_MinimumLot'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMinimumLot'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MinimumLot'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outUpdateDate'
        Value = 'NULL'
        Component = MasterCDS
        ComponentItem = 'UpdateDate'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outUpdateName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UpdateName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 288
  end
  object spDelete_ObjectFloat_Goods_MinimumLot: TdsdStoredProc
    StoredProcName = 'gpDelete_ObjectFloat_Goods_MinimumLot'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = FormParams
        ComponentItem = 'ObjectId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 520
    Top = 312
  end
  object spGetImportSetting_Goods_MinimumLot: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TGoodsPartnerCodeForm;zc_Object_ImportSetting_Goods_MinimumLot'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 520
    Top = 264
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ObjectId'
        Value = Null
        Component = PartnerCodeGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingIsUploadId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingIsSpecConditionId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 472
    Top = 104
  end
  object spUpdate_Goods_IsUpload: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_IsUpload'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsUpload'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IsUpload'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 336
  end
  object spGetImportSetting_Goods_IsUpload: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TGoodsPartnerCodeForm;zc_Object_ImportSetting_Goods_IsUpload'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingIsUploadId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 712
    Top = 224
  end
  object spDelete_ObjectBoolean_Goods_IsUpload: TdsdStoredProc
    StoredProcName = 'gpDelete_ObjectBoolean_Goods_IsUpload'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'ObjectId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 712
    Top = 280
  end
  object spUpdate_Goods_Promo: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_Promo'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPromo'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IsPromo'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outUpdateDate'
        Value = 'NULL'
        Component = MasterCDS
        ComponentItem = 'UpdateDate'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'outUpdateName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UpdateName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 368
  end
  object spUpdate_Goods_IsSpecCondition: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_IsSpecCondition'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsSpecCondition'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IsSpecCondition'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 176
    Top = 344
  end
  object spGetImportSetting_Goods_IsSpecCondition: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 
          'TGoodsPartnerCodeForm;zc_Object_ImportSetting_Goods_IsSpecCondit' +
          'ion'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingIsSpecConditionId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 824
    Top = 192
  end
  object spDelete_ObjectBoolean_Goods_IsSpecCondition: TdsdStoredProc
    StoredProcName = 'gpDelete_ObjectBoolean_Goods_IsSpecCondition'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'ObjectId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 824
    Top = 136
  end
  object spErasedUnErasedGoods: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 40
    Top = 136
  end
end
