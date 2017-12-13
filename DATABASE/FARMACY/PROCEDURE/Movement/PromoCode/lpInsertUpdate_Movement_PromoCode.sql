-- Function: lpInsertUpdate_Movement_PromoCode()

DROP FUNCTION IF EXISTS lpInsertUpdate_Movement_PromoCode (Integer, TVarChar, TDateTime, TDateTime, TDateTime, Tfloat, Boolean, Boolean, Integer, TVarChar, Integer);


CREATE OR REPLACE FUNCTION lpInsertUpdate_Movement_PromoCode(
 INOUT ioId                    Integer    , -- ���� ������� <�������� �������>
    IN inInvNumber             TVarChar   , -- ����� ���������
    IN inOperDate              TDateTime  , -- ���� ���������
    IN inStartPromo            TDateTime  , -- ���� ������ ���������
    IN inEndPromo              TDateTime  , -- ���� ��������� ���������
    IN inChangePercent         Tfloat     , --
    IN inIsElectron            Boolean    , 
    IN inIsOne                 Boolean    , 
    IN inPromoCodeId           Integer    , --
    IN inComment               TVarChar   , -- ����������
    IN inUserId                Integer     -- ������ ������������
)
RETURNS Integer AS
$BODY$
   DECLARE vbIsInsert Boolean;
BEGIN
    inOperDate  := DATE_TRUNC ('DAY', inOperDate);
    inStartPromo:= DATE_TRUNC ('DAY', inStartPromo);
    inEndPromo  := DATE_TRUNC ('DAY', inEndPromo);

    -- ��������
    IF inOperDate <> DATE_TRUNC ('DAY', inOperDate)
    THEN
        RAISE EXCEPTION '������.�������� ������ ����.';
    END IF;
    
    -- ���������� ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;
    
    -- ��������� <��������>
    ioId := lpInsertUpdate_Movement (ioId, zc_Movement_PromoCode(), inInvNumber, inOperDate, NULL, 0);
    
    -- ��������� ����� � <�������������>
    PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_PromoCode(), ioId, inPromoCodeId);
    
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_StartPromo(), ioId, inStartPromo);
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_EndPromo(), ioId, inEndPromo);
    
    -- ��������� <>
    PERFORM lpInsertUpdate_MovementFloat (zc_MovementFloat_ChangePercent(), ioId, inChangePercent);

    -- ��������� �������� <>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Electron(), ioId, inIsElectron);
    
    -- ��������� �������� <>
    PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_One(), ioId, inIsOne);
    
    -- ��������� <����������>
    PERFORM lpInsertUpdate_MovementString (zc_MovementString_Comment(), ioId, inComment);
    
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
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.   ��������� �.�.
 13.12.17         *
*/