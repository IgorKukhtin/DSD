-- Function: gpInsertUpdate_Object_GoodsGroupProperty()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsGroupProperty(Integer, Integer, TVarChar, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsGroupProperty(Integer, Integer, TVarChar, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsGroupProperty(
 INOUT ioId               Integer   ,     -- ���� ������� <> 
    IN inCode             Integer   ,     -- ��� �������  
    IN inName             TVarChar  ,     -- �������� ������� 
    IN inParentId         Integer   ,     -- ������
    IN inQualityINN       TVarChar  ,     -- ���������������� ����� ������� �� ��� �������� ��������  
    IN inSession          TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_GoodsGroupProperty());

   IF COALESCE (inCode,0) = 0 AND COALESCE (ioId,0) <> 0
   THEN
       inCode := (SELECT Object.ObjectCode FROM Object WHERE Object.Id = ioId AND Object.DescId = zc_Object_GoodsGroupProperty());
   END IF;
   
   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_GoodsGroupProperty());
                               
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_GoodsGroupProperty(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_GoodsGroupProperty(), inCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsGroupProperty(), inCode, inName);
         
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_GoodsGroupProperty_Parent(), ioId, inParentId);
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_GoodsGroupProperty_QualityINN(), ioId, inQualityINN);
      
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 21.01.25         *
 19.12.23         *
*/

-- ����
-- 