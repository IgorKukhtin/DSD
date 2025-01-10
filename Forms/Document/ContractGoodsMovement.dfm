inherited ContractGoodsMovementForm: TContractGoodsMovementForm
  Caption = #1044#1086#1082#1091#1084#1077#1085#1090' <'#1058#1086#1074#1072#1088#1099' '#1074' '#1076#1086#1075#1086#1074#1086#1088#1072#1093' ('#1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103')>'
  ClientHeight = 596
  ClientWidth = 1204
  ExplicitWidth = 1220
  ExplicitHeight = 635
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 117
    Width = 1204
    Height = 479
    ExplicitTop = 117
    ExplicitWidth = 1204
    ExplicitHeight = 479
    ClientRectBottom = 479
    ClientRectRight = 1204
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1204
      ExplicitHeight = 455
      inherited cxGrid: TcxGrid
        Width = 1204
        Height = 455
        ExplicitWidth = 1204
        ExplicitHeight = 455
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
              Format = #1057#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
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
          object isSale: TcxGridDBColumn [0]
            Caption = #1045#1089#1090#1100' '#1074' '#1087#1088#1086#1076#1072#1078#1077
            DataBinding.FieldName = 'isSale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1045#1089#1090#1100' '#1074' '#1087#1088#1086#1076#1072#1078#1077
            Options.Editing = False
            Width = 70
          end
          object GoodsGroupNameFull: TcxGridDBColumn [1]
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object GoodsCode: TcxGridDBColumn [2]
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object GoodsName: TcxGridDBColumn [3]
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Action = actGoods_ObjectChoiceForm
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 182
          end
          object GoodsKindName: TcxGridDBColumn [4]
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
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object MeasureName: TcxGridDBColumn [5]
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object Price: TcxGridDBColumn [6]
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object Price_curr: TcxGridDBColumn [7]
            Caption = #1062#1077#1085#1072' ('#1090#1077#1082#1091#1097#1072#1103')'
            DataBinding.FieldName = 'Price_curr'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object isSave: TcxGridDBColumn [8]
            Caption = #1057#1086#1093#1088#1072#1085#1077#1085
            DataBinding.FieldName = 'isSave'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object isBonusNo: TcxGridDBColumn [9]
            Caption = #1053#1077#1090' '#1085#1072#1095'. '#1087#1086' '#1073#1086#1085#1091#1089#1072#1084
            DataBinding.FieldName = 'isBonusNo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1085#1077#1090' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1087#1086' '#1073#1086#1085#1091#1089#1072#1084
            Width = 70
          end
          object Comment: TcxGridDBColumn [10]
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 110
          end
          object ChangePrice: TcxGridDBColumn [11]
            Caption = #1057#1082#1080#1076#1082#1072' '#1074' '#1094#1077#1085#1077
            DataBinding.FieldName = 'ChangePrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object ChangePercent: TcxGridDBColumn [12]
            Caption = '% '#1057#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'ChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object CountForAmount: TcxGridDBColumn [13]
            Caption = #1050#1086#1101#1092#1092' '#1087#1077#1088#1077#1074#1086#1076#1072
            DataBinding.FieldName = 'CountForAmount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1101#1092#1092' '#1087#1077#1088#1077#1074#1086#1076#1072' '#1080#1079' '#1082#1086#1083'-'#1074#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Width = 70
          end
          object CountForPrice: TcxGridDBColumn [14]
            Caption = #1050#1086#1083'. '#1074' '#1094#1077#1085#1077
            DataBinding.FieldName = 'CountForPrice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          inherited colIsErased: TcxGridDBColumn
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object msUpdateName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 97
          end
          object msUpdateDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' / '#1074#1088#1077#1084#1103' ('#1082#1086#1088#1088'.)'
            DataBinding.FieldName = 'UpdateDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object msInsertName: TcxGridDBColumn
            Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 97
          end
          object msInsertDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' / '#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076'.)'
            DataBinding.FieldName = 'InsertDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 93
          end
        end
      end
    end
  end
  inherited DataPanel: TPanel
    Width = 1204
    Height = 91
    TabOrder = 3
    ExplicitWidth = 1204
    ExplicitHeight = 91
    inherited edInvNumber: TcxTextEdit
      Left = 8
      ExplicitLeft = 8
      ExplicitWidth = 89
      Width = 89
    end
    inherited cxLabel1: TcxLabel
      Left = 8
      ExplicitLeft = 8
    end
    inherited edOperDate: TcxDateEdit
      Left = 109
      Properties.SaveTime = False
      Properties.ShowTime = False
      ExplicitLeft = 109
      ExplicitWidth = 84
      Width = 84
    end
    inherited cxLabel2: TcxLabel
      Left = 109
      Caption = #1044#1072#1090#1072' '#1089' ...'
      ExplicitLeft = 109
      ExplicitWidth = 53
    end
    inherited cxLabel15: TcxLabel
      Top = 45
      ExplicitTop = 45
    end
    inherited ceStatus: TcxButtonEdit
      Top = 62
      ExplicitTop = 62
      ExplicitWidth = 165
      ExplicitHeight = 22
      Width = 165
    end
    object cxLabel22: TcxLabel
      Left = 1038
      Top = 45
      Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
    end
    object ceComment: TcxTextEdit
      Left = 1038
      Top = 62
      TabOrder = 7
      Width = 146
    end
    object cxLabel8: TcxLabel
      Left = 918
      Top = 5
      Caption = #1044#1072#1090#1072'/'#1074#1088#1077#1084#1103' ('#1089#1086#1079#1076'.)'
    end
    object edInsertDate: TcxDateEdit
      Left = 918
      Top = 23
      EditValue = 42132d
      Properties.DisplayFormat = 'dd.mm.yyyy hh:mm'
      Properties.EditFormat = 'dd.mm.yyyy hh:mm'
      Properties.Kind = ckDateTime
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 112
    end
    object cxLabel7: TcxLabel
      Left = 1036
      Top = 0
      Caption = #1055#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100' ('#1089#1086#1079#1076'.)'
    end
    object edInsertName: TcxButtonEdit
      Left = 1038
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 146
    end
    object cxLabel27: TcxLabel
      Left = 298
      Top = 5
      Caption = #8470' '#1044#1086#1075#1086#1074#1086#1088#1072
    end
    object edContract: TcxButtonEdit
      Left = 298
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ClickKey = 0
      Properties.HideSelection = False
      Properties.ReadOnly = False
      TabOrder = 13
      Width = 105
    end
    object cxLabel3: TcxLabel
      Left = 298
      Top = 45
      Caption = #1070#1088'.'#1083#1080#1094#1086
    end
    object edJuridical: TcxButtonEdit
      Left = 298
      Top = 62
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 15
      Width = 173
    end
    object edContractTag: TcxButtonEdit
      Left = 570
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 16
      Width = 97
    end
    object cxLabel21: TcxLabel
      Left = 570
      Top = 5
      Caption = #1055#1088#1080#1079#1085#1072#1082' '#1076#1086#1075#1086#1074#1086#1088#1072
    end
    object cxLabel4: TcxLabel
      Left = 740
      Top = 5
      Caption = #1044#1077#1081#1089#1090#1074#1091#1077#1090' '#1089
    end
    object edStartDate_contract: TcxDateEdit
      Left = 740
      Top = 23
      EditValue = 0d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 19
      Width = 80
    end
    object edEndDate_contract: TcxDateEdit
      Left = 828
      Top = 23
      EditValue = 0d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 20
      Width = 80
    end
    object cxLabel6: TcxLabel
      Left = 828
      Top = 5
      Caption = #1044#1077#1081#1089#1090#1074#1091#1077#1090' '#1076#1086
    end
    object cxLabel11: TcxLabel
      Left = 407
      Top = 5
      Caption = #1050#1086#1076' '#1076#1086#1075'.'
    end
    object edContractCode: TcxCurrencyEdit
      Left = 407
      Top = 23
      Properties.DecimalPlaces = 0
      Properties.DisplayFormat = '0'
      Properties.ReadOnly = True
      TabOrder = 23
      Width = 58
    end
    object cxLabel9: TcxLabel
      Left = 469
      Top = 5
      Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1076#1086#1075'.'
    end
    object edContractStateKind: TcxButtonEdit
      Left = 470
      Top = 23
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 25
      Width = 94
    end
    object cxLabel14: TcxLabel
      Left = 179
      Top = 45
      Caption = #1042#1072#1083#1102#1090#1072' ('#1094#1077#1085#1072' '#1089#1087#1077#1094'.)'
    end
    object edCurrency: TcxButtonEdit
      Left = 180
      Top = 62
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 27
      Width = 107
    end
    object cxLabel12: TcxLabel
      Left = 478
      Top = 45
      Caption = '% '#1086#1090#1082'. '#1076#1083#1103' '#1094#1077#1085#1099
    end
    object edDiffPrice: TcxCurrencyEdit
      Left = 478
      Top = 62
      Hint = #1056#1072#1079#1088#1077#1096#1077#1085#1085#1099#1081' % '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1076#1083#1103' '#1094#1077#1085#1099
      ParentShowHint = False
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      ShowHint = True
      TabOrder = 29
      Width = 139
    end
    object cxLabel10: TcxLabel
      Left = 626
      Top = 45
      Caption = #1050#1086#1083'-'#1074#1086' '#1079#1085'. '#1086#1082#1088#1091#1075#1083'.'
    end
    object edRoundPrice: TcxCurrencyEdit
      Left = 626
      Top = 62
      Hint = #1050#1086#1083'-'#1074#1086' '#1079#1085#1072#1082#1086#1074' '#1076#1083#1103' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1103
      ParentShowHint = False
      Properties.DecimalPlaces = 4
      Properties.DisplayFormat = ',0.####'
      ShowHint = True
      TabOrder = 31
      Width = 105
    end
    object cxLabel13: TcxLabel
      Left = 918
      Top = 45
      Caption = #1050#1072#1090#1077#1075#1086#1088#1080#1103', '#1089#1072#1081#1090#1072
    end
    object edSiteTag: TcxButtonEdit
      Left = 918
      Top = 62
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 33
      Width = 112
    end
  end
  object cxLabel5: TcxLabel [2]
    Left = 203
    Top = 5
    Caption = #1044#1072#1090#1072' '#1087#1086' ...'
  end
  object edEndBeginDate: TcxDateEdit [3]
    Left = 203
    Top = 23
    EditValue = 42132d
    Properties.ReadOnly = True
    Properties.SaveTime = False
    Properties.ShowTime = False
    TabOrder = 7
    Width = 84
  end
  object edPriceWithVAT: TcxCheckBox [4]
    Left = 740
    Top = 48
    Caption = #1062#1077#1085#1072' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
    TabOrder = 8
    Width = 128
  end
  object cbMultWithVAT: TcxCheckBox [5]
    Left = 740
    Top = 70
    Caption = #1062#1077#1085#1072' '#1082#1088#1072#1090#1085#1072#1103' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
    TabOrder = 9
    Width = 166
  end
  object cxLabel16: TcxLabel [6]
    Left = 672
    Top = 5
    Caption = #1060#1054' '#1076#1086#1075'.'
  end
  object edPaidKind: TcxButtonEdit [7]
    Left = 672
    Top = 23
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 59
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 883
    Top = 232
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 40
    Top = 640
  end
  inherited ActionList: TActionList
    Left = 87
    Top = 255
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
    inherited actInsertUpdateMovement: TdsdExecStoredProc
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMovement
        end
        item
          StoredProc = spGet
        end>
    end
    inherited actUpdateMainDS: TdsdUpdateDataSet
      StoredProcList = <
        item
          StoredProc = spInsertUpdateMIMaster
        end
        item
          StoredProc = spSelect
        end
        item
        end>
    end
    object actPrintNoGroup: TdsdPrintAction [8]
      Category = 'DSDLib'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1055#1077#1095#1072#1090#1100' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      Hint = #1055#1077#1095#1072#1090#1100' ('#1076#1077#1090#1072#1083#1100#1085#1086')'
      ImageIndex = 16
      ShortCut = 16464
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
      ReportName = 'PrintMovement_Send'
      ReportNameParam.Value = 'PrintMovement_Send'
      ReportNameParam.DataType = ftString
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    inherited actPrint: TdsdPrintAction
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
          IndexFieldNames = 'UnitName;GoodsGroupNameFull;GoodsName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_OrderGoods'
      ReportNameParam.Value = 'PrintMovement_OrderGoods'
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
    object actGoodsKindChoice: TOpenChoiceForm [14]
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
    object actRefreshMI: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1055#1077#1088#1077#1095#1080#1090#1072#1090#1100
      Hint = #1054#1073#1085#1086#1074#1080#1090#1100' '#1076#1072#1085#1085#1099#1077
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actStorageChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'StorageForm'
      FormName = 'TStorage_ObjectForm'
      FormNameParam.Value = 'TStorage_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StorageId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'StorageName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actUnitChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'UnitForm'
      FormName = 'TUnit_ObjectForm'
      FormNameParam.Value = 'TUnit_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitId'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'UnitName'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actGoods_ObjectChoiceForm: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'Goods_Object'
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
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Code'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsCode'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'MeasureName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MeasureName'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'isSave'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'isSave'
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actGoodsKindCompleteChoice: TOpenChoiceForm
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      Caption = 'actGoodsKindCompleteChoiceMaster'
      FormName = 'TGoodsKind_ObjectForm'
      FormNameParam.Value = 'TGoodsKind_ObjectForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Key'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindId_Complete'
          MultiSelectSeparator = ','
        end
        item
          Name = 'TextValue'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsKindName_Complete'
          DataType = ftString
          MultiSelectSeparator = ','
        end>
      isShowModal = True
    end
    object actPrintSaleOrder: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1047#1072#1103#1074#1082#1072'/'#1086#1090#1075#1088#1091#1079#1082#1072
      Hint = #1047#1072#1103#1074#1082#1072'/'#1086#1090#1075#1088#1091#1079#1082#1072
      ImageIndex = 21
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_Sale_Order'
      ReportNameParam.Value = 'PrintMovement_Sale_Order'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object macUpdate_MI_ContractGoods_Save_Yes: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_MI_Save_Yes_List
        end
        item
          Action = actRefreshMI
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1084' '#1090#1086#1074#1072#1088#1072#1084' <'#1057#1086#1093#1088#1072#1085#1077#1085' '#1044#1040'>?'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1057#1086#1093#1088#1072#1085#1077#1085' '#1044#1040'>'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1057#1086#1093#1088#1072#1085#1077#1085' '#1044#1040'>'
      ImageIndex = 76
    end
    object actUpdate_MI_ContractGoods_Save_Yes: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_MI_ContractGoods_Save_Yes
      StoredProcList = <
        item
          StoredProc = spUpdate_MI_ContractGoods_Save_Yes
        end>
      Caption = 'actUpdate_MI_ContractGoods_Save_No'
    end
    object macUpdate_MI_ContractGoods_Save_No: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = macUpdate_MI_Save_No_List
        end
        item
          Action = actRefreshMI
        end>
      QuestionBeforeExecute = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1074#1099#1073#1088#1072#1085#1085#1099#1084' '#1090#1086#1074#1072#1088#1072#1084' <'#1057#1086#1093#1088#1072#1085#1077#1085' '#1053#1045#1058'> ('#1091#1076#1072#1083#1080#1090#1100')?'
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1057#1086#1093#1088#1072#1085#1077#1085' '#1053#1045#1058'> ('#1091#1076#1072#1083#1080#1090#1100')'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1057#1086#1093#1088#1072#1085#1077#1085' '#1053#1045#1058'> ('#1091#1076#1072#1083#1080#1090#1100')'
      ImageIndex = 77
    end
    object macUpdate_MI_Save_Yes_List: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_MI_ContractGoods_Save_Yes
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1057#1086#1093#1088#1072#1085#1077#1085' '#1044#1040'>'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1057#1086#1093#1088#1072#1085#1077#1085' '#1044#1040'>'
      ImageIndex = 76
    end
    object actPrintSaleOrderTax: TdsdPrintAction
      Category = 'Print'
      MoveParams = <>
      StoredProcList = <
        item
        end>
      Caption = #1054#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1085#1072' %'
      Hint = #1047#1072#1103#1074#1082#1072'/'#1086#1090#1075#1088#1091#1079#1082#1072' '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1085#1072' %'
      ImageIndex = 18
      DataSets = <
        item
          DataSet = PrintHeaderCDS
          UserName = 'frxDBDHeader'
        end
        item
          DataSet = PrintItemsCDS
          UserName = 'frxDBDMaster'
          IndexFieldNames = 'GoodsGroupNameFull;GoodsName'
        end>
      Params = <
        item
          Name = 'Id'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end>
      ReportName = 'PrintMovement_Sale_Order'
      ReportNameParam.Value = 'PrintMovement_Sale_Order'
      ReportNameParam.DataType = ftString
      ReportNameParam.ParamType = ptInput
      ReportNameParam.MultiSelectSeparator = ','
      PrinterNameParam.Value = ''
      PrinterNameParam.DataType = ftString
      PrinterNameParam.MultiSelectSeparator = ','
    end
    object actUpdate_MI_ContractGoods_Save_No: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spUpdate_MI_ContractGoods_Save_No
      StoredProcList = <
        item
          StoredProc = spUpdate_MI_ContractGoods_Save_No
        end>
      Caption = 'actUpdate_MI_ContractGoods_Save_No'
    end
    object macUpdate_MI_Save_No_List: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actUpdate_MI_ContractGoods_Save_No
        end>
      View = cxGridDBTableView
      Caption = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1057#1086#1093#1088#1072#1085#1077#1085' '#1053#1045#1058'>'
      Hint = #1059#1089#1090#1072#1085#1086#1074#1080#1090#1100' <'#1057#1086#1093#1088#1072#1085#1077#1085' '#1053#1045#1058'>'
      ImageIndex = 77
    end
    object InsertRecord1: TInsertRecord
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      View = cxGridDBTableView
      Action = actGoods_ObjectChoiceForm
      Params = <>
      Caption = #1044#1086#1073#1072#1074#1080#1090#1100' <'#1058#1086#1074#1072#1088'>'
      ImageIndex = 0
    end
    object actGetImportSetting: TdsdExecStoredProc
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <
        item
          FromParam.Value = Null
          FromParam.MultiSelectSeparator = ','
          ToParam.Value = Null
          ToParam.MultiSelectSeparator = ','
        end>
      PostDataSetBeforeExecute = False
      StoredProc = spGetImportSetting
      StoredProcList = <
        item
          StoredProc = spGetImportSetting
        end>
      Caption = 'actGetImportSetting'
    end
    object actLoadExcel: TMultiAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ActionList = <
        item
          Action = actGetImportSetting
        end
        item
          Action = actDoLoad
        end
        item
          Action = actRefresh
        end>
      QuestionBeforeExecute = #1044#1077#1081#1089#1090#1074#1080#1090#1077#1083#1100#1085#1086' '#1079#1072#1075#1088#1091#1079#1080#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1092#1072#1081#1083#1072' Excel?'
      InfoAfterExecute = #1044#1072#1085#1085#1099#1077' '#1079#1072#1075#1088#1091#1078#1077#1085#1099' '#1091#1089#1087#1077#1096#1085#1086
      Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1080#1079' '#1092#1072#1081#1083#1072' Excel'
      Hint = #1047#1072#1075#1088#1091#1079#1082#1072' '#1089#1090#1088#1086#1082' '#1076#1086#1082#1091#1084#1077#1085#1090#1072' '#1080#1079' '#1092#1072#1081#1083#1072' Excel'
      ImageIndex = 41
    end
    object actDoLoad: TExecuteImportSettingsAction
      Category = #1047#1072#1075#1088#1091#1079#1082#1072
      MoveParams = <>
      ImportSettingsId.Value = '0'
      ImportSettingsId.Component = FormParams
      ImportSettingsId.ComponentItem = 'ImportSettingId'
      ImportSettingsId.MultiSelectSeparator = ','
      ExternalParams = <
        item
          Name = 'InMovementId'
          Value = Null
          Component = FormParams
          ComponentItem = 'Id'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
    end
  end
  inherited MasterDS: TDataSource
    Left = 16
    Top = 320
  end
  inherited MasterCDS: TClientDataSet
    Left = 40
    Top = 368
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementItem_ContractGoods'
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
        Name = 'inShowAll'
        Value = Null
        Component = actShowAll
        DataType = ftBoolean
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
    Left = 80
    Top = 207
    DockControlHeights = (
      0
      0
      26
      0)
    inherited Bar: TdxBar
      ItemLinks = <
        item
          Visible = True
          ItemName = 'bbInsertUpdateMovement'
        end
        item
          Visible = True
          ItemName = 'bbShowErased'
        end
        item
          Visible = True
          ItemName = 'bbShowAll'
        end
        item
          BeginGroup = True
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
          ItemName = 'bbUpdate_MI_ContractGoods_Save_Yes'
        end
        item
          Visible = True
          ItemName = 'bbUpdate_MI_ContractGoods_Save_No'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbLoadExcel'
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
    object bbPrintNoGroup: TdxBarButton
      Action = actPrintNoGroup
      Category = 0
    end
    object bbPrintSaleOrder: TdxBarButton
      Action = actPrintSaleOrder
      Category = 0
    end
    object bbPrintSaleOrderTax: TdxBarButton
      Action = actPrintSaleOrderTax
      Category = 0
    end
    object bbUpdate_MI_ContractGoods_Save_No: TdxBarButton
      Action = macUpdate_MI_ContractGoods_Save_No
      Category = 0
    end
    object bbUpdate_MI_ContractGoods_Save_Yes: TdxBarButton
      Action = macUpdate_MI_ContractGoods_Save_Yes
      Category = 0
    end
    object bbInsertRecord: TdxBarButton
      Action = InsertRecord1
      Category = 0
    end
    object bbLoadExcel: TdxBarButton
      Action = actLoadExcel
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    SummaryItemList = <
      item
        Param.Value = Null
        Param.Component = FormParams
        Param.ComponentItem = 'TotalSumm'
        Param.DataType = ftString
        Param.MultiSelectSeparator = ','
        DataSummaryItemIndex = 5
      end>
    Left = 750
    Top = 225
  end
  inherited PopupMenu: TPopupMenu
    Left = 600
    Top = 360
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
        Name = 'ReportNameSend'
        Value = 'PrintMovement_Sale1'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSendTax'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'ReportNameSendBill'
        Value = Null
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'isSave_yes'
        Value = True
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMask'
        Value = False
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'ImportSettingId'
        Value = Null
        MultiSelectSeparator = ','
      end>
    Left = 272
    Top = 360
  end
  inherited StatusGuides: TdsdGuides
    Left = 48
    Top = 40
  end
  inherited spChangeStatus: TdsdStoredProc
    StoredProcName = 'gpUpdate_Status_ContractGoods'
    Left = 96
    Top = 16
  end
  inherited spGet: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_ContractGoods'
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
        Name = 'inMask'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMask'
        DataType = ftBoolean
        ParamType = ptInput
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
        Name = 'EndBeginDate'
        Value = Null
        Component = edEndBeginDate
        DataType = ftDateTime
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
        Name = 'StatusName'
        Value = ''
        Component = StatusGuides
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractId'
        Value = 0d
        Component = GuidesContract
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractName'
        Value = 'False'
        Component = GuidesContract
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Comment'
        Value = 0.000000000000000000
        Component = ceComment
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertName'
        Value = Null
        Component = edInsertName
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'InsertDate'
        Value = Null
        Component = edInsertDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractCode'
        Value = Null
        Component = edContractCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractStateKindId'
        Value = Null
        Component = GuidesContractStateKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractStateKindName'
        Value = Null
        Component = GuidesContractStateKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTagId'
        Value = Null
        Component = GuidesContractTag
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTagName'
        Value = Null
        Component = GuidesContractTag
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate_contract'
        Value = Null
        Component = edStartDate_contract
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate_contract'
        Value = Null
        Component = edEndDate_contract
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMask'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMask'
        DataType = ftBoolean
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
        Name = 'CurrencyId'
        Value = Null
        Component = GuidesCurrency
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'CurrencyName'
        Value = Null
        Component = GuidesCurrency
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'DiffPrice'
        Value = Null
        Component = edDiffPrice
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'RoundPrice'
        Value = Null
        Component = edRoundPrice
        DataType = ftFloat
        MultiSelectSeparator = ','
      end
      item
        Name = 'PriceWithVAT'
        Value = Null
        Component = edPriceWithVAT
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'isMultWithVAT'
        Value = Null
        Component = cbMultWithVAT
        DataType = ftBoolean
        MultiSelectSeparator = ','
      end
      item
        Name = 'SiteTagId'
        Value = Null
        Component = GuidesSiteTag
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'SiteTagName'
        Value = Null
        Component = GuidesSiteTag
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindId'
        Value = Null
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = Null
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 248
  end
  inherited spInsertUpdateMovement: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Movement_ContractGoods'
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
        Name = 'outEndBeginDate'
        Value = Null
        Component = edEndBeginDate
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'inContractId'
        Value = 0d
        Component = GuidesContract
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCurrencyId'
        Value = Null
        Component = GuidesCurrency
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inSiteTagId'
        Value = Null
        Component = GuidesSiteTag
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inDiffPrice'
        Value = Null
        Component = edDiffPrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRoundPrice'
        Value = Null
        Component = edRoundPrice
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inPriceWithVAT'
        Value = Null
        Component = edPriceWithVAT
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisMultWithVAT'
        Value = Null
        Component = cbMultWithVAT
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = 'False'
        Component = ceComment
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 162
    Top = 312
  end
  inherited GuidesFiller: TGuidesFiller
    GuidesList = <
      item
      end
      item
        Guides = GuidesContract
      end>
    Left = 160
    Top = 192
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
        Control = edContract
      end
      item
        Control = edCurrency
      end
      item
        Control = edPriceWithVAT
      end
      item
      end
      item
        Control = ceComment
      end
      item
        Control = cbMultWithVAT
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end
      item
      end>
    Left = 272
    Top = 201
  end
  inherited RefreshAddOn: TRefreshAddOn
    DataSet = ''
    Left = 784
    Top = 296
  end
  inherited spErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ContractGoods_SetErased'
    Left = 646
    Top = 304
  end
  inherited spUnErasedMIMaster: TdsdStoredProc
    StoredProcName = 'gpMovementItem_ContractGoods_SetUnErased'
    Left = 646
    Top = 240
  end
  inherited spInsertUpdateMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_ContractGoods'
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
        Name = 'inisBonusNo'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isBonusNo'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSave'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isSave'
        DataType = ftBoolean
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
        Name = 'inChangePrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ChangePrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inChangePercent'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ChangePercent'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountForAmount'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountForAmount'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inCountForPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'CountForPrice'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 160
    Top = 368
  end
  inherited spInsertMaskMIMaster: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_ContractGoods'
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
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
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
        Name = 'inPrice'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Price'
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 368
    Top = 272
  end
  inherited spGetTotalSumm: TdsdStoredProc
    Left = 420
    Top = 188
  end
  object RefreshDispatcher: TRefreshDispatcher
    IdParam.Value = Null
    IdParam.MultiSelectSeparator = ','
    RefreshAction = actRefreshMI
    ComponentList = <
      item
      end
      item
        Component = edContract
      end
      item
      end
      item
        Component = ceComment
      end>
    Left = 512
    Top = 328
  end
  object PrintHeaderCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 508
    Top = 193
  end
  object PrintItemsCDS: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 508
    Top = 246
  end
  object spSelectPrint: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_ContractGoods_Print'
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
    Left = 375
    Top = 336
  end
  object GuidesContract: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContract
    FormNameParam.Value = 'TContractChoiceForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractChoiceForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesContract
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = Null
        Component = GuidesContract
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = Null
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = Null
        Component = edContractCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTagId'
        Value = Null
        Component = GuidesContractTag
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTagName'
        Value = Null
        Component = GuidesContractTag
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractStateKindId'
        Value = Null
        Component = GuidesContractStateKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractStateKindName'
        Value = Null
        Component = GuidesContractStateKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate'
        Value = Null
        Component = edStartDate_contract
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = Null
        Component = edEndDate_contract
        DataType = ftDateTime
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindId'
        Value = Null
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PaidKindName'
        Value = Null
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 356
    Top = 40
  end
  object GuidesJuridical: TdsdGuides
    KeyField = 'Id'
    LookupControl = edJuridical
    DisableGuidesOpen = True
    FormNameParam.Value = 'TJuridical_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TJuridical_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 568
    Top = 64
  end
  object spUpdate_MI_ContractGoods_Save_No: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_ContractGoods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
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
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisBonusNo'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isBonusNo'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSave'
        Value = False
        DataType = ftBoolean
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
        Name = 'inComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 624
    Top = 432
  end
  object spUpdate_MI_ContractGoods_Save_Yes: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_MovementItem_ContractGoods'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
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
        Name = 'inGoodsKindId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'GoodsKindId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisBonusNo'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isBonusNo'
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisSave'
        Value = True
        DataType = ftBoolean
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
        Name = 'inComment'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Comment'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 616
    Top = 496
  end
  object GuidesContractTag: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContractTag
    DisableGuidesOpen = True
    FormNameParam.Value = 'TContractTagForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TContractTagForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesContractTag
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesContractTag
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 624
    Top = 95
  end
  object GuidesContractStateKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edContractStateKind
    DisableGuidesOpen = True
    FormNameParam.Value = ''
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    PositionDataSet = 'ClientDataSet'
    Params = <>
    Left = 408
    Top = 48
  end
  object GuidesCurrency: TdsdGuides
    KeyField = 'Id'
    LookupControl = edCurrency
    FormNameParam.Value = 'TCurrency_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TCurrency_ObjectForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesCurrency
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesCurrency
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 208
    Top = 56
  end
  object spGetImportSetting: TdsdStoredProc
    StoredProcName = 'gpGet_DefaultValue'
    DataSets = <
      item
      end>
    OutputType = otResult
    Params = <
      item
        Name = 'inDefaultKey'
        Value = 'TContractGoodsMovementForm;zc_Object_ImportSetting_ContractGoods'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inUserKeyId'
        Value = '0'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'gpGet_DefaultValue'
        Value = Null
        Component = FormParams
        ComponentItem = 'ImportSettingId'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 896
    Top = 328
  end
  object GuidesSiteTag: TdsdGuides
    KeyField = 'Id'
    LookupControl = edSiteTag
    FormNameParam.Value = 'TSiteTagForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TSiteTagForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesSiteTag
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesSiteTag
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 952
    Top = 88
  end
  object GuidesPaidKind: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPaidKind
    DisableGuidesOpen = True
    FormNameParam.Value = 'TPaidKindForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPaidKindForm'
    PositionDataSet = 'ClientDataSet'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesPaidKind
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 696
    Top = 95
  end
end
