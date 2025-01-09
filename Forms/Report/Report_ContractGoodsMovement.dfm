inherited Report_ContractGoodsMovementForm: TReport_ContractGoodsMovementForm
  Caption = #1054#1090#1095#1077#1090' <'#1087#1086' '#1044#1086#1082#1091#1084#1077#1085#1090#1072#1084' <'#1058#1086#1074#1072#1088#1099' '#1074' '#1076#1086#1075#1086#1074#1086#1088#1072#1093' ('#1057#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103')>'
  ClientHeight = 341
  ClientWidth = 1174
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitWidth = 1190
  ExplicitHeight = 380
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 86
    Width = 1174
    Height = 255
    TabOrder = 3
    ExplicitTop = 86
    ExplicitWidth = 1174
    ExplicitHeight = 255
    ClientRectBottom = 255
    ClientRectRight = 1174
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 1174
      ExplicitHeight = 255
      inherited cxGrid: TcxGrid
        Width = 1174
        Height = 255
        ExplicitWidth = 1174
        ExplicitHeight = 255
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.FooterSummaryItems = <
            item
              Format = #1042#1089#1077#1075#1086' '#1089#1090#1088#1086#1082': ,0'
              Kind = skCount
              Column = JuridicalName
            end>
          OptionsData.Editing = False
          OptionsView.GroupByBox = True
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object OperDate: TcxGridDBColumn
            Caption = #1044#1077#1081#1089#1090#1074#1091#1077#1090' '#1089'...'
            DataBinding.FieldName = 'OperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object InvNumber: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1082'.'
            DataBinding.FieldName = 'InvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 69
          end
          object EndBeginDate: TcxGridDBColumn
            Caption = #1044#1077#1081#1089#1090#1074#1091#1077#1090' '#1076#1086'... ('#1080#1085#1092#1086#1088#1084'. '#1080#1079' '#1076#1086#1082')'
            DataBinding.FieldName = 'EndBeginDate'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1077#1081#1089#1090#1074#1091#1077#1090' '#1076#1086'... ('#1089#1087#1077#1094#1080#1092#1080#1082#1072#1094#1080#1103') '#1080#1085#1092#1086#1088#1084#1072#1090#1080#1074#1085#1086
            Options.Editing = False
            Width = 80
          end
          object EndBeginDate_calc: TcxGridDBColumn
            Caption = #1044#1077#1081#1089#1090#1074#1091#1077#1090' '#1076#1086'...'
            DataBinding.FieldName = 'EndBeginDate_calc'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1077#1081#1089#1090#1074#1091#1077#1090' '#1076#1086'... ('#1088#1072#1089#1095#1077#1090')'
            Options.Editing = False
            Width = 80
          end
          object ContractStateKindName: TcxGridDBColumn
            Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractStateKindCode'
            PropertiesClassName = 'TcxImageComboBoxProperties'
            Properties.Alignment.Horz = taLeftJustify
            Properties.Alignment.Vert = taVCenter
            Properties.Images = dmMain.ImageList
            Properties.Items = <
              item
                Description = #1055#1086#1076#1087#1080#1089#1072#1085
                ImageIndex = 12
                Value = 1
              end
              item
                Description = #1053#1077' '#1087#1086#1076#1087#1080#1089#1072#1085
                ImageIndex = 11
                Value = 2
              end
              item
                Description = #1047#1072#1074#1077#1088#1096#1077#1085
                ImageIndex = 13
                Value = 3
              end
              item
                Description = #1059' '#1082#1086#1085#1090#1088#1072#1075#1077#1085#1090#1072
                ImageIndex = 66
                Value = 4
              end>
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 67
          end
          object ContractCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object ContractName: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 40
          end
          object CurrencyName: TcxGridDBColumn
            Caption = #1042#1072#1083#1102#1090#1072' ('#1094#1077#1085#1072' '#1089#1087#1077#1094'.)'
            DataBinding.FieldName = 'CurrencyName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 79
          end
          object PriceWithVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1099' '#1089' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
            DataBinding.FieldName = 'PriceWithVAT'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 94
          end
          object isMultWithVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1082#1088#1072#1090#1085#1072#1103' '#1053#1044#1057
            DataBinding.FieldName = 'isMultWithVAT'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1062#1077#1085#1072' '#1082#1088#1072#1090#1085#1072#1103' '#1053#1044#1057' ('#1076#1072'/'#1085#1077#1090')'
            Options.Editing = False
            Width = 76
          end
          object PaidKindName: TcxGridDBColumn
            Caption = #1060#1086#1088#1084#1072' '#1086#1087#1083#1072#1090#1099
            DataBinding.FieldName = 'PaidKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 50
          end
          object StartDate_Contract: TcxGridDBColumn
            Caption = #1044#1077#1081#1089#1090#1074'. '#1089' ('#1076#1086#1075'.)'
            DataBinding.FieldName = 'StartDate_Contract'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1077#1081#1089#1090#1074'. '#1089' ('#1076#1086#1075#1086#1074#1086#1088')'
            Options.Editing = False
            Width = 60
          end
          object ContractKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1076#1086#1075'.'
            DataBinding.FieldName = 'ContractKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 86
          end
          object InfoMoneyGroupCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055' '#1075#1088#1091#1087#1087#1099
            DataBinding.FieldName = 'InfoMoneyGroupCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object InfoMoneyGroupName: TcxGridDBColumn
            Caption = #1059#1055' '#1075#1088#1091#1087#1087#1072' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyGroupName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 113
          end
          object InfoMoneyDestinationCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055' '#1085#1072#1079#1085#1072#1095'.'
            DataBinding.FieldName = 'InfoMoneyDestinationCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object InfoMoneyDestinationName: TcxGridDBColumn
            Caption = #1059#1055' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1077
            DataBinding.FieldName = 'InfoMoneyDestinationName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object InfoMoneyCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1059#1055
            DataBinding.FieldName = 'InfoMoneyCode'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 39
          end
          object InfoMoneyName: TcxGridDBColumn
            Caption = #1059#1055' '#1089#1090#1072#1090#1100#1103' '#1085#1072#1079#1085#1072#1095#1077#1085#1080#1103
            DataBinding.FieldName = 'InfoMoneyName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object PersonalName: TcxGridDBColumn
            Caption = #1054#1090#1074#1077#1090#1089#1090#1074#1077#1085#1085#1099#1081' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            DataBinding.FieldName = 'PersonalName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 55
          end
          object PersonalTradeName: TcxGridDBColumn
            Caption = #1058#1055' ('#1089#1086#1090#1088#1091#1076#1085#1080#1082')'
            DataBinding.FieldName = 'PersonalTradeName'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 60
          end
          object JuridicalCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1102#1088'.'#1083'.'
            DataBinding.FieldName = 'JuridicalCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1070#1088#1080#1076#1080#1095#1077#1089#1082#1086#1077' '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 171
          end
          object GoodsGroupNameFull: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' ('#1074#1089#1077')'
            DataBinding.FieldName = 'GoodsGroupNameFull'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 120
          end
          object GoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 75
          end
          object GoodsName: TcxGridDBColumn
            Caption = #1058#1086#1074#1072#1088
            DataBinding.FieldName = 'GoodsName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 182
          end
          object GoodsKindName: TcxGridDBColumn
            Caption = #1042#1080#1076' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsKindName'
            PropertiesClassName = 'TcxButtonEditProperties'
            Properties.Buttons = <
              item
                Default = True
                Kind = bkEllipsis
              end>
            Properties.ReadOnly = True
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object MeasureName: TcxGridDBColumn
            Caption = #1045#1076'. '#1080#1079#1084'.'
            DataBinding.FieldName = 'MeasureName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 45
          end
          object Price: TcxGridDBColumn
            Caption = #1062#1077#1085#1072
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object isBonusNo: TcxGridDBColumn
            Caption = #1053#1077#1090' '#1085#1072#1095'. '#1087#1086' '#1073#1086#1085#1091#1089#1072#1084
            DataBinding.FieldName = 'isBonusNo'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1085#1077#1090' '#1085#1072#1095#1080#1089#1083#1077#1085#1080#1103' '#1087#1086' '#1073#1086#1085#1091#1089#1072#1084
            Width = 70
          end
          object Comment: TcxGridDBColumn
            Caption = #1055#1088#1080#1084#1077#1095#1072#1085#1080#1077
            DataBinding.FieldName = 'Comment'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 110
          end
          object ChangePrice: TcxGridDBColumn
            Caption = #1057#1082#1080#1076#1082#1072' '#1074' '#1094#1077#1085#1077
            DataBinding.FieldName = 'ChangePrice'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object ChangePercent: TcxGridDBColumn
            Caption = '% '#1057#1082#1080#1076#1082#1080
            DataBinding.FieldName = 'ChangePercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object CountForPrice: TcxGridDBColumn
            Caption = #1050#1086#1083'. '#1074' '#1094#1077#1085#1077
            DataBinding.FieldName = 'CountForPrice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object CountForAmount: TcxGridDBColumn
            Caption = #1050#1086#1101#1092#1092' '#1087#1077#1088#1077#1074#1086#1076#1072
            DataBinding.FieldName = 'CountForAmount'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1101#1092#1092' '#1087#1077#1088#1077#1074#1086#1076#1072' '#1080#1079' '#1082#1086#1083'-'#1074#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072
            Width = 70
          end
          object DiffPrice: TcxGridDBColumn
            Caption = '% '#1086#1090#1082#1083'. '#1076#1083#1103' '#1094#1077#1085#1099
            DataBinding.FieldName = 'DiffPrice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1056#1072#1079#1088#1077#1096#1077#1085#1085#1099#1081' % '#1086#1090#1082#1083#1086#1085#1077#1085#1080#1077' '#1076#1083#1103' '#1094#1077#1085#1099
            Options.Editing = False
            Width = 70
          end
          object RoundPrice: TcxGridDBColumn
            Caption = #1050#1086#1083'-'#1074#1086' '#1079#1085'. '#1076#1083#1103' '#1086#1082#1088#1091#1075#1083'.'
            DataBinding.FieldName = 'RoundPrice'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1050#1086#1083'-'#1074#1086' '#1079#1085#1072#1082#1086#1074' '#1076#1083#1103' '#1086#1082#1088#1091#1075#1083#1077#1085#1080#1103
            Options.Editing = False
            Width = 70
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 1174
    Height = 60
    ExplicitWidth = 1174
    ExplicitHeight = 60
    inherited deStart: TcxDateEdit
      Left = 123
      EditValue = 41640d
      Properties.SaveTime = False
      ExplicitLeft = 123
    end
    inherited deEnd: TcxDateEdit
      Left = 123
      Top = 30
      EditValue = 41640d
      Properties.SaveTime = False
      ExplicitLeft = 123
      ExplicitTop = 30
    end
    inherited cxLabel1: TcxLabel
      Left = 29
      ExplicitLeft = 29
    end
    inherited cxLabel2: TcxLabel
      Left = 10
      Top = 31
      ExplicitLeft = 10
      ExplicitTop = 31
    end
  end
  object cxLabel27: TcxLabel [2]
    Left = 226
    Top = 6
    Caption = #8470' '#1044#1086#1075#1086#1074#1086#1088#1072
  end
  object edContract: TcxButtonEdit [3]
    Left = 301
    Top = 5
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ClickKey = 0
    Properties.HideSelection = False
    Properties.ReadOnly = False
    TabOrder = 7
    Width = 132
  end
  object edContractCode: TcxCurrencyEdit [4]
    Left = 494
    Top = 5
    Properties.DecimalPlaces = 0
    Properties.DisplayFormat = '0'
    Properties.ReadOnly = True
    TabOrder = 8
    Width = 58
  end
  object cxLabel11: TcxLabel [5]
    Left = 439
    Top = 6
    Caption = #1050#1086#1076' '#1076#1086#1075'.'
  end
  object cxLabel3: TcxLabel [6]
    Left = 247
    Top = 31
    Caption = #1070#1088'.'#1083#1080#1094#1086
  end
  object edJuridical: TcxButtonEdit [7]
    Left = 301
    Top = 30
    Properties.Buttons = <
      item
        Default = True
        Kind = bkEllipsis
      end>
    Properties.ReadOnly = True
    TabOrder = 11
    Width = 251
  end
  inherited ActionList: TActionList
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_ContractGoodsMovementDialogForm'
      FormNameParam.Value = 'TReport_ContractGoodsMovementDialogForm'
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
          Name = 'JuridicalId'
          Value = ''
          Component = GuidesJuridical
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'JuridicalName'
          Value = ''
          Component = GuidesJuridical
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractId'
          Value = Null
          Component = GuidesContract
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractName'
          Value = Null
          Component = GuidesContract
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'ContractCode'
          Value = Null
          Component = edContractCode
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
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
    StoredProcName = 'gpReport_ContractGoodsMovement'
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
        Name = 'inContractId'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 112
    Top = 208
  end
  inherited BarManager: TdxBarManager
    Left = 144
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
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 368
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 80
    Top = 144
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = PeriodChoice
      end
      item
        Component = GuidesContract
      end>
    Left = 736
    Top = 8
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
        Value = ''
        Component = GuidesContract
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesContract
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalId'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'Key'
        MultiSelectSeparator = ','
      end
      item
        Name = 'JuridicalName'
        Value = ''
        Component = GuidesJuridical
        ComponentItem = 'TextValue'
        DataType = ftString
        MultiSelectSeparator = ','
      end
      item
        Name = 'Code'
        Value = 0.000000000000000000
        Component = edContractCode
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTagId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractTagName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractStateKindId'
        Value = ''
        ComponentItem = 'Key'
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'ContractStateKindName'
        Value = ''
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'StartDate'
        Value = 0d
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end
      item
        Name = 'EndDate'
        Value = 0d
        DataType = ftDateTime
        ParamType = ptUnknown
        MultiSelectSeparator = ','
      end>
    Left = 588
    Top = 16
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
    Left = 624
    Top = 8
  end
end
