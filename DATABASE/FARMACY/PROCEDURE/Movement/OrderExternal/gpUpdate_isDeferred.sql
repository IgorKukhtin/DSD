-- Function: gpUpdate_Object_Goods_IsUpload()

DROP FUNCTION IF EXISTS gpUpdate_isDeferred(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_isDeferred(
    IN inMovementId          Integer   ,    -- ���� ���������
    IN inisDeferred          Boolean   ,    -- �������
   OUT outisDeferred         Boolean   ,
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inMovementId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- ���������� �������
   outisDeferred:=  inisDeferred;

   PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_Deferred(), inMovementId, outisDeferred);

   -- ��������� ��������
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, false);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 22.12.16         *
*/