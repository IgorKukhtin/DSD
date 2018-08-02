-- 

DROP FUNCTION IF EXISTS gpExecForm_repl (TVarChar, TBlob, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpExecForm_repl (
    IN inFormName        TVarChar,      -- ������� �������� ������� <�����> 
    IN inFormData        TBLOB   ,      -- ������ ����� 
    IN gConnectHost      TVarChar,      -- �����������, ��� � � exe - ������������ ������ ������
    IN inSession         TVarChar       -- ������ ������������
) 
RETURNS VOID
AS $BODY$
BEGIN
      PERFORM gpInsertUpdate_Object_Form (inFormName, inFormData, zfCalc_UserAdmin());
END; $BODY$
  LANGUAGE plpgsql;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.08.18                                        *
*/

-- ����
-- SELECT * FROM gpExecForm_repl ('select 1', '', zfCalc_UserAdmin())
