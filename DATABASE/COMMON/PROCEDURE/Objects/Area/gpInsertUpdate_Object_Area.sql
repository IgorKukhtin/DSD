-- Function: gpInsertUpdate_Object_Area()

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Area(Integer, Integer, TVarChar, TVarChar);
--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Area(Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Area(Integer, Integer, TVarChar, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Area(
 INOUT ioId               Integer   ,     -- ���� ������� <�������> 
    IN inCode             Integer   ,     -- ��� �������  
    IN inName             TVarChar  ,     -- �������� ������� 
    IN inTelegramGroupId  Integer   ,     -- ������ ��������
    IN inSession          TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Area());

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_Area());
   
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Area(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Area(), inCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Area(), inCode, inName);
         
   -- ��������� ����� � <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Area_TelegramGroup(), ioId, inTelegramGroupId);
      
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_Area (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.09.22         *
 16.09.22         *
 14.11.13         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Area(ioId:=null, inCode:=null, inName:='������ 1', inSession:='2')