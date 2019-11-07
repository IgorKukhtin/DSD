-- Function: gpInsertUpdate_Movement_Loyalty()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_Loyalty (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, Tfloat, Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_Loyalty(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inStartPromo            TDateTime  , -- ���� ������ ���������
    IN inEndPromo              TDateTime  , -- ���� ��������� ���������
    IN inStartSale             TDateTime  , -- ���� ������ ���������
    IN inEndSale               TDateTime  , -- ���� ��������� ���������
    IN inStartSummCash         Tfloat     , -- �������� �� ����� ����
    IN inMonthCount            Integer    , -- ���������� ������� ���������
    IN inDayCount              Integer    , -- ���������� � ���� ��� ������
    IN inSummLimit             Tfloat     , -- ����� ����� ������ � ���� ��� ������
    IN inComment               TVarChar   , -- ����������
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
    ioId := lpInsertUpdate_Movement_Loyalty (ioId            := ioId
                                           , inInvNumber     := inInvNumber
                                           , inOperDate      := inOperDate
                                           , inStartPromo    := inStartPromo
                                           , inEndPromo      := inEndPromo
                                           , inStartSale     := inStartSale
                                           , inEndSale       := inEndSale
                                           , inStartSummCash := inStartSummCash  
                                           , inMonthCount    := inMonthCount                                       
                                           , inDayCount      := inDayCount                                       
                                           , inSummLimit     := inSummLimit                                       
                                           , inComment       := inComment
                                           , inUserId        := vbUserId
                                           );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ������ �.�.
 15.11.19                                                                  *
*/