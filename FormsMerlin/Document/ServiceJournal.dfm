inherited ServiceJournalForm: TServiceJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1072#1088#1077#1085#1076#1099'>'
  ClientHeight = 331
  ClientWidth = 1028
  AddOnFormData.RefreshAction = actRefreshStart
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1044
  ExplicitHeight = 369
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1028
    Height = 274
    TabOrder = 3
    ExplicitWidth = 1028
    ExplicitHeight = 274
    ClientRectBottom = 274
    ClientRectRight = 1028
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1028
      ExplicitHeight = 274
      inherited cxGrid: TcxGrid
        Width = 1028
        Height = 274
        ExplicitWidth = 1028
        ExplicitHeight = 274
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00##'
              Kind = skSum
              Column = Amount
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00##'
              Kind = skSum
              Column = Amount
            end
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = UnitName
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colStatus: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 69
          end
          object isAuto: TcxGridDBColumn [1]
            Caption = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
            DataBinding.FieldName = 'isAuto'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1040#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080
            Options.Editing = False
            Width = 70
          end
          inherited colInvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 121
          end
          inherited colOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 72
          end
          object ServiceDate: TcxGridDBColumn
            Caption = #1052#1077#1089#1103#1094' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103
            DataBinding.FieldName = 'ServiceDate'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'mmmm yyyy'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 89
          end
          object UnitCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086#1076#1088'.'
            DataBinding.FieldName = 'UnitCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object UnitName: TcxGridDBColumn
            Caption = #1054#1090#1076#1077#1083
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 149
          end
          object Amount: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 94
          end
          object InfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1089#1090#1072#1090#1100#1080
            DataBinding.FieldName = 'InfoMoneyCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 33
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1100#1103' '#1055#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 197
          end
          object CommentInfoMoneyName: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077' '#1055#1088#1080#1093#1086#1076'/'#1088#1072#1089#1093#1086#1076
            DataBinding.FieldName = 'CommentInfoMoneyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 198
          end
          object InsertName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076#1072#1085#1080#1077')'
            Options.Editing = False
            Width = 101
          end
          object InsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1042#1088#1077#1084#1103' ('#1089#1086#1079#1076#1072#1085#1080#1077')'
            Options.Editing = False
            Width = 78
          end
          object UpdateName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072')'
            Options.Editing = False
            Width = 101
          end
          object UpdateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1072#1090#1072'/'#1042#1088#1077#1084#1103' ('#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072')'
            Options.Editing = False
            Width = 78
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1028
    ExplicitWidth = 1028
    inherited deStart: TcxDateEdit
      EditValue = 44562d
    end
    inherited deEnd: TcxDateEdit
      EditValue = 44562d
    end
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
      end>
  end
  inherited ActionList: TActionList
    inherited actInsert: TdsdInsertUpdateAction
      FormName = 'TServiceMovementForm'
      FormNameParam.Value = 'TServiceMovementForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId_Value'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
    end
    inherited actInsertMask: TdsdInsertUpdateAction
      FormName = 'TServiceMovementForm'
      FormNameParam.Value = 'TServiceMovementForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId_Value'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TServiceMovementForm'
      FormNameParam.Value = 'TServiceMovementForm'
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
          Name = 'inMovementId_Value'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1054#1090#1095#1077#1090' - '#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1088'/'#1089#1095#1077#1090#1072#1084
      Hint = #1054#1090#1095#1077#1090' - '#1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1088'/'#1089#1095#1077#1090#1072#1084
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDItems'
          IndexFieldNames = 'AccountName;BankName;BankAccountName'
        end>
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
      ReportName = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1088#1072#1089#1095#1077#1090#1085#1086#1084#1091' '#1089#1095#1077#1090#1091
      ReportNameParam.Value = #1054#1073#1086#1088#1086#1090#1099' '#1087#1086' '#1088#1072#1089#1095#1077#1090#1085#1086#1084#1091' '#1089#1095#1077#1090#1091
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint1: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <
        item
          FromParam.Name = 'id'
          FromParam.Value = Null
          FromParam.ComponentItem = 'id'
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.Component = FormParams
          ToParam.ComponentItem = 'Id'
          ToParam.ParamType = ptInputOutput
          ToParam.MultiSelectSeparator = ','
        end>
      StoredProcList = <>
      Caption = #1055#1083#1072#1090#1077#1078#1082#1072' '#1041#1072#1085#1082
      Hint = #1055#1083#1072#1090#1077#1078#1082#1072' '#1041#1072#1085#1082
      ImageIndex = 16
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDItems'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      ReportName = #1055#1083#1072#1090#1077#1078#1082#1072' '#1041#1072#1085#1082
      ReportNameParam.Value = #1055#1083#1072#1090#1077#1078#1082#1072' '#1041#1072#1085#1082
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TMovement_PeriodDialogForm'
      FormNameParam.Value = 'TMovement_PeriodDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actUpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actUpdateDataSet'
      DataSource = MasterDS
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
  end
  inherited MasterDS: TDataSource
    Left = 40
    Top = 139
  end
  inherited MasterCDS: TClientDataSet
    Left = 8
    Top = 123
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Service'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInputOutput
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
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = Null
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Top = 131
  end
  inherited BarManager: TdxBarManager
    Left = 128
    Top = 131
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsert'
        end
        item
          Visible = True
          ItemName = 'bbInsertMask'
        end
        item
          Visible = True
          ItemName = 'bbEdit'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbComplete'
        end
        item
          Visible = True
          ItemName = 'bbUnComplete'
        end
        item
          Visible = True
          ItemName = 'bbDelete'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
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
          ItemName = 'bbMovementItemContainer'
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
          ItemName = 'bbMovementProtocol'
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
    object bbAddBonus: TdxBarButton
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1073#1086#1085#1091#1089#1086#1074
      Category = 0
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1073#1086#1085#1091#1089#1086#1074
      Visible = ivAlways
      ImageIndex = 27
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbPrint1: TdxBarButton
      Action = actPrint1
      Category = 0
      ShortCut = 16465
    end
    object bbisCopy: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1073#1086#1085#1091#1089#1086#1074' '#1044#1072'/'#1053#1077#1090'"'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' "'#1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1073#1086#1085#1091#1089#1086#1074' '#1044#1072'/'#1053#1077#1090'"'
      Visible = ivAlways
      ImageIndex = 58
    end
    object bb: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1086#1075#1086#1074#1086#1088
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1086#1075#1086#1074#1086#1088
      Visible = ivAlways
      ImageIndex = 43
    end
    object bbUpdateMoneyPlace: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1054#1090' '#1050#1086#1075#1086', '#1050#1086#1084#1091'>'
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' <'#1054#1090' '#1050#1086#1075#1086', '#1050#1086#1084#1091'>'
      Visible = ivAlways
      ImageIndex = 55
    end
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end>
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_Service'
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_Service'
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_Service'
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
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isCopy'
        Value = Null
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
  end
  inherited spMovementReComplete: TdsdStoredProc
    StoredProcName = 'gpReComplete_Movement_Service'
    Left = 376
    Top = 152
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 708
    Top = 262
  end
  object spSelectPrint: TdsdStoredProc
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
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
        Name = 'inJuridicalBasisId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAccountId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inBankAccountId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyId'
        Value = 0
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsDetail'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 631
    Top = 232
  end
end
