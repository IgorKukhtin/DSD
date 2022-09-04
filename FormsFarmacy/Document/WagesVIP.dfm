inherited WagesVIPForm: TWagesVIPForm
  Caption = #1047'/'#1055' VIP '#1084#1077#1085#1077#1076#1078#1077#1088#1086#1074
  ClientHeight = 580
  ClientWidth = 1185
  AddOnFormData.AddOnFormRefresh.ParentList = 'Sale'
  ExplicitWidth = 1201
  ExplicitHeight = 619
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 115
    Width = 1185
    Height = 465
    ExplicitTop = 115
    ExplicitWidth = 1185
    ExplicitHeight = 465
    ClientRectBottom = 465
    ClientRectRight = 1185
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1185
      ExplicitHeight = 441
      inherited cxGrid: TcxGrid
        Width = 1185
        Height = 433
        ExplicitTop = -6
        ExplicitWidth = 1185
        ExplicitHeight = 433
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Column = AmountAccrued
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = AmountAccrued
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = MemberName
            end
            item
              Format = ',0.####'
              Kind = skSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = TotalSum
            end
            item
              Format = ',0.00;-,0.00; ;'
              Kind = skSum
              Column = ApplicationAward
            end>
          OptionsBehavior.IncSearch = True
          OptionsView.ColumnAutoWidth = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object MemberCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'MemberCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
          end
          object MemberName: TcxGridDBColumn
            Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
            DataBinding.FieldName = 'MemberName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 334
          end
          object HoursWork: TcxGridDBColumn
            Caption = #1054#1090#1088#1072#1073#1086#1090#1072#1085#1086' '#1095#1072#1089#1086#1074
            DataBinding.FieldName = 'HoursWork'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object AmountAccrued: TcxGridDBColumn
            Caption = #1053#1072#1095#1080#1089#1083#1077#1085#1086
            DataBinding.FieldName = 'AmountAccrued'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 3
            Properties.DisplayFormat = ',0.000'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object ApplicationAward: TcxGridDBColumn
            Caption = #1055#1088#1077#1084#1080#1103' '#1079#1072' '#1087#1088#1080#1083#1086#1078#1077#1085#1080#1077
            DataBinding.FieldName = 'ApplicationAward'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object TotalSum: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086
            DataBinding.FieldName = 'TotalSum'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object isIssuedBy: TcxGridDBColumn
            Caption = #1042#1099#1076#1072#1085#1086
            DataBinding.FieldName = 'isIssuedBy'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object DateIssuedBy: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1074#1099#1076#1072#1095#1080
            DataBinding.FieldName = 'DateIssuedBy'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
        end
      end
      object cxSplitter1: TcxSplitter
        Left = 0
        Top = 433
        Width = 1185
        Height = 8
        Touch.ParentTabletOptions = False
        Touch.TabletOptions = [toPressAndHold]
        AlignSplitter = salBottom
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1185
    Height = 89
    TabOrder = 3
    ExplicitWidth = 1185
    ExplicitHeight = 89
    inherited edInvNumber: TcxTextEdit
      Left = 8
      Top = 20
      ExplicitLeft = 8
      ExplicitTop = 20
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      Top = 2
      ExplicitLeft = 8
      ExplicitTop = 2
    end
    inherited edOperDate: TcxDateEdit
      Left = 108
      Top = 20
      EditValue = 42767d
      Properties.DisplayFormat = 'mmmm yyyy'
      ExplicitLeft = 108
      ExplicitTop = 20
    end
    inherited cxLabel2: TcxLabel
      Left = 108
      Top = 2
      ExplicitLeft = 108
      ExplicitTop = 2
    end
    inherited cxLabel15: TcxLabel
      Top = 40
      ExplicitTop = 40
    end
    inherited ceStatus: TcxButtonEdit
      Top = 57
      ExplicitTop = 57
      ExplicitWidth = 200
      ExplicitHeight = 22
      Width = 200
    end
    object cxLabel3: TcxLabel
      Left = 222
      Top = 8
      Caption = #1057#1091#1084#1084#1072' '#1087#1088#1080#1085#1103#1090#1099#1093' '#1087#1086' '#1090#1077#1083#1077#1092#1086#1085#1091' '#1079#1072#1082#1072#1079#1086#1074
    end
    object ceTotalSummPhone: TcxCurrencyEdit
      Left = 431
      Top = 7
      TabStop = False
      Properties.DisplayFormat = ',0.00;-,0.00; ;'
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 89
    end
    object ceTotalSummSale: TcxCurrencyEdit
      Left = 431
      Top = 32
      TabStop = False
      Properties.DisplayFormat = ',0.00;-,0.00; ;'
      Properties.ReadOnly = True
      TabOrder = 8
      Width = 89
    end
    object cxLabel4: TcxLabel
      Left = 222
      Top = 33
      Caption = #1057#1091#1084#1084#1072' '#1086#1089#1090#1072#1083#1100#1085#1099#1093' '#1079#1072#1082#1072#1079#1086#1074
    end
    object ceHoursWork: TcxCurrencyEdit
      Left = 703
      Top = 32
      TabStop = False
      Properties.DisplayFormat = ',0.00;-,0.00; ;'
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 89
    end
    object cxLabel5: TcxLabel
      Left = 526
      Top = 33
      Caption = #9#1054#1090#1088#1072#1073#1086#1090#1072#1085#1086' '#1095#1072#1089#1086#1074' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084#1080
    end
    object deDateCalculation: TcxDateEdit
      Left = 635
      Top = 7
      EditValue = 42767d
      Properties.AssignedValues.DisplayFormat = True
      Properties.ReadOnly = True
      TabOrder = 12
      Width = 157
    end
    object cxLabel6: TcxLabel
      Left = 526
      Top = 9
      Caption = #1044#1072#1090#1072' '#1088#1072#1089#1095#1077#1090#1072
    end
    object ceTotalSummSaleNP: TcxCurrencyEdit
      Left = 431
      Top = 58
      TabStop = False
      Properties.DisplayFormat = ',0.00;-,0.00; ;'
      Properties.ReadOnly = True
      TabOrder = 14
      Width = 89
    end
    object cxLabel7: TcxLabel
      Left = 222
      Top = 59
      Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078' "'#1053#1086#1074#1072#1103' '#1087#1086#1095#1090#1072'"'
    end
    object ceTotalSumm: TcxCurrencyEdit
      Left = 703
      Top = 58
      TabStop = False
      Properties.DisplayFormat = ',0.00;-,0.00; ;'
      Properties.ReadOnly = True
      TabOrder = 16
      Width = 89
    end
    object cxLabel8: TcxLabel
      Left = 526
      Top = 59
      Caption = #1041#1072#1079#1072' '#1088#1072#1089#1095#1077#1090#1072
    end
    object cxGrid1: TcxGrid
      Left = 808
      Top = 0
      Width = 361
      Height = 89
      PopupMenu = PopupMenu
      TabOrder = 18
      object cxGridDBTableView1: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = PayrollTypeVIPDS
        DataController.Filter.Options = [fcoCaseInsensitive]
        DataController.Summary.DefaultGroupSummaryItems = <
          item
            Format = ',0.####'
            Column = colPercentOther
          end
          item
            Format = ',0.####'
            Kind = skSum
          end>
        DataController.Summary.FooterSummaryItems = <
          item
            Format = ',0.####'
            Kind = skSum
            Column = colPercentOther
          end
          item
            Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
            Kind = skCount
            Column = colName
          end
          item
            Format = ',0.####'
            Kind = skSum
          end>
        DataController.Summary.SummaryGroups = <>
        Images = dmMain.SortImageList
        OptionsBehavior.GoToNextCellOnEnter = True
        OptionsBehavior.IncSearch = True
        OptionsBehavior.FocusCellOnCycle = True
        OptionsCustomize.ColumnHiding = True
        OptionsCustomize.ColumnsQuickCustomization = True
        OptionsCustomize.DataRowSizing = True
        OptionsData.CancelOnExit = False
        OptionsData.Deleting = False
        OptionsData.DeletingConfirmation = False
        OptionsData.Editing = False
        OptionsData.Inserting = False
        OptionsView.ColumnAutoWidth = True
        OptionsView.GroupByBox = False
        OptionsView.GroupSummaryLayout = gslAlignWithColumns
        OptionsView.HeaderAutoHeight = True
        Styles.StyleSheet = dmMain.cxGridTableViewStyleSheet
        object colName: TcxGridDBColumn
          Caption = #1058#1080#1087' '#1088#1072#1089#1095#1077#1090#1072
          DataBinding.FieldName = 'Name'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 147
        end
        object colPercentPhone: TcxGridDBColumn
          Caption = #1058#1077#1083'. '#1088#1077#1078'.'
          DataBinding.FieldName = 'PercentPhone'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.#### %'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 60
        end
        object colPercentOther: TcxGridDBColumn
          Caption = #1054#1089#1090#1072#1083#1100#1085#1099#1077
          DataBinding.FieldName = 'PercentOther'
          PropertiesClassName = 'TcxCurrencyEditProperties'
          Properties.DecimalPlaces = 4
          Properties.DisplayFormat = ',0.#### %'
          HeaderAlignmentHorz = taCenter
          HeaderAlignmentVert = vaCenter
          Options.Editing = False
          Width = 60
        end
      end
      object cxGridLevel1: TcxGridLevel
        GridView = cxGridDBTableView1
      end
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 67
    Top = 272
  end
  inherited ActionList: TActionList
    Left = 215
    Top = 319
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end
        item
          StoredProc = spSelect_PayrollTypeVIP
        end
        item
        end>
    end
    inherited actMISetErased: TdsdUpdateErased
      StoredProcList = <
        item
          StoredProc = spErasedMIMaster
        end
        item
        end>
    end
    inherited actMISetUnErased: TdsdUpdateErased
      StoredProcList = <
        item
          StoredProc = spUnErasedMIMaster
        end
        item
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
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
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
      ReportName = #1055#1088#1086#1076#1072#1078#1072
      ReportNameParam.Value = #1055#1088#1086#1076#1072#1078#1072
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
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MemberName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
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
      QuestionBeforeExecute = #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1088#1072#1089#1095#1077#1090' '#1079#1072#1088#1072#1073#1086#1090#1085#1086#1081' '#1087#1083#1072#1090#1099' '#1087#1086' '#1074#1089#1077#1084' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084' ?'
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
      Caption = 'actExecCalculationAll'
      Hint = #1056#1072#1089#1095#1077#1090' '#1079'.'#1087'. '#1087#1086' '#1074#1089#1077#1084' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084
    end
    object actCalculationAllDay: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecCalculationAllDay
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = 
        #1042#1099#1087#1086#1083#1085#1080#1090#1100' '#1088#1072#1089#1095#1077#1090' '#1079#1072#1088#1072#1073#1086#1090#1085#1086#1081' '#1087#1083#1072#1090#1099' '#1087#1086' '#1074#1089#1077#1084' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084' ('#1088#1072#1089#1095#1077#1090' '#1087#1086 +
        ' '#1076#1085#1103#1084') ?'
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1056#1072#1089#1095#1080#1090#1072#1090#1100' '#1079#1072#1088#1072#1073#1086#1090#1085#1091#1102' '#1087#1083#1072#1090#1091' '#1087#1086' '#1074#1089#1077#1084' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084' ('#1088#1072#1089#1095#1077#1090' '#1087#1086' '#1076#1085#1103#1084')'
      Hint = #1056#1072#1089#1095#1080#1090#1072#1090#1100' '#1079#1072#1088#1072#1073#1086#1090#1085#1091#1102' '#1087#1083#1072#1090#1091' '#1087#1086' '#1074#1089#1077#1084' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084' ('#1088#1072#1089#1095#1077#1090' '#1087#1086' '#1076#1085#1103#1084')'
      ImageIndex = 38
    end
    object actExecCalculationAllDay: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spCalculationAllDay
      StoredProcList = <
        item
          StoredProc = spCalculationAllDay
        end>
      Caption = 'actExecCalculationAllDay'
      Hint = #1056#1072#1089#1095#1077#1090' '#1079'.'#1087'. '#1087#1086' '#1074#1089#1077#1084' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072#1084
    end
    object actReport_CalcMonthForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1086#1076#1088#1086#1073#1085#1086' '#1087#1086' '#1076#1085#1103#1084' '
      Hint = #1055#1086#1076#1088#1086#1073#1085#1086' '#1087#1086' '#1076#1085#1103#1084' '
      ImageIndex = 3
      FormName = 'TReport_Movement_WagesVIP_CalcMonthForm'
      FormNameParam.Value = 'TReport_Movement_WagesVIP_CalcMonthForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'OperDate'
          Value = Null
          Component = edOperDate
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_WagesVIP'
  end
  inherited BarManager: TdxBarManager
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
          ItemName = 'dxBarButton2'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbReport_CalcMonthForm'
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    inherited bbMovementItemProtocol: TdxBarButton
      UnclickAfterDoing = False
    end
    object bbactStartLoad: TdxBarButton
      Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Category = 0
      Hint = #1047#1072#1075#1088#1091#1079#1080#1090#1100
      Visible = ivAlways
      ImageIndex = 41
    end
    object dxBarButton1: TdxBarButton
      Action = actCalculationAll
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actCalculationAllDay
      Category = 0
    end
    object bbReport_CalcMonthForm: TdxBarButton
      Action = actReport_CalcMonthForm
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 11
      end>
    SearchAsFilter = False
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
        Name = 'TotalCount'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = Null
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        DataType = ftFloat
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 40
    Top = 312
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_WagesVIP'
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 176
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_WagesVIP'
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
        Value = Null
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
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
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
        Name = 'TotalSummPhone'
        Value = Null
        Component = ceTotalSummPhone
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummSale'
        Value = Null
        Component = ceTotalSummSale
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummSaleNP'
        Value = Null
        Component = ceTotalSummSaleNP
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = Null
        Component = ceTotalSumm
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'HoursWork'
        Value = Null
        Component = ceHoursWork
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateCalculation'
        Value = Null
        Component = deDateCalculation
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 72
    Top = 224
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_WagesVIP'
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
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    ParamKeyField = 'ioId'
    Left = 202
    Top = 248
  end
  inherited GuidesFiller: TGuidesFiller
    ActionItemList = <
      item
      end
      item
        Action = actInsertUpdateMovement
      end>
    Left = 288
    Top = 216
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
    Left = 232
    Top = 177
  end
  inherited RefreshAddOn: TRefreshAddOn
    Left = 120
    Top = 312
  end
  inherited spErasedMIMaster: TdsdStoredProc
    Left = 438
    Top = 184
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    Left = 654
    Top = 248
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_WagesVIP'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
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
        Name = 'inUserID'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UserID'
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
      end>
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 320
    Top = 288
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 464
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_WagesVIP_TotalSumm'
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
        Name = 'TotalCount'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalCount'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSumm'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalSumm'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'TotalSummPrimeCost'
        Value = Null
        Component = FormParams
        ComponentItem = 'TotalSummPrimeCost'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 652
    Top = 196
  end
  object spCalculationAll: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_WagesVIP_CalculationAll'
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
    Left = 552
    Top = 192
  end
  object spCalculationAllDay: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_WagesVIP_CalculationAllDay'
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
    Left = 552
    Top = 256
  end
  object PayrollTypeVIPDS: TDataSource
    DataSet = PayrollTypeVIPCDS
    Left = 896
    Top = 32
  end
  object PayrollTypeVIPCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 848
    Top = 32
  end
  object spSelect_PayrollTypeVIP: TdsdStoredProc
    StoredProcName = 'gpSelect_WagesVIP_PayrollTypeVIP'
    DataSet = PayrollTypeVIPCDS
    DataSets = <
      item
        DataSet = PayrollTypeVIPCDS
      end>
    Params = <>
    PackSize = 1
    Left = 1024
    Top = 32
  end
end
