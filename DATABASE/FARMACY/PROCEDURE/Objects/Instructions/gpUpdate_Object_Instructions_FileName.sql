-- Function: gpUpdate_Object_Instructions_FileName()

DROP FUNCTION IF EXISTS gpUpdate_Object_Instructions_FileName (Integer, TVarChar, Tvarchar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Instructions_FileName(
    IN inId                      Integer   ,   	-- ���� ������� <>
    IN inFileName                TVarChar  ,    -- ��� �����
    IN inSession                 TVarChar       -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ImportTypeItems());
   vbUserId := lpGetUserBySession (inSession); 
  
   IF COALESCE (inId, 0) = 0
   THEN
      RAISE EXCEPTION '������. ���������� �� ���������...';
   END IF;

   -- ��������� <��� �����>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Instructions_FileName(), inId, inFileName);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_Instructions_FileName (Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.02.21                                                       *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Instructions_FileName ()                            