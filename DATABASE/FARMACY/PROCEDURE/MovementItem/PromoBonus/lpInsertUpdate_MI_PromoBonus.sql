-- Function: lpInsertUpdate_MI_PromoBonus()

DROP FUNCTION IF EXISTS lpInsertUpdate_MI_PromoBonus (Integer, Integer, Integer, Integer, TFloat, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_MI_PromoBonus(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inMIPromoId           Integer   , -- MI �������������� ���������
    IN inAmount              TFloat    , -- ������������� �����
    IN inUserId              Integer     -- ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
     
     IF EXISTS(SELECT 1
               FROM MovementItem

                   INNER JOIN MovementItemFloat AS MIPromo
                                                ON MIPromo.MovementItemId = MovementItem.Id
                                               AND MIPromo.DescId = zc_MIFloat_MovementItemId()

               WHERE MovementItem.MovementId = inMovementId
                 AND MovementItem.Id <> COALESCE (ioId, 0)
                 AND MovementItem.DescId = zc_MI_Master()
                 AND MIPromo.ValueData = inMIPromoId)
     THEN
        RAISE EXCEPTION '������. �� ������ � �������������� ��������� ������ ���� ���� ������.';     
     END IF;

     -- ������������ ������� ��������/�������������
     vbIsInsert:= COALESCE (ioId, 0) = 0;
          
     -- ��������� <������� ���������>
     ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Master(), inGoodsId, inMovementId, inAmount, NULL);

     -- ��������� <�������������>
     PERFORM lpInsertUpdate_MovementItemFloat (zc_MIFloat_MovementItemId(), ioId, inMIPromoId);
       

       -- ��������� <���� ���������>
     -- ���������
     IF COALESCE (inAmount, 0) <> (SELECT MovementItem.Amount
                                   FROM MovementItem WHERE  MovementItem.ID = ioId) OR
        vbIsInsert = TRUE AND COALESCE (inAmount, 0) <> 0
     THEN
       PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), ioId, CURRENT_TIMESTAMP);
     END IF;

     -- ����������� �������� ����� �� ���������
     PERFORM lpInsertUpdate_PromoBonus_TotalSumm (inMovementId);
     
     -- ��������� ��������
     PERFORM lpInsert_MovementItemProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 17.02.21                                                                      * 
 */

-- ����
-- select * from gpInsertUpdate_MI_PromoBonus(ioId := 410422039 , inMovementId := 22181875 , inGoodsId := 14051181 , inMIPromoId := 339776720 , inAmount := 1 ,  inSession := '3');