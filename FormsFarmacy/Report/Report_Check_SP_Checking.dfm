inherited Report_Check_SP_CheckingForm: TReport_Check_SP_CheckingForm
  Caption = #1057#1074#1077#1088#1082#1072' '#1095#1077#1082#1086#1074' '#1089' '#1092#1072#1081#1083#1086#1084' '#1089' '#1089#1072#1081#1090#1072
  ClientHeight = 480
  ClientWidth = 1066
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1082
  ExplicitHeight = 519
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 59
    Width = 1066
    Height = 421
    TabOrder = 3
    ExplicitTop = 59
    ExplicitWidth = 1077
    ExplicitHeight = 421
    ClientRectBottom = 421
    ClientRectRight = 1066
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1077
      ExplicitHeight = 421
      inherited cxGrid: TcxGrid
        Width = 1066
        Height = 421
        ExplicitWidth = 1077
        ExplicitHeight = 421
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
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
              Kind = skAverage
            end
            item
              Format = ',0.####'
              Kind = skSum
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
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
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
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
            end>
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object NumLine: TcxGridDBColumn
            Caption = #8470' '#1087'.'#1087'.'
            DataBinding.FieldName = 'NumLine'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 42
          end
          object InvNumber_Full: TcxGridDBColumn
            Caption = #1063#1077#1082' '#1076#1072#1090#1072
            DataBinding.FieldName = 'InvNumber_Full'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 118
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 158
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 138
          end
          object InvNumberSP: TcxGridDBColumn
            Caption = #1056#1077#1094#1077#1087#1090
            DataBinding.FieldName = 'InvNumberSP'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 191
          end
          object SummaSP_pack: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1074#1086#1079#1084#1077#1097#1077#1085#1080#1103' '#1088#1077#1077#1089#1090#1088', '#1075#1088#1085
            DataBinding.FieldName = 'SummaSP_pack'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 96
          end
          object SummaSP: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1092#1072#1082#1090'. '#1074#1086#1079#1084#1077#1097#1077#1085#1080#1103' '#1095#1077#1082', '#1075#1088#1085
            DataBinding.FieldName = 'SummaSP'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object SummaSP_pack_File: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1074#1086#1079#1084#1077#1097#1077#1085#1080#1103' '#1088#1077#1077#1089#1090#1088' '#1089#1072#1081#1090', '#1075#1088#1085
            DataBinding.FieldName = 'SummaSP_pack_File'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 92
          end
          object SummaSP_File: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1092#1072#1082#1090'. '#1074#1086#1079#1084#1077#1097#1077#1085#1080#1103' '#1089#1072#1081#1090', '#1075#1088#1085
            DataBinding.FieldName = 'SummaSP_File'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 92
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1066
    Height = 33
    Visible = False
    ExplicitWidth = 1077
    ExplicitHeight = 33
    inherited deStart: TcxDateEdit
      Left = 26
      ExplicitLeft = 26
    end
    inherited deEnd: TcxDateEdit
      Left = 146
      ExplicitLeft = 146
    end
    inherited cxLabel1: TcxLabel
      Caption = #1057':'
      ExplicitWidth = 15
    end
    inherited cxLabel2: TcxLabel
      Left = 125
      Caption = #1087#1086':'
      ExplicitLeft = 125
      ExplicitWidth = 20
    end
  end
  inherited ActionList: TActionList
    object actRefreshStart: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_Check_SP_CheckingDialogForm'
      FormNameParam.Value = 'TReport_Check_SP_CheckingDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42370d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42370d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalId'
          Value = ''
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 64
    Top = 216
  end
  inherited MasterCDS: TClientDataSet
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Check_SP_Checking'
    Params = <
      item
        Name = 'inFileJson'
        Value = 42370d
        Component = FormParams
        ComponentItem = 'FileJson'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDataJson'
        Value = 42370d
        Component = FormParams
        ComponentItem = 'DataJson'
        DataType = ftWideString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 216
  end
  inherited BarManager: TdxBarManager
    Left = 168
    Top = 216
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
          ItemName = 'dxBarStatic'
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
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
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
    object dxBarButton1: TdxBarButton
      Caption = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Category = 0
      Hint = #1055#1086' '#1087#1072#1088#1090#1080#1103#1084
      Visible = ivAlways
      ImageIndex = 38
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072
      Category = 0
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072
      Visible = ivAlways
      ImageIndex = 3
      ShortCut = 16464
    end
    object bbPrint1: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086#1089#1090'.152'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1088#1086#1076#1072#1078#1072#1084' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072'('#1087#1086#1089#1090'.152)'
      Visible = ivAlways
      ImageIndex = 16
    end
    object dxBarControlContainerItem1: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object bbPrintInvoice: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' '#1089#1095#1077#1090#1072
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100
      Visible = ivAlways
      ImageIndex = 15
    end
    object bbPrint_Pact: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' '#1044#1086#1087'. '#1089#1086#1075#1083#1072#1096#1077#1085#1080#1077
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' '#1044#1086#1087'. '#1089#1086#1075#1083#1072#1096#1077#1085#1080#1077
      Visible = ivAlways
      ImageIndex = 17
    end
    object bbPrintDepartment: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072' ('#1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090')'
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090#1072' ('#1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090')'
      Visible = ivAlways
      ImageIndex = 3
    end
    object bbPrintDepartment_152: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090' ('#1087#1086#1089#1090'.152)'
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' '#1057#1086#1094'. '#1087#1088#1086#1077#1082#1090' ('#1087#1086#1089#1090'.152)'
      Visible = ivAlways
      ImageIndex = 16
    end
    object bbPrintInvoiceDepartment: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' C'#1095#1077#1090#1072' ('#1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090')'
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' C'#1095#1077#1090#1072' ('#1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090')'
      Visible = ivAlways
      ImageIndex = 15
    end
    object bbPrint_PactDepartment: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' '#1044#1086#1087'. '#1089#1086#1075#1083#1072#1096#1077#1085#1080#1077'  ('#1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090')'
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' '#1044#1086#1087'. '#1089#1086#1075#1083#1072#1096#1077#1085#1080#1077'  ('#1044#1077#1087#1072#1088#1090#1072#1084#1077#1085#1090')'
      Visible = ivAlways
      ImageIndex = 17
    end
    object dxBarButton2: TdxBarButton
      Caption = #1055#1077#1095#1072#1090#1100' '#1086#1090#1095#1077#1090#1072' '#1057#1055' '#1076#1083#1103' '#1044#1055#1057#1057
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' '#1086#1090#1095#1077#1090#1072' '#1057#1055' '#1076#1083#1103' '#1044#1055#1057#1057
      Visible = ivAlways
      ImageIndex = 18
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 272
    Top = 304
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 40
    Top = 64
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end
      item
      end
      item
      end>
    Left = 272
    Top = 232
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'FileJson'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DataJson'
        Value = Null
        DataType = ftWideString
        MultiSelectSeparator = ','
      end>
    Left = 192
    Top = 304
  end
end
