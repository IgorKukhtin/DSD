-- Function: lpSelect_Object_SignInternalItem (TVarChar)

-- DROP FUNCTION IF EXISTS lpSelect_Object_SignInternalItem (Integer, Integer, Integer);
DROP FUNCTION IF EXISTS lpSelect_Object_SignInternalItem (Integer, Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION lpSelect_Object_SignInternalItem(
    IN inSignInternalId      Integer, -- Модель электронной подписи
    IN inMovementDescId      Integer, -- Вид документа
    IN inObjectDescId        Integer, -- Вид справочника
    IN inObjectId            Integer  -- Элемент справочника
)
RETURNS TABLE (Ord Integer
             , SignInternalId Integer, SignInternalName TVarChar
               -- здесь или User или
             , UserId Integer, UserCode Integer, UserName TVarChar
             , isMain Boolean
              )
AS
$BODY$
BEGIN

   -- Результат
   RETURN QUERY
         SELECT
               Object_SignInternalItem.ObjectCode AS Ord
             , Object_SignInternal.Id             AS SignInternalId
             , Object_SignInternal.ValueData      AS SignInternalName

             , CASE WHEN ObjectFloat_MovementDesc.ValueData = zc_Movement_PromoTrade() THEN Object_SignInternalItem.Id         ELSE Object_User.Id         END :: Integer  AS UserId
             , CASE WHEN ObjectFloat_MovementDesc.ValueData = zc_Movement_PromoTrade() THEN Object_SignInternalItem.ObjectCode ELSE Object_User.ObjectCode END :: Integer  AS UserCode
             , CASE WHEN ObjectFloat_MovementDesc.ValueData = zc_Movement_PromoTrade() THEN Object_SignInternalItem.ValueData  ELSE Object_User.ValueData  END :: TVarChar AS UserName
             , COALESCE (ObjectBoolean_Main.ValueData, FALSE) :: Boolean AS isMain

         FROM Object AS Object_SignInternal
              --
              INNER JOIN ObjectFloat AS ObjectFloat_MovementDesc
                                     ON ObjectFloat_MovementDesc.ObjectId = Object_SignInternal.Id
                                    AND ObjectFloat_MovementDesc.DescId = zc_ObjectFloat_SignInternal_MovementDesc()
                                    AND (ObjectFloat_MovementDesc.ValueData :: Integer = inMovementDescId OR inMovementDescId = 0)
              INNER JOIN ObjectFloat AS ObjectFloat_ObjectDesc
                                     ON ObjectFloat_ObjectDesc.ObjectId = Object_SignInternal.Id
                                    AND ObjectFloat_ObjectDesc.DescId = zc_ObjectFloat_SignInternal_ObjectDesc()
                                    AND (ObjectFloat_ObjectDesc.ValueData :: Integer = inObjectDescId OR inObjectDescId = 0)

              INNER JOIN ObjectLink AS ObjectLink_SignInternal_Object
                                    ON ObjectLink_SignInternal_Object.ObjectId = Object_SignInternal.Id
                                   AND ObjectLink_SignInternal_Object.DescId = zc_ObjectLink_SignInternal_Object()
                                   AND (ObjectLink_SignInternal_Object.ChildObjectId = inObjectId OR inObjectId = 0)

              LEFT JOIN ObjectBoolean AS ObjectBoolean_Main
                                      ON ObjectBoolean_Main.ObjectId = Object_SignInternal.Id
                                     AND ObjectBoolean_Main.DescId = zc_ObjectBoolean_SignInternal_Main()

              LEFT JOIN ObjectLink AS ObjectLink_SignInternalItem_SignInternal
                                   ON ObjectLink_SignInternalItem_SignInternal.ChildObjectId = Object_SignInternal.Id
                                  AND ObjectLink_SignInternalItem_SignInternal.DescId = zc_ObjectLink_SignInternalItem_SignInternal()
              INNER JOIN Object AS Object_SignInternalItem
                                ON Object_SignInternalItem.Id       = ObjectLink_SignInternalItem_SignInternal.ObjectId
                               AND Object_SignInternalItem.isErased = FALSE

              LEFT JOIN ObjectLink AS ObjectLink_SignInternalItem_User
                                   ON ObjectLink_SignInternalItem_User.ObjectId = Object_SignInternalItem.Id
                                  AND ObjectLink_SignInternalItem_User.DescId = zc_ObjectLink_SignInternalItem_User()
              LEFT JOIN Object AS Object_User ON Object_User.Id = ObjectLink_SignInternalItem_User.ChildObjectId

              LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                   ON ObjectLink_User_Member.ObjectId = Object_User.Id
                                  AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
              LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

         WHERE Object_SignInternal.DescId   = zc_Object_SignInternal()
           AND Object_SignInternal.isErased = FALSE
           AND (Object_SignInternal.Id = inSignInternalId
            OR  (ObjectBoolean_Main.ValueData = TRUE AND COALESCE (inSignInternalId, 0) = 0)
               )
  ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.08.16         *
*/

-- тест
-- SELECT * FROM lpSelect_Object_SignInternalItem (0, 1, 43,0)
-- SELECT * FROM lpSelect_Object_SignInternalItem (0, 0, 43,0)
