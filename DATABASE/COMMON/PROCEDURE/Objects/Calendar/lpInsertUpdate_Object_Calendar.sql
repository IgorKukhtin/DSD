-- Function: lpInsertUpdate_Object_Calendar(Integer, Boolean, TDateTime, TVarChar,TVarChar )

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Calendar (Integer, Boolean, TDateTime, TVarChar );
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Calendar (Integer, Boolean, Boolean, TDateTime, TVarChar );

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Calendar (
 INOUT ioId                Integer   , -- ���� ������� <��������� ������� ����>
    IN inisWorking         Boolean   , -- ������� ������� ����
    IN inisHoliday         Boolean   , -- ������� ����������� ����
    IN inValue             TDateTime , -- ����
    IN inUserId            TVarChar 
)
RETURNS Integer AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Calendar());
      vbUserId := inUserId; 
      
   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Calendar(), 0, '');
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Calendar_Working(), ioId, inisWorking);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Calendar_Holiday(), ioId, inisHoliday);
  
   -- ��������� �������� <>   
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Calendar_Value(), ioId, inValue);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;

  
/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.12.18         *
 27.11.13         * 
*/

-- ����
-- SELECT * FROM lpInsertUpdate_Object_Calendar (0,  true, '12.11.2013')