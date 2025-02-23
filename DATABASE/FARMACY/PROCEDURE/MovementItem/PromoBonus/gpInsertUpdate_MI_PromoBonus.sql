-- Function: gpInsertUpdate_MI_PromoBonus()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_PromoBonus (Integer, Integer, Integer, Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_PromoBonus(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inGoodsId             Integer   , -- ������
    IN inMIPromoId           Integer   , -- MI �������������� ���������
    IN inAmount              TFloat    , -- ������������� �����
    IN inBonusInetOrder      TFloat    , -- ������ ������ ��� ���� �������, %
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Send());
    vbUserId := inSession;
    
    IF COALESCE (inAmount, 0) < 0 OR COALESCE (inAmount, 0) > 100
    THEN
        RAISE EXCEPTION '������. ������������� ����� ������ ���� � ��������� �� 0 �� 100.';         
    END IF;


     -- ���������
    ioId := lpInsertUpdate_MI_PromoBonus (ioId                 := ioId
                                        , inMovementId         := inMovementId
                                        , inGoodsId            := inGoodsId
                                        , inMIPromoId          := inMIPromoId
                                        , inAmount             := inAmount
                                        , inBonusInetOrder     := inBonusInetOrder
                                        , inUserId             := vbUserId
                                         );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_MI_PromoBonus (Integer, Integer, Integer, TFloat, TFloat, TVarChar) OWNER TO postgres;
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 17.02.21                                                                      *
*/

-- ����
-- select * from gpInsertUpdate_MI_PromoBonus(ioId := 0 , inMovementId := 19386934 , inGoodsId := 427 , inAmount := 10 , inNewExpirationDate := ('22.07.2020')::TDateTime , inContainerId := 20253754 ,  inSession := '3');