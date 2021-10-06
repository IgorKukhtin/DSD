-- Function: gpSelect_Object_BanCommentSend()

DROP FUNCTION IF EXISTS gpSelect_Object_BanCommentSend (Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Object_BanCommentSend(
    IN inShowAll       Boolean,       --
    IN inSession       TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Code Integer
             , CommentSendId Integer, CommentSendCode Integer, CommentSendName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar, JuridicalName TVarChar
             , isErased Boolean
              ) AS
$BODY$
BEGIN
      -- проверка прав пользователя на вызов процедуры
      -- PERFORM lpCheckRight(inSession, zc_Enum_Process_BanCommentSend());

      RETURN QUERY 
        SELECT Object_BanCommentSend.Id         AS Id
             , Object_BanCommentSend.ObjectCode AS Code

             , Object_CommentSend.Id         AS CommentSendId
             , Object_CommentSend.ObjectCode AS CommentSendCode
             , Object_CommentSend.ValueData  AS CommentSendName

             , Object_Unit.Id             AS UnitId
             , Object_Unit.ObjectCode     AS UnitCode
             , Object_Unit.ValueData      AS UnitName
             , Object_Juridical.ValueData AS JuridicalName

             , Object_BanCommentSend.isErased

        FROM Object AS Object_BanCommentSend
             LEFT JOIN ObjectLink AS ObjectLink_CommentSend
                                  ON ObjectLink_CommentSend.ObjectId = Object_BanCommentSend.Id
                                 AND ObjectLink_CommentSend.DescId = zc_ObjectLink_BanCommentSend_CommentSend()
             LEFT JOIN Object AS Object_CommentSend ON Object_CommentSend.Id = ObjectLink_CommentSend.ChildObjectId
             LEFT JOIN ObjectLink AS ObjectLink_Unit
                                  ON ObjectLink_Unit.ObjectId = Object_BanCommentSend.Id
                                 AND ObjectLink_Unit.DescId = zc_ObjectLink_BanCommentSend_Unit()
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Unit.ChildObjectId

             LEFT JOIN ObjectLink AS ObjectLink_Unit_Juridical
                                  ON ObjectLink_Unit_Juridical.ObjectId = Object_Unit.Id
                                 AND ObjectLink_Unit_Juridical.DescId = zc_ObjectLink_Unit_Juridical()
             LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = ObjectLink_Unit_Juridical.ChildObjectId

        WHERE Object_BanCommentSend.DescId = zc_Object_BanCommentSend()
          AND (Object_BanCommentSend.isErased = False OR inShowAll = True);
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 04.10.21                                                       *
*/

-- тест
-- 
SELECT * FROM gpSelect_Object_BanCommentSend (FALSE, '3')
