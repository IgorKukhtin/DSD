inherited Report_Client_LastErrorForm: TReport_Client_LastErrorForm
  Caption = #1055#1088#1086#1074#1077#1088#1082#1072' '#1057#1091#1084#1084' '#1087#1086#1089#1083#1077#1076#1085#1077#1081' '#1087#1086#1082#1091#1087#1082#1080' '#1055#1086#1082#1091#1087#1072#1090#1077#1083#1077#1081
  ClientHeight = 425
  ClientWidth = 1065
  AddOnFormData.RefreshAction = actRefreshStart
  ExplicitWidth = 1081
  ExplicitHeight = 463
  PixelsPerInch = 96
  TextHeight = 13
  inherited Panel: TPanel [0]
    Width = 1065
    Height = 25
    Visible = False
    ExplicitWidth = 1065
    ExplicitHeight = 25
    inherited deStart: TcxDateEdit
      Left = 29
      EditValue = 42736d
      Visible = False
      ExplicitLeft = 29
    end
    inherited deEnd: TcxDateEdit
      Left = 142
      EditValue = 42736d
      Visible = False
      ExplicitLeft = 142
    end
    inherited cxLabel1: TcxLabel
      Caption = #1057':'
      Visible = False
      ExplicitWidth = 15
    end
    inherited cxLabel2: TcxLabel
      Left = 120
      Caption = #1087#1086':'
      Visible = False
      ExplicitLeft = 120
      ExplicitWidth = 20
    end
  end
  inherited PageControl: TcxPageControl [1]
    Top = 51
    Width = 1065
    Height = 374
    TabOrder = 3
    ExplicitTop = 51
    ExplicitWidth = 1065
    ExplicitHeight = 374
    ClientRectBottom = 374
    ClientRectRight = 1065
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1065
      ExplicitHeight = 374
      inherited cxGrid: TcxGrid
        Width = 1065
        Height = 374
        ExplicitWidth = 1065
        ExplicitHeight = 374
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = LastCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = LastSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = LastSummDiscount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = LastCount_Calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = LastSumm_Calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = LastSummDiscount_Calc
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = ClientName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = LastCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = LastSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = LastSummDiscount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = LastCount_Calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = LastSumm_Calc
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = LastSummDiscount_Calc
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
          object ClientCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'ClientCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object ClientName: TcxGridDBColumn
            Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100
            DataBinding.FieldName = 'ClientName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 253
          end
          object LastCount: TcxGridDBColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1074' '#1087#1086#1089#1083#1077#1076#1085#1077#1081' '#1087#1086#1082#1091#1087#1082#1077
            DataBinding.FieldName = 'LastCount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 124
          end
          object LastCount_Calc: TcxGridDBColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1074' '#1087#1086#1089#1083#1077#1076#1085#1077#1081' '#1087#1086#1082#1091#1087#1082#1077' ('#1088#1072#1089#1095#1077#1090')'
            DataBinding.FieldName = 'LastCount_Calc'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 124
          end
          object LastSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086#1089#1083#1077#1076#1085#1077#1081' '#1087#1086#1082#1091#1087#1082#1080
            DataBinding.FieldName = 'LastSumm'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 122
          end
          object LastSumm_Calc: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086#1089#1083#1077#1076#1085#1077#1081' '#1087#1086#1082#1091#1087#1082#1080' ('#1088#1072#1089#1095#1077#1090')'
            DataBinding.FieldName = 'LastSumm_Calc'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 122
          end
          object LastSummDiscount: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1074' '#1087#1086#1089#1083#1077#1076#1085#1077#1081' '#1087#1086#1082#1091#1087#1082#1077
            DataBinding.FieldName = 'LastSummDiscount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 125
          end
          object LastSummDiscount_Calc: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1089#1082#1080#1076#1082#1080' '#1074' '#1087#1086#1089#1083#1077#1076#1085#1077#1081' '#1087#1086#1082#1091#1087#1082#1077' ('#1088#1072#1089#1095#1077#1090')'
            DataBinding.FieldName = 'LastSummDiscount_Calc'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 125
          end
          object LastDate: TcxGridDBColumn
            Caption = #1055#1086#1089#1083#1077#1076#1085#1103#1103' '#1076#1072#1090#1072' '#1087#1086#1082#1091#1087#1082#1080
            DataBinding.FieldName = 'LastDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 92
          end
          object LastDate_Calc: TcxGridDBColumn
            Caption = #1055#1086#1089#1083#1077#1076#1085#1103#1103' '#1076#1072#1090#1072' '#1087#1086#1082#1091#1087#1082#1080' ('#1088#1072#1089#1095#1077#1090')'
            DataBinding.FieldName = 'LastDate_Calc'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            Width = 92
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1086#1089#1083'. '#1076#1086#1082'. '#1087#1088#1086#1076'. ('#1088#1072#1089#1095#1077#1090')'
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderGlyphAlignmentHorz = taCenter
            HeaderHint = #1044#1072#1090#1072' '#1087#1086#1089#1083#1077#1076#1085#1077#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1087#1088#1086#1076#1072#1078#1080
            Width = 90
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1087#1086#1089#1083'. '#1076#1086#1082'. '#1087#1088#1086#1076'. ('#1088#1072#1089#1095#1077#1090')'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #8470' '#1087#1086#1089#1083#1077#1076#1085#1077#1075#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1087#1088#1086#1076#1072#1078#1080
            Options.Editing = False
            Width = 100
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    object actGet_UserUnit: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actGet_UserUnit'
    end
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
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
      FormName = 'TReport_GoodsMI_AccountDialogForm'
      FormNameParam.Value = 'TReport_GoodsMI_AccountDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41579d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41608d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = ''
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actRefreshMovement: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1044#1086#1082#1091#1084#1077#1085#1090#1072#1084
      Hint = #1087#1086' '#1044#1086#1082#1091#1084#1077#1085#1090#1072#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshSize: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1056#1072#1079#1084#1077#1088#1072#1084
      Hint = #1087#1086' '#1056#1072#1079#1084#1077#1088#1072#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshPartner: TdsdDataSetRefresh
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
    object actOpenReportForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1044#1074#1080#1078#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1072'>'
      Hint = #1054#1090#1095#1077#1090' <'#1044#1074#1080#1078#1077#1085#1080#1077' '#1090#1086#1074#1072#1088#1072'>'
      ImageIndex = 40
      FormName = 'TReport_GoodsForm'
      FormNameParam.Value = 'TReport_GoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'LocationId'
          Value = ''
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = ''
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
          Name = 'GoodsSizeId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsSizeId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsSizeName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsSizeName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartionId'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isPeriod'
          Value = 'TRUE'
          DataType = ftBoolean
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
          Name = 'MovementId'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'InvNumber'
          Value = Null
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = '0'
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42736d
          FromParam.Component = deStart
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'StartDate'
          ToParam.Value = 'NULL'
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end
        item
          FromParam.Value = 42736d
          FromParam.Component = deEnd
          FromParam.DataType = ftDateTime
          FromParam.MultiSelectSeparator = ','
          ToParam.Name = 'EndDate'
          ToParam.Value = 'NULL'
          ToParam.DataType = ftDateTime
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = MasterCDS
          UserName = 'frxDBDItems'
          IndexFieldNames = 'OperDate;DescName;InvNumber;LabelName;GoodsSizeName'
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 42736d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42736d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1087#1086' '#1088#1072#1089#1095#1077#1090#1072#1084
      ReportNameParam.Value = #1054#1090#1095#1077#1090' '#1087#1086' '#1088#1072#1089#1095#1077#1090#1072#1084
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
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
    StoredProcName = 'gpReport_Object_Client_LastError'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41395d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 72
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
    object bbOpenReportForm: TdxBarButton
      Action = actOpenReportForm
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 416
    Top = 65528
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end
      item
      end
      item
      end>
    Left = 688
    Top = 280
  end
end
