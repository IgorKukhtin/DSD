inherited Report_BalanceGoodsSUNForm: TReport_BalanceGoodsSUNForm
  Caption = #1041#1072#1083#1072#1085#1089' '#1090#1086#1074#1072#1088#1086#1074' '#1087#1086' '#1057#1059#1053
  ClientHeight = 480
  ClientWidth = 815
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 831
  ExplicitHeight = 519
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 67
    Width = 815
    Height = 413
    TabOrder = 3
    ExplicitTop = 58
    ExplicitWidth = 865
    ExplicitHeight = 422
    ClientRectBottom = 413
    ClientRectRight = 815
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 865
      ExplicitHeight = 422
      inherited cxGrid: TcxGrid
        Width = 815
        Height = 413
        ExplicitWidth = 865
        ExplicitHeight = 422
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
        end
        object cxGridDBBandedTableView1: TcxGridDBBandedTableView [1]
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = MasterDS
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountIn
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummaIn
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountOut
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = SummaOut
            end>
          DataController.Summary.SummaryGroups = <>
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsData.CancelOnExit = False
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.HeaderAutoHeight = True
          Styles.Content = dmMain.cxContentStyle
          Styles.Inactive = dmMain.cxSelection
          Styles.Selection = dmMain.cxSelection
          Styles.Footer = dmMain.cxFooterStyle
          Styles.Header = dmMain.cxHeaderStyle
          Styles.BandHeader = dmMain.cxHeaderStyle
          Bands = <
            item
              Caption = #1058#1086#1074#1072#1088
              Width = 438
            end
            item
              Caption = #1055#1088#1080#1093#1086#1076
              Width = 170
            end
            item
              Caption = #1056#1072#1089#1093#1086#1076
              Width = 170
            end>
          object GoodsCode: TcxGridDBBandedColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 49
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object GoodsName: TcxGridDBBandedColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 350
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object Price: TcxGridDBBandedColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 71
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object AmountIn: TcxGridDBBandedColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'AmountIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 87
            Position.BandIndex = 1
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object SummaIn: TcxGridDBBandedColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'SummaIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 84
            Position.BandIndex = 1
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object AmountOut: TcxGridDBBandedColumn
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'AmountOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 87
            Position.BandIndex = 2
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object SummaOut: TcxGridDBBandedColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'SummaOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 84
            Position.BandIndex = 2
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
        end
        inherited cxGridLevel: TcxGridLevel
          GridView = cxGridDBBandedTableView1
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 815
    Height = 41
    ExplicitWidth = 792
    ExplicitHeight = 41
    inherited deStart: TcxDateEdit
      Left = 29
      ExplicitLeft = 29
    end
    inherited deEnd: TcxDateEdit
      Left = 142
      ExplicitLeft = 142
    end
    inherited cxLabel1: TcxLabel
      Caption = #1057':'
      ExplicitWidth = 15
    end
    inherited cxLabel2: TcxLabel
      Left = 120
      Caption = #1087#1086':'
      ExplicitLeft = 120
      ExplicitWidth = 20
    end
    object cxLabel3: TcxLabel
      Left = 234
      Top = 5
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object ceUnit: TcxButtonEdit
      Left = 325
      Top = 5
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
      Width = 260
    end
    object cbShow100: TcxCheckBox
      Left = 591
      Top = 18
      Hint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1073#1077#1079' '#1087#1088#1086#1076#1072#1078' 100 '#1076#1085#1077#1081
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' '#1073#1077#1079' '#1087#1088#1086#1076#1072#1078' 100 '#1076#1085#1077#1081
      TabOrder = 6
      Width = 208
    end
    object cbShow2Cat: TcxCheckBox
      Left = 591
      Top = 2
      Hint = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' 2 '#1082#1072#1090#1077#1075#1086#1088#1080#1080
      Caption = #1055#1077#1088#1077#1084#1077#1097#1077#1085#1080#1103' 2 '#1082#1072#1090#1077#1075#1086#1088#1080#1080
      TabOrder = 7
      Width = 160
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
        Component = cbShow100
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbShow2Cat
        Properties.Strings = (
          'Checked')
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
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_BalanceGoodsSUNDialogForm'
      FormNameParam.Value = 'TReport_BalanceGoodsSUNDialogForm'
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
          Name = 'Show2Cat'
          Value = Null
          Component = cbShow2Cat
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Show100'
          Value = Null
          Component = cbShow100
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
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
    StoredProcName = 'gpReport_BalanceGoodsSUN'
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
        Name = 'inDateFinal'
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
        Name = 'inShow2Cat'
        Value = Null
        Component = cbShow2Cat
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShow100'
        Value = Null
        Component = cbShow100
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 96
    Top = 160
  end
  inherited BarManager: TdxBarManager
    Left = 144
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
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
      Action = actGridToExcel
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    View = cxGridDBBandedTableView1
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 152
    Top = 0
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
end
