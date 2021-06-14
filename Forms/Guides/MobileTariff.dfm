object MobileTariffForm: TMobileTariffForm
  Left = 0
  Top = 0
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <T'#1072#1088#1080#1092#1099' '#1084#1086#1073#1080#1083#1100#1085#1099#1093' '#1086#1087#1077#1088#1072#1090#1086#1088#1086#1074'>'
  ClientHeight = 404
  ClientWidth = 994
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
    Width = 994
    Height = 378
    Align = alClient
    TabOrder = 0
    LookAndFeel.Kind = lfUltraFlat
    LookAndFeel.NativeStyle = False
    object cxGridDBTableView: TcxGridDBTableView
      PopupMenu = pmGrid
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Filter.Active = True
      DataController.KeyFieldNames = 'id'
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
          Kind = skCount
          Column = Name
        end
        item
          Kind = skCount
          Column = isErased
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.CellHints = True
      OptionsBehavior.IncSearch = True
      OptionsBehavior.IncSearchItem = CostInet
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.CellEndEllipsis = True
      OptionsView.Footer = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderHeight = 40
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object Code: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'Code'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 35
      end
      object Name: TcxGridDBColumn
        Caption = #1053#1072#1079#1074#1072#1085#1080#1077
        DataBinding.FieldName = 'Name'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 184
      end
      object ContractCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1076#1086#1075#1086#1074#1086#1088#1072
        DataBinding.FieldName = 'ContractCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 63
      end
      object ContractName: TcxGridDBColumn
        Caption = #1044#1086#1075#1086#1074#1086#1088
        DataBinding.FieldName = 'ContractName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 99
      end
      object JuridicalName: TcxGridDBColumn
        Caption = #1070#1088'. '#1083#1080#1094#1086
        DataBinding.FieldName = 'JuridicalName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 99
      end
      object Monthly: TcxGridDBColumn
        Caption = #1040#1073#1086#1085#1087#1083#1072#1090#1072
        DataBinding.FieldName = 'Monthly'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 72
      end
      object PocketMinutes: TcxGridDBColumn
        Caption = #1052#1080#1085'. '#1074' '#1087#1072#1082#1077#1090#1077
        DataBinding.FieldName = 'PocketMinutes'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1084#1080#1085#1091#1090' '#1074' '#1087#1072#1082#1077#1090#1077
        Options.Editing = False
        Width = 72
      end
      object PocketSMS: TcxGridDBColumn
        Caption = #1057#1052#1057' '#1074' '#1087#1072#1082#1077#1090#1077
        DataBinding.FieldName = 'PocketSMS'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1057#1052#1057' '#1074' '#1087#1072#1082#1077#1090#1077
        Options.Editing = False
        Width = 58
      end
      object PocketInet: TcxGridDBColumn
        Caption = #1052#1041' '#1074' '#1087#1072#1082#1077#1090#1077
        DataBinding.FieldName = 'PocketInet'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1052#1041' '#1080#1085#1090#1077#1088#1085#1077#1090#1072' '#1074' '#1087#1072#1082#1077#1090#1077
        Options.Editing = False
        Width = 70
      end
      object CostMinutes: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' '#1084#1080#1085'. '#1074#1085#1077' '#1087#1072#1082#1077#1090#1072
        DataBinding.FieldName = 'CostMinutes'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1057#1090#1086#1080#1084#1086#1089#1090#1100' 1 '#1084#1080#1085#1091#1090#1099' '#1074#1085#1077' '#1087#1072#1082#1077#1090#1072
        Options.Editing = False
        Width = 106
      end
      object CostSMS: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' '#1057#1052#1057' '#1074#1085#1077' '#1087#1072#1082#1077#1090#1072
        DataBinding.FieldName = 'CostSMS'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1057#1052#1057' '#1074#1085#1077' '#1087#1072#1082#1077#1090#1072
        Options.Editing = False
        Width = 68
      end
      object CostInet: TcxGridDBColumn
        Caption = #1062#1077#1085#1072' '#1052#1041' '#1074#1085#1077' '#1087#1072#1082#1077#1090#1072
        DataBinding.FieldName = 'CostInet'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DecimalPlaces = 4
        Properties.DisplayFormat = ',0.##;-,0.##; ;'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderHint = #1057#1090#1086#1080#1084#1086#1089#1090#1100' 1 '#1052#1041' '#1080#1085#1090#1077#1088#1085#1077#1090#1072' '#1074#1085#1077' '#1087#1072#1082#1077#1090#1072
        Options.Editing = False
        Width = 73
      end
      object Comment: TcxGridDBColumn
        Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
        DataBinding.FieldName = 'Comment'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 93
      end
      object isErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 59
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 40
    Top = 230
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 156
    Top = 233
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
    Left = 80
    Top = 88
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
    Left = 212
    Top = 91
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
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bbEdit'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbSetErased'
        end
        item
          Visible = True
          ItemName = 'bbSetUnErased'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbChoiceGuides'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbProtocolOpenForm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic1'
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
    object bbInsert: TdxBarButton
      Action = actInsert
      Category = 0
    end
    object bbEdit: TdxBarButton
      Action = actUpdate
      Category = 0
    end
    object bbSetErased: TdxBarButton
      Action = dsdSetErased
      Category = 0
    end
    object bbSetUnErased: TdxBarButton
      Action = dsdSetUnErased
      Category = 0
    end
    object bbGridToExcel: TdxBarButton
      Action = dsdGridToExcel1
      Category = 0
    end
    object dxBarStatic1: TdxBarStatic
      Caption = '    '
      Category = 0
      Hint = '    '
      Visible = ivAlways
      ShowCaption = False
    end
    object bbChoiceGuides: TdxBarButton
      Action = dsdChoiceGuides
      Category = 0
    end
    object bbShowAll: TdxBarButton
      Action = actShowAll
      Category = 0
    end
    object bbProtocolOpenForm: TdxBarButton
      Action = ProtocolOpenForm
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 151
    Top = 86
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
    object dsdSetErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 2
      ShortCut = 46
      ErasedFieldName = 'isErased'
      DataSource = DataSource
    end
    object dsdSetUnErased: TdsdUpdateErased
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spErasedUnErased
      StoredProcList = <
        item
          StoredProc = spErasedUnErased
        end>
      Caption = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100
      Hint = #1042#1086#1089#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 8
      ShortCut = 32776
      ErasedFieldName = 'isErased'
      isSetErased = False
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
          ComponentItem = 'id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Monthly'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Monthly'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
      DataSource = DataSource
    end
    object dsdGridToExcel1: TdsdGridToExcel
      Category = 'DSDLib'
      MoveParams = <>
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object actShowAll: TBooleanStoredProcAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndex = 63
      Value = False
      HintTrue = #1057#1082#1088#1099#1090#1100' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      HintFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      CaptionTrue = #1057#1082#1088#1099#1090#1100' '#1091#1076#1072#1083#1077#1085#1085#1099#1077
      CaptionFalse = #1055#1086#1082#1072#1079#1072#1090#1100' '#1074#1077#1089#1100' '#1089#1087#1080#1089#1086#1082
      ImageIndexTrue = 62
      ImageIndexFalse = 63
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
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Name'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdate: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      ShortCut = 115
      ImageIndex = 1
      FormName = 'TMobileTariffEditForm'
      FormNameParam.Value = 'TMobileTariffEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = ClientDataSet
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      ActionType = acUpdate
      DataSource = DataSource
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      FormName = 'TMobileTariffEditForm'
      FormNameParam.Value = 'TMobileTariffEditForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      DataSetRefresh = actRefresh
      IdFieldName = 'Id'
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_MobileTariff2'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    Left = 180
    Top = 166
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 55
    Top = 142
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_isErased_MobileTariff'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inTariffID'
        Value = 0
        Component = ClientDataSet
        ComponentItem = 'ID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 276
    Top = 166
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
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
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    Left = 882
    Top = 329
  end
  object pmGrid: TPopupMenu
    Images = dmMain.ImageList1
    Left = 354
    Top = 132
    object N1: TMenuItem
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ImageIndex = 0
      ShortCut = 45
    end
    object N2: TMenuItem
      Action = actUpdate
    end
    object N3: TMenuItem
      Action = dsdSetErased
    end
    object N4: TMenuItem
      Caption = '-'
    end
    object N5: TMenuItem
      Action = dsdSetUnErased
    end
  end
end
