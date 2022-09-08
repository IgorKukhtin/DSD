-- Function: gpInsertUpdate_Movement_SalePromoGoods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_SalePromoGoods (Integer, TVarChar, TDateTime, Integer, TDateTime, TDateTime, Integer, TVarChar, Boolean, TFloat, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_SalePromoGoods(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inRetailID              Integer    , -- �������� ����
    IN inStartSale             TDateTime  , -- ���� ������ ���������
    IN inEndSale               TDateTime  , -- ���� ��������� ���������
    IN inMonthCount            Integer    , -- ���������� ������� ���������
    IN inComment               TVarChar   , -- ����������
    IN inisElectron            Boolean    , -- ��� �����
    IN inSummRepay             Tfloat     , -- �������� �� ����� ����
    IN inAmountPresent         Tfloat     , -- ���������� ������� � ���
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_Promo());
    vbUserId := inSession;
    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement_SalePromoGoods (ioId            := ioId
                                           , inInvNumber     := inInvNumber
                                           , inOperDate      := inOperDate
                                           , inRetailID      := inRetailID
                                           , inStartSale     := inStartSale
                                           , inEndSale       := inEndSale
                                           , inMonthCount    := inMonthCount                                       
                                           , inComment       := inComment
                                           , inisElectron    := inisElectron
                                           , inSummRepay     := inSummRepay
                                           , inAmountPresent := inAmountPresent
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