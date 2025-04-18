-- Function: lpInsertUpdate_Movement_Loyalty()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_Loyalty (Integer, TVarChar, TDateTime, Integer, TDateTime, TDateTime, TDateTime, TDateTime, TFloat, Integer, Integer, TFloat, TVarChar, TFloat, Boolean, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_Loyalty(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inRetailID              Integer    , -- �������� ����
    IN inStartPromo            TDateTime  , -- ���� ������ ���������
    IN inEndPromo              TDateTime  , -- ���� ��������� ���������
    IN inStartSale             TDateTime  , -- ���� ������ ���������
    IN inEndSale               TDateTime  , -- ���� ��������� ���������
    IN inStartSummCash         Tfloat     , -- �������� �� ����� ����
    IN inMonthCount            Integer    , -- ���������� ������� ���������
    IN inDayCount              Integer    , -- ���������� � ���� ��� ������
    IN inSummLimit             Tfloat     , -- ����� ����� ������ � ���� ��� ������
    IN inComment               TVarChar   , -- ����������
    IN inChangePercent         TFloat     , -- ������� �� ���������� ��� ������ ������
    IN inisBeginning           Boolean    , -- ��������� ������ � ������ �����
    IN inisElectron            Boolean    , -- ��� �����
    IN inSummRepay             Tfloat     , -- �������� �� ����� ����
    IN inUserId                Integer      -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    inOperDate  := DATE_TRUNC ('DAY', inOperDate);
    inStartPromo:= DATE_TRUNC ('DAY', inStartPromo);
    inEndPromo  := DATE_TRUNC ('DAY', inEndPromo);
    inStartSale := DATE_TRUNC ('DAY', inStartSale);
    inEndSale   := DATE_TRUNC ('DAY', inEndSale);

    -- ���������� ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_Loyalty(), inInvNumber, inOperDate, NULL, 0);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartPromo(), ioId, inStartPromo);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndPromo(), ioId, inEndPromo);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartSale(), ioId, inStartSale);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndSale(), ioId, inEndSale);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_StartSummCash(), ioId, inStartSummCash);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MonthCount(), ioId, inMonthCount);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_DayCount(), ioId, inDayCount);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_Limit(), ioId, inSummLimit);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummRepay(), ioId, inSummRepay);

    -- ��������� <����������>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

    -- ��������� �������� <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Retail(), ioId, inRetailID);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Beginning(), ioId, inisBeginning);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Electron(), ioId, inisElectron);

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
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.  ������ �.�.
 05.11.19                                                                  *
*/