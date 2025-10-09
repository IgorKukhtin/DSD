-- Function: gpUpdate_MI_Income_isMask()

DROP FUNCTION IF EXISTS gpUpdate_MI_Income_isMask (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_MI_Income_isMask(
    IN inMovementId      Integer      , -- ���� ���������
    IN inMovementMaskId  Integer      , -- ���� ��������� �����
    IN inSession         TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpGetUserBySession (inSession);

      -- ���������
       CREATE TEMP TABLE tmpMI ON COMMIT DROP AS (

         WITH
          -- ������ �� ���. ���������
          tmpGoods AS (SELECT DISTINCT MovementItem.ObjectId AS GoodsId
                       FROM MovementItem
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId = zc_MI_Master()
                         AND MovementItem.isErased = FALSE
                      )
          -- ������ �� ��������� �����
        , tmpGoods_mask AS (SELECT gpSelect.GoodsId
                                 , gpSelect.Amount
                                 , gpSelect.DiscountTax
                                 , gpSelect.CountForPrice
                                 , gpSelect.OperPrice
                                 , gpSelect.OperPrice_orig
                                 , gpSelect.OperPrice_orig_old
                                 , gpSelect.SummIn
                                 , gpSelect.EmpfPrice
                                 , gpSelect.OperPriceList
                                 , gpSelect.PartNumber
                                 , gpSelect.PartionCellName
                                 , gpSelect.Comment 
                                 , gpSelect.GoodsSizeName
                                 , gpSelect.Weight
                            FROM gpSelect_MI_Income_Master (inMovementMaskId, FALSE, FALSE, inSession) AS gpSelect
                           )

        SELECT tmp.*
        FROM tmpGoods_mask AS tmp
            LEFT JOIN tmpGoods ON tmpGoods.GoodsId = tmp.GoodsId
        WHERE tmpGoods.GoodsId IS NULL
       );


     --c��������  ������ ������ �� ������, ������� ��� � ���. ���������
     PERFORM gpInsertUpdate_MovementItem_Income (ioId                  := 0
                                               , inMovementId          := inMovementId
                                               , inGoodsId             := tmpMI.GoodsId
                                               , inAmount              := COALESCE (tmpMI.Amount, 0)

                                               , inOperPrice_orig      := COALESCE (tmpMI.OperPrice_orig, 0)
                                               , inCountForPrice       := COALESCE (tmpMI.CountForPrice, 0)
                                               , ioDiscountTax         := COALESCE (tmpMI.DiscountTax, 0)
                                               , ioOperPrice           := COALESCE (tmpMI.OperPrice, 0)
                                               , ioSummIn              := COALESCE (tmpMI.SummIn, 0)
                                               , inAmount_old          := COALESCE (tmpMI.Amount, 0)
                                               , inOperPrice_orig_old  := COALESCE (tmpMI.OperPrice_orig_old, 0)
                                               , inDiscountTax_old     := COALESCE (tmpMI.DiscountTax, 0)
                                               , inOperPrice_old       := COALESCE (tmpMI.OperPrice, 0)
                                               , inSummIn_old          := COALESCE (tmpMI.SummIn, 0)

                                               , inOperPriceList       := COALESCE (tmpMI.OperPriceList, 0)
                                               , inEmpfPrice           := COALESCE (tmpMI.EmpfPrice, 0)
                                               , inPartNumber          := tmpMI.PartNumber
                                               , ioPartionCellName     := tmpMI.PartionCellName
                                               , inComment             := tmpMI.Comment
                                               , inGoodsSizeName       := tmpMI.GoodsSizeName
                                               , inWeight              := tmpMI.Weight
                                               , inSession             := inSession
                                                )
     FROM tmpMI;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.06.23         *
 02.06.22         *
*/

-- ����
--