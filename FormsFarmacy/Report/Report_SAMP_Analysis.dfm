inherited Report_SAMP_AnalysisForm: TReport_SAMP_AnalysisForm
  Caption = #1054#1090#1095#1077#1090' '#1089#1088#1072#1074#1085#1077#1085#1080#1077' '#1087#1088#1086#1076#1072#1078' '#1089' '#1087#1088#1086#1096#1083#1099#1084' '#1087#1077#1088#1080#1086#1076#1086#1084
  ClientWidth = 740
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  AddOnFormData.Params = FormParams
  ExplicitWidth = 756
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 77
    Width = 740
    Height = 231
    ExplicitTop = 77
    ExplicitWidth = 740
    ExplicitHeight = 231
    ClientRectBottom = 231
    ClientRectRight = 740
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 740
      ExplicitHeight = 231
      inherited cxGrid: TcxGrid
        Width = 740
        Height = 231
        ExplicitWidth = 740
        ExplicitHeight = 231
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.####'
            end
            item
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = Amount_MI
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountAnalys_MI
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountYear1
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountYear2
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountAnalys1
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountAnalys2
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = GoodsName
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = Amount_MI
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountAnalys_MI
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountYear1
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountYear2
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountAnalys1
            end
            item
              Format = ',0.###'
              Kind = skSum
              Column = AmountAnalys2
            end>
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Caption = 'mactChoiceGoodsForm'
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 39
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 224
          end
          object Price_MI: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1088#1086#1079#1085'.  ('#1076#1086#1082'.)'
            DataBinding.FieldName = 'Price_MI'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1088#1086#1079#1085'. '#1085#1072' '#1084#1086#1084#1077#1085#1090' '#1092#1086#1088#1084'. '#1086#1090#1095#1077#1090#1072' ('#1076#1086#1082'.)'
            Options.Editing = False
            Width = 66
          end
          object Amount_MI: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088'. '#1079#1072' '#1087#1077#1088#1080#1086#1076' ('#1076#1086#1082'.)'
            DataBinding.FieldName = 'Amount_MI'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1088#1086#1076#1072#1078' '#1079#1072' '#1087#1077#1088#1080#1086#1076' ('#1076#1086#1082'.)'
            Options.Editing = False
            Width = 66
          end
          object AmountAnalys_MI: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088'. '#1079#1072' '#1072#1085#1072#1083#1080#1079' ('#1076#1086#1082'.)'
            DataBinding.FieldName = 'AmountAnalys_MI'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1088#1086#1076#1072#1078' '#1079#1072' '#1072#1085#1072#1083#1080#1079' ('#1076#1086#1082'.)'
            Options.Editing = False
            Width = 66
          end
          object AmountYear1: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088'. '#1079#1072' '#1087#1077#1088#1080#1086#1076' ('#1087#1077#1088#1080#1086#1076'1)'
            DataBinding.FieldName = 'AmountYear1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1088#1086#1076#1072#1078' '#1079#1072' '#1087#1077#1088#1080#1086#1076' ('#1087#1077#1088#1080#1086#1076'1)'
            Options.Editing = False
            Width = 66
          end
          object AmountYear2: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088'. '#1079#1072' '#1087#1077#1088#1080#1086#1076' ('#1087#1077#1088#1080#1086#1076'2)'
            DataBinding.FieldName = 'AmountYear2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1088#1086#1076#1072#1078' '#1079#1072' '#1087#1077#1088#1080#1086#1076' ('#1087#1077#1088#1080#1086#1076'2)'
            Options.Editing = False
            Width = 66
          end
          object AmountAnalys1: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088'. '#1079#1072' '#1072#1085#1072#1083#1080#1079' ('#1087#1077#1088#1080#1086#1076'1)'
            DataBinding.FieldName = 'AmountAnalys1'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1088#1086#1076#1072#1078' '#1079#1072' '#1072#1085#1072#1083#1080#1079' ('#1087#1077#1088#1080#1086#1076'1)'
            Options.Editing = False
            Width = 66
          end
          object AmountAnalys2: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1087#1088'. '#1079#1072' '#1072#1085#1072#1083#1080#1079' ('#1087#1077#1088#1080#1086#1076'2)'
            DataBinding.FieldName = 'AmountAnalys2'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.##;-,0.##; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1087#1088#1086#1076#1072#1078' '#1079#1072' '#1072#1085#1072#1083#1080#1079' ('#1087#1077#1088#1080#1086#1076'2)'
            Options.Editing = False
            Width = 66
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 740
    Height = 51
    ExplicitWidth = 740
    ExplicitHeight = 51
    inherited deStart: TcxDateEdit
      Left = 39
      Top = 23
      EditValue = 43009d
      Properties.DisplayFormat = 'YYYY'
      TabOrder = 1
      ExplicitLeft = 39
      ExplicitTop = 23
      ExplicitWidth = 82
      Width = 82
    end
    inherited deEnd: TcxDateEdit
      Left = 142
      Top = 23
      EditValue = 43009d
      Properties.DisplayFormat = 'YYYY'
      TabOrder = 0
      ExplicitLeft = 142
      ExplicitTop = 23
      ExplicitWidth = 82
      Width = 82
    end
    inherited cxLabel1: TcxLabel
      Left = 39
      Caption = #1055#1077#1088#1080#1086#1076' 1 ('#1075#1086#1076'):'
      ExplicitLeft = 39
      ExplicitWidth = 84
    end
    inherited cxLabel2: TcxLabel
      Left = 142
      Caption = #1055#1077#1088#1080#1086#1076' 2 ('#1075#1086#1076'):'
      ExplicitLeft = 142
      ExplicitWidth = 84
    end
    object cxLabel25: TcxLabel
      Left = 521
      Top = 5
      Caption = #1044#1086#1082#1091#1084#1077#1085#1090' '#1052#1072#1088#1082#1077#1090#1080#1085#1075#1072
    end
    object edPromo: TcxButtonEdit
      Left = 521
      Top = 23
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
      Left = 645
      Top = 5
      Caption = #1044#1072#1090#1072' '#1076#1086#1082'.'
    end
    object deOperdate: TcxDateEdit
      Left = 645
      Top = 23
      EditValue = 41640d
      Properties.ReadOnly = True
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 7
      Width = 85
    end
    object cxLabel3: TcxLabel
      Left = 267
      Top = 6
      Caption = #1044#1072#1090#1072' '#1085#1072#1095'. '#1086#1090#1095'.'
    end
    object edStartSale: TcxDateEdit
      Left = 267
      Top = 23
      EditValue = 42485d
      Properties.ReadOnly = True
      TabOrder = 9
      Width = 81
    end
    object cxLabel6: TcxLabel
      Left = 353
      Top = 6
      Caption = #1044#1072#1090#1072' '#1086#1082#1086#1085'. '#1086#1090#1095'.'
    end
    object edEndSale: TcxDateEdit
      Left = 353
      Top = 23
      EditValue = 42485d
      Properties.ReadOnly = True
      TabOrder = 11
      Width = 86
    end
    object cxLabel14: TcxLabel
      Left = 444
      Top = 6
      Caption = #1044#1085'. '#1072#1085#1072#1083#1080#1079#1072
    end
    object edDayCount: TcxCurrencyEdit
      Left = 444
      Top = 23
      Properties.DisplayFormat = ',0.00'
      Properties.ReadOnly = True
      TabOrder = 13
      Width = 66
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
      StoredProc = gpGetObjectGoods
      StoredProcList = <
        item
          StoredProc = gpGetObjectGoods
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
    object actOpenDocument: TMultiAction
      Category = 'DSDLib'
      MoveParams = <>
      ActionList = <
        item
          Action = actGetForm
        end
        item
          Action = actOpenForm
        end>
      Caption = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      Hint = #1055#1088#1086#1089#1084#1086#1090#1088' '#1076#1086#1082#1091#1084#1077#1085#1090#1072
      ImageIndex = 28
      ShortCut = 115
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_SAMP_AnalysisDialogForm'
      FormNameParam.Value = 'TReport_SAMP_AnalysisDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'Year1'
          Value = 42491d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'Year2'
          Value = 42491d
          Component = deEnd
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 40
    Top = 88
  end
  inherited MasterCDS: TClientDataSet
    Left = 8
    Top = 88
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpReport_SAMP_Analysis'
    Params = <
      item
        Name = 'inMovementId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inMovementId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inGoodsId'
        Value = Null
        Component = FormParams
        ComponentItem = 'inGoodsId'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inYear1'
        Value = 'NULL'
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inYear2'
        Value = 'NULL'
        Component = deEnd
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 64
    Top = 112
  end
  inherited BarManager: TdxBarManager
    Left = 112
    Top = 88
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
          ItemName = 'bbGridToExcel'
        end>
    end
    object bbOpenDocument: TdxBarButton
      Action = actOpenDocument
      Category = 0
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    OnDblClickActionList = <
      item
        Action = actOpenDocument
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
  object gpGetObjectGoods: TdsdStoredProc
    StoredProcName = 'gpGet_Object_GoodsByCode'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'inGoodsCode'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'Id'
        Value = Null
        MultiSelectSeparator = ','
      end
      item
        Name = 'Name'
        Value = Null
        DataType = ftString
        MultiSelectSeparator = ','
      end>
    PackSize = 1
    Left = 592
    Top = 120
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
        Component = GuidesPromo
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inInvNumber'
        Value = Null
        Component = GuidesPromo
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
      end
      item
        Name = 'inGoodsId'
        Value = Null
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartSale'
        Value = 'NULL'
        Component = edStartSale
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndSale'
        Value = 'NULL'
        Component = edEndSale
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'DayCount'
        Value = Null
        Component = edDayCount
        DataType = ftFloat
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 216
    Top = 176
  end
  object GuidesPromo: TdsdGuides
    KeyField = 'Id'
    LookupControl = edPromo
    Key = '0'
    FormNameParam.Value = 'TPromoJournalForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TPromoJournalForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = '0'
        Component = GuidesPromo
        ComponentItem = 'Key'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'InvNumber_Full'
        Value = ''
        Component = GuidesPromo
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
    Left = 564
    Top = 16
  end
end
