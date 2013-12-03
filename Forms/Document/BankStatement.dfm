inherited BankStatementForm: TBankStatementForm
  Caption = #1042#1099#1087#1080#1089#1082#1080' '#1073#1072#1085#1082#1072
  ClientHeight = 416
  ClientWidth = 935
  AddOnFormData.isSingle = False
  AddOnFormData.Params = FormParams
  ExplicitLeft = -98
  ExplicitTop = -24
  ExplicitWidth = 943
  ExplicitHeight = 443
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 75
    Width = 935
    Height = 341
    ExplicitTop = 75
    ExplicitWidth = 935
    ExplicitHeight = 341
    ClientRectBottom = 341
    ClientRectRight = 935
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 935
      ExplicitHeight = 341
      inherited cxGrid: TcxGrid
        Width = 935
        Height = 341
        ExplicitWidth = 935
        ExplicitHeight = 341
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsView.CellAutoHeight = True
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colDocNumber: TcxGridDBColumn
            Caption = #8470' '#1087#1083#1072#1090#1077#1078#1082#1080
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 76
          end
          object colJuridicalName: TcxGridDBColumn
            Caption = #1070#1088' '#1083#1080#1094#1086' '#1080#1079' '#1074#1099#1087#1080#1089#1082#1080
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 89
          end
          object colOKPO: TcxGridDBColumn
            Caption = #1054#1050#1055#1054
            DataBinding.FieldName = 'OKPO'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 59
          end
          object colDebet: TcxGridDBColumn
            Caption = #1044#1077#1073#1077#1090
            DataBinding.FieldName = 'Debet'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 68
          end
          object colCredit: TcxGridDBColumn
            Caption = #1050#1088#1077#1076#1080#1090
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 57
          end
          object colLinkJuridicalName: TcxGridDBColumn
            Caption = #1070#1088' '#1083#1080#1094#1086' '#1074' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object colContract: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088
            DataBinding.FieldName = 'ContractNumber'
            HeaderAlignmentVert = vaCenter
            Width = 57
          end
          object colInfoMoney: TcxGridDBColumn
            Caption = #1059#1087#1088#1072#1074#1083#1077#1085#1095#1077#1089#1082#1072#1103' '#1089#1090#1072#1090#1100#1103
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 96
          end
          object colUnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 114
          end
          object colComment: TcxGridDBColumn
            Caption = #1050#1086#1084#1084#1077#1085#1090#1072#1088#1080#1081
            DataBinding.FieldName = 'Comment'
            PropertiesClassName = 'TcxMemoProperties'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 205
          end
        end
      end
    end
  end
  object Panel: TPanel [1]
    Left = 0
    Top = 0
    Width = 935
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
  inherited ActionList: TActionList
    inherited actRefresh: TdsdDataSetRefresh
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spSelect
        end>
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
