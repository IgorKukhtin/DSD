-- Function: gpInsertUpdate_Object_GoodsKindNew()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsKindNew(Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsKindNew(
 INOUT ioId	                 Integer   ,   	-- ���� ������� < ��� ������> 
    IN inCode                Integer   ,    -- ��� ������� <��� ������> 
    IN inName                TVarChar  ,    -- �������� ������� <��� ������>
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE Code_max Integer;  
   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_GoodsKindNew());
   vbUserId:= lpGetUserBySession (inSession);

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   inCode := lfGet_ObjectCode (inCode, zc_Object_GoodsKindNew());
   
   -- �������� ���� ������������ ��� �������� <������������ ���� ������>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_GoodsKindNew(), inName);
   -- �������� ���� ������������ ��� �������� <��� ���� ������>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsKindNew(), inCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_GoodsKindNew(), inCode, inName);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);   

END;$BODY$

LANGUAGE plpgsql VOLATILE
  COST 100;
--ALTER FUNCTION gpInsertUpdate_Object_GoodsKindNew (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;
  
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.12.22         *
*/

-- ����
--