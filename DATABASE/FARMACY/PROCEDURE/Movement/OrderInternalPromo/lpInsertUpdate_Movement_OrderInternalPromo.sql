-- Function: lpInsertUpdate_Movement_OrderInternalPromo()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_OrderInternalPromo (Integer, TVarChar, TDateTime, TDateTime, Tfloat, Integer, TVarChar, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_OrderInternalPromo(
 INOUT ioId                    Integer    , -- ���� ������� <��������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inStartSale             TDateTime  , -- ���� ������ ������
    IN inAmount                Tfloat     , -- 
    IN inRetailId              Integer    , -- ����. ����
    IN inComment               TVarChar   , -- ����������
    IN inUserId                Integer     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    inOperDate  := DATE_TRUNC ('DAY', inOperDate);
    inStartSale:= DATE_TRUNC ('DAY', inStartSale);

    -- ���������� ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_OrderInternalPromo(), inInvNumber, inOperDate, NULL, 0);
    
    -- ��������� ����� � <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Retail(), ioId, inRetailId);
    
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartSale(), ioId, inStartSale);
    
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), ioId, inAmount);
 
    -- ��������� <����������>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
    
    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.04.19         *
*/