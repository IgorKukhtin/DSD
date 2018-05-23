object Report_ImplementationPlanEmployeeForm: TReport_ImplementationPlanEmployeeForm
  Left = 0
  Top = 0
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1102' '#1087#1083#1072#1085#1072' '#1087#1088#1086#1076#1072#1078' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091
  ClientHeight = 660
  ClientWidth = 1252
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1252
    Height = 31
    Align = alTop
    TabOrder = 0
    object deStart: TcxDateEdit
      Left = 101
      Top = 5
      EditValue = 43221d
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 0
      Width = 85
    end
    object cxLabel1: TcxLabel
      Left = 4
      Top = 6
      Caption = #1052#1077#1089#1103#1094' '#1088#1072#1089#1095#1077#1090#1072':'
    end
    object cxLabel3: TcxLabel
      Left = 202
      Top = 6
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082':'
    end
    object edMember: TcxButtonEdit
      Left = 272
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 3
      Width = 315
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 57
    Width = 1252
    Height = 603
    Align = alClient
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 5
    object cxImplementationPlanEmployee: TcxGrid
      Left = 0
      Top = 0
      Width = 1252
      Height = 456
      Align = alClient
      TabOrder = 0
      ExplicitTop = 2
      object cxImplementationPlanEmployeeDBBandedTableView1: TcxGridDBBandedTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = DataSource
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = ',0.00'
            Kind = skSum
            Column = colAmountTheFineTab
          end
          item
            Format = ',0.00'
            Kind = skSum
            Column = colBonusAmountTab
          end
          item
            OnGetText = cxImplementationPlanEmployeeDBBandedTableView1TcxGridDBDataControllerTcxDataSummaryFooterSummaryItems2GetText
            Column = colConsider
          end
          item
            OnGetText = cxImplementationPlanEmployeeDBBandedTableView1TcxGridDBDataControllerTcxDataSummaryFooterSummaryItems3GetText
            Column = colGoodsName
          end
          item
            OnGetText = cxImplementationPlanEmployeeDBBandedTableView1TcxGridDBDataControllerTcxDataSummaryFooterSummaryItems4GetText
            Column = colAmount
          end>
        DataController.Summary.SummaryGroups = <>
        OptionsData.Deleting = False
        OptionsData.Inserting = False
        OptionsView.Footer = True
        OptionsView.HeaderHeight = 60
        Bands = <
          item
            Caption = #1058#1086#1074#1072#1088
          end
          item
            Caption = #1042#1089#1077#1075#1086
          end>
        object colGroupName: TcxGridDBBandedColumn
          Caption = #1043#1088#1091#1087#1087#1072
          DataBinding.FieldName = 'GroupName'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 140
          Position.BandIndex = 0
          Position.ColIndex = 0
          Position.RowIndex = 0
        end
        object colGoodsCode: TcxGridDBBandedColumn
          Caption = #1050#1086#1076
          DataBinding.FieldName = 'GoodsCode'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 49
          Position.BandIndex = 0
          Position.ColIndex = 1
          Position.RowIndex = 0
        end
        object colGoodsName: TcxGridDBBandedColumn
          Caption = #1053#1072#1079#1074#1072#1085#1080#1077
          DataBinding.FieldName = 'GoodsName'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 234
          Position.BandIndex = 0
          Position.ColIndex = 2
          Position.RowIndex = 0
        end
        object colAmount: TcxGridDBBandedColumn
          Caption = #1042#1089#1077#1075#1086' '#1087#1088#1086#1076#1072#1085#1086
          DataBinding.FieldName = 'Amount'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 3
          Properties.DisplayFormat = ',0.000'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 80
          Position.BandIndex = 1
          Position.ColIndex = 0
          Position.RowIndex = 0
        end
        object colAmountPlanTab: TcxGridDBBandedColumn
          Caption = #1052#1080#1085'. '#1055#1083#1072#1085' '#1089' '#1091#1095'. '#1058#1072#1073#1077#1083#1103
          DataBinding.FieldName = 'AmountPlanTab'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 2
          Properties.DisplayFormat = ',0.00'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 80
          Position.BandIndex = 1
          Position.ColIndex = 1
          Position.RowIndex = 0
        end
        object colAmountPlanAwardTab: TcxGridDBBandedColumn
          Caption = #1055#1083#1072#1085' '#1076#1083#1103' '#1055#1088#1077#1084#1080#1080' '#1089' '#1091#1095'. '#1058#1072#1073#1077#1083#1103
          DataBinding.FieldName = 'AmountPlanAwardTab'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 2
          Properties.DisplayFormat = ',0.00'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 80
          Position.BandIndex = 1
          Position.ColIndex = 2
          Position.RowIndex = 0
        end
        object colAmountTheFineTab: TcxGridDBBandedColumn
          Caption = #1057#1091#1084#1084#1072' '#1096#1090#1088#1072#1092#1072' '#1089' '#1091#1095'. '#1058#1072#1073#1077#1083#1103
          DataBinding.FieldName = 'AmountTheFineTab'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 2
          Properties.DisplayFormat = ',0.00'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 80
          Position.BandIndex = 1
          Position.ColIndex = 3
          Position.RowIndex = 0
        end
        object colBonusAmountTab: TcxGridDBBandedColumn
          Caption = #1057#1091#1084#1084#1072' '#1055#1088#1077#1084#1080#1080' '#1089' '#1091#1095'. '#1058#1072#1073#1077#1083#1103
          DataBinding.FieldName = 'BonusAmountTab'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 2
          Properties.DisplayFormat = ',0.00'
          HeaderAlignmentHorz = taCenter
          Options.Editing = False
          Width = 80
          Position.BandIndex = 1
          Position.ColIndex = 4
          Position.RowIndex = 0
        end
        object colConsider: TcxGridDBBandedColumn
          Caption = #1059#1095#1080#1090#1099#1074#1072#1090#1100' '#1076#1083#1103' '#1085#1077#1086#1073#1093#1086#1076#1080#1084#1086#1075#1086' % '#1087#1086#1089#1090#1088#1086#1095#1085#1086#1075#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103
          DataBinding.FieldName = 'Consider'
          PropertiesClassName = 'TcxComboBoxProperties'
          Properties.DropDownListStyle = lsFixedList
          Properties.Items.Strings = (
            'Yes'
            'No')
          HeaderAlignmentHorz = taCenter
          Styles.Content = dmMain.cxGreenEdit
          Width = 80
          Position.BandIndex = 1
          Position.ColIndex = 5
          Position.RowIndex = 0
        end
      end
      object cxImplementationPlanEmployeeLevel1: TcxGridLevel
        GridView = cxImplementationPlanEmployeeDBBandedTableView1
      end
    end
    object cxSplitter1: TcxSplitter
      Left = 0
      Top = 456
      Width = 1252
      Height = 8
      AlignSplitter = salBottom
      Control = Panel3
    end
    object Panel3: TPanel
      Left = 0
      Top = 464
      Width = 1252
      Height = 139
      Align = alBottom
      ShowCaption = False
      TabOrder = 2
      object cxUnit: TcxGrid
        Left = 393
        Top = 1
        Width = 496
        Height = 137
        Align = alLeft
        TabOrder = 0
        ExplicitLeft = 387
        ExplicitTop = 6
        object cxUnitDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = dsUnit
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsData.Deleting = False
          OptionsData.Inserting = False
          OptionsView.GroupByBox = False
          OptionsView.HeaderHeight = 60
          object colUnitName: TcxGridDBColumn
            Caption = #1040#1087#1090#1077#1082#1072
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 183
          end
          object colNormOfManDays: TcxGridDBColumn
            Caption = #1053#1086#1088#1084#1072' '#1095#1077#1083#1086#1074#1077#1082#1086#1076#1085#1077#1081
            DataBinding.FieldName = 'NormOfManDays'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 100
          end
          object colFactOfManDays: TcxGridDBColumn
            Caption = #1060#1072#1082#1090' '#1063#1077#1083#1086#1074#1077#1082#1086#1076#1085#1077#1081
            DataBinding.FieldName = 'FactOfManDays'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 92
          end
          object colPercentAttendance: TcxGridDBColumn
            Caption = '% '#1087#1088#1080#1089#1091#1090#1089#1090#1074#1080#1103' '#1085#1072' '#1072#1087#1090#1077#1082#1077
            DataBinding.FieldName = 'PercentAttendance'
            HeaderAlignmentHorz = taCenter
            Styles.Content = dmMain.cxGreenEdit
            Width = 104
          end
        end
        object cxUnitLevel1: TcxGridLevel
          GridView = cxUnitDBTableView1
        end
      end
      object cxUnitCategory: TcxGrid
        Left = 1
        Top = 1
        Width = 392
        Height = 137
        Align = alLeft
        TabOrder = 1
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = dsUnitCategory
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsData.Deleting = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.GroupByBox = False
          OptionsView.HeaderHeight = 60
          object colUnitCategoryName: TcxGridDBColumn
            Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103
            DataBinding.FieldName = 'UnitCategoryName'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 78
          end
          object colPenaltyNonMinPlan: TcxGridDBColumn
            Caption = '% '#1076#1083#1103' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1096#1090#1088#1072#1092#1072
            DataBinding.FieldName = 'PenaltyNonMinPlan'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 100
          end
          object colPremiumImplPlan: TcxGridDBColumn
            Caption = '% '#1076#1083#1103' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1087#1088#1077#1084#1080#1080
            DataBinding.FieldName = 'PremiumImplPlan'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 92
          end
          object colMinLineByLineImplPlan: TcxGridDBColumn
            Caption = #1053#1077#1086#1073#1093#1086#1076#1080#1084#1099#1081' % '#1087#1086#1089#1090#1088#1086#1095#1085#1086#1075#1086' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103' '#1076#1083#1103' '#1087#1088#1077#1084#1080#1080
            DataBinding.FieldName = 'MinLineByLineImplPlan'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 104
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxResult: TcxGrid
        Left = 889
        Top = 1
        Width = 296
        Height = 137
        Align = alLeft
        TabOrder = 2
        object cxGridDBTableView2: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = dsResult
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <>
          DataController.Summary.SummaryGroups = <>
          OptionsData.Deleting = False
          OptionsData.Inserting = False
          OptionsView.GroupByBox = False
          OptionsView.HeaderHeight = 60
          object cxGridDBColumn5: TcxGridDBColumn
            Caption = #1054#1073#1097#1080#1081' % '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103' '#1087#1086#1089#1090#1088#1086#1095#1085#1099#1081':'
            DataBinding.FieldName = 'TotalExecutionLine'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 87
          end
          object cxGridDBColumn6: TcxGridDBColumn
            Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1087#1088#1077#1084#1080#1080':'
            DataBinding.FieldName = 'Awarding'
            PropertiesClassName = 'TcxComboBoxProperties'
            Properties.DropDownListStyle = lsFixedList
            Properties.Items.Strings = (
              'Yes'
              'No')
            HeaderAlignmentHorz = taCenter
            Styles.Content = dmMain.cxGreenEdit
            Width = 100
          end
          object cxGridDBColumn7: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086':'
            DataBinding.FieldName = 'Total'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 92
          end
        end
        object cxGridLevel2: TcxGridLevel
          GridView = cxGridDBTableView2
        end
      end
    end
  end
  object DataSource: TDataSource
    DataSet = ClientDataSet
    Left = 144
    Top = 264
  end
  object ClientDataSet: TClientDataSet
    Aggregates = <>
    FieldDefs = <>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    AfterOpen = ClientDataSetAfterOpen
    AfterPost = ClientDataSetAfterPost
    OnCalcFields = ClientDataSetCalcFields
    Left = 40
    Top = 264
  end
  object cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = deStart
        Properties.Strings = (
          'Date')
      end
      item
        Component = MemberGuides
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
    Left = 272
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
    Left = 144
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
          ItemName = 'bbExecuteDialog'
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
          ItemName = 'dxBarButton4'
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
          ItemName = 'dxBarButton1'
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
    object bbStaticText: TdxBarButton
      Category = 0
      Visible = ivAlways
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bb: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object dxBarButton3: TdxBarButton
      Caption = 'New Button'
      Category = 0
      Hint = 'New Button'
      Visible = ivAlways
    end
    object dxBarButton4: TdxBarButton
      Action = actExportExel
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = actConsider
      Category = 0
    end
  end
  object ActionList: TActionList
    Images = dmMain.ImageList
    Left = 40
    Top = 200
    object actRefresh: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = dsdStoredProc
      StoredProcList = <
        item
          StoredProc = dsdStoredProc
        end
        item
        end
        item
        end
        item
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actExportExel: TdsdGridToExcel
      MoveParams = <>
      Grid = cxImplementationPlanEmployee
      Caption = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      Hint = #1042#1099#1075#1088#1091#1079#1082#1072' '#1074' Excel'
      ImageIndex = 6
      ShortCut = 16472
    end
    object dsdOpenForm1: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'dsdOpenForm1'
      FormName = 'TReport_ImplementationPlanEmployeeForm'
      FormNameParam.Value = 'TReport_ImplementationPlanEmployeeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object dsdExecStoredProc1: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'dsdExecStoredProc1'
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_ImplementationPlanEmployeeDialogForm'
      FormNameParam.Value = 'TReport_ImplementationPlanEmployeeDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberId'
          Value = Null
          Component = MemberGuides
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MemberName'
          Value = Null
          Component = MemberGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actConsider: TAction
      Caption = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1059#1095#1080#1090#1099#1074#1072#1090#1100' '#1076#1083#1103' '#1085#1077#1086#1073#1093#1086#1076#1080#1084#1086#1075#1086' % '#1087#1086#1089#1090#1088#1086#1095#1085#1086#1075#1086' '#1074#1099#1087#1086#1083 +
        #1085#1077#1085#1080#1103'"'
      Hint = 
        #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' "'#1059#1095#1080#1090#1099#1074#1072#1090#1100' '#1076#1083#1103' '#1085#1077#1086#1073#1093#1086#1076#1080#1084#1086#1075#1086' % '#1087#1086#1089#1090#1088#1086#1095#1085#1086#1075#1086' '#1074#1099#1087#1086#1083 +
        #1085#1077#1085#1080#1103'"'
      ImageIndex = 1
      OnExecute = actConsiderExecute
    end
  end
  object dsdStoredProc: TdsdStoredProc
    StoredProcName = 'gpReport_ImplementationPlanEmployee'
    DataSet = cdsListBands
    DataSets = <
      item
        DataSet = cdsListBands
      end
      item
        DataSet = cdsListFields
      end
      item
        DataSet = cdsUnitCategory
      end
      item
        DataSet = cdsUnit
      end
      item
        DataSet = ClientDataSet
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMemberId'
        Value = 41640d
        Component = MemberGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 272
    Top = 264
  end
  object UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 624
    Top = 16
  end
  object PeriodChoice: TPeriodChoice
    DateStart = deStart
    Left = 184
    Top = 8
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = edMember
      end>
    Left = 488
    Top = 48
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'inStartDate'
        Value = '01.01.2016'
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMemberId'
        Value = '01.01.2016'
        Component = edMember
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 456
    Top = 200
  end
  object dsUnitCategory: TDataSource
    DataSet = cdsUnitCategory
    Left = 144
    Top = 328
  end
  object cdsUnitCategory: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 40
    Top = 328
  end
  object dsUnit: TDataSource
    DataSet = cdsUnit
    Left = 144
    Top = 384
  end
  object cdsUnit: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterPost = cdsUnitAfterPost
    Left = 40
    Top = 384
  end
  object dsResult: TDataSource
    DataSet = cdsResult
    Left = 144
    Top = 448
  end
  object cdsResult: TClientDataSet
    Active = True
    Aggregates = <>
    FieldDefs = <
      item
        Name = 'Awarding'
        DataType = ftString
        Size = 3
      end>
    IndexDefs = <>
    Params = <>
    StoreDefs = True
    OnCalcFields = cdsResultCalcFields
    Left = 40
    Top = 448
    Data = {
      370000009619E0BD010000001800000001000000000003000000370008417761
      7264696E6701004900000001000557494454480200020003000000}
    object cdsResultTotalExecutionLine: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'TotalExecutionLine'
      Calculated = True
    end
    object cdsResultAwarding: TStringField
      FieldName = 'Awarding'
      Size = 3
    end
    object cdsResultTotal: TCurrencyField
      FieldKind = fkCalculated
      FieldName = 'Total'
      Calculated = True
    end
  end
  object MemberGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMember
    Key = '0'
    FormNameParam.Value = 'TMemberForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMemberForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = MemberGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = MemberGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 342
    Top = 16
  end
  object cdsListBands: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterOpen = cdsListBandsAfterOpen
    AfterClose = cdsListBandsAfterClose
    Left = 456
    Top = 264
  end
  object cdsListFields: TClientDataSet
    Aggregates = <>
    Params = <>
    AfterOpen = cdsListFieldsAfterOpen
    Left = 456
    Top = 328
  end
end
