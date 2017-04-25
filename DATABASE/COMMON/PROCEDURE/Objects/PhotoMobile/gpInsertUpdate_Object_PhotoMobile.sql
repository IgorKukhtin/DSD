-- Function: gpInsertUpdate_Object_PhotoMobile()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PhotoMobile(Integer, Integer, TVarChar, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PhotoMobile(
 INOUT ioId             Integer   ,     -- ���� ������� <�������> 
    IN inCode           Integer   ,     -- MovementItemId
    IN inName           TVarChar  ,     -- �������� ������� 
    IN inPhotoData      TBlob     ,
    IN inSession        TVarChar        -- ������ ������������
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- �������� ���� ������������ �� ����� ���������
    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_PhotoMobile());

   -- �������� ���� ������������ ��� �������� <������������>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_PhotoMobile(), inName);


   -- ��������� <������>
   ioId := lpInsertUpdate_Object_PhotoMobile (ioId	   := ioId
                                            , inCode       := inCode
                                            , inName       := inName
                                            , inPhotoData  := inPhotoData
                                            , inUserId     := vbUserId
                                             );
  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 26.03.17         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_PhotoMobile(ioId:=null, inCode:=null, inName:='������ 1', inSession:='2')