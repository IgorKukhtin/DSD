-- Function: gpUpdateObject_Partner_EdiOrdspr 


DROP FUNCTION IF EXISTS gpUpdateObject_Partner_Edi (Integer, Boolean, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateObject_Partner_Edi (
    IN ioId                  Integer   , -- ���� ������� <��������>
 INOUT inValue               Boolean   , -- ��������
    IN inDesc                TVarChar  , -- 
    IN inSession             TVarChar    -- ������ ������������
)
RETURNS Boolean 
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
     -- ��������
     -- �������� ���� ������������ �� ����� ���������
     vbUserId := lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Partner());

     -- ���������� �������
     inValue:= NOT inValue;
     
     -- ��������� ��������
     PERFORM lpInsertUpdate_ObjectBoolean (tmpDesc.Id, ioId, inValue)
           FROM ObjectBooleanDesc AS tmpDesc
           WHERE ItemName = inDesc;
   
  -- ��������� ��������
     PERFORM lpInsert_ObjectProtocol (ioId, vbUserId, FALSE);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 06.02.15         * 
*/


-- ����
-- SELECT * FROM gpUpdateObject_Partner_Edi (ioId:=  83674 , inValue:= false , inDesc := '����', inSession:= '5')
