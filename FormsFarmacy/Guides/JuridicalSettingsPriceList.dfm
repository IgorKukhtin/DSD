inherited JuridicalSettingsPriceListForm: TJuridicalSettingsPriceListForm
  Caption = #1047#1072#1082#1088#1099#1090#1080#1077' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1086#1074
  ClientWidth = 415
  ExplicitWidth = 423
  ExplicitHeight = 335
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 415
    ExplicitWidth = 395
    ClientRectRight = 415
    inherited tsMain: TcxTabSheet
      inherited cxGrid: TcxGrid
        Width = 415
        ExplicitWidth = 395
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colJuridicalName: TcxGridDBColumn
            Caption = #1070#1088'. '#1083#1080#1094#1086
            DataBinding.FieldName = 'JuridicalName'
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 162
          end
          object colContract: TcxGridDBColumn
            Caption = #1044#1086#1075#1086#1074#1086#1088
            DataBinding.FieldName = 'ContractName'
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
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    object UpdateDataSet: TdsdUpdateDataSet
      Category = 'DSDLib'
      MoveParams = <>
      StoredProc = spInsertUpdate
      StoredProcList = <
        item
          StoredProc = spInsertUpdate
        end>
      Caption = 'UpdateDataSet'
      DataSource = MasterDS
    end
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_JuridicalSettingsPriceList'
  end
  inherited BarManager: TdxBarManager
    DockControlHeights = (
      0
      0
      26
      0)
  end
  object spInsertUpdate: TdsdStoredProc
    StoredProcName = 'gpInsertUpdate_Object_JuridicalSettings_PriceList'
    DataSets = <>
    OutputType = otResult
    Params = <
      item
        Name = 'ioId'
        Component = MasterCDS
        ComponentItem = 'Id'
        ParamType = ptInputOutput
      end
      item
        Name = 'inJuridicalId'
        Component = MasterCDS
        ComponentItem = 'JuridicalId'
        ParamType = ptInput
      end
      item
        Name = 'inContractId'
        Component = MasterCDS
        ComponentItem = 'ContractId'
        ParamType = ptInput
      end
      item
        Name = 'inisPriceClose'
        Component = MasterCDS
        ComponentItem = 'isPriceClose'
        DataType = ftBoolean
        ParamType = ptInput
      end>
    PackSize = 1
    Left = 152
    Top = 152
  end
end
