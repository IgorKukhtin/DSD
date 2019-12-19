inherited Report_IlliquidReductionPlanListForm: TReport_IlliquidReductionPlanListForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1083#1072#1085' '#1087#1086' '#1091#1084#1077#1085#1100#1096#1077#1085#1080#1102' '#1082#1086#1083'-'#1074#1086' '#1085#1077#1083#1080#1082#1074#1080#1076#1072' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091'>'
  ClientHeight = 504
  ClientWidth = 824
  AddOnFormData.Params = FormParams
  ExplicitWidth = 840
  ExplicitHeight = 543
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 79
    Width = 824
    Height = 425
    ExplicitTop = 77
    ExplicitWidth = 824
    ExplicitHeight = 427
    ClientRectBottom = 425
    ClientRectRight = 824
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 824
      ExplicitHeight = 427
      inherited cxGrid: TcxGrid
        Top = 49
        Width = 824
        Height = 376
        ExplicitTop = 41
        ExplicitWidth = 824
        ExplicitHeight = 386
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
              Column = GoodsName
            end>
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Caption = 'mactChoiceGoodsForm'
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 61
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 291
          end
          object AmountStart: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088#1086#1074' '#1073#1077#1079' '#1087#1088#1086#1076#1072#1078
            DataBinding.FieldName = 'AmountStart'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 77
          end
          object AmountSale: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1085#1086' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'AmountSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 71
          end
          object ProcSale: TcxGridDBColumn
            Caption = '% '#1087#1088#1086#1076#1072#1078
            DataBinding.FieldName = 'ProcSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 89
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
          end
          object RemainsOut: TcxGridDBColumn
            Caption = #1048#1089#1093#1086#1076#1103#1097#1080#1081' '#1086#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'RemainsOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.###;-,0.###; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 93
          end
          object AccommodationName: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1088#1080#1074'.'
            DataBinding.FieldName = 'AccommodationName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 72
          end
          object Color_calc: TcxGridDBColumn
            DataBinding.FieldName = 'Color_Calc'
            Visible = False
            Options.Editing = False
          end
          object Color_font: TcxGridDBColumn
            DataBinding.FieldName = 'Color_font'
            Visible = False
          end
        end
      end
      object cxGridDetals: TcxGrid
        Left = 0
        Top = 0
        Width = 824
        Height = 41
        Align = alTop
        PopupMenu = PopupMenu
        TabOrder = 1
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DetalsDS
          DataController.Filter.Options = [fcoCaseInsensitive]
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
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.CancelOnExit = False
          OptionsData.Editing = False
          OptionsData.Inserting = False
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object D_AmountStart: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088#1086#1074' '#1073#1077#1079' '#1087#1088#1086#1076#1072#1078
            DataBinding.FieldName = 'AmountStart'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 144
          end
          object D_AmountSale: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1085#1086' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'AmountSale'
            Options.Editing = False
            Width = 146
          end
          object D_ProcSale: TcxGridDBColumn
            Caption = '% '#1087#1088#1086#1076#1072#1078
            DataBinding.FieldName = 'ProcSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 89
          end
          object D_Color_calc: TcxGridDBColumn
            DataBinding.FieldName = 'Color_calc'
            Visible = False
            Options.Editing = False
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 41
        Width = 824
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salTop
        Control = cxGridDetals
        ExplicitTop = 427
      end
    end
  end
  inherited Panel: TPanel
    Width = 824
    Height = 53
    ExplicitWidth = 824
    ExplicitHeight = 53
    inherited deStart: TcxDateEdit
      EditValue = 43344d
      Properties.DisplayFormat = 'mmmm yyyy'
      Properties.EditFormat = 'dd.mm.yyyy'
      Properties.ReadOnly = True
      TabOrder = 1
      ExplicitWidth = 115
      Width = 115
    end
    inherited deEnd: TcxDateEdit
      Left = 131
      Top = 56
      EditValue = 42491d
      TabOrder = 0
      Visible = False
      ExplicitLeft = 131
      ExplicitTop = 56
    end
    inherited cxLabel1: TcxLabel
      Caption = #1052#1077#1089#1103#1094' '#1088#1072#1089#1095#1077#1090#1072':'
      ExplicitWidth = 83
    end
    inherited cxLabel2: TcxLabel
      Left = 15
      Top = 57
      Visible = False
      ExplicitLeft = 15
      ExplicitTop = 57
    end
    object edUserName: TcxTextEdit
      Left = 348
      Top = 5
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 242
    end
    object edUserCode: TcxTextEdit
      Left = 289
      Top = 5
      ParentColor = True
      Properties.ReadOnly = True
      Style.BorderStyle = ebsNone
      TabOrder = 5
      Width = 47
    end
    object cxLabel3: TcxLabel
      Left = 222
      Top = 6
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
    end
    object ceProcUnit: TcxCurrencyEdit
      Left = 545
      Top = 28
      EditValue = 20.000000000000000000
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = ',0.##'
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 45
    end
    object cxLabel4: TcxLabel
      Left = 443
      Top = 29
      Caption = '% '#1074#1099#1087'. '#1087#1086' '#1072#1087#1090#1077#1082#1077'.'
    end
    object ceProcGoods: TcxCurrencyEdit
      Left = 374
      Top = 28
      EditValue = 20.000000000000000000
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = ',0.##'
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 45
    end
    object cxLabel5: TcxLabel
      Left = 264
      Top = 29
      Caption = '% '#1087#1088#1086#1076#1072#1078#1080' '#1076#1083#1103' '#1074#1099#1087'.'
    end
    object ceNotSalePastDay: TcxCurrencyEdit
      Left = 187
      Top = 28
      EditValue = 60.000000000000000000
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 47
    end
    object cxLabel6: TcxLabel
      Left = 10
      Top = 29
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1076#1085#1077#1081' '#1073#1077#1079' '#1087#1088#1086#1076#1072#1078' '#1086#1090':'
    end
    object cxLabel7: TcxLabel
      Left = 611
      Top = 2
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1085#1077#1083#1080#1082#1074#1080#1076#1072' '
      ParentColor = False
      Style.Color = 11201206
    end
    object cxLabel8: TcxLabel
      Left = 611
      Top = 17
      Caption = #1041#1077#1079' '#1087#1088#1086#1076#1072#1078#1080
      ParentColor = False
      Style.Color = 16636922
      Style.TextColor = clWindowText
    end
    object cxLabel9: TcxLabel
      Left = 611
      Top = 33
      Caption = #1058#1086#1074#1072#1088' '#1086#1090#1089#1091#1090#1089#1090#1074#1091#1077#1090' '
      ParentColor = False
      Style.Color = clWhite
      Style.TextColor = clGray
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 51
    Top = 192
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 48
    Top = 240
  end
  inherited ActionList: TActionList
    Left = 103
    Top = 191
    object actRefreshSearch: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actRefreshSearch'
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
          Value = 'NULL'
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
  end
  inherited MasterDS: TDataSource
    Left = 40
    Top = 88
  end
  inherited MasterCDS: TClientDataSet
    Left = 8
    Top = 88
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_IlliquidReductionPlan'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = DetalsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inUserId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UserID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate'
        Value = 'NULL'
        Component = FormParams
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNotSalePastDay'
        Value = Null
        Component = ceNotSalePastDay
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProcGoods'
        Value = Null
        Component = ceProcGoods
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inProcUnit'
        Value = Null
        Component = ceProcUnit
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 88
  end
  inherited BarManager: TdxBarManager
    Left = 112
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
        end>
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = actOpenForm
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
      end>
    ColorRuleList = <
      item
        ValueColumn = Color_font
        BackGroundValueColumn = Color_calc
        ColorValueList = <>
      end>
  end
  inherited PopupMenu: TPopupMenu
    Left = 136
    Top = 232
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
    Left = 104
    Top = 136
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'OperDate'
        Value = 'NULL'
        Component = deStart
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserID'
        Value = Null
        Component = edUserCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = Null
        Component = edUserName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'NotSalePastDay'
        Value = Null
        Component = ceNotSalePastDay
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProcGoods'
        Value = Null
        Component = ceProcGoods
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ProcUnit'
        Value = Null
        Component = ceProcUnit
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    Left = 48
    Top = 304
  end
  object DetalsDS: TDataSource
    DataSet = DetalsCDS
    Left = 400
    Top = 160
  end
  object DetalsCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 296
    Top = 160
  end
  object DBViewAddOnDetals: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <
      item
      end>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ColorRuleList = <
      item
        BackGroundValueColumn = D_Color_calc
        ColorValueList = <>
      end>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <>
    Left = 520
    Top = 344
  end
end
