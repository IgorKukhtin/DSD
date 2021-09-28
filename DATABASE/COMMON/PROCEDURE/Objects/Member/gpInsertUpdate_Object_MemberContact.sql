-- Function: gpInsertUpdate_Object_MemberContact(Integer, Integer, TVarChar, TVarChar, TVarChar, TVarChar, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberContact (Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MemberContact (Integer, TVarChar, TBlob, TVarChar);


CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MemberContact(
    IN inId	             Integer   ,    -- ���� ������� <���������� ����> 
    IN inEmail               TVarChar  ,    -- Email 
    IN inEMailSign           TBlob     ,    --
    IN inSession             TVarChar       -- ������ ������������
)
  RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;
BEGIN
   -- !!! ��� �������� !!!
   -- IF COALESCE(ioId, 0) = 0
   -- THEN ioId := (SELECT Id FROM Object WHERE ValueData = inName AND DescId = zc_Object_Member());
   -- END IF;

   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Member());
   
   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectString( zc_ObjectString_Member_EMail(), inId, inEMail);

   -- ��������� �������� <>
   PERFORM lpInsertUpdate_ObjectBlob( zc_ObjectBlob_Member_EMailSign(), inId, inEMailSign);

   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_MemberContact(Integer, TVarChar, TBlob, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.12.14                        * 
 18.11.14                        * add 
*/

-- !!!�������������� <���������� ����> � <����������>!!!
-- UPDATE Object SET ValueData = Object2.ValueData , ObjectCode = Object2.ObjectCode from (SELECT Object.*, ObjectId FROM ObjectLink join Object on Object.Id = ObjectLink.ChildObjectId WHERE ObjectLink.DescId = zc_ObjectLink_Personal_Member()) as Object2 WHERE Object.Id  = Object2. ObjectId;
-- ����
-- SELECT * FROM gpInsertUpdate_Object_MemberContact()
