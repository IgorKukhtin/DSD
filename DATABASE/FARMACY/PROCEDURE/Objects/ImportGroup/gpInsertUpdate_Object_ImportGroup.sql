-- Function: gpInsertUpdate_Object_ImportType()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ImportGroup (Integer, TVarChar, tvarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ImportGroup(
 INOUT ioId                      Integer   ,   	-- ���� ������� <������ �������>
    IN inName                    TVarChar  ,    -- �������� ������� <>
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;  

BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ImportType());
   vbUserId := lpGetUserBySession (inSession); 
   vbObjectId := lpGet_DefaultValue('zc_Object_Retail', vbUserId);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ImportGroup(), 0, inName);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_ImportGroup_Object(), ioId, vbObjectId);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_ImportGroup (Integer, TVarChar, tvarchar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 30.09.14                         * 

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_ImportType ()                            
