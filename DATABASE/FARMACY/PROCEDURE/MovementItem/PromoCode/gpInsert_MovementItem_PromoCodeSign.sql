-- Function: gpInsertUpdate_MovementItem_PromoCode()

DROP FUNCTION IF EXISTS gpInsert_MovementItem_PromoCodeSign (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsert_MovementItem_PromoCodeSign(
    IN inMovementId          Integer   , -- ���� ������� <��������>
    IN inCount_GUID          Integer   ,
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;
   DECLARE vbIndex Integer;
   DECLARE vbGUID TVarChar;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    vbUserId := inSession;
  
    vbIndex := 0;
  
    -- ������ ������� ��� ������
    WHILE (vbIndex < inCount_GUID) LOOP
      vbIndex := vbIndex + 1;
      
      -- ��������� <������� ���������>
      vbId := lpInsertUpdate_MovementItem (0, zc_MI_Sign(), 0, inMovementId, 1, NULL);

      -- ���������� ����� GUID ���
      vbGUID := (SELECT zfCalc_GUID());
      -- ��������� �� ������������ GUID
      /*WHILE EXISTS (SELECT MovementItemString.ValueData FROM MovementItemString WHERE MovementItemString.DescId = zc_MIString_GUID() AND MovementItemString.ValueData = vbGUID) LOOP
           vbGUID := (SELECT zfCalc_GUID());
      END LOOP;
      */
      -- ��������� �������� <>
      PERFORM lpInsertUpdate_MovementItemString (zc_MIString_GUID(), vbId, vbGUID);
      PERFORM lpInsertUpdate_MovementItem_PromoCode_GUID (vbId, vbGUID, vbUserId);
  
      -- ��������� ����� � <>
      PERFORM lpInsertUpdate_MovementItemLinkObject (zc_MILinkObject_Insert(), vbId, vbUserId);
      -- ��������� �������� <>
      PERFORM lpInsertUpdate_MovementItemDate (zc_MIDate_Insert(), vbId, CURRENT_TIMESTAMP);

    END LOOP;
     
              
   -- ��������� ��������
   --PERFORM lpInsert_MovementItemProtocol (vbId, vbUserId, vbIsInsert);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.   ������ �.�.
 05.02.20                                                                     *
 13.12.17         *
*/
--