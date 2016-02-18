inherited JuridicalSettingsForm: TJuridicalSettingsForm
  Caption = #1059#1089#1090#1072#1085#1086#1074#1082#1080' '#1102#1088' '#1083#1080#1094
  ClientHeight = 311
  ClientWidth = 892
  ExplicitWidth = 908
  ExplicitHeight = 349
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 892
    Height = 285
    ExplicitWidth = 793
    ClientRectBottom = 285
    ClientRectRight = 892
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 793
      ExplicitHeight = 282
      inherited cxGrid: TcxGrid
        Width = 892
        Height = 285
        ExplicitWidth = 793
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colName: TcxGridDBColumn
            Caption = #8470' '#1076#1086#1075'.'
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 70
          end
          object colMainJuridical: TcxGridDBColumn
            Caption = #1053#1072#1096#1077' '#1102#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'MainJuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 122
          end
          object colJuridicalName: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 162
          end
          object colContract: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088
            DataBinding.FieldName = 'ContractName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 158
          end
          object colisPriceClose: TcxGridDBColumn
            Caption = #1055#1088#1072#1081#1089' '#1079#1072#1082#1088#1099#1090
            DataBinding.FieldName = 'isPriceClose'
            PropertiesClassName = 'TcxCheckBoxProperties'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 108
          end
          object colBonus: TcxGridDBColumn
            Caption = #1041#1086#1085#1091#1089
            DataBinding.FieldName = 'Bonus'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 73
          end
          object colPriceLimit: TcxGridDBColumn
            Caption = #1062#1077#1085#1072' '#1076#1086
            DataBinding.FieldName = 'PriceLimit'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1054#1075#1088#1072#1085#1080#1095#1077#1085#1080#1077' "'#1062#1077#1085#1072' '#1076#1086'"'
            Width = 70
          end
          object colStartDate: TcxGridDBColumn
            Caption = #1044#1077#1081#1089#1090#1074'. '#1089
            DataBinding.FieldName = 'StartDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 65
          end
          object colEndDate: TcxGridDBColumn
            Caption = #1044#1077#1081#1089#1090#1074'. '#1076#1086
            DataBinding.FieldName = 'EndDate'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 74
          end
          object colСonditionalPercent: TcxGridDBColumn
            Caption = #1044#1086#1087'. % '#1087#1086' '#1087#1088#1072#1081#1089#1091
            DataBinding.FieldName = #1057'onditionalPercent'
            PropertiesClassName = 'TcxCurrencyEditProperties'
            Properties.DecimalPlaces = 4
            Properties.DisplayFormat = ',0.####;-,0.####; ;'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            HeaderHint = #1044#1086#1087'. '#1091#1089#1083#1086#1074#1080#1103' '#1087#1086' '#1087#1088#1072#1081#1089#1091', %'
            Width = 65
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    object UpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      PostDataSetBeforeExecute = False
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'UpdateDataSet'
      DataSource = MasterDS
    end
  end
  inherited MasterDS: TDataSource
    Left = 88
    Top = 80
  end
  inherited MasterCDS: TClientDataSet
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_JuridicalSettings'
    Left = 152
    Top = 64
  end
  inherited BarManager: TdxBarManager
    Left = 160
    Top = 65528
    DockControlHeights = (
      0
      0
      26
      0)
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_JuridicalSettings'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inName'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Name'
        DataType = ftString
        ParamType = ptInput
      end
      item
        Name = 'inJuridicalId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
      end
      item
        Name = 'inMainJuridicalId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'MainJuridicalId'
        ParamType = ptInput
      end
      item
        Name = 'inContractId'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
      end
      item
        Name = 'inisPriceClose'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'isPriceClose'
        DataType = ftBoolean
        ParamType = ptInput
      end
      item
        Name = 'inBonus'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'Bonus'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'inPriceLimit'
        Value = Null
        Component = MasterCDS
        ComponentItem = 'PriceLimit'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'in'#1057'onditionalPercent'
        Value = Null
        Component = MasterCDS
        ComponentItem = #1057'onditionalPercent'
        DataType = ftFloat
        ParamType = ptInput
      end
      item
        Name = 'InStartDate'
        Value = 'Null'
        Component = MasterCDS
        ComponentItem = 'StartDate'
        DataType = ftDateTime
        ParamType = ptInput
      end
      item
        Name = 'inEndDate'
        Value = 0
        Component = MasterCDS
        ComponentItem = 'EndDate'
        DataType = ftDateTime
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 152
    Top = 152
  end
end
