-- Function: gpInsertUpdate_Movement_LoyaltyPresent()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_LoyaltyPresent (Integer, TVarChar, TDateTime, Integer, TDateTime, TDateTime, TDateTime, TDateTime, TFloat, Integer, Integer, TFloat, TVarChar, TFloat, Boolean, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_LoyaltyPresent(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inRetailID              Integer    , -- �������� ����
    IN inStartPromo            TDateTime  , -- ���� ������ ���������
    IN inEndPromo              TDateTime  , -- ���� ��������� ���������
    IN inStartSale             TDateTime  , -- ���� ������ ���������
    IN inEndSale               TDateTime  , -- ���� ��������� ���������
    IN inStartSummCash         TFloat     , -- �������� �� ����� ����
    IN inMonthCount            Integer    , -- ���������� ������� ���������
    IN inDayCount              Integer    , -- ���������� � ���� ��� ������
    IN inSummLimit             TFloat     , -- ����� ����� ������ � ���� ��� ������
    IN inComment               TVarChar   , -- ����������
    IN inChangePercent         TFloat     , -- ������� �� ���������� ��� ������ ������
    IN inisBeginning           Boolean    , -- ��������� ������ � ������ �����
    IN inisElectron            Boolean    , -- ��� �����
    IN inSummRepay             Tfloat     , -- �������� �� ����� ����
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
    ioId := lpInsertUpdate_Movement_LoyaltyPresent (ioId            := ioId
                                           , inInvNumber     := inInvNumber
                                           , inOperDate      := inOperDate
                                           , inRetailID      := inRetailID
                                           , inStartPromo    := inStartPromo
                                           , inEndPromo      := inEndPromo
                                           , inStartSale     := inStartSale
                                           , inEndSale       := inEndSale
                                           , inStartSummCash := inStartSummCash  
                                           , inMonthCount    := inMonthCount                                       
                                           , inDayCount      := inDayCount                                       
                                           , inSummLimit     := inSummLimit                                       
                                           , inComment       := inComment
                                           , inChangePercent := inChangePercent
                                           , inisBeginning   := inisBeginning
                                           , inisElectron    := inisElectron
                                           , inSummRepay     := inSummRepay
                                           , inUserId        := vbUserId
                                           );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ������ �.�.
 28.09.20                                                       *
*/