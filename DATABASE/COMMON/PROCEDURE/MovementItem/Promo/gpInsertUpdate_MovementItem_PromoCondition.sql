-- Function: gpInsertUpdate_MovementItem_PromoCondition()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoCondition (Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PromoCondition(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inConditionPromoId    Integer   , -- ���� ������� <������� �������>
    IN inAmount              TFloat    , -- ��������
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbPriceList Integer;
   DECLARE vbPriceWithWAT Boolean;
   DECLARE vbVAT TFloat;
   
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PromoGoods());
    vbUserId := inSession;
    --��������� ������������ ������� � ���������
    IF EXISTS(SELECT 1 
              FROM
                  MovementItem_PromoCondition_View AS MI_PromoCondition
              WHERE
                  MI_PromoCondition.MovementId = inMovementId
                  AND
                  MI_PromoCondition.ConditionPromoId = inConditionPromoId
                  AND
                  MI_PromoCondition.Id <> COALESCE(ioId,0))
    THEN
        RAISE EXCEPTION '������. � ��������� ��� ������� ��������� �������', (SELECT ValueData FROM Object WHERE id = inConditionPromoId);
    END IF;
    
    -- ���������
    ioId := lpInsertUpdate_MovementItem_PromoCondition (ioId                 := ioId
                                                      , inMovementId         := inMovementId
                                                      , inConditionPromoId   := inConditionPromoId
                                                      , inAmount             := inAmount
                                                      , inUserId             := vbUserId
                                                       );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_PromoCondition (Integer, Integer, Integer, TFloat, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.    ��������� �.�.
 05.11.15                                                                         *
*/