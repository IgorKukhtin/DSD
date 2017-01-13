-- Function: gpUpdate_Juridical_isLongUKTZED()

DROP FUNCTION IF EXISTS gpUpdate_Juridical_isLongUKTZED(Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Juridical_isLongUKTZED(
    IN inId                  Integer   ,    -- ���� ������� <��.����>
    IN inisLongUKTZED        Boolean   ,    -- 10-�� ������� ��� ��� ���
   OUT outisLongUKTZED       Boolean   ,
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
   outisLongUKTZED:= NOT inisLongUKTZED;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Juridical_isLongUKTZED(), inId, outisLongUKTZED);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 13.01.17         *

*/
--select * from gpUpdate_Juridical_isLongUKTZED(inId := 1393106 , inisLongUKTZED := 'False' ,  inSession := '3');