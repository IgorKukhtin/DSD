inherited CurrencyJournalForm: TCurrencyJournalForm
  Caption = #1046#1091#1088#1085#1072#1083' '#1076#1086#1082#1091#1084#1077#1085#1090#1086#1074' <'#1050#1091#1088#1089#1086#1074#1072#1103' '#1088#1072#1079#1085#1080#1094#1072'>'
  ClientHeight = 649
  ClientWidth = 910
  ExplicitWidth = 926
  ExplicitHeight = 684
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 910
    Height = 592
    TabOrder = 3
    ExplicitWidth = 894
    ExplicitHeight = 592
    ClientRectBottom = 592
    ClientRectRight = 910
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 894
      ExplicitHeight = 592
      inherited cxGrid: TcxGrid
        Width = 910
        Height = 592
        ExplicitWidth = 894
        ExplicitHeight = 592
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.Footer = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          inherited colStatus: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 88
          end
          inherited colInvNumber: TcxGridDBColumn
            Visible = False
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 55
          end
          inherited colOperDate: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            Options.Editing = False
            Width = 75
          end
          object clPaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object clAmount: TcxGridDBColumn
            Caption = #1047#1085#1072#1095#1077#1085#1080#1077' '#1082#1091#1088#1089#1072
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object clCurrencyFromName: TcxGridDBColumn
            Caption = #1042#1072#1083#1102#1090#1072' ('#1079#1085#1072#1095#1077#1085#1080#1077')'
            DataBinding.FieldName = 'CurrencyFromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object clParValue: TcxGridDBColumn
            Caption = #1053#1086#1084#1080#1085#1072#1083' ('#1088#1077#1079#1091#1083#1100#1090#1072#1090')'
            DataBinding.FieldName = 'ParValue'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object clCurrencyToName: TcxGridDBColumn
            Caption = #1042#1072#1083#1102#1090#1072' ('#1088#1077#1079#1091#1083#1100#1090#1072#1090')'
            DataBinding.FieldName = 'CurrencyToName'
            FooterAlignmentHorz = taCenter
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object clComment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 300
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 910
    ExplicitWidth = 894
  end
  inherited ActionList: TActionList
    inherited actInsert: TdsdInsertUpdateAction
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100
      FormName = 'TCurrencyMovementForm'
      FormNameParam.Value = 'TCurrencyMovementForm'
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
      FormName = 'TCurrencyMovementForm'
      FormNameParam.Value = 'TCurrencyMovementForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
        end
        item
          Name = 'inMovementId_Value'
          Value = Null
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
      FormName = 'TCurrencyMovementForm'
      FormNameParam.Value = 'TCurrencyMovementForm'
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          ParamType = ptInput
        end
        item
          Name = 'inMovementId_Value'
          Value = Null
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
    StoredProcName = 'gpSelect_Movement_Currency'
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
    Left = 224
    Top = 168
  end
  inherited spMovementComplete: TdsdStoredProc
    StoredProcName = 'gpComplete_Movement_Currency'
    Left = 16
    Top = 152
  end
  inherited spMovementUnComplete: TdsdStoredProc
    StoredProcName = 'gpUnComplete_Movement_Currency'
    Left = 112
    Top = 168
  end
  inherited spMovementSetErased: TdsdStoredProc
    StoredProcName = 'gpSetErased_Movement_Currency'
    DataSet = MasterCDS
    DataSets = <
      item
        DataSet = MasterCDS
      end>
    Left = 384
    Top = 160
  end
  inherited FormParams: TdsdFormParams
    Left = 384
  end
end
