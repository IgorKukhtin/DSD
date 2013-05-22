-- Function: lpFind_Object_Account()

-- DROP FUNCTION lpFind_Object_Account();

CREATE OR REPLACE FUNCTION lpFind_Object_Account(
IN inAccountGroupId      Integer   ,    /* Группа счетов */
IN inAccountPlaceId      Integer   ,    /* Аналитика счета (место) */
IN inAccountReferenceId  Integer        /* Аналитика счета (назначение) */
)
  RETURNS integer AS
$BODY$
DECLARE lObjectId integer;
BEGIN
--   PERFORM lpCheckRight(inSession, zc_Enum_Process_Account());

   SELECT  
        ObjectLink_Account_AccountGroup.ObjectId INTO lObjectId 
   FROM 
        ObjectLink AS ObjectLink_Account_AccountGroup
   JOIN ObjectLink AS ObjectLink_Account_AccountPlace
     ON ObjectLink_Account_AccountPlace.DescId = zc_ObjectLink_Account_AccountPlace()
    AND ObjectLink_Account_AccountPlace.ChildObjectId = inAccountPlaceId
    AND ObjectLink_Account_AccountPlace.ObjectId = ObjectLink_Account_AccountGroup.ObjectId
   JOIN ObjectLink AS ObjectLink_Account_AccountReference
     ON ObjectLink_Account_AccountReference.DescId = zc_ObjectLink_Account_AccountReference()
    AND ObjectLink_Account_AccountReference.ChildObjectId = inAccountReferenceId
    AND ObjectLink_Account_AccountReference.ObjectId = ObjectLink_Account_AccountGroup.ObjectId
  WHERE ObjectLink_Account_AccountGroup.DescId = zc_ObjectLink_Account_AccountGroup()
    AND ObjectLink_Account_AccountGroup.ChildObjectId = inAccountGroupId;

  RETURN COALESCE(lObjectId, 0);

END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
                            