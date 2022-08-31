-- Function: gpUpdate_Object_Unit_Position (Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, Integer, TVarChar);

DROP FUNCTION IF EXISTS gpUpdate_Object_Unit_Position (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Unit_Position(
    IN inId                  Integer   ,    -- ���� ������� <�������������> 
    IN inPosition            Integer   ,    -- 
    IN inDescCode            TVarChar  ,    -- 
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
   DECLARE vbGroupNameFull TVarChar;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Unit());
   vbUserId:= lpGetUserBySession (inSession);
   
   IF COALESCE (inId, 0) = 0
   THEN
     RETURN;
   END IF;
   

   -- ��������� ��������� 
   PERFORM lpInsertUpdate_ObjectFloat ((SELECT tmp.Id FROM ObjectFloatDesc AS tmp WHERE tmp.Code = inDescCode), inId, inPosition);

   -- ��������� ��������
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 30.08.22         *
*/

-- ����
--