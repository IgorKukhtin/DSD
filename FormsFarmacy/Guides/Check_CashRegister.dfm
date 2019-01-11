inherited Check_CashRegisterForm: TCheck_CashRegisterForm
  Caption = #1050#1072#1089#1089#1099' '#1087#1086' '#1087#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1103#1084
  ClientHeight = 463
  ClientWidth = 583
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 599
  ExplicitHeight = 502
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 583
    Height = 406
    ExplicitWidth = 511
    ExplicitHeight = 406
    ClientRectBottom = 406
    ClientRectRight = 583
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 511
      ExplicitHeight = 406
      inherited cxGrid: TcxGrid
        Width = 583
        Height = 406
        ExplicitWidth = 511
        ExplicitHeight = 406
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
              Column = CashSessionId
            end>
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object CashSessionId: TcxGridDBColumn
            Caption = #1050#1072#1089#1089#1072
            DataBinding.FieldName = 'CashRegisterName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 130
          end
          object cxGridDBTableViewColumn1: TcxGridDBColumn
            Caption = #1057#1077#1088#1080#1081#1085#1099#1081' '#1085#1086#1084#1077#1088
            DataBinding.FieldName = 'SerialNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 96
          end
          object UnitName: TcxGridDBColumn
            Caption = #1040#1087#1090#1077#1082#1072
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 232
          end
          object UserName: TcxGridDBColumn
            Caption = #1063#1077#1082#1086#1074' '#1079#1072' '#1087#1077#1088#1080#1086#1076
            DataBinding.FieldName = 'CheckCount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 583
    ExplicitWidth = 511
    inherited deStart: TcxDateEdit
      Left = 108
      EditValue = 43344d
      Properties.AssignedValues.DisplayFormat = True
      Properties.AssignedValues.EditFormat = True
      TabOrder = 1
      ExplicitLeft = 108
    end
    inherited deEnd: TcxDateEdit
      Left = 334
      EditValue = 43344d
      TabOrder = 0
      ExplicitLeft = 334
    end
    inherited cxLabel1: TcxLabel
      Left = 11
      ExplicitLeft = 11
    end
    inherited cxLabel2: TcxLabel
      Left = 218
      ExplicitLeft = 218
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 51
    Top = 192
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 8
    Top = 232
  end
  inherited ActionList: TActionList
    Left = 87
    Top = 191
    object actRefreshSearch: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actRefreshSearch'
      ShortCut = 13
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
      FormName = 'TMovement_PeriodDialogForm'
      FormNameParam.Value = 'TMovement_PeriodDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42491d
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
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object dsdOpenForm1: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'dsdOpenForm1'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <>
      isShowModal = False
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
    StoredProcName = 'gpSelect_Movement_Check_CashRegister'
    Params = <
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
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
      end>
    Left = 336
    Top = 216
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
end
