-- Function: gpUpdate_Object_User_ScalePSW()

DROP FUNCTION IF EXISTS gpUpdate_Object_User_ScalePSW (Integer, TFloat, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_User_ScalePSW(
    IN inUserId      Integer   ,    -- ���� ������� <������������> 
    IN inScalePSW    TFloat    ,    -- ������
    IN inSession     TVarChar       -- ������ ������������
)
  RETURNS Void 
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE Code_max Integer;  
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_User_ScalePSW());
   
   
   IF COALESCE (inUserId, 0) = 0
   THEN
       RAISE EXCEPTION '������.� ���������� �� ��������� ������������.';
   END IF;

   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_User_ScalePSW(), inUserId, inScalePSW);
  
   -- C�������� ��������
   PERFORM lpInsert_ObjectProtocol (inUserId, vbUserId);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.01.17         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_User_ScalePSW ('2')