inherited Goods_NDS_diffForm: TGoods_NDS_diffForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1089#1077#1090#1080' ('#1080#1079#1084#1077#1085#1077#1085#1080#1077' '#1053#1044#1057' '#1087#1086#1089#1090'.)'
  ClientHeight = 449
  ClientWidth = 883
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 899
  ExplicitHeight = 488
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 883
    Height = 423
    ExplicitWidth = 883
    ExplicitHeight = 423
    ClientRectBottom = 423
    ClientRectRight = 883
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 883
      ExplicitHeight = 423
      inherited cxGrid: TcxGrid
        Width = 883
        Height = 423
        ExplicitWidth = 883
        ExplicitHeight = 423
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
            Options.Editing = False
            Width = 80
          end
          object MorionCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1052#1086#1088#1080#1086#1085#1072
            DataBinding.FieldName = 'MorionCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object IdBarCode: TcxGridDBColumn
            Caption = #1064#1090#1088#1080#1093'-'#1082#1086#1076' ('#1072#1087#1090#1077#1082#1072')'
            DataBinding.FieldName = 'IdBarCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object BarCode: TcxGridDBColumn
            Caption = #1064#1090#1088#1080#1093'-'#1082#1086#1076' ('#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100')'
            DataBinding.FieldName = 'BarCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object Name: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
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
            Options.Editing = False
            Width = 68
          end
          object NDS_PriceList: TcxGridDBColumn
            Caption = #1053#1044#1057' '#1087#1086#1089#1090'.'
            DataBinding.FieldName = 'NDS_PriceList'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1053#1044#1057' '#1074' '#1087#1088#1072#1081#1089#1077' '#1042#1099#1073#1088#1072#1085#1085#1086#1075#1086' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 49
          end
          object isNDS_dif: TcxGridDBColumn
            Caption = #1054#1090#1082#1083'. '#1087#1086' '#1053#1044#1057
            DataBinding.FieldName = 'isNDS_dif'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1087#1086' '#1053#1044#1057' '#1074' '#1087#1088#1072#1081#1089#1077' '#1080' '#1090#1086#1074#1072#1088#1077
            Width = 52
          end
          object OrdPrice: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1090#1086#1074'. '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            DataBinding.FieldName = 'OrdPrice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1090#1086#1074#1072#1088#1086#1074' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' '#1074' '#1087#1088#1072#1081#1089#1077
            Options.Editing = False
            Width = 50
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 59
          end
          object ConditionsKeepName: TcxGridDBColumn
            Caption = #1059#1089#1083#1086#1074#1080#1103' '#1093#1088#1072#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'ConditionsKeepName'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 96
          end
          object MinimumLot: TcxGridDBColumn
            Caption = #1050#1088#1072#1090#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'MinimumLot'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = '0; ; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 77
          end
          object IsClose: TcxGridDBColumn
            Caption = #1047#1072#1082#1088#1099#1090
            DataBinding.FieldName = 'IsClose'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 52
          end
          object IsTop: TcxGridDBColumn
            Caption = #1058#1054#1055
            DataBinding.FieldName = 'IsTop'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 37
          end
          object isFirst: TcxGridDBColumn
            Caption = '1-'#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isFirst'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object isSecond: TcxGridDBColumn
            Caption = #1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isSecond'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object isPublished: TcxGridDBColumn
            Caption = #1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' '#1085#1072' '#1089#1072#1081#1090#1077
            DataBinding.FieldName = 'isPublished'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Properties.AllowGrayed = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 86
          end
          object isPromo: TcxGridDBColumn
            Caption = #1052#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1081' '#1082#1086#1085#1090#1088#1072#1082#1090
            DataBinding.FieldName = 'isPromo'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object isMarketToday: TcxGridDBColumn
            Caption = #1045#1089#1090#1100' '#1085#1072' '#1088#1099#1085#1082#1077' '#1089#1077#1075#1086#1076#1085#1103
            DataBinding.FieldName = 'isMarketToday'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1045#1089#1090#1100' '#1085#1072' '#1088#1099#1085#1082#1077' '#1089#1077#1075#1086#1076#1085#1103' ('#1044#1072'/'#1053#1077#1090')'
            Options.Editing = False
            Width = 70
          end
          object LastPriceDate: TcxGridDBColumn
            Caption = #1055#1086#1089#1083#1077#1076'. '#1076#1072#1090#1072' '#1085#1072#1083#1080#1095#1080#1103' '#1085#1072' '#1088#1099#1085#1082#1077
            DataBinding.FieldName = 'LastPriceDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1089#1083#1077#1076'. '#1076#1072#1090#1072' '#1085#1072#1083#1080#1095#1080#1103' '#1085#1072' '#1088#1099#1085#1082#1077
            Options.Editing = False
            Width = 65
          end
          object LastPriceOldDate: TcxGridDBColumn
            Caption = #1055#1088#1077#1076#1087#1086#1089#1083#1077#1076'. '#1076#1072#1090#1072' '#1085#1072#1083#1080#1095#1080#1103' '#1085#1072' '#1088#1099#1085#1082#1077
            DataBinding.FieldName = 'LastPriceOldDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1087#1086#1089#1083#1077#1076'. '#1076#1072#1090#1072' '#1085#1072#1083#1080#1095#1080#1103' '#1085#1072' '#1088#1099#1085#1082#1077
            Options.Editing = False
            Width = 85
          end
          object CountDays: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1076#1085'. ('#1085#1072#1083#1080#1095#1080#1077' '#1085#1072' '#1088#1099#1085#1082#1077')'
            DataBinding.FieldName = 'CountDays'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1084#1077#1078#1076#1091' '#1076#1072#1090#1072#1084#1080' '#1085#1072#1083#1080#1095#1080#1103' '#1085#1072' '#1088#1099#1085#1082#1077
            Options.Editing = False
            Width = 66
          end
          object CountDays_inf: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1076#1085'. '#1053#1045#1058' '#1085#1072' '#1088#1099#1085#1082#1077
            DataBinding.FieldName = 'CountDays_inf'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1076#1085#1077#1081' '#1053#1045#1058' '#1085#1072' '#1088#1099#1085#1082#1077
            Options.Editing = False
            Width = 66
          end
          object CountPrice: TcxGridDBColumn
            Caption = #1053#1072' '#1088#1099#1085#1082#1077' '#1082#1086#1083'-'#1074#1086' '#1087#1088#1072#1081#1089#1086#1074
            DataBinding.FieldName = 'CountPrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object PercentMarkup: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'PercentMarkup'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
          object Price: TcxGridDBColumn
            AlternateCaption = #1062#1077#1085#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080
            Caption = #1062#1077#1085#1072' '#1088#1077#1072#1083#1080#1079'.'
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080
            Options.Editing = False
            Width = 70
          end
          object RetailCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1058#1086#1088#1075#1086#1074#1086#1081' '#1089#1077#1090#1080
            DataBinding.FieldName = 'RetailCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object RetailName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1058#1086#1088#1075#1086#1074#1086#1081' '#1089#1077#1090#1080
            DataBinding.FieldName = 'RetailName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
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
          object UpdateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 48
          end
          object UpdateName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object InsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 48
          end
          object InsertName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
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
          object isResolution_224: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1085#1086#1074#1083#1077#1085#1080#1077' 224'
            DataBinding.FieldName = 'isResolution_224'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
          end
        end
      end
      object cxLabel3: TcxLabel
        Left = 343
        Top = 101
        Caption = #1044#1086#1075#1086#1074#1086#1088' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
      end
      object edContract: TcxButtonEdit
        Left = 343
        Top = 119
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        TabOrder = 2
        Width = 222
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
    object mactAfterInsert: TMultiAction
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
    object DataSetInsert1: TDataSetInsert
      Category = 'Dataset'
      Caption = '&Insert'
      Hint = 'Insert'
      ImageIndex = 73
      DataSource = MasterDS
    end
    object actUpdateNDS: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Goods_NDS
      StoredProcList = <
        item
          StoredProc = spUpdate_Goods_NDS
        end>
      Caption = 'actUpdateNDS'
    end
    object macSimpleUpdateNDS: TMultiAction
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
    object macUpdateNDS: TMultiAction
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
    object InsertRecord1: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Params = <>
      Caption = 'InsertRecord1'
    end
    object UpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <>
      Caption = 'UpdateDataSet'
      DataSource = MasterDS
    end
    object actPublished: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Goods_Published
      StoredProcList = <
        item
          StoredProc = spUpdate_Goods_Published
        end>
      Caption = 'actPublished'
    end
    object actSimplePublishedList: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actPublished
        end>
      View = cxGridDBTableView
      Caption = #1057#1076#1077#1083#1072#1090#1100' '#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' = '#1053#1045#1058
      Hint = #1057#1076#1077#1083#1072#1090#1100' '#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' = '#1053#1045#1058
    end
    object actPublishedList: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actSimplePublishedList
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1079#1085#1072#1095#1077#1085#1080#1077' '#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' = '#1053#1045#1058'? '
      InfoAfterExecute = #1047#1085#1072#1095#1077#1085#1080#1077' '#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' = '#1053#1045#1058
      Caption = #1057#1076#1077#1083#1072#1090#1100' '#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' = '#1053#1045#1058
      Hint = #1057#1076#1077#1083#1072#1090#1100' '#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' = '#1053#1045#1058
      ImageIndex = 58
    end
  end
  inherited MasterDS: TDataSource
    Left = 56
    Top = 48
  end
  inherited MasterCDS: TClientDataSet
    FilterOptions = []
    Top = 48
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_Goods_Retail'
    Params = <
      item
        Name = 'inContractId'
        Value = Null
        Component = GuidesContract
        ComponentItem = 'Key'
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
    Left = 112
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
          ItemName = 'bbPublished'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbUpdateNDS'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbLabel3'
        end
        item
          Visible = True
          ItemName = 'bbContract'
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    inherited dxBarStatic: TdxBarStatic
      ShowCaption = False
    end
    object bbPublished: TdxBarButton
      Action = actPublishedList
      Category = 0
    end
    object bbLabel3: TdxBarControlContainerItem
      Caption = 'Label3'
      Category = 0
      Hint = 'Label3'
      Visible = ivAlways
      Control = cxLabel3
    end
    object bbContract: TdxBarControlContainerItem
      Caption = 'Contract'
      Category = 0
      Hint = 'Contract'
      Visible = ivAlways
      Control = edContract
    end
    object bbUpdateNDS: TdxBarButton
      Action = macUpdateNDS
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
    ColorRuleList = <
      item
        ColorColumn = IsTop
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = PercentMarkup
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
        ColorColumn = isErased
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
        ColorColumn = MinimumLot
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
        ColorColumn = Price
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
        ColorColumn = isPublished
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = RetailCode
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = RetailName
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end
      item
        ColorColumn = ConditionsKeepName
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end>
    SearchAsFilter = False
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
      end>
    PackSize = 1
    Left = 240
    Top = 144
  end
  object FormParams: TdsdFormParams
    Params = <>
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
  object spUpdate_Goods_MinimumLot: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_MinimumLot'
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
        Name = 'inMinimumLot'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MinimumLot'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 288
  end
  object spUpdate_Goods_isFirst: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_isFirst'
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
        Name = 'inisFirst'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isFirst'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outColor'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Color_calc'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 704
    Top = 176
  end
  object spUpdate_Goods_isSecond: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_isSecond'
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
        Name = 'inisSecond'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSecond'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outColor'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Color_calc'
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 648
    Top = 256
  end
  object spUpdate_Goods_Published: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_Published'
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
        Name = 'outisPublished'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPublished'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 680
    Top = 107
  end
  object spUpdate_Goods_LastPriceOld: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_LastPriceOld'
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
        Name = 'inLastPriceDate'
        Value = 'NULL'
        Component = MasterCDS
        ComponentItem = 'LastPriceDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLastPriceOldDate'
        Value = 'NULL'
        Component = MasterCDS
        ComponentItem = 'LastPriceOldDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outCountDays'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountDays'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 560
    Top = 176
  end
  object GuidesContract: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContract
    FormNameParam.Value = 'TContractForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 424
    Top = 136
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = GuidesContract
      end>
    Left = 544
    Top = 96
  end
  object spUpdate_Goods_NDS: TdsdStoredProc
    StoredProcName = 'gpUpdate_Goods_NDS'
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
        Name = 'inNDS'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'NDS'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNDS_PriceList'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'NDS_PriceList'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 808
    Top = 248
  end
end
