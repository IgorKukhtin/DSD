object OrderTypeForm: TOrderTypeForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1099' '#1089#1077#1079#1086#1085#1085#1086#1089#1090#1080' '#1087#1086' '#1084#1077#1089#1103#1094#1072#1084'>'
  ClientHeight = 725
  ClientWidth = 1039
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  AddOnFormData.isAlwaysRefresh = False
  AddOnFormData.RefreshAction = actRefresh
  AddOnFormData.ChoiceAction = dsdChoiceGuides
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 26
    Width = 1039
    Height = 699
    Align = alClient
    TabOrder = 0
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
    ExplicitHeight = 321
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsBehavior.IncSearchItem = clValue1
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Appending = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object clUnitCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1087#1086#1076#1088'.'
        DataBinding.FieldName = 'UnitCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 48
      end
      object clUnitName: TcxGridDBColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086')'
        DataBinding.FieldName = 'UnitName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = UnitChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 120
      end
      object clGoodsGroupAnalystName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1072#1085#1072#1083#1080#1090#1080#1082#1080
        DataBinding.FieldName = 'GoodsGroupAnalystName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object clGoodsTagName: TcxGridDBColumn
        Caption = #1055#1088#1080#1079#1085#1072#1082' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsTagName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object clTradeMarkName: TcxGridDBColumn
        Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1084#1072#1088#1082#1072
        DataBinding.FieldName = 'TradeMarkName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object clGoodsGroupName: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsGroupName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = GoodsChoiceForm
            Default = True
            Kind = bkEllipsis
          end>
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object clGoodsGroupNameFull: TcxGridDBColumn
        Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
        DataBinding.FieldName = 'GoodsGroupNameFull'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 150
      end
      object clGoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1090#1086#1074'.'
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 56
      end
      object clGoodsName: TcxGridDBColumn
        Caption = #1058#1086#1074#1072#1088
        DataBinding.FieldName = 'GoodsName'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = GoodsChoiceForm
            Default = True
            Enabled = False
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 150
      end
      object clMeasureName: TcxGridDBColumn
        Caption = #1045#1076'. '#1080#1079#1084'.'
        DataBinding.FieldName = 'MeasureName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 45
      end
      object clTermProduction: TcxGridDBColumn
        Caption = #1057#1088#1086#1082' '#1087#1088#1086#1080#1079#1074'. '#1074' '#1076#1085#1103#1093
        DataBinding.FieldName = 'TermProduction'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 90
      end
      object clNormInDays: TcxGridDBColumn
        Caption = #1053#1086#1088#1084#1072' '#1079#1072#1087#1072#1089' '#1074' '#1076#1085#1103#1093
        DataBinding.FieldName = 'NormInDays'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 90
      end
      object clStartProductionInDays: TcxGridDBColumn
        Caption = #1063#1077#1088#1077#1079' '#1089#1082#1086#1083#1100#1082#1086' '#1076#1085#1077#1081' '#1085#1072#1095#1072#1083#1086' '#1087#1088#1086#1080#1079#1074'.'
        DataBinding.FieldName = 'StartProductionInDays'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.AssignedValues.DisplayFormat = True
        Properties.DecimalPlaces = 4
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 140
      end
      object clValue1: TcxGridDBColumn
        Caption = #1071#1085#1074#1072#1088#1100
        DataBinding.FieldName = 'Koeff1'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object clValue2: TcxGridDBColumn
        Caption = #1060#1077#1074#1088#1072#1083#1100
        DataBinding.FieldName = 'Koeff2'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 65
      end
      object clValue3: TcxGridDBColumn
        Caption = #1052#1072#1088#1090
        DataBinding.FieldName = 'Koeff3'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object clValue4: TcxGridDBColumn
        Caption = #1040#1087#1088#1077#1083#1100
        DataBinding.FieldName = 'Koeff4'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object clValue5: TcxGridDBColumn
        Caption = #1052#1072#1081' '
        DataBinding.FieldName = 'Koeff5'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object clValue6: TcxGridDBColumn
        Caption = #1048#1102#1085#1100
        DataBinding.FieldName = 'Koeff6'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object clValue7: TcxGridDBColumn
        Caption = #1048#1102#1083#1100
        DataBinding.FieldName = 'Koeff7'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object clValue8: TcxGridDBColumn
        Caption = #1040#1074#1075#1091#1089#1090
        DataBinding.FieldName = 'Koeff8'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object clValue9: TcxGridDBColumn
        Caption = #1057#1077#1085#1090#1103#1073#1088#1100
        DataBinding.FieldName = 'Koeff9'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 65
      end
      object clValue10: TcxGridDBColumn
        Caption = #1054#1082#1090#1103#1073#1088#1100
        DataBinding.FieldName = 'Koeff10'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object clValue11: TcxGridDBColumn
        Caption = #1053#1086#1103#1073#1088#1100
        DataBinding.FieldName = 'Koeff11'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object clValue12: TcxGridDBColumn
        Caption = #1044#1077#1082#1072#1073#1088#1100
        DataBinding.FieldName = 'Koeff12'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = '0.####;-0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 60
      end
      object clInfoMoneyCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1059#1055
        DataBinding.FieldName = 'InfoMoneyCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object clInfoMoneyGroupName: TcxGridDBColumn
        Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoMoneyGroupName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 80
      end
      object clInfoMoneyDestinationName: TcxGridDBColumn
        Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
        DataBinding.FieldName = 'InfoMoneyDestinationName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object clInfoMoneyName: TcxGridDBColumn
        Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoMoneyName'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object clErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 45
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object ceUnit: TcxButtonEdit
    Left = 522
    Top = 157
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    TabOrder = 5
    Width = 154
  end
  object cxLabel6: TcxLabel
    Left = 428
    Top = 158
    Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 56
    Top = 104
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 48
    Top = 160
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = dsdUnitGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
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
    Left = 288
    Top = 104
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Segoe UI'
    Font.Style = []
    Categories.Strings = (
      'Default')
    Categories.ItemsVisibles = (
      2)
    Categories.Visibles = (
      True)
    ImageOptions.Images = dmMain.ImageList
    NotDocking = [dsNone, dsLeft, dsTop, dsRight, dsBottom]
    PopupMenuLinks = <>
    ShowShortCutInHint = True
    UseSystemFont = True
    Left = 168
    Top = 104
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
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
          ItemName = 'bbactShowAll'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bb'
        end
        item
          Visible = True
          ItemName = 'bb1'
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
      OneOnRow = True
      Row = 0
      UseOwnFont = False
      Visible = True
      WholeRow = False
    end
    object bbRefresh: TdxBarButton
      Action = actRefresh
      Category = 0
    end
    object bbGridToExcel: TdxBarButton
      Action = dsdGridToExcel
      Category = 0
    end
    object dxBarStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Hint = '     '
      Visible = ivAlways
    end
    object bbChoiceGuides: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object bbactShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bb: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel6
    end
    object bb1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = ceUnit
    end
    object bbProtocolOpenForm: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 288
    Top = 160
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'actUpdateDataSet'
      DataSource = DataSource
    end
    object dsdChoiceGuides: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          DataType = ftString
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name'
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
      DataSource = DataSource
    end
    object dsdGridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object GoodsChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Goods_ObjectForm'
      FormName = 'TGoods_ObjectForm'
      FormNameParam.Value = 'TGoods_ObjectForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsName'
          DataType = ftString
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'GoodsGroupName'
          DataType = ftString
        end>
      isShowModal = True
    end
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 63
      Value = False
      HintTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1089#1077' '#1090#1086#1074#1072#1088#1099
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
    end
    object UnitChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Unit_ObjectForm'
      FormName = 'TUnit_ObjectForm'
      FormNameParam.Value = 'TUnit_ObjectForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'UnitId'
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'UnitName'
          DataType = ftString
        end
        item
          Name = 'Code'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'UnitCode'
        end>
      isShowModal = True
    end
    object ProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1087#1088#1086#1090#1086#1082#1086#1083#1072
      ImageIndex = 34
      FormName = 'TProtocolForm'
      FormNameParam.Value = 'TProtocolForm'
      FormNameParam.DataType = ftString
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'QualityName'
          DataType = ftString
          ParamType = ptInput
        end>
      isShowModal = False
    end
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_OrderType'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = dsdUnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'inShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 48
    Top = 216
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 168
    Top = 160
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <
      item
        Action = dsdChoiceGuides
      end
      item
        Action = actUpdateDataSet
      end>
    ActionItemList = <
      item
        Action = dsdChoiceGuides
        ShortCut = 13
      end
      item
        Action = actUpdateDataSet
        ShortCut = 13
      end>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 168
    Top = 216
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_OrderType'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inCode'
        Value = 0
        ParamType = ptInput
      end
      item
        Name = 'inName'
        Value = ''
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inTermProduction'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'TermProduction'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inNormInDays'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'NormInDays'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inStartProductionInDays'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'StartProductionInDays'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inKoeff1'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Koeff1'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inKoeff2'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Koeff2'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inKoeff3'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Koeff3'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inKoeff4'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Koeff4'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inKoeff5'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Koeff5'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inKoeff6'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Koeff6'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inKoeff7'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Koeff7'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inKoeff8'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Koeff8'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inKoeff9'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Koeff9'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inKoeff10'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Koeff10'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inKoeff11'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Koeff11'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inKoeff12'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'Koeff12'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'GoodsId'
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = ClientDataSet
        ComponentItem = 'UnitId'
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 128
    Top = 296
  end
  object dsdUnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = dsdUnitGuides
        ComponentItem = 'Key'
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = dsdUnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 600
    Top = 155
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = dsdUnitGuides
      end
      item
        Component = actShowAll
      end>
    Left = 832
    Top = 168
  end
end
