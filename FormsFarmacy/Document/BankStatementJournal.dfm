inherited BankStatementJournalForm: TBankStatementJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1041#1072#1085#1082#1086#1074#1089#1082#1080#1077' '#1074#1099#1087#1080#1089#1082#1080'>'
  ClientWidth = 873
  ExplicitWidth = 881
  ExplicitHeight = 702
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 873
    TabOrder = 3
    ExplicitWidth = 873
    ClientRectRight = 873
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 873
      inherited cxGrid: TcxGrid
        Width = 873
        ExplicitWidth = 873
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          inherited colStatus: TcxGridDBColumn
            Options.Editing = False
            Width = 95
          end
          inherited colInvNumber: TcxGridDBColumn
            Options.Editing = False
            Width = 135
          end
          inherited colOperDate: TcxGridDBColumn
            Options.Editing = False
            Width = 126
          end
          object colBankName: TcxGridDBColumn
            Caption = #1041#1072#1085#1082
            DataBinding.FieldName = 'BankName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 175
          end
          object colBankAccount: TcxGridDBColumn
            Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090
            DataBinding.FieldName = 'BankAccountName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 172
          end
          object colDebet: TcxGridDBColumn
            Caption = #1044#1077#1073#1077#1090
            HeaderAlignmentVert = vaCenter
          end
          object colKredit: TcxGridDBColumn
            Caption = #1050#1088#1077#1076#1080#1090
            HeaderAlignmentVert = vaCenter
          end
          object colAmount: TcxGridDBColumn
            Caption = #1054#1073#1086#1088#1086#1090' '#1087#1086' '#1089#1095#1077#1090#1091
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 873
    ExplicitWidth = 873
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = BankFidoLoad
        Properties.Strings = (
          'InitializeDirectory')
      end
      item
        Component = BankUkrEximLoad
        Properties.Strings = (
          'InitializeDirectory')
      end
      item
        Component = BankPrivatLoad
        Properties.Strings = (
          'InitializeDirectory')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Top'
          'Width')
      end
      item
        Component = BankVostokLoad
        Properties.Strings = (
          'InitializeDirectory')
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
      FormName = 'TBankStatementForm'
    end
    object BankMarfinLoad: TClientBankLoadAction [4]
      Category = 'Load'
      MoveParams = <>
      ClientBankType = cbMarfinBank
      StartDateParam.Value = 41640d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      EndDateParam.Value = 41640d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
    end
    object BankMarfin: TMultiAction [5]
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = BankMarfinLoad
        end
        item
          Action = actRefresh
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1052#1072#1088#1092#1080#1085' '#1041#1072#1085#1082#1072
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1052#1072#1088#1092#1080#1085' '#1041#1072#1085#1082#1072
      ImageIndex = 71
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TBankStatementForm'
    end
    inherited actSetErased: TdsdChangeMovementStatus
      QuestionBeforeExecute = #1042#1099' '#1091#1074#1077#1088#1077#1085#1099' '#1074' '#1091#1076#1072#1083#1077#1085#1080#1080' '#1076#1086#1082#1091#1084#1077#1085#1090#1072'? '
    end
    object BankPrivatLoad: TClientBankLoadAction
      Category = 'Load'
      MoveParams = <>
      ClientBankType = cbPrivatBank
      StartDateParam.Value = 41640d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      EndDateParam.Value = 41640d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
    end
    object BankUkrEximLoad: TClientBankLoadAction
      Category = 'Load'
      MoveParams = <>
      ClientBankType = cbUrkExim
      StartDateParam.Value = 41640d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      EndDateParam.Value = 41640d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
    end
    object BankPireusLoad: TClientBankLoadAction
      Category = 'Load'
      MoveParams = <>
      ClientBankType = cbPireusBank
      StartDateParam.Value = 41640d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      EndDateParam.Value = 41640d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
    end
    object BankOTPLoad: TClientBankLoadAction
      Category = 'Load'
      MoveParams = <>
      ClientBankType = cbOTPBank
      StartDateParam.Value = 41640d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      EndDateParam.Value = 41640d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
    end
    object BankPireusDBFLoad: TClientBankLoadAction
      Category = 'Load'
      MoveParams = <>
      ClientBankType = cbPireusBankDBF
      StartDateParam.Value = 41640d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      EndDateParam.Value = 41640d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
    end
    object BankPireusDBF: TMultiAction
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = BankPireusDBFLoad
        end
        item
          Action = actRefresh
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1055#1080#1088#1077#1091#1089' '#1073#1072#1085#1082#1072' (dbf)'
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1055#1080#1088#1077#1091#1089' '#1073#1072#1085#1082#1072' (dbf)'
      ImageIndex = 70
    end
    object BankPireus: TMultiAction
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = BankPireusLoad
        end
        item
          Action = actRefresh
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1055#1080#1088#1077#1091#1089' '#1073#1072#1085#1082#1072' '
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1055#1080#1088#1077#1091#1089' '#1073#1072#1085#1082#1072' '
      ImageIndex = 70
    end
    object BankOTP: TMultiAction
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = BankOTPLoad
        end
        item
          Action = actRefresh
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1054#1058#1055' '#1073#1072#1085#1082#1072' '
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1054#1058#1055' '#1073#1072#1085#1082#1072' '
      ImageIndex = 69
    end
    object BankVostokLoad: TClientBankLoadAction
      Category = 'Load'
      MoveParams = <>
      ClientBankType = cbVostok
      StartDateParam.Value = 41640d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      EndDateParam.Value = 41640d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
    end
    object BankFidoLoad: TClientBankLoadAction
      Category = 'Load'
      MoveParams = <>
      ClientBankType = cbFidoBank
      StartDateParam.Value = 41640d
      StartDateParam.Component = deStart
      StartDateParam.DataType = ftDateTime
      EndDateParam.Value = 41640d
      EndDateParam.Component = deEnd
      EndDateParam.DataType = ftDateTime
    end
    object BankPrivat: TMultiAction
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = BankPrivatLoad
        end
        item
          Action = actRefresh
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1055#1088#1080#1074#1072#1090'-'#1041#1072#1085#1082#1072
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1055#1088#1080#1074#1072#1090'-'#1041#1072#1085#1082#1072
      ImageIndex = 47
    end
    object BankUkrExim: TMultiAction
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = BankUkrEximLoad
        end
        item
          Action = actRefresh
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1073#1072#1085#1082#1072' '#1059#1082#1088#1069#1082#1089#1080#1084
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1073#1072#1085#1082#1072' '#1059#1082#1088#1069#1082#1089#1080#1084
      ImageIndex = 48
    end
    object BankVostok: TMultiAction
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = BankVostokLoad
        end
        item
          Action = actRefresh
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1073#1072#1085#1082#1072' '#1042#1086#1089#1090#1086#1082
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1073#1072#1085#1082#1072' '#1042#1086#1089#1090#1086#1082
      ImageIndex = 49
    end
    object BankFido: TMultiAction
      Category = 'Load'
      MoveParams = <>
      ActionList = <
        item
          Action = BankFidoLoad
        end
        item
          Action = actRefresh
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1060#1080#1076#1086#1073#1072#1085#1082#1072
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1060#1080#1076#1086#1073#1072#1085#1082#1072
      ImageIndex = 68
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_BankStatement'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbDelete'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbBankPrivat'
        end
        item
          Visible = True
          ItemName = 'bbBankForum'
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
    inherited bbInsert: TdxBarButton
      Enabled = False
    end
    inherited bbEdit: TdxBarButton
      Enabled = False
    end
    inherited bbComplete: TdxBarButton
      Action = nil
    end
    inherited bbUnComplete: TdxBarButton
      Action = nil
    end
    object bbBankPrivat: TdxBarButton
      Action = BankPrivat
      Category = 0
    end
    object bbBankVostok: TdxBarButton
      Action = BankVostok
      Category = 0
    end
    object bbBankForum: TdxBarButton
      Action = BankUkrExim
      Category = 0
    end
    object bbBankErnst: TdxBarButton
      Action = BankFido
      Category = 0
    end
    object bbOTPLoad: TdxBarButton
      Action = BankOTP
      Category = 0
    end
    object bbPireus: TdxBarButton
      Action = BankPireus
      Category = 0
    end
    object bbPireusDBFLoad: TdxBarButton
      Action = BankPireusDBF
      Category = 0
    end
    object bbMarfinLoad: TdxBarButton
      Action = BankMarfin
      Category = 0
    end
  end
  inherited PopupMenu: TPopupMenu
    inherited N3: TMenuItem
      Visible = False
    end
    inherited N2: TMenuItem
      Visible = False
    end
    inherited N4: TMenuItem
      Visible = False
    end
    inherited N5: TMenuItem
      Visible = False
    end
    inherited N7: TMenuItem
      Visible = False
    end
    inherited N9: TMenuItem
      Visible = False
    end
    inherited N10: TMenuItem
      Visible = False
    end
    inherited N11: TMenuItem
      Visible = False
    end
    inherited N12: TMenuItem
      Visible = False
    end
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_BankStatement'
  end
end
