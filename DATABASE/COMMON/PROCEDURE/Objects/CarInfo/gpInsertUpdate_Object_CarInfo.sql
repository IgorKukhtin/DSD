-- Function: gpInsertUpdate_Object_CarInfo()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CarInfo(Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CarInfo(
 INOUT ioId             Integer   ,     -- ���� ������� <�������> 
    IN inCode           Integer   ,     -- ��� �������  
    IN inName           TVarChar  ,     -- �������� ������� 
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_CarInfo());
    vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_OrderExternal()); 

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   inCode:=lfGet_ObjectCode (inCode, zc_Object_CarInfo());
   
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_CarInfo(), inName);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_CarInfo(), inCode);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_CarInfo(), inCode, inName);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 14.06.22         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_CarInfo(ioId:=null, inCode:=null, inName:='������ 1', inSession:='2')
