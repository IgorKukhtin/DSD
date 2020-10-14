-- Function: lpInsertUpdate_Movement_RelatedProduct()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_RelatedProduct (Integer, TVarChar, TDateTime, Integer, TFloat, TVarChar, TBlob, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_RelatedProduct(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inRetailID              Integer    , -- �������� ����
    IN inPriceMin              Tfloat     , -- �� ���� ������
    IN inComment               TVarChar   , -- ����������
    IN inMessage               TBlob      , -- ���������
    IN inUserId                Integer      -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    inOperDate  := DATE_TRUNC ('DAY', inOperDate);

    -- ���������� ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_RelatedProduct(), inInvNumber, inOperDate, NULL, 0);

    -- ��������� <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_PriceMin(), ioId, inPriceMin);

    -- ��������� <����������>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);

    -- ��������� �������� <>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_Retail(), ioId, inRetailID);

    -- ��������� �������� <���������>
    PERFORM lpInsertUpdate_MovementBlob (zc_MovementBlob_Message(), ioId, inMessage);

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
 13.10.20                                                       *
*/