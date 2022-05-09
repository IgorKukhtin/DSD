-- Function: gpUpdate_Object_Guide_Irna()

DROP FUNCTION IF EXISTS gpUpdate_Object_Guide_Irna (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Guide_Irna(
    IN inId                  Integer   , --
    IN inisIrna              Boolean   , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Object_Guide_Irna());
     vbUserId:= lpGetUserBySession (inSession);

     -- �������� �������
     inisIrna:= NOT inisIrna;

     -- ��������� ��������
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Guide_Irna(), inId, inisIrna);

     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 05.05.22         *
*/


-- ����
--