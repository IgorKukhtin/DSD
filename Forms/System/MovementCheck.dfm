inherited MovementCheckForm: TMovementCheckForm
  Caption = #1054#1096#1080#1073#1082#1080' '#1087#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1091
  ClientHeight = 368
  ClientWidth = 854
  AddOnFormData.Params = FormParams
  ExplicitWidth = 862
  ExplicitHeight = 395
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 854
    Height = 342
    ExplicitWidth = 854
    ExplicitHeight = 342
    ClientRectBottom = 342
    ClientRectRight = 854
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 854
      ExplicitHeight = 342
      inherited cxGrid: TcxGrid
        Width = 854
        Height = 342
        ExplicitWidth = 854
        ExplicitHeight = 342
        inherited cxGridDBTableView: TcxGridDBTableView
          DataController.Summary.DefaultGroupSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
              Position = spFooter
            end
            item
              Format = ',0.00'
              Kind = skSum
              Position = spFooter
            end>
          DataController.Summary.FooterSummaryItems = <
            item
              Format = ',0.00'
              Kind = skSum
            end
            item
              Format = ',0.00'
              Kind = skSum
            end>
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object colParamText: TcxGridDBColumn
            Caption = #1056#1077#1082#1074#1080#1079#1080#1090
            DataBinding.FieldName = 'ParamText'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 88
          end
          object colParam_Doc1: TcxGridDBColumn
            Caption = #1044#1086#1082#1091#1084#1077#1085#1090' 1'
            DataBinding.FieldName = 'Param_Doc1'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object colParam_Doc2: TcxGridDBColumn
            Caption = #1044#1086#1082#1091#1084#1077#1085#1090' 2'
            DataBinding.FieldName = 'Param_Doc2'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
        end
      end
    end
  end
  inherited MasterDS: TDataSource
    Top = 72
  end
  inherited MasterCDS: TClientDataSet
    Top = 72
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_MovementCheck'
    Params = <
      item
        Name = 'inmovementid'
        Value = Null
        Component = FormParams
        ComponentItem = 'Id'
        ParamType = ptInput
      end>
    Top = 72
  end
  inherited BarManager: TdxBarManager
    Top = 72
    DockControlHeights = (
      0
      0
      26
      0)
  end
  inherited DBViewAddOn: TdsdDBViewAddOn
    Left = 360
    Top = 120
  end
  object FormParams: TdsdFormParams
    Params = <
      item
        Name = 'Id'
        Value = Null
      end>
    Left = 152
    Top = 264
  end
end
