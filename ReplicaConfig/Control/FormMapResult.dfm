object MapResultForm: TMapResultForm
  Left = 0
  Top = 0
  Caption = 'MapResultForm'
  ClientHeight = 619
  ClientWidth = 1084
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 120
  TextHeight = 16
  object pnl: TPanel
    Left = 0
    Top = 0
    Width = 601
    Height = 619
    Align = alLeft
    Caption = 'pnl'
    TabOrder = 0
    inline MapFrame: TMapFrame
      Left = 1
      Top = 1
      Width = 599
      Height = 617
      Align = alClient
      TabOrder = 0
      ExplicitLeft = 1
      ExplicitTop = 1
      ExplicitWidth = 599
      ExplicitHeight = 617
      inherited GridPanel: TGridPanel
        Width = 599
        ControlCollection = <
          item
            Column = 1
            Control = MapFrame.lblSlave
            Row = 0
          end
          item
            Column = 0
            Control = MapFrame.lblMaster
            Row = 0
          end
          item
            Column = 0
            Control = MapFrame.edSlaveSearch
            Row = 1
          end
          item
            Column = 1
            Control = MapFrame.edMasterSeatch
            Row = 1
          end>
        ExplicitWidth = 599
        inherited lblSlave: TLabel
          Left = 297
          Width = 298
          ExplicitLeft = 297
        end
        inherited lblMaster: TLabel
          Width = 297
        end
        inherited edSlaveSearch: TEdit
          Width = 297
          ExplicitWidth = 297
        end
        inherited edMasterSeatch: TEdit
          Left = 297
          Width = 298
          ExplicitLeft = 297
          ExplicitWidth = 298
        end
      end
      inherited dgMaster: TDrawGrid
        Width = 599
        Height = 317
        OnSelectCell = MapFramedgMasterSelectCell
        ExplicitWidth = 599
        ExplicitHeight = 317
      end
      inherited dgFields: TDrawGrid
        Top = 366
        Width = 599
        ExplicitTop = 366
        ExplicitWidth = 599
      end
    end
  end
  object btnGenerateCustomIndex: TButton
    Left = 632
    Top = 8
    Width = 205
    Height = 29
    Caption = 'btnGenerateCustomIndex'
    TabOrder = 1
  end
  object mmAlter: TMemo
    Left = 636
    Top = 57
    Width = 429
    Height = 87
    Lines.Strings = (
      'mmAlter')
    TabOrder = 2
  end
  object mmSelect: TMemo
    Left = 636
    Top = 158
    Width = 429
    Height = 89
    Lines.Strings = (
      'mmSelect')
    TabOrder = 3
  end
  object mmUpdate: TMemo
    Left = 636
    Top = 261
    Width = 429
    Height = 89
    Lines.Strings = (
      'mmUpdate')
    TabOrder = 4
  end
  object mmInsert: TMemo
    Left = 636
    Top = 360
    Width = 429
    Height = 89
    Lines.Strings = (
      'mmInsert')
    TabOrder = 5
  end
end
