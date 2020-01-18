inherited Report_IlliquidReductionPlanUserForm: TReport_IlliquidReductionPlanUserForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1083#1072#1085' '#1087#1086' '#1091#1084#1077#1085#1100#1096#1077#1085#1080#1102' '#1082#1086#1083'-'#1074#1086' '#1085#1077#1083#1080#1082#1074#1080#1076#1072' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091'>'
  ClientHeight = 504
  ClientWidth = 866
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 882
  ExplicitHeight = 543
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 83
    Width = 866
    Height = 421
    ExplicitTop = 83
    ExplicitWidth = 866
    ExplicitHeight = 421
    ClientRectBottom = 421
    ClientRectRight = 866
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 866
      ExplicitHeight = 421
      inherited cxGrid: TcxGrid
        Top = 49
        Width = 866
        Height = 372
        ExplicitTop = 47
        ExplicitWidth = 866
        ExplicitHeight = 372
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
              Column = AmountStart
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountSale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RemainsOut
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = Summa
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
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
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 107
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
            Width = 60
          end
          object Summa: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'Summa'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 68
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
            Width = 69
          end
          object AccommodationName: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1088#1080#1074'.'
            DataBinding.FieldName = 'AccommodationName'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object ExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'ExpirationDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 107
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
          object Check_Filter: TcxGridDBColumn
            DataBinding.FieldName = 'Check_Filter'
            Visible = False
          end
        end
      end
      object cxGridDetals: TcxGrid
        Left = 0
        Top = 0
        Width = 866
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
          object D_AmountAll: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088#1086#1074' '#1073#1077#1079' '#1087#1088#1086#1076#1072#1078
            DataBinding.FieldName = 'AmountAll'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 135
          end
          object D_AmountStart: TcxGridDBColumn
            Caption = #1059#1095#1077#1090#1085#1099#1081' '#1086#1089#1090#1072#1090#1086#1082' ('#1073#1077#1079' '#1089#1077#1088#1099#1093')'
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
          object D_Value: TcxGridDBColumn
            Caption = '  '
            DataBinding.FieldName = 'Value'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 138
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 41
        Width = 866
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salTop
        Control = cxGridDetals
      end
    end
  end
  inherited Panel: TPanel
    Width = 866
    Height = 57
    ExplicitWidth = 866
    ExplicitHeight = 57
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
      Left = 217
      Top = 55
      EditValue = 42491d
      TabOrder = 0
      Visible = False
      ExplicitLeft = 217
      ExplicitTop = 55
    end
    inherited cxLabel1: TcxLabel
      Caption = #1052#1077#1089#1103#1094' '#1088#1072#1089#1095#1077#1090#1072':'
      ExplicitWidth = 83
    end
    inherited cxLabel2: TcxLabel
      Left = 101
      Top = 56
      Visible = False
      ExplicitLeft = 101
      ExplicitTop = 56
    end
    object ceProcUnit: TcxCurrencyEdit
      Left = 662
      Top = 5
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = ',0.##'
      Properties.ReadOnly = True
      TabOrder = 4
      Width = 45
    end
    object cxLabel4: TcxLabel
      Left = 560
      Top = 6
      Caption = '% '#1074#1099#1087'. '#1087#1086' '#1072#1087#1090#1077#1082#1077'.'
    end
    object ceProcGoods: TcxCurrencyEdit
      Left = 507
      Top = 5
      Properties.DecimalPlaces = 2
      Properties.DisplayFormat = ',0.##'
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 45
    end
    object cxLabel5: TcxLabel
      Left = 397
      Top = 6
      Caption = '% '#1087#1088#1086#1076#1072#1078#1080' '#1076#1083#1103' '#1074#1099#1087'.'
    end
    object ceNotSalePastDay: TcxCurrencyEdit
      Left = 341
      Top = 5
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      Properties.ReadOnly = True
      TabOrder = 8
      Width = 47
    end
    object cxLabel6: TcxLabel
      Left = 222
      Top = 6
      Caption = #1044#1085#1077#1081' '#1073#1077#1079' '#1087#1088#1086#1076#1072#1078' '#1086#1090':'
    end
    object edFilter: TcxTextEdit
      Left = 101
      Top = 29
      TabOrder = 10
      DesignSize = (
        373
        21)
      Width = 373
    end
    object cxLabel3: TcxLabel
      Left = 10
      Top = 30
      Caption = #1060#1080#1083#1100#1090#1088
    end
    object cbFilter3: TcxCheckBox
      Left = 713
      Top = 35
      Caption = #1058#1086#1074#1072#1088' '#1086#1090#1089#1091#1090#1089#1090#1074#1091#1077#1090' '
      ParentBackground = False
      ParentColor = False
      State = cbsChecked
      Style.Color = clWhite
      Style.TextColor = clGray
      TabOrder = 12
      Width = 139
    end
    object cbFilter2: TcxCheckBox
      Left = 713
      Top = 17
      Caption = #1041#1077#1079' '#1087#1088#1086#1076#1072#1078#1080
      ParentBackground = False
      ParentColor = False
      State = cbsChecked
      Style.Color = 16636922
      Style.TextColor = clWindowText
      TabOrder = 13
      Width = 139
    end
    object cbFilter1: TcxCheckBox
      Left = 713
      Top = -1
      Caption = #1055#1088#1086#1076#1072#1078#1072' '#1085#1077#1083#1080#1082#1074#1080#1076#1072' '
      ParentBackground = False
      ParentColor = False
      State = cbsChecked
      Style.Color = 11201206
      Style.TextColor = clWindowText
      TabOrder = 14
      Width = 139
    end
    object edLabelPenalty: TcxTextEdit
      Left = 480
      Top = 29
      TabStop = False
      Enabled = False
      ParentColor = True
      Properties.AutoSelect = False
      Properties.ReadOnly = True
      Style.BorderStyle = ebsNone
      StyleDisabled.TextColor = clWindowText
      StyleHot.BorderStyle = ebsNone
      TabOrder = 15
      Text = 'edLabelPenalty'
      Width = 227
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 67
    Top = 248
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 64
    Top = 296
  end
  inherited ActionList: TActionList
    Left = 119
    Top = 247
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
    Top = 144
  end
  inherited MasterCDS: TClientDataSet
    Top = 144
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_IlliquidReductionPlanUser'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = DetalsCDS
      end
      item
        DataSet = HeaderCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inStartDate'
        Value = 'NULL'
        Component = FormParams
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 144
  end
  inherited BarManager: TdxBarManager
    Top = 144
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
    Left = 152
    Top = 288
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 32
    Top = 192
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end>
    Left = 120
    Top = 192
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
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 64
    Top = 360
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
  object dsdFieldFilter: TdsdFieldFilter
    TextEdit = edFilter
    DataSet = MasterCDS
    Column = GoodsName
    CheckColumn = Check_Filter
    CheckBoxList = <
      item
        Value = '1'
        CheckBox = cbFilter1
      end
      item
        Value = '2'
        CheckBox = cbFilter2
      end
      item
        Value = '3'
        CheckBox = cbFilter3
      end>
    Left = 520
    Top = 168
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpReport_GetIlliquidReductionPlanUser'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
        DataSet = DetalsCDS
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inStartDate'
        Value = 43344d
        Component = FormParams
        ComponentItem = 'OperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'DayCount'
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
      end
      item
        Name = 'LabelPenalty'
        Value = Null
        Component = edLabelPenalty
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 256
    Top = 240
  end
  object HeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 256
    Top = 312
  end
  object CrossDBViewAddOn: TCrossDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
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
    HeaderDataSet = HeaderCDS
    HeaderColumnName = 'ValueField'
    TemplateColumn = D_Value
    Left = 688
    Top = 264
  end
end
