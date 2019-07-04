inherited Report_CheckPartionDateForm: TReport_CheckPartionDateForm
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1089#1088#1086#1082#1086#1074#1099#1093' '#1090#1086#1074#1072#1088#1086#1074
  ClientHeight = 364
  ClientWidth = 824
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 840
  ExplicitHeight = 402
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 99
    Width = 824
    Height = 265
    TabOrder = 3
    ExplicitTop = 99
    ExplicitWidth = 824
    ExplicitHeight = 265
    ClientRectBottom = 265
    ClientRectRight = 824
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 824
      ExplicitHeight = 265
      inherited cxGrid: TcxGrid
        Width = 824
        Height = 265
        ExplicitWidth = 824
        ExplicitHeight = 265
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SumIncome
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SumSale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummDiff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummSaleDiff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SumIncome
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SumSale
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummDiff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = SummSaleDiff
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ
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
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsCode'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 179
          end
          object PartionDateKindName: TcxGridDBColumn
            Caption = #1058#1080#1087#1099' '#1089#1088#1086#1082'/'#1085#1077' '#1089#1088#1086#1082
            DataBinding.FieldName = 'PartionDateKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 129
          end
          object ExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'ExpirationDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 88
          end
          object Amount: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1085#1086', '#1096#1090'.'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            GroupSummaryAlignment = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object PriceIncome: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1079#1072#1082#1091#1087#1082#1080
            DataBinding.FieldName = 'PriceIncome'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 89
          end
          object PriceSale: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'PriceSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 89
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 89
          end
          object SumIncome: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1074' '#1094#1077#1085#1072#1093' '#1079#1072#1082#1091#1087#1082#1080
            DataBinding.FieldName = 'SumIncome'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 89
          end
          object SumSale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'SumSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 89
          end
          object Summ: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 89
          end
          object Persent: TcxGridDBColumn
            Caption = '% '#1087#1086#1090#1077#1088#1080' '#1086#1090' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'Persent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.#;-,0.#; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 89
          end
          object SummDiff: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086#1090#1077#1088#1080' '#1086#1090' '#1087#1088#1086#1076#1072#1078#1080', '#1075#1088#1085
            DataBinding.FieldName = 'SummDiff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 89
          end
          object SummSaleDiff: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086#1090#1077#1088#1080' ('#1094#1077#1085#1072' '#1073#1077#1079' '#1089#1082#1080#1076#1082#1080' - '#1094#1077#1085#1072'), '#1075#1088#1085
            DataBinding.FieldName = 'SummSaleDiff'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 89
          end
          object DaysDiff: TcxGridDBColumn
            Caption = #1044#1085#1077#1081' '#1076#1086' '#1089#1088#1086#1082#1072
            DataBinding.FieldName = 'DaysDiff'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 824
    Height = 73
    ExplicitWidth = 824
    ExplicitHeight = 73
    inherited deStart: TcxDateEdit
      Left = 120
      Top = 10
      EditValue = 43831d
      ExplicitLeft = 120
      ExplicitTop = 10
      ExplicitWidth = 81
      Width = 81
    end
    inherited deEnd: TcxDateEdit
      Left = 121
      Top = 36
      EditValue = 43831d
      ExplicitLeft = 121
      ExplicitTop = 36
      ExplicitWidth = 80
      Width = 80
    end
    inherited cxLabel1: TcxLabel
      Left = 26
      Top = 11
      ExplicitLeft = 26
      ExplicitTop = 11
    end
    inherited cxLabel2: TcxLabel
      Left = 10
      Top = 37
      ExplicitLeft = 10
      ExplicitTop = 37
    end
    object cxLabel4: TcxLabel
      Left = 219
      Top = 11
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnit: TcxButtonEdit
      Left = 308
      Top = 10
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 299
    end
    object cbPartionDateKind: TcxCheckBox
      Left = 219
      Top = 37
      Action = actRefreshKind
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      Width = 180
    end
    object cbExpirationDate: TcxCheckBox
      Left = 405
      Top = 37
      Action = actRefreshDate
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      Width = 146
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
    object actRefreshDate: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' ('#1076#1072'/'#1085#1077#1090')'
      Hint = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' ('#1076#1072'/'#1085#1077#1090')'
      ImageIndex = 4
      RefreshOnTabSetChanges = False
    end
    object actRefreshKind: TdsdDataSetRefresh [1]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1058#1080#1087#1099' '#1089#1088#1086#1082'/ '#1085#1077' '#1089#1088#1086#1082' ('#1076#1072'/'#1085#1077#1090')'
      Hint = #1058#1080#1087#1099' '#1089#1088#1086#1082'/ '#1085#1077' '#1089#1088#1086#1082' ('#1076#1072'/'#1085#1077#1090')'
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
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
    object actOpenDocument: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1082#1088#1099#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      FormNameParam.Name = 'FormClass'
      FormNameParam.Value = ''
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
          ComponentItem = 'MovementId_Income'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actGet_MovementFormClass: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGet_MovementFormClass
      StoredProcList = <
        item
          StoredProc = spGet_MovementFormClass
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
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_CheckPartionDateDialogForm'
      FormNameParam.Value = 'TReport_CheckPartionDateDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
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
          Name = 'StartDate'
          Value = 'NULL'
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 'NULL'
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartionDateKind'
          Value = Null
          Component = cbPartionDateKind
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isExpirationDate'
          Value = Null
          Component = cbExpirationDate
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actRefreshIsPartion: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1076#1077#1090#1072#1083#1100#1085#1086' ('#1076#1072'/'#1085#1077#1090')'
      Hint = #1087#1086#1082#1072#1079#1072#1090#1100' '#1055#1072#1088#1090#1080#1102' ('#1076#1072'/'#1085#1077#1090')'
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actOpenReportForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1055#1086' '#1076#1074#1080#1078#1077#1085#1080#1102' '#1087#1072#1088#1090#1080#1080' '#1090#1086#1074#1072#1088#1072'>'
      Hint = #1054#1090#1095#1077#1090' <'#1055#1086' '#1076#1074#1080#1078#1077#1085#1080#1102' '#1087#1072#1088#1090#1080#1080' '#1090#1086#1074#1072#1088#1072'>'
      ImageIndex = 25
      FormName = 'TReport_GoodsPartionHistoryForm'
      FormNameParam.Value = 'TReport_GoodsPartionHistoryForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
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
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPartion'
          Value = 'TRUE'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartyId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PartionGoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartyName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Invnumber_Income'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Top = 136
  end
  inherited MasterCDS: TClientDataSet
    Top = 136
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_CheckPartionDate'
    Params = <
      item
        Name = 'inUnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inStartDate'
        Value = 'NULL'
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 'NULL'
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisExpirationDate'
        Value = Null
        Component = cbExpirationDate
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartionDateKind'
        Value = Null
        Component = cbPartionDateKind
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 136
  end
  inherited BarManager: TdxBarManager
    Top = 136
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
        end>
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbOpenReportForm: TdxBarButton
      Action = actOpenReportForm
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = mactOpenDocument
      end
      item
      end>
  end
  inherited PopupMenu: TPopupMenu
    object N2: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Action = actOpenDocument
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 32
    Top = 200
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    Left = 144
    Top = 200
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
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
    Left = 568
    Top = 16
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
    Left = 440
    Top = 168
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'FormClass'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitId'
        Value = Null
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 280
    Top = 208
  end
  object spGet_MovementFormClass: TdsdStoredProc
    StoredProcName = 'gpGet_MovementFormClass'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = ''
        Component = MasterCDS
        ComponentItem = 'MovementId_Income'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outFormClass'
        Value = ''
        Component = FormParams
        ComponentItem = 'FormClass'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 600
    Top = 152
  end
  object rgUnit: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefresh
    ComponentList = <
      item
        Component = GuidesUnit
      end>
    Left = 200
    Top = 128
  end
end
