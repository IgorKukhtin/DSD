inherited RateFuelForm: TRateFuelForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1053#1086#1088#1084#1099' '#1090#1086#1087#1083#1080#1074#1072'>'
  ClientHeight = 367
  ClientWidth = 853
  ExplicitWidth = 869
  ExplicitHeight = 402
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 26
    Width = 853
    Height = 341
    Align = alClient
    TabOrder = 0
    LookAndFeel.Kind = lfStandard
    LookAndFeel.NativeStyle = False
    LookAndFeel.SkinName = ''
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
      OptionsBehavior.IncSearchItem = clCarName
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Appending = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object clCarCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'CarCode'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 52
      end
      object clCarModelName: TcxGridDBColumn
        Caption = #1052#1072#1088#1082'a '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
        DataBinding.FieldName = 'CarModelName'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 150
      end
      object clCarName: TcxGridDBColumn
        Caption = #1043#1086#1089'.'#1085#1086#1084#1077#1088
        DataBinding.FieldName = 'CarName'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 120
      end
      object clAmount_Internal: TcxGridDBColumn
        Caption = #1043#1086#1088#1086#1076', '#1050#1086#1083'-'#1074#1086' '#1085#1072' 100 '#1082#1084
        DataBinding.FieldName = 'Amount_Internal'
        HeaderAlignmentVert = vaCenter
        Width = 85
      end
      object clAmountColdHour_Internal: TcxGridDBColumn
        Caption = #1043#1086#1088#1086#1076', '#1085#1072' '#1061#1086#1083#1086#1076' '#1074' '#1095#1072#1089
        DataBinding.FieldName = 'AmountColdHour_Internal'
        HeaderAlignmentVert = vaCenter
        Width = 92
      end
      object clAmountColdDistance_Internal: TcxGridDBColumn
        Caption = #1043#1086#1088#1086#1076', '#1085#1072' '#1061#1086#1083#1086#1076' '#1079#1072' 100 '#1082#1084
        DataBinding.FieldName = 'AmountColdDistance_Internal'
        HeaderAlignmentVert = vaCenter
        Width = 90
      end
      object clAmount_External: TcxGridDBColumn
        Caption = #1052#1077#1078#1075#1086#1088#1086#1076', '#1050#1086#1083'-'#1074#1086' '#1085#1072' 100 '#1082#1084
        DataBinding.FieldName = 'Amount_External'
        HeaderAlignmentVert = vaCenter
        Width = 88
      end
      object clAmountColdHour_External: TcxGridDBColumn
        Caption = #1052#1077#1078#1075#1086#1088#1086#1076', '#1085#1072' '#1061#1086#1083#1086#1076' '#1074' '#1095#1072#1089
        DataBinding.FieldName = 'AmountColdHour_External'
        HeaderAlignmentVert = vaCenter
        Width = 91
      end
      object clAmountColdDistance_External: TcxGridDBColumn
        Caption = #1052#1077#1078#1075#1086#1088#1086#1076', '#1085#1072' '#1061#1086#1083#1086#1076' '#1079#1072' 100 '#1082#1084
        DataBinding.FieldName = 'AmountColdDistance_External'
        HeaderAlignmentVert = vaCenter
        Width = 87
      end
      object clErased: TcxGridDBColumn
        Caption = #1059#1076#1072#1083#1077#1085
        DataBinding.FieldName = 'isErased'
        PropertiesClassName = 'TcxCheckBoxProperties'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        HeaderGlyphAlignmentHorz = taCenter
        Options.Editing = False
        Width = 71
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
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
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbChoiceGuides'
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
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100
      Category = 0
      Visible = ivAlways
      ImageIndex = 1
      ShortCut = 115
    end
    object bbErased: TdxBarButton
      Action = dsdSetErased
      Category = 0
    end
    object bbUnErased: TdxBarButton
      Action = dsdSetUnErased
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
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 288
    Top = 160
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
    end
    object actInsert: TdsdInsertUpdateAction
      Category = 'DSDLib'
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100
      ShortCut = 45
      ImageIndex = 0
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
        end>
      isShowModal = True
      DataSource = DataSource
      DataSetRefresh = actRefresh
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      StoredProc = spInsertUpdateObject
      StoredProcList = <
        item
          StoredProc = spInsertUpdateObject
        end>
      Caption = 'actUpdateDataSet'
      DataSource = DataSource
    end
    object dsdSetErased: TdsdUpdateErased
      Category = 'DSDLib'
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
      Params = <
        item
          Name = 'Key'
          Component = ClientDataSet
          ComponentItem = 'Id'
          DataType = ftString
        end
        item
          Name = 'TextValue'
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
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_RateFuel'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Value = Null
      end>
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
    Left = 168
    Top = 216
  end
  object spErasedUnErased: TdsdStoredProc
    StoredProcName = 'gpUpdateObjectIsErased'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inObjectId'
        Component = ClientDataSet
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Left = 288
    Top = 208
  end
  object spInsertUpdateObject: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_RateFuel'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = ClientDataSet
        ComponentItem = 'CarId'
        ParamType = ptInputOutput
      end
      item
        Name = 'inRateFuelId_Internal'
        Component = ClientDataSet
        ComponentItem = 'RateFuelId_Internal'
        ParamType = ptInput
      end
      item
        Name = 'inRateFuelId_External'
        Component = ClientDataSet
        ComponentItem = 'RateFuelId_External'
        ParamType = ptInput
      end
      item
        Name = 'inAmount_Internal '
        Component = ClientDataSet
        ComponentItem = 'Amount_Internal'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inAmountColdHour_Internal'
        Component = ClientDataSet
        ComponentItem = 'AmountColdHour_Internal'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inAmountColdDistance_Internal'
        Component = ClientDataSet
        ComponentItem = 'AmountColdDistance_Internal'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inAmount_External'
        Component = ClientDataSet
        ComponentItem = 'Amount_External'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inAmountColdHour_External'
        Component = ClientDataSet
        ComponentItem = 'AmountColdHour_External'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inAmountColdDistance_External'
        Component = ClientDataSet
        ComponentItem = 'AmountColdDistance_External'
        DataType = ftFloat
        ParamType = ptInput
      end>
    Left = 128
    Top = 296
  end
end
