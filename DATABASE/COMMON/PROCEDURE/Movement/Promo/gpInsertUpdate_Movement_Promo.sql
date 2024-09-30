-- Function: gpInsertUpdate_Movement_Promo()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Promo (Integer, TVarChar, TDateTime, Integer, Integer, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Promo (Integer, TVarChar, TDateTime, Integer, Integer
                                                     , TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime
                                                     , Boolean, Boolean, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Promo (Integer, TVarChar, TDateTime, Integer, Integer
                                                     , TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime
                                                     , Boolean, Boolean, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, Integer, TVarChar);

/*DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Promo (Integer, TVarChar, TDateTime, Integer, Integer
                                                     , TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime
                                                     , Boolean, Boolean, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);  */
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Promo (Integer, TVarChar, TDateTime, Integer, Integer
                                                     , TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime
                                                     , Boolean, Boolean, Boolean, TFloat, TVarChar, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Promo(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inPromoKindId           Integer    , -- ��� �����
    IN inPriceListId           Integer    , -- ����� ����
    IN inStartPromo            TDateTime  , -- ���� ������ �����
    IN inEndPromo              TDateTime  , -- ���� ��������� �����
    IN inStartSale             TDateTime  , -- ���� ������ �������� �� ��������� ����
    IN inEndSale               TDateTime  , -- ���� ��������� �������� �� ��������� ����
    IN inEndReturn             TDateTime  , -- ���� ��������� ��������� �� ��������� ����
    IN inOperDateStart         TDateTime  , -- ���� ������ ����. ������ �� �����
    IN inOperDateEnd           TDateTime  , -- ���� ��������� ����. ������ �� �����
 INOUT ioMonthPromo            TDateTime  , -- ����� �����
    IN inCheckDate             TDateTime  , -- ���� ������������
    IN inChecked               Boolean    , -- �����������
    IN inIsPromo               Boolean    , -- �����  
    IN inisCost                Boolean    , -- �������
    IN inCostPromo             TFloat     , -- ��������� ������� � �����
    IN inComment               TVarChar   , -- ����������
    IN inCommentMain           TVarChar   , -- ���������� (�����)
    IN inUnitId                Integer    , -- �������������
    IN inPersonalTradeId       Integer    , -- ������������� ������������� ������������� ������
    IN inPersonalId            Integer    , -- ������������� ������������� �������������� ������
    IN inPaidKindId            Integer    , --
    --IN inSignInternalId        Integer    , -- ������ �������
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());

    -- ��������
    IF 1=0 AND COALESCE (inisCost,FALSE) = TRUE AND COALESCE (inIsPromo,FALSE) = TRUE
    THEN
        RAISE EXCEPTION '������.��������� <�����> � <�������> �� ����� ���� �������� ������������.';
    END IF; 

    -- �������� - ���� ���� �������, �������������� ������
    PERFORM lpCheck_Movement_Promo_Sign (inMovementId:= ioId
                                       , inIsComplete:= FALSE
                                       , inIsUpdate  := TRUE
                                       , inUserId    := vbUserId
                                        );

     -- ��������� <��������>
     SELECT tmp.ioId, tmp.ioMonthPromo
  INTO ioId, ioMonthPromo
     FROM  lpInsertUpdate_Movement_Promo (ioId             := ioId
                                        , inInvNumber      := inInvNumber
                                        , inOperDate       := inOperDate
                                        , inPromoKindId    := inPromoKindId     --��� �����
                                        , inPriceListId    := inPriceListId     --����� ����
                                        , inStartPromo     := inStartPromo      --���� ������ �����
                                        , inEndPromo       := inEndPromo        --���� ��������� �����
                                        , inStartSale      := inStartSale       --���� ������ �������� �� ��������� ����
                                        , inEndSale        := inEndSale         --���� ��������� �������� �� ��������� ����
                                        , inEndReturn      := inEndReturn       --���� ��������� ��������� �� ��������� ����
                                        , inOperDateStart  := inOperDateStart   --���� ������ ����. ������ �� �����
                                        , inOperDateEnd    := inOperDateEnd     --���� ��������� ����. ������ �� �����
                                        , ioMonthPromo     := ioMonthPromo      --����� �����
                                        , inCheckDate      := inCheckDate       --���� ������������
                                        , inChecked        := inChecked         --�����������
                                        , inIsPromo        := inIsPromo	        --�����          
                                        , inisCost         := inisCost          --�������
                                        , inCostPromo      := inCostPromo       --��������� ������� � �����
                                        , inComment        := inComment         --����������
                                        , inCommentMain    := inCommentMain     --���������� (�����)
                                        , inUnitId         := inUnitId          --�������������
                                        , inPersonalTradeId:= inPersonalTradeId --������������� ������������� ������������� ������
                                        , inPersonalId     := inPersonalId      --������������� ������������� �������������� ������   
                                        , inPaidKindId     := inPaidKindId
                                        --, inSignInternalId := inSignInternalId  -- ������ �������
                                        , inUserId         := vbUserId
                                        ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ��������� �.�.
-- 09.04.20         * inSignInternalId
 01.08.17         * add inCheckDate
 27.07.17         *
 31.10.15                                                                    *
*/
