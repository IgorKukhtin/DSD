-- Function: gpInsertUpdate_Object_PickUpLogsAndDBF()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PickUpLogsAndDBF (Integer, TVarchar, TVarchar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PickUpLogsAndDBF(
 INOUT ioId                      Integer   ,   	-- ���� ������� <>
    IN inGUID                    TVarChar  ,    -- ��� ������� ���������� �����
    IN inSession                 TVarChar       -- ������ ������������
)
  RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_CorrectMinAmount());
   vbUserId := lpGetUserBySession (inSession); 

   
   IF COALESCE(inGUID, '') = ''
   THEN
     RAISE EXCEPTION '�� ��������� <GUID>';
   END IF;

   IF NOT EXISTS(SELECT 1
                 FROM EmployeeWorkLog
                 WHERE EmployeeWorkLog.DateLogIn >= CURRENT_DATE - INTERVAL '5 DAY'
                   AND EmployeeWorkLog.CashSessionId = inGUID)
   THEN
     RAISE EXCEPTION 'GUID �� ������.';
   END IF;
   
   IF EXISTS(SELECT Object_PickUpLogsAndDBF.Id
             FROM Object AS Object_PickUpLogsAndDBF
             WHERE Object_PickUpLogsAndDBF.DescId = zc_Object_PickUpLogsAndDBF()
               AND Object_PickUpLogsAndDBF.ValueData = inGUID)
   THEN
     SELECT Object_PickUpLogsAndDBF.Id
     INTO ioId
     FROM Object AS Object_PickUpLogsAndDBF
     WHERE Object_PickUpLogsAndDBF.DescId = zc_Object_PickUpLogsAndDBF()
       AND Object_PickUpLogsAndDBF.ValueData = inGUID;
       
     IF EXISTS(SELECT Object_PickUpLogsAndDBF.Id
               FROM Object AS Object_PickUpLogsAndDBF
               WHERE Object_PickUpLogsAndDBF.Id = ioId
                 AND Object_PickUpLogsAndDBF.isErased = True)
     THEN
       UPDATE Object AS Object_PickUpLogsAndDBF SET isErased = False
       WHERE Object_PickUpLogsAndDBF.Id = ioId
         AND Object_PickUpLogsAndDBF.isErased = True;       
     END IF;
   END IF;

   -- �������� ����� ���
   IF ioId <> 0 THEN vbCode_calc := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- ���� ��� �� ����������, ���������� ��� ��� ���������+1
   vbCode_calc:=lfGet_ObjectCode (vbCode_calc, zc_Object_PickUpLogsAndDBF());
   
   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_PickUpLogsAndDBF(), inGUID);
   -- �������� ���� ������������ ��� �������� <���>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_PickUpLogsAndDBF(), vbCode_calc);

   -- ��������� <������>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PickUpLogsAndDBF(), vbCode_calc, inGUID);

   -- ��������� ����� � <��� ������� ���������� �����>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_PickUpLogsAndDBF_Loaded(), ioId, False);

   -- ��������� �������� <���� ������ ��������>
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_PickUpLogsAndDBF_DateLoaded(), ioId, Null);
   
   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 20.01.22                                                       *
*/

-- ����
-- select * from gpInsertUpdate_Object_PickUpLogsAndDBF(ioId := 0, inGUID := '{CAE90CED-6DB6-45C0-A98E-84BC0E5D9F26}' ,  inSession := '3');