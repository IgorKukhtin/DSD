object Report_PriceCheckForm: TReport_PriceCheckForm
  Left = 0
  Top = 0
  Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1094#1077#1085' '#1084#1077#1078#1076#1091' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084#1080
  ClientHeight = 440
  ClientWidth = 1145
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
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1145
    Height = 31
    Align = alTop
    TabOrder = 0
    object cxLabel4: TcxLabel
      Left = 7
      Top = 4
      Caption = #1055#1088#1086#1094#1077#1085#1090' '#1088#1072#1089#1093#1086#1078#1076#1077#1085#1080#1103' '#1094#1077#1085
    end
    object cePercent: TcxCurrencyEdit
      Left = 152
      Top = 3
      EditValue = 20.000000000000000000
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      TabOrder = 1
      Width = 90
    end
    object ceUser: TcxButtonEdit
      Left = 368
      Top = 3
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 2
      Width = 241
    end
    object cxLabel1: TcxLabel
      Left = 262
      Top = 4
      Caption = #1052#1077#1085#1077#1076#1078#1077#1088' '#1072#1087#1090#1077#1082#1080':'
    end
    object cbHideExceptRed: TcxCheckBox
      Left = 623
      Top = 3
      Hint = #1057#1082#1088#1099#1090#1100' '#1082#1088#1086#1084#1077' '#1082#1088#1072#1089#1085#1099#1093
      Caption = #1057#1082#1088#1099#1090#1100' '#1082#1088#1086#1084#1077' '#1082#1088#1072#1089#1085#1099#1093
      TabOrder = 4
      Width = 146
    end
    object cbisRetail: TcxCheckBox
      Left = 780
      Top = 3
      Caption = #1058#1086#1074#1072#1088' '#1089#1090#1080
      State = cbsChecked
      TabOrder = 5
      Width = 77
    end
    object cbManagerUnitsOnly: TcxCheckBox
      Left = 863
      Top = 3
      Caption = #1058#1086#1083#1100#1082#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103' '#1084#1077#1085#1077#1076#1078#1077#1088#1072
      TabOrder = 6
      Width = 210
    end
  end
  object cxGrid: TcxGrid
    Left = 0
    Top = 57
    Width = 1145
    Height = 383
    Align = alClient
    TabOrder = 5
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = GoodsName
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.GoToNextCellOnEnter = True
      OptionsBehavior.FocusCellOnCycle = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsCustomize.DataRowSizing = True
      OptionsData.CancelOnExit = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.GroupSummaryLayout = gslAlignWithColumns
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object GoodsCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'GoodsCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 62
      end
      object GoodsName: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077' '#1090#1086#1074#1072#1088#1072
        DataBinding.FieldName = 'GoodsName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 182
      end
      object isResolution_224: TcxGridDBColumn
        Caption = #1055#1086#1089#1090'. 224'
        DataBinding.FieldName = 'isResolution_224'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 51
      end
      object isTop: TcxGridDBColumn
        Caption = #1058#1086#1087' '#1089#1077#1090#1080
        DataBinding.FieldName = 'isTop'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 50
      end
      object PercentMarkup: TcxGridDBColumn
        Caption = '% '#1085#1077#1094#1077#1085#1082#1080' '#1058#1054#1055' '#1089#1077#1090#1080
        DataBinding.FieldName = 'PercentMarkup'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 53
      end
      object PriceTop: TcxGridDBColumn
        Caption = #1060#1080#1082#1089' '#1094#1077#1085#1072' '#1058#1054#1055' '#1089#1077#1090#1080
        DataBinding.FieldName = 'PriceTop'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.####;-,0.####; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 56
      end
      object isSP: TcxGridDBColumn
        Caption = #1057#1055'- '#1044#1086#1089#1090'. '#1083#1077#1082'-'#1074#1072
        DataBinding.FieldName = 'isSP'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 46
      end
      object isPromo: TcxGridDBColumn
        Caption = #1052#1072#1088#1082#1077#1090' '#1076#1086#1075#1086#1074#1086#1088
        DataBinding.FieldName = 'isPromo'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object isPromoBonus: TcxGridDBColumn
        Caption = #1052#1072#1088#1082#1077#1090'. '#1073#1086#1085#1091#1089
        DataBinding.FieldName = 'isPromoBonus'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 58
      end
      object PromoBonus: TcxGridDBColumn
        Caption = '% '#1084#1072#1088#1082#1077#1090' '#1073#1086#1085#1091#1089#1072' '
        DataBinding.FieldName = 'PromoBonus'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 72
      end
      object PriceAverage: TcxGridDBColumn
        Caption = #1057#1088#1077#1076#1085#1103#1103' '#1094#1077#1085#1072
        DataBinding.FieldName = 'PriceAverage'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00;-,0.00; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object PriceMin: TcxGridDBColumn
        Caption = #1052#1080#1085'. '#1094#1077#1085#1072
        DataBinding.FieldName = 'PriceMin'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object PriceMax: TcxGridDBColumn
        Caption = #1052#1072#1082#1089'. '#1094#1077#1085#1072
        DataBinding.FieldName = 'PriceMax'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object UnitCount: TcxGridDBColumn
        Caption = #1040#1087#1090#1077#1082' '#1089' '#1086#1089#1090#1072#1090#1082#1086#1084
        DataBinding.FieldName = 'UnitCount'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 69
      end
      object BadPricePlus: TcxGridDBColumn
        Caption = #1040#1087#1090#1077#1082' '#1089' '#1086#1090#1082#1083#1086#1085'. '#1094#1077#1085#1099'  '#1074' '#1087#1083#1102#1089
        DataBinding.FieldName = 'BadPricePlus'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 69
      end
      object BadPriceMinus: TcxGridDBColumn
        Caption = #1040#1087#1090#1077#1082' '#1089' '#1086#1090#1082#1083#1086#1085'. '#1094#1077#1085#1099' '#1074' '#1084#1080#1085#1091#1089
        DataBinding.FieldName = 'BadPriceMinus'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 69
      end
      object PriceIn: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' '#1080#1079' '#1087#1088#1080#1093#1086#1076#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' '#1089' '#1091#1095#1077#1090#1086#1084' '#1053#1044#1057
        DataBinding.FieldName = 'PriceIn'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 69
      end
      object DateIn: TcxGridDBColumn
        Caption = #1044#1072#1090#1072' '#1087#1088#1080#1093#1086#1076#1072
        DataBinding.FieldName = 'DateIn'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 73
      end
      object JuridicalInName: TcxGridDBColumn
        Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082' '#1080#1079' '#1087#1088#1080#1093#1086#1076#1072
        DataBinding.FieldName = 'JuridicalInName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 95
      end
      object JuridicalPrice: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' '#1080#1079' '#1087#1088#1072#1081#1089#1086#1074' '#1089' '#1091#1095#1077#1090#1086#1084' '#1053#1044#1057
        DataBinding.FieldName = 'JuridicalPrice'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 2
        Properties.DisplayFormat = ',0.00;-,0.00; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 79
      end
      object JuridicalPriceAverage: TcxGridDBColumn
        Caption = #1057#1088#1077#1076#1085#1103#1103' '#1094#1077#1085#1072'  '#1080#1079' '#1087#1088#1072#1081#1089#1086#1074' '#1089' '#1053#1044#1057
        DataBinding.FieldName = 'JuridicalPriceAverage'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 76
      end
      object Price: TcxGridDBColumn
        DataBinding.FieldName = 'Price'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00; ;'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
      end
      object Color_Calc: TcxGridDBColumn
        DataBinding.FieldName = 'Color_Calc'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        VisibleForCustomization = False
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 168
    Top = 208
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 104
    Top = 200
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
      end
      item
        Component = cePercent
        Properties.Strings = (
          'Value')
      end
      item
        Component = cbManagerUnitsOnly
        Properties.Strings = (
          'Checked')
      end>
    StorageName = 'cxPropertiesStore'
    StorageType = stStream
    Left = 328
    Top = 200
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
    Left = 240
    Top = 200
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
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
        end
        item
          Visible = True
          ItemName = 'bbToExcel'
        end
        item
          Visible = True
          ItemName = 'bbStaticText'
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
    object bbToExcel: TdxBarButton
      Action = actExportToExcel
      Category = 0
    end
    object bbStaticText: TdxBarButton
      Caption = '     '
      Category = 0
      Visible = ivAlways
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' ('#1040#1082#1090#1080#1074'/'#1055#1072#1089#1089#1080#1074')'
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' ('#1040#1082#1090#1080#1074'/'#1055#1072#1089#1089#1080#1074')'
      Visible = ivAlways
      ImageIndex = 3
      ShortCut = 16464
    end
    object bbPrint2: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' ('#1044#1077#1073#1077#1090'/'#1050#1088#1077#1076#1080#1090')'
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' ('#1044#1077#1073#1077#1090'/'#1050#1088#1077#1076#1080#1090')'
      Visible = ivAlways
      ImageIndex = 16
    end
    object bbcbTotal: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object bbOpenReport_AccountMotion: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1091
      Category = 0
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1089#1095#1077#1090#1091
      Visible = ivAlways
      ImageIndex = 26
    end
    object bbReport_Account: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' <'#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1089#1095#1077#1090#1091'>'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' <'#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1089#1095#1077#1090#1091'>'
      Visible = ivAlways
      ImageIndex = 25
    end
    object bbPrint3: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' ('#1044#1077#1073#1077#1090'/'#1050#1088#1077#1076#1080#1090') '#1089#1074#1077#1088#1085#1091#1090#1086
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' ('#1044#1077#1073#1077#1090'/'#1050#1088#1077#1076#1080#1090') '#1089#1074#1077#1088#1085#1091#1090#1086
      Visible = ivAlways
      ImageIndex = 18
    end
    object bbGroup: TdxBarControlContainerItem
      Caption = 'bbGroup'
      Category = 0
      Hint = 'bbGroup'
      Visible = ivAlways
    end
    object bbUpdate: TdxBarButton
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      Category = 0
      Hint = #1054#1090#1082#1088#1099#1090#1100' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077
      Visible = ivAlways
      ImageIndex = 1
      ShortCut = 115
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 32
    Top = 200
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actExportToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_PeriodDialogForm'
      FormNameParam.Value = 'TReport_PeriodDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpReport_PriceCheck'
    DataSet = HeaderCDS
    DataSets = <
      item
        DataSet = HeaderCDS
      end
      item
        DataSet = ClientDataSet
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inPercent'
        Value = 41640d
        Component = cePercent
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserId'
        Value = Null
        Component = GuidesUser
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisHideExceptRed'
        Value = Null
        Component = cbHideExceptRed
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisRetail'
        Value = Null
        Component = cbisRetail
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inManagerUnitsOnly'
        Value = Null
        Component = cbManagerUnitsOnly
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 32
    Top = 280
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 608
    Top = 144
  end
  object PeriodChoice: TPeriodChoice
    Left = 376
    Top = 128
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = GuidesUser
      end
      item
        Component = cePercent
      end
      item
        Component = cbHideExceptRed
      end>
    Left = 472
    Top = 128
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Percent'
        Value = Null
        Component = cePercent
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserId'
        Value = Null
        Component = GuidesUser
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = Null
        Component = GuidesUser
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 440
    Top = 208
  end
  object DBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 392
    Top = 296
  end
  object HeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 712
    Top = 152
  end
  object CrossDBViewAddOn: TCrossDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <
      item
        ColorColumn = Price
        ValueColumn = Color_Calc
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    KeepSelectColor = True
    PropertiesCellList = <>
    HeaderDataSet = HeaderCDS
    HeaderColumnName = 'UnitName'
    TemplateColumn = Price
    Left = 568
    Top = 288
  end
  object GuidesUser: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUser
    FormNameParam.Value = 'TUserNickForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUserNickForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUser
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUser
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 456
    Top = 1
  end
end
