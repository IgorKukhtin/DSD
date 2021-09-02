inherited Report_SheetWorkTimeForm: TReport_SheetWorkTimeForm
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1090#1072#1073#1077#1083#1102' '#1088#1072#1073#1086#1095#1077#1075#1086' '#1074#1088#1077#1084#1077#1085#1080
  ClientHeight = 519
  ClientWidth = 1091
  AddOnFormData.ExecuteDialogAction = actReport_SheetWorkTimeDialog
  ExplicitWidth = 1107
  ExplicitHeight = 557
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1091
    Height = 462
    TabOrder = 3
    ExplicitWidth = 1091
    ExplicitHeight = 462
    ClientRectBottom = 462
    ClientRectRight = 1091
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1091
      ExplicitHeight = 462
      inherited cxGrid: TcxGrid
        Width = 1091
        Height = 320
        ExplicitWidth = 1091
        ExplicitHeight = 320
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.DataSource = nil
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
        object cxGridDBBandedTableView1: TcxGridDBBandedTableView [1]
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = MasterDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Options = [dcoAssignGroupingValues, dcoAssignMasterDetailKeys, dcoSaveExpanding, dcoGroupsAlwaysExpanded]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.##'
              Kind = skSum
              Column = Amount_1
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Amount_2
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Amount_3
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Amount_4
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Amount_5
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Amount_6
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = MemberName
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Amount_1
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Amount_2
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Amount_3
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Amount_4
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Amount_5
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Amount_6
            end>
          DataController.Summary.SummaryGroups = <>
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.BandHiding = True
          OptionsCustomize.BandsQuickCustomization = True
          OptionsCustomize.ColumnVertSizing = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsSelection.InvertSelect = False
          OptionsView.Footer = True
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.Content = dmMain.cxContentStyle
          Styles.Inactive = dmMain.cxSelection
          Styles.Selection = dmMain.cxSelection
          Styles.Footer = dmMain.cxFooterStyle
          Styles.Header = dmMain.cxHeaderStyle
          Styles.StyleSheet = dmMain.cxGridBandedTableViewStyleSheet
          Styles.BandHeader = dmMain.cxHeaderStyle
          Bands = <
            item
              Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' / '#1057#1086#1090#1088#1091#1076#1085#1080#1082
              Width = 460
            end
            item
              Caption = #1055#1077#1088#1080#1086#1076
              Options.HoldOwnColumnsOnly = True
              Options.Moving = False
              Width = 57
            end>
          object UnitName: TcxGridDBBandedColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            Visible = False
            GroupIndex = 0
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 104
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object MemberCode: TcxGridDBBandedColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'MemberCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 20
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object MemberName: TcxGridDBBandedColumn
            Caption = #1060#1048#1054
            DataBinding.FieldName = 'MemberName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 69
            Position.BandIndex = 0
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
          object PositionName: TcxGridDBBandedColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 62
            Position.BandIndex = 0
            Position.ColIndex = 4
            Position.RowIndex = 0
          end
          object PositionLevelName: TcxGridDBBandedColumn
            Caption = #1056#1072#1079#1088#1103#1076
            DataBinding.FieldName = 'PositionLevelName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 52
            Position.BandIndex = 0
            Position.ColIndex = 5
            Position.RowIndex = 0
          end
          object DateIn: TcxGridDBBandedColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1080#1077#1084#1072
            DataBinding.FieldName = 'DateIn'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
            Position.BandIndex = 0
            Position.ColIndex = 6
            Position.RowIndex = 0
          end
          object DateOut: TcxGridDBBandedColumn
            Caption = #1044#1072#1090#1072' '#1091#1074#1086#1083#1100#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'DateOut'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
            Position.BandIndex = 0
            Position.ColIndex = 7
            Position.RowIndex = 0
          end
          object PersonalGroupName: TcxGridDBBandedColumn
            Caption = #1041#1088#1080#1075#1072#1076#1072
            DataBinding.FieldName = 'PersonalGroupName'
            Visible = False
            GroupIndex = 1
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 47
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object Amount_1: TcxGridDBBandedColumn
            Caption = '1.'#1095#1072#1089#1099
            DataBinding.FieldName = 'Amount_1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1095#1072#1089#1086#1074
            MinWidth = 15
            Options.Editing = False
            Options.Moving = False
            Width = 29
            Position.BandIndex = 0
            Position.ColIndex = 8
            Position.RowIndex = 0
          end
          object Amount_2: TcxGridDBBandedColumn
            Caption = '2.'#1089#1084'.'
            DataBinding.FieldName = 'Amount_2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1089#1084#1077#1085
            MinWidth = 15
            Options.Editing = False
            Options.Moving = False
            Width = 37
            Position.BandIndex = 0
            Position.ColIndex = 9
            Position.RowIndex = 0
          end
          object Amount_3: TcxGridDBBandedColumn
            Caption = '3.'#1096#1090'.'#1077#1076
            DataBinding.FieldName = 'Amount_3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1096#1090#1072#1090#1085#1099#1093' '#1077#1076#1080#1085#1080#1094
            MinWidth = 15
            Options.Editing = False
            Options.Moving = False
            Width = 29
            Position.BandIndex = 0
            Position.ColIndex = 10
            Position.RowIndex = 0
          end
          object Amount_4: TcxGridDBBandedColumn
            Caption = '4.'#1041#1051
            DataBinding.FieldName = 'Amount_4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1041#1086#1083#1100#1085#1080#1095#1085#1099#1077
            MinWidth = 15
            Options.Editing = False
            Options.Moving = False
            Width = 64
            Position.BandIndex = 0
            Position.ColIndex = 13
            Position.RowIndex = 0
          end
          object Amount_5: TcxGridDBBandedColumn
            Caption = '5.'#1086#1090#1087'.'
            DataBinding.FieldName = 'Amount_5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1086#1090#1087#1091#1089#1082
            MinWidth = 15
            Options.Editing = False
            Options.Moving = False
            Width = 64
            Position.BandIndex = 0
            Position.ColIndex = 11
            Position.RowIndex = 0
          end
          object Amount_6: TcxGridDBBandedColumn
            Caption = '6.'#1087#1088#1086#1075'.'
            DataBinding.FieldName = 'Amount_6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1048#1090#1086#1075#1086' '#1087#1088#1086#1075#1091#1083#1086#1074
            MinWidth = 15
            Options.Editing = False
            Options.Moving = False
            Width = 64
            Position.BandIndex = 0
            Position.ColIndex = 12
            Position.RowIndex = 0
          end
          object Value: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Value'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            MinWidth = 40
            Options.Editing = False
            VisibleForCustomization = False
            Width = 40
            Position.BandIndex = 1
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
        end
        inherited cxGridLevel: TcxGridLevel
          GridView = cxGridDBBandedTableView1
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 328
        Width = 1091
        Height = 134
        Align = alBottom
        TabOrder = 1
        object cxGridDBBandedTableView2: TcxGridDBBandedTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = TotalDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Options = [dcoAssignGroupingValues, dcoAssignMasterDetailKeys, dcoSaveExpanding, dcoGroupsAlwaysExpanded]
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
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
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsSelection.InvertSelect = False
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridBandedTableViewStyleSheet
          Styles.BandHeader = dmMain.cxHeaderStyle
          Bands = <
            item
              Caption = #1048#1090#1086#1075#1080
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
          object Name_ch2: TcxGridDBBandedColumn
            Caption = #1044#1072#1085#1085#1099#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            MinWidth = 67
            Options.Editing = False
            Options.Moving = False
            Width = 162
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object TotalAmount_ch2: TcxGridDBBandedColumn
            Caption = #1048#1090#1086#1075#1086
            DataBinding.FieldName = 'TotalAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            MinWidth = 67
            Options.Editing = False
            Options.Moving = False
            Width = 80
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object Value_ch2: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Value'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Visible = False
            MinWidth = 40
            Width = 40
            Position.BandIndex = 1
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBBandedTableView2
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 320
        Width = 1091
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = cxGrid1
      end
    end
  end
  inherited Panel: TPanel
    Width = 1091
    ExplicitWidth = 1091
    object cxLabel4: TcxLabel
      Left = 420
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object edUnit: TcxButtonEdit
      Left = 505
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 246
    end
  end
  object edMember: TcxButtonEdit [2]
    Left = 834
    Top = 5
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 6
    Width = 246
  end
  object cxLabel3: TcxLabel [3]
    Left = 772
    Top = 6
    Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deEnd
        Properties.Strings = (
          'Date')
      end
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = GuidesUnit
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GuidesMember
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    object actReport_SheetWorkTimeDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_SheetWorkTimeDialogForm'
      FormNameParam.Value = 'TReport_SheetWorkTimeDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = Null
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberId'
          Value = Null
          Component = GuidesMember
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberName'
          Value = Null
          Component = GuidesMember
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 336
    Top = 176
  end
  inherited MasterCDS: TClientDataSet
    Left = 376
    Top = 168
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_SheetWorkTime'
    DataSet = HeaderCDS
    DataSets = <
      item
        DataSet = HeaderCDS
      end
      item
        DataSet = MasterCDS
      end
      item
        DataSet = TotalCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inStartDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41395d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId'
        Value = Null
        Component = GuidesMember
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 440
    Top = 176
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end>
    end
    object dxBarButton1: TdxBarButton
      Action = actReport_SheetWorkTimeDialog
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    View = nil
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 32
    Top = 184
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 80
    Top = 184
  end
  object HeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 408
    Top = 224
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_SheetWorkTimeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_SheetWorkTimeForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 600
    Top = 32
  end
  object RefreshDispatcher1: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
      end
      item
        Component = GuidesUnit
      end
      item
        Component = GuidesMember
      end>
    Left = 672
    Top = 40
  end
  object CrossDBViewAddOn: TCrossDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBBandedTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    HeaderDataSet = HeaderCDS
    HeaderColumnName = 'ValueField'
    TemplateColumn = Value
    Left = 360
    Top = 272
  end
  object GuidesMember: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMember
    FormNameParam.Value = 'TMember_ChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMember_ChoiceForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMember
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 920
  end
  object TotalCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 472
    Top = 399
  end
  object TotalDS: TDataSource
    DataSet = TotalCDS
    Left = 534
    Top = 407
  end
  object CrossDBViewAddOnTotal: TCrossDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBBandedTableView2
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    HeaderDataSet = HeaderCDS
    HeaderColumnName = 'ValueField'
    TemplateColumn = Value
    Left = 624
    Top = 400
  end
end
