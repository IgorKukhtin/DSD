-- Function: gpUpdate_Unit_isErrorRROToVIP()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isErrorRROToVIP(Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Unit_isErrorRROToVIP(
    IN inId                      Integer   ,    -- ���� ������� <�������������>
    IN inisErrorRROToVIP         Boolean   ,    -- 
   OUT outisErrorRROToVIP        Boolean   ,
    IN inSession                 TVarChar       -- ������� ������������
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
   outisErrorRROToVIP:= NOT inisErrorRROToVIP;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_ErrorRROToVIP(), inId, outisErrorRROToVIP);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 14.12.21                                                      *

*/
--select * from gpUpdate_Unit_isErrorRROToVIP(inId := 1393106 , inisErrorRROToVIP := 'False' ,  inSession := '3');