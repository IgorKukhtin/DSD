inherited Report_Check_PromoBonusDiscoForm: TReport_Check_PromoBonusDiscoForm
  Caption = #1044#1080#1089#1082#1086#1090#1077#1082#1072' '#1087#1086' '#1084#1072#1088#1082#1077#1090' '#1073#1086#1085#1091#1089#1072#1084
  ClientHeight = 626
  ClientWidth = 751
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 767
  ExplicitHeight = 665
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 99
    Width = 751
    Height = 527
    TabOrder = 3
    ExplicitTop = 99
    ExplicitWidth = 751
    ExplicitHeight = 527
    ClientRectBottom = 527
    ClientRectRight = 751
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 751
      ExplicitHeight = 527
      inherited cxGrid: TcxGrid
        Width = 751
        Height = 295
        ExplicitWidth = 751
        ExplicitHeight = 295
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.DataSource = nil
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0;-,0;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0;-,0;'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0;-,0;'
              Kind = skSum
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
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
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0;-,0; ;'
              Kind = skSum
              Column = Count
            end
            item
              Format = ',0;-,0; ;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = AmountCheckComparison
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = AmountCheckSumComparison
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = AmountCheck
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skAverage
            end
            item
              Format = ',0;-,0; ;'
              Kind = skSum
            end
            item
              Format = ',0;-,0; ;'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = AmountCheckSum
            end>
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
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridBandedTableViewStyleSheet
          Styles.BandHeader = dmMain.cxHeaderStyle
          Bands = <
            item
              Options.HoldOwnColumnsOnly = True
              Options.Moving = False
              Width = 262
            end
            item
              Caption = #1052#1077#1089#1103#1094' '#1089#1088#1072#1074#1085#1077#1085#1080#1103
              Options.HoldOwnColumnsOnly = True
              Options.Moving = False
              Width = 164
            end
            item
              Caption = #1052#1077#1089#1103#1094' '#1088#1072#1089#1095#1077#1090#1072
              Width = 307
            end>
          object UnitName: TcxGridDBBandedColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Options.Moving = False
            Width = 153
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object Color_calc: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_calc'
            Visible = False
            VisibleForCustomization = False
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object Count: TcxGridDBBandedColumn
            Caption = '1'
            DataBinding.FieldName = 'Count'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 0
            Properties.DisplayFormat = ',0;-,0; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            MinWidth = 60
            Options.Editing = False
            Options.Moving = False
            Options.VertSizing = False
            Width = 60
            Position.BandIndex = 1
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object AmountCheckComparison: TcxGridDBBandedColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
            DataBinding.FieldName = 'AmountCheckComparison'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            MinWidth = 60
            Options.Editing = False
            Options.VertSizing = False
            Width = 83
            Position.BandIndex = 1
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object AmountCheckSumComparison: TcxGridDBBandedColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'AmountCheckSumComparison'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            MinWidth = 60
            Options.Editing = False
            Options.VertSizing = False
            Width = 80
            Position.BandIndex = 1
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object AmountCheck: TcxGridDBBandedColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
            DataBinding.FieldName = 'AmountCheck'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            MinWidth = 60
            Options.Editing = False
            Options.VertSizing = False
            Width = 84
            Position.BandIndex = 2
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object AmountCheckSum: TcxGridDBBandedColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'AmountCheckSum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 2
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            MinWidth = 60
            Options.Editing = False
            Options.VertSizing = False
            Width = 86
            Position.BandIndex = 2
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object ProcAmount: TcxGridDBBandedColumn
            Caption = '% '#1080#1079#1084'. '#1082#1086#1083'-'#1074#1072
            DataBinding.FieldName = 'ProcAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '+ ,0.##;- ,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
            Position.BandIndex = 2
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object ProcAmountSum: TcxGridDBBandedColumn
            Caption = '% '#1080#1079#1084'. '#1089#1091#1084#1084#1099
            DataBinding.FieldName = 'ProcAmountSum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = '+ ,0.##;- ,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
            Position.BandIndex = 2
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
        end
        inherited cxGridLevel: TcxGridLevel
          GridView = cxGridDBBandedTableView1
        end
      end
      object grChart: TcxGrid
        Left = 0
        Top = 303
        Width = 751
        Height = 224
        Align = alBottom
        TabOrder = 1
        object grChartDBChartView1: TcxGridDBChartView
          DiagramLine.Active = True
          DiagramLine.Values.LineWidth = 3
          ToolBox.CustomizeButton = True
          ToolBox.DiagramSelector = True
        end
        object grChartLevel1: TcxGridLevel
          GridView = grChartDBChartView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 295
        Width = 751
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = grChart
      end
    end
  end
  inherited Panel: TPanel
    Width = 751
    Height = 73
    ExplicitWidth = 751
    ExplicitHeight = 73
    inherited deStart: TcxDateEdit
      Left = 116
      Top = 21
      Properties.DisplayFormat = 'mmmm yyyy'
      ExplicitLeft = 116
      ExplicitTop = 21
      ExplicitWidth = 112
      Width = 112
    end
    inherited deEnd: TcxDateEdit
      Left = 116
      Top = 43
      Properties.DisplayFormat = 'mmmm yyyy'
      ExplicitLeft = 116
      ExplicitTop = 43
      ExplicitWidth = 112
      Width = 112
    end
    inherited cxLabel1: TcxLabel
      Left = 12
      Top = 21
      Caption = #1052#1077#1089#1103#1094' '#1088#1072#1089#1095#1077#1090#1072':'
      ExplicitLeft = 12
      ExplicitTop = 21
      ExplicitWidth = 83
    end
    inherited cxLabel2: TcxLabel
      Left = 12
      Top = 44
      Caption = #1052#1077#1089#1103#1094' '#1089#1088#1072#1074#1085#1077#1085#1080#1103' :'
      ExplicitLeft = 12
      ExplicitTop = 44
      ExplicitWidth = 98
    end
    object edGoods: TcxButtonEdit
      Left = 336
      Top = 43
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 404
    end
    object cxLabel3: TcxLabel
      Left = 243
      Top = 44
      Caption = #1058#1086#1074#1072#1088':'
    end
    object ceUnit: TcxButtonEdit
      Left = 336
      Top = 21
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 6
      Width = 404
    end
    object cxLabel4: TcxLabel
      Left = 243
      Top = 22
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object cxLabel5: TcxLabel
      Left = 12
      Top = 0
      Caption = #1055#1088#1086#1076#1072#1078#1080' '#1087#1086' '#1084#1072#1088#1082#1077#1090#1080#1085#1075#1086#1074#1099#1084' '#1073#1086#1085#1091#1089#1072' '#1087#1086#1096#1083#1080' '#1089'  23.02.21 '
    end
  end
  object cbChartData: TcxComboBox [2]
    Left = 560
    Top = 128
    Properties.ReadOnly = False
    TabOrder = 6
    Width = 166
  end
  object lblChartData: TcxLabel [3]
    Left = 432
    Top = 129
    Caption = #1044#1080#1072#1075#1088#1072#1084#1084#1072' '#1087#1086':'
  end
  inherited cxPropertiesStore: TcxPropertiesStore
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
        Component = GoodsGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = UnitGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_Check_PromoBonusDiscoDialogForm'
      FormNameParam.Value = 'TReport_Check_PromoBonusDiscoDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'DateComparison'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = Null
          Component = UnitGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = UnitGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = ''
          Component = GoodsGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GoodsGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actGet_MovementFormClass: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actGet_MovementFormClass'
    end
    object mactOpenDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGet_MovementFormClass
        end
        item
          Action = actOpenDocument
        end>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      ImageIndex = 1
    end
    object actOpenDocument: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      FormNameParam.Name = 'FormClass'
      FormNameParam.Value = Null
      FormNameParam.Component = FormParams
      FormNameParam.ComponentItem = 'FormClass'
      FormNameParam.DataType = ftString
      FormNameParam.ParamType = ptInput
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object MovementProtocolOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' <'#1055#1088#1086#1090#1086#1082#1086#1083#1072' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'>'
      ImageIndex = 34
      FormName = 'TMovementProtocolForm'
      FormNameParam.Value = 'TMovementProtocolForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'InvNumber'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Left = 344
    Top = 184
  end
  inherited MasterCDS: TClientDataSet
    Left = 152
    Top = 128
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Check_PromoBonusDisco'
    Params = <
      item
        Name = 'inOperDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateComparison'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = UnitGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 128
  end
  inherited BarManager: TdxBarManager
    Left = 168
    Top = 184
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarControlContainerItem2'
        end>
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = MovementProtocolOpenForm
      Category = 0
    end
    object bbExpand: TdxBarButton
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1088#1077#1079#1091#1083#1100#1090#1072#1090' '#1089#1090#1086#1083#1073#1080#1082#1086#1084
      Category = 0
      Hint = #1055#1086#1082#1072#1079#1072#1090#1100' '#1088#1077#1079#1091#1083#1100#1090#1072#1090' '#1089#1090#1086#1083#1073#1080#1082#1086#1084
      Visible = ivAlways
      ImageIndex = 11
    end
    object dxBarContainerItem1: TdxBarContainerItem
      Caption = 'New Item'
      Category = 0
      Visible = ivAlways
      ItemLinks = <>
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = lblChartData
    end
    object dxBarControlContainerItem2: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cbChartData
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    View = cxGridDBBandedTableView1
    OnDblClickActionList = <
      item
        Action = mactOpenDocument
      end>
    ChartList = <
      item
        ChartView = grChartDBChartView1
        VariantList = <
          item
            Series = <
              item
                ColumnList = <
                  item
                    Column = AmountCheckComparison
                    Title = '1. '#1052#1077#1089#1103#1094' '#1089#1088#1072#1074#1085#1077#1085#1080#1103
                  end
                  item
                    Column = AmountCheck
                    Title = '2. '#1052#1077#1089#1103#1094' '#1088#1072#1089#1095#1077#1090#1072
                  end>
                SeriesName = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1090#1086#1074#1072#1088#1072
              end>
            HeaderName = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1090#1086#1074#1072#1088#1072
          end
          item
            Series = <
              item
                ColumnList = <
                  item
                    Column = AmountCheckSumComparison
                    Title = '1. '#1052#1077#1089#1103#1094' '#1089#1088#1072#1074#1085#1077#1085#1080#1103
                  end
                  item
                    Column = AmountCheckSum
                    Title = '2. '#1052#1077#1089#1103#1094' '#1088#1072#1089#1095#1077#1090#1072
                  end>
                SeriesName = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080
              end>
            HeaderName = #1057#1091#1084#1084#1072' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1080
          end>
        DisplayedDataComboBox = cbChartData
      end>
    Left = 256
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 32
    Top = 128
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 88
    Top = 176
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'StartDate'
        Value = Null
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 176
    Top = 264
  end
  object GoodsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    Key = '0'
    FormNameParam.Value = 'TGoodsLiteForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsLiteForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GoodsGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 574
    Top = 14
  end
  object UnitGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = ceUnit
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = UnitGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 480
  end
end
