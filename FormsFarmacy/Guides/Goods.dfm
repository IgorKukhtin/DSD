inherited GoodsForm: TGoodsForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' '#1090#1086#1074#1072#1088#1086#1074' '#1089#1077#1090#1080
  ClientHeight = 423
  ClientWidth = 962
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  ExplicitWidth = 978
  ExplicitHeight = 461
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 962
    Height = 397
    ExplicitWidth = 962
    ExplicitHeight = 397
    ClientRectBottom = 397
    ClientRectRight = 962
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 962
      ExplicitHeight = 397
      inherited cxGrid: TcxGrid
        Width = 962
        Height = 397
        ExplicitWidth = 962
        ExplicitHeight = 397
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsBehavior.IncSearch = True
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 89
          end
          object clName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 324
          end
          object clNDSKindName: TcxGridDBColumn
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'NDSKindName'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object clMeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 59
          end
          object clGoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 96
          end
          object clMinimumLot: TcxGridDBColumn
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
          object clIsClose: TcxGridDBColumn
            Caption = #1047#1072#1082#1088#1099#1090
            DataBinding.FieldName = 'IsClose'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 52
          end
          object cbIsTop: TcxGridDBColumn
            Caption = #1058#1054#1055
            DataBinding.FieldName = 'IsTop'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 37
          end
          object clisFirst: TcxGridDBColumn
            Caption = '1-'#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isFirst'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object clisSecond: TcxGridDBColumn
            Caption = #1053#1077#1087#1088#1080#1086#1088#1080#1090#1077#1090'. '#1074#1099#1073#1086#1088
            DataBinding.FieldName = 'isSecond'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 60
          end
          object cbPercentMarkup: TcxGridDBColumn
            Caption = '% '#1085#1072#1094#1077#1085#1082#1080
            DataBinding.FieldName = 'PercentMarkup'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##; ; '
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 84
          end
          object colPrice: TcxGridDBColumn
            AlternateCaption = #1062#1077#1085#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080
            Caption = #1062#1077#1085#1072' '#1088#1077#1072#1083#1080#1079'.'
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
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
          object clisErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            PropertiesClassName = 'TcxCheckBoxProperties'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 51
          end
          object clColor_calc: TcxGridDBColumn
            DataBinding.FieldName = 'Color_calc'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            VisibleForCustomization = False
            Width = 30
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
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
        end>
      FormName = 'TGoodsEditForm'
      FormNameParam.Value = 'TGoodsEditForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
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
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Code'
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
      StoredProc = spUpdate_Goods_isFirst
      StoredProcList = <
        item
          StoredProc = spUpdate_Goods_isFirst
        end
        item
          StoredProc = spUpdate_Goods_isSecond
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
        ColorColumn = cbIsTop
        BackGroundValueColumn = clColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = cbPercentMarkup
        BackGroundValueColumn = clColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = clCode
        BackGroundValueColumn = clColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = clGoodsGroupName
        BackGroundValueColumn = clColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = clIsClose
        BackGroundValueColumn = clColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = clisErased
        BackGroundValueColumn = clColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = clisFirst
        BackGroundValueColumn = clColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = clMeasureName
        BackGroundValueColumn = clColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = clMinimumLot
        BackGroundValueColumn = clColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = clName
        BackGroundValueColumn = clColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = clNDSKindName
        BackGroundValueColumn = clColor_calc
        ColorValueList = <>
      end
      item
        ColorColumn = colPrice
        BackGroundValueColumn = clColor_calc
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
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = MasterCDS
        ComponentItem = 'Code'
      end
      item
        Name = 'Name'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'Name'
        DataType = ftString
      end
      item
        Name = 'GoodsGroupId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'GoodsGroupId'
      end
      item
        Name = 'GoodsGroupName'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'GoodsGroupName'
        DataType = ftString
      end
      item
        Name = 'MeasureId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'MeasureId'
      end
      item
        Name = 'MeasureName'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'MeasureName'
        DataType = ftString
      end
      item
        Name = 'NDSKindId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'NdsKindId'
      end
      item
        Name = 'NDSKindName'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'NDSKindName'
        DataType = ftString
      end
      item
        Name = 'MinimumLot'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MinimumLot'
        DataType = ftFloat
      end
      item
        Name = 'isClose'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isClose'
        DataType = ftBoolean
      end
      item
        Name = 'isTop'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isTop'
        DataType = ftBoolean
      end
      item
        Name = 'PercentMarkup'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PercentMarkup'
        DataType = ftFloat
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
      end
      item
        Name = 'Id'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
      end
      item
        Name = 'Code'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Code'
      end
      item
        Name = 'Name'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Name'
        DataType = ftString
      end
      item
        Name = 'GoodsGroupId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsGroupId'
      end
      item
        Name = 'GoodsGroupName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsGroupName'
        DataType = ftString
      end
      item
        Name = 'MeasureId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MeasureId'
      end
      item
        Name = 'MeasureName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MeasureName'
        DataType = ftString
      end
      item
        Name = 'NDSKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'NdsKindId'
      end
      item
        Name = 'NDSKindName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'NDSKindName'
        DataType = ftString
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
      end
      item
        Name = 'inMinimumLot'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MinimumLot'
        DataType = ftFloat
        ParamType = ptInput
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
      end
      item
        Name = 'inisFirst'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isFirst'
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'outColor'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Color_calc'
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
      end
      item
        Name = 'inisSecond'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSecond'
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'outColor'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Color_calc'
      end>
    PackSize = 1
    Left = 712
    Top = 256
  end
end
