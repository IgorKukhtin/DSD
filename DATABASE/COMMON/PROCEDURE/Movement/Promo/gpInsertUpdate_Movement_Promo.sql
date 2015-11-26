-- Function: gpInsertUpdate_Movement_Promo()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Promo (
    Integer    , -- ���� ������� <�������� �������>
    TVarChar   , -- ����� ���������
    TDateTime  , -- ���� ���������
    Integer    , -- ��� �����
    TDateTime  , -- ���� ������ �����
    TDateTime  , -- ���� ��������� �����
    TDateTime  , -- ���� ������ �������� �� ��������� ����
    TDateTime  , -- ���� ��������� �������� �� ��������� ����
    TDateTime  , -- ���� ������ ����. ������ �� �����
    TDateTime  , -- ���� ��������� ����. ������ �� �����
    TFloat     , -- ��������� ������� � �����
    TVarChar   , -- ����������
    Integer    , -- ��������� ���������
    Integer    , -- �������������
    Integer    , -- ������������� ������������� ������������� ������
    Integer    , -- ������������� ������������� �������������� ������	
    TVarChar     -- ������ ������������

);

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Promo (
    Integer    , -- ���� ������� <�������� �������>
    TVarChar   , -- ����� ���������
    TDateTime  , -- ���� ���������
    Integer    , -- ��� �����
    Integer    , -- ����� ����
    TDateTime  , -- ���� ������ �����
    TDateTime  , -- ���� ��������� �����
    TDateTime  , -- ���� ������ �������� �� ��������� ����
    TDateTime  , -- ���� ��������� �������� �� ��������� ����
    TDateTime  , -- ���� ������ ����. ������ �� �����
    TDateTime  , -- ���� ��������� ����. ������ �� �����
    TFloat     , -- ��������� ������� � �����
    TVarChar   , -- ����������
    Integer    , -- ��������� ���������
    Integer    , -- �������������
    Integer    , -- ������������� ������������� ������������� ������
    Integer    , -- ������������� ������������� �������������� ������	
    TVarChar     -- ������ ������������

);

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Promo (
    Integer    , -- ���� ������� <�������� �������>
    TVarChar   , -- ����� ���������
    TDateTime  , -- ���� ���������
    Integer    , -- ��� �����
    Integer    , -- ����� ����
    TDateTime  , -- ���� ������ �����
    TDateTime  , -- ���� ��������� �����
    TDateTime  , -- ���� ������ �������� �� ��������� ����
    TDateTime  , -- ���� ��������� �������� �� ��������� ����
    TDateTime  , -- ���� ������ ����. ������ �� �����
    TDateTime  , -- ���� ��������� ����. ������ �� �����
    TFloat     , -- ��������� ������� � �����
    TVarChar   , -- ����������
    TVarChar   , -- ���������� (�����)
    Integer    , -- �������������
    Integer    , -- ������������� ������������� ������������� ������
    Integer    , -- ������������� ������������� �������������� ������	
    TVarChar     -- ������ ������������

);


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
    IN inOperDateStart         TDateTime  , -- ���� ������ ����. ������ �� �����
    IN inOperDateEnd           TDateTime  , -- ���� ��������� ����. ������ �� �����
    IN inCostPromo             TFloat     , -- ��������� ������� � �����
    IN inComment               TVarChar   , -- ����������
    IN inCommentMain           TVarChar   , -- ���������� (�����)
    IN inUnitId                Integer    , -- �������������
    IN inPersonalTradeId       Integer    , -- ������������� ������������� ������������� ������
    IN inPersonalId            Integer    , -- ������������� ������������� �������������� ������	
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());


    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement_Promo (ioId            := ioId
                                        , inInvNumber      := inInvNumber
                                        , inOperDate       := inOperDate
                                        , inPromoKindId    := inPromoKindId     --��� �����
                                        , inPriceListId    := inPriceListId     --����� ����
                                        , inStartPromo     := inStartPromo      --���� ������ �����
                                        , inEndPromo       := inEndPromo        --���� ��������� �����
                                        , inStartSale      := inStartSale       --���� ������ �������� �� ��������� ����
                                        , inEndSale        := inEndSale         --���� ��������� �������� �� ��������� ����
                                        , inOperDateStart  := inOperDateStart   --���� ������ ����. ������ �� �����
                                        , inOperDateEnd    := inOperDateEnd     --���� ��������� ����. ������ �� �����
                                        , inCostPromo      := inCostPromo       --��������� ������� � �����
                                        , inComment        := inComment         --����������
                                        , inCommentMain    := inCommentMain     --���������� (�����)
                                        , inUnitId         := inUnitId          --�������������
                                        , inPersonalTradeId:= inPersonalTradeId --������������� ������������� ������������� ������
                                        , inPersonalId     := inPersonalId      --������������� ������������� �������������� ������	
                                        , inUserId         := vbUserId
                                        );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ��������� �.�.
 31.10.15                                                                    *
*/