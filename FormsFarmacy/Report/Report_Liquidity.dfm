inherited Report_LiquidityForm: TReport_LiquidityForm
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1051#1080#1082#1074#1080#1076#1085#1086#1089#1090#1080
  ClientHeight = 659
  ClientWidth = 1326
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1342
  ExplicitHeight = 698
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 721
    Height = 602
    Align = alLeft
    ExplicitWidth = 721
    ExplicitHeight = 602
    ClientRectBottom = 602
    ClientRectRight = 721
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 721
      ExplicitHeight = 602
      object Panel1: TPanel [0]
        Left = 0
        Top = 296
        Width = 721
        Height = 306
        Align = alBottom
        BevelOuter = bvNone
        Caption = 'Panel1'
        ShowCaption = False
        TabOrder = 0
        object gMarketCompany: TcxGrid
          Left = 0
          Top = 0
          Width = 361
          Height = 306
          Align = alLeft
          PopupMenu = PopupMenu
          TabOrder = 0
          object gMarketCompanyDBBandedTableView: TcxGridDBBandedTableView
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
            DataController.DataSource = dsMarketCompany
            DataController.Summary.DefaultGroupSummaryItems = <
              item
                Kind = skSum
                Position = spFooter
                Column = gMarketCompanySumma
              end
              item
                Format = ',0.####'
                Column = gMarketCompanySumma
              end>
            DataController.Summary.FooterSummaryItems = <
              item
                Format = ',0.####'
                Kind = skSum
                Column = gMarketCompanySumma
              end
              item
                Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
                Kind = skCount
                Column = gMarketCompanyMarketCompanyName
              end>
            DataController.Summary.SummaryGroups = <>
            OptionsBehavior.GoToNextCellOnEnter = True
            OptionsBehavior.FocusCellOnCycle = True
            OptionsData.CancelOnExit = False
            OptionsData.Inserting = False
            OptionsView.ColumnAutoWidth = True
            OptionsView.Footer = True
            OptionsView.GroupByBox = False
            OptionsView.GroupSummaryLayout = gslAlignWithColumns
            OptionsView.Indicator = True
            Styles.Content = dmMain.cxContentStyle
            Styles.Inactive = dmMain.cxSelection
            Styles.Selection = dmMain.cxSelection
            Styles.Footer = dmMain.cxFooterStyle
            Styles.Header = dmMain.cxHeaderStyle
            Styles.BandHeader = dmMain.cxHeaderStyle
            Bands = <
              item
                Caption = 'cash back'
                Width = 350
              end>
            object gMarketCompanyMarketCompanyID: TcxGridDBBandedColumn
              Caption = #1050#1086#1076
              DataBinding.FieldName = 'MarketCompanyID'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 39
              Position.BandIndex = 0
              Position.ColIndex = 0
              Position.RowIndex = 0
            end
            object gMarketCompanyMarketCompanyName: TcxGridDBBandedColumn
              Caption = #1052#1072#1088#1082#1077#1090'. '#1082#1086#1084#1087#1072#1085#1080#1080
              DataBinding.FieldName = 'MarketCompanyName'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 216
              Position.BandIndex = 0
              Position.ColIndex = 1
              Position.RowIndex = 0
            end
            object gMarketCompanySumma: TcxGridDBBandedColumn
              Caption = #1057#1091#1084#1084#1072'  ('#1075#1088#1085')'
              DataBinding.FieldName = 'Summa'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DisplayFormat = ',0.00'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 92
              Position.BandIndex = 0
              Position.ColIndex = 2
              Position.RowIndex = 0
            end
          end
          object gMarketCompanyLevel: TcxGridLevel
            GridView = gMarketCompanyDBBandedTableView
          end
        end
        object gOverdraft: TcxGrid
          Left = 361
          Top = 0
          Width = 360
          Height = 306
          Align = alClient
          PopupMenu = PopupMenu
          TabOrder = 1
          object gOverdraftDBBandedTableView: TcxGridDBBandedTableView
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
            DataController.DataSource = dsOverdraft
            DataController.Summary.DefaultGroupSummaryItems = <
              item
                Kind = skSum
                Position = spFooter
                Column = gOverdraftSumma
              end
              item
                Format = ',0.####'
                Column = gOverdraftSumma
              end>
            DataController.Summary.FooterSummaryItems = <
              item
                Format = ',0.####'
                Kind = skSum
                Column = gOverdraftSumma
              end
              item
                Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
                Kind = skCount
                Column = gOverdraftBankName
              end>
            DataController.Summary.SummaryGroups = <>
            OptionsBehavior.GoToNextCellOnEnter = True
            OptionsBehavior.FocusCellOnCycle = True
            OptionsData.CancelOnExit = False
            OptionsData.Inserting = False
            OptionsView.ColumnAutoWidth = True
            OptionsView.Footer = True
            OptionsView.GroupByBox = False
            OptionsView.GroupSummaryLayout = gslAlignWithColumns
            OptionsView.Indicator = True
            Styles.Content = dmMain.cxContentStyle
            Styles.Inactive = dmMain.cxSelection
            Styles.Selection = dmMain.cxSelection
            Styles.Footer = dmMain.cxFooterStyle
            Styles.Header = dmMain.cxHeaderStyle
            Styles.BandHeader = dmMain.cxHeaderStyle
            Bands = <
              item
                Caption = #1054#1074#1077#1088#1076#1088#1072#1092#1090
                Width = 350
              end>
            object gOverdraftBankID: TcxGridDBBandedColumn
              Caption = #1050#1086#1076
              DataBinding.FieldName = 'BankID'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 39
              Position.BandIndex = 0
              Position.ColIndex = 0
              Position.RowIndex = 0
            end
            object gOverdraftBankName: TcxGridDBBandedColumn
              Caption = #1041#1072#1085#1082
              DataBinding.FieldName = 'BankName'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Options.Editing = False
              Width = 216
              Position.BandIndex = 0
              Position.ColIndex = 1
              Position.RowIndex = 0
            end
            object gOverdraftSumma: TcxGridDBBandedColumn
              Caption = #1057#1091#1084#1084#1072'  ('#1075#1088#1085')'
              DataBinding.FieldName = 'Summa'
              PropertiesClassName = 'TcxCurrencyEditProperties'
              Properties.DisplayFormat = ',0.00'
              HeaderAlignmentHorz = taCenter
              HeaderAlignmentVert = vaCenter
              Width = 91
              Position.BandIndex = 0
              Position.ColIndex = 2
              Position.RowIndex = 0
            end
          end
          object gOverdraftLevel: TcxGridLevel
            GridView = gOverdraftDBBandedTableView
          end
        end
      end
      inherited cxGrid: TcxGrid
        Width = 361
        Height = 296
        Align = alLeft
        TabOrder = 1
        ExplicitWidth = 361
        ExplicitHeight = 296
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
            end
            item
              Kind = skSum
              Position = spFooter
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
            end>
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
        object cxGridDBBandedTableView: TcxGridDBBandedTableView [1]
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
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Kind = skSum
              Position = spFooter
              Column = cxGridSummaRemainder
            end
            item
              Format = ',0.####'
              Column = cxGridSummaRemainder
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = cxGridJuridicalName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = cxGridSummaRemainder
            end>
          DataController.Summary.SummaryGroups = <>
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsData.CancelOnExit = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.Indicator = True
          Styles.Content = dmMain.cxContentStyle
          Styles.Inactive = dmMain.cxSelection
          Styles.Selection = dmMain.cxSelection
          Styles.Footer = dmMain.cxFooterStyle
          Styles.Header = dmMain.cxHeaderStyle
          Styles.BandHeader = dmMain.cxHeaderStyle
          Bands = <
            item
              Caption = #1054#1089#1090#1072#1090#1082#1080' '#1087#1086' '#1102#1088' '#1083#1080#1094#1072#1084'  '#1074' '#1094#1077#1085#1077' '#1079#1072#1082#1091#1087#1082#1080' '#1089' '#1085#1076#1089
              Width = 350
            end>
          object cxGridJuridicalID: TcxGridDBBandedColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'JuridicalID'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 39
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object cxGridJuridicalName: TcxGridDBBandedColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 215
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object cxGridSummaRemainder: TcxGridDBBandedColumn
            Caption = #1057#1091#1084#1084#1072'  ('#1075#1088#1085') '
            DataBinding.FieldName = 'SummaRemainder'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 93
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
        end
        inherited cxGridLevel: TcxGridLevel
          GridView = cxGridDBBandedTableView
        end
      end
      object gIncome: TcxGrid
        Left = 361
        Top = 0
        Width = 360
        Height = 296
        Align = alClient
        PopupMenu = PopupMenu
        TabOrder = 2
        object gIncomeDBBandedTableView: TcxGridDBBandedTableView
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
          DataController.DataSource = dsIncome
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Kind = skSum
              Position = spFooter
              Column = gIncomeSummNoPay
            end
            item
              Format = ',0.####'
              Column = gIncomeSummNoPay
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = gIncomeSummNoPay
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = gIncomeJuridicalName
            end>
          DataController.Summary.SummaryGroups = <>
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsData.CancelOnExit = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.ColumnAutoWidth = True
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.Indicator = True
          Styles.Content = dmMain.cxContentStyle
          Styles.Inactive = dmMain.cxSelection
          Styles.Selection = dmMain.cxSelection
          Styles.Footer = dmMain.cxFooterStyle
          Styles.Header = dmMain.cxHeaderStyle
          Styles.BandHeader = dmMain.cxHeaderStyle
          Bands = <
            item
              Caption = #1053#1077' '#1086#1087#1083#1072#1095#1077#1085#1085#1099#1077' '#1085#1072#1082#1083#1072#1076#1085#1099#1077'  '#1087#1086' '#1102#1088'. '#1083#1080#1094#1072#1084
              Width = 350
            end>
          object gIncomeJuridicalId: TcxGridDBBandedColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'JuridicalId'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 39
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object gIncomeJuridicalName: TcxGridDBBandedColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 216
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object gIncomeSummNoPay: TcxGridDBBandedColumn
            Caption = #1057#1091#1084#1084#1072'  ('#1075#1088#1085')'
            DataBinding.FieldName = 'SummNoPay'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
        end
        object gIncomeLevel: TcxGridLevel
          GridView = gIncomeDBBandedTableView
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1326
    ExplicitWidth = 1326
    inherited deStart: TcxDateEdit
      EditValue = 42491d
      TabOrder = 1
    end
    inherited deEnd: TcxDateEdit
      Left = 316
      EditValue = 42491d
      TabOrder = 0
      Visible = False
      ExplicitLeft = 316
    end
    inherited cxLabel1: TcxLabel
      Caption = #1044#1072#1090#1072' '#1088#1072#1089#1095#1077#1090#1072':'
      ExplicitWidth = 78
    end
    inherited cxLabel2: TcxLabel
      Visible = False
    end
  end
  object cxPageControl1: TcxPageControl [2]
    Left = 721
    Top = 57
    Width = 605
    Height = 602
    Align = alClient
    TabOrder = 6
    Properties.ActivePage = cxTabSheet2
    Properties.CustomButtons.Buttons = <>
    ExplicitLeft = 697
    ClientRectBottom = 602
    ClientRectRight = 605
    ClientRectTop = 24
    object cxTabSheet2: TcxTabSheet
      Caption = #1048#1090#1086#1075#1086
      ImageIndex = 1
      object cxGrid8: TcxGrid
        Left = 0
        Top = 0
        Width = 605
        Height = 578
        Align = alClient
        TabOrder = 0
        object cxGridDBChartView4: TcxGridDBChartView
          DataController.DataSource = ChartSumDS
          DiagramLine.Active = True
          DiagramLine.Values.LineWidth = 3
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
          object cxGridDBChartDataGroup3: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'OperDate'
            DisplayText = #1055#1077#1088#1080#1086#1076
          end
          object cxGridDBChartSeries3: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaRemains'
            DisplayText = #1054#1089#1090#1072#1090#1086#1082
            Styles.Values = cxStyle1
          end
          object cxGridDBChartView4Series1: TcxGridDBChartSeries
            DataBinding.FieldName = 'SummaIncome'
            DisplayText = #1053#1077' '#1086#1087#1083'. '#1087#1088#1080#1093#1086#1076#1099
            Styles.Values = cxStyle2
          end
          object cxGridDBChartView4Series2: TcxGridDBChartSeries
            DataBinding.FieldName = 'Summa'
            DisplayText = #1056#1072#1079#1085#1080#1094#1072
            Styles.Values = cxStyle3
          end
        end
        object cxGridLevel4: TcxGridLevel
          GridView = cxGridDBChartView4
        end
      end
    end
    object cxTabSheet1: TcxTabSheet
      Caption = #1055#1086' '#1102#1088'. '#1083#1080#1094#1072#1084
      ImageIndex = 0
      object grChart: TcxGrid
        Left = 0
        Top = 0
        Width = 605
        Height = 195
        Align = alTop
        TabOrder = 0
        object cxGridDBChartView1: TcxGridDBChartView
          DataController.DataSource = ChartJuridicalDS
          DiagramLine.Active = True
          Title.Text = #1054#1089#1090#1072#1090#1082#1080
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
          ToolBox.Visible = tvNever
          object dqOperDate: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'OperDateText'
          end
        end
        object grChartLevel1: TcxGridLevel
          GridView = cxGridDBChartView1
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 195
        Width = 605
        Height = 189
        Align = alClient
        TabOrder = 1
        object cxGridDBChartView2: TcxGridDBChartView
          DataController.DataSource = ChartJuridicalDS
          DiagramLine.Active = True
          Title.Text = #1053#1077' '#1086#1087#1083#1072#1095#1077#1085#1085#1099#1077' '#1085#1072#1082#1083#1072#1076#1085#1099#1077
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
          ToolBox.Visible = tvNever
          object cxGridDBChartDataGroup1: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'OperDateText'
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBChartView2
        end
      end
      object cxGrid2: TcxGrid
        Left = 0
        Top = 384
        Width = 605
        Height = 194
        Align = alBottom
        TabOrder = 2
        object cxGridDBChartView3: TcxGridDBChartView
          DataController.DataSource = ChartJuridicalDS
          DiagramLine.Active = True
          Title.Text = #1048#1090#1086#1075#1086
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
          ToolBox.Visible = tvNever
          object cxGridDBChartDataGroup2: TcxGridDBChartDataGroup
            DataBinding.FieldName = 'OperDateText'
          end
        end
        object cxGridLevel2: TcxGridLevel
          GridView = cxGridDBChartView3
        end
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 11
    Top = 304
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 8
    Top = 232
  end
  inherited ActionList: TActionList
    Left = 167
    Top = 279
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelectChart
        end>
    end
    object actRefreshSearch: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actRefreshSearch'
      ShortCut = 13
    end
    object actOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      FormName = 'NULL'
      FormNameParam.Value = ''
      FormNameParam.ComponentItem = 'FormName'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actGetForm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actGetForm'
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TDataDialogForm'
      FormNameParam.Value = 'TDataDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = 42491d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object UpdateisMarketCompany: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateisMarketCompany
      StoredProcList = <
        item
          StoredProc = spUpdateisMarketCompany
        end>
      Caption = 'UpdateisMarketCompany'
      DataSource = dsMarketCompany
    end
    object UpdateisOverdraft: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateisOverdraft
      StoredProcList = <
        item
          StoredProc = spUpdateisOverdraft
        end>
      Caption = 'UpdateisOverdraft'
      DataSource = dsOverdraft
    end
    object actOverdraft: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' "'#1054#1074#1077#1088#1076#1088#1072#1092#1090'"'
      Hint = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082' "'#1054#1074#1077#1088#1076#1088#1072#1092#1090'"'
      ImageIndex = 43
      FormName = 'TOverdraftForm'
      FormNameParam.Value = 'TOverdraftForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 88
    Top = 144
  end
  inherited MasterCDS: TClientDataSet
    Left = 16
    Top = 88
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Liquidity'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = cdsIncome
      end
      item
        DataSet = cdsMarketCompany
      end
      item
        DataSet = cdsOverdraft
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inStartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 80
  end
  inherited BarManager: TdxBarManager
    Left = 160
    Top = 88
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
          ItemName = 'bbExecuteDialog'
        end
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
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = actOverdraft
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
      end>
  end
  inherited PopupMenu: TPopupMenu
    Left = 160
    Top = 208
  end
  inherited PeriodChoice: TPeriodChoice
    Top = 136
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end>
    Left = 152
    Top = 144
  end
  object dsIncome: TDataSource
    DataSet = cdsIncome
    Left = 416
    Top = 176
  end
  object cdsIncome: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 416
    Top = 112
  end
  object dsMarketCompany: TDataSource
    DataSet = cdsMarketCompany
    Left = 40
    Top = 464
  end
  object cdsMarketCompany: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 40
    Top = 392
  end
  object dsOverdraft: TDataSource
    DataSet = cdsOverdraft
    Left = 424
    Top = 464
  end
  object cdsOverdraft: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 424
    Top = 384
  end
  object spUpdateisMarketCompany: TdsdStoredProc
    StoredProcName = 'gpUpdate_Liquidity_MarketCompany'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId '
        Value = Null
        Component = cdsMarketCompany
        ComponentItem = 'ID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSumma'
        Value = Null
        Component = cdsMarketCompany
        ComponentItem = 'Summa'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 232
    Top = 395
  end
  object spUpdateisOverdraft: TdsdStoredProc
    StoredProcName = 'gpUpdate_Liquidity_Overdraft'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId '
        Value = Null
        Component = cdsOverdraft
        ComponentItem = 'ID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioSumma'
        Value = Null
        Component = cdsOverdraft
        ComponentItem = 'Summa'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 512
    Top = 387
  end
  object spSelectChart: TdsdStoredProc
    StoredProcName = 'gpReport_LiquidityChart'
    DataSet = HeaderChartCDS
    DataSets = <
      item
        DataSet = HeaderChartCDS
      end
      item
        DataSet = ChartJuridicalCDS
      end
      item
        DataSet = ChartSumCDS
      end>
    OutputType = otMultiDataSet
    Params = <>
    PackSize = 1
    Left = 512
    Top = 112
  end
  object ChartJuridicalDS: TDataSource
    DataSet = ChartJuridicalCDS
    Left = 696
    Top = 168
  end
  object ChartJuridicalCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 600
    Top = 168
  end
  object ChartSumDS: TDataSource
    DataSet = ChartSumCDS
    Left = 696
    Top = 232
  end
  object ChartSumCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 600
    Top = 232
  end
  object HeaderChartCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 600
    Top = 117
  end
  object ChartAddOn1: TChartAddOn
    ChartView = cxGridDBChartView1
    SeriesDataSet = HeaderChartCDS
    SeriesDisplayText = 'JuridicalName'
    SeriesFieldName = 'SummaRemains'
    Left = 808
    Top = 128
  end
  object ChartAddOn2: TChartAddOn
    ChartView = cxGridDBChartView2
    SeriesDataSet = HeaderChartCDS
    SeriesDisplayText = 'JuridicalName'
    SeriesFieldName = 'SummaIncome'
    Left = 816
    Top = 304
  end
  object ChartAddOn3: TChartAddOn
    ChartView = cxGridDBChartView3
    SeriesDataSet = HeaderChartCDS
    SeriesDisplayText = 'JuridicalName'
    SeriesFieldName = 'Summa'
    Left = 824
    Top = 496
  end
  object cxStyleRepository1: TcxStyleRepository
    Left = 928
    Top = 128
    PixelsPerInch = 96
    object cxStyle1: TcxStyle
      AssignedValues = [svColor]
      Color = clGreen
    end
    object cxStyle2: TcxStyle
      AssignedValues = [svColor]
      Color = clRed
    end
    object cxStyle3: TcxStyle
      AssignedValues = [svColor]
      Color = clYellow
    end
  end
end
