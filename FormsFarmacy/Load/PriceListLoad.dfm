inherited PriceListLoadForm: TPriceListLoadForm
  Caption = #1060#1086#1088#1084#1072' '#1079#1072#1075#1088#1091#1079#1082#1080' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1086#1074
  ClientHeight = 399
  ClientWidth = 597
  ExplicitWidth = 605
  ExplicitHeight = 426
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 597
    Height = 373
    ExplicitWidth = 597
    ExplicitHeight = 373
    ClientRectBottom = 373
    ClientRectRight = 597
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 597
      ExplicitHeight = 373
      inherited cxGrid: TcxGrid
        Width = 597
        Height = 373
        ExplicitWidth = 597
        ExplicitHeight = 373
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colOperDate: TcxGridDBColumn
            Caption = #1044#1072#1090#1072' '#1087#1088#1072#1081#1089'-'#1083#1080#1089#1090#1072
            DataBinding.FieldName = 'OperDate'
            Options.Editing = False
            Width = 131
          end
          object colJuridicalName: TcxGridDBColumn
            Caption = #1055#1086#1089#1090#1072#1074#1097#1080#1082
            DataBinding.FieldName = 'JuridicalName'
            Options.Editing = False
            Width = 403
          end
          object col: TcxGridDBColumn
            Options.Editing = False
            Width = 49
          end
        end
      end
    end
  end
  inherited ActionList: TActionList
    object dsdInsertUpdateAction1: TdsdInsertUpdateAction
      Category = 'DSDLib'
      MoveParams = <>
      Caption = 'dsdInsertUpdateAction1'
      FormNameParam.Value = ''
      FormNameParam.DataType = ftString
      GuiParams = <>
      isShowModal = False
      ActionType = acUpdate
      IdFieldName = 'Id'
    end
  end
  inherited MasterDS: TDataSource
    Top = 56
  end
  inherited MasterCDS: TClientDataSet
    Top = 56
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Movement_LoadPriceList'
    Top = 56
  end
  inherited BarManager: TdxBarManager
    Top = 56
    DockControlHeights = (
      0
      0
      26
      0)
  end
end
