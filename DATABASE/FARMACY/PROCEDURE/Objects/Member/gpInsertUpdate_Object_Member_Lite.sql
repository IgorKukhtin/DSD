-- Function: gpInsertUpdate_Object_Member_Lite()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Member_Lite (Integer, TVarChar, TVarChar, Integer, Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Member_Lite(
 INOUT ioId                  Integer   ,    -- ���� ������� <���������� ����> 
    IN inName                TVarChar  ,    -- �������� ������� <

    IN inPhone               TVarChar  , 

    IN inPositionID          Integer   ,    -- ���������
    IN inUnitID              Integer   ,    -- �������������
    
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- !!! ��� �������� !!!
   -- IF COALESCE(ioId, 0) = 0
   -- THEN ioId := (SELECT Id FROM Object WHERE ValueData = inName AND DescId = zc_Object_Member());
   -- END IF;

   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Member());
   
   -- �������� ����� ���
   IF ioId <> 0  THEN vbCode_calc := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ��������� + 1
   vbCode_calc:= lfGet_ObjectCode (vbCode_calc, zc_Object_Member());
   
   -- �������� ������������ <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Member(), inName);
   -- �������� ������������ <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Member(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Member(), vbCode_calc, inName, inAccessKeyId:= NULL);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_Phone(), ioId, inPhone);

    -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Member_Position(), ioId, inPositionID);

    -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Member_Unit(), ioId, inUnitID);

   -- �������������� <���������� ����> � <����������>
   UPDATE Object SET ValueData = inName, ObjectCode = vbCode_calc
   WHERE Id IN (SELECT ObjectId FROM ObjectLink WHERE DescId = zc_ObjectLink_Personal_Member() AND ChildObjectId = ioId);  

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 16.04.22                                                       *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Member_Lite()