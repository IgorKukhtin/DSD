inherited FileTypeKindForm: TFileTypeKindForm
  Caption = #1089#1087#1088#1072#1074#1086#1095#1085#1080#1082' <'#1058#1080#1087#1099' '#1092#1072#1081#1083#1086#1074' >'
  ClientHeight = 233
  ClientWidth = 334
  ExplicitWidth = 342
  ExplicitHeight = 267
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 334
    Height = 205
    ExplicitWidth = 334
    ExplicitHeight = 207
    ClientRectBottom = 201
    ClientRectRight = 330
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 334
      ExplicitHeight = 207
      inherited cxGrid: TcxGrid
        Width = 334
        Height = 207
        ExplicitWidth = 334
        ExplicitHeight = 207
        inherited cxGridDBTableView: TcxGridDBTableView
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object clName: TcxGridDBColumn
            Caption = #1058#1080#1087' '#1092#1072#1081#1083#1072
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 252
          end
        end
      end
    end
  end
  inherited MasterDS: TDataSource
    Left = 72
    Top = 40
  end
  inherited MasterCDS: TClientDataSet
    Left = 24
    Top = 40
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_FileTypeKind'
    Left = 152
    Top = 72
  end
  inherited BarManager: TdxBarManager
    Left = 176
    DockControlHeights = (
      0
      0
      28
      0)
  end
end
