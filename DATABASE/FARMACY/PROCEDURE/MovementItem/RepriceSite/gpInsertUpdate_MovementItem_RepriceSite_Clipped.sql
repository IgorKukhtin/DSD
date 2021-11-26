-- Function: gpInsertUpdate_MovementItem_RepriceSite_Clipped()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_RepriceSite_Clipped (Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TFloat, TFloat, TFloat, Boolean, Integer, Integer, TFloat, TDateTime, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_RepriceSite_Clipped(
 INOUT ioId                  Integer   , -- ���� ������
    IN inGoodsId             Integer   , -- ������
    IN inJuridicalId         Integer   , -- ���������
    IN inContractId          Integer   , -- �������
    IN inExpirationDate      TDateTime , -- ���� ��������
    IN inMinExpirationDate   TDateTime , -- ���� �������� �������
    IN inAmount              TFloat    , -- ���������� (�������)

    IN inPriceOld            TFloat    , -- ���� ������
    IN inPriceNew            TFloat    , -- ���� �����
    IN inJuridical_Price     TFloat    , -- ���� ����������

    IN inisJuridicalTwo      Boolean   , -- ������ �� 2 �����������  
    IN inJuridicalTwoId      Integer   , -- ���������
    IN inContractTwoId       Integer   , -- �������
    IN inJuridical_PriceTwo  TFloat    , -- ���� ����������
    IN inExpirationDateTwo   TDateTime , -- ���� ��������

    IN inisPromoBonus        Boolean   , -- �� �������������� ������  
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
                                          AND MS_GUID.DescId    = zc_MovementString_Comment())
                      ,  tmpMovement AS (SELECT Movement.Id, Movement.OperDate, Movement.DescId
                                         FROM Movement
                                         WHERE Movement.Id IN (SELECT DISTINCT tmpMS_GUID.MovementId FROM tmpMS_GUID)
                                        )
                    -- ���������
                    SELECT Movement.Id AS MovementId
                    FROM tmpMovement AS Movement
                    WHERE Movement.OperDate = CURRENT_DATE
                      AND Movement.DescId   = zc_Movement_RepriceSite()
                      -- AND Movement.OperDate >= CURRENT_DATE AND Movement.OperDate < CURRENT_DATE + INTERVAL '1 DAY'
                   );


    IF COALESCE (vbMovementId, 0) = 0
    THEN
        --
        vbMovementId := lpInsertUpdate_Movement_RepriceSite(ioId        := COALESCE (vbMovementId,0),
                                                            inInvNumber := CAST (NEXTVAL('movement_RepriceSite_seq') AS TVarChar),
                                                            inOperDate  := CURRENT_DATE::TDateTime,
                                                            inGUID      := inGUID,
                                                            inUserId    := vbUserId);
    END IF;
        

    -- ��������� ������
    ioId := lpInsertUpdate_MovementItem_RepriceSite (ioId                 := COALESCE(ioId,0)
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
                                                   , inisJuridicalTwo     := inisJuridicalTwo
                                                   , inJuridicalTwoId     := inJuridicalTwoId
                                                   , inContractTwoId      := inContractTwoId
                                                   , inJuridical_PriceTwo := inJuridical_PriceTwo
                                                   , inExpirationDateTwo  := inExpirationDateTwo
                                                   , inUserId             := vbUserId);

    -- ��������� <������� ��� ���������>
    PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_ClippedReprice(), ioId, True);
    
    -- ��������� <�� �������������� ������ >
    IF COALESCE (inisPromoBonus, False) = TRUE
    THEN
      PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_PromoBonus(), ioId, inisPromoBonus);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 10.06.21                                                      *  
*/