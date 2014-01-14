inherited BankStatementJournalForm: TBankStatementJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1073#1072#1085#1082#1086#1074#1089#1082#1080#1093' '#1074#1099#1087#1080#1089#1086#1082
  ClientWidth = 843
  ExplicitWidth = 851
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 843
    TabOrder = 3
    ClientRectRight = 843
    inherited tsMain: TcxTabSheet
      inherited cxGrid: TcxGrid
        Width = 843
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colStatus: TcxGridDBColumn
            Visible = False
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
    Top = 0
    Width = 843
    ExplicitTop = 0
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = BankFidoLoad
        Properties.Strings = (
          'InitializeDirectory')
      end
      item
        Component = BankForumLoad
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
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TBankStatementForm'
    end
    object BankPrivatLoad: TClientBankLoadAction
      Category = 'DSDLib'
      ClientBankType = cbPrivatBank
    end
    object BankForumLoad: TClientBankLoadAction
      Category = 'DSDLib'
      ClientBankType = cbForum
    end
    object BankOTPLoad: TClientBankLoadAction
      Category = 'DSDLib'
      ClientBankType = cbOTPBank
    end
    object BankOTP: TMultiAction
      Category = 'DSDLib'
      ActionList = <
        item
          Action = BankOTPLoad
        end
        item
          Action = actRefresh
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1054#1058#1055' '#1073#1072#1085#1082#1072' '
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1054#1058#1055' '#1073#1072#1085#1082#1072' '
      ImageIndex = 50
    end
    object BankVostokLoad: TClientBankLoadAction
      Category = 'DSDLib'
      ClientBankType = cbVostok
    end
    object BankFidoLoad: TClientBankLoadAction
      Category = 'DSDLib'
      ClientBankType = cbFidoBank
    end
    object BankPrivat: TMultiAction
      Category = 'DSDLib'
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
    object BankForum: TMultiAction
      Category = 'DSDLib'
      ActionList = <
        item
          Action = BankForumLoad
        end
        item
          Action = actRefresh
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1073#1072#1085#1082#1072' '#1060#1086#1088#1091#1084
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1073#1072#1085#1082#1072' '#1060#1086#1088#1091#1084
      ImageIndex = 48
    end
    object BankVostok: TMultiAction
      Category = 'DSDLib'
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
      Category = 'DSDLib'
      ActionList = <
        item
          Action = BankFidoLoad
        end
        item
          Action = actRefresh
        end>
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1060#1080#1076#1086#1073#1072#1085#1082#1072
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1060#1080#1076#1086#1073#1072#1085#1082#1072
      ImageIndex = 50
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
          ItemName = 'bbInsert'
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
          ItemName = 'bbBankPrivat'
        end
        item
          Visible = True
          ItemName = 'bbBankForum'
        end
        item
          Visible = True
          ItemName = 'bbBankVostok'
        end
        item
          Visible = True
          ItemName = 'bbBankErnst'
        end
        item
          Visible = True
          ItemName = 'bbOTPLoad'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end>
    end
    inherited bbComplete: TdxBarButton
      Action = nil
    end
    inherited bbUnComplete: TdxBarButton
      Action = nil
    end
    inherited bbDelete: TdxBarButton
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
      Action = BankForum
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
  end
end
