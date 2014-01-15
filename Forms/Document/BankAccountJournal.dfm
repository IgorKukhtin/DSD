inherited BankAccountJournalForm: TBankAccountJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1086#1087#1077#1088#1072#1094#1080#1081' '#1089' '#1088'\'#1089
  ClientHeight = 377
  ClientWidth = 1056
  ExplicitWidth = 1064
  ExplicitHeight = 404
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 1056
    Height = 320
    TabOrder = 3
    ExplicitWidth = 1056
    ExplicitHeight = 320
    ClientRectBottom = 320
    ClientRectRight = 1056
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1056
      ExplicitHeight = 320
      inherited cxGrid: TcxGrid
        Width = 1056
        Height = 320
        ExplicitWidth = 1056
        ExplicitHeight = 320
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Position = spFooter
              Column = colDebet
            end
            item
              Format = ',0.00'
              Kind = skSum
              Position = spFooter
              Column = colKredit
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = colDebet
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colKredit
            end>
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
            Width = 87
          end
          inherited colOperDate: TcxGridDBColumn
            Options.Editing = False
            Width = 66
          end
          object colBankAccount: TcxGridDBColumn
            Caption = #1056#1072#1089#1095#1077#1090#1085#1099#1081' '#1089#1095#1077#1090
            DataBinding.FieldName = 'BankAccountName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 139
          end
          object colBankName: TcxGridDBColumn
            Caption = #1041#1072#1085#1082
            DataBinding.FieldName = 'BankName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 149
          end
          object colDebet: TcxGridDBColumn
            Caption = #1044#1077#1073#1077#1090
            DataBinding.FieldName = 'AmountIn'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object colKredit: TcxGridDBColumn
            Caption = #1050#1088#1077#1076#1080#1090
            DataBinding.FieldName = 'AmountOut'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00'
            HeaderAlignmentHorz = taRightJustify
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 64
          end
          object colJuridical: TcxGridDBColumn
            Caption = #1054#1073#1098#1077#1082#1090
            DataBinding.FieldName = 'MoneyPlaceName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 103
          end
          object colContract: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088
            DataBinding.FieldName = 'ContractInvNumber'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object colInfoMoney: TcxGridDBColumn
            Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1072#1103' '#1089#1090#1072#1090#1100#1103
            DataBinding.FieldName = 'InfoMoneyName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 110
          end
          object colUnit: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 101
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1056
    ExplicitWidth = 1056
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
      FormName = 'TBankAccountMovementForm'
    end
    inherited actUpdate: TdsdInsertUpdateAction
      FormName = 'TBankAccountMovementForm'
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_BankAccount'
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
    inherited bbComplete: TdxBarButton
      Action = nil
    end
    inherited bbUnComplete: TdxBarButton
      Action = nil
    end
    inherited bbDelete: TdxBarButton
      Action = nil
    end
  end
end
