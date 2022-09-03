-- Function: gpUpdate_Movement_FilesToCheck_FileName()

DROP FUNCTION IF EXISTS gpUpdate_Movement_FilesToCheck_FileName (Integer, TVarChar, Tvarchar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_FilesToCheck_FileName(
    IN inId                      Integer   ,   	-- ���� ������� <>
    IN inFileName                TVarChar  ,    -- ��� �����
    IN inSession                 TVarChar       -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_ImportTypeItems());
   vbUserId := lpGetUserBySession (inSession); 
  
   IF COALESCE (inId, 0) = 0
   THEN
      RAISE EXCEPTION '������. �������� �� ��������...';
   END IF;

   -- ��������� <��� �����>
   PERFORM lpInsertUpdate_MovementString(zc_MovementString_FileName(), inId, inFileName);
   
   -- ��������� ��������
   PERFORM lpInsert_MovementProtocol (inId, vbUserId, False);
END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Movement_FilesToCheck_FileName (Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 03.09.22                                                       *
*/

-- ����
-- SELECT * FROM gpUpdate_Movement_FilesToCheck_FileName ()                            