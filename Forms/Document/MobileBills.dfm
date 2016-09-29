inherited MobileBillsForm: TMobileBillsForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1047#1072#1090#1088#1072#1090#1099' '#1085#1072' '#1084#1086#1073#1080#1083#1100#1085#1091#1102' '#1089#1074#1103#1079#1100'>'
  ClientHeight = 617
  ClientWidth = 861
  ExplicitWidth = 877
  ExplicitHeight = 655
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 76
    Width = 861
    Height = 541
    ExplicitTop = 76
    ExplicitWidth = 861
    ExplicitHeight = 541
    ClientRectBottom = 541
    ClientRectRight = 861
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 861
      ExplicitHeight = 517
      inherited cxGrid: TcxGrid
        Width = 861
        Height = 517
        ExplicitWidth = 861
        ExplicitHeight = 517
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount
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
              Column = colCurrMonthly
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
              Column = colCurrNavigator
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colPrevNavigator
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colMobileLimit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colPrevLimit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colDutyLimit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colOverlimit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colPrevMonthly
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colCurrMonthly
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colCurrNavigator
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colPrevNavigator
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colMobileLimit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colPrevLimit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colDutyLimit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colOverlimit
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = colPrevMonthly
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = colMobileEmployeeName
            end>
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupSummaryLayout = gslStandard
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colMobileEmployeeCode: TcxGridDBColumn [0]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'MobileEmployeeCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object colMobileEmployeeName: TcxGridDBColumn [1]
            Caption = #1053#1086#1084#1077#1088' '#1090#1077#1083#1077#1092#1086#1085#1072
            DataBinding.FieldName = 'MobileEmployeeName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actMobileEmployeeChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object colAmount: TcxGridDBColumn [2]
            Caption = #1057#1091#1084#1084#1072' '#1080#1090#1086#1075#1086' '
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 85
          end
          object colCurrMonthly: TcxGridDBColumn [3]
            Caption = #1040#1073#1086#1085#1087#1083#1072#1090#1072
            DataBinding.FieldName = 'CurrMonthly'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 92
          end
          object colCurrNavigator: TcxGridDBColumn [4]
            Caption = #1053#1072#1074#1080#1075#1072#1090#1086#1088
            DataBinding.FieldName = 'CurrNavigator'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object colPrevNavigator: TcxGridDBColumn [5]
            Caption = #1055#1088#1077#1076'. '#1085#1072#1074#1080#1075#1072#1090#1086#1088
            DataBinding.FieldName = 'PrevNavigator'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1099#1076#1091#1097#1077#1077' '#1089#1086#1089#1090#1086#1103#1085#1080#1077' '#1091#1089#1083#1091#1075#1080' '#1053#1072#1074#1080#1075#1072#1090#1086#1088
            Options.Editing = False
            Width = 95
          end
          object colMobileLimit: TcxGridDBColumn [6]
            Caption = #1051#1080#1084#1080#1090
            DataBinding.FieldName = 'MobileLimit'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1058#1077#1082#1091#1097#1080#1081' '#1083#1080#1084#1080#1090
            Options.Editing = False
            Width = 70
          end
          object colPrevLimit: TcxGridDBColumn [7]
            Caption = #1055#1088#1077#1076'. '#1083#1080#1084#1080#1090
            DataBinding.FieldName = 'PrevLimit'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1099#1076#1091#1097#1080#1081' '#1083#1080#1084#1080#1090
            Options.Editing = False
            Width = 70
          end
          object colDutyLimit: TcxGridDBColumn [8]
            Caption = #1057#1083#1091#1078#1077#1073#1085#1099#1081' '#1083#1080#1084#1080#1090
            DataBinding.FieldName = 'DutyLimit'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object colOverlimit: TcxGridDBColumn [9]
            Caption = #1055#1077#1088#1077#1083#1080#1084#1080#1090
            DataBinding.FieldName = 'Overlimit'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colPrevMonthly: TcxGridDBColumn [10]
            Caption = #1055#1088#1077#1076'.'#1072#1073#1086#1087#1083#1072#1090#1072
            DataBinding.FieldName = 'PrevMonthly'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1040#1073#1086#1085#1087#1083#1072#1090#1072' '#1079#1072' '#1087#1088#1077#1076#1099#1076#1091#1097#1080#1081' '#1087#1077#1088#1080#1086#1076
            Options.Editing = False
            Width = 86
          end
          object colRegionName: TcxGridDBColumn [11]
            Caption = #1056#1077#1075#1080#1086#1085
            DataBinding.FieldName = 'RegionName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actRegionChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object colEmployeeName: TcxGridDBColumn [12]
            Caption = #1057#1086#1090#1088#1091#1076#1085#1080#1082
            DataBinding.FieldName = 'EmployeeName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 104
          end
          object colPrevEmployeeName: TcxGridDBColumn [13]
            Caption = #1055#1088#1077#1076'. '#1089#1086#1090#1088#1091#1076#1085#1080#1082
            DataBinding.FieldName = 'PrevEmployeeName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actPersonalChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1099#1076#1091#1097#1080#1081' '#1089#1086#1090#1088#1091#1076#1085#1080#1082
            Width = 90
          end
          object colMobileTariffName: TcxGridDBColumn [14]
            Caption = #1058#1077#1082#1091#1097#1080#1081' '#1090#1072#1088#1080#1092#1085#1099#1081' '#1087#1083#1072#1085
            DataBinding.FieldName = 'MobileTariffName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 81
          end
          object colPrevMobileTariffName: TcxGridDBColumn [15]
            Caption = #1055#1088#1077#1076'. '#1090#1072#1088#1080#1092#1085#1099#1081' '#1087#1083#1072#1085
            DataBinding.FieldName = 'PrevMobileTariffName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actMobileTariffChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1055#1088#1077#1076#1099#1076#1091#1097#1080#1081' '#1090#1072#1088#1080#1092#1085#1099#1081' '#1087#1083#1072#1085
            Width = 78
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 861
    Height = 50
    TabOrder = 3
    ExplicitWidth = 861
    ExplicitHeight = 50
    inherited edInvNumber: TcxTextEdit
      Left = 232
      ExplicitLeft = 232
      ExplicitWidth = 87
      Width = 87
    end
    inherited cxLabel1: TcxLabel
      Left = 232
      ExplicitLeft = 232
    end
    inherited edOperDate: TcxDateEdit
      Left = 324
      EditValue = 42614d
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 324
    end
    inherited cxLabel2: TcxLabel
      Left = 324
      ExplicitLeft = 324
    end
    inherited ceStatus: TcxButtonEdit
      ExplicitWidth = 218
      ExplicitHeight = 22
      Width = 218
    end
  end
  object edIsAuto: TcxCheckBox [2]
    Left = 437
    Top = 23
    Caption = #1057#1086#1079#1076#1072#1085' '#1072#1074#1090#1086#1084#1072#1090#1080#1095#1077#1089#1082#1080' ('#1076#1072'/'#1085#1077#1090')'
    Properties.ReadOnly = True
    TabOrder = 6
    Visible = False
    Width = 187
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 219
    Top = 448
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 40
    Top = 640
  end
  inherited ActionList: TActionList
    Left = 55
    Top = 303
    inherited actRefresh: TdsdDataSetRefresh
      RefreshOnTabSetChanges = True
    end
    inherited actPrint: TdsdPrintAction
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_MobileBills'
      ReportNameParam.Value = 'PrintMovement_MobileBills'
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    object actRegionChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'RegionForm'
      FormName = 'TRegionForm'
      FormNameParam.Value = 'TRegionForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RegionId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'RegionName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actPersonalChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'UnitForm'
      FormName = 'TPersonal_ObjectForm'
      FormNameParam.Value = 'TPersonal_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PrevEmployeeId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PrevEmployeeName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actMobileTariffChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'MobileTariff2Form'
      FormName = 'TMobileTariff2Form'
      FormNameParam.Value = 'TMobileTariff2Form'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PrevMobileTariffId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PrevMobileTariffName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Monthly'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'PrevMonthly'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actMobileEmployeeChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsForm'
      FormName = 'TMobileEmployee2Form'
      FormNameParam.Value = 'TMobileEmployee2Form'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MobileEmployeeId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MobileEmployeeName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MobileEmployeeCode'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MobileTariffId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MobileTariffId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'MobileTariffName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MobileTariffName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'EmployeeId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PersonalName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'EmployeeName'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'MobileLimit'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MobileLimit'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'DutyLimit'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'DutyLimit'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end
        item
          Name = 'Navigator'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'CurrNavigator'
          DataType = ftFloat
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actInsertRecord: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = actMobileEmployeeChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1069#1083#1077#1084#1077#1085#1090'>'
      ShortCut = 45
      ImageIndex = 0
    end
  end
  inherited MasterDS: TDataSource
    Left = 32
    Top = 512
  end
  inherited MasterCDS: TClientDataSet
    Left = 88
    Top = 512
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_MobileBills'
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
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Value = ''
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = False
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 248
  end
  inherited BarManager: TdxBarManager
    Left = 80
    Top = 207
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
          ItemName = 'bbInsertRecord'
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
          ItemName = 'bbStatic'
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
          ItemName = 'bbMovementItemContainer'
        end
        item
          Visible = True
          ItemName = 'bbStatic'
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
    object bbInsertRecord: TdxBarButton
      Action = actInsertRecord
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    Left = 750
    Top = 225
  end
  inherited PopupMenu: TPopupMenu
    Left = 800
    Top = 464
    object N2: TMenuItem
      Action = actMISetErased
    end
    object N3: TMenuItem
      Action = actMISetUnErased
    end
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
        Name = 'ReportNameSend'
        Value = 'PrintMovement_Sale1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSendTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSendBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 344
    Top = 496
  end
  inherited StatusGuides: TdsdGuides
    Left = 48
    Top = 8
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_MobileBills'
    Left = 104
    Top = 8
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_MobileBills'
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
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 'NULL'
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 248
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_MobileBills'
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
        Value = 42614d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 162
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    Left = 160
    Top = 192
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edOperDate
      end>
    Left = 232
    Top = 193
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 912
    Top = 320
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_MobileBills_SetErased'
    Left = 606
    Top = 464
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_MobileBills_SetUnErased'
    Left = 718
    Top = 464
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_MobileBills'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
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
        Name = 'inMobileEmployeeId'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'MobileEmployeeId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmount'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCurrMonthly'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'CurrMonthly'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrNavigator'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'CurrNavigator'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrevNavigator'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'PrevNavigator'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLimit'
        Value = 0
        Component = MasterCDS
        ComponentItem = 'MobileLimit'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrevLimit'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'PrevLimit'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDutyLimit'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'DutyLimit'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOverlimit'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Overlimit'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrevMonthly'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'PrevMonthly'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRegionId'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'RegionId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEmployeeId'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'EmployeeId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrevEmployeeId'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'PrevEmployeeId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMobileTariffId'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'MobileTariffId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrevMobileTariffId'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'PrevMobileTariffId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 368
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_MobileBills'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
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
        Name = 'inMobileEmployeeId'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'MobileEmployeeId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioAmount'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCurrMonthly'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'CurrMonthly'
        DataType = ftFloat
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrNavigator'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'CurrNavigator'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrevNavigator'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'PrevNavigator'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inLimit'
        Value = 0
        Component = MasterCDS
        ComponentItem = 'MobileLimit'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrevLimit'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'PrevLimit'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDutyLimit'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'DutyLimit'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOverlimit'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'Overlimit'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrevMonthly'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'PrevMonthly'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRegionId'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'RegionId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEmployeeId'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'EmployeeId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrevEmployeeId'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'PrevEmployeeId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMobileTariffId'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'MobileTariffId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrevMobileTariffId'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'PrevMobileTariffId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 272
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Left = 420
    Top = 188
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    ComponentList = <
      item
      end>
    Left = 512
    Top = 328
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 508
    Top = 193
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 508
    Top = 246
  end
  object PrintItemsSverkaCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 644
    Top = 334
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_MobileBills_Print'
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
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId_Weighing'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 367
    Top = 376
  end
end
