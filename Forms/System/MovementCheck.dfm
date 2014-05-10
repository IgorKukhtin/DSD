inherited MovementCheckForm: TMovementCheckForm
  Caption = #1054#1096#1080#1073#1082#1080' '#1087#1086' '#1076#1086#1082#1091#1084#1077#1085#1090#1091
  ClientHeight = 368
  ClientWidth = 854
  AddOnFormData.Params = FormParams
  ExplicitWidth = 862
  ExplicitHeight = 402
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
            Caption = #1055#1072#1088#1072#1084#1077#1090#1088
            DataBinding.FieldName = 'ParamText'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 88
          end
          object colParam_Sale: TcxGridDBColumn
            Caption = #1044#1086#1082'. '#1087#1088#1086#1076#1072#1078#1080
            DataBinding.FieldName = 'Param_Sale'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object colParam_Tax: TcxGridDBColumn
            Caption = #1044#1086#1082'. '#1085#1072#1083#1086#1075#1086#1074#1072#1103
            DataBinding.FieldName = 'Param_Tax'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 90
          end
          object colParam_TaxCorrective: TcxGridDBColumn
            Caption = #1044#1086#1082'. '#1082#1086#1088#1088#1077#1082#1090#1080#1088#1086#1074#1082#1072
            DataBinding.FieldName = 'Param_TaxCorrective'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Width = 80
          end
        end
      end
    end
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
  end
  inherited BarManager: TdxBarManager
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
