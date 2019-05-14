-- Function: gpUpdate_Object_Retail_ClientKind()

DROP FUNCTION IF EXISTS gpUpdate_Object_Retail_ClientKind (Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Retail_ClientKind (
    IN inId                    Integer   ,  -- ���� ������� <�������� ����> 
    IN inClientKindId          Integer   ,  -- 
    IN inSession               TVarChar     -- ������ ������������
)
  RETURNS void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Retail_ClientKind());

   -- ��������� ����� � <�������������� ������� �������>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Retail_ClientKind(), inId, inClientKindId);   

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.05.19         *
*/

-- ����
--