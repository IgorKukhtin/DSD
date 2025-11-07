inherited Report_Personal_Cash_smsForm: TReport_Personal_Cash_smsForm
  Caption = #1054#1090#1095#1077#1090' <'#1054#1090#1087#1088#1072#1074#1082#1072' '#1089#1084#1089'>'
  ClientHeight = 483
  ClientWidth = 984
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1000
  ExplicitHeight = 522
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 64
    Width = 984
    Height = 419
    TabOrder = 3
    ExplicitTop = 64
    ExplicitWidth = 984
    ExplicitHeight = 419
    ClientRectBottom = 419
    ClientRectRight = 984
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 984
      ExplicitHeight = 419
      inherited cxGrid: TcxGrid
        Width = 984
        Height = 419
        ExplicitWidth = 984
        ExplicitHeight = 419
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = PersonalName
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
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 82
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
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
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object PersonalServiceListName: TcxGridDBColumn
            Caption = #1042#1077#1076#1086#1084#1086#1089#1090#1100
            DataBinding.FieldName = 'PersonalServiceListName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 140
          end
          object PersonalCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'PersonalCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PersonalName: TcxGridDBColumn
            Caption = #1060#1048#1054' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            DataBinding.FieldName = 'PersonalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object PositionName: TcxGridDBColumn
            Caption = #1044#1086#1083#1078#1085#1086#1089#1090#1100
            DataBinding.FieldName = 'PositionName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 96
          end
          object PositionLevelName: TcxGridDBColumn
            Caption = #1056#1072#1079#1088#1103#1076' '#1076#1086#1083#1078#1085#1086#1089#1090#1080
            DataBinding.FieldName = 'PositionLevelName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 113
          end
          object Amount: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object isSms: TcxGridDBColumn
            Caption = #1054#1090#1087#1088#1072#1074#1083#1077#1085#1086' '#1089#1084#1089' ('#1044#1072'/'#1053#1077#1090')'
            DataBinding.FieldName = 'isSms'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object Date_SMS: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1086#1090#1087#1088#1072#1074#1082#1080' '#1089#1084#1089
            DataBinding.FieldName = 'Date_SMS'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object Phone: TcxGridDBColumn
            Caption = #8470' '#1058#1077#1083#1077#1092#1086#1085#1072
            DataBinding.FieldName = 'Phone'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 984
    Height = 38
    ExplicitWidth = 984
    ExplicitHeight = 38
    inherited deStart: TcxDateEdit
      Top = 7
      EditValue = 45809d
      Properties.SaveTime = False
      ExplicitTop = 7
      ExplicitWidth = 81
      Width = 81
    end
    inherited deEnd: TcxDateEdit
      Left = 317
      Top = 7
      EditValue = 45809d
      Properties.SaveTime = False
      ExplicitLeft = 317
      ExplicitTop = 7
      ExplicitWidth = 81
      Width = 81
    end
    inherited cxLabel1: TcxLabel
      Left = 4
      Top = 8
      ExplicitLeft = 4
      ExplicitTop = 8
    end
    inherited cxLabel2: TcxLabel
      Left = 201
      Top = 8
      ExplicitLeft = 201
      ExplicitTop = 8
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 59
    Top = 320
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 48
  end
  inherited ActionList: TActionList
    Left = 623
    Top = 279
    inherited actRefresh: TdsdDataSetRefresh
      TabSheet = tsMain
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1077#1088#1080#1086#1076
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1077#1088#1080#1086#1076
      ImageIndex = 35
      FormName = 'TDatePeriodDialogForm'
      FormNameParam.Value = 'TDatePeriodDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inStartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inEndDate'
          Value = Null
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actOpenMovementForm: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1050#1072#1089#1089#1072', '#1074#1099#1087#1083#1072#1090#1072' '#1087#1086' '#1074#1077#1076#1086#1084#1086#1089#1090#1080'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1050#1072#1089#1089#1072', '#1074#1099#1087#1083#1072#1090#1072' '#1087#1086' '#1074#1077#1076#1086#1084#1086#1089#1090#1080'>'
      ImageIndex = 28
      FormName = 'TCash_PersonalForm'
      FormNameParam.Value = Null
      FormNameParam.Component = FormParams
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
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inMovementId_Value'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actGetForm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = getMovementForm
      StoredProcList = <
        item
          StoredProc = getMovementForm
        end>
      Caption = 'actGetForm'
    end
    object mactOpenDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetForm
        end
        item
          Action = actOpenMovementForm
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 28
    end
  end
  inherited MasterDS: TDataSource
    Left = 112
    Top = 200
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Personal_Cash_sms'
    DataSets = <
      item
        DataSet = MasterCDS
      end
      item
      end
      item
      end>
    Params = <
      item
        Name = 'inStartDate'
        Value = 44927d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = Null
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 176
    Top = 200
  end
  inherited BarManager: TdxBarManager
    Left = 408
    Top = 272
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
    object bbOpenMovementForm: TdxBarButton
      Action = mactOpenDocument
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 648
    Top = 208
  end
  inherited PopupMenu: TPopupMenu
    Left = 144
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 232
    Top = 0
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = deStart
      end
      item
        Component = deEnd
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
    Left = 560
    Top = 208
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'FormName'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 336
    Top = 226
  end
  object HeaderCDS: TClientDataSet
    Aggregates = <>
    FilterOptions = [foCaseInsensitive]
    Params = <>
    Left = 256
    Top = 208
  end
  object getMovementForm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FormName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 456
    Top = 208
  end
end
