-- Function: gpUpdate_Object_User_ScalePSW()

DROP FUNCTION IF EXISTS gpUpdate_Object_User_ScalePSW (Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Object_Member_ScalePSW (Integer, TVarChar, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Member_ScalePSW(
    IN inMemberId      Integer   ,    -- ���� ������� <������������> 
    IN inScalePSW      TVarChar  ,    -- ������
    IN inSession       TVarChar       -- ������ ������������
)
  RETURNS Void 
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_Member_ScalePSW());
   
   
   IF COALESCE (inMemberId, 0) = 0
   THEN
       RAISE EXCEPTION '������.� ���������� �� ���������� ���.����.';
   END IF;

   IF zfConvert_StringToNumber (inScalePSW) = 0 AND inScalePSW <> ''
   THEN
       RAISE EXCEPTION '������.������ ������ ���� ������ ������ 0.';
   END IF;

   IF CHAR_LENGTH (inScalePSW) >= 8
   THEN
       RAISE EXCEPTION '������.������ ������ ���� ������ �� 8 ������.';
   END IF;

   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Member_ScalePSW(), inMemberId, zfConvert_StringToNumber (inScalePSW));
  
   -- C�������� ��������
   -- PERFORM lpInsert_ObjectProtocol (inMemberId, vbUserId);
 
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.10.17         * rename
 20.01.17         *
*/

-- ����
-- SELECT * FROM gpUpdate_Object_Member_ScalePSW ('2')
