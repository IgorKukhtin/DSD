-- Function: gpUpdate_Object_Calendar(Integer, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_Calendar(Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Calendar(Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Calendar(
    IN inId                Integer   , -- ���� ������� <��������� ������� ����>
    IN inisWorking         Boolean   , -- ������� ������� ����
    IN inisHoliday         Boolean   , -- ������� ������� ����
    IN inSession           TVarChar    -- ������ ������������
   )
RETURNS Integer AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Calendar());
   vbUserId:= lpGetUserBySession (inSession);

   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Calendar_Working(), inId, inisWorking);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Calendar_Holiday(), inId, inisHoliday);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId); 
   return 0;
   
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
  
/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.12.18         *
 28.11.13         * 
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Calendar (0,  true, '2')
