-- Function: gpInsertUpdate_Object_EDIEvents(Integer,Integer,TVarChar,TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_EDIEvents (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_EDIEvents(
 INOUT ioId	             Integer,     -- ���� ������� <������� ��������>
    IN inCode                Integer,     -- Id ���������
    IN inName                TVarChar,    -- ��������
    IN inSession             TVarChar     -- ������ ������������
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_EDIEvents());
   vbUserId:= lpGetUserBySession (inSession);


   -- �������� Desc
   IF NOT EXISTS (SELECT MovementBooleanDesc.Code FROM MovementBooleanDesc WHERE LOWER (MovementBooleanDesc.Code) = LOWER (inName))
   THEN 
       RAISE EXCEPTION '������.�������� ��� EDIEvents �� ��������.';
   END IF;


   -- ��������� <������> - !!!������ Insert!!!
   ioId:= lpInsertUpdate_Object (0, zc_Object_EDIEvents(), inCode, inName);
   
   -- ��������� �������� <���� ��������>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
   -- ��������� �������� <������������ (��������)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_EDIEvents (Integer, Integer, TVarChar, TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 04.07.15                                        *
*/

-- ����
-- SELECT * FROM gpInsertUpdate_Object_EDIEvents ()
/*
select *
from Object
     left join ObjectDate on ObjectDate.ObjectId = Object.Id and ObjectDate.DescId = zc_ObjectDate_Protocol_Insert()
     left join ObjectLink on ObjectLink.ObjectId = Object.Id and ObjectLink.DescId = zc_ObjectLink_Protocol_Insert()
     left join Object as Object_User on Object_User.Id = ObjectLink.ChildObjectId
     left join Movement on Movement.Id = Object.ObjectCode
where Object.DescId = zc_Object_EDIEvents()
*/
