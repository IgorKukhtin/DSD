-- Function: gpUpdate_Object_isErased_ContractConditionPartner (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_isErased_ContractConditionPartner (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_isErased_ContractConditionPartner(
    IN inObjectId Integer, 
    IN inSession  TVarChar
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Object_isErased_ContractConditionPartner());

     -- !!!временно - ПРОТОКОЛ - ЗАХАРДКОДИЛ!!!
     INSERT INTO ObjectProtocol (ObjectId, OperDate, UserId, ProtocolData, isInsert)
       SELECT (SELECT OL2.ChildObjectId FROM ObjectLink AS OL JOIN ObjectLink AS OL2 ON OL2.ObjectId = OL.ChildObjectId AND OL2.DescId = zc_ObjectLink_ContractCondition_Contract() WHERE OL.ObjectId = inObjectId AND OL.DescId = zc_ObjectLink_ContractConditionPartner_ContractCondition())
            , CLOCK_TIMESTAMP(), vbUserId
           , '<XML>'
          || '<Field FieldName = "Код" FieldValue = "' || COALESCE ((SELECT Object.ObjectCode FROM ObjectLink AS OL JOIN Object ON Object.Id = OL.ChildObjectId WHERE OL.ObjectId = inObjectId AND OL.DescId = zc_ObjectLink_ContractConditionPartner_Partner()) :: TVarChar, '') || '"/>'
          || '<Field FieldName = "Название" FieldValue = "' || COALESCE ((SELECT Object.ValueData FROM ObjectLink AS OL JOIN Object ON Object.Id = OL.ChildObjectId WHERE OL.ObjectId = inObjectId AND OL.DescId = zc_ObjectLink_ContractConditionPartner_Partner()) :: TVarChar, '') || '"/>'
          || '<Field FieldName = "Id" FieldValue = "' || COALESCE (inObjectId, 0) :: TVarChar || '"/>'
          || '<Field FieldName = "Key" FieldValue = "' || COALESCE ((SELECT ObjectDesc.ItemName || ' (' || ObjectDesc.Code || ')' FROM Object JOIN ObjectDesc ON ObjectDesc.Id = Object.DescId WHERE Object.Id = inObjectId) :: TVarChar, '') || '"/>'
          || '<Field FieldName = "Comment" FieldValue = "Удаление"/>'
          || '</XML>'
           , TRUE;

   -- изменили
   PERFORM lpDelete_Object (inObjectId, inSession) ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.11.20         *
*/
