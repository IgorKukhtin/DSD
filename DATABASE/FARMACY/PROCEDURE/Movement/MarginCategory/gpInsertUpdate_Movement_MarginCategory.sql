-- Function: gpInsertUpdate_Movement_MarginCategory()

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_MarginCategory (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TVarChar, TFloat, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_MarginCategory (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TVarChar, TFloat, TFloat, TFloat, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_MarginCategory (Integer, TVarChar, TDateTime, TDateTime, TDateTime, TDateTime, TDateTime, TVarChar, TFloat, TFloat, TFloat, TFloat, TFloat, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_MarginCategory(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inStartSale             TDateTime  , -- ���� ������ �������� �� ��������� ����
    IN inEndSale               TDateTime  , -- ���� ��������� �������� �� ��������� ����
    IN inOperDateStart         TDateTime  , -- ���� ������ ����. ������ �� �����
    IN inOperDateEnd           TDateTime  , -- ���� ��������� ����. ������ �� �����
    IN inComment               TVarChar   , -- ����������
    IN inAmount                TFloat     , --
    IN inChangePercent         TFloat     , --
    IN inDayCount              TFloat     , --
    IN inPriceMin              TFloat,     --
    IN inPriceMax              TFloat,     --
    IN inUnitId                Integer    , -- �������������
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    -- ���������� ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_MarginCategory(), inInvNumber, inOperDate, NULL, 0);
    
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Unit(), ioId, inUnitId);
    
    -- ����������
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
    
    -- ���� ������
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartSale(), ioId, inStartSale);
    -- ���� ���������
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndSale(), ioId, inEndSale);
    -- ���� ������
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateStart(), ioId, inOperDateStart);
    -- ���� ���������
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_OperDateEnd(), ioId, inOperDateEnd);
 
    -- 
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), ioId, inAmount);
    -- 
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);
    -- 
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DayCount(), ioId, inDayCount);
    -- 
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_PriceMin(), ioId, inPriceMin);
    -- 
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_PriceMax(), ioId, inPriceMax);
           
    -- 
    IF vbIsInsert = TRUE
    THEN
       -- ��������� �������� <���� ��������>
       PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
       -- ��������� �������� <������������ (��������)>
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, vbUserId);
    ELSE
       -- ��������� �������� <���� �������������>
       PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
       -- ��������� �������� <������������ (��������)>
       PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, vbUserId);
    END IF;
    
  
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ��������� �.�.
 19.11.17         *
*/