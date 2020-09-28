-- Function: lpInsertUpdate_Movement_LoyaltyPresent()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_LoyaltyPresent (Integer, TVarChar, TDateTime, Integer, TDateTime, TDateTime, Integer, TVarChar, Boolean, TFloat, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_LoyaltyPresent(
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
    IN inUserId                Integer      -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    inOperDate  := DATE_TRUNC ('DAY', inOperDate);
    inStartSale := DATE_TRUNC ('DAY', inStartSale);
    inEndSale   := DATE_TRUNC ('DAY', inEndSale);

    -- ���������� ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_LoyaltyPresent(), inInvNumber, inOperDate, NULL, 0);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartSale(), ioId, inStartSale);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndSale(), ioId, inEndSale);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_MonthCount(), ioId, inMonthCount);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_SummRepay(), ioId, inSummRepay);

    -- ��������� <����������>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

    -- ��������� �������� <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Retail(), ioId, inRetailID);

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
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 28.09.20                                                       *
*/