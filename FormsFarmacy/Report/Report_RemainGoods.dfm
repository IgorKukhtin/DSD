inherited Report_GoodsRemainsForm: TReport_GoodsRemainsForm
  Caption = #1054#1089#1090#1072#1090#1082#1080' '#1090#1086#1074#1072#1088#1086#1074
  ClientHeight = 364
  ClientWidth = 930
  AddOnFormData.ExecuteDialogAction = ExecuteDialog
  ExplicitLeft = -140
  ExplicitWidth = 946
  ExplicitHeight = 399
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Top = 56
    Width = 930
    Height = 308
    TabOrder = 3
    ExplicitTop = 56
    ExplicitWidth = 930
    ExplicitHeight = 308
    ClientRectBottom = 308
    ClientRectRight = 930
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 930
      ExplicitHeight = 308
      inherited cxGrid: TcxGrid
        Width = 930
        Height = 308
        ExplicitWidth = 930
        ExplicitHeight = 308
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colSummaWithOutVAT
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colSummaWithVAT
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colSumma
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colSummaSale
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = MP_Summa
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = MP_SummaVAT
            end>
          DataController.Summary.FooterSummaryItems = <
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
              Column = colSummaWithOutVAT
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colSummaWithVAT
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colSumma
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colSummaSale
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = colAmount
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = MP_Summa
            end
            item
              Format = ',0.00'
              Kind = skSum
              Column = MP_SummaVAT
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
          object clGoodsGroupName: TcxGridDBColumn
            Caption = #1043#1088#1091#1087#1087#1072' '#1090#1086#1074#1072#1088#1072
            DataBinding.FieldName = 'GoodsGroupName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 100
          end
          object colGoodsCode: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'GoodsCode'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 52
          end
          object colGoodsName: TcxGridDBColumn
            Caption = #1053#1072#1080#1084#1077#1085#1086#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'GoodsName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 214
          end
          object colNDSKindName: TcxGridDBColumn
            Caption = #1053#1044#1057
            DataBinding.FieldName = 'NDSKindName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 42
          end
          object colAmount: TcxGridDBColumn
            Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
            DataBinding.FieldName = 'Amount'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 80
          end
          object colMinExpirationDate: TcxGridDBColumn
            Caption = #1057#1088#1086#1082' '#1075#1086#1076#1085#1086#1089#1090#1080' '#1086#1089#1090#1072#1090#1082#1072
            DataBinding.FieldName = 'MinExpirationDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 118
          end
          object JuridicalCode: TcxGridDBColumn
            Caption = #1050#1086#1076' '#1087#1086#1089#1090'.'
            DataBinding.FieldName = 'JuridicalCode'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object JuridicalName: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object PriceWithOutVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1080#1093#1086#1076#1072' ('#1073#1077#1079' '#1053#1044#1057')'
            DataBinding.FieldName = 'PriceWithOutVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object colPriceWithVAT: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1080#1093#1086#1076#1072' ('#1089' '#1053#1044#1057')'
            DataBinding.FieldName = 'PriceWithVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 78
          end
          object colPrice: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1080#1093#1086#1076#1072' '#1089' '#1091#1095'. % '#1082#1086#1088#1088'. ('#1089' '#1053#1044#1057')'
            DataBinding.FieldName = 'Price'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 79
          end
          object colPriceSale: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'PriceSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 58
          end
          object colSummaWithOutVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1080#1093#1086#1076#1072' ('#1073#1077#1079' '#1053#1044#1057')'
            DataBinding.FieldName = 'SummaWithOutVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 87
          end
          object colSummaWithVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1080#1093#1086#1076#1072' ('#1089' '#1053#1044#1057')'
            DataBinding.FieldName = 'SummaWithVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 87
          end
          object colSumma: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1080#1093#1086#1076#1072' '#1089' '#1091#1095'. % '#1082#1086#1088#1088'. ('#1089' '#1053#1044#1057')'
            DataBinding.FieldName = 'Summa'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 102
          end
          object colSummaSale: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'SummaSale'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PartionDescName: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103' '#1042#1080#1076
            DataBinding.FieldName = 'PartionDescName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object PartionInvNumber: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103' '#8470
            DataBinding.FieldName = 'PartionInvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object PartionOperDate: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103' '#1044#1072#1090#1072
            DataBinding.FieldName = 'PartionOperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object PartionPriceDescName: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103' '#1089'/'#1089' '#1042#1080#1076
            DataBinding.FieldName = 'PartionPriceDescName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
          object PartionPriceInvNumber: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103' '#1089'/'#1089' '#8470
            DataBinding.FieldName = 'PartionPriceInvNumber'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 55
          end
          object PartionPriceOperDate: TcxGridDBColumn
            Caption = #1055#1072#1088#1090#1080#1103' '#1089'/'#1089' '#1044#1072#1090#1072
            DataBinding.FieldName = 'PartionPriceOperDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object UnitName: TcxGridDBColumn
            Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077' ('#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072')'
            DataBinding.FieldName = 'UnitName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 108
          end
          object OurJuridicalName: TcxGridDBColumn
            Caption = #1070#1088'.'#1083#1080#1094#1086' ('#1087#1088#1080#1093#1086#1076' '#1086#1090' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072')'
            DataBinding.FieldName = 'OurJuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 100
          end
          object MP_JuridicalName: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082' ('#1084#1080#1085'.'#1094#1077#1085#1072')'
            DataBinding.FieldName = 'MP_JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object MP_ContractName: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088' ('#1084#1080#1085'.'#1094#1077#1085#1072')'
            DataBinding.FieldName = 'MP_ContractName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object MinPriceOnDate: TcxGridDBColumn
            Caption = #1052#1080#1085'.'#1094#1077#1085#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' '#1085#1072' '#1076#1072#1090#1091'  ('#1073#1077#1079' '#1053#1044#1057')'
            DataBinding.FieldName = 'MinPriceOnDate'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object MinPriceOnDateVAT: TcxGridDBColumn
            Caption = #1052#1080#1085'.'#1094#1077#1085#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072' '#1085#1072' '#1076#1072#1090#1091'  ('#1089' '#1053#1044#1057')'
            DataBinding.FieldName = 'MinPriceOnDateVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object MP_Summa: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'  ('#1073#1077#1079' '#1053#1044#1057')'
            DataBinding.FieldName = 'MP_Summa'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 90
          end
          object MP_SummaVAT: TcxGridDBColumn
            Caption = #1057#1091#1084#1084#1072' '#1087#1086#1089#1090#1072#1074#1097#1080#1082#1072'  ('#1089' '#1053#1044#1057')'
            DataBinding.FieldName = 'MP_SummaVAT'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DisplayFormat = ',0.00;-,0.00; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
        end
      end
    end
  end
  inherited Panel: TPanel
    Width = 930
    Height = 30
    ExplicitWidth = 930
    ExplicitHeight = 30
    inherited deStart: TcxDateEdit
      Left = 131
      Top = 4
      ExplicitLeft = 131
      ExplicitTop = 4
    end
    inherited deEnd: TcxDateEdit
      Left = 118
      Top = 32
      Visible = False
      ExplicitLeft = 118
      ExplicitTop = 32
    end
    inherited cxLabel1: TcxLabel
      Left = 19
      Caption = #1054#1089#1090#1072#1090#1086#1082' '#1085#1072' '#1085#1072#1095#1072#1083#1086':'
      ExplicitLeft = 19
      ExplicitWidth = 105
    end
    inherited cxLabel2: TcxLabel
      Left = 8
      Top = 33
      Visible = False
      ExplicitLeft = 8
      ExplicitTop = 33
    end
    object cxLabel4: TcxLabel
      Left = 230
      Top = 6
      Caption = #1055#1086#1076#1088#1072#1079#1076#1077#1083#1077#1085#1080#1077':'
    end
    object edUnit: TcxButtonEdit
      Left = 320
      Top = 4
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      TabOrder = 5
      Width = 201
    end
  end
  object cbPartion: TcxCheckBox [2]
    Left = 530
    Top = 4
    Action = actRefreshIsPartion
    TabOrder = 6
    Width = 94
  end
  object cbPartionPrice: TcxCheckBox [3]
    Left = 627
    Top = 4
    Action = actRefreshPartionPrice
    TabOrder = 7
    Width = 200
  end
  inherited cxPropertiesStore: TcxPropertiesStore
    Components = <
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
        Component = GuidesUnit
        Properties.Strings = (
          'Key'
          'TextValue')
      end
      item
        Component = Owner
        Properties.Strings = (
          'Height'
          'Left'
          'Tag'
          'Width')
      end>
  end
  inherited ActionList: TActionList
    object actOpenPartionReport: TdsdOpenForm
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1054#1090#1095#1077#1090' '#1087#1086' '#1087#1072#1088#1090#1080#1103#1084
      ImageIndex = 39
      FormName = 'TReport_GoodsPartionMoveForm'
      FormNameParam.Value = 'TReport_GoodsPartionMoveForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'UnitId'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'Key'
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = Null
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsId'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'Id'
          MultiSelectSeparator = ','
        end
        item
          Name = 'GoodsName'
          Value = Null
          Component = MasterCDS
          ComponentItem = 'GoodsName'
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartyId'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'PartyName'
          Value = Null
          MultiSelectSeparator = ','
        end
        item
          Name = 'RemainsDate'
          Value = Null
          Component = deStart
          MultiSelectSeparator = ','
        end>
      isShowModal = False
    end
    object actRefreshPartionPrice: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086#1082#1072#1079#1072#1090#1100' '#1076#1072#1085#1085#1099#1077' '#1080#1079' '#1087#1072#1088#1090#1080#1080' '#1094#1077#1085#1099
      Hint = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object actRefreshIsPartion: TdsdDataSetRefresh
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spSelect
      StoredProcList = <
        item
          StoredProc = spSelect
        end>
      Caption = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      Hint = #1087#1086' '#1055#1072#1088#1090#1080#1103#1084
      ShortCut = 116
      RefreshOnTabSetChanges = False
    end
    object ExecuteDialog: TExecuteDialog
      Category = 'DSDLib'
      MoveParams = <>
      Caption = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      Hint = #1048#1079#1084#1077#1085#1080#1090#1100' '#1087#1072#1088#1072#1084#1077#1090#1088#1099' '#1086#1090#1095#1077#1090#1072
      ImageIndex = 35
      FormName = 'TReport_GoodsRemainsDialogForm'
      FormNameParam.Value = 'TReport_GoodsRemainsDialogForm'
      FormNameParam.DataType = ftString
      FormNameParam.MultiSelectSeparator = ','
      GuiParams = <
        item
          Name = 'StartDate'
          Value = 41395d
          Component = deStart
          DataType = ftDateTime
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitId'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'Key'
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'UnitName'
          Value = ''
          Component = GuidesUnit
          ComponentItem = 'TextValue'
          DataType = ftString
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inIsPartion'
          Value = 'False'
          Component = cbPartion
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end
        item
          Name = 'inisPartionPrice'
          Value = 'False'
          Component = cbPartionPrice
          DataType = ftBoolean
          ParamType = ptInput
          MultiSelectSeparator = ','
        end>
      isShowModal = True
      RefreshDispatcher = RefreshDispatcher
      OpenBeforeShow = True
    end
  end
  inherited MasterDS: TDataSource
    Left = 16
    Top = 160
  end
  inherited MasterCDS: TClientDataSet
    Left = 208
    Top = 168
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_GoodsOnUnitRemains'
    Params = <
      item
        Name = 'inUnitId'
        Value = 41395d
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inRemainsDate'
        Value = 41395d
        Component = deStart
        DataType = ftDateTime
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inIsPartion'
        Value = Null
        Component = cbPartion
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'inisPartionPrice'
        Value = Null
        Component = cbPartionPrice
        DataType = ftBoolean
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 48
    Top = 152
  end
  inherited BarManager: TdxBarManager
    Left = 152
    Top = 144
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
          ItemName = 'bbGoodsPartyReport'
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
    object bbGoodsPartyReport: TdxBarButton
      Action = actOpenPartionReport
      Category = 0
    end
    object bbExecuteDialog: TdxBarButton
      Action = ExecuteDialog
      Category = 0
    end
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 424
    Top = 256
  end
  inherited PeriodChoice: TPeriodChoice
    Left = 272
    Top = 152
  end
  inherited RefreshDispatcher: TRefreshDispatcher
    ComponentList = <
      item
        Component = GuidesUnit
      end
      item
        Component = deStart
      end>
    Left = 96
    Top = 144
  end
  object GuidesUnit: TdsdGuides
    KeyField = 'Id'
    LookupControl = edUnit
    FormNameParam.Value = 'TUnit_ObjectForm'
    FormNameParam.DataType = ftString
    FormNameParam.MultiSelectSeparator = ','
    FormName = 'TUnit_ObjectForm'
    PositionDataSet = 'MasterCDS'
    Params = <
      item
        Name = 'Key'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'Key'
        ParamType = ptInput
        MultiSelectSeparator = ','
      end
      item
        Name = 'TextValue'
        Value = ''
        Component = GuidesUnit
        ComponentItem = 'TextValue'
        DataType = ftString
        ParamType = ptInput
        MultiSelectSeparator = ','
      end>
    Left = 256
    Top = 8
  end
end
