inherited Goods_BarCodeForm: TGoods_BarCodeForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1089#1077#1090#1080' ('#1080#1079#1084'. '#1096'/'#1082' '#1087#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1103')'
  ClientHeight = 443
  ClientWidth = 883
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 899
  ExplicitHeight = 481
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 883
    Height = 417
    ExplicitWidth = 883
    ExplicitHeight = 417
    ClientRectBottom = 417
    ClientRectRight = 883
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 883
      ExplicitHeight = 417
      inherited cxGrid: TcxGrid
        Width = 883
        Height = 417
        ExplicitWidth = 883
        ExplicitHeight = 417
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
            Width = 110
          end
          object OrdBar: TcxGridDBColumn
            Caption = #8470' '#1087'/'#1087' '#1064'/'#1050' '#1087#1088#1086#1080#1079#1074'.'
            DataBinding.FieldName = 'OrdBar'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object Name: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 324
          end
          object NDS: TcxGridDBColumn
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'NDS'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
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
    inherited dsdSetUnErased: TdsdUpdateErased
      Enabled = False
      ShortCut = 0
    end
    inherited dsdSetErased: TdsdUpdateErased
      Enabled = False
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
      StoredProc = spUpdate_Goods_BarCode
      StoredProcList = <
        item
          StoredProc = spUpdate_Goods_BarCode
        end>
      Caption = 'UpdateDataSet'
      DataSource = MasterDS
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
    object bbPublished: TdxBarButton
      Caption = #1057#1076#1077#1083#1072#1090#1100' '#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' = '#1053#1045#1058
      Category = 0
      Hint = #1057#1076#1077#1083#1072#1090#1100' '#1054#1087#1091#1073#1083#1080#1082#1086#1074#1072#1085' = '#1053#1045#1058
      Visible = ivAlways
      ImageIndex = 58
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
        ColorColumn = NDS
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
    inherited N4: TMenuItem
      Visible = False
    end
    inherited N5: TMenuItem
      Visible = False
    end
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
    Left = 600
    Top = 112
  end
  object spUpdate_Goods_BarCode: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Goods_BarCode'
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
        Name = 'inBarCode'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'BarCode'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 344
    Top = 288
  end
end
