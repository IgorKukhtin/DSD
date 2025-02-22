inherited Report_WeighingPartner_PassportForm: TReport_WeighingPartner_PassportForm
  Caption = #1054#1090#1095#1077#1090' <'#1055#1086' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1103#1084' '#1055#1072#1089#1087#1086#1088#1090' '#1090#1086#1074#1072#1088#1072'>'
  ClientHeight = 348
  ClientWidth = 1064
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 1080
  ExplicitHeight = 387
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 91
    Width = 1064
    Height = 257
    TabOrder = 3
    ExplicitWidth = 1064
    ExplicitHeight = 291
    ClientRectBottom = 257
    ClientRectRight = 1064
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1064
      ExplicitHeight = 291
      inherited cxGrid: TcxGrid
        Width = 1064
        Height = 257
        ExplicitLeft = 24
        ExplicitTop = -40
        ExplicitWidth = 1064
        ExplicitHeight = 291
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare1
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare8
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare9
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare10
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = BoxCountTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = BoxWeightTotal
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = RealWeight
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare1
            end
            item
              Format = 'C'#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare2
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare3
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare4
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare5
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare6
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare7
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare8
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare9
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = CountTare10
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = BoxCountTotal
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = BoxWeightTotal
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object StatusCode: TcxGridDBColumn
            Caption = #1057#1090#1072#1090#1091#1089
            DataBinding.FieldName = 'StatusCode'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = #1053#1077' '#1087#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 11
                Value = 1
              end
              item
                Description = #1055#1088#1086#1074#1077#1076#1077#1085
                ImageIndex = 12
                Value = 2
              end
              item
                Description = #1059#1076#1072#1083#1077#1085
                ImageIndex = 13
                Value = 3
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 69
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 48
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 59
          end
          object InsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1089#1086#1079#1076#1072#1085#1080#1103' ('#1074#1079#1074#1077#1096'.)'
            DataBinding.FieldName = 'InsertDate'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 84
          end
          object InsertName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100'  '#1089#1086#1079#1076#1072#1085#1080#1103' ('#1074#1079#1074#1077#1096'.)'
            DataBinding.FieldName = 'InsertName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 97
          end
          object BarCode: TcxGridDBColumn
            Caption = #1064#1090#1088#1080#1093#1082#1086#1076
            DataBinding.FieldName = 'BarCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 111
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 42
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 157
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 52
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 33
          end
          object PartionGoodsDate: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'PartionGoodsDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object PartionNum: TcxGridDBColumn
            Caption = #1055#1072#1089#1087#1086#1088#1090
            DataBinding.FieldName = 'PartionNum'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object PartionCellName: TcxGridDBColumn
            Caption = #1071#1095#1077#1081#1082#1072' '#1093#1088#1072#1085#1077#1085#1080#1103
            DataBinding.FieldName = 'PartionCellName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1089#1082#1083#1072#1076')'
            DataBinding.FieldName = 'Amount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object RealWeight: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088#1080' '#1074#1079#1074#1077#1096'.'
            DataBinding.FieldName = 'RealWeight'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxCountTotal: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1082#1086#1083'-'#1074#1086' '#1103#1097#1080#1082#1086#1074
            DataBinding.FieldName = 'BoxCountTotal'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxWeightTotal: TcxGridDBColumn
            Caption = #1048#1090#1086#1075#1086' '#1074#1077#1089' '#1103#1097#1080#1082#1086#1074
            DataBinding.FieldName = 'BoxWeightTotal'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxName_1: TcxGridDBColumn
            Caption = #1071#1097'. '#1074#1080#1076#1072'1'
            DataBinding.FieldName = 'BoxName_1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object CountTare1: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1103#1097'. '#1074#1080#1076#1072'1'
            DataBinding.FieldName = 'CountTare1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxName_2: TcxGridDBColumn
            Caption = #1071#1097'. '#1074#1080#1076#1072'2'
            DataBinding.FieldName = 'BoxName_2'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object CountTare2: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1103#1097'. '#1074#1080#1076#1072'2'
            DataBinding.FieldName = 'CountTare2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxName_3: TcxGridDBColumn
            Caption = #1071#1097'. '#1074#1080#1076#1072'3'
            DataBinding.FieldName = 'BoxName_3'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object CountTare3: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1103#1097'. '#1074#1080#1076#1072'3'
            DataBinding.FieldName = 'CountTare3'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxName_4: TcxGridDBColumn
            Caption = #1071#1097'. '#1074#1080#1076#1072'4'
            DataBinding.FieldName = 'BoxName_4'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object CountTare4: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1103#1097'. '#1074#1080#1076#1072'4'
            DataBinding.FieldName = 'CountTare4'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxName_5: TcxGridDBColumn
            Caption = #1071#1097'. '#1074#1080#1076#1072'5'
            DataBinding.FieldName = 'BoxName_5'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object CountTare5: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1103#1097'. '#1074#1080#1076#1072'5'
            DataBinding.FieldName = 'CountTare5'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxName_6: TcxGridDBColumn
            Caption = #1071#1097'. '#1074#1080#1076#1072'6'
            DataBinding.FieldName = 'BoxName_6'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object CountTare6: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1103#1097'. '#1074#1080#1076#1072'6'
            DataBinding.FieldName = 'CountTare6'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxName_7: TcxGridDBColumn
            Caption = #1071#1097'. '#1074#1080#1076#1072'7'
            DataBinding.FieldName = 'BoxName_7'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object CountTare7: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1103#1097'. '#1074#1080#1076#1072'7'
            DataBinding.FieldName = 'CountTare7'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxName_8: TcxGridDBColumn
            Caption = #1071#1097'. '#1074#1080#1076#1072'8'
            DataBinding.FieldName = 'BoxName_8'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object CountTare8: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1103#1097'. '#1074#1080#1076#1072'8'
            DataBinding.FieldName = 'CountTare8'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxName_9: TcxGridDBColumn
            Caption = #1071#1097'. '#1074#1080#1076#1072'9'
            DataBinding.FieldName = 'BoxName_9'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object CountTare9: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1103#1097'. '#1074#1080#1076#1072'9'
            DataBinding.FieldName = 'CountTare9'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object BoxName_10: TcxGridDBColumn
            Caption = #1071#1097'. '#1074#1080#1076#1072'10'
            DataBinding.FieldName = 'BoxName_10'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object CountTare10: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1103#1097'. '#1074#1080#1076#1072'10'
            DataBinding.FieldName = 'CountTare10'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1064
    Height = 65
    ExplicitLeft = 8
    ExplicitWidth = 1064
    ExplicitHeight = 65
    inherited deStart: TcxDateEdit
      Left = 97
      EditValue = 45658d
      Properties.SaveTime = False
      ExplicitLeft = 97
    end
    inherited deEnd: TcxDateEdit
      Left = 305
      EditValue = 45658d
      Properties.SaveTime = False
      ExplicitLeft = 305
    end
    inherited cxLabel1: TcxLabel
      Left = 5
      ExplicitLeft = 5
    end
    inherited cxLabel2: TcxLabel
      Left = 189
      ExplicitLeft = 189
    end
    object lbSearchName: TcxLabel
      Left = 5
      Top = 35
      Caption = #1064#1090#1088#1080#1093#1082#1086#1076':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchBarCode: TcxTextEdit
      Left = 83
      Top = 36
      TabOrder = 5
      DesignSize = (
        198
        21)
      Width = 198
    end
    object cxLabel4: TcxLabel
      Left = 305
      Top = 35
      Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchPartionNum: TcxTextEdit
      Left = 673
      Top = 36
      TabOrder = 7
      DesignSize = (
        191
        21)
      Width = 191
    end
  end
  object cxLabel3: TcxLabel [2]
    Left = 602
    Top = 35
    Caption = #1055#1072#1089#1087#1086#1088#1090':'
    ParentFont = False
    Style.Font.Charset = DEFAULT_CHARSET
    Style.Font.Color = clBlue
    Style.Font.Height = -13
    Style.Font.Name = 'Tahoma'
    Style.Font.Style = [fsBold]
    Style.IsFontAssigned = True
  end
  object edSearchGoodsCode: TcxTextEdit [3]
    Left = 394
    Top = 36
    TabOrder = 7
    DesignSize = (
      191
      21)
    Width = 191
  end
  inherited ActionList: TActionList
    object actRefresh_Detail: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1044#1077#1090#1072#1083#1100#1085#1086' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077
      Hint = #1044#1077#1090#1072#1083#1100#1085#1086' '#1074#1079#1074#1077#1096#1080#1074#1072#1085#1080#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_WeighingPartner_PassportDialogForm'
      FormNameParam.Value = 'TReport_WeighingPartner_PassportDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 42005d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 42005d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
    object actSelectMIPrintPassport: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelectMIPrintPassport
      StoredProcList = <
        item
          StoredProc = spSelectMIPrintPassport
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1055#1072#1089#1087#1086#1088#1090#1072
      Hint = #1055#1077#1095#1072#1090#1100' '#1055#1072#1089#1087#1086#1088#1090#1072
      ImageIndex = 23
      DataSets = <
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDItems'
        end>
      Params = <
        item
          Name = 'isPrintTermo'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMI_WeighingProductionPassport'
      ReportNameParam.Value = 'PrintMI_WeighingProductionPassport'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object dsdChoiceGuides1: TdsdChoiceGuides
      Category = 'DSDLib'
      MoveParams = <>
      Params = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Name'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Code'
          MultiSelectSeparator = ','
        end>
      Caption = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      Hint = #1042#1099#1073#1086#1088' '#1080#1079' '#1089#1087#1088#1072#1074#1086#1095#1085#1080#1082#1072
      ImageIndex = 7
    end
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 208
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 208
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_WeighingPartner_Passport'
    Params = <
      item
        Name = 'inStartDate'
        Value = 41640d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 41640d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'fff'
        Value = Null
        DataType = ftBoolean
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 208
  end
  inherited BarManager: TdxBarManager
    Left = 160
    Top = 208
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
          ItemName = 'bbExecuteDialog'
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
          ItemName = 'bbPrint'
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
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrint: TdxBarButton
      Action = actSelectMIPrintPassport
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 320
    Top = 232
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 112
    Top = 128
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end
      item
      end>
    Left = 224
    Top = 136
  end
  object FormParams: TdsdFormParams
    Params = <>
    Left = 328
    Top = 170
  end
  object spSelectMIPrintPassport: TdsdStoredProc
    StoredProcName = 'gpSelect_MI_WeighingProduction_PrintPassport'
    DataSet = PrintItemsCDS
    DataSets = <
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 664
    Top = 168
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 660
    Top = 222
  end
  object FieldFilter_Name: TdsdFieldFilter
    TextEdit = edSearchBarCode
    DataSet = MasterCDS
    Column = BarCode
    ColumnList = <
      item
        Column = BarCode
      end
      item
        Column = GoodsCode
        TextEdit = edSearchGoodsCode
      end
      item
        Column = PartionCellName
        TextEdit = edSearchPartionNum
      end>
    ActionNumber1 = dsdChoiceGuides1
    CheckBoxList = <>
    Left = 464
    Top = 64
  end
end
