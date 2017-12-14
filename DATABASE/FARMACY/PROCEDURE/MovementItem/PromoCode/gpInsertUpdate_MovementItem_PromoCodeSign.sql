-- Function: gpInsertUpdate_MovementItem_PromoCode()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoCodeSign (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PromoCodeSign(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inBayerName           TVarChar  , -- 
    IN inBayerPhone          TVarChar  , -- 
    IN inBayerEmail          TVarChar  , -- 
    IN inGUID                TVarChar  , -- 
    IN inComment             TVarChar  , -- ����������
    IN inSession             TVarChar    -- ������ ������������
)
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
  
     -- ������������ ������� ��������/�������������
    vbIsInsert:= COALESCE (ioId, 0) = 0;

    -- ��������� <������� ���������>
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Sign(), 0, inMovementId, 0, NULL);

     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GUID(), ioId, inGUID);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Bayer(), ioId, inBayerName);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_BayerPhone(), ioId, inBayerPhone);
     -- ��������� �������� <>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_BayerEmail(), ioId, inBayerEmail);
     -- ��������� �������� <����������>
     PERFORM lpInsertUpdate_MovementItemString (zc_MIString_Comment(), ioId, inComment);

     IF vbIsInsert = TRUE
     THEN
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), ioId, vbUserId);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), ioId, CURRENT_TIMESTAMP);
     ELSE
         -- ��������� ����� � <>
         PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Update(), ioId, vbUserId);
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Update(), ioId, CURRENT_TIMESTAMP);
     END IF;
          
    -- ��������� ��������
    PERFORM lpInsert_MovementItemProtocol (ioId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.    ��������� �.�.
 13.12.17         *
*/
--select * from gpInsertUpdate_MovementItem_PromoCodeSign(ioId := 0 , inMovementId := 3959814 , inBayerName := '' , inBayerPhone := '45666' , inBayerEmail := 'mmk,' , inGUID := '' , inComment := 'dgsdg' ,  inSession := '3');