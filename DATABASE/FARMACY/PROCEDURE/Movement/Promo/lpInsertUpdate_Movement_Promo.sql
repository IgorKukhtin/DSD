-- Function: lpInsertUpdate_Movement_Promo()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Promo (Integer, TVarChar, TDateTime, TDateTime, TDateTime, Integer, Integer, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Promo (Integer, TVarChar, TDateTime, TDateTime, TDateTime, Tfloat, Tfloat, Integer, Integer, TVarChar, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Promo(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inStartPromo            TDateTime  , -- ���� ������ ���������
    IN inEndPromo              TDateTime  , -- ���� ��������� ���������
    IN inAmount                Tfloat     , -- 
    IN inChangePercent         Tfloat     , --
    IN inMakerId               Integer    , -- �������������
    IN inPersonalId            Integer    , -- ������������� ������������� �������������� ������
    IN inComment               TVarChar   , -- ����������
    IN inUserId                Integer     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    -- ��������
    IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
    THEN
        RAISE EXCEPTION '������.�������� ������ ����.';
    END IF;
    
    -- ���������� ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Promo(), inInvNumber, inOperDate, NULL, 0);
    
    -- ��������� ����� � <�������������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Maker(), ioId, inMakerId);
    
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Personal(), ioId, inPersonalId);
    
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartPromo(), ioId, inStartPromo);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndPromo(), ioId, inEndPromo);
    
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), ioId, inAmount);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);

    -- ��������� <����������>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 24.04.16         *
*/