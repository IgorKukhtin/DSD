-- Function: gpInsertUpdate_Object_Unit (Integer, TVarChar,  Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Unit (Integer, TVarChar,  Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Unit(
 INOUT ioId                       Integer   ,    -- ���� ������� <�������������> 
    IN inName                     TVarChar  ,    -- �������� ������� <�������������>
    IN inJuridicalId              Integer   ,    -- ���� ������� <����������� ����> 
    IN inSession                  TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_max Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Unit());
   vbUserId:= lpGetUserBySession (inSession);

   -- �������� ����� ���
   IF ioId <> 0 AND COALESCE (vbCode_max, 0) = 0 THEN vbCode_max := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_max:=lfGet_ObjectCode (vbCode_max, zc_Object_Unit()); 
   
   -- �������� ���� ������������ ��� �������� <������������ >
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Unit(), inName);

   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Unit(), vbCode_max);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Unit(), vbCode_max, inName);

   -- ��������� ����� � <����������� ����>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_Juridical(), ioId, inJuridicalId);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
28.02.17                                                           *

*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Unit()
