-- Function: gpUpdate_Object_ReplServer_Start()

DROP FUNCTION IF EXISTS gpUpdate_Object_ReplServer_Start (Integer, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_ReplServer_Start(
    IN inId                  Integer   , -- ���� ������� <>
    IN inOperDate            TDateTime , -- 
    IN inIsTo                Boolean   , -- ����  �� - StartTo , �����  StartFrom
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ReplServer());
     vbUserId:= lpGetUserBySession (inSession);

     IF inIsTo = TRUE 
     THEN 
         -- ��������� �������� <����/����� ������ �������� � ����-Child>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReplServer_StartTo(), inId, inOperDate);
     ELSE
         -- ��������� �������� <����/����� ������ ��������� �� ����-Child>
         PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_ReplServer_StartFrom(), inId, inOperDate);     
     END IF;
     
     -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (inId, vbUserId, FALSE);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 21.06.18         *
*/

-- ����
-- 