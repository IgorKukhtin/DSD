inherited Report_JuridicalSoldForm: TReport_JuridicalSoldForm
  Caption = #1054#1073#1088#1086#1090#1082#1072' '#1087#1086' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072#1084
  ClientHeight = 389
  ClientWidth = 861
  ExplicitWidth = 869
  ExplicitHeight = 416
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 861
    Height = 332
    TabOrder = 3
    ExplicitWidth = 861
    ExplicitHeight = 332
    ClientRectBottom = 332
    ClientRectRight = 861
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 861
      ExplicitHeight = 332
      inherited cxGrid: TcxGrid
        Top = 0
        Width = 861
        Height = 332
        ExplicitTop = 0
        ExplicitWidth = 861
        ExplicitHeight = 332
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = colStartAmount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colEndAmount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colSaleSumm
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colServiceSumm
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colMoneySumm
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colOtherSumm
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = colStartAmount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colEndAmount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colSaleSumm
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colServiceSumm
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colMoneySumm
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colOtherSumm
            end>
          OptionsView.GroupByBox = True
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colJuridicalName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colContractNumber: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1088' '#1076#1086#1075#1086#1074#1086#1088#1072
            DataBinding.FieldName = 'ContractNumber'
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colPaidKindName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1086#1087#1083#1072#1090
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colAccountName: TcxGridDBColumn
            Caption = #1057#1095#1077#1090
            DataBinding.FieldName = 'AccountName'
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colInfoMoneyName: TcxGridDBColumn
            Caption = #1059#1087#1088'. '#1089#1090#1072#1090#1100#1103
            DataBinding.FieldName = 'InfoMoneyName'
            Width = 65
          end
          object colInfoMoneyGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1089#1090#1072#1090#1077#1081
            DataBinding.FieldName = 'InfoMoneyGroupName'
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colInfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1053#1072#1087#1088#1072#1074#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colStartAmount: TcxGridDBColumn
            Caption = #1053#1072#1095#1072#1083#1100#1085#1099#1081' '#1086#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'StartAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object colEndAmount: TcxGridDBColumn
            Caption = #1050#1086#1085#1077#1095#1085#1099#1081' '#1086#1089#1090#1072#1090#1086#1082
            DataBinding.FieldName = 'EndAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentVert = vaCenter
            Width = 69
          end
          object colSaleSumm: TcxGridDBColumn
            Caption = #1055#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'SaleSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentVert = vaCenter
            Width = 69
          end
          object colServiceSumm: TcxGridDBColumn
            Caption = #1059#1089#1083#1091#1075#1080
            DataBinding.FieldName = 'ServiceSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentVert = vaCenter
            Width = 68
          end
          object colMoneySumm: TcxGridDBColumn
            Caption = #1054#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'MoneySumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentVert = vaCenter
            Width = 69
          end
          object colOtherSumm: TcxGridDBColumn
            Caption = #1054#1089#1090#1072#1083#1100#1085#1086#1077
            DataBinding.FieldName = 'OtherSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentVert = vaCenter
            Width = 69
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 861
    ExplicitWidth = 861
  end
  inherited ActionList: TActionList
    object dsdPrintAction: TdsdPrintAction
      Category = 'DSDLib'
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1086#1090#1095#1077#1090#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 3
      ShortCut = 16464
      Params = <>
      ReportName = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1076#1086#1083#1075#1086#1084')'
    end
  end
  inherited MasterDS: TDataSource
    Top = 48
  end
  inherited MasterCDS: TClientDataSet
    IndexFieldNames = 'PaidKindName'
    Top = 48
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_JuridicalSold'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 41395d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inAccountId'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'inInfoMoneyId'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'inInfoMoneyGroupId'
        Value = Null
        ParamType = ptInput
      end
      item
        Name = 'inInfoMoneyDestinationId'
        Value = Null
        ParamType = ptInput
      end>
    Top = 48
  end
  inherited BarManager: TdxBarManager
    Left = 112
    Top = 48
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbPrint'
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
          ItemName = 'bbGridToExcel'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end>
    end
    object bbPrint: TdxBarButton
      Action = dsdPrintAction
      Category = 0
    end
  end
  object frxDBDataset: TfrxDBDataset
    UserName = 'frxDBDataset'
    CloseDataSource = False
    DataSource = MasterDS
    BCDToCurrency = False
    Left = 184
    Top = 264
  end
end
