inherited Report_Remains_byOrderExternalForm: TReport_Remains_byOrderExternalForm
  Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1086#1089#1090#1072#1090#1082#1072#1084' - '#1042#1067#1055#1054#1051#1053#1045#1053#1048#1045' '#1079#1072#1103#1074#1082#1080' '#1087#1086#1082#1091#1087#1072#1090#1077#1083#1103
  ClientWidth = 927
  AddOnFormData.Params = FormParams
  ExplicitWidth = 943
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 70
    Width = 927
    Height = 238
    ExplicitTop = 70
    ExplicitWidth = 927
    ExplicitHeight = 238
    ClientRectBottom = 238
    ClientRectRight = 927
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 927
      ExplicitHeight = 238
      inherited cxGrid: TcxGrid
        Width = 927
        Height = 238
        ExplicitWidth = 927
        ExplicitHeight = 238
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
              Column = Amount_Prev
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Next
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains_CEH
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains_SKLAD
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_result
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains_CEH_next
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_result_two
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Income_CEH
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_result_two_two
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Prev
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_Next
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains_CEH
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains_SKLAD
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_result
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Remains_CEH_next
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_result_two
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Income_CEH
            end
            item
              Format = ',0.####'
              Kind = skSum
              Column = Amount_result_two_two
            end>
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object FromName: TcxGridDBColumn
            Caption = #1055#1086#1082#1091#1087#1072#1090#1077#1083#1100'/ '#1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077
            DataBinding.FieldName = 'FromName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object GoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object GoodsCode_Main: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1079#1072#1082#1083#1072#1076#1082#1072' '#1089#1099#1088#1100#1077')'
            DataBinding.FieldName = 'GoodsCode_Main'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 68
          end
          object GoodsName_Main: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' ('#1079#1072#1082#1083#1072#1076#1082#1072' '#1089#1099#1088#1100#1077')'
            DataBinding.FieldName = 'GoodsName_Main'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object GoodsKindName_Main: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1079#1072#1082#1083#1072#1076#1082#1072' '#1089#1099#1088#1100#1077')'
            DataBinding.FieldName = 'GoodsKindName_Main'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object GoodsCode_pack: TcxGridDBColumn
            Caption = #1050#1086#1076' ('#1087#1088#1080#1093#1086#1076' '#1089' '#1094#1077#1093#1072')'
            DataBinding.FieldName = 'GoodsCode_pack'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object GoodsName_pack: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088' ('#1087#1088#1080#1093#1086#1076' '#1089' '#1094#1077#1093#1072')'
            DataBinding.FieldName = 'GoodsName_pack'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object GoodsKindName_pack: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072' ('#1087#1088#1080#1093#1086#1076' '#1089' '#1094#1077#1093#1072')'
            DataBinding.FieldName = 'GoodsKindName_pack'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 150
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object PartionGoods: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103
            DataBinding.FieldName = 'PartionGoods'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 65
          end
          object PartionGoods_start: TcxGridDBColumn
            Caption = #1074#1089#1077' '#1095#1090#1086' <= '#1101#1090#1086#1081' '#1044#1072#1090#1099
            DataBinding.FieldName = 'PartionGoods_start'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object TermProduction: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1087#1088'. '#1074' '#1076#1085#1103#1093
            DataBinding.FieldName = 'TermProduction'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object Amount_result: TcxGridDBColumn
            Caption = #1056#1045#1047#1059#1051#1068#1058#1040#1058
            DataBinding.FieldName = 'Amount_result'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object Amount_result_two: TcxGridDBColumn
            Caption = #1056#1045#1047#1059#1051#1068#1058#1040#1058' '#1073#1077#1079' '#1055#1056'-'#1042#1040
            DataBinding.FieldName = 'Amount_result_two'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object Amount_result_two_two: TcxGridDBColumn
            Caption = #1056#1045#1047#1059#1051#1068#1058#1040#1058' C '#1087#1088'-'#1074#1086' ('#1060#1040#1050#1058')'
            DataBinding.FieldName = 'Amount_result_two_two'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object Amount: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1074' '#1079#1072#1103#1074#1082#1077
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object Income_CEH: TcxGridDBColumn
            Caption = #1055#1088#1080#1093#1086#1076' '#1087#1088'-'#1074#1086' ('#1060#1040#1050#1058')'
            DataBinding.FieldName = 'Income_CEH'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
          end
          object Amount_Prev: TcxGridDBColumn
            Caption = #1085#1077#1086#1090#1075#1088#1091#1078'. '#1079#1072#1103#1074#1082#1072
            DataBinding.FieldName = 'Amount_Prev'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object Amount_Next: TcxGridDBColumn
            Caption = #1089#1077#1075#1086#1076#1085#1103' '#1079#1072#1103#1074#1082#1072
            DataBinding.FieldName = 'Amount_Next'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object Remains_SKLAD: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1085#1072#1095'. ('#1057#1050#1051#1040#1044')'
            DataBinding.FieldName = 'Remains_SKLAD'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object Remains_CEH: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1085#1072#1095'. ('#1055#1056'-'#1042#1054')'
            DataBinding.FieldName = 'Remains_CEH'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090'. '#1085#1072#1095#1072#1083#1100#1085'. - '#1087#1088#1086#1080#1079#1074'. ('#1057#1045#1043#1054#1044#1053#1071')'
            Width = 80
          end
          object Remains_CEH_next: TcxGridDBColumn
            Caption = #1054#1089#1090'. '#1085#1072#1095'. ('#1087#1088'-'#1074#1086' '#1055#1054#1047#1046#1045')'
            DataBinding.FieldName = 'Remains_CEH_next'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1089#1090'. '#1085#1072#1095'. ('#1087#1088'-'#1074#1086' '#1055#1054#1047#1046#1045')'
            Width = 80
          end
          object ReceiptCode_basis: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1088#1077#1094'. ('#1089#1099#1088#1100#1077')'
            DataBinding.FieldName = 'ReceiptCode_basis'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object ReceiptName_basis: TcxGridDBColumn
            Caption = #1056#1077#1094#1077#1087#1090' ('#1089#1099#1088#1100#1077')'
            DataBinding.FieldName = 'ReceiptName_basis'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object ReceiptCode_pack: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1088#1077#1094'. ('#1087#1088#1080#1093#1086#1076' '#1089' '#1094#1077#1093#1072')'
            DataBinding.FieldName = 'ReceiptCode_pack'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object ReceiptName_pack: TcxGridDBColumn
            Caption = #1056#1077#1094#1077#1087#1090' ('#1087#1088#1080#1093#1086#1076' '#1089' '#1094#1077#1093#1072')'
            DataBinding.FieldName = 'ReceiptName_pack'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
          object ReceiptCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1088#1077#1094'. ('#1091#1087#1072#1082'.)'
            DataBinding.FieldName = 'ReceiptCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object ReceiptName: TcxGridDBColumn
            Caption = #1056#1077#1094#1077#1087#1090' ('#1091#1087#1072#1082'.)'
            DataBinding.FieldName = 'ReceiptName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 120
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 927
    Height = 44
    ExplicitWidth = 927
    ExplicitHeight = 44
    inherited deStart: TcxDateEdit
      Left = 738
      Top = 23
      EditValue = 43009d
      TabOrder = 1
      Visible = False
      ExplicitLeft = 738
      ExplicitTop = 23
      ExplicitWidth = 91
      Width = 91
    end
    inherited deEnd: TcxDateEdit
      Left = 841
      Top = 23
      EditValue = 43009d
      TabOrder = 0
      Visible = False
      ExplicitLeft = 841
      ExplicitTop = 23
      ExplicitWidth = 110
      Width = 110
    end
    inherited cxLabel1: TcxLabel
      Left = 738
      Visible = False
      ExplicitLeft = 738
    end
    inherited cxLabel2: TcxLabel
      Left = 841
      Visible = False
      ExplicitLeft = 841
    end
    object cxLabel25: TcxLabel
      Left = 9
      Top = -1
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1047#1072#1103#1074#1082#1080
    end
    object edPromo: TcxButtonEdit
      Left = 9
      Top = 17
      Properties.Buttons = <
        item
          Default = True
          Enabled = False
          Kind = bkEllipsis
        end>
      Properties.ReadOnly = True
      TabOrder = 5
      Width = 117
    end
    object cxLabel4: TcxLabel
      Left = 224
      Top = -1
      Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
    end
    object deOperdate: TcxDateEdit
      Left = 224
      Top = 17
      EditValue = 41640d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 7
      Width = 85
    end
  end
  inherited UserSettingsStorageAddOn: TdsdUserSettingsStorageAddOn
    Left = 51
    Top = 192
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Left = 8
    Top = 232
  end
  inherited ActionList: TActionList
    Left = 87
    Top = 191
    object actRefreshSearch: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProcList = <
        item
        end>
      Caption = 'actRefreshSearch'
      ShortCut = 13
    end
    object actOpenForm: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1055#1086#1082#1072#1079#1072#1090#1100' '#1076#1086#1082#1091#1084#1077#1085#1090
      FormName = 'NULL'
      FormNameParam.Value = Null
      FormNameParam.Component = FormParams
      FormNameParam.ComponentItem = 'FormName'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Id'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'MovementId'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inOperDate'
          Value = 'NULL'
          Component = MasterCDS
          ComponentItem = 'OperDate'
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actGetForm: TdsdExecStoredProc
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = getMovementForm
      StoredProcList = <
        item
          StoredProc = getMovementForm
        end>
      Caption = 'actGetForm'
    end
  end
  inherited MasterDS: TDataSource
    Left = 48
    Top = 120
  end
  inherited MasterCDS: TClientDataSet
    Left = 8
    Top = 88
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_Remains_byOrderExternal'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Top = 128
  end
  inherited BarManager: TdxBarManager
    Left = 112
    Top = 88
    DockControlHeights = (
      0
      0
      26
      0)
    object bbOpenDocument: TdxBarButton
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Category = 0
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Visible = ivAlways
      ImageIndex = 28
      ShortCut = 115
    end
    object bbExecuteDialog: TdxBarButton
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Category = 0
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Visible = ivAlways
      ImageIndex = 35
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
      end>
  end
  inherited PopupMenu: TPopupMenu
    Left = 128
    Top = 216
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 32
    Top = 152
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
      end>
    Left = 128
    Top = 144
  end
  object getMovementForm: TdsdStoredProc
    StoredProcName = 'gpGet_Movement_Form'
    DataSets = <>
    OutputType = otResult
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
        Name = 'FormName'
        Value = Null
        Component = FormParams
        ComponentItem = 'FormName'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 280
    Top = 160
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'FormName'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'inMovementId'
        Value = Null
        Component = GuidesOrderExternal
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = Null
        Component = GuidesOrderExternal
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inOperDate'
        Value = 'NULL'
        Component = deOperdate
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 232
    Top = 176
  end
  object GuidesOrderExternal: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPromo
    Key = '0'
    FormNameParam.Value = 'TOrderExternalJournalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TOrderExternalJournalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesOrderExternal
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = GuidesOrderExternal
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerId'
        Value = ''
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'PartnerName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    Left = 52
    Top = 8
  end
end
