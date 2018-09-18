inherited Report_Branch_App7_FullForm: TReport_Branch_App7_FullForm
  Caption = #1054#1090#1095#1077#1090' 2 <'#1055#1088#1080#1083#1086#1078#1077#1085#1080#1077' 7>'
  ClientHeight = 344
  ClientWidth = 1020
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1036
  ExplicitHeight = 382
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1020
    Height = 287
    TabOrder = 3
    ExplicitWidth = 1020
    ExplicitHeight = 287
    ClientRectBottom = 287
    ClientRectRight = 1020
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1020
      ExplicitHeight = 287
      inherited cxGrid: TcxGrid
        Width = 1020
        Height = 287
        ExplicitWidth = 1020
        ExplicitHeight = 287
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = GoodsSummStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = JuridicalSummStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = GoodsSummEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = GoodsSummIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = GoodsSummOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = GoodsSummSale_SF
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = GoodsSummReturnIn_SF
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CashSummStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CashSummOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CashSummIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CashSummEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CashAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = JuridicalSummOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = JuridicalSummIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = JuridicalSummEnd
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.##'
              Kind = skSum
              Column = GoodsSummStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = JuridicalSummStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = GoodsSummEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = GoodsSummIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = GoodsSummOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = GoodsSummSale_SF
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = GoodsSummReturnIn_SF
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CashSummStart
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CashSummOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CashSummIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CashSummEnd
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CashAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = JuridicalSummOut
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = JuridicalSummIn
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = JuridicalSummEnd
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object BranchName: TcxGridDBColumn
            Caption = #1060#1080#1083#1080#1072#1083
            DataBinding.FieldName = 'BranchName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 148
          end
          object GoodsSummStart: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1053#1072#1095'.'#1086#1089#1090'. '#1085#1072' '#1089#1082#1083#1072#1076#1077' '
            DataBinding.FieldName = 'GoodsSummStart'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 87
          end
          object GoodsSummEnd: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1050#1086#1085'.'#1086#1089#1090'. '#1085#1072' '#1089#1082#1083#1072#1076#1077
            DataBinding.FieldName = 'GoodsSummEnd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsSummIn: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1080#1093#1086#1076' '#1085#1072' '#1089#1082#1083#1072#1076
            DataBinding.FieldName = 'GoodsSummIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object GoodsSummOut: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1088#1072#1089#1093#1086#1076' '#1089#1086' '#1089#1082#1083#1072#1076#1072
            DataBinding.FieldName = 'GoodsSummOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 76
          end
          object GoodsSummSale_SF: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080' '#1060'2'
            DataBinding.FieldName = 'GoodsSummSale_SF'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object GoodsSummReturnIn_SF: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1074#1086#1079#1074#1088#1072#1090#1072' '#1060'2'
            DataBinding.FieldName = 'GoodsSummReturnIn_SF'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object CashSummStart: TcxGridDBColumn
            Caption = #1050#1072#1089#1089#1072' '#1085#1072#1095'.'#1086#1089#1090'.'
            DataBinding.FieldName = 'CashSummStart'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object CashSummOut: TcxGridDBColumn
            Caption = #1050#1072#1089#1089#1072' '#1087#1088#1080#1093#1086#1076
            DataBinding.FieldName = 'CashSummOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object CashSummIn: TcxGridDBColumn
            Caption = #1050#1072#1089#1089#1072' '#1088#1072#1089#1093#1086#1076
            DataBinding.FieldName = 'CashSummIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object CashSummEnd: TcxGridDBColumn
            Caption = #1050#1072#1089#1089#1072' '#1082#1086#1085'.'#1086#1089#1090'.'
            DataBinding.FieldName = 'CashSummEnd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object CashAmount: TcxGridDBColumn
            Caption = #1050#1072#1089#1089#1072' ('#1086#1087#1083#1072#1090#1072')'
            DataBinding.FieldName = 'CashAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object JuridicalSummStart: TcxGridDBColumn
            Caption = #1044#1086#1083#1075#1080' ('#1085#1072#1095'.)'
            DataBinding.FieldName = 'JuridicalSummStart'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object JuridicalSummOut: TcxGridDBColumn
            Caption = #1050#1088#1077#1076#1080#1090
            DataBinding.FieldName = 'JuridicalSummOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object JuridicalSummIn: TcxGridDBColumn
            Caption = #1044#1077#1073#1077#1090
            DataBinding.FieldName = 'JuridicalSummIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object JuridicalSummEnd: TcxGridDBColumn
            Caption = #1044#1086#1083#1075#1080' ('#1082#1086#1085')'
            DataBinding.FieldName = 'JuridicalSummEnd'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1020
    ExplicitWidth = 1020
    inherited deStart: TcxDateEdit
      Left = 97
      EditValue = 42309d
      Properties.SaveTime = False
      ExplicitLeft = 97
    end
    inherited deEnd: TcxDateEdit
      Left = 300
      EditValue = 42309d
      Properties.SaveTime = False
      ExplicitLeft = 300
    end
    inherited cxLabel1: TcxLabel
      Left = 5
      ExplicitLeft = 5
    end
    inherited cxLabel2: TcxLabel
      Left = 189
      ExplicitLeft = 189
    end
    object cxLabel3: TcxLabel
      Left = 394
      Top = 6
      Caption = #1060#1080#1083#1080#1072#1083':'
    end
    object edBranch: TcxButtonEdit
      Left = 446
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 251
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
        Component = BranchGuides
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
      FormName = 'TReport_Branch_App7DialogForm'
      FormNameParam.Value = 'TReport_Branch_App7DialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchId'
          Value = ''
          Component = BranchGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchName'
          Value = ''
          Component = BranchGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
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
      Caption = #1055#1077#1095#1072#1090#1100' <'#1055#1088#1080#1083#1086#1078#1077#1085#1080#1077' 7>'
      Hint = #1055#1077#1095#1072#1090#1100' <'#1055#1088#1080#1083#1086#1078#1077#1085#1080#1077' 7>'
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'BranchName'
          Value = ''
          Component = BranchGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1088#1080#1083#1086#1078#1077#1085#1080#1077'7'
      ReportNameParam.Value = #1055#1088#1080#1083#1086#1078#1077#1085#1080#1077'7'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Branch_App7_Full'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBranchId'
        Value = Null
        Component = BranchGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 208
  end
  inherited BarManager: TdxBarManager
    Left = 160
    Top = 208
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
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 320
    Top = 232
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 112
    Top = 128
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end
      item
        Component = BranchGuides
      end>
    Left = 224
    Top = 136
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 328
    Top = 170
  end
  object BranchGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edBranch
    FormNameParam.Value = 'TBranch_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TBranch_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = BranchGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 544
  end
end
