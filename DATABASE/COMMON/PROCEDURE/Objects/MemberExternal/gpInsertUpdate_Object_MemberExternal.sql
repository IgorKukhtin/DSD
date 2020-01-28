-- Function: gpInsertUpdate_Object_MemberExternal (Integer, Integer, TVarChar, TVarChar)

--DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberExternal (Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberExternal (Integer, Integer, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberExternal(
 INOUT ioId	             Integer   ,    -- ���� ������� <���������� ����(���������)> 
    IN inCode                Integer   ,    -- ��� ������� 
    IN inName                TVarChar  ,    -- �������� �������
    IN inDriverCertificate   TVarChar  ,    -- ������������ �������������
    IN inSession             TVarChar       -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_MemberExternal());
   
   -- ��������� <������>
   ioId := lpInsertUpdate_Object_MemberExternal (ioId	 := ioId
                                               , inCode  := inCode
                                               , inName  := inName
                                               , inDriverCertificate := inDriverCertificate
                                               , inUserId:= vbUserId
                                                );

  
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 27.01.20         *
 28.03.15                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_MemberExternal()
