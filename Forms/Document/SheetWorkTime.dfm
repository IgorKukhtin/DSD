object SheetWorkTimeForm: TSheetWorkTimeForm
  Left = 0
  Top = 0
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1058#1072#1073#1077#1083#1100' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080'>'
  ClientHeight = 462
  ClientWidth = 971
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
  object DataPanel: TPanel
    Left = 0
    Top = 0
    Width = 971
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object edOperDate: TcxDateEdit
      Left = 1
      Top = 20
      Properties.DisplayFormat = 'mmmm yyyy'
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 1
      Width = 108
    end
    object cxLabel2: TcxLabel
      Left = 1
      Top = 2
      Caption = #1044#1072#1090#1072
    end
    object edUnit: TcxButtonEdit
      Left = 115
      Top = 20
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 0
      Width = 170
    end
    object cxLabel4: TcxLabel
      Left = 115
      Top = 2
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
  end
  object cxGrid: TcxGrid
    Left = 0
    Top = 75
    Width = 971
    Height = 387
    Align = alClient
    TabOrder = 0
    object cxGridDBBandedTableView: TcxGridDBBandedTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = MasterDS
      DataController.Filter.Options = [fcoCaseInsensitive]
      DataController.Options = [dcoAssignGroupingValues, dcoAssignMasterDetailKeys, dcoSaveExpanding, dcoGroupsAlwaysExpanded]
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
      OptionsBehavior.GoToNextCellOnEnter = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsCustomize.BandHiding = True
      OptionsCustomize.BandsQuickCustomization = True
      OptionsCustomize.ColumnVertSizing = False
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Inserting = False
      OptionsSelection.InvertSelect = False
      OptionsView.GroupByBox = False
      OptionsView.HeaderAutoHeight = True
      OptionsView.Indicator = True
      Styles.StyleSheet = dmMain.cxGridBandedTableViewStyleSheet
      Styles.BandHeader = dmMain.cxHeaderStyle
      Bands = <
        item
          Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
          FixedKind = fkLeft
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
        end
        item
          Caption = #1055#1077#1088#1080#1086#1076
          Options.HoldOwnColumnsOnly = True
          Options.Moving = False
          Width = 50
        end>
      object BandcolPersonalCode: TcxGridDBBandedColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'PersonalCode'
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Options.Moving = False
        Width = 34
        Position.BandIndex = 0
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
      object BandcolPersonalName: TcxGridDBBandedColumn
        Caption = #1060#1048#1054
        DataBinding.FieldName = 'PersonalName'
        HeaderAlignmentVert = vaCenter
        MinWidth = 67
        Options.Editing = False
        Options.Moving = False
        Width = 109
        Position.BandIndex = 0
        Position.ColIndex = 1
        Position.RowIndex = 0
      end
      object BandcolPositionName: TcxGridDBBandedColumn
        Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
        DataBinding.FieldName = 'PositionName'
        HeaderAlignmentVert = vaCenter
        MinWidth = 64
        Options.Editing = False
        Options.Moving = False
        Width = 87
        Position.BandIndex = 0
        Position.ColIndex = 2
        Position.RowIndex = 0
      end
      object BandcolUnitName: TcxGridDBBandedColumn
        Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
        DataBinding.FieldName = 'UnitName'
        HeaderAlignmentVert = vaCenter
        MinWidth = 64
        Options.Editing = False
        Options.Moving = False
        Width = 115
        Position.BandIndex = 0
        Position.ColIndex = 3
        Position.RowIndex = 0
      end
      object BandcolPersonalGroupName: TcxGridDBBandedColumn
        Caption = #1041#1088#1080#1075#1072#1076#1072
        DataBinding.FieldName = 'PersonalGroupName'
        Visible = False
        GroupIndex = 0
        HeaderAlignmentVert = vaCenter
        MinWidth = 64
        Options.Editing = False
        Options.Moving = False
        Width = 73
        Position.BandIndex = 0
        Position.ColIndex = 4
        Position.RowIndex = 0
      end
      object TemplateColumn: TcxGridDBBandedColumn
        DataBinding.FieldName = 'Value'
        PropertiesClassName = 'TcxButtonEditProperties'
        Properties.Buttons = <
          item
            Action = OpenWorkTimeKindForm
            Default = True
            Kind = bkEllipsis
          end>
        MinWidth = 40
        Width = 40
        Position.BandIndex = 1
        Position.ColIndex = 0
        Position.RowIndex = 0
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBBandedTableView
    end
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
      end
      item
        Name = 'UnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
      end>
    Left = 278
    Top = 303
  end
  object spSelectMI: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_SheetWorkTime'
    DataSet = HeaderCDS
    DataSets = <
      item
        DataSet = HeaderCDS
      end
      item
        DataSet = MasterCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
      end>
    Left = 408
    Top = 191
  end
  object dxBarManager: TdxBarManager
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
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
    Left = 22
    Top = 231
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar: TdxBar
      AllowClose = False
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 0
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 409
      FloatTop = 390
      FloatClientWidth = 51
      FloatClientHeight = 93
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'bbGridToExel'
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
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbStatic: TdxBarStatic
      Caption = '     '
      Category = 0
      Visible = ivAlways
    end
    object bbGridToExel: TdxBarButton
      Action = GridToExcel
      Category = 0
    end
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
    Left = 81
    Top = 232
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 51
    Top = 231
    object actUpdateMasterDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      StoredProc = spInsertUpdateMI
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMI
        end>
      Caption = 'actUpdateMasterDS'
      DataSource = MasterDS
    end
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      StoredProc = spSelectMI
      StoredProcList = <
        item
          StoredProc = spSelectMI
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
      Params = <
        item
          Name = 'InvNumber'
          Value = ''
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'From'
          Value = ''
          DataType = ftString
          ParamType = ptInput
        end
        item
          Name = 'OperDate'
          Value = 0d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
        end>
      ReportName = #1055#1088#1080#1093#1086#1076#1085#1072#1103' '#1085#1072#1082#1083#1072#1076#1085#1072#1103
    end
    object GridToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object OpenWorkTimeKindForm: TOpenChoiceForm
      Category = 'DSDLib'
      FormName = 'TWorkTimeKindForm'
      GuiParams = <
        item
          Name = 'Key'
          Component = CrossDBViewAddOn
          ComponentItem = 'TypeId'
        end>
      isShowModal = False
    end
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 342
    Top = 191
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 304
    Top = 191
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormName = 'TUnitForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 208
    Top = 16
  end
  object spInsertUpdateMI: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_SheetWorkTime'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioPersonalId'
        Component = MasterCDS
        ComponentItem = 'PersonalId'
        ParamType = ptInputOutput
      end
      item
        Name = 'inPositionId'
        Component = MasterCDS
        ComponentItem = 'PositionId'
        ParamType = ptInput
      end
      item
        Name = 'inUnitId'
        Component = MasterCDS
        ComponentItem = 'UnitId'
        ParamType = ptInput
      end
      item
        Name = 'inPersonalGroupId'
        Component = MasterCDS
        ComponentItem = 'PersonalGroupId'
        ParamType = ptInput
      end
      item
        Name = 'inStartDate'
        Component = HeaderCDS
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'ioValue'
        Component = CrossDBViewAddOn
        ComponentItem = 'Value'
        DataType = ftString
        ParamType = ptInputOutput
      end
      item
        Name = 'inTypeId'
        Component = CrossDBViewAddOn
        ComponentItem = 'TypeId'
        ParamType = ptInput
      end>
    Left = 374
    Top = 183
  end
  object frxDBDataset: TfrxDBDataset
    UserName = 'frxDBDataset'
    CloseDataSource = False
    DataSet = MasterCDS
    BCDToCurrency = False
    Left = 445
    Top = 192
  end
  object CrossDBViewAddOn: TCrossDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBBandedTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    HeaderDataSet = HeaderCDS
    HeaderColumnName = 'ValueField'
    TemplateColumn = TemplateColumn
    Left = 360
    Top = 208
  end
  object HeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 304
    Top = 208
  end
  object RefreshDispatcher: TRefreshDispatcher
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = edOperDate
      end
      item
        Component = GuidesUnit
      end>
    Left = 248
    Top = 48
  end
end
