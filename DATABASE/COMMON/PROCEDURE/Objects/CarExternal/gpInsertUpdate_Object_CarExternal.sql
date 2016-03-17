-- Function: gpInsertUpdate_Object_CarExternal (Integer, Integer, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CarExternal (Integer, Integer, TVarChar, TVarChar,TVarChar,Integer,Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CarExternal(
   INOUT ioId                       Integer, 
      IN incode                     Integer, 
      IN inName                     TVarChar, 
      IN inRegistrationCertificate  TVarChar, 
      IN inComment                  TVarChar  ,    -- ����������
      IN inCarModelId               Integer, 
      IN inJuridicalId              Integer,        
      IN inSession                  TVarChar
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_CarExternal());
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object_CarExternal (ioId	    := ioId
                                            , inCode        := inCode
                                            , inName        := inName
                                            , inRegistrationCertificate := inRegistrationCertificate
                                            , inComment     := inComment
                                            , inCarModelId  := inCarModelId
                                            , inJuridicalId := inJuridicalId
                                            , inUserId      := vbUserId
                                              );

  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 17.03.16         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_CarExternal()
