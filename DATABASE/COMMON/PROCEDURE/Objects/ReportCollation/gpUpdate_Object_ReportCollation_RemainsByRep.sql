-- Function: gpUpdate_Object_ReportCollation_RemainsByRep(Integer, TFloat, TFloat, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_ReportCollation_RemainsByRep (Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_ReportCollation_RemainsByRep(
    IN inId                  Integer,      --
    IN inStartRemainsRep     TFloat,      --
    IN inEndRemainsRep       TFloat,      --
    IN inSession             TVarChar
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
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ReportCollation_StartRemains(), inId, inStartRemainsRep);
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ReportCollation_EndRemains(), inId, inEndRemainsRep);
            

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inObjectId:= inId, inUserId:= vbUserId, inIsUpdate:= TRUE);
  
END;$BODY$
 LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 15.10.18         *
*/
