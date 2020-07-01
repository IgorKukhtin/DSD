-- Function: gpInsertUpdate_MovementItem_PromoCondition()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoCondition (Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoCondition (Integer, Integer, Integer, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PromoCondition(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inConditionPromoId    Integer   , -- ���� ������� <������� �������>
    IN inAmount              TFloat    , -- ��������
    IN inComment             TVarChar  , -- �����������
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PromoGoods());
    vbUserId := lpGetUserBySession (inSession);


    -- �������� - ���� ���� �������, �������������� ������
    PERFORM lpCheck_Movement_Promo_Sign (inMovementId:= inMovementId
                                       , inIsComplete:= FALSE
                                       , inIsUpdate  := TRUE
                                       , inUserId    := vbUserId
                                        );

    -- ��������� ������������ ������� � ���������
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
        RAISE EXCEPTION '������. � ��������� ��� ������� ��������� ������� <%>', (SELECT ValueData FROM Object WHERE id = inConditionPromoId);
    END IF;


    -- ���������
    ioId := lpInsertUpdate_MovementItem_PromoCondition (ioId                 := ioId
                                                      , inMovementId         := inMovementId
                                                      , inConditionPromoId   := inConditionPromoId
                                                      , inAmount             := inAmount
                                                      , inComment            := inComment
                                                      , inUserId             := vbUserId
                                                       );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_PromoCondition (Integer, Integer, Integer, TFloat, TVarChar, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.    ��������� �.�.
 25.11.15                                                                         * Comment
 05.11.15                                                                         *
*/