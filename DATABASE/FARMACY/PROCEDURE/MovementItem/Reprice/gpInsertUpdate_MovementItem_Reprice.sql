-- Function: gpInsert_MovementItem_Reprice()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_Reprice (Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsert_MovementItem_Reprice (integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Reprice(
 INOUT ioId                  Integer   , -- ���� ������
    IN inGoodsId             Integer   , -- ������
    IN inUnitId              Integer   , -- ������
    IN inAmount              TFloat    , -- ����������
    IN inPriceOld            TFloat    , -- ���� ������
    IN inPriceNew            TFloat    , -- ���� �����
    IN inGUID                TVarChar  , -- GUID ��� ����������� ������� ����������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Integer 
AS 
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMovementId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
    -- ����� ��������
    SELECT
        Movement_Reprice.Id
    INTO
        vbMovementId
    FROM
        Movement_Reprice_View AS Movement_Reprice
    WHERE
        DATE_TRUNC ('DAY', Movement_Reprice.OperDate) = DATE_TRUNC ('DAY', CURRENT_DATE)
        AND
        Movement_Reprice.UnitId = inUnitId
        AND
        Movement_Reprice.GUID = inGUID;
    IF COALESCE(vbMovementId,0) = 0
    THEN
        vbMovementId := lpInsertUpdate_Movement_Reprice(ioId        := COALESCE(vbMovementId,0),
                                                        inInvNumber := CAST(NEXTVAL('movement_sale_seq') AS TVarChar),
                                                        inOperDate  := CURRENT_DATE::TDateTime,
                                                        inUnitId    := inUnitId,
                                                        inGUID      := inGUID,
                                                        inUserId    := vbUserId);
    END IF;
    --����������� �����
    PERFORM lpInsertUpdate_Object_Price(inGoodsId := inGoodsId,
                                        inUnitId  := inUnitId,
                                        inPrice   := inPriceNew,
                                        inDate    := CURRENT_DATE::TDateTime,
                                        inUserId  := vbUserId);

    -- ��������� ������
    ioId := lpInsertUpdate_MovementItem_Reprice (ioId                 := COALESCE(ioId,0)
                                               , inMovementId         := vbMovementId
                                               , inGoodsId            := inGoodsId
                                               , inAmount             := inAmount
                                               , inPriceOld           := inPriceOld
                                               , inPriceNew           := inPriceNew
                                               , inUserId             := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_MovementItem_Reprice (Integer, Integer, Integer, TFloat, TFloat, TFloat, TVarChar, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.    ��������� �.�.
 27.11.15                                                                       *
*/