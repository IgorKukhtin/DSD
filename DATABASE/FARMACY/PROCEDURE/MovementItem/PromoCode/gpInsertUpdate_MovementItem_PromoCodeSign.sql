-- Function: gpInsertUpdate_MovementItem_PromoCode()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoCodeSign (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PromoCodeSign (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PromoCodeSign(
 INOUT ioId                  Integer   , -- ���� ������� <������� ���������>
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inBayerName           TVarChar  , -- 
    IN inBayerPhone          TVarChar  , -- 
    IN inBayerEmail          TVarChar  , -- 
 INOUT ioGUID                TVarChar  , -- 
    IN inComment             TVarChar  , -- ����������
    IN inIsChecked           Boolean   , -- �������
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
    ioId := lpInsertUpdate_MovementItem (ioId, zc_MI_Sign(), 0, inMovementId, (CASE WHEN inIsChecked = TRUE THEN 1 ELSE 0 END) ::TFloat, NULL);

     IF COALESCE (ioGUID, '') <> ''
     THEN
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GUID(), ioId, ioGUID);
         PERFORM lpInsertUpdate_MovementItem_PromoCode_GUID (ioId, ioGUID, vbUserId);
     ELSE
         -- ���������� ����� GUID ���
         ioGUID := (SELECT zfCalc_GUID());
         -- ��������� �� ������������ GUID
         /*WHILE EXISTS (SELECT MovementItemString.ValueData FROM MovementItemString WHERE MovementItemString.DescId = zc_MIString_GUID() AND MovementItemString.ValueData = ioGUID) LOOP
              ioGUID := (SELECT zfCalc_GUID());
         END LOOP;
         */
         -- ��������� �������� <>
         PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GUID(), ioId, ioGUID);
         PERFORM lpInsertUpdate_MovementItem_PromoCode_GUID (ioId, ioGUID, vbUserId);
     END IF;
     
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
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 05.02.20                                                                     *
 13.12.17         *
*/
--select * from gpInsertUpdate_MovementItem_PromoCodeSign(ioId := 67502267 , inMovementId := 3959814 , inBayerName := 'kbjjbjb' , inBayerPhone := '' , inBayerEmail := '' , ioGUID := '' , inComment := '' , inIsChecked:= TRUE, inSession := '3');