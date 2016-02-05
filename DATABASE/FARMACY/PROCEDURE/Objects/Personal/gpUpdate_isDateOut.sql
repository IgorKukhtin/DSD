-- Function: gpUpdate_isDateOut ()


DROP FUNCTION IF EXISTS gpUpdate_isDateOut (Integer, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_isDateOut(
    IN inId                  Integer   , -- ���� ������� <����������>
 INOUT ioDateOut             TDateTime , -- ���� ����������
 INOUT ioisDateOut           Boolean   , -- ������
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS record
AS
$BODY$
   DECLARE vbUserId Integer;

BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Personal());

    -- ��������
     IF COALESCE (inId, 0) = 0
     THEN
         RAISE EXCEPTION '������. ������� ����������� �� �������.';
     END IF;

   -- ���������� �������
   ioisDateOut:= NOT ioisDateOut;

   -- ��������� �������� <���� ����������>
   IF ioisDateOut = TRUE
   THEN
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Personal_Out(), inId, COALESCE(ioDateOut,CURRENT_DATE));
       ioDateOut:=CURRENT_DATE;
   ELSE
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Personal_Out(), inId, zc_DateEnd());
       ioDateOut:=zc_DateEnd();
   END IF;
  
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*---------------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   
 05.02.16         * 
*/

-- ����
-- SELECT * FROM gpUpdate_isDateOut (inId:=0, inPositionId:=0, inIsMain:=False, inSession:='2')