-- Function: gpUpdate_Object_Goods_IsUpload()

DROP FUNCTION IF EXISTS gpUpdate_Unit_Params(Integer, TDateTime, TDateTime, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_Params(
    IN inId                  Integer   ,    -- ���� ������� <�������������>
    IN inCreateDate          TDateTime ,    -- ���� �������� �����
    IN inCloseDate           TDateTime ,    -- ���� �������� �����
    IN inUserManagerId       Integer   ,    -- ������ �� ��������
    IN inSession             TVarChar       -- ������� ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE vbCreateDate TDateTime;
   DECLARE vbCloseDate  TDateTime;
   
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;
   
   -- �������� ���� ������������ �� ����� ���������
   vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_Unit_Params());
   --vbUserId := lpGetUserBySession (inSession);

   -- ������� ���������� �������� ���� ����
   vbCreateDate := (SELECT ObjectDate_Create.ValueData
                    FROM ObjectDate AS ObjectDate_Create
                    WHERE ObjectDate_Create.DescId = zc_ObjectDate_Unit_Create()
                      AND ObjectDate_Create.ObjectId = inId);
   vbCloseDate := (SELECT ObjectDate_Close.ValueData
                    FROM ObjectDate AS ObjectDate_Close
                    WHERE ObjectDate_Close.DescId = zc_ObjectDate_Unit_Close()
                      AND ObjectDate_Close.ObjectId = inId);

   -- ��������� ����� � <��������>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Unit_UserManager(), inId, inUserManagerId);
   
   IF (inCreateDate is not NULL) OR (vbCreateDate is not NULL)
   THEN
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_Create(), inId, inCreateDate);
   END IF;

   IF (inCloseDate is not NULL) OR (vbCloseDate is not NULL)
   THEN   
       -- ��������� �������� <>
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_Close(), inId, inCloseDate);
   END IF;

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ��������� �.�.
 15.09.17         *

*/