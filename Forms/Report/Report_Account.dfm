object Report_AccountForm: TReport_AccountForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' c'#1095#1077#1090#1091
  ClientHeight = 395
  ClientWidth = 1189
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
  PixelsPerInch = 96
  TextHeight = 13
  object cxGrid: TcxGrid
    Left = 0
    Top = 57
    Width = 1189
    Height = 338
    Align = alClient
    TabOrder = 0
    ExplicitTop = 113
    ExplicitHeight = 282
    object cxGridDBTableView: TcxGridDBTableView
      Navigator.Buttons.CustomButtons = <>
      DataController.DataSource = DataSource
      DataController.Filter.Active = True
      DataController.Summary.DefaultGroupSummaryItems = <
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Position = spFooter
        end
        item
          Format = ',0.00'
          Position = spFooter
        end
        item
          Format = ',0.00'
          Position = spFooter
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = StartSumm
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = InSumm
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = OutSumm
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = EndSumm
        end>
      DataController.Summary.FooterSummaryItems = <
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = StartSumm
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = InSumm
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = EndSumm
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
          Kind = skSum
        end
        item
          Format = ',0.00'
        end
        item
          Format = ',0.00'
        end
        item
          Format = ',0.00'
          Kind = skSum
          Column = OutSumm
        end>
      DataController.Summary.SummaryGroups = <>
      Images = dmMain.SortImageList
      OptionsBehavior.IncSearch = True
      OptionsCustomize.ColumnHiding = True
      OptionsCustomize.ColumnsQuickCustomization = True
      OptionsData.Deleting = False
      OptionsData.DeletingConfirmation = False
      OptionsData.Editing = False
      OptionsData.Inserting = False
      OptionsView.ColumnAutoWidth = True
      OptionsView.Footer = True
      OptionsView.GroupSummaryLayout = gslAlignWithColumns
      OptionsView.HeaderAutoHeight = True
      Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      object PersonalCode: TcxGridDBColumn
        Caption = #1050#1086#1076
        DataBinding.FieldName = 'PersonalCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 32
      end
      object PersonalName: TcxGridDBColumn
        Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082' ('#1042#1086#1076#1080#1090#1077#1083#1100')'
        DataBinding.FieldName = 'PersonalName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 108
      end
      object InfoMoneyCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1059#1055' '#1089#1090'. '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoMoneyCode'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 70
      end
      object InfoMoneyGroupName: TcxGridDBColumn
        Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoMoneyGroupName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object InfoMoneyDestinationName: TcxGridDBColumn
        Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
        DataBinding.FieldName = 'InfoMoneyDestinationName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object InfoManeyName: TcxGridDBColumn
        Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
        DataBinding.FieldName = 'InfoManeyName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object CarModelName: TcxGridDBColumn
        Caption = #1052#1072#1088#1082'a '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
        DataBinding.FieldName = 'CarModelName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Width = 70
      end
      object CarCode: TcxGridDBColumn
        Caption = #1050#1086#1076' '#1072#1074#1090#1086#1084#1086#1073#1080#1083#1103
        DataBinding.FieldName = 'CarCode'
        Visible = False
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 55
      end
      object CarName: TcxGridDBColumn
        Caption = #1040#1074#1090#1086#1084#1086#1073#1080#1083#1100
        DataBinding.FieldName = 'CarName'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 100
      end
      object StartSumm: TcxGridDBColumn
        Caption = #1053#1072#1095'. '#1086#1089#1090'.  '#1089#1091#1084#1084#1072
        DataBinding.FieldName = 'StartSumm'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 82
      end
      object InSumm: TcxGridDBColumn
        Caption = #1055#1088#1080#1093#1086#1076' '#1089#1091#1084#1084#1072
        DataBinding.FieldName = 'InSumm'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 83
      end
      object OutSumm: TcxGridDBColumn
        Caption = #1056#1072#1089#1093#1086#1076' '#1089#1091#1084#1084#1072
        DataBinding.FieldName = 'OutSumm'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 93
      end
      object EndSumm: TcxGridDBColumn
        Caption = #1050#1086#1085'. '#1086#1089#1090'. '#1089#1091#1084#1084#1072
        DataBinding.FieldName = 'EndSumm'
        PropertiesClassName = 'TcxCurrencyEditProperties'
        Properties.DisplayFormat = ',0.00;-,0.00'
        HeaderAlignmentHorz = taCenter
        HeaderAlignmentVert = vaCenter
        Options.Editing = False
        Width = 90
      end
    end
    object cxGridLevel: TcxGridLevel
      GridView = cxGridDBTableView
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 26
    Width = 1189
    Height = 31
    Align = alTop
    TabOrder = 5
    object deStart: TcxDateEdit
      Left = 101
      Top = 5
      EditValue = 41548d
      Properties.ShowTime = False
      TabOrder = 0
      Width = 85
    end
    object deEnd: TcxDateEdit
      Left = 310
      Top = 5
      EditValue = 41557d
      Properties.ShowTime = False
      TabOrder = 1
      Width = 85
    end
    object cxLabel2: TcxLabel
      Left = 409
      Top = 6
      Caption = #1057#1095#1077#1090':'
    end
    object edAccount: TcxButtonEdit
      Left = 442
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 3
      Width = 200
    end
    object cxLabel1: TcxLabel
      Left = 10
      Top = 6
      Caption = #1053#1072#1095#1072#1083#1086' '#1087#1077#1088#1080#1086#1076#1072':'
    end
    object cxLabel3: TcxLabel
      Left = 200
      Top = 6
      Caption = #1054#1082#1086#1085#1095#1072#1085#1080#1077' '#1087#1077#1088#1080#1086#1076#1072':'
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 56
    Top = 64
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 64
    Top = 256
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd
        Properties.Strings = (
          'Align'
          'AlignWithMargins'
          'Anchors'
          'AutoSize'
          'BeepOnEnter'
          'BiDiMode'
          'Constraints'
          'Cursor'
          'CustomHint'
          'Date'
          'DragCursor'
          'DragKind'
          'DragMode'
          'EditValue'
          'Enabled'
          'FakeStyleController'
          'Height'
          'HelpContext'
          'HelpKeyword'
          'HelpType'
          'Hint'
          'ImeMode'
          'ImeName'
          'Left'
          'Margins'
          'Name'
          'ParentBiDiMode'
          'ParentColor'
          'ParentCustomHint'
          'ParentFont'
          'ParentShowHint'
          'PopupMenu'
          'Properties'
          'RepositoryItem'
          'ShowHint'
          'Style'
          'StyleDisabled'
          'StyleFocused'
          'StyleHot'
          'TabOrder'
          'TabStop'
          'Tag'
          'TextHint'
          'Top'
          'Touch'
          'Visible'
          'Width')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Align'
          'AlignWithMargins'
          'Anchors'
          'AutoSize'
          'BeepOnEnter'
          'BiDiMode'
          'Constraints'
          'Cursor'
          'CustomHint'
          'Date'
          'DragCursor'
          'DragKind'
          'DragMode'
          'EditValue'
          'Enabled'
          'FakeStyleController'
          'Height'
          'HelpContext'
          'HelpKeyword'
          'HelpType'
          'Hint'
          'ImeMode'
          'ImeName'
          'Left'
          'Margins'
          'Name'
          'ParentBiDiMode'
          'ParentColor'
          'ParentCustomHint'
          'ParentFont'
          'ParentShowHint'
          'PopupMenu'
          'Properties'
          'RepositoryItem'
          'ShowHint'
          'Style'
          'StyleDisabled'
          'StyleFocused'
          'StyleHot'
          'TabOrder'
          'TabStop'
          'Tag'
          'TextHint'
          'Top'
          'Touch'
          'Visible'
          'Width')
      end
      item
        Component = edAccount
        Properties.Strings = (
          'Align'
          'AlignWithMargins'
          'Anchors'
          'AutoSize'
          'BeepOnEnter'
          'Constraints'
          'Cursor'
          'CustomHint'
          'DragCursor'
          'DragKind'
          'DragMode'
          'Enabled'
          'FakeStyleController'
          'Height'
          'HelpContext'
          'HelpKeyword'
          'HelpType'
          'Hint'
          'ImeMode'
          'ImeName'
          'Left'
          'Margins'
          'Name'
          'ParentColor'
          'ParentCustomHint'
          'ParentFont'
          'ParentShowHint'
          'PopupMenu'
          'Properties'
          'RepositoryItem'
          'ShowHint'
          'Style'
          'StyleDisabled'
          'StyleFocused'
          'StyleHot'
          'TabOrder'
          'TabStop'
          'Tag'
          'Text'
          'TextHint'
          'Top'
          'Touch'
          'Visible'
          'Width')
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
    Left = 584
    Top = 256
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
    Left = 144
    Top = 24
    DockControlHeights = (
      0
      0
      26
      0)
    object dxBarManagerBar1: TdxBar
      Caption = 'Custom'
      CaptionButtons = <>
      DockedDockingStyle = dsTop
      DockedLeft = 2
      DockedTop = 0
      DockingStyle = dsTop
      FloatLeft = 671
      FloatTop = 8
      FloatClientWidth = 0
      FloatClientHeight = 0
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'bbToExcel'
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
    object bbDialogForm: TdxBarButton
      Caption = #1044#1080#1072#1083#1086#1075' '#1091#1089#1090#1072#1085#1086#1074#1082#1080' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074
      Category = 0
      Hint = #1044#1080#1072#1083#1086#1075' '#1091#1089#1090#1072#1085#1086#1074#1082#1080' '#1087#1072#1088#1072#1084#1077#1090#1088#1086#1074
      Visible = ivAlways
      ImageIndex = 35
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 232
    Top = 240
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
      RefreshOnTabSetChanges = False
    end
    object actExportToExcel: TdsdGridToExcel
      Category = 'DSDLib'
      Grid = cxGrid
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpReport_Account'
    DataSet = ClientDataSet
    DataSets = <
      item
        DataSet = ClientDataSet
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 41548d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41557d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inAccountId'
        Value = ''
        Component = AccountGuides
        ParamType = ptInput
      end>
    Left = 152
    Top = 248
  end
  object dsdDBViewAddOn: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    Left = 312
    Top = 264
  end
  object dsdUserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 432
    Top = 232
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    DateEnd = deEnd
    Left = 200
    Top = 64
  end
  object RefreshDispatcher: TRefreshDispatcher
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Left = 328
    Top = 64
  end
  object AccountGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edAccount
    FormName = 'TAccountForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = AccountGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = AccountGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 640
    Top = 32
  end
end
