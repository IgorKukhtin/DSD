inherited WagesForm: TWagesForm
  Caption = #1047'/'#1055' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074
  ClientHeight = 626
  ClientWidth = 1134
  AddOnFormData.AddOnFormRefresh.ParentList = 'Wages'
  ExplicitWidth = 1150
  ExplicitHeight = 665
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 77
    Width = 1134
    Height = 549
    ExplicitTop = 77
    ExplicitWidth = 1134
    ExplicitHeight = 549
    ClientRectBottom = 549
    ClientRectRight = 1134
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1134
      ExplicitHeight = 525
      inherited cxGrid: TcxGrid
        Width = 1134
        Height = 328
        ExplicitWidth = 1134
        ExplicitHeight = 328
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsBehavior.IncSearch = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
        end
        object cxGridDBBandedTableView1: TcxGridDBBandedTableView [1]
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = MasterDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Options = [dcoAssignGroupingValues, dcoAssignMasterDetailKeys, dcoSaveExpanding, dcoGroupsAlwaysExpanded]
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = AmountCard
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = AmountHand
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = AmountAccrued
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = Marketing
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = Director
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = HolidaysHospital
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = IlliquidAssets
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = PenaltySUN
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = MarketingRepayment
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = IlliquidAssetsRepayment
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = PenaltyExam
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
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
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridBandedTableViewStyleSheet
          Styles.BandHeader = dmMain.cxHeaderStyle
          Bands = <
            item
              Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
              FixedKind = fkLeft
              Options.HoldOwnColumnsOnly = True
              Options.Moving = False
              Width = 428
            end
            item
              Options.HoldOwnColumnsOnly = True
              Options.Moving = False
              Width = 672
            end>
          object MemberCode: TcxGridDBBandedColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'MemberCode'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Options.Moving = False
            Width = 20
            Position.BandIndex = 0
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object MemberName: TcxGridDBBandedColumn
            Caption = #1060#1048#1054
            DataBinding.FieldName = 'MemberName'
            HeaderAlignmentVert = vaCenter
            MinWidth = 67
            Options.Editing = False
            Options.Moving = False
            Width = 109
            Position.BandIndex = 0
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object PositionName: TcxGridDBBandedColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName'
            HeaderAlignmentVert = vaCenter
            MinWidth = 64
            Options.Editing = False
            Options.Moving = False
            Width = 80
            Position.BandIndex = 0
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object isManagerPharmacy: TcxGridDBBandedColumn
            Caption = #1047#1072#1074'. '#1072#1087#1090'.'
            DataBinding.FieldName = 'isManagerPharmacy'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 36
            Position.BandIndex = 0
            Position.ColIndex = 6
            Position.RowIndex = 0
          end
          object TestingStatus: TcxGridDBBandedColumn
            Caption = #1069#1082#1079#1072' '#1084#1077#1085
            DataBinding.FieldName = 'TestingStatus'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 39
            Position.BandIndex = 0
            Position.ColIndex = 7
            Position.RowIndex = 0
          end
          object TestingDate: TcxGridDBBandedColumn
            Caption = #1044#1072#1090#1072' '#1089#1076#1072#1095#1080
            DataBinding.FieldName = 'TestingDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
            Position.BandIndex = 0
            Position.ColIndex = 8
            Position.RowIndex = 0
          end
          object TestingAttempts: TcxGridDBBandedColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1086#1087#1099#1090#1086#1082
            DataBinding.FieldName = 'TestingAttempts'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 58
            Position.BandIndex = 0
            Position.ColIndex = 10
            Position.RowIndex = 0
          end
          object UnitName: TcxGridDBBandedColumn
            Caption = #1040#1087#1090#1077#1082#1072
            DataBinding.FieldName = 'UnitName'
            Visible = False
            GroupIndex = 0
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Styles.Content = dmMain.cxSelection
            Width = 165
            Position.BandIndex = 0
            Position.ColIndex = 4
            Position.RowIndex = 0
          end
          object AmountAccrued: TcxGridDBBandedColumn
            Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1086
            DataBinding.FieldName = 'AmountAccrued'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 44
            Position.BandIndex = 1
            Position.ColIndex = 0
            Position.RowIndex = 0
          end
          object HolidaysHospital: TcxGridDBBandedColumn
            Caption = #1054#1090#1087#1091#1089#1082' / '#1041#1086#1083#1100#1085#1080#1095#1085#1099#1081
            DataBinding.FieldName = 'HolidaysHospital'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
            Position.BandIndex = 1
            Position.ColIndex = 1
            Position.RowIndex = 0
          end
          object Marketing: TcxGridDBBandedColumn
            Caption = #1052#1072#1088#1082#1077#1090#1080#1085#1075
            DataBinding.FieldName = 'Marketing'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 45
            Position.BandIndex = 1
            Position.ColIndex = 2
            Position.RowIndex = 0
          end
          object MarketingRepayment: TcxGridDBBandedColumn
            Caption = #1052#1072#1088#1082#1077#1090#1080#1085#1075' '#1087#1086#1075#1072#1096#1077#1085#1080#1077' '#1095#1077#1088#1077#1079' '#1095#1077#1082
            DataBinding.FieldName = 'MarketingRepayment'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 46
            Position.BandIndex = 1
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
          object Director: TcxGridDBBandedColumn
            Caption = #1044#1080#1088#1077#1082#1090#1086#1088'. '#1087#1088#1077#1084#1080#1080' / '#1096#1090#1088#1072#1092#1099
            DataBinding.FieldName = 'Director'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 46
            Position.BandIndex = 1
            Position.ColIndex = 4
            Position.RowIndex = 0
          end
          object IlliquidAssets: TcxGridDBBandedColumn
            Caption = #1053#1077#1083#1080#1082#1074#1080#1076#1099
            DataBinding.FieldName = 'IlliquidAssets'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 43
            Position.BandIndex = 1
            Position.ColIndex = 5
            Position.RowIndex = 0
          end
          object IlliquidAssetsRepayment: TcxGridDBBandedColumn
            Caption = #1053#1077#1083#1080#1082#1074#1080#1076#1099'  '#1087#1086#1075#1072#1096#1077#1085#1080#1077' '#1095#1077#1088#1077#1079' '#1095#1077#1082
            DataBinding.FieldName = 'IlliquidAssetsRepayment'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 42
            Position.BandIndex = 1
            Position.ColIndex = 6
            Position.RowIndex = 0
          end
          object PenaltySUN: TcxGridDBBandedColumn
            Caption = #1055#1077#1088#1089#1086#1085#1072#1083#1100#1085#1099#1081' '#1096#1090#1088#1072#1092' '#1087#1086' '#1057#1059#1053
            DataBinding.FieldName = 'PenaltySUN'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 51
            Position.BandIndex = 1
            Position.ColIndex = 7
            Position.RowIndex = 0
          end
          object PenaltyExam: TcxGridDBBandedColumn
            Caption = #1064#1090#1088#1072#1092' '#1087#1086' '#1089#1076#1072#1095#1077' '#1101#1082#1079#1072#1084#1077#1085#1072
            DataBinding.FieldName = 'PenaltyExam'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 51
            Position.BandIndex = 1
            Position.ColIndex = 8
            Position.RowIndex = 0
          end
          object AmountCard: TcxGridDBBandedColumn
            Caption = #1053#1072' '#1082#1072#1088#1090#1091
            DataBinding.FieldName = 'AmountCard'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 46
            Position.BandIndex = 1
            Position.ColIndex = 9
            Position.RowIndex = 0
          end
          object AmountHand: TcxGridDBBandedColumn
            Caption = #1053#1072' '#1088#1091#1082#1080
            DataBinding.FieldName = 'AmountHand'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 49
            Position.BandIndex = 1
            Position.ColIndex = 10
            Position.RowIndex = 0
          end
          object isIssuedBy: TcxGridDBBandedColumn
            Caption = #1042#1099#1076#1072#1085#1086
            DataBinding.FieldName = 'isIssuedBy'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 47
            Position.BandIndex = 1
            Position.ColIndex = 11
            Position.RowIndex = 0
          end
          object DateIssuedBy: TcxGridDBBandedColumn
            Caption = #1042#1088#1077#1084#1103' '#1080' '#1076#1072#1090#1072' '#1074#1099#1076#1072#1095#1080
            DataBinding.FieldName = 'DateIssuedBy'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 74
            Position.BandIndex = 1
            Position.ColIndex = 12
            Position.RowIndex = 0
          end
          object Color_Calc: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_Calc'
            Visible = False
            Options.Editing = False
            Position.BandIndex = 0
            Position.ColIndex = 5
            Position.RowIndex = 0
          end
          object Color_Testing: TcxGridDBBandedColumn
            DataBinding.FieldName = 'Color_Testing'
            Visible = False
            Position.BandIndex = 0
            Position.ColIndex = 9
            Position.RowIndex = 0
          end
          object isErased: TcxGridDBBandedColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            Options.Editing = False
            Width = 50
            Position.BandIndex = 0
            Position.ColIndex = 3
            Position.RowIndex = 0
          end
        end
        inherited cxGridLevel: TcxGridLevel
          GridView = cxGridDBBandedTableView1
        end
      end
      object cxGrid1: TcxGrid
        Left = 0
        Top = 336
        Width = 1134
        Height = 189
        Align = alBottom
        PopupMenu = PopupMenu
        TabOrder = 1
        object cxGridDBTableView1: TcxGridDBTableView
          Navigator.Buttons.CustomButtons = <>
          DataController.DataSource = DetailDS
          DataController.Filter.Options = [fcoCaseInsensitive]
          DataController.Summary.DefaultGroupSummaryItems = <>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = chAmountAccrued
            end>
          DataController.Summary.SummaryGroups = <>
          Images = dmMain.SortImageList
          OptionsBehavior.GoToNextCellOnEnter = True
          OptionsBehavior.IncSearch = True
          OptionsBehavior.FocusCellOnCycle = True
          OptionsCustomize.ColumnHiding = True
          OptionsCustomize.ColumnsQuickCustomization = True
          OptionsCustomize.DataRowSizing = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Inserting = False
          OptionsView.Footer = True
          OptionsView.GroupByBox = False
          OptionsView.GroupSummaryLayout = gslAlignWithColumns
          OptionsView.HeaderAutoHeight = True
          OptionsView.Indicator = True
          Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
          object chUnitName: TcxGridDBColumn
            Caption = #1040#1087#1090#1077#1082#1072' '#1088#1072#1089#1095#1077#1090#1072
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 198
          end
          object chPayrollTypeName: TcxGridDBColumn
            Caption = #1058#1080#1087#1099' '#1088#1072#1089#1095#1077#1090#1072' '
            DataBinding.FieldName = 'PayrollTypeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 189
          end
          object chDateCalculation: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1088#1072#1089#1095#1077#1090#1072
            DataBinding.FieldName = 'DateCalculation'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'dd.mm.yyyy'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
          end
          object chAmountAccrued: TcxGridDBColumn
            Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1086
            DataBinding.FieldName = 'AmountAccrued'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 92
          end
          object chSummaBase: TcxGridDBColumn
            Caption = #1041#1072#1079#1072' '#1088#1072#1089#1095#1077#1090#1072
            DataBinding.FieldName = 'SummaBase'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 94
          end
          object chFormula: TcxGridDBColumn
            Caption = #1054#1087#1080#1089#1072#1085#1080#1077' '#1088#1072#1089#1095#1077#1090#1072
            DataBinding.FieldName = 'Formula'
            PropertiesClassName = 'TcxMemoProperties'
            Properties.ReadOnly = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 347
          end
        end
        object cxGridLevel1: TcxGridLevel
          GridView = cxGridDBTableView1
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 328
        Width = 1134
        Height = 8
        HotZoneClassName = 'TcxMediaPlayer8Style'
        AlignSplitter = salBottom
        Control = cxGrid1
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1134
    Height = 51
    TabOrder = 3
    ExplicitWidth = 1134
    ExplicitHeight = 51
    inherited edInvNumber: TcxTextEdit
      Top = 22
      ExplicitTop = 22
    end
    inherited cxLabel1: TcxLabel
      Top = 4
      ExplicitTop = 4
    end
    inherited edOperDate: TcxDateEdit
      Top = 22
      Properties.DisplayFormat = 'mmmm yyyy'
      Properties.ReadOnly = True
      ExplicitTop = 22
    end
    inherited cxLabel2: TcxLabel
      Top = 4
      ExplicitTop = 4
    end
    inherited cxLabel15: TcxLabel
      Top = 4
      ExplicitTop = 4
    end
    inherited ceStatus: TcxButtonEdit
      Left = 12
      Top = 22
      ExplicitLeft = 12
      ExplicitTop = 22
      ExplicitHeight = 22
    end
    object deDateCalculation: TcxDateEdit
      Left = 398
      Top = 22
      EditValue = 42132d
      Properties.AssignedValues.DisplayFormat = True
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 155
    end
    object cxLabel3: TcxLabel
      Left = 398
      Top = 4
      Caption = #1044#1072#1090#1072' '#1088#1072#1089#1095#1077#1090#1072
    end
  end
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_MI_Child
        end>
    end
    inherited actShowAll: TBooleanStoredProcAction
      StoredProcList = <
        item
          StoredProc = spSelect
        end
        item
        end>
    end
    inherited actPrint: TdsdPrintAction
      StoredProcList = <
        item
        end>
      DataSets = <
        item
          UserName = 'frxDBDHeader'
        end
        item
          UserName = 'frxDBDMaster'
        end>
      ReportName = #1050#1086#1084#1084#1077#1088#1095#1077#1089#1082#1086#1077' '#1087#1088#1077#1076#1083#1086#1078#1077#1085#1080#1077
      ReportNameParam.Value = #1050#1086#1084#1084#1077#1088#1095#1077#1089#1082#1086#1077' '#1087#1088#1077#1076#1083#1086#1078#1077#1085#1080#1077
    end
    inherited MovementItemProtocolOpenForm: TdsdOpenForm
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
    inherited actAddMask: TdsdExecStoredProc
      StoredProc = nil
      StoredProcList = <
        item
        end
        item
          StoredProc = spInsertMaskMIMaster
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072
    end
    object actDataDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actDataDialog'
      FormName = 'TDataDialogForm'
      FormNameParam.Value = 'TDataDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'inOperDate'
          DataType = ftDateTime
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actAddUser: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUserNickDialig
        end
        item
          Action = actspInsertUser
        end
        item
          Action = actRefresh
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072
      ImageIndex = 54
    end
    object actUserNickDialig: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actUserNickDialig'
      FormName = 'TUserNickForm'
      FormNameParam.Value = 'TUserNickForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'UserID'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actspInsertUser: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUser
      StoredProcList = <
        item
          StoredProc = spInsertUser
        end>
      Caption = 'actspInsertUser'
    end
    object actPrintCalculationUser: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actOpenChoiceUser
        end
        item
          Action = actExecSPPrintCalculationUser
        end
        item
          Action = actExportPrintCalculationUser
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1088#1072#1089#1095#1077#1090#1072' '#1079'.'#1087'. '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091
      Hint = #1055#1077#1095#1072#1090#1100' '#1088#1072#1089#1095#1077#1090#1072' '#1079'.'#1087'. '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091
      ImageIndex = 3
    end
    object actOpenChoiceUser: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actOpenChoiceUser'
      FormName = 'TUserNickForm'
      FormNameParam.Value = 'TUserNickForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'UserPrintID'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actExecSPPrintCalculationUser: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelectPrintCalculationUser
      StoredProcList = <
        item
          StoredProc = spSelectPrintCalculationUser
        end>
      Caption = 'actExecSPPrintCalculationUser'
    end
    object actExportPrintCalculationUser: TdsdExportToXLS
      Category = 'DSDLibExport'
      MoveParams = <>
      ItemsDataSet = PrintItemsCDS
      TitleDataSet = PrintHeaderCDS
      FileNameParam.Value = ''
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      TitleHeight = 1.000000000000000000
      SignHeight = 1.000000000000000000
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -11
      HeaderFont.Name = 'Tahoma'
      HeaderFont.Style = []
      SignFont.Charset = DEFAULT_CHARSET
      SignFont.Color = clWindowText
      SignFont.Height = -11
      SignFont.Name = 'Tahoma'
      SignFont.Style = []
      ColumnParams = <
        item
          Caption = #1044#1077#1085#1100' '#1088#1072#1089#1095#1077#1090#1072
          FieldName = 'OperDate'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
          FieldName = 'UnitName'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 30
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1050#1088#1072#1090'. '#1085#1072#1080#1084'.'
          FieldName = 'ShortName'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1058#1080#1087' '#1088#1072#1089#1095#1077#1090#1072
          FieldName = 'PayrollTypeName'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 20
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1086
          FieldName = 'SummaCalc'
          DataType = ftCurrency
          DecimalPlace = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 20
          CalcColumnLists = <>
          DetailedTexts = <>
          Kind = skSumma
          KindText = #1048#1090#1086#1075#1086' '#1085#1072#1095#1080#1089#1083#1077#1085#1086':'
        end
        item
          Caption = #1060#1086#1088#1084#1091#1083#1072' '#1088#1072#1089#1095#1077#1090#1072
          FieldName = 'FormulaCalc'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 100
          WrapText = True
          CalcColumnLists = <>
          DetailedTexts = <>
        end>
      Caption = 'actExportPrintCalculationUser'
    end
    object actCalculationAll: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecCalculationAll
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1088#1072#1089#1095#1077#1090' '#1079#1072#1088#1072#1073#1086#1090#1085#1086#1081' '#1087#1083#1072#1090#1099' '#1087#1086' '#1074#1089#1077#1084' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1056#1072#1089#1095#1080#1090#1072#1090#1100' '#1079#1072#1088#1072#1073#1086#1090#1085#1091#1102' '#1087#1083#1072#1090#1091' '#1087#1086' '#1074#1089#1077#1084' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084
      Hint = #1056#1072#1089#1095#1080#1090#1072#1090#1100' '#1079#1072#1088#1072#1073#1086#1090#1085#1091#1102' '#1087#1083#1072#1090#1091' '#1087#1086' '#1074#1089#1077#1084' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084
      ImageIndex = 38
    end
    object actExecCalculationAll: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spCalculationAll
      StoredProcList = <
        item
          StoredProc = spCalculationAll
        end>
      Hint = #1056#1072#1089#1095#1077#1090' '#1079'.'#1087'. '#1087#1086' '#1074#1089#1077#1084' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084
    end
    object actPrintCalculationAll: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecSPPrintCalculationAll
        end
        item
          Action = actExportPrintCalculationAll
        end>
      QuestionBeforeExecute = #1056#1072#1089#1087#1077#1095#1072#1090#1072#1090#1100' '#1088#1072#1089#1095#1077#1090' '#1079'.'#1087'. '#1087#1086' '#1074#1089#1077#1084' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084'?'
      Caption = #1055#1077#1095#1072#1090#1100' '#1088#1072#1089#1095#1077#1090#1072' '#1079'.'#1087'. '#1087#1086' '#1074#1089#1077#1084' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084
      Hint = #1055#1077#1095#1072#1090#1100' '#1088#1072#1089#1095#1077#1090#1072' '#1079'.'#1087'. '#1087#1086' '#1074#1089#1077#1084' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084
      ImageIndex = 16
    end
    object actExecSPPrintCalculationAll: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSelectPrintCalculationAll
      StoredProcList = <
        item
          StoredProc = spSelectPrintCalculationAll
        end>
      Caption = 'actExecSPPrintCalculationAll'
    end
    object actExportPrintCalculationAll: TdsdExportToXLS
      Category = 'DSDLibExport'
      MoveParams = <>
      ItemsDataSet = PrintItemsCDS
      TitleDataSet = PrintHeaderCDS
      FileNameParam.Value = ''
      FileNameParam.DataType = ftString
      FileNameParam.MultiSelectSeparator = ','
      TitleHeight = 1.000000000000000000
      SignHeight = 1.000000000000000000
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      HeaderFont.Charset = DEFAULT_CHARSET
      HeaderFont.Color = clWindowText
      HeaderFont.Height = -11
      HeaderFont.Name = 'Tahoma'
      HeaderFont.Style = []
      SignFont.Charset = DEFAULT_CHARSET
      SignFont.Color = clWindowText
      SignFont.Height = -11
      SignFont.Name = 'Tahoma'
      SignFont.Style = []
      ColumnParams = <
        item
          Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
          FieldName = 'PersonalName'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 30
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
          FieldName = 'PositionName'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1051#1086#1075#1080#1085
          FieldName = 'UserId'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
          FieldName = 'UnitName'
          DecimalPlace = 0
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          Width = 30
          CalcColumnLists = <>
          DetailedTexts = <>
        end
        item
          Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1086
          FieldName = 'SummaCalc'
          DataType = ftCurrency
          DecimalPlace = 2
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          CalcColumnLists = <>
          DetailedTexts = <>
          Kind = skSumma
          KindText = #1048#1090#1086#1075#1086' '#1085#1072#1095#1080#1089#1083#1077#1085#1086':'
        end>
      Caption = 'actExportPrintCalculationAll'
    end
    object actIssuedBy: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_isIssuedBy
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1088#1080#1079#1085#1072#1082' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091' '#1074#1099#1076#1072#1085#1086'?'
      Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1087#1088#1080#1079#1085#1072#1082#1072' '#1074#1099#1076#1072#1085#1086
      Hint = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1087#1088#1080#1079#1085#1072#1082#1072' '#1074#1099#1076#1072#1085#1086
      ImageIndex = 66
    end
    object actUpdate_isIssuedBy: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_isIssuedBy
      StoredProcList = <
        item
          StoredProc = spUpdate_isIssuedBy
        end>
      Caption = 'actUpdate_isIssuedBy'
    end
    object actWagesAdditionalExpenses: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1088#1072#1089#1093#1086#1076#1099
      Hint = #1044#1086#1087#1086#1083#1085#1080#1090#1077#1083#1100#1085#1099#1077' '#1088#1072#1089#1093#1086#1076#1099
      ImageIndex = 56
      FormName = 'TWagesAdditionalExpensesForm'
      FormNameParam.Value = 'TWagesAdditionalExpensesForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = FormParams
          ComponentItem = 'inOperDate'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUpdateUnit: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUnitChoice
        end
        item
          Action = actExecStoredProcUpdateUnit
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1086#1089#1085#1086#1074#1085#1086#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'?'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1086#1089#1085#1086#1074#1085#1086#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1086#1089#1085#1086#1074#1085#1086#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      ImageIndex = 66
    end
    object actUnitChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actChoiceUnitTreeForm'
      FormName = 'TUnitTreeForm'
      FormNameParam.Value = 'TUnitTreeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'UnitID'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actExecStoredProcUpdateUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdateUnit
      StoredProcList = <
        item
          StoredProc = spUpdateUnit
        end>
      Caption = 'actExecStoredUpdateUnit'
    end
    object actMITestingUserYes: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spMITestingUserYes
      StoredProcList = <
        item
          StoredProc = spMITestingUserYes
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090' "'#1069#1082#1079#1072#1084#1077#1085' '#1089#1076#1072#1085'"'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090' "'#1069#1082#1079#1072#1084#1077#1085' '#1089#1076#1072#1085'"'
      ImageIndex = 79
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090' "'#1069#1082#1079#1072#1084#1077#1085' '#1089#1076#1072#1085'"?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
    end
    object actMITestingUserNo: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spMITestingUserNo
      StoredProcList = <
        item
          StoredProc = spMITestingUserNo
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090' "'#1069#1082#1079#1072#1084#1077#1085' '#1085#1077' '#1089#1076#1072#1085'"'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090' "'#1069#1082#1079#1072#1084#1077#1085' '#1085#1077' '#1089#1076#1072#1085'"'
      ImageIndex = 7
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090' "'#1069#1082#1079#1072#1084#1077#1085' '#1085#1077' '#1089#1076#1072#1085'"?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
    end
    object actMITestingUserDel: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spMITestingUserDel
      StoredProcList = <
        item
          StoredProc = spMITestingUserDel
        end>
      Caption = #1054#1090#1084#1077#1085#1080#1090#1100' '#1088#1091#1095#1085#1091#1102' '#1086#1090#1084#1077#1090#1082#1091'  '#1087#1086' '#1101#1082#1079#1072#1084#1077#1085#1091
      Hint = #1054#1090#1084#1077#1085#1080#1090#1100' '#1088#1091#1095#1085#1091#1102' '#1086#1090#1084#1077#1090#1082#1091'  '#1087#1086' '#1101#1082#1079#1072#1084#1077#1085#1091
      ImageIndex = 77
      QuestionBeforeExecute = #1054#1090#1084#1077#1085#1080#1090#1100' '#1088#1091#1095#1085#1091#1102' '#1086#1090#1084#1077#1090#1082#1091'  '#1087#1086' '#1101#1082#1079#1072#1084#1077#1085#1091'?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
    end
    object actWagesSUN1: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1064#1090#1088#1072#1092#1099' '#1087#1086' '#1057#1059#1053'1'
      Hint = #1064#1090#1088#1072#1092#1099' '#1087#1086' '#1057#1059#1053'1'
      ImageIndex = 61
      FormName = 'TWagesSUN1Form'
      FormNameParam.Value = 'TWagesSUN1Form'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = '0'
          Component = FormParams
          ComponentItem = 'inOperDate'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actWagesTechnicalRediscount: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1058#1077#1093#1085#1080#1095#1077#1089#1082#1080#1081' '#1087#1077#1088#1077#1091#1095#1077#1090
      Hint = #1058#1077#1093#1085#1080#1095#1077#1089#1082#1080#1081' '#1087#1077#1088#1077#1091#1095#1077#1090
      ImageIndex = 42
      FormName = 'TWagesTechnicalRediscountForm'
      FormNameParam.Value = 'TWagesTechnicalRediscountForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = '0'
          Component = FormParams
          ComponentItem = 'inOperDate'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actWagesMoneyBoxSun: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1050#1086#1087#1080#1083#1082#1072
      Hint = #1050#1086#1087#1080#1083#1082#1072
      ImageIndex = 75
      FormName = 'TWagesMoneyBoxSunForm'
      FormNameParam.Value = 'TWagesMoneyBoxSunForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = '0'
          Component = FormParams
          ComponentItem = 'inOperDate'
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited MasterDS: TDataSource
    Top = 224
  end
  inherited MasterCDS: TClientDataSet
    Top = 224
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Wages'
    Left = 64
    Top = 224
  end
  inherited BarManager: TdxBarManager
    Left = 96
    Top = 223
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbAddMask'
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
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
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
          ItemName = 'dxBarButton11'
        end
        item
          Visible = True
          ItemName = 'dxBarButton16'
        end
        item
          Visible = True
          ItemName = 'dxBarButton17'
        end
        item
          Visible = True
          ItemName = 'dxBarButton18'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton8'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton7'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton9'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton12'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarButton13'
        end
        item
          Visible = True
          ItemName = 'dxBarButton14'
        end
        item
          Visible = True
          ItemName = 'dxBarButton15'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end>
    end
    inherited bbAddMask: TdxBarButton
      Action = actAddUser
    end
    object bbPrintCheck: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' '#1095#1077#1082#1072
      Visible = ivAlways
      ImageIndex = 15
    end
    object bbGet_SP_Prior: TdxBarButton
      Caption = #1040#1042#1058#1054#1047#1040#1055#1054#1051#1053#1048#1058#1068
      Category = 0
      Visible = ivAlways
      ImageIndex = 74
    end
    object dxBarButton1: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' '#1089#1095#1077#1090#1072
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' '#1089#1095#1077#1090#1072
      Visible = ivAlways
      ImageIndex = 3
      ShortCut = 49232
    end
    object dxBarButton2: TdxBarButton
      Caption = #1042#1089#1090#1072#1074#1082#1072' '#1074' '#1079#1072#1082#1072#1079
      Category = 0
      Hint = #1042#1089#1090#1072#1074#1082#1072' '#1074' '#1079#1072#1082#1072#1079
      Visible = ivAlways
      ImageIndex = 0
    end
    object dxBarButton3: TdxBarButton
      Caption = #1057#1086#1079#1076#1072#1090#1100' '#1087#1088#1086#1076#1072#1078#1091
      Category = 0
      Hint = #1057#1086#1079#1076#1072#1090#1100' '#1087#1088#1086#1076#1072#1078#1091
      Visible = ivAlways
      ImageIndex = 43
    end
    object dxBarButton4: TdxBarButton
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1075#1088#1072#1092#1080#1082#1086#1074' '#1089' '#1087#1088#1077#1076#1099#1076#1091#1097#1077#1075#1086' '#1084#1077#1089#1103#1094#1072
      Category = 0
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1075#1088#1072#1092#1080#1082#1086#1074' '#1089' '#1087#1088#1077#1076#1099#1076#1091#1097#1077#1075#1086' '#1084#1077#1089#1103#1094#1072
      Visible = ivAlways
      ImageIndex = 50
    end
    object dxBarButton5: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1086#1089#1085#1086#1074#1085#1086#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1086#1089#1085#1086#1074#1085#1086#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      Visible = ivAlways
      ImageIndex = 66
    end
    object dxBarButton6: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1076#1083#1103' '#1087#1086#1076#1084#1077#1085#1099
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1076#1083#1103' '#1087#1086#1076#1084#1077#1085#1099
      Visible = ivAlways
      ImageIndex = 35
    end
    object dxBarButton7: TdxBarButton
      Action = actPrintCalculationUser
      Category = 0
    end
    object dxBarButton8: TdxBarButton
      Action = actCalculationAll
      Category = 0
    end
    object dxBarButton9: TdxBarButton
      Action = actPrintCalculationAll
      Category = 0
    end
    object dxBarButton10: TdxBarButton
      Action = actIssuedBy
      Category = 0
    end
    object dxBarButton11: TdxBarButton
      Action = actWagesAdditionalExpenses
      Category = 0
    end
    object dxBarButton12: TdxBarButton
      Action = actUpdateUnit
      Category = 0
    end
    object dxBarButton13: TdxBarButton
      Action = actMITestingUserYes
      Category = 0
    end
    object dxBarButton14: TdxBarButton
      Action = actMITestingUserNo
      Category = 0
    end
    object dxBarButton15: TdxBarButton
      Action = actMITestingUserDel
      Category = 0
    end
    object dxBarButton16: TdxBarButton
      Action = actWagesSUN1
      Category = 0
    end
    object dxBarButton17: TdxBarButton
      Action = actWagesTechnicalRediscount
      Category = 0
    end
    object dxBarButton18: TdxBarButton
      Action = actWagesMoneyBoxSun
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    View = cxGridDBBandedTableView1
    ColorRuleList = <
      item
        ColorColumn = TestingStatus
        BackGroundValueColumn = Color_Testing
        ColorValueList = <>
      end>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 0
      end>
    SearchAsFilter = False
    Top = 241
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserID'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'UnitID'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'UserPrintID'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 40
    Top = 312
  end
  inherited StatusGuides: TdsdGuides
    Top = 232
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_Wages'
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Top = 232
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Wages'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateCalculation'
        Value = Null
        Component = deDateCalculation
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 176
    Top = 272
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Wages'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 42132d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    ParamKeyField = 'ioId'
    Left = 282
    Top = 272
  end
  inherited GuidesFiller: TGuidesFiller
    Left = 264
    Top = 232
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edOperDate
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Left = 208
    Top = 233
  end
  inherited RefreshAddOn: TRefreshAddOn
    Left = 72
    Top = 312
  end
  inherited spErasedMIMaster: TdsdStoredProc
    Left = 534
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    Left = 526
    Top = 280
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_Wages_Summa'
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inHolidaysHospital'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'HolidaysHospital'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMarketing'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Marketing'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDirector'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Director'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIlliquidAssets'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'IlliquidAssets'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPenaltySUN'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PenaltySUN'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPenaltyExam'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PenaltyExam'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountCard'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountCard'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisIssuedBy'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isIssuedBy'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outAmountHand'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'AmountHand'
        DataType = ftFloat
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 408
    Top = 280
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 352
    Top = 352
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Wages_TotalSumm'
    Left = 188
    Top = 364
  end
  object spInsertUser: TdsdStoredProc
    StoredProcName = 'gpInsert_MovementItem_Wages_User'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserID'
        Value = Null
        Component = FormParams
        ComponentItem = 'UserID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 488
    Top = 352
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 796
    Top = 265
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 796
    Top = 214
  end
  object spSelectPrintCalculationUser: TdsdStoredProc
    StoredProcName = 'gpSelect_CalculationPerson_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inOperDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserID'
        Value = Null
        Component = FormParams
        ComponentItem = 'UserPrintID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 663
    Top = 216
  end
  object spSelect_MI_Child: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_Wages_Child'
    DataSet = DetailDCS
    DataSets = <
      item
        DataSet = DetailDCS
      end>
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = Null
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 464
    Top = 536
  end
  object dsdDBViewAddOn1: TdsdDBViewAddOn
    ErasedFieldName = 'isErased'
    View = cxGridDBTableView1
    OnDblClickActionList = <>
    ActionItemList = <>
    SortImages = dmMain.SortImageList
    OnlyEditingCellOnEnter = False
    ChartList = <>
    ColorRuleList = <>
    ColumnAddOnList = <>
    ColumnEnterList = <>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = -1
      end>
    ShowFieldImageList = <>
    SearchAsFilter = False
    PropertiesCellList = <>
    Left = 318
    Top = 529
  end
  object DetailDS: TDataSource
    DataSet = DetailDCS
    Left = 168
    Top = 544
  end
  object DetailDCS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    IndexFieldNames = 'ParentId;DateCalculation'
    MasterFields = 'Id'
    MasterSource = MasterDS
    PacketRecords = 0
    Params = <>
    Left = 80
    Top = 544
  end
  object spCalculationAll: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_Wages_CalculationAll'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    Left = 600
    Top = 360
  end
  object spSelectPrintCalculationAll: TdsdStoredProc
    StoredProcName = 'gpSelect_CalculationPerson_PrintAll'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inOperDate'
        Value = 42132d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 663
    Top = 280
  end
  object spUpdate_isIssuedBy: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_Wages_isIssuedBy'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisIssuedBy'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isIssuedBy'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outisIssuedBy'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isIssuedBy'
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 600
    Top = 488
  end
  object spUpdateUnit: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_Wages_Unit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitId'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 722
    Top = 480
  end
  object PopupMenu1: TPopupMenu
    Left = 968
    Top = 136
  end
  object spMITestingUserYes: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_TestingUser'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTestingUser'
        Value = '1'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 944
    Top = 216
  end
  object spMITestingUserNo: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_TestingUser'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTestingUser'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 944
    Top = 272
  end
  object spMITestingUserDel: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_TestingUser'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTestingUser'
        Value = '2'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 944
    Top = 320
  end
end
