-- Function: gpInsertUpdate_Movement_PromoTrade()
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoTrade (Integer, TVarChar, TDateTime, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoTrade (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TFloat, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_PromoTrade (Integer, TVarChar, TDateTime, Integer, Integer, Integer, Integer, TDateTime, TDateTime, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_PromoTrade(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inContractId            Integer    , -- �������
 INOUT ioPaidKindId            Integer   , -- ���� ���� ������
   OUT outPaidKindName         TVarChar   , -- ���� ���� ������
    IN inPromoItemId           Integer    , -- ������ ������
    IN inPromoKindId           Integer    , -- ��� �����
    IN inStartPromo            TDateTime  , -- ���� ������ �����
    IN inEndPromo              TDateTime  , -- ���� ��������� �����
    --IN inCostPromo             TFloat     , -- ��������� ������� � �����
    IN inComment               TVarChar   , -- ����������
   OUT outPriceListName        TVarChar ,
   OUT outPersonalTradetName   TVarChar ,
   OUT outChangePercent        TFloat   ,
   OUT outCostPromo            TFloat   ,
   OUT outOperDateStart        TDateTime ,
   OUT outOperDateEnd          TDateTime ,
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
     --���� �� �� ���������� ����� �� ��������
     IF COALESCE (ioPaidKindId,0) = 0
     THEN
         ioPaidKindId := 0;/*(SELECT ObjectLink_Contract_PaidKind.ChildObjectId
                          FROM ObjectLink AS ObjectLink_Contract_PaidKind
                          WHERE ObjectLink_Contract_PaidKind.ObjectId = inContractId
                           AND ObjectLink_Contract_PaidKind.DescId = zc_ObjectLink_Contract_PaidKind()
                          );*/
     END IF;

     -- ��������� <��������>
     ioId := lpInsertUpdate_Movement_PromoTrade (ioId             := ioId
                                               , inInvNumber      := inInvNumber
                                               , inOperDate       := inOperDate
                                               , inContractId     := inContractId
                                               , inPaidKindId     := ioPaidKindId
                                               , inPromoItemId    := inPromoItemId
                                               , inPromoKindId    := inPromoKindId     --��� �����
                                               , inStartPromo     := inStartPromo      --���� ������ �����
                                               , inEndPromo       := inEndPromo        --���� ��������� �����
                                               --, inCostPromo      := inCostPromo       --��������� ������� � �����
                                               , inComment        := inComment         --����������
                                               , inUserId         := vbUserId
                                               ) AS tmp;

     outPriceListName      := (SELECT lfGet_Object_ValueData_sh (MLO.ObjectId) FROM MovementLinkObject AS MLO WHERE MLO.DescId = zc_MovementLinkObject_PriceList() AND MLO.MovementId = ioId)     ::TVarChar;
     outPersonalTradetName := (SELECT lfGet_Object_ValueData_sh (MLO.ObjectId) FROM MovementLinkObject AS MLO WHERE MLO.DescId = zc_MovementLinkObject_PersonalTrade() AND MLO.MovementId = ioId) ::TVarChar;
     outChangePercent      := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.DescId = zc_MovementFloat_ChangePercent() AND MF.MovementId = ioId) ::TFloat;
     outCostPromo          := (SELECT MF.ValueData FROM MovementFloat AS MF WHERE MF.DescId = zc_MovementFloat_CostPromo() AND MF.MovementId = ioId) ::TFloat;

     outOperDateEnd := inOperDate - INTERVAL '1 Day';
     outOperDateStart := outOperDateEnd - INTERVAL '3 Month' + INTERVAL '1 Day';

     outPaidKindName := lfGet_Object_ValueData_sh (ioPaidKindId) ::TVarChar;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.08.24         *
*/