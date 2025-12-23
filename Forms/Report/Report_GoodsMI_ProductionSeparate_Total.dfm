inherited Report_GoodsMI_ProductionSeparate_TotalForm: TReport_GoodsMI_ProductionSeparate_TotalForm
  Caption = #1054#1090#1095#1077#1090' <'#1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' '#1048#1090#1086#1075#1086#1074#1099#1081'>'
  ClientHeight = 507
  ClientWidth = 1508
  AddOnFormData.isSingle = False
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitLeft = -614
  ExplicitWidth = 1524
  ExplicitHeight = 546
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 124
    Width = 1508
    Height = 383
    TabOrder = 3
    ExplicitTop = 124
    ExplicitWidth = 1508
    ExplicitHeight = 383
    ClientRectBottom = 383
    ClientRectRight = 1508
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1508
      ExplicitHeight = 383
      inherited cxGrid: TcxGrid
        Width = 1508
        Height = 383
        ExplicitWidth = 1508
        ExplicitHeight = 383
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = ChildSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = ChildAmount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = HeadCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.####'
              Kind = skSum
              Column = ChildSumm
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = ChildAmount
            end
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = HeadCount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Summ
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
          object FromCode_partion: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086#1089#1090'.'
            DataBinding.FieldName = 'FromCode_partion'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1076' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Options.Editing = False
            Width = 70
          end
          object FromName_partion: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'FromName_partion'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 150
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 46
          end
          object OperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
            DataBinding.FieldName = 'OperDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 49
          end
          object FromName: TcxGridDBColumn
            Caption = #1054#1090' '#1082#1086#1075#1086
            DataBinding.FieldName = 'FromName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 110
          end
          object ToName: TcxGridDBColumn
            Caption = #1050#1086#1084#1091
            DataBinding.FieldName = 'ToName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 110
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 140
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 79
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' ('#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 200
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 91
          end
          object PartionGoods: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'PartionGoods'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object PartionGoods_main: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103' ('#1075#1083#1072#1074#1085#1072#1103')'
            DataBinding.FieldName = 'PartionGoods_main'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 140
          end
          object PartionGoods_main2: TcxGridDBColumn
            Caption = '***'#1055#1072#1088#1090#1080#1103' ('#1087#1088'-/'#1086#1073'-)'
            DataBinding.FieldName = 'PartionGoods_main2'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object PartionGoods_Date: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1072#1088#1090#1080#1080
            DataBinding.FieldName = 'PartionGoods_Date'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object Summ: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072'  ('#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'Summ'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object HeadCount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1075#1086#1083#1086#1074
            DataBinding.FieldName = 'HeadCount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 68
          end
          object ChildGoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'ChildGoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 72
          end
          object ChildGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'ChildGoodsCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 71
          end
          object ChildGoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'ChildGoodsName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 71
          end
          object ChildGoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'ChildGoodsKindName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 98
          end
          object StorageLineName: TcxGridDBColumn
            Caption = #1051#1080#1085#1080#1103' '#1087#1088'-'#1074#1072' ('#1088#1072#1089#1093#1086#1076')'
            DataBinding.FieldName = 'StorageLineName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object StorageLineName_in: TcxGridDBColumn
            Caption = #1051#1080#1085#1080#1103' '#1087#1088'-'#1074#1072' ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'StorageLineName_in'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object IsCalculated: TcxGridDBColumn
            Caption = #1056#1072#1089#1089#1095#1080#1090#1099#1074#1072#1077#1090#1089#1103' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'isCalculated'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1047#1085#1072#1095#1077#1085#1080#1077' '#1088#1072#1089#1089#1095#1080#1090#1099#1074#1072#1077#1090#1089#1103' ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 66
          end
          object ChildAmount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'ChildAmount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object ChildPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'ChildPrice'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object ChildSumm: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072'  ('#1087#1088#1080#1093#1086#1076')'
            DataBinding.FieldName = 'ChildSumm'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.00##;-,0.00##; ;'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1072#1081#1089
            DataBinding.FieldName = 'Price'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object Percent: TcxGridDBColumn
            Caption = '% '#1074#1099#1093#1086#1076#1072
            DataBinding.FieldName = 'Percent'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 50
          end
          object Num: TcxGridDBColumn
            Caption = #8470
            DataBinding.FieldName = 'Num'
            Visible = False
            Options.Editing = False
            Width = 30
          end
        end
      end
      object cxLabel9: TcxLabel
        Left = 1263
        Top = 6
        Caption = #1055#1083#1072#1085' '#1086#1073#1074#1072#1083#1082#1072':'
      end
      object edPriceListNorm: TcxButtonEdit
        Left = 676
        Top = 93
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        TabOrder = 2
        Width = 147
      end
      object cbDetailPrint: TcxCheckBox
        Left = 1164
        Top = 6
        Caption = #1076#1077#1090#1072#1083#1100#1085#1086
        TabOrder = 3
        Width = 74
      end
    end
  end
  inherited Panel: TPanel
    Width = 1508
    Height = 57
    ExplicitWidth = 1508
    ExplicitHeight = 57
    inherited deStart: TcxDateEdit
      Left = 108
      EditValue = 45658d
      Properties.SaveTime = False
      ExplicitLeft = 108
    end
    inherited deEnd: TcxDateEdit
      Left = 108
      Top = 29
      EditValue = 45658d
      Properties.SaveTime = False
      ExplicitLeft = 108
      ExplicitTop = 29
    end
    inherited cxLabel1: TcxLabel
      Left = 19
      ExplicitLeft = 19
    end
    inherited cxLabel2: TcxLabel
      Left = 0
      Top = 30
      ExplicitLeft = 0
      ExplicitTop = 30
    end
    object cxLabel4: TcxLabel
      Left = 501
      Top = 6
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074'.'#1088#1072#1089#1093'.:'
    end
    object edGoodsGroup: TcxButtonEdit
      Left = 596
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 147
    end
    object cxLabel3: TcxLabel
      Left = 194
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1086#1090' '#1082#1086#1075#1086'):'
    end
    object edFromGroup: TcxButtonEdit
      Left = 328
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 7
      Width = 169
    end
    object cxLabel5: TcxLabel
      Left = 208
      Top = 30
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1082#1086#1084#1091'):'
    end
    object edGoods: TcxButtonEdit
      Left = 812
      Top = 5
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 148
    end
    object edToGroup: TcxButtonEdit
      Left = 328
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 10
      Width = 169
    end
    object cbGroupMovement: TcxCheckBox
      Left = 966
      Top = 5
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#8470' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Properties.ReadOnly = True
      State = cbsChecked
      TabOrder = 11
      Width = 172
    end
    object cbGroupPartion: TcxCheckBox
      Left = 966
      Top = 29
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#8470' '#1087#1072#1088#1090#1080#1080
      Properties.ReadOnly = True
      State = cbsChecked
      TabOrder = 12
      Width = 145
    end
    object cxLabel6: TcxLabel
      Left = 501
      Top = 32
      Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074'.'#1087#1088#1080#1093':'
    end
    object cxLabel8: TcxLabel
      Left = 747
      Top = 6
      Caption = #1058#1086#1074#1072#1088' '#1088#1072#1089#1093':'
    end
    object edChildGoods: TcxButtonEdit
      Left = 812
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 15
      Width = 148
    end
    object edChildGoodsGroup: TcxButtonEdit
      Left = 596
      Top = 29
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 16
      Width = 147
    end
    object cbStorageLine: TcxCheckBox
      Left = 1113
      Top = 5
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1051#1080#1085#1080#1102' '#1087#1088'-'#1074#1072
      Properties.ReadOnly = False
      TabOrder = 17
      Width = 144
    end
    object cbCalculated: TcxCheckBox
      Left = 1113
      Top = 29
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' "'#1056#1072#1089#1095#1080#1090#1099#1074#1072#1102#1090#1089#1103'"'
      TabOrder = 18
      Width = 178
    end
    object cbisDetail: TcxCheckBox
      Left = 1263
      Top = 5
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1088#1072#1089#1093#1086#1076
      Properties.ReadOnly = False
      TabOrder = 19
      Width = 112
    end
  end
  object cxLabel7: TcxLabel [2]
    Left = 747
    Top = 30
    Caption = #1058#1086#1074#1072#1088' '#1087#1088#1080#1093':'
  end
  object PanelSearch: TPanel [3]
    Left = 0
    Top = 83
    Width = 1508
    Height = 41
    Align = alTop
    TabOrder = 7
    object lbSearchCode: TcxLabel
      Left = 0
      Top = 10
      Caption = #1055#1086#1080#1089#1082' '#1055#1086#1089#1090#1072#1074#1097#1080#1082': '
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchFromPartion: TcxTextEdit
      Left = 138
      Top = 10
      TabOrder = 1
      DesignSize = (
        195
        21)
      Width = 195
    end
    object lbSearchName: TcxLabel
      Left = 342
      Top = 10
      Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072' '#1087#1088#1080#1093#1086#1076':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchCodeIn: TcxTextEdit
      Left = 484
      Top = 10
      TabOrder = 3
      DesignSize = (
        140
        21)
      Width = 140
    end
    object cxLabel10: TcxLabel
      Left = 645
      Top = 10
      Caption = #1050#1086#1076' '#1090#1086#1074#1072#1088#1072' '#1088#1072#1089#1093#1086#1076':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
    object edSearchCodeOut: TcxTextEdit
      Left = 787
      Top = 10
      TabOrder = 5
      DesignSize = (
        144
        21)
      Width = 144
    end
    object edSerchPartionGoods: TcxTextEdit
      Left = 1011
      Top = 10
      TabOrder = 6
      DesignSize = (
        147
        21)
      Width = 147
    end
    object cxLabel11: TcxLabel
      Left = 949
      Top = 10
      Caption = #1055#1072#1088#1090#1080#1103':'
      ParentFont = False
      Style.Font.Charset = DEFAULT_CHARSET
      Style.Font.Color = clBlue
      Style.Font.Height = -13
      Style.Font.Name = 'Tahoma'
      Style.Font.Style = [fsBold]
      Style.IsFontAssigned = True
    end
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
      item
        Component = cbGroupMovement
        Properties.Strings = (
          'Checked')
      end
      item
        Component = cbGroupPartion
        Properties.Strings = (
          'Checked')
      end
      item
        Component = ChildGoodsGroupGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = ChildGoodsGuides
        Properties.Strings = (
          'Key'
          'TextValue')
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
      end
      item
        Component = FromGroupGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GoodsGroupGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = GoodsGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = ToGroupGuides
        Properties.Strings = (
          'Key'
          'TextValue')
      end>
  end
  inherited ActionList: TActionList
    object actPrint_test_4218: TdsdPrintAction [0]
      Category = 'Print_act'
      MoveParams = <>
      StoredProc = Print_test_4218
      StoredProcList = <
        item
          StoredProc = Print_test_4218
        end>
      Caption = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1046#1042') test'
      Hint = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1046#1042') test'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
          IndexFieldNames = 
            'MovementId;GroupStatName;GoodsGroupCode;GoodsGroupNameFull;Goods' +
            'Name'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4218) '#1086#1090#1095#1077#1090
      ReportNameParam.Value = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4218) '#1086#1090#1095#1077#1090
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_4001_test: TdsdPrintAction [1]
      Category = 'Print_act'
      MoveParams = <>
      StoredProc = Print_test_4134
      StoredProcList = <
        item
          StoredProc = Print_test_4134
        end>
      Caption = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1057#1074#1080#1085#1080#1085#1072' '#1053#1050')test'
      Hint = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1057#1074#1080#1085#1080#1085#1072' '#1053#1050')test'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
          IndexFieldNames = 
            'MovementId;GroupStatName;GoodsGroupCode;GoodsGroupNameFull;Goods' +
            'Name'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4134) '#1086#1090#1095#1077#1090
      ReportNameParam.Value = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4134) '#1086#1090#1095#1077#1090
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_4134_AllPart: TdsdPrintAction [2]
      Category = 'Print_act'
      MoveParams = <>
      StoredProc = Print_test_4134_AllPart
      StoredProcList = <
        item
          StoredProc = Print_test_4134_AllPart
        end>
      Caption = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1087#1088'-/'#1086#1073'-) '#1042#1089#1077' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1080
      Hint = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1087#1088'-/'#1086#1073'-) '#1042#1089#1077' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1080
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
          IndexFieldNames = 
            'MovementId;GroupStatName;GoodsGroupCode;GoodsGroupNameFull;Goods' +
            'Name'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4134) '#1086#1090#1095#1077#1090
      ReportNameParam.Value = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4134) '#1086#1090#1095#1077#1090
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_4134_All: TdsdPrintAction [4]
      Category = 'Print_act'
      MoveParams = <>
      StoredProc = Print_test_4134_All
      StoredProcList = <
        item
          StoredProc = Print_test_4134_All
        end>
      Caption = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1087#1088'-/'#1086#1073'-) '#1087#1086' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1091
      Hint = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1087#1088'-/'#1086#1073'-) '#1087#1086' '#1055#1086#1089#1090#1072#1074#1097#1080#1082#1091
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
          IndexFieldNames = 
            'MovementId;GroupStatName;GoodsGroupCode;GoodsGroupNameFull;Goods' +
            'Name'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4134) '#1086#1090#1095#1077#1090'All'
      ReportNameParam.Value = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4134) '#1086#1090#1095#1077#1090'All'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_4134_part: TdsdPrintAction [5]
      Category = 'Print_act'
      MoveParams = <>
      StoredProc = Print_test_4134_part
      StoredProcList = <
        item
          StoredProc = Print_test_4134_part
        end>
      Caption = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1057#1074#1080#1085#1080#1085#1072' '#1053#1050') ('#1048#1090#1086#1075#1086'***)'
      Hint = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1057#1074#1080#1085#1080#1085#1072' '#1053#1050')'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
          IndexFieldNames = 
            'MovementId;GroupStatName;GoodsGroupCode;GoodsGroupNameFull;Goods' +
            'Name'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4134) '#1086#1090#1095#1077#1090
      ReportNameParam.Value = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4134) '#1086#1090#1095#1077#1090
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_4134_grPart: TdsdPrintAction [6]
      Category = 'Print_act'
      MoveParams = <>
      StoredProc = Print_test_4134_grPart
      StoredProcList = <
        item
          StoredProc = Print_test_4134_grPart
        end>
      Caption = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1087#1088'-/'#1086#1073'-)'
      Hint = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1087#1088'-/'#1086#1073'-)'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
          IndexFieldNames = 
            'MovementId;GroupStatName;GoodsGroupCode;GoodsGroupNameFull;Goods' +
            'Name'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4134) '#1086#1090#1095#1077#1090
      ReportNameParam.Value = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4134) '#1086#1090#1095#1077#1090
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_4001_gov_gr: TdsdPrintAction [7]
      Category = 'Print_act'
      MoveParams = <>
      StoredProc = Print_test_4001_gr
      StoredProcList = <
        item
          StoredProc = Print_test_4001_gr
        end>
      Caption = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1043#1086#1074#1103#1076#1080#1085#1072') ('#1080#1090#1086#1075#1086')'
      Hint = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1043#1086#1074#1103#1076#1080#1085#1072')'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
          IndexFieldNames = 
            'MovementId;GroupStatName;GoodsGroupCode;GoodsGroupNameFull;Goods' +
            'Name'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4001) '#1086#1090#1095#1077#1090
      ReportNameParam.Value = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4001) '#1086#1090#1095#1077#1090
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_4134_gr: TdsdPrintAction [8]
      Category = 'Print_act'
      MoveParams = <>
      StoredProc = Print_test_4134_gr
      StoredProcList = <
        item
          StoredProc = Print_test_4134_gr
        end>
      Caption = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1057#1074#1080#1085#1080#1085#1072' '#1053#1050') ('#1080#1090#1086#1075#1086')'
      Hint = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1057#1074#1080#1085#1080#1085#1072' '#1053#1050')'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
          IndexFieldNames = 
            'MovementId;GroupStatName;GoodsGroupCode;GoodsGroupNameFull;Goods' +
            'Name'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4134) '#1086#1090#1095#1077#1090
      ReportNameParam.Value = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4134) '#1086#1090#1095#1077#1090
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_4218_gr: TdsdPrintAction [9]
      Category = 'Print_act'
      MoveParams = <>
      StoredProc = Print_test_4218_gr
      StoredProcList = <
        item
          StoredProc = Print_test_4218_gr
        end>
      Caption = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1046#1042') ('#1080#1090#1086#1075#1086')'
      Hint = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1046#1042')'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
          IndexFieldNames = 
            'MovementId;GroupStatName;GoodsGroupCode;GoodsGroupNameFull;Goods' +
            'Name'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4218) '#1086#1090#1095#1077#1090
      ReportNameParam.Value = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4218) '#1086#1090#1095#1077#1090
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_its_gr: TdsdPrintAction
      Category = 'Print_act'
      MoveParams = <>
      StoredProc = Print_test_its_gr
      StoredProcList = <
        item
          StoredProc = Print_test_its_gr
        end>
      Caption = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1087#1088#1086#1095#1077#1077') ('#1080#1090#1086#1075#1086')'
      Hint = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1087#1088#1086#1095#1077#1077')'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
          IndexFieldNames = 'MovementId;PartionGoods;GroupStatName;GoodsName'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (its) '#1086#1090#1095#1077#1090
      ReportNameParam.Value = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (its) '#1086#1090#1095#1077#1090
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_4001_gov_mov: TdsdPrintAction
      Category = 'Print_act'
      MoveParams = <>
      StoredProc = Print_test_4001_mov
      StoredProcList = <
        item
          StoredProc = Print_test_4001_mov
        end>
      Caption = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1043#1086#1074#1103#1076#1080#1085#1072')'
      Hint = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1043#1086#1074#1103#1076#1080#1085#1072')'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
          IndexFieldNames = 
            'MovementId;GroupStatName;GoodsGroupCode;GoodsGroupNameFull;Goods' +
            'Name'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4001) '#1086#1090#1095#1077#1090
      ReportNameParam.Value = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4001) '#1086#1090#1095#1077#1090
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_4218_mov: TdsdPrintAction
      Category = 'Print_act'
      MoveParams = <>
      StoredProc = Print_test_4218_mov
      StoredProcList = <
        item
          StoredProc = Print_test_4218_mov
        end>
      Caption = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1046#1042')'
      Hint = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1046#1042')'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
          IndexFieldNames = 
            'MovementId;GroupStatName;GoodsGroupCode;GoodsGroupNameFull;Goods' +
            'Name'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4218) '#1086#1090#1095#1077#1090
      ReportNameParam.Value = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4218) '#1086#1090#1095#1077#1090
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrintTotal: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1056#1072#1089#1093#1086#1076'/'#1055#1088#1080#1093#1086#1076' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' ('#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077') '#1048#1090#1086#1075
      Hint = #1054#1090#1095#1077#1090' '#1056#1072#1089#1093#1086#1076'/'#1055#1088#1080#1093#1086#1076' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' ('#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077') '#1048#1090#1086#1075
      ImageIndex = 16
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'ChildGoodsGroupName;ChildGoodsName'
          GridView = cxGridDBTableView
        end>
      Params = <
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
          Name = 'ReportType'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = ''
          Component = FromGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = ''
          Component = ToGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GoodsGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GoodsGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1055#1088#1080#1093#1086#1076'_'#1056#1072#1089#1093#1086#1076'_'#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'_'#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'_'#1048#1090#1086#1075
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1055#1088#1080#1093#1086#1076'_'#1056#1072#1089#1093#1086#1076'_'#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'_'#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'_'#1048#1090#1086#1075
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_4134_mov: TdsdPrintAction
      Category = 'Print_act'
      MoveParams = <>
      StoredProc = Print_test_4134_mov
      StoredProcList = <
        item
          StoredProc = Print_test_4134_mov
        end>
      Caption = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1057#1074#1080#1085#1080#1085#1072' '#1053#1050')'
      Hint = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1057#1074#1080#1085#1080#1085#1072' '#1053#1050')'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
          IndexFieldNames = 
            'MovementId;GroupStatName;GoodsGroupCode;GoodsGroupNameFull;Goods' +
            'Name'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4134) '#1086#1090#1095#1077#1090
      ReportNameParam.Value = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4134) '#1086#1090#1095#1077#1090
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_its_mov: TdsdPrintAction
      Category = 'Print_act'
      MoveParams = <>
      StoredProc = Print_test_its_mov
      StoredProcList = <
        item
          StoredProc = Print_test_its_mov
        end>
      Caption = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1087#1088#1086#1095#1077#1077') '
      Hint = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1087#1088#1086#1095#1077#1077')'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
          IndexFieldNames = 'MovementId;PartionGoods;GroupStatName;GoodsName'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (its) '#1086#1090#1095#1077#1090
      ReportNameParam.Value = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (its) '#1086#1090#1095#1077#1090
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_4001_gov: TdsdPrintAction
      Category = 'Print_act'
      MoveParams = <>
      StoredProc = Print_test_4001
      StoredProcList = <
        item
          StoredProc = Print_test_4001
        end>
      Caption = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1043#1086#1074#1103#1076#1080#1085#1072')'
      Hint = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1043#1086#1074#1103#1076#1080#1085#1072')'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
          IndexFieldNames = 
            'MovementId;GroupStatName;GoodsGroupCode;GoodsGroupNameFull;Goods' +
            'Name'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4001) '#1086#1090#1095#1077#1090
      ReportNameParam.Value = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4001) '#1086#1090#1095#1077#1090
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint: TdsdPrintAction
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <>
      Caption = #1054#1090#1095#1077#1090' '#1056#1072#1089#1093#1086#1076'/'#1055#1088#1080#1093#1086#1076' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' ('#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077')'
      Hint = #1054#1090#1095#1077#1090' '#1056#1072#1089#1093#1086#1076'/'#1055#1088#1080#1093#1086#1076' '#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' ('#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077')'
      ImageIndex = 3
      ShortCut = 16464
      DataSets = <
        item
          UserName = 'frxDBDMaster'
          GridView = cxGridDBTableView
        end>
      Params = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ReportType'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromName'
          Value = Null
          Component = FromGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToName'
          Value = Null
          Component = ToGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = GoodsGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = GoodsGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      ReportName = #1054#1090#1095#1077#1090'_'#1055#1088#1080#1093#1086#1076'_'#1056#1072#1089#1093#1086#1076'_'#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'_'#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      ReportNameParam.Value = #1054#1090#1095#1077#1090'_'#1055#1088#1080#1093#1086#1076'_'#1056#1072#1089#1093#1086#1076'_'#1087#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086'_'#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_GoodsMI_ProductionSeparate_TotalDialogForm'
      FormNameParam.Value = 'TReport_GoodsMI_ProductionSeparate_TotalDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41640d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'EndDate'
          Value = 41640d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromGroupId'
          Value = ''
          Component = FromGroupGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'FromGroupName'
          Value = ''
          Component = FromGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToGroupId'
          Value = ''
          Component = ToGroupGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ToGroupName'
          Value = ''
          Component = ToGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = ''
          Component = GoodsGroupGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = ''
          Component = GoodsGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ChildGoodsGroupId'
          Value = ''
          Component = ChildGoodsGroupGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ChildGoodsGroupName'
          Value = ''
          Component = ChildGoodsGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = ''
          Component = GoodsGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = ''
          Component = GoodsGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ChildGoodsId'
          Value = ''
          Component = ChildGoodsGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ChildGoodsName'
          Value = ''
          Component = ChildGoodsGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGroupMovement'
          Value = False
          Component = cbGroupMovement
          DataType = ftBoolean
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGroupPartion'
          Value = False
          Component = cbGroupPartion
          DataType = ftBoolean
          ParamType = ptInputOutput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isCalculated'
          Value = Null
          Component = cbCalculated
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isDetail'
          Value = Null
          Component = cbisDetail
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
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
          Name = 'UnitGroupId'
          Value = ''
          Component = FromGroupGuides
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitGroupName'
          Value = ''
          Component = FromGroupGuides
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationId'
          Value = '0'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'LocationName'
          Value = Null
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsGroupName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsGroupName'
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
    object actPrint_4218: TdsdPrintAction
      Category = 'Print_act'
      MoveParams = <>
      StoredProc = Print_test_4218
      StoredProcList = <
        item
          StoredProc = Print_test_4218
        end>
      Caption = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1046#1042')'
      Hint = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1046#1042')'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
          IndexFieldNames = 
            'MovementId;GroupStatName;GoodsGroupCode;GoodsGroupNameFull;Goods' +
            'Name'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4218) '#1086#1090#1095#1077#1090
      ReportNameParam.Value = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4218) '#1086#1090#1095#1077#1090
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_4134: TdsdPrintAction
      Category = 'Print_act'
      MoveParams = <>
      StoredProc = Print_test_4134
      StoredProcList = <
        item
          StoredProc = Print_test_4134
        end>
      Caption = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1057#1074#1080#1085#1080#1085#1072' '#1053#1050')'
      Hint = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1057#1074#1080#1085#1080#1085#1072' '#1053#1050')'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
          IndexFieldNames = 
            'MovementId;GroupStatName;GoodsGroupCode;GoodsGroupNameFull;Goods' +
            'Name'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4134) '#1086#1090#1095#1077#1090
      ReportNameParam.Value = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (4134) '#1086#1090#1095#1077#1090
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actPrint_its: TdsdPrintAction
      Category = 'Print_act'
      MoveParams = <>
      StoredProc = Print_test_its
      StoredProcList = <
        item
          StoredProc = Print_test_its
        end>
      Caption = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1087#1088#1086#1095#1077#1077')'
      Hint = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' ('#1087#1088#1086#1095#1077#1077')'
      ImageIndex = 15
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
          IndexFieldNames = 'MovementId;GroupStatName;GoodsGroupCode;GoodsName'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
        end>
      Params = <
        item
          Name = 'Id'
          Value = '0'
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'isGroupPrint'
          Value = Null
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end>
      ReportName = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (its) '#1086#1090#1095#1077#1090
      ReportNameParam.Value = #1040#1082#1090' '#1086#1073#1074#1072#1083#1082#1080' (its) '#1086#1090#1095#1077#1090
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actOpenFormProductionSeparate: TdsdOpenForm
      Category = 'DSDLib'
      TabSheet = tsMain
      MoveParams = <>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' <'#1055#1088#1086#1080#1079#1074#1086#1076#1089#1090#1074#1086' - '#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077'>'
      ImageIndex = 28
      FormName = 'TProductionSeparateForm'
      FormNameParam.Value = 'TProductionSeparateForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = '0'
          Component = MasterCDS
          ComponentItem = 'MovementId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ShowAll'
          Value = False
          DataType = ftBoolean
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 42094d
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          MultiSelectSeparator = ','
        end>
      isShowModal = False
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
    StoredProcName = 'gpReport_GoodsMI_ProductionSeparate_Total'
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
        Name = 'inIsMovement'
        Value = Null
        Component = cbGroupMovement
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPartion'
        Value = Null
        Component = cbGroupPartion
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsStorageLine'
        Value = Null
        Component = cbStorageLine
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisCalculated'
        Value = Null
        Component = cbCalculated
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDetail'
        Value = Null
        Component = cbisDetail
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsGroupId'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = GoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChildGoodsGroupId'
        Value = Null
        Component = ChildGoodsGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChildGoodsId'
        Value = Null
        Component = ChildGoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = Null
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
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
          ItemName = 'bbReport_Goods'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bOpenFormProductionSeparate'
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
          ItemName = 'bbPrintTotal'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbsPrintMovement'
        end
        item
          Visible = True
          ItemName = 'bbsPrint'
        end
        item
          Visible = True
          ItemName = 'bbs'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem1'
        end
        item
          Visible = True
          ItemName = 'dxBarSubItem2'
        end
        item
          Visible = True
          ItemName = 'bbDetail'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbLabel9'
        end
        item
          Visible = True
          ItemName = 'bbPriceListNorm'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbGridToExcel'
        end>
    end
    object bbPrint: TdxBarButton
      Action = actPrint
      Category = 0
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
    object bbPrintTotal: TdxBarButton
      Action = actPrintTotal
      Category = 0
    end
    object bbReport_Goods: TdxBarButton
      Action = actReport_Goods
      Category = 0
    end
    object bbsPrint: TdxBarSubItem
      Caption = #1055#1077#1095#1072#1090#1100' ('#1087#1086' 1-'#1084#1091' '#1076#1086#1082'. '#1079#1072' '#1087#1077#1088#1080#1086#1076')'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbPrint_4001_gov'
        end
        item
          Visible = True
          ItemName = 'bbPrint_4218'
        end
        item
          Visible = True
          ItemName = 'bbPrint_4134'
        end
        item
          Visible = True
          ItemName = 'bbPrint_its'
        end>
    end
    object bbPrint_its: TdxBarButton
      Action = actPrint_its
      Category = 0
    end
    object bbPriceListNorm: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = edPriceListNorm
    end
    object bbLabel9: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cxLabel9
    end
    object bbGroupPrint: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
    end
    object bbPrint_its_mov: TdxBarButton
      Action = actPrint_its_mov
      Category = 0
    end
    object bbPrint_4001_gov: TdxBarButton
      Action = actPrint_4001_gov
      Category = 0
    end
    object bbPrint_4134: TdxBarButton
      Action = actPrint_4134
      Category = 0
    end
    object bbPrint_4218: TdxBarButton
      Action = actPrint_4218
      Category = 0
    end
    object bbSeparator: TdxBarSeparator
      Caption = 'bbSeparator'
      Category = 0
      Hint = 'bbSeparator'
      Visible = ivAlways
      ShowCaption = False
    end
    object bbPrint_test: TdxBarButton
      Action = actPrint_4001_test
      Category = 0
    end
    object bbtPrint_test_4218: TdxBarButton
      Action = actPrint_test_4218
      Category = 0
    end
    object bbsPrintMovement: TdxBarSubItem
      Caption = #1055#1077#1095#1072#1090#1100' ('#1076#1083#1103' 1-'#1086#1075#1086' '#1076#1086#1082'.)'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbPrint_4001_gov_mov'
        end
        item
          Visible = True
          ItemName = 'bbPrint_4218_mov'
        end
        item
          Visible = True
          ItemName = 'bbPrint_4134_mov'
        end
        item
          Visible = True
          ItemName = 'bbPrint_its_mov'
        end>
    end
    object bbPrint_4001_gov_mov: TdxBarButton
      Action = actPrint_4001_gov_mov
      Category = 0
    end
    object bbPrint_4134_mov: TdxBarButton
      Action = actPrint_4134_mov
      Category = 0
    end
    object bbPrint_4218_mov: TdxBarButton
      Action = actPrint_4218_mov
      Category = 0
    end
    object bbs: TdxBarSubItem
      Caption = #1055#1077#1095#1072#1090#1100' ('#1080#1090#1086#1075' '#1087#1086' 1-'#1086#1081' '#1087#1072#1088#1090#1080#1080')'
      Category = 0
      Hint = #1055#1077#1095#1072#1090#1100' ('#1080#1090#1086#1075')'
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbPrint_4001_gov_gr'
        end
        item
          Visible = True
          ItemName = 'bbPrint_4218_gr'
        end
        item
          Visible = True
          ItemName = 'bbPrint_4134_gr'
        end
        item
          Visible = True
          ItemName = 'bbPrint_its_gr'
        end>
    end
    object bbPrint_4001_gov_gr: TdxBarButton
      Action = actPrint_4001_gov_gr
      Category = 0
    end
    object bbPrint_4134_gr: TdxBarButton
      Action = actPrint_4134_gr
      Category = 0
    end
    object bbPrint_4218_gr: TdxBarButton
      Action = actPrint_4218_gr
      Category = 0
    end
    object bbPrint_its_gr: TdxBarButton
      Action = actPrint_its_gr
      Category = 0
    end
    object bOpenFormProductionSeparate: TdxBarButton
      Action = actOpenFormProductionSeparate
      Category = 0
    end
    object dxBarSubItem1: TdxBarSubItem
      Caption = #1055#1077#1095#1072#1090#1100' ('#1080#1090#1086#1075' '#1087#1086' 1-'#1086#1081' '#1087#1072#1088#1090#1080#1080' '#1087#1088'-/'#1086#1073'-) '
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbPrint_4134_grPart'
        end>
    end
    object bbPrint_4134_part: TdxBarButton
      Action = actPrint_4134_part
      Category = 0
      Visible = ivNever
    end
    object bbPrint_4134_grPart: TdxBarButton
      Action = actPrint_4134_grPart
      Category = 0
    end
    object dxBarButton1: TdxBarButton
      Action = actPrint_4134_All
      Category = 0
    end
    object dxBarButton2: TdxBarButton
      Action = actPrint_4134_AllPart
      Category = 0
    end
    object bbDetail: TdxBarControlContainerItem
      Caption = 'New Item'
      Category = 0
      Hint = 'New Item'
      Visible = ivAlways
      Control = cbDetailPrint
    end
    object dxBarSubItem2: TdxBarSubItem
      Caption = #1055#1077#1095#1072#1090#1100' ('#1080#1090#1086#1075')'
      Category = 0
      Visible = ivAlways
      ItemLinks = <
        item
          Visible = True
          ItemName = 'dxBarButton1'
        end
        item
          Visible = True
          ItemName = 'bbSeparator'
        end
        item
          Visible = True
          ItemName = 'dxBarButton2'
        end>
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 320
    Top = 232
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 72
    Top = 176
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = cbGroupMovement
      end
      item
        Component = cbGroupPartion
      end
      item
        Component = ChildGoodsGroupGuides
      end
      item
        Component = ChildGoodsGuides
      end
      item
        Component = FromGroupGuides
      end
      item
        Component = ToGroupGuides
      end
      item
        Component = GoodsGuides
      end
      item
        Component = GoodsGroupGuides
      end
      item
      end
      item
        Component = cbisDetail
      end>
    Left = 232
    Top = 200
  end
  object GoodsGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoodsGroup
    FormNameParam.Value = 'TGoodsGroup_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroup_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 616
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'InDescName'
        Value = ''
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGroupMovement'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListId_norm'
        Value = '12048635'
        Component = GuidesPriceListNorm
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceListName_norm'
        Value = #1053#1054#1056#1052#1040' '#1042#1067#1061#1054#1044#1054#1042' '#1086#1073#1074#1072#1083#1082#1072
        Component = GuidesPriceListNorm
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 328
    Top = 170
  end
  object FromGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edFromGroup
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'TreeDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 408
  end
  object GoodsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edGoods
    FormNameParam.Value = 'TGoodsFuel_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsFuel_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 848
    Top = 65531
  end
  object ToGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edToGroup
    FormNameParam.Value = 'TUnitTreeForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnitTreeForm'
    PositionDataSet = 'ClientDataSet'
    ParentDataSet = 'TreeDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 424
    Top = 8
  end
  object ChildGoodsGroupGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edChildGoodsGroup
    FormNameParam.Value = 'TGoodsGroup_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsGroup_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ChildGoodsGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ChildGoodsGroupGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 744
    Top = 8
  end
  object ChildGoodsGuides: TdsdGuides
    KeyField = 'Id'
    LookupControl = edChildGoods
    FormNameParam.Value = 'TGoodsFuel_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TGoodsFuel_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = ChildGoodsGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = ChildGoodsGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 904
    Top = 19
  end
  object GuidesPriceListNorm: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPriceListNorm
    FormNameParam.Value = 'TPriceListForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPriceListForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = FormParams
        ComponentItem = 'PriceListId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = FormParams
        ComponentItem = 'PriceListName'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 504
    Top = 232
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 668
    Top = 233
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 652
    Top = 278
  end
  object spSelectPrint_its: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ProductionSeparate_Print_byReport'
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
        Name = 'inFromId'
        Value = Null
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = Null
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_norm'
        Value = Null
        Component = GuidesPriceListNorm
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = '0'
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
        Name = 'inIsPartion'
        Value = Null
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1111
    Top = 232
  end
  object spSelectPrint_its_mov: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ProductionSeparate_Print_byReport'
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
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_norm'
        Value = ''
        Component = GuidesPriceListNorm
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPartion'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1119
    Top = 176
  end
  object spSelectPrint_4001: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ProductionSeparate_Print_byReport'
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
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_norm'
        Value = ''
        Component = GuidesPriceListNorm
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = '4234'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPartion'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1063
    Top = 208
  end
  object spSelectPrint_4218: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ProductionSeparate_Print_byReport'
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
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_norm'
        Value = ''
        Component = GuidesPriceListNorm
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = '5225'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPartion'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1047
    Top = 168
  end
  object spSelectPrint_4134: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ProductionSeparate_Print_byReport'
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
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_norm'
        Value = ''
        Component = GuidesPriceListNorm
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = '4261'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPartion'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1199
    Top = 216
  end
  object Print_test_4001: TdsdStoredProc
    StoredProcName = 'gpSelect_ProductionSeparate_Print_byReport_Test'
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
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_norm'
        Value = ''
        Component = GuidesPriceListNorm
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = '4234'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGroup'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods_main'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main2'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 887
    Top = 248
  end
  object Print_test_4218: TdsdStoredProc
    StoredProcName = 'gpSelect_ProductionSeparate_Print_byReport_Test'
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
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_norm'
        Value = ''
        Component = GuidesPriceListNorm
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = '5225'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGroup'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods_main'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main2'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 959
    Top = 248
  end
  object Print_test_4134: TdsdStoredProc
    StoredProcName = 'gpSelect_ProductionSeparate_Print_byReport_Test'
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
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_norm'
        Value = ''
        Component = GuidesPriceListNorm
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = '4261'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGroup'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods_main'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main2'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1015
    Top = 248
  end
  object Print_test_its: TdsdStoredProc
    StoredProcName = 'gpSelect_ProductionSeparate_Print_byReport_Test'
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
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_norm'
        Value = ''
        Component = GuidesPriceListNorm
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = '5225'
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGroup'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods_main'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main2'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 807
    Top = 240
  end
  object Print_test_its_mov: TdsdStoredProc
    StoredProcName = 'gpSelect_ProductionSeparate_Print_byReport_Test'
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
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_norm'
        Value = ''
        Component = GuidesPriceListNorm
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'MovementId'
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
        Name = 'inisGroup'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods_main'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main2'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 783
    Top = 296
  end
  object Print_test_4001_mov: TdsdStoredProc
    StoredProcName = 'gpSelect_ProductionSeparate_Print_byReport_Test'
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
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_norm'
        Value = ''
        Component = GuidesPriceListNorm
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = '4234'
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGroup'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods_main'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main2'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 871
    Top = 296
  end
  object Print_test_4218_mov: TdsdStoredProc
    StoredProcName = 'gpSelect_ProductionSeparate_Print_byReport_Test'
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
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_norm'
        Value = ''
        Component = GuidesPriceListNorm
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = '5225'
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGroup'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods_main'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main2'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 959
    Top = 296
  end
  object Print_test_4134_mov: TdsdStoredProc
    StoredProcName = 'gpSelect_ProductionSeparate_Print_byReport_Test'
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
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_norm'
        Value = ''
        Component = GuidesPriceListNorm
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = '0'
        Component = MasterCDS
        ComponentItem = 'MovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = '4261'
        Component = MasterCDS
        ComponentItem = 'GoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisGroup'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods_main'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main2'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1023
    Top = 296
  end
  object Print_test_its_gr: TdsdStoredProc
    StoredProcName = 'gpSelect_ProductionSeparate_Print_byReport_Test'
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
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_norm'
        Value = ''
        Component = GuidesPriceListNorm
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
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
        Name = 'inisGroup'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods_main'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main2'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 735
    Top = 352
  end
  object Print_test_4001_gr: TdsdStoredProc
    StoredProcName = 'gpSelect_ProductionSeparate_Print_byReport_Test'
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
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_norm'
        Value = ''
        Component = GuidesPriceListNorm
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
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
        Name = 'inisGroup'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods_main'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main2'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 855
    Top = 352
  end
  object Print_test_4218_gr: TdsdStoredProc
    StoredProcName = 'gpSelect_ProductionSeparate_Print_byReport_Test'
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
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_norm'
        Value = ''
        Component = GuidesPriceListNorm
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
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
        Name = 'inisGroup'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods_main'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main2'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 943
    Top = 352
  end
  object Print_test_4134_gr: TdsdStoredProc
    StoredProcName = 'gpSelect_ProductionSeparate_Print_byReport_Test'
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
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_norm'
        Value = ''
        Component = GuidesPriceListNorm
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
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
        Name = 'inisGroup'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods_main'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main2'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 1023
    Top = 352
  end
  object FieldFilter_Search: TdsdFieldFilter
    TextEdit = edSearchFromPartion
    DataSet = MasterCDS
    Column = FromName_partion
    ColumnList = <
      item
        Column = FromName_partion
      end
      item
        Column = GoodsCode
        TextEdit = edSearchCodeOut
      end
      item
        Column = ChildGoodsCode
        TextEdit = edSearchCodeIn
      end
      item
        Column = PartionGoods
        TextEdit = edSerchPartionGoods
      end>
    CheckBoxList = <>
    Left = 576
    Top = 96
  end
  object Print_test_4134_part: TdsdStoredProc
    StoredProcName = 'gpSelect_ProductionSeparate_Print_byReport_TotalPart'
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
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_norm'
        Value = ''
        Component = GuidesPriceListNorm
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
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
        Name = 'inisGroup'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods_main2'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 455
    Top = 320
  end
  object Print_test_4134_grPart: TdsdStoredProc
    StoredProcName = 'gpSelect_ProductionSeparate_Print_byReport_Test'
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
        Name = 'inStartDate'
        Value = 42370d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 42370d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_norm'
        Value = ''
        Component = GuidesPriceListNorm
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
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
        Name = 'inisGroup'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods_main'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods_main2'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 567
    Top = 328
  end
  object Print_test_4134_All: TdsdStoredProc
    StoredProcName = 'gpSelect_ProductionSeparate_Print_byReport_Test_all_1'
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
        Name = 'inStartDate'
        Value = 45658d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 45658d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_norm'
        Value = ''
        Component = GuidesPriceListNorm
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
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
        Name = 'inisGroup'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAll'
        Value = False
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDetail'
        Value = True
        Component = cbDetailPrint
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods_main'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods_main2'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 567
    Top = 392
  end
  object Print_test_4134_AllPart: TdsdStoredProc
    StoredProcName = 'gpSelect_ProductionSeparate_Print_byReport_Test_all_1'
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
        Name = 'inStartDate'
        Value = 45658d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inEndDate'
        Value = 45658d
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inFromId'
        Value = ''
        Component = FromGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inToId'
        Value = ''
        Component = ToGroupGuides
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceListId_norm'
        Value = ''
        Component = GuidesPriceListNorm
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
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
        Name = 'inisGroup'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisAll'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisDetail'
        Value = Null
        Component = cbDetailPrint
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods_main'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPartionGoods_main2'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PartionGoods_main2'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 567
    Top = 424
  end
end
