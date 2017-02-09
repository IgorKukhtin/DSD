-- Function: gpInsertUpdate_Object_RouteMember()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_RouteMember (Integer, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_RouteMember(
 INOUT ioId	          Integer   ,    -- ���� ������� <> 
    IN inCode             Integer   ,    -- ��� ������� <> 
    IN inRouteMemberName  TBlob     ,    -- 
    IN inSession          TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
 BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_RouteMember());
  
   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   inCode := lfGet_ObjectCode (inCode, zc_Object_RouteMember());
    
   -- �������� ���� ������������ ��� �������� <������������ >  
   --PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_RouteMember(), inRouteMemberName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_RouteMember(), inCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_RouteMember(), inCode, '');

   -- ��������� ��������
  
   PERFORM lpInsertUpdate_ObjectBlob (zc_ObjectBlob_RouteMember_Description(), ioId, inRouteMemberName);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_RouteMember (Integer, Integer, TBlob, TVarChar) OWNER TO postgres;
  
 /*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.01.16         *
*/

-- ����
--SELECT * FROM gpInsertUpdate_Object_RouteMember(0,1,'�����������'::TBlob,'5'::TVarChar)
--SELECT * FROM gpSelect_Object_RouteMember (zfCalc_UserAdmin())

