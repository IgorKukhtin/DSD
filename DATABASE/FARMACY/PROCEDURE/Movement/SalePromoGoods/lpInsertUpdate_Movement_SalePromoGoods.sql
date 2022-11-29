-- Function: lpInsertUpdate_Movement_SalePromoGoods()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_SalePromoGoods (Integer, TVarChar, TDateTime, Integer, TDateTime, TDateTime, TVarChar, Boolean, TFloat, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_SalePromoGoods(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inRetailID              Integer    , -- �������� ����
    IN inStartPromo            TDateTime  , -- ���� ������ ���������
    IN inEndPromo              TDateTime  , -- ���� ��������� ���������
    IN inComment               TVarChar   , -- ����������
    IN inisAmountCheck         Boolean    , -- ����� �� ����� ����
    IN inAmountCheck           TFloat     , -- �� ����� ����
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
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_SalePromoGoods(), inInvNumber, inOperDate, NULL, 0);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartPromo(), ioId, inStartPromo);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndPromo(), ioId, inEndPromo);

    -- ��������� <����������>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

    -- ��������� <����� �� ����� ����>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_AmountCheck(), ioId, inisAmountCheck);

    -- ��������� <�� ����� ����>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_AmountCheck(), ioId, inAmountCheck);

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
 07.09.22                                                       *
*/