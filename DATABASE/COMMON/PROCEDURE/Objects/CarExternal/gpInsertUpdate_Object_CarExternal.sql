-- Function: gpInsertUpdate_Object_CarExternal (Integer, Integer, TVarChar, TVarChar)

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CarExternal (Integer, Integer, TVarChar, TVarChar,TVarChar,Integer,Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CarExternal (Integer, Integer, TVarChar, TVarChar, TVarChar,TVarChar,Integer,Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CarExternal (Integer, Integer, TVarChar, TVarChar, TVarChar,TVarChar,Integer,Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_CarExternal (Integer, Integer, TVarChar, TVarChar, TVarChar,TVarChar,Integer,Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_CarExternal(
   INOUT ioId                       Integer, 
      IN incode                     Integer, 
      IN inName                     TVarChar, 
      IN inRegistrationCertificate  TVarChar, 
      IN inVIN                      TVarChar,    -- VIN ���
      IN inComment                  TVarChar  ,    -- ����������
      IN inCarModelId               Integer, 
      IN inCarTypeId                Integer,     -- ������ ����������  
      IN inCarPropertyId            Integer,     -- ��� ����
      IN inObjectColorId            Integer,     -- ���� ����
      IN inJuridicalId              Integer,
      IN inLength                   TFloat ,     -- 
      IN inWidth                    TFloat ,     -- 
      IN inHeight                   TFloat ,     -- 
      IN inWeight                   TFloat ,     --
      IN inYear                     TFloat ,     --     
      IN inSession                  TVarChar
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_CarExternal());
   vbUserId:= lpGetUserBySession (inSession);
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object_CarExternal (ioId	    := ioId
                                            , inCode        := inCode
                                            , inName        := inName
                                            , inRegistrationCertificate := inRegistrationCertificate
                                            , inVIN         := inVIN
                                            , inComment     := inComment
                                            , inCarModelId  := inCarModelId 
                                            , inCarTypeId   := inCarTypeId
                                            , inCarPropertyId := inCarPropertyId
                                            , inObjectColorId := inObjectColorId
                                            , inJuridicalId := inJuridicalId
                                            , inLength      := inLength
                                            , inWidth       := inWidth 
                                            , inHeight      := inHeight
                                            , inWeight      := inWeight
                                            , inYear        := inYear  
                                            , inUserId      := vbUserId
                                              );

  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.11.23         *
 09.11.21         *
 17.03.16         *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_CarExternal()
