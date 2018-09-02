-- Function: gpInsert_MovementItem_Reprice()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_RepriceChange (Integer, Integer, Integer, Integer, TFloat, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_RepriceChange (Integer, Integer, Integer, Integer, TFloat, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_RepriceChange(
 INOUT ioId                  Integer   , -- ���� ������
    IN inGoodsId             Integer   , -- ������
    IN inRetailId            Integer   , -- �������������
    IN inRetailId_Forwarding Integer   , -- �������������(��������� ��� ��������� ���)
    IN inTax                 TFloat    , -- % +/-
    IN inJuridicalId         Integer   , -- ���������
    IN inContractId          Integer   , -- �������
    IN inExpirationDate      TDateTime , -- ���� ��������
    IN inMinExpirationDate   TDateTime , -- ���� �������� �������
    IN inAmount              TFloat    , -- ���������� (�������)
    IN inPriceOld            TFloat    , -- ���� ������
    IN inPriceNew            TFloat    , -- ���� �����
    IN inJuridical_Price     TFloat    , -- ���� ����������
    IN inJuridical_Percent   TFloat    , -- % ������������� ������� ����������
    IN inContract_Percent    TFloat    , -- % ������������� ������� ��������
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
    vbMovementId:= (WITH tmpMS_GUID AS (SELECT MS_GUID.MovementId
                                        FROM MovementString AS MS_GUID
                                        WHERE MS_GUID.ValueData = inGUID
                                          AND MS_GUID.DescId    = zc_MovementString_Comment()
                                       )
                      ,  tmpMLO_Retail AS (SELECT MLO_Retail.MovementId
                                         FROM MovementLinkObject AS MLO_Retail
                                         WHERE MLO_Retail.MovementId IN (SELECT DISTINCT tmpMS_GUID.MovementId FROM tmpMS_GUID)
                                           AND MLO_Retail.DescId     = zc_MovementLinkObject_Retail()
                                           AND MLO_Retail.ObjectId   = inRetailId
                                        )
                      ,  tmpMovement AS (SELECT Movement.Id, Movement.OperDate, Movement.DescId
                                         FROM Movement
                                         WHERE Movement.Id IN (SELECT DISTINCT tmpMLO_Retail.MovementId FROM tmpMLO_Retail)
                                        )
                    -- ���������
                    SELECT Movement.Id AS MovementId
                    FROM tmpMovement AS Movement
                    WHERE Movement.OperDate = CURRENT_DATE
                      AND Movement.DescId   = zc_Movement_RepriceChange()
                   );

    IF COALESCE (vbMovementId, 0) = 0
    THEN
        --
        vbMovementId := lpInsertUpdate_Movement_RepriceChange(ioId        := COALESCE (vbMovementId,0),
                                                              inInvNumber := CAST (NEXTVAL('movement_repricechange_seq') AS TVarChar),
                                                              inOperDate  := CURRENT_DATE::TDateTime,
                                                              inRetailId  := inRetailId,
                                                              inGUID      := inGUID,
                                                              inUserId    := vbUserId
                                                             );

        -- ��������� ����� � <�������������(��������� ��� ��������� ���)>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_RetailForwarding(), vbMovementId, inRetailId_Forwarding);
        -- ��������� <(-)% ������ (+)% ������� (��������� ��� ��������� ���)>
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), vbMovementId, inTax);


    ELSE
        -- ��������� ����� � <�������������(��������� ��� ��������� ���)>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_RetailForwarding(), vbMovementId, inRetailId_Forwarding);
        -- ��������� <(-)% ������ (+)% ������� (��������� ��� ��������� ���)>
        PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), vbMovementId, inTax);

    END IF;

    -- ����������� �����
    PERFORM lpInsertUpdate_Object_PriceChange(inGoodsId     := inGoodsId,
                                              inRetailId    := inRetailId,
                                              inPriceChange := inPriceNew,
                                              inDate        := CURRENT_DATE::TDateTime,
                                              inUserId      := vbUserId);

    -- ��������� ������
    ioId := lpInsertUpdate_MovementItem_RepriceChange (ioId                 := COALESCE (ioId, 0)
                                                     , inMovementId         := vbMovementId
                                                     , inGoodsId            := inGoodsId
                                                     , inJuridicalId        := inJuridicalId
                                                     , inContractId         := inContractId
                                                     , inExpirationDate  := inExpirationDate
                                                     , inMinExpirationDate  := inMinExpirationDate
                                                     , inAmount             := inAmount
                                                     , inPriceOld           := inPriceOld
                                                     , inPriceNew           := inPriceNew
                                                     , inJuridical_Price    := inJuridical_Price
                                                     , inJuridical_Percent  := inJuridical_Percent
                                                     , inContract_Percent   := inContract_Percent
                                                     , inUserId             := vbUserId
                                                      );


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.08.18         *
*/
-- SELECT COUNT(*) FROM Log_RepriceChange
-- SELECT * FROM Log_RepriceChange WHERE TextValue NOT LIKE '%InsertUpdate%' ORDER BY Id DESC LIMIT 100
-- SELECT * FROM Log_RepriceChange ORDER BY Id DESC LIMIT 100
