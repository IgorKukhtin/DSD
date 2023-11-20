inherited MoneyPlace_ObjectForm: TMoneyPlace_ObjectForm
  Caption = #1057#1087#1088#1072#1074#1086#1095#1085#1080#1082
  ClientHeight = 480
  ClientWidth = 669
  ExplicitWidth = 685
  ExplicitHeight = 519
  PixelsPerInch = 96
  TextHeight = 13
  inherited PageControl: TcxPageControl
    Width = 669
    Height = 413
    ExplicitWidth = 669
    ExplicitHeight = 413
    ClientRectBottom = 413
    ClientRectRight = 669
    inherited tsMain: TcxTabSheet
      ExplicitWidth = 669
      ExplicitHeight = 413
      inherited cxGrid: TcxGrid
        Width = 669
        Height = 413
        ExplicitWidth = 669
        ExplicitHeight = 413
        inherited cxGridDBTableView: TcxGridDBTableView
          OptionsData.CancelOnExit = True
          OptionsData.Deleting = False
          OptionsData.DeletingConfirmation = False
          OptionsData.Editing = False
          Styles.Content = nil
          Styles.Inactive = nil
          Styles.Selection = nil
          Styles.Footer = nil
          Styles.Header = nil
          object Code: TcxGridDBColumn
            Caption = #1050#1086#1076
            DataBinding.FieldName = 'Code'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 70
          end
          object Name: TcxGridDBColumn
            Caption = #1053#1072#1079#1074#1072#1085#1080#1077
            DataBinding.FieldName = 'Name'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 400
          end
          object ItemName: TcxGridDBColumn
            Caption = #1069#1083#1077#1084#1077#1085#1090
            DataBinding.FieldName = 'ItemName'
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 174
          end
          object IsErased: TcxGridDBColumn
            Caption = #1059#1076#1072#1083#1077#1085
            DataBinding.FieldName = 'isErased'
            Visible = False
            HeaderAlignmentHorz = taCenter
            HeaderAlignmentVert = vaCenter
            Options.Editing = False
            Width = 20
          end
        end
      end
    end
  end
  object Panel_btn: TPanel [1]
    Left = 0
    Top = 439
    Width = 669
    Height = 41
    Align = alBottom
    TabOrder = 5
    object btnFormClose: TcxButton
      Left = 381
      Top = 7
      Width = 90
      Height = 25
      Action = actFormClose
      TabOrder = 0
    end
    object btnChoiceGuides: TcxButton
      Left = 203
      Top = 7
      Width = 90
      Height = 25
      Action = actChoiceGuides
      TabOrder = 1
    end
  end
  inherited MasterDS: TDataSource
    Top = 80
  end
  inherited MasterCDS: TClientDataSet
    Top = 80
  end
  inherited spSelect: TdsdStoredProc
    StoredProcName = 'gpSelect_Object_MoneyPlace'
    Top = 80
  end
  inherited BarManager: TdxBarManager
    Top = 80
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
          ItemName = 'bbRefresh'
        end
        item
          Visible = True
          ItemName = 'dxBarStatic'
        end
        item
          Visible = True
          ItemName = 'bbChoice'
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
  end
end
