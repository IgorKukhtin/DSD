-- Function: gpUpdate_Object_ReportCollation_Remains(Integer, TFloat, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_ReportCollation_Remains (Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_ReportCollation_Remains(
    IN inId               Integer,      --
    IN inStartRemains     TFloat,      --
    IN inEndRemains       TFloat,      --
    IN inSession          TVarChar
)

RETURNS VOID
AS
$BODY$
  DECLARE vbUserId   Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_ReportCollation());
   

   IF COALESCE (inId, 0) = 0
   THEN
        RAISE EXCEPTION '������."������� ��� ������ �� ��������>';
   END IF;

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ReportCollation_StartRemains(), inId, inStartRemains);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ReportCollation_EndRemains(), inId, inEndRemains);
            

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inObjectId:= inId, inUserId:= vbUserId, inIsUpdate:= FALSE);
  
END;$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.10.18         *
*/
