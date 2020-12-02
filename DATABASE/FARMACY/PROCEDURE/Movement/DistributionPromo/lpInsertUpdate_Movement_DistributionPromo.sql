-- Function: lpInsertUpdate_Movement_DistributionPromo()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_DistributionPromo (Integer, TVarChar, TDateTime, Integer, TDateTime, TDateTime, Integer, TFloat, TVarChar, TBlob, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_DistributionPromo(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inRetailID              Integer    , -- �������� ����
    IN inStartPromo            TDateTime  , -- ���� ������ ��������
    IN inEndPromo              TDateTime  , -- ���� ��������� ��������
    IN inAmount                Integer    , -- �������� �� ���������� ������
    IN inSummRepay             Tfloat     , -- �������� �� ����� ������ 
    IN inComment               TVarChar   , -- ����������
    IN inMessage               TBlob      , -- ���������
    IN inUserId                Integer      -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    inOperDate   := DATE_TRUNC ('DAY', inOperDate);
    inStartPromo := DATE_TRUNC ('DAY', inStartPromo);
    inEndPromo   := DATE_TRUNC ('DAY', inEndPromo);

    -- ���������� ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_DistributionPromo(), inInvNumber, inOperDate, NULL, 0);

    -- ��������� �������� <���������>
    PERFORM lpInsertUpdate_MovementBlob (zc_MovementBlob_Message(), ioId, inMessage);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartPromo(), ioId, inStartPromo);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndPromo(), ioId, inEndPromo);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Amount(), ioId, inAmount);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummRepay(), ioId, inSummRepay);

    -- ��������� <����������>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

    -- ��������� �������� <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Retail(), ioId, inRetailID);

    IF vbIsInsert = True
    THEN
        -- ��������� �������� <>
        PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Insert(), ioId, CURRENT_TIMESTAMP);
        -- ��������� �������� <>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Insert(), ioId, inUserId);
    ELSE
        -- ��������� �������� <>
        PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Update(), ioId, CURRENT_TIMESTAMP);
        -- ��������� �������� <>
        PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Update(), ioId, inUserId);
    END IF;

    -- ��������� ��������
    PERFORM lpInsert_MovementProtocol (ioId, inUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 02.12.20                                                       *
*/