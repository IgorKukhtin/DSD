-- Function: gpUpdate_MI_IsCalculated()

DROP FUNCTION IF EXISTS gpUpdate_MI_IsCalculated(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_IsCalculated(
    IN inId                  Integer   ,    -- ���� ������� <>
    IN inIsCalculated        Boolean   ,    -- 
   OUT outIsCalculated       Boolean   ,
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- ���������� �������
   outIsCalculated:= NOT inIsCalculated;
   
   -- ��������� 
   PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Calculated(), inId, inIsCalculated);

   -- ��������� ��������
   PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.11.20         *

*/