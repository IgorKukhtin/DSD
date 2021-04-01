inherited Report_StockTiming_RemainderForm: TReport_StockTiming_RemainderForm
  Caption = #1054#1090#1095#1077#1090' '#1086#1089#1090#1072#1090#1086#1082' '#1087#1088#1086#1089#1088#1086#1095#1077#1085#1085#1086#1075#1086' '#1090#1086#1074#1072#1088#1072' '#1085#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1080
  ClientHeight = 479
  ClientWidth = 917
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 933
  ExplicitHeight = 518
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 58
    Width = 917
    Height = 421
    TabOrder = 3
    ExplicitTop = 58
    ExplicitWidth = 1050
    ExplicitHeight = 421
    ClientRectBottom = 421
    ClientRectRight = 917
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1050
      ExplicitHeight = 421
      inherited cxGrid: TcxGrid
        Width = 917
        Height = 421
        ExplicitWidth = 1050
        ExplicitHeight = 421
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Position = spFooter
              Column = Amount
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Position = spFooter
              Column = Summa
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Column = Summa
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
            end
            item
              Format = ',0.##;-,0.##; ;'
              Kind = skSum
              Column = Summa
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end
            item
              Format = ',0.####;-,0.####; ;'
              Kind = skSum
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 140
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 52
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 209
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 51
          end
          object Amount: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1087#1088#1086#1089#1088#1086#1095#1077#1085#1086#1075#1086' '#1090#1086#1074#1072#1088#1072' '#1085#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1080' '#1082#1086#1083#1080#1095#1077#1089#1090#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Styles.Content = dmMain.cxRemainsContentStyle
            Width = 100
          end
          object Summa: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1090#1086#1082' '#1087#1088#1086#1089#1088#1086#1095#1077#1085#1086#1075#1086' '#1090#1086#1074#1072#1088#1072' '#1085#1072' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1080' '#1089#1091#1084#1084#1072
            DataBinding.FieldName = 'Summa'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object MakerName: TcxGridDBColumn
            Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1100#1077#1083#1100' '#1087#1086' '#1084#1072#1088#1082'. '#1082#1086#1085#1090#1088
            DataBinding.FieldName = 'MakerName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 119
          end
          object ExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1086#1089#1090#1072#1090#1082#1072
            DataBinding.FieldName = 'ExpirationDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 108
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 917
    Height = 32
    ExplicitWidth = 1050
    ExplicitHeight = 32
    inherited deStart: TcxDateEdit
      Left = 59
      Top = 4
      ExplicitLeft = 59
      ExplicitTop = 4
    end
    inherited deEnd: TcxDateEdit
      Left = 59
      Top = 31
      Visible = False
      ExplicitLeft = 59
      ExplicitTop = 31
    end
    inherited cxLabel1: TcxLabel
      Caption = #1053#1072' '#1076#1072#1090#1091':'
      ExplicitWidth = 49
    end
    inherited cxLabel2: TcxLabel
      Left = 37
      Top = 32
      Caption = #1087#1086':'
      Visible = False
      ExplicitLeft = 37
      ExplicitTop = 32
      ExplicitWidth = 20
    end
    object cxLabel3: TcxLabel
      Left = 162
      Top = 4
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object ceUnit: TcxButtonEdit
      Left = 253
      Top = 4
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.Nullstring = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Properties.ReadOnly = True
      Properties.UseNullString = True
      TabOrder = 5
      Text = '<'#1042#1099#1073#1077#1088#1080#1090#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Width = 244
    end
    object edMaker: TcxButtonEdit
      Left = 596
      Top = 4
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 6
      Width = 225
    end
    object cxLabel4: TcxLabel
      Left = 508
      Top = 5
      Caption = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1077#1083#1100': '
    end
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
      end>
  end
  inherited ActionList: TActionList
    object actGet_UserUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end>
      Caption = 'actGet_UserUnit'
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet_UserUnit
      StoredProcList = <
        item
          StoredProc = spGet_UserUnit
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshJuridical: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084
      Hint = #1087#1086' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1072#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshPartionPrice: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1087#1072#1088#1090#1080#1080' '#1094#1077#1085#1099
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1087#1072#1088#1090#1080#1080' '#1094#1077#1085#1099
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshIsPartion: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      Hint = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_StockTiming_RemainderDialogForm'
      FormNameParam.Value = 'TReport_StockTiming_RemainderDialogForm'
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
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MakerId'
          Value = Null
          Component = GuidesMaker
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MakerName'
          Value = Null
          Component = GuidesMaker
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'JuridicalName;GoodsName'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1085#1072' '#1082#1072#1089#1089#1072#1093
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actUpdateMainDS: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_Price_MCSIsClose
      StoredProcList = <
        item
          StoredProc = spUpdate_Price_MCSIsClose
        end>
      Caption = 'actUpdateMainDS'
      DataSource = MasterDS
    end
  end
  inherited MasterDS: TDataSource
    Left = 48
    Top = 160
  end
  inherited MasterCDS: TClientDataSet
    Left = 16
    Top = 160
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_StockTiming_Remainder'
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
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMakerId'
        Value = Null
        Component = GuidesMaker
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 160
  end
  inherited BarManager: TdxBarManager
    Left = 120
    Top = 160
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object dxBarButton1: TdxBarButton
      Caption = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Category = 0
      Hint = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Visible = ivAlways
      ImageIndex = 38
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 200
    Top = 8
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end
      item
        Component = GuidesUnit
      end>
    Left = 432
    Top = 216
  end
  object rdUnit: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = GuidesUnit
      end>
    Left = 208
    Top = 240
  end
  object GuidesUnit: TdsdGuides
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
        Component = GuidesUnit
        ComponentItem = 'Key'
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
    Left = 344
  end
  object spGet_UserUnit: TdsdStoredProc
    StoredProcName = 'gpGet_UserUnit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'UnitId'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitName'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 376
    Top = 208
  end
  object spUpdate_Price_MCSIsClose: TdsdStoredProc
    StoredProcName = 'gpUpdate_Object_Price_MCSIsClose'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMCSIsClose'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MCSIsClose'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 688
    Top = 240
  end
  object GuidesMaker: TdsdGuides
    KeyField = 'Id'
    LookupControl = edMaker
    FormNameParam.Value = 'TMakerForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TMakerForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesMaker
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesMaker
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 684
    Top = 3
  end
end
