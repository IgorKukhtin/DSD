inherited GoodsCashForm: TGoodsCashForm
  Caption = #1058#1086#1074#1072#1088#1099' '#1089#1077#1090#1080' '#1085#1072#1089#1090#1088#1086#1081#1082#1080' '#1076#1083#1103' '#1082#1072#1089#1089
  ClientHeight = 544
  ClientWidth = 1165
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 1181
  ExplicitHeight = 583
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1165
    Height = 518
    ExplicitWidth = 1165
    ExplicitHeight = 518
    ClientRectBottom = 518
    ClientRectRight = 1165
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1165
      ExplicitHeight = 518
      inherited cxGrid: TcxGrid
        Width = 1165
        Height = 518
        ExplicitWidth = 1165
        ExplicitHeight = 518
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = Name
            end>
          OptionsBehavior.IncSearch = True
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076
            Options.Editing = False
            Width = 80
          end
          object MorionCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1052#1086#1088#1080#1086#1085#1072
            DataBinding.FieldName = 'MorionCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1052#1086#1088#1080#1086#1085#1072
            Options.Editing = False
            Width = 80
          end
          object IdBarCode: TcxGridDBColumn
            Caption = #1064#1090#1088#1080#1093'-'#1082#1086#1076' ('#1072#1087#1090#1077#1082#1072')'
            DataBinding.FieldName = 'IdBarCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1064#1090#1088#1080#1093'-'#1082#1086#1076' ('#1072#1087#1090#1077#1082#1072')'
            Options.Editing = False
            Width = 90
          end
          object BarCode: TcxGridDBColumn
            Caption = #1064#1090#1088#1080#1093'-'#1082#1086#1076' ('#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100')'
            DataBinding.FieldName = 'BarCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1064#1090#1088#1080#1093'-'#1082#1086#1076' ('#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100')'
            Options.Editing = False
            Width = 110
          end
          object Name: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' ('#1085#1072' '#1088#1091#1089'. '#1103#1079#1099#1082#1077')'
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
            Options.Editing = False
            Width = 324
          end
          object NDSKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1053#1044#1057
            DataBinding.FieldName = 'NDSKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042#1080#1076' '#1053#1044#1057
            Options.Editing = False
            Width = 68
          end
          object NDS: TcxGridDBColumn
            Caption = #1053#1044#1057', %'
            DataBinding.FieldName = 'NDS'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1044#1057', %'
            Options.Editing = False
            Width = 68
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1045#1076#1080#1085#1080#1094#1072' '#1080#1079#1084#1077#1088#1077#1085#1080#1103
            Options.Editing = False
            Width = 59
          end
          object ConditionsKeepName: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'ConditionsKeepName'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103
            Options.Editing = False
            Width = 75
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            Options.Editing = False
            Width = 96
          end
          object IsClose: TcxGridDBColumn
            Caption = #1047#1072#1082#1088#1099#1090
            DataBinding.FieldName = 'IsClose'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1072#1082#1088#1099#1090' '#1082#1086#1076' '#1087#1086' '#1074#1089#1077#1081' '#1089#1077#1090#1080
            Options.Editing = False
            Width = 52
          end
          object IsTop: TcxGridDBColumn
            Caption = #1058#1054#1055
            DataBinding.FieldName = 'IsTop'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1054#1055
            Options.Editing = False
            Width = 37
          end
          object isFirst: TcxGridDBColumn
            Caption = '1-'#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isFirst'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = '1-'#1074#1099#1073#1086#1088
            Options.Editing = False
            Width = 60
          end
          object isSecond: TcxGridDBColumn
            Caption = #1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isSecond'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090#1085#1099#1081' '#1074#1099#1073#1086#1088
            Options.Editing = False
            Width = 60
          end
          object isPromo: TcxGridDBColumn
            Caption = #1052#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1081' '#1082#1086#1085#1090#1088#1072#1082#1090
            DataBinding.FieldName = 'isPromo'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1052#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1081' '#1082#1086#1085#1090#1088#1072#1082#1090
            Options.Editing = False
            Width = 100
          end
          object MakerPromoName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074'. '#1084#1072#1088#1082'. '#1082#1086#1085#1090#1088'.'
            DataBinding.FieldName = 'MakerPromoName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 108
          end
          object RetailCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1058#1086#1088#1075#1086#1074#1086#1081' '#1089#1077#1090#1080
            DataBinding.FieldName = 'Code'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1058#1086#1088#1075#1086#1074#1086#1081' '#1089#1077#1090#1080
            Options.Editing = False
            Width = 70
          end
          object RetailName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1058#1086#1088#1075#1086#1074#1086#1081' '#1089#1077#1090#1080
            DataBinding.FieldName = 'Name'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1072#1079#1074#1072#1085#1080#1077' '#1058#1086#1088#1075#1086#1074#1086#1081' '#1089#1077#1090#1080
            Options.Editing = False
            Width = 100
          end
          object isErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1059#1076#1072#1083#1077#1085
            Options.Editing = False
            Width = 51
          end
          object Color_calc: TcxGridDBColumn
            DataBinding.FieldName = 'Color_calc'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
          end
          object isSp: TcxGridDBColumn
            Caption = #1057#1086#1094'. '#1087#1088#1086#1077#1082#1090
            DataBinding.FieldName = 'isSp'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1042' '#1089#1087#1080#1089#1082#1077' '#1087#1088#1086#1077#1082#1090#1072' '#171#1044#1086#1089#1090#1091#1087#1085#1099#1077' '#1083#1077#1082#1072#1088#1089#1090#1074#1072#187
            Options.Editing = False
            Width = 60
          end
          object DoesNotShare: TcxGridDBColumn
            Caption = #1053#1077' '#1076#1077#1083#1080#1090#1100' ('#1092#1072#1088#1084#1072#1094#1077#1074#1090#1099')'
            DataBinding.FieldName = 'DoesNotShare'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1077' '#1076#1077#1083#1080#1090#1100' ('#1092#1072#1088#1084#1072#1094#1077#1074#1090#1099')'
            Width = 60
          end
          object AllowDivision: TcxGridDBColumn
            Caption = #1053#1077' '#1076#1077#1083#1080#1090#1100' '#1085#1072' '#1082#1072#1089#1089#1072#1093
            DataBinding.FieldName = 'AllowDivision'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1077' '#1076#1077#1083#1080#1090#1100' '#1085#1072' '#1082#1072#1089#1089#1072#1093
          end
          object NotTransferTime: TcxGridDBColumn
            Caption = #1053#1077' '#1087#1077#1088#1077#1074#1086#1076#1080#1090#1100' '#1074' '#1089#1088#1086#1082#1080
            DataBinding.FieldName = 'NotTransferTime'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1077' '#1087#1077#1088#1077#1074#1086#1076#1080#1090#1100' '#1074' '#1089#1088#1086#1082#1080
            Options.Editing = False
            Width = 78
          end
          object isExceptionUKTZED: TcxGridDBColumn
            Caption = #1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1087#1086' '#1059#1050#1058#1042#1069#1044
            DataBinding.FieldName = 'isExceptionUKTZED'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1076#1083#1103' '#1079#1072#1087#1088#1077#1090#1072' '#1082' '#1092#1080#1089#1082#1072#1083#1100#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1077' '#1087#1086' '#1059#1050#1058#1042#1069#1044
            Options.Editing = False
            Width = 81
          end
          object isPresent: TcxGridDBColumn
            Caption = #1055#1086#1076#1072#1088#1086#1082
            DataBinding.FieldName = 'isPresent'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1076#1072#1088#1086#1082'. '#1041#1083#1086#1082#1080#1088#1091#1077#1090#1100#1089#1103' '#1087#1088#1086#1076#1072#1078#1072' '#1085#1072' '#1082#1072#1089#1089#1072#1093
            Options.Editing = False
            Width = 61
          end
          object isOnlySP: TcxGridDBColumn
            Caption = #1058#1086#1083#1100#1082#1086' '#1076#1083#1103' '#1057#1055' "'#1044#1086#1089#1090#1091#1087#1085#1110' '#1083#1110#1082#1080'"'
            DataBinding.FieldName = 'isOnlySP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 72
          end
          object Multiplicity: TcxGridDBColumn
            Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1080' ('#1084#1080#1085#1080#1084#1072#1083#1100#1085#1099#1081' '#1076#1077#1083#1080#1090#1077#1083#1100')'
            DataBinding.FieldName = 'Multiplicity'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.###; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object isMultiplicityError: TcxGridDBColumn
            Caption = #1055#1086#1075#1088#1077#1096#1085#1086#1089#1090#1100' '#1076#1083#1103' '#1082#1088#1072#1090#1085#1086#1089#1090#1080' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'isMultiplicityError'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 88
          end
        end
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 67
    Top = 312
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end>
  end
  inherited ActionList: TActionList
    Left = 103
    Top = 255
    inherited actRefresh: TdsdDataSetRefresh
      Category = 'Refresh'
    end
    inherited actInsert: TInsertUpdateChoiceAction
      MoveParams = <
        item
          FromParam.Value = '0'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.MultiSelectSeparator = ','
        end>
      FormName = 'TGoodsEditForm'
      FormNameParam.Value = 'TGoodsEditForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      DataSetRefresh = mactAfterInsert
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TGoodsEditForm'
      FormNameParam.Value = 'TGoodsEditForm'
      DataSetRefresh = spRefreshOneRecord
    end
    object InsertRecord1: TInsertRecord [4]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Params = <>
      Caption = 'InsertRecord1'
    end
    inherited dsdSetErased: TdsdUpdateErased
      QuestionBeforeExecute = #1059#1076#1072#1083#1080#1090#1100' '#1090#1086#1074#1072#1088'?'
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
    object macSimpleUpdateNDS: TMultiAction [8]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateNDS
        end>
      View = cxGridDBTableView
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1053#1044#1057' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1087#1088#1072#1081#1089#1072
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1053#1044#1057' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1087#1088#1072#1081#1089#1072
    end
    object mactAfterInsert: TMultiAction [9]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = InsertRecord1
        end
        item
          Action = spRefreshOnInsert
        end
        item
          Action = DataSetPost1
        end>
      Caption = 'mactAfterInsert'
    end
    object macUpdateNDS: TMultiAction [10]
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macSimpleUpdateNDS
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1054#1073#1085#1086#1074#1080#1090#1100' '#1053#1044#1057' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1087#1088#1072#1081#1089#1072'? '
      InfoAfterExecute = #1053#1044#1057' '#1086#1073#1085#1086#1074#1083#1077#1085#1086' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1087#1088#1072#1081#1089#1072
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1053#1044#1057' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1087#1088#1072#1081#1089#1072
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1053#1044#1057' '#1089#1086#1075#1083#1072#1089#1085#1086' '#1087#1088#1072#1081#1089#1072
      ImageIndex = 76
    end
    object actUpdateNDS: TdsdExecStoredProc [11]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actUpdateNDS'
    end
    object spRefreshOneRecord: TdsdDataSetRefresh
      Category = 'Refresh'
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
    object macUpdateNot_No: TMultiAction
      Category = 'UpdateNot'
      MoveParams = <>
      ActionList = <
        item
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082'> = '#1053#1045#1058'? '
      InfoAfterExecute = #1047#1085#1072#1095#1077#1085#1080#1077' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082'> '#1091#1089#1090#1072#1085#1086#1074#1083#1077#1085#1086
      Caption = '<'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082'> = '#1053#1045#1058
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082'> = '#1053#1045#1058
      ImageIndex = 52
    end
    object DataSetInsert1: TDataSetInsert
      Category = 'Dataset'
      Caption = '&Insert'
      Hint = 'Insert'
      ImageIndex = 73
      DataSource = MasterDS
    end
    object DataSetPost1: TDataSetPost
      Category = 'Dataset'
      Caption = 'P&ost'
      Hint = 'Post'
      ImageIndex = 74
      DataSource = MasterDS
    end
    object spRefreshOnInsert: TdsdExecStoredProc
      Category = 'Refresh'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetOnInsert
      StoredProcList = <
        item
          StoredProc = spGetOnInsert
        end>
      Caption = 'spRefreshOnInsert'
    end
    object UpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end
        item
          StoredProc = spUpdate_Goods_DoesNotShare
        end
        item
          StoredProc = spUpdate_Goods_AllowDivision
        end>
      Caption = 'UpdateDataSet'
      DataSource = MasterDS
    end
    object actUpdateExceptionUKTZED: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = execUpdate_ExceptionUKTZED
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1076#1083#1103' '#1079#1072#1087#1088#1077#1090#1072' '#1082' '#1092#1080#1089#1082#1072#1083#1100#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1077' '#1087#1086 +
        ' '#1059#1050#1058#1042#1069#1044'"? '
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1076#1083#1103' '#1079#1072#1087#1088#1077#1090#1072' '#1082' '#1092#1080#1089#1082#1072#1083#1100#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1077' '#1087#1086 +
        ' '#1059#1050#1058#1042#1069#1044'"'
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1076#1083#1103' '#1079#1072#1087#1088#1077#1090#1072' '#1082' '#1092#1080#1089#1082#1072#1083#1100#1085#1086#1081' '#1087#1088#1086#1076#1072#1078#1077' '#1087#1086 +
        ' '#1059#1050#1058#1042#1069#1044'"'
      ImageIndex = 79
    end
    object execUpdate_ExceptionUKTZED: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_inExceptionUKTZED_Revert
      StoredProcList = <
        item
          StoredProc = spUpdate_inExceptionUKTZED_Revert
        end>
      Caption = 'execUpdate_ExceptionUKTZED'
    end
    object actUpdate_inPresent_Revert: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = execUpdate_inPresent_Revert
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1076#1072#1088#1086#1082'"?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1076#1072#1088#1086#1082'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1076#1072#1088#1086#1082'"'
      ImageIndex = 79
    end
    object execUpdate_inPresent_Revert: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_inPresent_Revert
      StoredProcList = <
        item
          StoredProc = spUpdate_inPresent_Revert
        end>
      Caption = 'execUpdate_inPresent_Revert'
    end
    object maUpdate_isOnlySP: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actExecUpdate_isOnlySP
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1058#1086#1083#1100#1082#1086' '#1076#1083#1103' '#1057#1055' "'#1044#1086#1089#1090#1091#1087#1085#1110' '#1083#1110#1082#1080'"?'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1058#1086#1083#1100#1082#1086' '#1076#1083#1103' '#1057#1055' "'#1044#1086#1089#1090#1091#1087#1085#1110' '#1083#1110#1082#1080'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1058#1086#1083#1100#1082#1086' '#1076#1083#1103' '#1057#1055' "'#1044#1086#1089#1090#1091#1087#1085#1110' '#1083#1110#1082#1080'"'
      ImageIndex = 79
    end
    object actExecUpdate_isOnlySP: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isOnlySP_Revert
      StoredProcList = <
        item
          StoredProc = spUpdate_isOnlySP_Revert
        end>
      Caption = 'actExecUpdate_isOnlySP'
    end
    object actUpdate_Multiplicity: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = astExecuteDialogMultiplicity
      ActionList = <
        item
          Action = actExecUpfdate_Multiplicity
        end>
      View = cxGridDBTableView
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1077'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1077'"'
      ImageIndex = 43
    end
    object actExecUpfdate_Multiplicity: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Multiplicity
      StoredProcList = <
        item
          StoredProc = spUpdate_Multiplicity
        end>
      Caption = 'actExecUpfdate_Multiplicity'
    end
    object astExecuteDialogMultiplicity: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actExecuteDialogUpdate_PercentWagesStore'
      FormName = 'TAmountDialogForm'
      FormNameParam.Value = 'TAmountDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Amount'
          Value = Null
          Component = FormParams
          ComponentItem = 'Multiplicity'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Label'
          Value = 
            #1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1080#1077#1084#1072' '#1090#1086#1074#1072#1088#1072' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076#1083#1103' '#1082 +
            #1083#1072#1076#1086#1074#1097#1080#1082#1072
          Component = FormParams
          ComponentItem = 'MultiplicityLabel'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object maUpdate_isMultiplicityError: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      ActionList = <
        item
          Action = actExecUpdate_isMultiplicityError
        end>
      View = cxGridDBTableView
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1075#1088#1077#1096#1085#1086#1089#1090#1100' '#1076#1083#1103' '#1082#1088#1072#1090#1085#1086#1089#1090#1080' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1080'"?'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1075#1088#1077#1096#1085#1086#1089#1090#1100' '#1076#1083#1103' '#1082#1088#1072#1090#1085#1086#1089#1090#1080' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1080'"'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1075#1088#1077#1096#1085#1086#1089#1090#1100' '#1076#1083#1103' '#1082#1088#1072#1090#1085#1086#1089#1090#1080' '#1087#1088#1080' '#1087#1088#1086#1076#1072#1078#1080'"'
      ImageIndex = 79
    end
    object actExecUpdate_isMultiplicityError: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isMultiplicityError_Revert
      StoredProcList = <
        item
          StoredProc = spUpdate_isMultiplicityError_Revert
        end>
      Caption = 'actExecUpdate_isMultiplicityError'
    end
    object actUpdateAdditional: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1058#1086#1074#1072#1088#1072'>'
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1058#1086#1074#1072#1088#1072'>'
      ShortCut = 16499
      ImageIndex = 43
      FormName = 'TGoodsAdditionalEditForm'
      FormNameParam.Value = 'TGoodsAdditionalEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
      ActionType = acUpdate
      DataSource = MasterDS
      DataSetRefresh = spRefreshOneRecord
      IdFieldName = 'Id'
    end
    object ProtocolOpenMainForm: TdsdOpenForm
      Category = #1055#1088#1086#1090#1086#1082#1086#1083
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1075#1083#1072#1074#1085#1086#1075#1086' '#1090#1086#1074#1072#1088#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072' '#1075#1083#1072#1074#1085#1086#1075#1086' '#1090#1086#1074#1072#1088#1072
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
          ComponentItem = 'GoodsMainId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdateGoodsAdditional: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateGoodsAdditional
      StoredProcList = <
        item
          StoredProc = spUpdateGoodsAdditional
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1058#1086#1074#1072#1088'> '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1058#1086#1074#1072#1088'> '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
    end
    object actDialogGoodsAdditional: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = False
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'inis_MakerName'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = False
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'inis_FormDispensing'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = False
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'inis_NumberPlates'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = False
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'inis_QtyPackage'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = False
          FromParam.DataType = ftBoolean
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = False
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'inis_IsRecipe'
          ToParam.DataType = ftBoolean
          ToParam.MultiSelectSeparator = ','
        end>
      Caption = 'actDialogGoodsAdditional'
      FormName = 'TGoodsAdditionalEditDialogForm'
      FormNameParam.Value = 'TGoodsAdditionalEditDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'MakerName'
          Value = ''
          Component = FormParams
          ComponentItem = 'MakerName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'FormDispensingId'
          Value = Null
          Component = FormParams
          ComponentItem = 'FormDispensingId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'NumberPlates'
          Value = Null
          Component = FormParams
          ComponentItem = 'NumberPlates'
          MultiSelectSeparator = ','
        end
        item
          Name = 'QtyPackage'
          Value = Null
          Component = FormParams
          ComponentItem = 'QtyPackage'
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsRecipe'
          Value = Null
          Component = FormParams
          ComponentItem = 'IsRecipe'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis_MakerName'
          Value = Null
          Component = FormParams
          ComponentItem = 'inis_MakerName'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis_FormDispensing'
          Value = Null
          Component = FormParams
          ComponentItem = 'inis_FormDispensing'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis_NumberPlates'
          Value = Null
          Component = FormParams
          ComponentItem = 'inis_NumberPlates'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis_QtyPackage'
          Value = Null
          Component = FormParams
          ComponentItem = 'inis_QtyPackage'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inis_IsRecipe'
          Value = Null
          Component = FormParams
          ComponentItem = 'inis_IsRecipe'
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object mactUpdateGoodsAdditional: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      BeforeAction = actDialogGoodsAdditional
      ActionList = <
        item
          Action = actUpdateGoodsAdditional
        end>
      View = cxGridDBTableView
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1058#1086#1074#1072#1088#1072'> '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1076#1072#1085#1085#1099#1077' '#1058#1086#1074#1072#1088#1072'> '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      ImageIndex = 43
    end
  end
  inherited MasterDS: TDataSource
    Left = 56
    Top = 80
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
    Left = 24
    Top = 88
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Goods_Cash'
    Params = <
      item
        Name = 'inContractId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRetailId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 144
    Top = 88
  end
  inherited BarManager: TdxBarManager
    Left = 40
    Top = 168
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bbEdit'
        end
        item
          Visible = True
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateAdditional'
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
          ItemName = 'bbChoiceGuides'
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
          ItemName = 'bsUpdate'
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
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpenForm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton14'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      Style = dmMain.cxFooterStyle
      ShowCaption = False
    end
    object bbPublished: TdxBarButton
      Caption = #1057#1076#1077#1083#1072#1090#1100' '#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' = '#1053#1045#1058
      Category = 0
      Hint = #1057#1076#1077#1083#1072#1090#1100' '#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' = '#1053#1045#1058
      Visible = ivAlways
      ImageIndex = 58
    end
    object bbLabel3: TdxBarControlContainerItem
      Caption = 'Label3'
      Category = 0
      Hint = 'Label3'
      Visible = ivAlways
    end
    object bbContract: TdxBarControlContainerItem
      Caption = 'Contract'
      Category = 0
      Hint = 'Contract'
      Visible = ivAlways
    end
    object bbUpdateNDS: TdxBarButton
      Action = macUpdateNDS
      Category = 0
    end
    object bbUpdate_CountPrice: TdxBarButton
      Caption = #1054#1073#1085#1086#1074#1080#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1072#1081#1089#1086#1074
      Category = 0
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1072#1081#1089#1086#1074' '#1087#1086' '#1074#1089#1077#1084' '#1089#1077#1090#1103#1084
      Style = dmMain.cxContentStyle
      Visible = ivAlways
      PaintStyle = psCaption
    end
    object bbStartLoad: TdxBarButton
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1062#1077#1085#1099
      Category = 0
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1062#1077#1085#1099
      Visible = ivAlways
      ImageIndex = 41
    end
    object bbUpdateNotMarion_Yes: TdxBarButton
      Caption = '<'#1053#1077' '#1087#1088#1080#1074#1103#1079#1099#1074#1072#1090#1100' '#1082#1086#1076' '#1052#1072#1088#1080#1086#1085'> = '#1044#1072
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1053#1077' '#1087#1088#1080#1074#1103#1079#1099#1074#1072#1090#1100' '#1082#1086#1076' '#1052#1072#1088#1080#1086#1085'> = '#1044#1072
      Visible = ivAlways
      ImageIndex = 76
    end
    object bbUpdateNotMarion_No: TdxBarButton
      Caption = '<'#1053#1077' '#1087#1088#1080#1074#1103#1079#1099#1074#1072#1090#1100' '#1082#1086#1076' '#1052#1072#1088#1080#1086#1085'> = '#1053#1045#1058
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1053#1077' '#1087#1088#1080#1074#1103#1079#1099#1074#1072#1090#1100' '#1082#1086#1076' '#1052#1072#1088#1080#1086#1085'> = '#1053#1045#1058
      Visible = ivAlways
      ImageIndex = 77
    end
    object bbUpdateNot_Yes: TdxBarButton
      Caption = '<'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082'> = '#1044#1072
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082'> = '#1044#1072
      Visible = ivAlways
      ImageIndex = 79
    end
    object bbUpdateNot_No: TdxBarButton
      Action = macUpdateNot_No
      Category = 0
    end
    object bbUpdateNot_v2_Yes: TdxBarButton
      Caption = '<'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2> = '#1044#1072
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2> = '#1044#1072
      Visible = ivAlways
      ImageIndex = 7
    end
    object bbUpdateNot_v2_No: TdxBarButton
      Caption = '<'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2> = '#1053#1045#1058
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2> = '#1053#1045#1058
      Visible = ivAlways
      ImageIndex = 77
    end
    object bbUpdate_isSun_v3_yes: TdxBarButton
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' = '#1044#1040
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053'> = '#1044#1040
      Visible = ivAlways
      ImageIndex = 79
    end
    object bbUpdate_isSun_v3_No: TdxBarButton
      Caption = #1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053' = '#1053#1045#1058
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1056#1072#1073#1086#1090#1072#1102#1090' '#1087#1086' '#1069'-'#1057#1059#1053'> = '#1053#1045#1058
      Visible = ivAlways
      ImageIndex = 58
    end
    object bbSetClose: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1047#1072#1082#1088#1099#1090'"'
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1047#1072#1082#1088#1099#1090'"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object bbClearClose: TdxBarButton
      Caption = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1047#1072#1082#1088#1099#1090'"'
      Category = 0
      Hint = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1047#1072#1082#1088#1099#1090'"'
      Visible = ivAlways
      ImageIndex = 58
    end
    object bbinResolution_224_No: TdxBarButton
      Caption = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1072#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224"'
      Category = 0
      Hint = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1072#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224"'
      Visible = ivAlways
      ImageIndex = 58
    end
    object bbisResolution_224_Yes: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1072#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224"'
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1055#1086#1072#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object bbUpdate_inTop_Yes: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1058#1054#1055'"'
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1058#1054#1055'"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object bbUpdate_inTop_No: TdxBarButton
      Caption = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1058#1054#1055'"'
      Category = 0
      Hint = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1058#1054#1055'"'
      Visible = ivAlways
      ImageIndex = 58
    end
    object bbUpdate_isNot_Sun_v4_yes: TdxBarButton
      Caption = '<'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2-'#1055#1048'> = '#1044#1040
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2-'#1055#1048'> = '#1044#1040
      Visible = ivAlways
      ImageIndex = 7
    end
    object bbUpdate_isNot_Sun_v4_No: TdxBarButton
      Caption = '<'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2-'#1055#1048'> = '#1053#1045#1058
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1053#1054#1058'-'#1085#1077#1087#1077#1088#1077#1084#1077#1097#1072#1077#1084#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' '#1076#1083#1103' '#1057#1059#1053'-v2-'#1055#1048'> = '#1053#1045#1058
      Visible = ivAlways
      ImageIndex = 77
    end
    object bbUpdateGoods_KoeffSUN: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1088#1072#1090#1085#1086#1089#1090#1080' '#1087#1086' '#1057#1059#1053' (v1, v2, v2-'#1055#1048')'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1050#1088#1072#1090#1085#1086#1089#1090#1080' '#1087#1086' '#1057#1059#1053' (v1, v2, v3)'
      Visible = ivAlways
      ImageIndex = 43
    end
    object bbUpdateGoods_LimitSUN: TdxBarButton
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1054#1089#1090#1072#1090#1086#1082', '#1087#1088#1080' '#1082#1086#1090#1086#1088#1086#1084' '#1088#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1057#1059#1053' v2, v2-'#1055#1048' '#1079#1085#1072#1095#1077#1085#1080#1103' ' +
        #1058'1'
      Category = 0
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1054#1089#1090#1072#1090#1086#1082', '#1087#1088#1080' '#1082#1086#1090#1086#1088#1086#1084' '#1088#1072#1089#1095#1077#1090' '#1076#1083#1103' '#1057#1059#1053' v2, v2-'#1055#1048' '#1079#1085#1072#1095#1077#1085#1080#1103' ' +
        #1058'1'
      Visible = ivAlways
      ImageIndex = 43
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = 'New SubItem'
      Category = 0
      Visible = ivAlways
      ItemLinks = <>
    end
    object dxBarButton1: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1044#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053'1"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1044#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053'1"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object dxBarButton2: TdxBarButton
      Action = actUpdateExceptionUKTZED
      Category = 0
    end
    object bsUpdate: TdxBarSubItem
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 79
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbUpdateExceptionUKTZED'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_inPresent_Revert'
        end
        item
          Visible = True
          ItemName = 'dxBarButton10'
        end
        item
          Visible = True
          ItemName = 'dxBarButton12'
        end
        item
          Visible = True
          ItemName = 'dxBarButton11'
        end>
    end
    object bbUpdateInvisibleSUN: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077#1074#1080#1076#1080#1084#1082#1072' '#1076#1083#1103' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1081' '#1087#1086' '#1057#1059#1053'"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077#1074#1080#1076#1080#1084#1082#1072' '#1076#1083#1103' '#1086#1075#1088#1072#1085#1080#1095#1077#1085#1080#1081' '#1087#1086' '#1057#1059#1053'"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object bbUpdateisSupplementSUN1: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1044#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053'1"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1044#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1057#1059#1053'1"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object bbUpdateExceptionUKTZED: TdxBarButton
      Action = actUpdateExceptionUKTZED
      Category = 0
    end
    object dxBarSubItem2: TdxBarSubItem
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 79
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbUpdateNotMarion_Yes'
        end
        item
          Visible = True
          ItemName = 'bbSetClose'
        end
        item
          Visible = True
          ItemName = 'bbisResolution_224_Yes'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_inTop_Yes'
        end
        item
          Visible = True
          ItemName = 'bbtUpdate_isFirst_Yes'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_isSecond_Yes'
        end>
    end
    object dxBarSubItem3: TdxBarSubItem
      Caption = #1057#1085#1103#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 58
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbUpdateNotMarion_No'
        end
        item
          Visible = True
          ItemName = 'bbClearClose'
        end
        item
          Visible = True
          ItemName = 'bbinResolution_224_No'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_inTop_No'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_isFirst_No'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_isSecond_No'
        end>
    end
    object dxBarSubItem4: TdxBarSubItem
      Action = actUpdate_inPresent_Revert
      Category = 0
      ItemLinks = <>
    end
    object bbUpdate_inPresent_Revert: TdxBarButton
      Action = actUpdate_inPresent_Revert
      Category = 0
    end
    object dxBarButton3: TdxBarButton
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' "'#1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076 +
        #1083#1103' '#1087#1077#1088#1074#1086#1089#1090#1086#1083#1100#1085#1080#1082#1072'"'
      Category = 0
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' "'#1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076 +
        #1083#1103' '#1087#1077#1088#1074#1086#1089#1090#1086#1083#1100#1085#1080#1082#1072'"'
      Visible = ivAlways
      ImageIndex = 43
    end
    object dxBarButton4: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "% '#1086#1090' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076#1083#1103' '#1087#1077#1088#1074#1086#1089#1090#1086#1083#1100#1085#1080#1082#1072'"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "% '#1086#1090' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076#1083#1103' '#1087#1077#1088#1074#1086#1089#1090#1086#1083#1100#1085#1080#1082#1072'"'
      Visible = ivAlways
      ImageIndex = 43
    end
    object dxBarButton5: TdxBarButton
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1082' '#1057#1059#1053'1'
      Category = 0
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1077' '#1082' '#1057#1059#1053'1'
      Visible = ivAlways
      ImageIndex = 66
    end
    object dxBarButton6: TdxBarButton
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' "'#1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1080#1077#1084#1072' '#1090#1086#1074#1072#1088#1072' '#1074' '#1079#1072#1088#1087 +
        #1083#1072#1090#1091' '#1076#1083#1103' '#1082#1083#1072#1076#1086#1074#1097#1080#1082#1072'"'
      Category = 0
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' "'#1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1080#1077#1084#1072' '#1090#1086#1074#1072#1088#1072' '#1074' '#1079#1072#1088#1087 +
        #1083#1072#1090#1091' '#1076#1083#1103' '#1082#1083#1072#1076#1086#1074#1097#1080#1082#1072'"'
      Visible = ivAlways
      ImageIndex = 43
    end
    object dxBarButton7: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "% '#1086#1090' '#1087#1088#1080#1077#1084#1072' '#1090#1086#1074#1072#1088#1072' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076#1083#1103' '#1082#1083#1072#1076#1086#1074#1097#1080#1082#1072'"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "% '#1086#1090' '#1087#1088#1080#1077#1084#1072' '#1090#1086#1074#1072#1088#1072' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076#1083#1103' '#1082#1083#1072#1076#1086#1074#1097#1080#1082#1072'"'
      Visible = ivAlways
      ImageIndex = 43
    end
    object dxBarButton8: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1057#1059#1053'1"'
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1057#1059#1053'1"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object dxBarButton9: TdxBarButton
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100' "'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1057#1059#1053'1"'
      Category = 0
      Hint = #1054#1095#1080#1089#1090#1080#1090#1100' "'#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1076#1083#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1087#1086' '#1076#1086#1087#1086#1083#1085#1077#1085#1080#1102' '#1057#1059#1053'1"'
      Visible = ivAlways
      ImageIndex = 76
    end
    object dxBarButton10: TdxBarButton
      Action = maUpdate_isOnlySP
      Category = 0
    end
    object dxBarButton11: TdxBarButton
      Action = actUpdate_Multiplicity
      Category = 0
    end
    object dxBarButton12: TdxBarButton
      Action = maUpdate_isMultiplicityError
      Category = 0
    end
    object dxBarButton13: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "% '#1085#1072#1094#1077#1085#1082#1080'" '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' "% '#1085#1072#1094#1077#1085#1082#1080'" '#1087#1086#1076' '#1092#1080#1083#1100#1090#1088#1086#1084
      Visible = ivAlways
      ImageIndex = 43
    end
    object bbUpdateAdditional: TdxBarButton
      Action = actUpdateAdditional
      Category = 0
    end
    object dxBarButton14: TdxBarButton
      Action = ProtocolOpenMainForm
      Category = 0
    end
    object dxBarButton15: TdxBarButton
      Action = mactUpdateGoodsAdditional
      Category = 0
    end
    object dxBarButton16: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1087#1086' '#1089#1088#1086#1082#1091' '#1075#1086#1076#1085#1086#1089#1090#1080' ('#1076#1083#1103' '#1089#1072#1081#1090#1072')"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1048#1089#1082#1083#1102#1095#1077#1085#1080#1077' '#1087#1086' '#1089#1088#1086#1082#1091' '#1075#1086#1076#1085#1086#1089#1090#1080' ('#1076#1083#1103' '#1089#1072#1081#1090#1072')"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object dxBarButton17: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1082#1080#1076#1082#1091' '#1076#1083#1103' '#1089#1072#1081#1090#1072
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1082#1080#1076#1082#1091' '#1076#1083#1103' '#1089#1072#1081#1090#1072
      Visible = ivAlways
      ImageIndex = 43
    end
    object dxBarButton18: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object bbtUpdate_isFirst_Yes: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "1-'#1074#1099#1073#1086#1088'"'
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "1-'#1074#1099#1073#1086#1088'"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object bbUpdate_isSecond_Yes: TdxBarButton
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088'"'
      Category = 0
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088'"'
      Visible = ivAlways
      ImageIndex = 79
    end
    object bbUpdate_isFirst_No: TdxBarButton
      Caption = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "1-'#1074#1099#1073#1086#1088'"'
      Category = 0
      Hint = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "1-'#1074#1099#1073#1086#1088'"'
      Visible = ivAlways
      ImageIndex = 77
    end
    object bbUpdate_isSecond_No: TdxBarButton
      Caption = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088'"'
      Category = 0
      Hint = #1057#1085#1103#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088'"'
      Visible = ivAlways
      ImageIndex = 77
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
    ColorRuleList = <
      item
        ColorColumn = IsTop
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = Code
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = GoodsGroupName
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = IsClose
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = isFirst
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = MeasureName
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = Name
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = NDSKindName
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = isSecond
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = isPromo
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = ConditionsKeepName
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end>
    SearchAsFilter = False
    Left = 344
    Top = 176
  end
  inherited PopupMenu: TPopupMenu
    Left = 144
    Top = 256
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Goods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'Id'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = MasterCDS
        ComponentItem = 'Code'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'Name'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'GoodsGroupId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupName'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'GoodsGroupName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'MeasureId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureName'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'MeasureName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'NDSKindId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'NdsKindId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'NDSKindName'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'NDSKindName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MinimumLot'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MinimumLot'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'isClose'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isClose'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isTop'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isTop'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentMarkup'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PercentMarkup'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MorionCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MorionCode'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BarCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BarCode'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MakerName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MakerName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormDispensingId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'FormDispensingId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormDispensingName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'FormDispensingName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'NumberPlates'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'NumberPlates'
        MultiSelectSeparator = ','
      end
      item
        Name = 'QtyPackage'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'QtyPackage'
        MultiSelectSeparator = ','
      end
      item
        Name = 'isRecipe'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isRecipe'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 240
    Top = 144
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentMarkup'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'Price'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeffSUN_v1'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeffSUN_v2'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeffSUN_v4'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inKoeffSUN_Supplementv1'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_v1'
        Value = 'false'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_v2'
        Value = 'false'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_v4'
        Value = 'false'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_Supplementv1'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummaWages'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LabelSummaWages'
        Value = 
          #1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076#1083#1103' '#1087#1077#1088#1074#1086#1089#1090 +
          #1086#1083#1100#1085#1080#1082#1072
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentWages'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LabelPercentWages'
        Value = '% '#1086#1090' '#1087#1088#1086#1076#1072#1078#1080' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076#1083#1103' '#1087#1077#1088#1074#1086#1089#1090#1086#1083#1100#1085#1080#1082#1072
        MultiSelectSeparator = ','
      end
      item
        Name = 'SummaWagesStore'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LabelSummaWagesStore'
        Value = 
          #1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1080#1077#1084#1072' '#1090#1086#1074#1072#1088#1072' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076#1083#1103' '#1082 +
          #1083#1072#1076#1086#1074#1097#1080#1082#1072
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentWagesStore'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'LabelPercentWagesStore'
        Value = 
          #1057#1090#1072#1090#1080#1095#1080#1089#1082#1086#1077' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1079#1072' 1 '#1077#1076#1080#1085#1080#1094#1091' '#1087#1088#1080#1077#1084#1072' '#1090#1086#1074#1072#1088#1072' '#1074' '#1079#1072#1088#1087#1083#1072#1090#1091' '#1076#1083#1103' '#1082 +
          #1083#1072#1076#1086#1074#1097#1080#1082#1072
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitSupplementSUN1'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'Multiplicity'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'MultiplicityLabel'
        Value = #1042#1074#1077#1076#1080#1090#1077' "'#1050#1088#1072#1090#1085#1086#1089#1090#1100' '#1087#1088#1080' '#1087#1088#1080#1076#1072#1078#1077'"'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentMarkup'
        Value = 0.000000000000000000
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PercentMarkupLabel'
        Value = #1042#1074#1077#1076#1080#1090#1077' % '#1085#1072#1094#1077#1085#1082#1080
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MakerName'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormDispensingId'
        Value = '0'
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'NumberPlates'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'QtyPackage'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'IsRecipe'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_MakerName'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_FormDispensing'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_NumberPlates'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_QtyPackage'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_IsRecipe'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscontSiteStart'
        Value = '01.01.2016'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscontSiteEnd'
        Value = '01.01.2016'
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscontPercentSite'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiscontAmountSite'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 240
    Top = 64
  end
  object spGetOnInsert: TdsdStoredProc
    StoredProcName = 'gpGet_Object_Goods'
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
        Name = 'Id'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Code'
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Name'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsGroupId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'GoodsGroupName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsGroupName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MeasureId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'MeasureName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MeasureName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'NDSKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'NdsKindId'
        MultiSelectSeparator = ','
      end
      item
        Name = 'NDSKindName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'NDSKindName'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MorionCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MorionCode'
        MultiSelectSeparator = ','
      end
      item
        Name = 'BarCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BarCode'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 240
    Top = 208
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <>
    Left = 336
    Top = 104
  end
  object spUpdate_Goods_DoesNotShare: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_DoesNotShare'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDoesNotShare'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DoesNotShare'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outDoesNotShare'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'DoesNotShare'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 840
    Top = 184
  end
  object spUpdate_Goods_AllowDivision: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_AllowDivision'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAllowDivision'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AllowDivision'
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 472
    Top = 256
  end
  object spUpdate_inExceptionUKTZED_Revert: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_inExceptionUKTZED_Revert'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsMainId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsMainId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisExceptionUKTZED'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isExceptionUKTZED'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 840
    Top = 288
  end
  object spUpdate_inPresent_Revert: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_inPresent_Revert'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsMainId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsMainId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPresent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPresent'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 680
    Top = 200
  end
  object spUpdate_isOnlySP_Revert: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_isOnlySP_Revert'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsMainId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsMainId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisOnlySP'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isOnlySP'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 664
    Top = 280
  end
  object spUpdate_Multiplicity: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_Multiplicity'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsMainId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsMainId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMultiplicity'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'Multiplicity'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 472
    Top = 112
  end
  object spUpdate_isMultiplicityError_Revert: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_isMultiplicityError_Revert'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsMainId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsMainId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMultiplicityError'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isMultiplicityError'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 48
    Top = 216
  end
  object spUpdateGoodsAdditional: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_GoodsAdditionalFilter'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsMainId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMakerName'
        Value = ''
        Component = FormParams
        ComponentItem = 'MakerName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_MakerName'
        Value = Null
        Component = FormParams
        ComponentItem = 'inis_MakerName'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFormDispensingId'
        Value = ''
        Component = FormParams
        ComponentItem = 'FormDispensingId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_FormDispensing'
        Value = Null
        Component = FormParams
        ComponentItem = 'inis_FormDispensing'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNumberPlates'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'NumberPlates'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_NumberPlates'
        Value = Null
        Component = FormParams
        ComponentItem = 'inis_NumberPlates'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inQtyPackage'
        Value = 0.000000000000000000
        Component = FormParams
        ComponentItem = 'QtyPackage'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_QtyPackage'
        Value = Null
        Component = FormParams
        ComponentItem = 'inis_QtyPackage'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsRecipe'
        Value = False
        Component = FormParams
        ComponentItem = 'IsRecipe'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inis_IsRecipe'
        Value = Null
        Component = FormParams
        ComponentItem = 'inis_IsRecipe'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 136
    Top = 200
  end
end
