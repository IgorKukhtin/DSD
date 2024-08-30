-- Function: gpInsertUpdate_Movement_PromoTrade()
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoTrade (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PromoTrade(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������  
    IN inContractId            Integer    , -- �������  
    IN inPromoItemId           Integer    , -- ������ ������
    IN inPromoKindId           Integer    , -- ��� �����
    IN inStartPromo            TDateTime  , -- ���� ������ �����
    IN inEndPromo              TDateTime  , -- ���� ��������� �����
    IN inCostPromo             TFloat     , -- ��������� ������� � �����
    IN inComment               TVarChar   , -- ���������� 
   OUT outPriceListName        TVarChar ,
   OUT outPersonalTradetName   TVarChar ,
   OUT outChangePercent        TFloat   ,
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_PromoTrade());


    -- �������� - ���� ���� �������, �������������� ������
    PERFORM lpCheck_Movement_Promo_Sign (inMovementId:= ioId
                                       , inIsComplete:= FALSE
                                       , inIsUpdate  := TRUE
                                       , inUserId    := vbUserId
                                        );

     -- ��������� <��������>
     ioId := PERFORM lpInsertUpdate_Movement_PromoTrade (ioId             := ioId
                                                       , inInvNumber      := inInvNumber
                                                       , inOperDate       := inOperDate 
                                                       , inContractId     := inContractId
                                                       , inPromoItemId    := inPromoItemId
                                                       , inPromoKindId    := inPromoKindId     --��� �����
                                                       , inStartPromo     := inStartPromo      --���� ������ �����
                                                       , inEndPromo       := inEndPromo        --���� ��������� �����
                                                       , inCostPromo      := inCostPromo       --��������� ������� � �����
                                                       , inComment        := inComment         --����������
                                                       , inUserId         := vbUserId
                                                       ) AS tmp;  

     outPriceListName      := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.DescId = zc_MovementLinkObject_PriceList() AND MLO.MovementId = ioId);
     outPersonalTradetName := (SELECT MLO.ObjectId FROM MovementLinkObject AS MLO WHERE MLO.DescId = zc_MovementLinkObject_PersonalTrade() AND MLO.MovementId = ioId);
     outChangePercent      := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.DescId = zc_MovementFloat_ChangePercent() AND MF.MovementId = ioId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.08.24         *
*/