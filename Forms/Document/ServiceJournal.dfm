inherited ServiceJournalForm: TServiceJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1053#1072#1095#1080#1089#1083#1077#1085#1080#1077' '#1091#1089#1083#1091#1075'>'
  ClientHeight = 649
  ClientWidth = 1151
  ExplicitWidth = 1167
  ExplicitHeight = 684
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1151
    Height = 592
    TabOrder = 3
    ExplicitWidth = 1151
    ExplicitHeight = 592
    ClientRectBottom = 592
    ClientRectRight = 1151
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1151
      ExplicitHeight = 592
      inherited cxGrid: TcxGrid
        Width = 1151
        Height = 592
        ExplicitWidth = 1151
        ExplicitHeight = 592
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = clAmountIn
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colAmountOut
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = clAmountIn
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colAmountOut
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colStatus: TcxGridDBColumn
            Options.Editing = False
            Width = 88
          end
          inherited colInvNumber: TcxGridDBColumn
            Visible = False
            Options.Editing = False
            Width = 55
          end
          inherited colOperDate: TcxGridDBColumn
            Options.Editing = False
            Width = 75
          end
          object clAmountIn: TcxGridDBColumn
            Caption = #1044#1077#1073#1077#1090
            DataBinding.FieldName = 'AmountIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object colAmountOut: TcxGridDBColumn
            Caption = #1050#1088#1077#1076#1080#1090
            DataBinding.FieldName = 'AmountOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Width = 77
          end
          object clJuridicalCode: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1102#1088'.'#1083'.)'
            DataBinding.FieldName = 'JuridicalCode'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object clJuridicalName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object clPaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object clInfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            HeaderAlignmentVert = vaCenter
            Width = 57
          end
          object clInfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            HeaderAlignmentVert = vaCenter
            Width = 99
          end
          object clInfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object clInfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
          object clUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 112
          end
          object clContractInvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractInvNumber'
            HeaderAlignmentVert = vaCenter
            Width = 58
          end
          object clOperDatePartner: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1072#1082#1090#1072'('#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072')'
            DataBinding.FieldName = 'OperDatePartner'
            HeaderAlignmentVert = vaCenter
            Width = 73
          end
          object clInvNumberPartner: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1088' '#1072#1082#1090#1072' ('#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072')'
            DataBinding.FieldName = 'InvNumberPartner'
            HeaderAlignmentVert = vaCenter
            Width = 84
          end
          object clComment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentVert = vaCenter
            Width = 81
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1151
    ExplicitWidth = 1151
  end
  inherited ActionList: TActionList
    inherited actInsert: TdsdInsertUpdateAction
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      FormName = 'TServiceForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
        end
        item
          Name = 'inMovementId_Value'
          Value = Null
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end>
    end
    inherited actInsertMask: TdsdInsertUpdateAction
      FormName = 'TServiceForm'
      FormNameParam.Value = 'TServiceForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
        end
        item
          Name = 'inMovementId_Value'
          Component = MasterCDS
          ComponentItem = 'Id'
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end>
    end
    inherited actUpdate: TdsdInsertUpdateAction
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100
      FormName = 'TServiceForm'
      GuiParams = <
        item
          Name = 'Id'
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
        end
        item
          Name = 'inMovementId_Value'
          Component = MasterCDS
          ComponentItem = 'Id'
        end
        item
          Name = 'inOperDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
        end>
    end
    object actReCompleteAll: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spMovementReCompleteAll
      StoredProcList = <
        item
          StoredProc = spMovementReCompleteAll
        end>
      Caption = #1055#1077#1088#1077#1087#1088#1086#1074#1077#1089#1090#1080' '#1074#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      Hint = #1055#1077#1088#1077#1087#1088#1086#1074#1077#1089#1090#1080' '#1074#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1079#1072' '#1087#1077#1088#1080#1086#1076
      ImageIndex = 10
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1087#1077#1088#1077#1087#1088#1086#1074#1077#1089#1090#1080' '#1074#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1079#1072' '#1087#1077#1088#1080#1086#1076'?'
      InfoAfterExecute = #1042#1089#1077' '#1076#1086#1082#1091#1084#1077#1085#1090#1099' '#1079#1072' '#1087#1077#1088#1080#1086#1076' '#1087#1077#1088#1077#1087#1088#1086#1074#1077#1076#1077#1085#1099'.'
    end
  end
  inherited MasterDS: TDataSource
    Left = 56
    Top = 96
  end
  inherited MasterCDS: TClientDataSet
    Left = 24
    Top = 104
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_Service'
    Left = 96
    Top = 96
  end
  inherited BarManager: TdxBarManager
    Left = 160
    Top = 128
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
          Visible = True
          ItemName = 'bbReCompleteAll'
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
    object bbReCompleteAll: TdxBarButton
      Action = actReCompleteAll
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 472
    Top = 248
  end
  inherited PopupMenu: TPopupMenu
    object N13: TMenuItem [1]
    end
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 200
    Top = 120
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_Service'
    Left = 16
    Top = 152
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_Service'
    Top = 160
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_Service'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Left = 80
    Top = 176
  end
  object spMovementReCompleteAll: TdsdStoredProc
    StoredProcName = 'gpCompletePeriod_Movement_Service'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndtDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end>
    Left = 272
    Top = 224
  end
end
