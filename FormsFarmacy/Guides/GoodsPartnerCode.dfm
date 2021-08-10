inherited GoodsPartnerCodeForm: TGoodsPartnerCodeForm
  Caption = #1050#1086#1076#1099' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1086#1074
  ClientHeight = 529
  ClientWidth = 1257
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1273
  ExplicitHeight = 568
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 61
    Width = 1257
    Height = 468
    ExplicitTop = 61
    ExplicitWidth = 1257
    ExplicitHeight = 468
    ClientRectBottom = 468
    ClientRectRight = 1257
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1257
      ExplicitHeight = 468
      inherited cxGrid: TcxGrid
        Width = 1257
        Height = 468
        ExplicitWidth = 1257
        ExplicitHeight = 468
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsMainName
            end>
          OptionsBehavior.IncSearch = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object CommonCode: TcxGridDBColumn
            Caption = #1082#1086#1076' '#1052#1086#1088#1080#1086#1085
            DataBinding.FieldName = 'CommonCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object GoodsMainCode: TcxGridDBColumn
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
          object GoodsMainName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsMainName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 161
          end
          object GoodsCodeInt: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1072#1088#1090#1085#1077#1088#1072
            DataBinding.FieldName = 'GoodsCodeInt'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 64
          end
          object CodeUKTZED: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1050#1058' '#1047#1045#1044
            DataBinding.FieldName = 'CodeUKTZED'
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1090#1086#1074#1072#1088#1091' '#1079#1075#1110#1076#1085#1086' '#1079' '#1059#1050#1058' '#1047#1045#1044' '
            Options.Editing = False
            Width = 64
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1072#1088#1090#1085#1077#1088#1072' ('#1089#1090#1088#1086#1082')'
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1091' '#1087#1072#1088#1090#1085#1077#1088#1072
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 177
          end
          object AreaName: TcxGridDBColumn
            Caption = #1056#1077#1075#1080#1086#1085
            DataBinding.FieldName = 'AreaName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object MakerName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100
            DataBinding.FieldName = 'MakerName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object ConditionsKeepName: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'ConditionsKeepName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = ConditionsKeepChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Width = 110
          end
          object DiscountExternalName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' '#1076#1083#1103' '#1087#1088#1086#1077#1082#1090#1072' ('#1076#1080#1089#1082#1086#1085#1090#1085#1099#1077' '#1082#1072#1088#1090#1099')'
            DataBinding.FieldName = 'DiscountExternalName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = DiscountExternalChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Width = 119
          end
          object MinimumLot: TcxGridDBColumn
            Caption = #1052#1080#1085'. '#1086#1082#1088#1091#1075#1083'.'
            DataBinding.FieldName = 'MinimumLot'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0'
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1080#1085#1080#1084#1072#1083#1100#1085#1086#1077' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1077
            Width = 58
          end
          object IsUpload: TcxGridDBColumn
            Caption = #1042#1099#1075#1088'.'
            DataBinding.FieldName = 'IsUpload'
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1099#1075#1088#1091#1078#1072#1077#1090#1089#1103' '#1074' '#1086#1090#1095#1077#1090#1077' '#1076#1083#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Width = 41
          end
          object IsPromo: TcxGridDBColumn
            Caption = #1040#1082#1094#1080#1103
            DataBinding.FieldName = 'IsPromo'
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1086#1074#1072#1088' '#1091#1095#1072#1089#1090#1074#1091#1077#1090' '#1074' '#1072#1082#1094#1080#1080
            Width = 48
          end
          object isSpecCondition: TcxGridDBColumn
            Caption = #1057#1087#1077#1094'. '#1091#1089#1083#1086#1074#1080#1103
            DataBinding.FieldName = 'isSpecCondition'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1086#1074#1072#1088' '#1087#1086#1076' '#1089#1087#1077#1094'.'#1091#1089#1083#1086#1074#1080#1103
            Width = 55
          end
          object isUploadBadm: TcxGridDBColumn
            Caption = #1042#1099#1075#1088#1091#1078#1072#1090#1100' '#1074' '#1086#1090#1095#1077#1090#1077' '#1076#1083#1103' '#1087#1086#1089#1090'. '#1041#1040#1044#1052
            DataBinding.FieldName = 'isUploadBadm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1099#1075#1088#1091#1078#1072#1090#1100' '#1074' '#1086#1090#1095#1077#1090#1077' '#1076#1083#1103' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' '#1041#1040#1044#1052
            Width = 89
          end
          object isUploadTeva: TcxGridDBColumn
            Caption = #1042#1099#1075#1088#1091#1078#1072#1090#1100' '#1074' '#1086#1090#1095#1077#1090#1077' '#1076#1083#1103' '#1087#1086#1089#1090'. '#1058#1077#1074#1072
            DataBinding.FieldName = 'isUploadTeva'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1099#1075#1088#1091#1078#1072#1090#1100' '#1074' '#1086#1090#1095#1077#1090#1077' '#1076#1083#1103' '#1087#1086#1089#1090'. '#1058#1077#1074#1072
            Width = 89
          end
          object isUploadYuriFarm: TcxGridDBColumn
            Caption = #1042#1099#1075#1088#1091#1078#1072#1090#1100' '#1074' '#1086#1090#1095#1077#1090#1077' '#1076#1083#1103' '#1087#1086#1089#1090'. '#1070#1088#1080#1103'-'#1060#1072#1088#1084
            DataBinding.FieldName = 'isUploadYuriFarm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 89
          end
          object UpdateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateDate'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 48
          end
          object UpdateName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object DateUpdateMinimumLot: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'. '#1052#1080#1085'. '#1086#1082#1088#1091#1075#1083')'
            DataBinding.FieldName = 'DateUpdateMinimumLot'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object UserUpdateMinimumLotName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'. '#1052#1080#1085'. '#1086#1082#1088#1091#1075#1083')'
            DataBinding.FieldName = 'UserUpdateMinimumLotName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object DateUpdateisPromo: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'. '#1040#1082#1094#1080#1103')'
            DataBinding.FieldName = 'DateUpdateisPromo'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 81
          end
          object UserUpdateisPromoName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'. '#1040#1082#1094#1080#1103')'
            DataBinding.FieldName = 'UserUpdateisPromoName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object isErased: TcxGridDBColumn
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
      object cbUpdate: TcxCheckBox
        Left = 305
        Top = 64
        Caption = #1054#1073#1085#1086#1074#1083#1103#1090#1100' '#1076#1083#1103' '#1042#1057#1045#1061
        Properties.ReadOnly = False
        TabOrder = 1
        Width = 133
      end
    end
  end
  object Panel: TPanel [1]
    Left = 0
    Top = 0
    Width = 1257
    Height = 35
    Align = alTop
    TabOrder = 5
    object cxLabel6: TcxLabel
      Left = 480
      Top = 9
      AutoSize = False
      Caption = #1056#1077#1075#1080#1086#1085' '#1076#1083#1103' '#1079#1072#1075#1088#1091#1079#1082#1080' '#1052#1048#1053' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1103':'
      Height = 17
      Width = 201
    end
    object edArea: TcxButtonEdit
      Left = 680
      Top = 8
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 0
      Width = 169
    end
    object edPartnerCode: TcxButtonEdit
      Left = 81
      Top = 8
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 1
      Width = 217
    end
    object cxLabel1: TcxLabel
      Left = 16
      Top = 9
      Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082':'
    end
  end
  inherited ActionList: TActionList
    object actStartLoadConditionsKeep: TMultiAction [0]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072' ConditionsKeep'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_Goods_ConditionsKeep
        end
        item
          Action = actDoLoadConditionsKeep
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1053#1072#1095#1072#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1087#1088#1080#1079#1085#1072#1082#1072' <'#1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103'>?'
      InfoAfterExecute = #1047#1072#1075#1088#1091#1079#1082#1072' '#1087#1088#1080#1079#1085#1072#1082#1072' <'#1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103'> '#1079#1072#1074#1077#1088#1096#1077#1085#1072
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103'>'
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' <'#1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103'>'
      ImageIndex = 60
    end
    object actGetImportSetting_Goods_ConditionsKeep: TdsdExecStoredProc [1]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072' ConditionsKeep'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSetting_Goods_ConditionsKeep
      StoredProcList = <
        item
          StoredProc = spGetImportSetting_Goods_ConditionsKeep
        end>
      Caption = 'actGetImportSetting_Goods_ConditionsKeep'
    end
    object actDoLoadConditionsKeep: TExecuteImportSettingsAction [3]
      Category = #1047#1072#1075#1088#1091#1079#1082#1072' ConditionsKeep'
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingConditionsKeepId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inObjectId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'ObjectId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inisUpdate'
          Value = Null
          Component = cbUpdate
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    object actGetImportSetting_Goods_IsSpecCondition: TdsdExecStoredProc [4]
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
    object actStartLoadIsSpecCondition: TMultiAction [5]
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
    object actDelete_ObjectFloat_Goods_IsSpecCondition: TdsdExecStoredProc [7]
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
    object actDoLoadIsSpecCondition: TExecuteImportSettingsAction [9]
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
    object actShowErased: TBooleanStoredProcAction [10]
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
    inherited ProtocolOpenForm: TdsdOpenForm
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsMainName'
          DataType = ftString
          ParamType = ptInput
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
    object ConditionsKeepChoiceForm: TOpenChoiceForm
      Category = 'Insert'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'ConditionsKeepChoiceForm'
      FormName = 'TConditionsKeepForm'
      FormNameParam.Value = 'TConditionsKeepForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ConditionsKeepId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ConditionsKeepName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
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
        end
        item
          StoredProc = spUpdate_Goods_isUploadBadm
        end
        item
          StoredProc = spUpdate_Goods_isUploadTeva
        end
        item
          StoredProc = spUpdate_Goods_isUploadYuriFarm
        end
        item
          StoredProc = spUpdate_Goods_DiscountExternal
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
        end
        item
          Name = 'inAreaId'
          Value = Null
          Component = GuidesArea
          ComponentItem = 'Key'
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
    object ProtocolOpenTwoForm: TdsdOpenForm
      Category = #1055#1088#1086#1090#1086#1082#1086#1083
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072'2'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072'2'
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdate_Goods_Promo_True: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actExecUpdate_Goods_Promo_True
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082#1072' '#1040#1082#1094#1080#1103' '#1085#1072' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099' '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084'?'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1087#1088#1080#1079#1085#1072#1082#1072' '#1040#1082#1094#1080#1103
      Hint = #1059#1089#1090#1072#1085#1086#1074#1082#1072' '#1087#1088#1080#1079#1085#1072#1082#1072' '#1040#1082#1094#1080#1103
      ImageIndex = 79
    end
    object actExecUpdate_Goods_Promo_True: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Goods_Promo_True
      StoredProcList = <
        item
          StoredProc = spUpdate_Goods_Promo_True
        end>
      Caption = 'actExecUpdate_Goods_Promo_True'
    end
    object actUpdate_Goods_Promo_False: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actExecUpdate_Goods_Promo_False
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1054#1090#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082#1072' '#1040#1082#1094#1080#1103' '#1085#1072' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099' '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084'?'
      Caption = #1054#1090#1084#1077#1085#1072' '#1087#1088#1080#1079#1085#1072#1082#1072' '#1040#1082#1094#1080#1103
      Hint = #1054#1090#1084#1077#1085#1072' '#1087#1088#1080#1079#1085#1072#1082#1072' '#1040#1082#1094#1080#1103
      ImageIndex = 76
    end
    object actExecUpdate_Goods_Promo_False: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Goods_Promo_False
      StoredProcList = <
        item
          StoredProc = spUpdate_Goods_Promo_False
        end>
      Caption = 'actExecUpdate_Goods_Promo_False'
    end
    object DiscountExternalChoiceForm: TOpenChoiceForm
      Category = 'Insert'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'DiscountExternalChoiceForm'
      FormName = 'TDiscountExternalForm'
      FormNameParam.Value = 'TDiscountExternalForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'DiscountExternalId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'DiscountExternalName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actStartLoadAction: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072' '#1072#1082#1094#1080#1080
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting_Goods_Action
        end
        item
          Action = actDoLoadAction
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1040#1082#1094#1080#1080'?'
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1040#1082#1094#1080#1080
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1040#1082#1094#1080#1080
      ImageIndex = 79
    end
    object actGetImportSetting_Goods_Action: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072' '#1072#1082#1094#1080#1080
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSetting_Goods_Аction
      StoredProcList = <
        item
          StoredProc = spGetImportSetting_Goods_Аction
        end>
      Caption = 'actGetImportSetting_Goods_Action'
    end
    object actDoLoadAction: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072' '#1072#1082#1094#1080#1080
      MoveParams = <>
      ImportSettingsId.Value = Null
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingActionId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'inObjectId'
          Value = '0'
          Component = FormParams
          ComponentItem = 'ObjectId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inAreaId'
          Value = '0'
          Component = GuidesArea
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 56
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
    Top = 88
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpenForm'
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpenTwoForm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Goods_Promo_True'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_Goods_Promo_False'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbIsUpdate'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      Caption = '    '
      Hint = '    '
      ShowCaption = False
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
    object bbLabel: TdxBarControlContainerItem
      Caption = 'bbLabel'
      Category = 0
      Hint = 'bbLabel'
      Visible = ivAlways
      Control = cxLabel1
    end
    object bbPartnerCode: TdxBarControlContainerItem
      Caption = 'bbPartnerCode'
      Category = 0
      Hint = 'bbPartnerCode'
      Visible = ivAlways
      Control = edPartnerCode
    end
    object bbIsUpdate: TdxBarControlContainerItem
      Caption = 'bbIsUpdate'
      Category = 0
      Hint = 'bbIsUpdate'
      Visible = ivAlways
      Control = cbUpdate
    end
    object bbStartLoad: TdxBarButton
      Action = actStartLoad
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1084#1080#1085'-'#1086#1077' '#1086#1082#1088#1091#1075#1083'.'
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actStartLoadIsUpload
      Category = 0
    end
    object bbStartLoadConditionsKeep: TdxBarButton
      Action = actStartLoadConditionsKeep
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' <'#1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103'>'
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
    object bbProtocolOpenTwoForm: TdxBarButton
      Action = ProtocolOpenTwoForm
      Category = 0
    end
    object bbUpdate_Goods_Promo_False: TdxBarButton
      Action = actUpdate_Goods_Promo_False
      Category = 0
    end
    object bbUpdate_Goods_Promo_True: TdxBarButton
      Action = actUpdate_Goods_Promo_True
      Category = 0
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = #1047#1072#1075#1088#1091#1079#1082#1080
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          UserDefine = [udPaintStyle]
          UserPaintStyle = psCaptionGlyph
          Visible = True
          ItemName = 'bbStartLoadConditionsKeep'
        end
        item
          UserDefine = [udPaintStyle]
          UserPaintStyle = psCaptionGlyph
          Visible = True
          ItemName = 'bbStartLoad'
        end
        item
          UserDefine = [udPaintStyle]
          UserPaintStyle = psCaptionGlyph
          Visible = True
          ItemName = 'dxBarButton2'
        end
        item
          UserDefine = [udPaintStyle]
          UserPaintStyle = psCaptionGlyph
          Visible = True
          ItemName = 'bbSpecCondition'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end>
    end
    object dxBarButton1: TdxBarButton
      Action = actStartLoadAction
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
    Left = 200
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
    Left = 224
    Top = 168
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
        Value = Null
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
      end
      item
        Name = 'inAreaId'
        Value = Null
        Component = GuidesArea
        ComponentItem = 'Key'
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
        Value = '0'
        Component = PartnerCodeGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ObjectName'
        Value = Null
        Component = PartnerCodeGuides
        ComponentItem = 'TextValue'
        DataType = ftString
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
      end
      item
        Name = 'ImportSettingConditionsKeepId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingActionId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'isUpdate'
        Value = Null
        Component = cbUpdate
        DataType = ftBoolean
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
        Value = Null
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
  object spUpdate_Goods_ConditionsKeep: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_ConditionsKeep'
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
      end
      item
        Name = 'inGoodsCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsCode'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisUpdate'
        Value = Null
        Component = FormParams
        ComponentItem = 'isUpdate'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inConditionsKeepName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ConditionsKeepName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 496
    Top = 432
  end
  object spGetImportSetting_Goods_ConditionsKeep: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 
          'TGoodsPartnerCodeForm;zc_Object_ImportSetting_Goods_ConditionsKe' +
          'ep'
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
        ComponentItem = 'ImportSettingConditionsKeepId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 616
    Top = 400
  end
  object spUpdate_Goods_isUploadBadm: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_isUploadBadm'
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
        Name = 'inisUploadBadm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isUploadBadm'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisUploadBadm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isUploadBadm'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 616
    Top = 87
  end
  object spUpdate_Goods_isUploadTeva: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_isUploadTeva'
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
        Name = 'inisUploadTeva'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isUploadTeva'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisUploadTeva'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isUploadTeva'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 616
    Top = 135
  end
  object GuidesArea: TdsdGuides
    KeyField = 'Id'
    LookupControl = edArea
    Key = '0'
    FormNameParam.Value = 'TAreaForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TAreaForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesArea
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesArea
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 728
  end
  object spUpdate_Goods_isUploadYuriFarm: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_isUploadYuriFarm'
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
        Name = 'inisUploadYuriFarm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isUploadYuriFarm'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisUploadYuriFarm'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isUploadYuriFarm'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 616
    Top = 191
  end
  object spUpdate_Goods_Promo_True: TdsdStoredProc
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
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1016
    Top = 376
  end
  object spUpdate_Goods_Promo_False: TdsdStoredProc
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
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 824
    Top = 376
  end
  object spUpdate_Goods_DiscountExternal: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_DiscountExternal'
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
        Name = 'inDiscountExternalId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DiscountExternalId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 416
  end
  object spGetImportSetting_Goods_Аction: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TGoodsPartnerCodeForm;zc_Object_ImportSetting_Goods_Action'
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
        ComponentItem = 'ImportSettingActionId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 520
    Top = 360
  end
end
