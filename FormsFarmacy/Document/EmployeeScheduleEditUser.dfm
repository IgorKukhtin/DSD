inherited EmployeeScheduleEditUserForm: TEmployeeScheduleEditUserForm
  ActiveControl = cxGrid
  Caption = #1048#1079#1084#1077#1085#1077#1085#1080#1077' '#1075#1088#1072#1092#1080#1082#1072' '#1088#1072#1073#1086#1090#1099' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1086#1074
  ClientHeight = 500
  ClientWidth = 771
  AddOnFormData.AddOnFormRefresh.ParentList = 'EmployeeScheduleEditUser'
  ExplicitWidth = 787
  ExplicitHeight = 539
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 75
    Width = 771
    Height = 425
    ExplicitTop = 75
    ExplicitWidth = 771
    ExplicitHeight = 425
    ClientRectBottom = 425
    ClientRectRight = 771
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 771
      ExplicitHeight = 401
      inherited cxGrid: TcxGrid
        Width = 771
        Height = 401
        ExplicitWidth = 771
        ExplicitHeight = 401
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.000'
              Kind = skSum
            end
            item
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
            end
            item
              Format = ',0.000'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end>
          OptionsBehavior.IncSearch = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Day: TcxGridDBColumn [0]
            Caption = #1044#1077#1085#1100
            DataBinding.FieldName = 'Day'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 42
          end
          object UnitName: TcxGridDBColumn [1]
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actUnitChoice
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 147
          end
          object isSubstitution: TcxGridDBColumn [2]
            Caption = #1055#1086#1076#1084#1077#1085#1072
            DataBinding.FieldName = 'isSubstitution'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object ShortName: TcxGridDBColumn [3]
            Caption = #1058#1080#1087' '#1076#1085#1103
            DataBinding.FieldName = 'ShortName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 46
          end
          object PayrollTypeName: TcxGridDBColumn [4]
            Caption = #1058#1080#1087' '#1076#1085#1103
            DataBinding.FieldName = 'PayrollTypeName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actPayrollTypeChoice
                Default = True
                Kind = bkEllipsis
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 115
          end
          object TimeStart: TcxGridDBColumn [5]
            Caption = #1042#1088#1077#1084#1103' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'TimeStart'
            PropertiesClassName = 'TcxTimeEditProperties'
            Properties.TimeFormat = tfHourMin
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 61
          end
          object TimeEnd: TcxGridDBColumn [6]
            Caption = #1042#1088#1077#1084#1103' '#1091#1093#1086#1076#1072
            DataBinding.FieldName = 'TimeEnd'
            PropertiesClassName = 'TcxTimeEditProperties'
            Properties.TimeFormat = tfHourMin
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 61
          end
          object DateStart: TcxGridDBColumn [7]
            Caption = #1044#1072#1090#1072' '#1087#1088#1080#1093#1086#1076#1072
            DataBinding.FieldName = 'DateStart'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'dd.mm.yyyy hh:nn'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 144
          end
          object DateEnd: TcxGridDBColumn [8]
            Caption = #1044#1072#1090#1072' '#1091#1093#1086#1076#1072
            DataBinding.FieldName = 'DateEnd'
            PropertiesClassName = 'TcxDateEditProperties'
            Properties.DisplayFormat = 'dd.mm.yyyy hh:nn'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 125
          end
          object Color_CalcUser: TcxGridDBColumn [9]
            DataBinding.FieldName = 'Color_CalcUser'
            Visible = False
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 771
    Height = 49
    TabOrder = 3
    ExplicitWidth = 771
    ExplicitHeight = 49
    inherited edInvNumber: TcxTextEdit
      Left = 20
      Top = 22
      ExplicitLeft = 20
      ExplicitTop = 22
    end
    inherited cxLabel1: TcxLabel
      Left = 20
      Top = 4
      ExplicitLeft = 20
      ExplicitTop = 4
    end
    inherited edOperDate: TcxDateEdit
      Left = 120
      Top = 22
      Properties.DisplayFormat = 'mmmm yyyy'
      Properties.ReadOnly = True
      ExplicitLeft = 120
      ExplicitTop = 22
    end
    inherited cxLabel2: TcxLabel
      Left = 120
      Top = 4
      ExplicitLeft = 120
      ExplicitTop = 4
    end
    inherited cxLabel15: TcxLabel
      Left = 23
      Top = 56
      Visible = False
      ExplicitLeft = 23
      ExplicitTop = 56
    end
    inherited ceStatus: TcxButtonEdit
      Left = 20
      Top = 74
      Visible = False
      ExplicitLeft = 20
      ExplicitTop = 74
      ExplicitHeight = 22
    end
    object edUserName: TcxTextEdit
      Left = 226
      Top = 22
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 242
    end
    object cxLabel3: TcxLabel
      Left = 226
      Top = 4
      Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
    end
    object edUnitName: TcxTextEdit
      Left = 474
      Top = 22
      Properties.ReadOnly = True
      TabOrder = 8
      Width = 279
    end
    object cxLabel4: TcxLabel
      Left = 474
      Top = 4
      Caption = #1054#1089#1085#1086#1074#1085#1086#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
    end
    object edUserCode: TcxTextEdit
      Left = 290
      Top = 3
      ParentColor = True
      Properties.ReadOnly = True
      Style.BorderStyle = ebsNone
      TabOrder = 10
      Width = 71
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
        end
        item
          Name = 'PersonalName'
          Value = Null
          Component = edUserName
          DataType = ftString
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
          Component = edOperDate
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
          Action = actAddUserDialog
        end
        item
          Action = actAddPayrollType
        end
        item
          Action = actRefresh
        end>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1080#1087' '#1076#1085#1103' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' '#1090#1080#1087' '#1076#1085#1103' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091
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
    object actAddPayrollType: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spAddPayrollType
      StoredProcList = <
        item
          StoredProc = spAddPayrollType
        end>
      Caption = 'actAddPayrollType'
    end
    object actPreviousMonth: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecPreviousMonth
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1055#1088#1086#1080#1079#1074#1086#1076#1080#1090#1100' '#1079#1072#1075#1088#1091#1079#1082#1091' '#1075#1088#1072#1092#1080#1082#1086#1074' '#1089' '#1087#1088#1077#1076#1099#1076#1091#1097#1077#1075#1086' '#1084#1077#1089#1103#1094#1072
      InfoAfterExecute = #1042#1099#1087#1086#1083#1085#1077#1085#1086
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1075#1088#1072#1092#1080#1082#1086#1074' '#1089' '#1087#1088#1077#1076#1099#1076#1091#1097#1077#1075#1086' '#1084#1077#1089#1103#1094#1072
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1075#1088#1072#1092#1080#1082#1086#1074' '#1089' '#1087#1088#1077#1076#1099#1076#1091#1097#1077#1075#1086' '#1084#1077#1089#1103#1094#1072
      ImageIndex = 50
    end
    object actExecPreviousMonth: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actExecPreviousMonth'
    end
    object actUpdateUnit: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actChoiceUnitTreeForm
        end
        item
          Action = actExecStoredUpdateUnit
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1048#1079#1084#1077#1085#1080#1090#1100' '#1086#1089#1085#1086#1074#1085#1086#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'?'
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1086#1089#1085#1086#1074#1085#1086#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1086#1089#1085#1086#1074#1085#1086#1077' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      ImageIndex = 66
    end
    object actChoiceUnitTreeForm: TOpenChoiceForm
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
    object actExecStoredUpdateUnit: TdsdExecStoredProc
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
    object actPayrollTypeChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'OpenChoiceForm1'
      FormName = 'TPayrollTypeForm'
      FormNameParam.Value = 'TPayrollTypeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PayrollTypeID'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PayrollTypeName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShortName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'ShortName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actUnitChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actUnitChoice'
      FormName = 'TUnitTreeForm'
      FormNameParam.Value = 'TUnitTreeForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitID'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actDelUserDay: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      AfterAction = actRefresh
      PostDataSetBeforeExecute = False
      StoredProc = spDelUserDay
      StoredProcList = <
        item
          StoredProc = spDelUserDay
        end>
      Caption = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091' '#1079#1072' '#1076#1077#1085#1100
      Hint = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091' '#1079#1072' '#1076#1077#1085#1100
      ImageIndex = 52
      QuestionBeforeExecute = #1059#1076#1072#1083#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1087#1086' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1091' '#1079#1072' '#1076#1077#1085#1100'?'
    end
    object actSetPayrollType: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actDialogPayrollType
        end
        item
          Action = actExecViewPayrollType
        end
        item
          Action = actRefresh
        end>
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1090#1080#1087' '#1076#1085#1103' '#1087#1086' '#1086#1090#1092#1080#1083#1100#1090#1088#1086#1074#1072#1085#1085#1099#1084' '#1087#1086#1079#1080#1094#1080#1103#1084
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1090#1080#1087' '#1076#1085#1103' '#1087#1086' '#1086#1090#1092#1080#1083#1100#1090#1088#1086#1074#1072#1085#1085#1099#1084' '#1087#1086#1079#1080#1094#1080#1103#1084
      ImageIndex = 43
    end
    object actDialogPayrollType: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actDialogPayrollType'
      FormName = 'TPayrollTypeDialogForm'
      FormNameParam.Value = 'TPayrollTypeDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = FormParams
          ComponentItem = 'PayrollTypeID'
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object actExecViewPayrollType: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actExecPayrollType
        end>
      View = cxGridDBTableView
      Caption = #1047#1072#1087#1086#1083#1085#1077#1085#1080#1077' '#1090#1080#1087#1072' '#1076#1085#1103
    end
    object actExecPayrollType: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spExecPayrollType
      StoredProcList = <
        item
          StoredProc = spExecPayrollType
        end>
      Caption = 'actExecPayrollType'
    end
    object actAddUserDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'actAddUserDialog'
      FormName = 'TEmployeeScheduleAddUserDialogForm'
      FormNameParam.Value = 'TEmployeeScheduleAddUserDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UserName'
          Value = Null
          Component = edUserName
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitID'
          Value = Null
          Component = FormParams
          ComponentItem = 'UnitID'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PayrollTypeId'
          Value = Null
          Component = FormParams
          ComponentItem = 'PayrollTypeID'
          MultiSelectSeparator = ','
        end
        item
          Name = 'DateStart'
          Value = Null
          Component = FormParams
          ComponentItem = 'DateStart'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'DateEnd'
          Value = Null
          Component = FormParams
          ComponentItem = 'DateEnd'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
  end
  inherited MasterDS: TDataSource
    Top = 224
  end
  inherited MasterCDS: TClientDataSet
    Top = 224
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_EmployeeScheduleEditUser'
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementID'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inShowAll'
        Value = False
        Component = FormParams
        ComponentItem = 'ShowAll'
        DataType = ftBoolean
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
      end>
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
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarButton5'
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
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' '#1089#1086#1090#1088#1091#1076#1085#1080#1082#1072
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
      Action = actPreviousMonth
      Category = 0
    end
    object dxBarButton5: TdxBarButton
      Action = actUpdateUnit
      Category = 0
    end
    object dxBarButton6: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1076#1083#1103' '#1087#1086#1076#1084#1077#1085#1099
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' '#1076#1083#1103' '#1087#1086#1076#1084#1077#1085#1099
      Visible = ivAlways
      ImageIndex = 35
    end
    object dxBarButton7: TdxBarButton
      Action = actDelUserDay
      Category = 0
    end
    object dxBarButton8: TdxBarButton
      Action = actSetPayrollType
      Category = 0
    end
    object dxBarButton9: TdxBarButton
      Action = actAddUser
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    ColorRuleList = <
      item
        BackGroundValueColumn = Color_CalcUser
        ColorValueList = <>
      end>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 0
      end>
    SearchAsFilter = False
    Left = 334
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
        Name = 'MovementID'
        Value = Null
        ParamType = ptInputOutput
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
        Name = 'PayrollTypeID'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateStart'
        Value = Null
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'DateEnd'
        Value = Null
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 40
    Top = 312
  end
  inherited StatusGuides: TdsdGuides
    Top = 232
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_EmployeeScheduleEditUser'
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Top = 232
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_EmployeeSchedule_UserEdit'
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementID'
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
        Name = 'UserCode'
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
        Name = 'UnitName'
        Value = Null
        Component = edUnitName
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 176
    Top = 272
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_EmployeeSchedule'
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
    ActionItemList = <
      item
        Action = actDataDialog
      end
      item
        Action = actInsertUpdateMovement
      end>
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
    StoredProcName = 'gpInsertUpdate_MovementItem_EmployeeScheduleEditUser'
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
        ComponentItem = 'MovementID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentID'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDay'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Day'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUnitID'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'UnitID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPayrollTypeID'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PayrollTypeID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTimeStart'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TimeStart'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inTimeEnd'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'TimeEnd'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 408
    Top = 280
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    Left = 352
    Top = 336
  end
  inherited spGetTotalSumm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_EmployeeSchedule_TotalSumm'
    Left = 668
    Top = 228
  end
  object spAddPayrollType: TdsdStoredProc
    StoredProcName = 'gpInsert_MovementItem_EmployeeScheduleAddUser_PayrollType'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
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
      end
      item
        Name = 'inUnitID'
        Value = Null
        Component = FormParams
        ComponentItem = 'UnitID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPayrollTypeID'
        Value = Null
        Component = FormParams
        ComponentItem = 'PayrollTypeID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateStart'
        Value = Null
        Component = FormParams
        ComponentItem = 'DateStart'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDateEnd'
        Value = Null
        Component = FormParams
        ComponentItem = 'DateEnd'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 488
    Top = 336
  end
  object spUpdateUnit: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_EmployeeSchedule_Unit'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
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
    Left = 672
    Top = 297
  end
  object spDelUserDay: TdsdStoredProc
    StoredProcName = 'gpDelete_MovementItem_EmployeeSchedule_UserDay'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementID'
        Value = Null
        Component = FormParams
        ComponentItem = 'MovementID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 672
    Top = 353
  end
  object spExecPayrollType: TdsdStoredProc
    StoredProcName = 'gpUpdate_MovementItem_EmployeeSchedule_PayrollType'
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
        Name = 'inDay'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Day'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPayrollTypeID'
        Value = Null
        Component = FormParams
        ComponentItem = 'PayrollTypeID'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    NeedResetData = True
    ParamKeyField = 'inMovementId'
    Left = 184
    Top = 336
  end
end
