-- Function: gpInsertUpdate_Object_ContractKind()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MedocLoadInfo(TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MedocLoadInfo(
   IN inPeriod              TDateTime ,    -- ������
   IN inSession             TVarChar       -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;   
   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_ContractKind());
   vbUserId:= lpGetUserBySession (inSession);

   
   -- ������ ������� � ������ ������
   inPeriod := date_trunc('month', inPeriod);

   -- �������� ����� ������

   SELECT Id INTO vbId FROM Object_MedocLoadInfo_View WHERE Period = inPeriod;

   IF COALESCE(vbId, 0) = 0 THEN
      -- ��������� <������>
      vbId := lpInsertUpdate_Object(0, zc_Object_MedocLoadInfo(), 0, '');

      -- ��������� �������� <>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_MedocLoadInfo_Period(), vbId, inPeriod);
   END IF;

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_MedocLoadInfo_LoadDateTime(), vbId, current_timestamp);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (vbId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_MedocLoadInfo (TDateTime, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
   25.05.15                       * 
*/

-- ����
-- SELECT * FROM ()
