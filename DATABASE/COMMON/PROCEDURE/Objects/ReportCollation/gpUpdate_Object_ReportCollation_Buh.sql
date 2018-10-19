-- Function: gpUpdate_Object_ReportCollation_Buh (Integer, TDateTime, Boolean TVarChar);

DROP FUNCTION IF EXISTS gpUpdate_Object_ReportCollation_Buh (Integer, TDateTime, Boolean , TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_ReportCollation_Buh (Integer, Boolean , TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_ReportCollation_Buh(
    In inId                 Integer   ,
    IN inIsBuh              Boolean   ,
    IN inSession            TVarChar
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ReportCollation());

     -- ��������
     IF COALESCE (inId, 0) = 0
     THEN
         RAISE EXCEPTION '������.��� ������ �� ��������.';
     END IF;

        
     -- ��������� �������� <����� � �����������>
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_ReportCollation_Buh(), inId, inIsBuh);
     
     -- ���� ������� ����� � ��� = True , ����� ��������� ����
     IF inIsBuh = TRUE     
     THEN                     
         -- ��������� �������� <���� ����� � �����������>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReportCollation_Buh(), inId, CURRENT_TIMESTAMP);
     END IF;
     
     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (inObjectId:= inId, inUserId:= vbUserId, inIsUpdate:= FALSE);
   
END;$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.10.18         *
*/

-- ����
-- 