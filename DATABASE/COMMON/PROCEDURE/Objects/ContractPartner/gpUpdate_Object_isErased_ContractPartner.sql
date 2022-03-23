-- Function: gpUpdate_Object_isErased_ContractPartner (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_ContractPartner (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased_ContractPartner(
    IN inObjectId Integer,
    IN inSession  TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- �������� ���� ������������ �� ����� ���������
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_isErased_ContractPartner());

     -- !!!�������� - �������� - �����������!!!
     INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
       SELECT (SELECT OL.ChildObjectId FROM ObjectLink AS OL WHERE OL.ObjectId = inObjectId AND OL.DescId = zc_ObjectLink_ContractPartner_Contract())
            , CLOCK_TIMESTAMP(), vbUserId
           , '<XML>'
          || '<Field FieldName = "���" FieldValue = "' || COALESCE ((SELECT Object.ObjectCode FROM ObjectLink AS OL JOIN Object ON Object.Id = OL.ChildObjectId WHERE OL.ObjectId = inObjectId AND OL.DescId = zc_ObjectLink_ContractPartner_Partner()) :: TVarChar, '') || '"/>'
          || '<Field FieldName = "��������" FieldValue = "' || COALESCE ((SELECT Object.ValueData FROM ObjectLink AS OL JOIN Object ON Object.Id = OL.ChildObjectId WHERE OL.ObjectId = inObjectId AND OL.DescId = zc_ObjectLink_ContractPartner_Partner()) :: TVarChar, '') || '"/>'
          || '<Field FieldName = "Id" FieldValue = "' || COALESCE (inObjectId, 0) :: TVarChar || '"/>'
          || '<Field FieldName = "Key" FieldValue = "' || COALESCE ((SELECT ObjectDesc.ItemName || ' (' || ObjectDesc.Code || ')' FROM Object JOIN ObjectDesc ON ObjectDesc.Id = Object.DescId WHERE Object.Id = inObjectId) :: TVarChar, '') || '"/>'
          || '<Field FieldName = "Comment" FieldValue = "��������"/>'
          || '</XML>'
           , TRUE;

   -- ��������
   -- PERFORM lpUpdate_Object_isErased (inObjectId:= inObjectId, inUserId:= vbUserId);
   PERFORM lpDelete_Object (inObjectId, inSession) ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Object_isErased_ContractPartner (Integer, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.06.15                                        * add lpDelete_Object
 09.02.15         *
*/
