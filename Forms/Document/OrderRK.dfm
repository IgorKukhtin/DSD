inherited OrderRKForm: TOrderRKForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1047#1072#1076#1072#1085#1080#1077' '#1085#1072' '#1089#1073#1086#1088#1082#1091' '#1043#1055'>'
  ClientHeight = 460
  ClientWidth = 1298
  ExplicitWidth = 1314
  ExplicitHeight = 499
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 115
    Width = 1298
    Height = 345
    ExplicitTop = 187
    ExplicitWidth = 1298
    ExplicitHeight = 273
    ClientRectBottom = 345
    ClientRectRight = 1298
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1298
      ExplicitHeight = 249
      inherited cxGrid: TcxGrid
        Width = 1298
        Height = 321
        ExplicitWidth = 1298
        ExplicitHeight = 249
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
            end
            item
              Format = ',0.####'
              Kind = skSum
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
          OptionsBehavior.FocusCellOnCycle = False
          OptionsCustomize.DataRowSizing = False
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsView.GroupSummaryLayout = gslStandard
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object LineNum: TcxGridDBColumn [0]
            Caption = #8470' '#1087'/'#1087
            DataBinding.FieldName = 'LineNum'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object GoodsName: TcxGridDBColumn [1]
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 250
          end
          object GoodsCode: TcxGridDBColumn [2]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object GoodsKindName: TcxGridDBColumn [3]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoodsKindChoice
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object MeasureName: TcxGridDBColumn [4]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object Amount: TcxGridDBColumn [5]
            Caption = #1050#1086#1083'-'#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object GoodsCode_in: TcxGridDBColumn [6]
            Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088' ('#1087#1077#1088#1077#1089#1086#1088#1090'-'#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsCode_in'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1090#1086#1074#1072#1088' ('#1087#1077#1088#1077#1089#1086#1088#1090'-'#1087#1088#1080#1093#1086#1076')'
            Options.Editing = False
            Width = 86
          end
          object GoodsName_in: TcxGridDBColumn [7]
            Caption = #1058#1086#1074#1072#1088' ('#1087#1077#1088#1077#1089#1086#1088#1090'-'#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsName_in'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 245
          end
          object GoodsKindName_in: TcxGridDBColumn [8]
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088' ('#1087#1077#1088#1077#1089#1086#1088#1090'-'#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsKindName_in'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 202
          end
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 190
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1298
    Height = 89
    TabOrder = 3
    ExplicitWidth = 1298
    ExplicitHeight = 89
    inherited edInvNumber: TcxTextEdit
      Left = 8
      Top = 22
      ExplicitLeft = 8
      ExplicitTop = 22
      ExplicitWidth = 75
      Width = 75
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 89
      Top = 22
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 89
      ExplicitTop = 22
      ExplicitWidth = 87
      Width = 87
    end
    inherited cxLabel2: TcxLabel
      Left = 89
      ExplicitLeft = 89
    end
    inherited cxLabel15: TcxLabel
      Top = 45
      ExplicitTop = 45
    end
    inherited ceStatus: TcxButtonEdit
      Top = 63
      ExplicitTop = 63
      ExplicitWidth = 168
      ExplicitHeight = 22
      Width = 168
    end
    object cxLabel4: TcxLabel
      Left = 619
      Top = 5
      Caption = #1054#1090' '#1082#1086#1075#1086
    end
    object edFrom: TcxButtonEdit
      Left = 619
      Top = 22
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 180
    end
    object cxLabel7: TcxLabel
      Left = 1152
      Top = 5
      Caption = #1052#1072#1088#1096#1088#1091#1090
    end
    object edRoute: TcxButtonEdit
      Left = 1152
      Top = 22
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 139
    end
    object cxLabel8: TcxLabel
      Left = 808
      Top = 5
      Caption = #1050#1086#1084#1091
    end
    object edTo: TcxButtonEdit
      Left = 808
      Top = 22
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 205
    end
    object cbPrinted: TcxCheckBox
      Left = 642
      Top = 63
      Caption = #1056#1072#1089#1087#1077#1095#1072#1090#1072#1085' ('#1076#1072'/'#1085#1077#1090')'
      Properties.ReadOnly = True
      TabOrder = 12
      Width = 128
    end
    object cxLabel18: TcxLabel
      Left = 808
      Top = 45
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object ceComment: TcxTextEdit
      Left = 808
      Top = 63
      TabOrder = 14
      Width = 483
    end
    object cxLabel19: TcxLabel
      Left = 301
      Top = 45
      Caption = #1044#1072#1090#1072' '#1087#1077#1095#1072#1090#1080
    end
    object edOperDate_print: TcxDateEdit
      Left = 301
      Top = 63
      EditValue = 42195d
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 16
      Width = 110
    end
    object cxLabel22: TcxLabel
      Left = 182
      Top = 45
      Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' '#1086#1090#1075'.'
    end
    object edCarInfo_Date: TcxDateEdit
      Left = 182
      Top = 63
      EditValue = 0d
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.EditFormat = 'dd.mm.yyyy hh:mm'
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 18
      Width = 113
    end
    object edOrderExternal: TcxButtonEdit
      Left = 417
      Top = 22
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 19
      Width = 195
    end
    object cxLabel5: TcxLabel
      Left = 417
      Top = 5
      Caption = #1047#1072#1103#1074#1082#1072' '#1089#1090#1086#1088#1086#1085#1085#1103#1103
    end
    object cxLabel6: TcxLabel
      Left = 182
      Top = 5
      Caption = #1044#1072#1090#1072' '#1079#1072#1103#1074#1082#1080
    end
    object edOperDate_OrderExternal: TcxDateEdit
      Left = 182
      Top = 22
      EditValue = 42132d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 22
      Width = 113
    end
    object cxLabel10: TcxLabel
      Left = 418
      Top = 45
      Caption = #1044#1072#1090#1072' '#1086#1090#1075#1088'.('#1079#1072#1103#1074'.)'
    end
    object edOperDatePartner_OrderExternal: TcxDateEdit
      Left = 417
      Top = 62
      EditValue = 43282d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 24
      Width = 95
    end
    object cxLabel9: TcxLabel
      Left = 516
      Top = 45
      Hint = #1044#1072#1090#1072' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
      Caption = #1044#1072#1090#1072' '#1082#1086#1085#1090#1088'.('#1079#1072#1103#1074'.)'
      ParentShowHint = False
      ShowHint = True
    end
    object edOperDatePartner_sale: TcxDateEdit
      Left = 520
      Top = 63
      EditValue = 42195d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 26
      Width = 92
    end
    object cxLabel11: TcxLabel
      Left = 301
      Top = 5
      Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076'.)'
    end
    object edInsertDate: TcxDateEdit
      Left = 301
      Top = 22
      EditValue = 0d
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.EditFormat = 'dd.mm.yyyy hh:mm'
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 28
      Width = 110
    end
  end
  object cxLabel3: TcxLabel [2]
    Left = 1024
    Top = 5
    Caption = #1058#1086#1088#1075#1086#1074#1072#1103' '#1089#1077#1090#1100
  end
  object edRetail: TcxButtonEdit [3]
    Left = 1024
    Top = 22
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 7
    Width = 121
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 923
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 1216
    Top = 256
  end
  inherited ActionList: TActionList
    Left = 15
    Top = 262
    object actRefreshGet: TdsdDataSetRefresh [0]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spGet
      StoredProcList = <
        item
          StoredProc = spGet
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 4
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object actPrint_3: TdsdPrintAction [1]
      Category = 'Print'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' ('#1089#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1087#1086' '#1082#1086#1076#1091' '#1090#1086#1074#1072#1088#1072')'
      Hint = #1055#1077#1095#1072#1090#1100' ('#1089#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1087#1086' '#1082#1086#1076#1091' '#1090#1086#1074#1072#1088#1072')'
      ImageIndex = 19
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsCode;GoodsGroupNameFull;GoodsName;GoodsKindName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inIsJuridical'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_OrderRK'
      ReportNameParam.Value = 'PrintMovement_OrderRK'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    inherited actRefresh: TdsdDataSetRefresh
      StoredProcList = <
        item
          StoredProc = spGet
        end
        item
          StoredProc = spGetTotalSumm
        end
        item
          StoredProc = spSelect
        end
        item
        end>
      RefreshOnTabSetChanges = True
    end
    object mactPrint_Order3: TMultiAction [6]
      Category = 'Print'
      MoveParams = <>
      ActionList = <
        item
          Action = actPrint_3
        end
        item
          Action = actSPSavePrintState
        end>
      Caption = #1055#1077#1095#1072#1090#1100' ('#1089#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1087#1086' '#1082#1086#1076#1091' '#1090#1086#1074#1072#1088#1072')'
      Hint = #1055#1077#1095#1072#1090#1100' ('#1089#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1087#1086' '#1082#1086#1076#1091' '#1090#1086#1074#1072#1088#1072')'
      ImageIndex = 19
    end
    object actPrintTotal: TdsdPrintAction [11]
      Category = 'Print'
      MoveParams = <>
      StoredProc = spSelectPrintTotal
      StoredProcList = <
        item
          StoredProc = spSelectPrintTotal
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1080#1090#1086#1075#1086' '#1087#1086' '#1070#1088' '#1083#1080#1094#1091
      Hint = #1055#1077#1095#1072#1090#1100' '#1080#1090#1086#1075#1086' '#1087#1086' '#1070#1088' '#1083#1080#1094#1091
      ImageIndex = 16
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'LineNum;GoodsGroupNameFull;GoodsName;GoodsKindName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inIsJuridical'
          Value = True
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_OrderRK'
      ReportNameParam.Value = 'PrintMovement_OrderRK'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_2: TdsdPrintAction [12]
      Category = 'Print'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' ('#1089#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1087#1086' '#1074#1080#1076#1091' '#1091#1087#1072#1082#1086#1074#1082#1080')'
      Hint = #1055#1077#1095#1072#1090#1100' ('#1089#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1087#1086' '#1074#1080#1076#1091' '#1091#1087#1072#1082#1086#1074#1082#1080')'
      ImageIndex = 17
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'LineNum;GoodsKindName;GoodsGroupNameFull;GoodsName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inIsJuridical'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_OrderRK'
      ReportNameParam.Value = 'PrintMovement_OrderRK'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actGoodsChoice: TOpenChoiceForm [13]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Goods_ObjectForm'
      FormName = 'TGoods_ObjectForm'
      FormNameParam.Value = 'TGoods_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actPrintSort: TdsdPrintAction [14]
      Category = 'Print'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' ('#1089#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1087#1086' '#1074#1077#1089#1091' )'
      Hint = #1055#1077#1095#1072#1090#1100' ('#1089#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1087#1086' '#1074#1077#1089#1091' )'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;AmountSort;GoodsName;GoodsKindName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inIsJuridical'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_OrderExternalQty'
      ReportNameParam.Value = 'PrintMovement_OrderExternalQty'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintCell: TdsdPrintAction [15]
      Category = 'Print'
      MoveParams = <>
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1087#1086' '#1084#1077#1089#1090#1072#1084' '#1086#1090#1073#1086#1088#1072
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'NPP;GoodsName;GoodsKindName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inIsJuridical'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_OrderExternal_Cell'
      ReportNameParam.Value = 'PrintMovement_OrderExternal_Cell'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    inherited actPrint: TdsdPrintAction
      Category = 'Print'
      StoredProc = spSelectPrint
      StoredProcList = <
        item
          StoredProc = spSelectPrint
        end>
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'LineNum;GoodsGroupNameFull;GoodsName;GoodsKindName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'inIsJuridical'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_OrderRK'
      ReportNameParam.Value = 'PrintMovement_OrderRK'
      ReportNameParam.ParamType = ptInput
    end
    inherited actUnCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    inherited actCompleteMovement: TChangeGuidesStatus
      StoredProcList = <
        item
          StoredProc = spChangeStatus
        end
        item
        end>
    end
    inherited actMovementItemContainer: TdsdOpenForm
      Enabled = False
    end
    object actGoodsKindChoice: TOpenChoiceForm [21]
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'GoodsKindForm'
      FormName = 'TGoodsKindForm'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actSPSavePrintState: TdsdExecStoredProc
      Category = 'Print'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spSavePrintState
      StoredProcList = <
        item
          StoredProc = spSavePrintState
        end>
      Caption = 'actSPSavePrintState'
    end
    object mactPrint_Order2: TMultiAction
      Category = 'Print'
      MoveParams = <>
      ActionList = <
        item
          Action = actPrint_2
        end
        item
          Action = actSPSavePrintState
        end>
      Caption = #1055#1077#1095#1072#1090#1100' ('#1089#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1087#1086' '#1074#1080#1076#1091' '#1091#1087#1072#1082#1086#1074#1082#1080')'
      Hint = #1055#1077#1095#1072#1090#1100' ('#1089#1086#1088#1090#1080#1088#1086#1074#1082#1072' '#1087#1086' '#1074#1080#1076#1091' '#1091#1087#1072#1082#1086#1074#1082#1080')'
      ImageIndex = 17
    end
    object mactPrint_Order: TMultiAction
      Category = 'Print'
      MoveParams = <>
      ActionList = <
        item
          Action = actPrint
        end
        item
          Action = actSPSavePrintState
        end>
      Caption = #1055#1077#1095#1072#1090#1100
      Hint = #1055#1077#1095#1072#1090#1100
      ImageIndex = 3
    end
    object actShowMessage: TShowMessageAction
      Category = 'DSDLib'
      MoveParams = <>
    end
    object actUpdate_MIChild_AmountNull: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = #1054#1073#1085#1091#1083#1077#1085#1080#1077' '#1076#1072#1085#1085#1099#1093' '#1088#1077#1079#1077#1088#1074' ('#1086#1089#1090#1072#1090#1086#1082' '#1080' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077')'
      Hint = #1054#1073#1085#1091#1083#1077#1085#1080#1077' '#1076#1072#1085#1085#1099#1093' '#1088#1077#1079#1077#1088#1074' ('#1086#1089#1090#1072#1090#1086#1082' '#1080' '#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077')'
      ImageIndex = 70
    end
    object actUpdateOperDatePartner: TdsdDataSetRefresh
      Category = 'OperDatePartner'
      MoveParams = <>
      StoredProc = spUpdateMovement_OperDatePartner
      StoredProcList = <
        item
          StoredProc = spUpdateMovement_OperDatePartner
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ImageIndex = 67
      ShortCut = 116
      RefreshOnTabSetChanges = True
    end
    object ExecuteDialogUpdateOperDatePartner: TExecuteDialog
      Category = 'OperDatePartner'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1086#1090#1075#1088#1091#1079#1082#1080
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1086#1090#1075#1088#1091#1079#1082#1080
      ImageIndex = 67
      FormName = 'TOrderExternal_DatePartnerDialogForm'
      FormNameParam.Value = 'TOrderExternal_DatePartnerDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'inOperDatePartner'
          Value = 43282d
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end
        item
          Name = 'inIsAuto'
          Value = Null
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inIsAuto'
          Value = False
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      OpenBeforeShow = True
    end
    object macUpdateOperDatePartner: TMultiAction
      Category = 'OperDatePartner'
      MoveParams = <>
      ActionList = <
        item
          Action = ExecuteDialogUpdateOperDatePartner
        end
        item
          Action = actUpdateOperDatePartner
        end
        item
          Action = actRefreshGet
        end>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1095#1077#1082#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1086#1090#1075#1088#1091#1079#1082#1080
      ImageIndex = 67
    end
    object actPrint_Account_ReportName: TdsdExecStoredProc
      Category = 'Print_Account'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spGetReporNameBill
      StoredProcList = <
        item
          StoredProc = spGetReporNameBill
        end>
      Caption = 'actPrint_Account_ReportName'
    end
    object actPrint_Account: TdsdPrintAction
      Category = 'Print_Account'
      MoveParams = <>
      StoredProc = spSelectPrintBill
      StoredProcList = <
        item
          StoredProc = spSelectPrintBill
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1057#1095#1077#1090
      Hint = #1055#1077#1095#1072#1090#1100' '#1057#1095#1077#1090
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'NULL'
      ReportNameParam.Name = #1057#1095#1077#1090
      ReportNameParam.Value = ''
      ReportNameParam.Component = FormParams
      ReportNameParam.ComponentItem = 'ReportNameOrderExternalBill'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object mactPrint_Account: TMultiAction
      Category = 'Print_Account'
      MoveParams = <>
      ActionList = <
        item
          Action = actPrint_Account_ReportName
        end
        item
          Action = actPrint_Account
        end>
      Caption = #1055#1077#1095#1072#1090#1100' '#1057#1095#1077#1090
      Hint = #1055#1077#1095#1072#1090#1100' '#1057#1095#1077#1090
      ImageIndex = 21
    end
    object actUpdateMIChild_Amount: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1088#1077#1079#1077#1088#1074' ('#1086#1089#1090#1072#1090#1086#1082')'
      Hint = #1060#1086#1088#1084#1080#1088#1086#1074#1072#1085#1080#1077' '#1088#1077#1079#1077#1088#1074' ('#1086#1089#1090#1072#1090#1086#1082')'
      ImageIndex = 68
    end
    object macUpdateMIChild_Amount: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdateMIChild_Amount
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1086#1089#1090#1072#1090#1086#1082')?'
      InfoAfterExecute = #1059#1089#1087#1077#1096#1085#1086' '#1089#1092#1086#1088#1084#1080#1088#1086#1074#1072#1085#1099' '#1076#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1086#1089#1090#1072#1090#1086#1082')'
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' c'#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1086#1089#1090#1072#1090#1086#1082')'
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' c'#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1086#1089#1090#1072#1090#1086#1082')'
      ImageIndex = 68
    end
    object actReport_Goods: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' <'#1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1090#1086#1074#1072#1088#1091'>'
      Hint = #1054#1090#1095#1077#1090' <'#1044#1077#1090#1072#1083#1100#1085#1086' '#1087#1086' '#1090#1086#1074#1072#1088#1091'>'
      ImageIndex = 26
      FormName = 'TReport_GoodsForm'
      FormNameParam.Value = 'TReport_GoodsForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 43466d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 43466d
          Component = edOperDate
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupId'
          Value = ''
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationId'
          Value = Null
          Component = GuidesTo
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = Null
          Component = GuidesTo
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = Null
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupNameFull'
          Value = Null
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'IsPartner'
          Value = True
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object InsertRecord: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      PostDataSetAfterExecute = True
      View = cxGridDBTableView
      Action = actGoodsChoice
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      Hint = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      ShortCut = 45
      ImageIndex = 0
    end
  end
  inherited MasterDS: TDataSource
    Left = 16
    Top = 312
  end
  inherited MasterCDS: TClientDataSet
    Left = 64
    Top = 328
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_OrderRK'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsErased'
        Value = False
        Component = actShowErased
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 248
  end
  inherited BarManager: TdxBarManager
    Left = 64
    Top = 263
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
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          BeginGroup = True
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbInsertRecord'
        end
        item
          Visible = True
          ItemName = 'bbErased'
        end
        item
          Visible = True
          ItemName = 'bbUnErased'
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
          ItemName = 'bbsPrint'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbMovementItemProtocol'
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
    inherited dxBarStatic: TdxBarStatic
      ShowCaption = False
    end
    inherited bbPrint: TdxBarButton
      Action = mactPrint_Order
    end
    object bbOpenReportForm: TdxBarButton
      Caption = #1054#1090#1095#1077#1090' <'#1042#1067#1055#1054#1051#1053#1045#1053#1048#1045' '#1079#1072#1103#1074#1082#1080' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      Category = 0
      Hint = #1054#1090#1095#1077#1090' <'#1042#1067#1055#1054#1051#1053#1045#1053#1048#1045' '#1079#1072#1103#1074#1082#1080' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103'>'
      Visible = ivAlways
      ImageIndex = 25
    end
    object bbPrintTotal: TdxBarButton
      Action = actPrintTotal
      Caption = #1055#1077#1095#1072#1090#1100' '#1080#1090#1086#1075#1086' '#1087#1086' '#1070#1088'.'#1083#1080#1094#1091
      Category = 0
    end
    object bbUpdateOperDatePartner: TdxBarButton
      Action = macUpdateOperDatePartner
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1076#1072#1090#1091' '#1086#1090#1075#1088#1091#1079#1082#1080
      Category = 0
    end
    object bbPrintOrder: TdxBarButton
      Action = mactPrint_Order2
      Category = 0
    end
    object bbPrint_Account: TdxBarButton
      Action = mactPrint_Account
      Category = 0
    end
    object bbUpdateMIChild_Amount: TdxBarButton
      Action = macUpdateMIChild_Amount
      Category = 0
    end
    object bbUpdateMIChild_AmountSecond: TdxBarButton
      Caption = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' c'#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077')'
      Category = 0
      Hint = #1057#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' c'#1092#1086#1088#1084#1080#1088#1086#1074#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1056#1077#1079#1077#1088#1074' ('#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077')'
      Visible = ivAlways
      ImageIndex = 69
    end
    object bbReport_Goods: TdxBarButton
      Action = actReport_Goods
      Category = 0
    end
    object bbOpenFormOrderExternalChild: TdxBarButton
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1088#1077#1079#1077#1088#1074#1072' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072
      Category = 0
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1088#1077#1079#1077#1088#1074' '#1076#1083#1103' '#1079#1072#1082#1072#1079#1072
      Visible = ivAlways
      ImageIndex = 24
    end
    object bbUpdate_MIChild_AmountNull: TdxBarButton
      Action = actUpdate_MIChild_AmountNull
      Category = 0
    end
    object bbUpdate_MIChild_AmountSecondNull: TdxBarButton
      Caption = #1054#1073#1085#1091#1083#1077#1085#1080#1077' '#1076#1072#1085#1085#1099#1093' '#1088#1077#1079#1077#1088#1074' ('#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077')'
      Category = 0
      Hint = #1054#1073#1085#1091#1083#1077#1085#1080#1077' '#1076#1072#1085#1085#1099#1093' '#1088#1077#1079#1077#1088#1074' ('#1087#1077#1088#1077#1084#1077#1097#1077#1085#1080#1077')'
      Visible = ivAlways
      ImageIndex = 71
    end
    object bbPrintQty: TdxBarButton
      Action = actPrintSort
      Category = 0
    end
    object bbPrintCell: TdxBarButton
      Action = actPrintCell
      Category = 0
    end
    object bbsPrint: TdxBarSubItem
      Caption = #1055#1077#1095#1072#1090#1100
      Category = 0
      Visible = ivNever
      ImageIndex = 3
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbPrint'
        end
        item
          Visible = True
          ItemName = 'bbPrintQty'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbPrintOrder'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Order3'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbPrintTotal'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbPrint_Account'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'bbPrintCell'
        end>
    end
    object bbSeparator: TdxBarSeparator
      Caption = 'Separator'
      Category = 0
      Hint = 'Separator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbPrint_Order3: TdxBarButton
      Action = mactPrint_Order3
      Category = 0
    end
    object bbInsertRecord: TdxBarButton
      Action = InsertRecord
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnlyEditingCellOnEnter = True
    ColumnAddOnList = <
      item
        Column = GoodsCode
        FindByFullValue = True
        onExitColumn.Active = False
        onExitColumn.AfterEmptyValue = False
      end>
    ColumnEnterList = <
      item
        Column = GoodsCode
      end
      item
        Column = GoodsName
      end
      item
        Column = Amount
      end>
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    Left = 758
    Top = 185
  end
  inherited PopupMenu: TPopupMenu
    Left = 104
    Top = 232
    object N2: TMenuItem
      Action = actMISetErased
    end
    object N3: TMenuItem
      Action = actMISetUnErased
    end
  end
  inherited FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Key'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ShowAll'
        Value = False
        Component = actShowAll
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameOrderExternal'
        Value = 'PrintMovement_Sale1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameOrderExternalTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameOrderExternalBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPrinted'
        Value = True
        DataType = ftBoolean
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMask'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    Left = 1032
    Top = 280
  end
  inherited StatusGuides: TdsdGuides
    Left = 80
    Top = 48
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_OrderRK'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioStatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outStatusName'
        Value = Null
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPrinted'
        Value = Null
        Component = cbPrinted
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'outMessageText'
        Value = Null
        Component = actShowMessage
        ComponentItem = 'MessageText'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 144
    Top = 48
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_OrderRK'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber'
        Value = ''
        Component = edInvNumber
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = FormParams
        ComponentItem = 'inOperDate'
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StatusCode'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'Key'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate_print'
        Value = Null
        Component = edOperDate_print
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate_CarInfo'
        Value = Null
        Component = edCarInfo_Date
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'isPrint'
        Value = Null
        Component = cbPrinted
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailId'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RetailName'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteId'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'RouteName'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = Null
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'MovementId_OrderExternal'
        Value = Null
        Component = GuidesOrderExternal
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumberFull_OrderExternal'
        Value = Null
        Component = GuidesOrderExternal
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate_OrderExternal'
        Value = Null
        Component = edOperDate_OrderExternal
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDatePartner_OrderExternal'
        Value = Null
        Component = edOperDatePartner_OrderExternal
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDatePartner_sale_OE'
        Value = Null
        Component = edOperDatePartner_sale
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertDate'
        Value = Null
        Component = edInsertDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 248
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_OrderRK'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inParentId'
        Value = Null
        Component = GuidesOrderExternal
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = ''
        Component = edInvNumber
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 0d
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outRouteName'
        Value = Null
        Component = GuidesRoute
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'outRetailName'
        Value = Null
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 162
    Top = 296
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
      end
      item
      end>
    Top = 376
  end
  inherited HeaderSaver: THeaderSaver
    ControlList = <
      item
        Control = edInvNumber
      end
      item
        Control = edOperDate
      end
      item
        Control = edOrderExternal
      end
      item
      end
      item
      end
      item
      end
      item
        Control = ceComment
      end>
    Left = 224
    Top = 305
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 664
    Top = 184
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderRK_SetErased'
    Left = 518
    Top = 320
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_OrderRK_SetUnErased'
    Left = 582
    Top = 304
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_OrderRK'
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Amount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 344
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_OrderRK'
    Params = <
      item
        Name = 'ioId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmount'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inAmountSecond'
        Value = 0.000000000000000000
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ioCountForPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountForPrice'
        ParamType = ptInputOutput
        MultiSelectSeparator = ','
      end>
    Left = 312
    Top = 264
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Left = 460
    Top = 372
  end
  object RefreshDispatcher: TRefreshDispatcher
    CheckIdParam = True
    IdParam.Value = Null
    IdParam.Component = FormParams
    IdParam.ComponentItem = 'Id'
    IdParam.MultiSelectSeparator = ','
    ComponentList = <
      item
        Component = GuidesTo
      end>
    Left = 424
    Top = 312
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 580
    Top = 185
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 524
    Top = 182
  end
  object PrintItemsSverkaCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 452
    Top = 270
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_OrderRK_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsJuridical'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 311
    Top = 216
  end
  object GuidesFrom: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFrom
    DisableGuidesOpen = True
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 816
  end
  object GuidesRoute: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRoute
    DisableGuidesOpen = True
    FormNameParam.Value = 'TRoute_SelfForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRoute_SelfForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRoute
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 984
    Top = 40
  end
  object GuidesTo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edTo
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPartner_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPartner_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 667
    Top = 12
  end
  object spSavePrintState: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_OrderRK_Print'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inNewPrinted'
        Value = Null
        Component = FormParams
        ComponentItem = 'isPrinted'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'outPrinted'
        Value = True
        Component = cbPrinted
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 312
    Top = 312
  end
  object spSelectPrintTotal: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_OrderRK_Print'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsJuridical'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 383
    Top = 232
  end
  object spUpdateMovement_OperDatePartner: TdsdStoredProc
    StoredProcName = 'gpUpdate_Movement_OrderExternal_OperDatePartner'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = Null
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = Null
        Component = edOperDate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDatePartner'
        Value = 42261d
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsAuto'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 986
    Top = 208
  end
  object spGetReporNameBill: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_OrderExternal_ReportNameBill'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inMovementId'
        Value = '0'
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_Movement_OrderExternal_ReportNameBill'
        Value = Null
        Component = FormParams
        ComponentItem = 'ReportNameOrderExternalBill'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 776
    Top = 352
  end
  object spSelectPrintBill: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_OrderExternal_PrintBill'
    DataSet = PrintHeaderCDS
    DataSets = <
      item
        DataSet = PrintHeaderCDS
      end
      item
        DataSet = PrintItemsCDS
      end>
    OutputType = otMultiDataSet
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 679
    Top = 352
  end
  object GuidesRetail: TdsdGuides
    KeyField = 'Id'
    LookupControl = edRetail
    DisableGuidesOpen = True
    Key = '0'
    FormNameParam.Value = 'TRetailForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TRetailForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesRetail
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 872
    Top = 16
  end
  object GuidesOrderExternal: TdsdGuides
    KeyField = 'Id'
    LookupControl = edOrderExternal
    FormNameParam.Value = 'TOrderExternalJournalChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TOrderExternalJournalChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesOrderExternal
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesOrderExternal
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromId'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'FromName'
        Value = ''
        Component = GuidesTo
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToId'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ToName'
        Value = ''
        Component = GuidesFrom
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDatePartner'
        Value = Null
        Component = edOperDatePartner_OrderExternal
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'OperDate'
        Value = Null
        Component = edOperDate_OrderExternal
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 524
    Top = 8
  end
end
