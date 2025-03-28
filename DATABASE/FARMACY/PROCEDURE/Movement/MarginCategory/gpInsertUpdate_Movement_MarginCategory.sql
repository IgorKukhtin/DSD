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
   OUT outMessageText          Text       , -- �������, ���� ���� ������
    IN inSession               TVarChar     -- ������ ������������
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbPeriodCount  Integer;
   DECLARE vbOperDateStart TDateTime;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    -- ��������
    IF COALESCE (inDayCount, 0) = 0 
    THEN
        RAISE EXCEPTION '������.�� ������� ���-�� ���� ������� ��� �������.';
    END IF;

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
    
    -- �������� ���� ������ ������� ��� �������
    vbPeriodCount := (CEIL( (date_part('DAY', inEndSale - inStartSale) / inDayCount) ::TFloat)) :: Integer;
    --������ ���� ���. 2 ������� ��� �������
    IF vbPeriodCount < 2 THEN vbPeriodCount := 2; END IF;
    vbOperDateStart := (inEndSale - ('' ||(vbPeriodCount * inDayCount)-1 || 'DAY ')  :: interval ) TDateTime;

    IF vbOperDateStart <> inStartSale
    THEN
        outMessageText:= '������.���-�� ���� ������� �� ������ ������� ��� �������.������������� ���.���� ' || CAST (vbOperDateStart AS Date)  ;
    END IF; 
    
    

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ��������� �.�.
 19.11.17         *
*/