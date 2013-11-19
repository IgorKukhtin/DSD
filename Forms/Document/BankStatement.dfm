inherited BankStatementForm: TBankStatementForm
  Caption = #1042#1099#1087#1080#1089#1082#1080' '#1073#1072#1085#1082#1072
  ClientHeight = 416
  ClientWidth = 636
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  ExplicitWidth = 644
  ExplicitHeight = 443
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 75
    Width = 636
    Height = 341
    ExplicitLeft = -1
    ExplicitTop = 83
    ClientRectBottom = 341
    ClientRectRight = 636
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 575
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Width = 636
        Height = 341
        ExplicitLeft = 16
        ExplicitTop = 80
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colDocNumber: TcxGridDBColumn
            Caption = #8470' '#1087#1083#1072#1090#1077#1078#1082#1080
            DataBinding.FieldName = 'InvNumber'
            Options.Editing = False
          end
          object colOKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO'
            Options.Editing = False
          end
          object colAmount: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
            Options.Editing = False
          end
          object cxGridDBTableViewColumn4: TcxGridDBColumn
            Options.Editing = False
          end
          object cxGridDBTableViewColumn5: TcxGridDBColumn
            Options.Editing = False
          end
          object cxGridDBTableViewColumn6: TcxGridDBColumn
            Options.Editing = False
          end
        end
      end
    end
  end
  object Panel: TPanel [1]
    Left = 0
    Top = 0
    Width = 636
    Height = 49
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 5
    object cxLabel1: TcxLabel
      Left = 8
      Top = 5
      Caption = #8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
    end
    object edInvNumber: TcxTextEdit
      Left = 8
      Top = 20
      Enabled = False
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 95
    end
    object cxLabel2: TcxLabel
      Left = 112
      Top = 5
      Caption = #1044#1072#1090#1072
    end
    object edOperDate: TcxDateEdit
      Left = 112
      Top = 20
      Enabled = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 3
      Width = 108
    end
    object cxLabel3: TcxLabel
      Left = 227
      Top = 5
      Caption = #1041#1072#1085#1082
    end
    object cxLabel4: TcxLabel
      Left = 374
      Top = 5
      Caption = #1057#1095#1077#1090
    end
    object edBankName: TcxTextEdit
      Left = 227
      Top = 20
      Enabled = False
      Properties.ReadOnly = True
      TabOrder = 6
      Width = 142
    end
    object edBankAccount: TcxTextEdit
      Left = 375
      Top = 20
      Enabled = False
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 160
    end
  end
  inherited MasterDS: TDataSource
    Left = 56
    Top = 104
  end
  inherited MasterCDS: TClientDataSet
    Left = 24
    Top = 96
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_BankStatementItem'
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Top = 112
  end
  inherited BarManager: TdxBarManager
    Left = 104
    Top = 120
    DockControlHeights = (
      0
      0
      26
      0)
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInput
      end>
    Left = 112
    Top = 264
  end
  object spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_BankStatement'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end
      item
        Name = 'invnumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
      end
      item
        Name = 'operdate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
      end
      item
        Name = 'bankaccountname'
        Value = ''
        Component = edBankAccount
        DataType = ftString
      end
      item
        Name = 'bankname'
        Value = ''
        Component = edBankName
        DataType = ftString
      end>
    Left = 248
    Top = 40
  end
end
