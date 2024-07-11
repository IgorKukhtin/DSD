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
       CREATE TEMP TABLE tmpMI (GoodsId Integer
                              , Amount TFloat, OperPriceList TFloat
                              , PartNumber TVarChar) ON COMMIT DROP;

      INSERT INTO tmpMI (GoodsId, Amount, OperPriceList, PartNumber)

         WITH
         --������ �� ���. ��������� 
          tmpGoods AS (SELECT DISTINCT MovementItem.ObjectId AS GoodsId
                       FROM MovementItem 
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId = zc_MI_Master()
                         AND MovementItem.isErased = FALSE
                      )
          --������ �� ��������� �����
        , tmpGoods_mask AS (SELECT MovementItem.ObjectId           AS GoodsId
                                 , MIFloat_OperPriceList.ValueData AS OperPriceList
                                 , MIString_PartNumber.ValueData   AS PartNumber 
                                 , SUM (MovementItem.Amount)       AS Amount
                            FROM MovementItem

                                 LEFT JOIN MovementItemFloat AS MIFloat_OperPriceList
                                                             ON MIFloat_OperPriceList.MovementItemId = MovementItem.Id
                                                            AND MIFloat_OperPriceList.DescId = zc_MIFloat_OperPriceList()

                                 LEFT JOIN MovementItemString AS MIString_PartNumber
                                                              ON MIString_PartNumber.MovementItemId = MovementItem.Id
                                                             AND MIString_PartNumber.DescId = zc_MIString_PartNumber() 

                            WHERE MovementItem.MovementId = inMovementMaskId
                              AND MovementItem.DescId     = zc_MI_Master()
                              AND MovementItem.isErased   = FALSE
                            GROUP BY MovementItem.ObjectId
                                   , MIFloat_OperPriceList.ValueData
                                   , MIString_PartNumber.ValueData 
                            )
                            
        SELECT tmp.GoodsId
             , tmp.Amount
             , tmp.OperPriceList  ::TFloat
             , tmp.PartNumber     ::TVarChar
        FROM tmpGoods_mask AS tmp
            LEFT JOIN tmpGoods ON tmpGoods.GoodsId = tmp.GoodsId
        WHERE tmpGoods.GoodsId IS NULL;


     --c��������  ������ ������ �� ������, ������� ��� � ���. ���������                
     PERFORM  lpInsertUpdate_MovementItem_Income (ioId            := 0             ::Integer
                                                , inMovementId    := inMovementId  ::Integer
                                                , inGoodsId       := tmpMI.GoodsId ::Integer
                                                , inAmount        := tmpMI.Amount  ::TFloat
                                                , inOperPriceList := COALESCE (tmpMI.OperPriceList,0) ::TFloat
                                                , inPartNumber    := COALESCE (tmpMI.PartNumber,'')   ::TVarChar
                                                , inComment       := ''            ::TVarChar
                                                , inPartionCellId := NULL            ::Integer
                                                , inUserId        := vbUserId      ::Integer
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