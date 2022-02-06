-- Function: gpUpdate_ConditionsKeep_isColdSUN()

DROP FUNCTION IF EXISTS gpUpdate_ConditionsKeep_isColdSUN(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_ConditionsKeep_isColdSUN(
    IN inId	                 Integer   ,    -- ���� ������� <̳�������� ������������� ����� (���. ������)> 
    IN inisColdSUN           Boolean   ,    -- ����� ��� ���
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
 
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ConditionsKeep());
   vbUserId := inSession;
   
   -- �������� ����� ���
   IF COALESCE(inId, 0) = 0
   THEN
       RAISE EXCEPTION '������. ������� �������� �� �������.';
   END IF;

   -- ��������� �������� <����� ��� ���>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_ConditionsKeep_ColdSUN(), inId, not inisColdSUN);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 02.02.22                                                      *
*/

-- ����
-- SELECT * FROM gpUpdate_ConditionsKeep_isColdSUN()