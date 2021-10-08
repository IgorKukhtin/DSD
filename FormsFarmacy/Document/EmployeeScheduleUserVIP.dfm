inherited EmployeeScheduleUserVIPForm: TEmployeeScheduleUserVIPForm
  Caption = #1042#1074#1086#1076' '#1074#1088#1077#1084#1077#1085#1080' '#1087#1088#1080#1093#1086#1076#1072' '#1080' '#1091#1093#1086#1076#1072
  ClientHeight = 518
  ClientWidth = 929
  Position = poScreenCenter
  AddOnFormData.SetFocusedAction = actSetFocused
  ExplicitWidth = 945
  ExplicitHeight = 557
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel [0]
    Left = 0
    Top = 0
    Width = 929
    Height = 73
    Align = alTop
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 0
    ExplicitWidth = 774
    object cbEndHour: TcxComboBox
      Left = 371
      Top = 44
      Properties.Items.Strings = (
        ''
        '0'
        '1'
        '2'
        '3'
        '4'
        '5'
        '6'
        '7'
        '8'
        '9'
        '10'
        '11'
        '12'
        '13'
        '14'
        '15'
        '16'
        '17'
        '18'
        '19'
        '20'
        '21'
        '22'
        '23')
      TabOrder = 0
      Width = 54
    end
    object cbEndMin: TcxComboBox
      Left = 438
      Top = 44
      Properties.Items.Strings = (
        ''
        '00'
        '30')
      TabOrder = 1
      Width = 54
    end
    object cbStartHour: TcxComboBox
      Left = 371
      Top = 21
      Properties.Items.Strings = (
        ''
        '0'
        '1'
        '2'
        '3'
        '4'
        '5'
        '6'
        '7'
        '8'
        '9'
        '10'
        '11'
        '12'
        '13'
        '14'
        '15'
        '16'
        '17'
        '18'
        '19'
        '20'
        '21'
        '22'
        '23')
      TabOrder = 2
      Width = 54
    end
    object cbStartMin: TcxComboBox
      Left = 438
      Top = 21
      Properties.Items.Strings = (
        ''
        '00'
        '30')
      TabOrder = 3
      Width = 54
    end
    object cxLabel2: TcxLabel
      Left = 26
      Top = 21
      Caption = #1057#1077#1075#1086#1076#1085#1103
    end
    object cxLabel3: TcxLabel
      Left = 206
      Top = 21
      Caption = #1042#1088#1077#1084#1103' '#1092#1072#1082#1090#1080#1095#1077#1089#1082#1086#1075#1086' '#1087#1088#1080#1093#1086#1076#1072':'
    end
    object cxLabel4: TcxLabel
      Left = 206
      Top = 44
      Caption = #1042#1088#1077#1084#1103' '#1092#1072#1082#1090#1080#1095#1077#1089#1082#1086#1075#1086' '#1091#1093#1086#1076#1072':'
    end
    object cxLabel5: TcxLabel
      Left = 206
      Top = 2
      Caption = 
        #1042#1088#1077#1084#1103' '#1092#1072#1082#1090#1080#1095#1077#1089#1082#1086#1075#1086' '#1087#1088#1080#1093#1086#1076#1072' '#1080' '#1091#1093#1086#1076#1072'  '#1074#1074#1086#1076#1080#1090#1089#1103' '#1082#1088#1072#1090#1085#1086' 30 '#1084#1080#1085'. '#1074' '#1074#1080 +
        #1076#1077' '#1063#1063':MM'
    end
    object cxLabel6: TcxLabel
      Left = 425
      Top = 22
      Caption = ' : '
    end
    object cxLabel7: TcxLabel
      Left = 425
      Top = 45
      Caption = ' : '
    end
    object edOperDate: TcxDateEdit
      Left = 79
      Top = 20
      TabStop = False
      EditValue = 42132d
      Properties.DisplayFormat = 'dd.mm.yyyy'
      Properties.EditFormat = 'dd.mm.yyyy'
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 100
    end
    object cxButton2: TcxButton
      Left = 615
      Top = 36
      Width = 75
      Height = 25
      Action = actFormCloseCancel
      ModalResult = 2
      TabOrder = 11
    end
    object cxButton1: TcxButton
      Left = 521
      Top = 36
      Width = 75
      Height = 25
      Action = actFormCloseOk
      Default = True
      ModalResult = 1
      TabOrder = 12
    end
  end
  object Panel2: TPanel [1]
    Left = 0
    Top = 73
    Width = 929
    Height = 445
    Align = alClient
    Caption = 'Panel2'
    ShowCaption = False
    TabOrder = 1
    ExplicitWidth = 774
    ExplicitHeight = 455
    object cxGrid: TcxGrid
      Left = 1
      Top = 1
      Width = 927
      Height = 443
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 2
      ExplicitTop = -2
      ExplicitWidth = 772
      ExplicitHeight = 453
      object cxGridDBTableView: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = MasterDS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        Images = dmMain.SortImageList
        OptionsBehavior.GoToNextCellOnEnter = True
        OptionsBehavior.FocusCellOnCycle = True
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsCustomize.DataRowSizing = True
        OptionsData.CancelOnExit = False
        OptionsData.Inserting = False
        OptionsView.GroupByBox = False
        OptionsView.GroupSummaryLayout = gslAlignWithColumns
        OptionsView.HeaderAutoHeight = True
        OptionsView.Indicator = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
      end
      object cxGridDBBandedTableView1: TcxGridDBBandedTableView
        Navigator.Buttons.CustomButtons = <>
        Navigator.Buttons.First.Visible = True
        Navigator.Buttons.PriorPage.Visible = True
        Navigator.Buttons.Prior.Visible = True
        Navigator.Buttons.Next.Visible = True
        Navigator.Buttons.NextPage.Visible = True
        Navigator.Buttons.Last.Visible = True
        Navigator.Buttons.Insert.Visible = True
        Navigator.Buttons.Append.Visible = False
        Navigator.Buttons.Delete.Visible = True
        Navigator.Buttons.Edit.Visible = True
        Navigator.Buttons.Post.Visible = True
        Navigator.Buttons.Cancel.Visible = True
        Navigator.Buttons.Refresh.Visible = True
        Navigator.Buttons.SaveBookmark.Visible = True
        Navigator.Buttons.GotoBookmark.Visible = True
        Navigator.Buttons.Filter.Visible = True
        DataController.DataSource = MasterDS
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsView.GroupByBox = False
        Styles.Content = dmMain.cxContentStyle
        Styles.Inactive = dmMain.cxSelection
        Styles.Selection = dmMain.cxSelection
        Styles.Header = dmMain.cxContentStyle
        Bands = <
          item
            Caption = #1043#1088#1072#1092#1080#1082' '#1088#1072#1073#1086#1090#1099' '#1087#1086' '#1076#1085#1103#1084
            FixedKind = fkLeft
            Styles.Header = dmMain.cxFooterStyle
            Width = 259
          end
          item
            Caption = #1055#1077#1088#1080#1086#1076
            Width = 55
          end>
        object Name0: TcxGridDBBandedColumn
          Caption = #1044#1072#1090#1099' '#1090#1077#1082#1091#1097#1077#1075#1086' '#1084#1077#1089#1103#1094#1072
          DataBinding.FieldName = 'Name0'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 239
          Position.BandIndex = 0
          Position.ColIndex = 0
          Position.RowIndex = 0
        end
        object Name1: TcxGridDBBandedColumn
          Caption = ' '
          DataBinding.FieldName = 'Name1'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 239
          Position.BandIndex = 0
          Position.ColIndex = 0
          Position.RowIndex = 1
        end
        object Name2: TcxGridDBBandedColumn
          Caption = ' '
          DataBinding.FieldName = 'Name2'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 239
          Position.BandIndex = 0
          Position.ColIndex = 0
          Position.RowIndex = 2
        end
        object Value: TcxGridDBBandedColumn
          DataBinding.FieldName = 'Value'
          Visible = False
          HeaderAlignmentHorz = taCenter
          MinWidth = 45
          Options.Editing = False
          Styles.Content = dmMain.cxFooterStyle
          Width = 65
          Position.BandIndex = 1
          Position.ColIndex = 0
          Position.RowIndex = 0
        end
        object ValueStart: TcxGridDBBandedColumn
          DataBinding.FieldName = 'ValueStart'
          Visible = False
          HeaderAlignmentHorz = taCenter
          MinWidth = 45
          Options.Editing = False
          Width = 65
          Position.BandIndex = 1
          Position.ColIndex = 0
          Position.RowIndex = 1
        end
        object ValueEnd: TcxGridDBBandedColumn
          DataBinding.FieldName = 'ValueEnd'
          Visible = False
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 65
          Position.BandIndex = 1
          Position.ColIndex = 0
          Position.RowIndex = 2
        end
        object Color_Calc: TcxGridDBBandedColumn
          DataBinding.FieldName = 'Color_Calc'
          Visible = False
          Options.Editing = False
          Position.BandIndex = 0
          Position.ColIndex = 1
          Position.RowIndex = 0
        end
      end
      object cxGridLevel: TcxGridLevel
        GridView = cxGridDBBandedTableView1
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 203
    Top = 216
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 208
    Top = 288
  end
  inherited ActionList: TActionList
    Left = 103
    Top = 271
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end>
    end
    object actFormCloseCancel: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = #1054#1090#1084#1077#1085#1072
    end
    object actFormCloseOk: TdsdFormClose
      Category = 'DSDLib'
      MoveParams = <>
      BeforeAction = actInsertUpdateMI
      PostDataSetBeforeExecute = False
      Caption = #1057#1086#1093#1088#1072#1085#1080#1090#1100
    end
    object actInsertUpdateMI: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdateMI
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMI
        end>
      Caption = 'actInsertUpdateMI'
    end
    object actSetFocused: TdsdSetFocusedAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actSetFocused'
      ControlName.Value = ''
      ControlName.Component = FormParams
      ControlName.ComponentItem = 'GridColumns'
      ControlName.DataType = ftString
      ControlName.MultiSelectSeparator = ','
    end
  end
  object MasterCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 32
    Top = 216
  end
  object HeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 376
    Top = 144
  end
  object spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_EmployeeScheduleVIP_User'
    DataSet = HeaderCDS
    DataSets = <
      item
        DataSet = HeaderCDS
      end
      item
        DataSet = MasterCDS
      end>
    OutputType = otMultiDataSet
    Params = <>
    PackSize = 1
    Left = 96
    Top = 208
  end
  object MasterDS: TDataSource
    DataSet = MasterCDS
    Left = 32
    Top = 280
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_MovementItem_EmployeeScheduleVIP_User'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'OperDate'
        Value = 42132d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartHour'
        Value = ''
        Component = cbStartHour
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartMin'
        Value = ''
        Component = cbStartMin
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndHour'
        Value = ''
        Component = cbEndHour
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndMin'
        Value = ''
        Component = cbEndMin
        MultiSelectSeparator = ','
      end
      item
        Name = 'ServiceExit'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'GridColumns'
        Value = Null
        Component = FormParams
        ComponentItem = 'GridColumns'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 24
    Top = 352
  end
  object CrossDBViewAddOn: TCrossDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBBandedTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ColorColumn = Value
        BackGroundValueColumn = Color_Calc
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    HeaderDataSet = HeaderCDS
    HeaderColumnName = 'ValueField'
    TemplateColumn = Value
    Left = 376
    Top = 232
  end
  object CrossDBViewStartAddOn: TCrossDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBBandedTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ColorColumn = ValueStart
        BackGroundValueColumn = Color_Calc
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    HeaderDataSet = HeaderCDS
    HeaderColumnName = 'ValueFieldNill'
    TemplateColumn = ValueStart
    Left = 520
    Top = 232
  end
  object CrossDBViewEndAddOn: TCrossDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBBandedTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <
      item
        ColorColumn = ValueEnd
        BackGroundValueColumn = Color_Calc
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    ShowFieldImageList = <>
    PropertiesCellList = <>
    HeaderDataSet = HeaderCDS
    HeaderColumnName = 'ValueFieldNill'
    TemplateColumn = ValueEnd
    Left = 520
    Top = 312
  end
  object spInsertUpdateMI: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_EmployeeScheduleVIP_User'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inStartHour'
        Value = Null
        Component = cbStartHour
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartMin'
        Value = Null
        Component = cbStartMin
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndHour'
        Value = Null
        Component = cbEndHour
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndMin'
        Value = Null
        Component = cbEndMin
        DataType = ftString
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 360
    Top = 296
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'GridColumns'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 104
    Top = 360
  end
end
