-- Function: gpInsertUpdate_Movement_SalePromoGoods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SalePromoGoods (Integer, TVarChar, TDateTime, Integer, TDateTime, TDateTime, TVarChar, Boolean, TFloat, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SalePromoGoods(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inRetailID              Integer    , -- �������� ����
    IN inStartPromo            TDateTime  , -- ���� ������ ���������
    IN inEndPromo              TDateTime  , -- ���� ��������� ���������
    IN inComment               TVarChar   , -- ����������
    IN inisAmountCheck         Boolean    , -- ����� �� ����� ����
    IN inAmountCheck           TFloat     , -- �� ����� ����
    IN inisDiscountInformation Boolean    , -- �������������� � ������
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());
    vbUserId := inSession;
    
    IF (COALESCE (inisAmountCheck, False) = TRUE OR COALESCE (inAmountCheck, 0) <> 0) AND
       EXISTS (SELECT 1
               FROM MovementItem AS MI_PromoCode
               WHERE MI_PromoCode.MovementId = ioId
                 AND MI_PromoCode.DescId = zc_MI_Master()
                 AND MI_PromoCode.isErased = FALSE)
    THEN
      RAISE EXCEPTION '��� ��������� "��������� ����� �� ����� ����" �� ���� �������� �������� ������.';
    END IF;
    
    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement_SalePromoGoods (ioId            := ioId
                                                  , inInvNumber     := inInvNumber
                                                  , inOperDate      := inOperDate
                                                  , inRetailID      := inRetailID
                                                  , inStartPromo    := inStartPromo
                                                  , inEndPromo      := inEndPromo
                                                  , inComment       := inComment
                                                  , inisAmountCheck := inisAmountCheck
                                                  , inAmountCheck   := inAmountCheck
                                                  , inisDiscountInformation := inisDiscountInformation
                                                  , inUserId        := vbUserId
                                                  );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ������ �.�.
 07.09.22                                                       *
*/