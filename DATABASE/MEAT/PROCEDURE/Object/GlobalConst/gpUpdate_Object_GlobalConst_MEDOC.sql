DROP FUNCTION IF EXISTS gpUpdate_Object_GlobalConst_MEDOC (TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_GlobalConst_MEDOC(
    IN inSession                  TVarChar       -- ������ ������������
)
 RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpGetUserBySession (inSession);

   -- ��������� <���� ���������� �������>
   PERFORM lpInsertUpdate_ObjectDate(zc_ObjectDate_GlobalConst_ActualBankStatement(), zc_Enum_GlobalConst_MedocTaxDate(), CURRENT_DATE);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (zc_Enum_GlobalConst_MedocTaxDate(), vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.06.15                         * 
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_Car()
