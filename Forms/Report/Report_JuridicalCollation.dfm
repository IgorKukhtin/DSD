inherited Report_JuridicalCollationForm: TReport_JuridicalCollationForm
  Caption = #1040#1082#1090' '#1089#1074#1077#1088#1082#1080' '
  ClientHeight = 389
  ClientWidth = 863
  ExplicitWidth = 871
  ExplicitHeight = 416
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 83
    Width = 863
    Height = 306
    TabOrder = 3
    ExplicitTop = 83
    ExplicitWidth = 863
    ExplicitHeight = 306
    ClientRectBottom = 306
    ClientRectRight = 863
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 863
      ExplicitHeight = 306
      inherited cxGrid: TcxGrid
        Width = 863
        Height = 306
        ExplicitWidth = 863
        ExplicitHeight = 306
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Column = colDebet
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colKredit
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
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
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end>
          OptionsView.GroupByBox = True
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colItemName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
            DataBinding.FieldName = 'ItemName'
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object coInvNumber: TcxGridDBColumn
            Caption = #1053#1086#1084#1077#1088
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072
            DataBinding.FieldName = 'OperDate'
            Width = 65
          end
          object colDebet: TcxGridDBColumn
            Caption = #1044#1077#1073#1077#1090
            DataBinding.FieldName = 'Debet'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00'
            HeaderAlignmentVert = vaCenter
            Width = 75
          end
          object colKredit: TcxGridDBColumn
            Caption = #1050#1088#1077#1076#1080#1090
            DataBinding.FieldName = 'Kredit'
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
    Width = 863
    Height = 57
    ExplicitWidth = 863
    ExplicitHeight = 57
    inherited deStart: TcxDateEdit
      Left = 118
      ExplicitLeft = 118
    end
    inherited deEnd: TcxDateEdit
      Left = 118
      Top = 30
      ExplicitLeft = 118
      ExplicitTop = 30
    end
    inherited cxLabel1: TcxLabel
      Left = 27
      ExplicitLeft = 27
    end
    inherited cxLabel2: TcxLabel
      Left = 8
      Top = 31
      ExplicitLeft = 8
      ExplicitTop = 31
    end
    object cxLabel6: TcxLabel
      Left = 209
      Top = 6
      Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086':'
    end
    object edJuridical: TcxButtonEdit
      Left = 209
      Top = 30
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 280
    end
  end
  inherited ActionList: TActionList
    object dsdPrintAction: TdsdPrintAction
      Category = 'DSDLib'
      StoredProcList = <>
      Caption = #1055#1077#1095#1072#1090#1100' '#1086#1090#1095#1077#1090#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 3
      ShortCut = 16464
      Params = <
        item
          Name = 'StartDate'
          Value = 41395d
          Component = deStart
          DataType = ftDateTime
        end
        item
          Name = 'EndDate'
          Value = 41395d
          Component = deEnd
          DataType = ftDateTime
        end>
      ReportName = #1054#1090#1095#1077#1090' '#1048#1090#1086#1075' '#1087#1086' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1102' (c '#1076#1086#1083#1075#1086#1084')'
    end
  end
  inherited MasterDS: TDataSource
    Top = 48
  end
  inherited MasterCDS: TClientDataSet
    IndexFieldNames = 'ItemName;OperDate'
    Top = 48
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_JuridicalCollation'
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
        Name = 'inJuridicalId'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
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
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = JuridicalGuides
      end>
  end
  object frxDBDataset: TfrxDBDataset
    UserName = 'frxDBDataset'
    CloseDataSource = False
    DataSource = MasterDS
    BCDToCurrency = False
    Left = 184
    Top = 264
  end
  object JuridicalGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'Key'
        ParamType = ptInput
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = JuridicalGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
      end>
    Left = 312
    Top = 48
  end
end
