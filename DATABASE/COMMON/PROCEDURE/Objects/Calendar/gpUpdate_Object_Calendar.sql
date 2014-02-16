-- Function: gpUpdate_Object_Calendar(Integer, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_Calendar(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Calendar(
    IN inId                Integer   , -- ���� ������� <��������� ������� ����>
    IN inWorking           Boolean   , -- ������� ������� ����
    IN inSession           TVarChar    -- ������ ������������
   )
RETURNS Integer AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Calendar());
   vbUserId := inSession;
   
  -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Calendar_Working(), inId, inWorking);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId); 
   
END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpUpdate_Object_Calendar (Integer, Boolean, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 28.11.13         * 
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Calendar (0,  true, '2')