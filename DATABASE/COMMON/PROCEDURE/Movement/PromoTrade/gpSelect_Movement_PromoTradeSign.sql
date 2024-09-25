-- Function: gpSelect_Movement_PromoTradeSign()

DROP FUNCTION IF EXISTS gpSelect_Movement_PromoTradeSign (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PromoTradeSign(
    IN inMovementId    Integer , -- Ключ документа <Акция>
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Ord              Integer
             , Name             TVarChar    --имя параметра  
             , ValueId          Integer     --Шв'
             , Value            TVarChar    --значение параметра 
              )

AS
$BODY$
   DECLARE vbUserId Integer;  
   DECLARE vbMovementId_PromoTradeSign Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     vbMovementId_PromoTradeSign := (SELECT Movement.Id
                                     FROM Movement
                                     WHERE Movement.DescId = zc_Movement_PromoTradeSign()
                                       AND Movement.ParentId = inMovementId
                                    );


    -- Результат
    RETURN QUERY
    WITH 
    tmpText AS (    SELECT  1 ::Integer  AS Ord, '1.Автор документа'                              ::TVarChar AS Name
              UNION SELECT  2 ::Integer  AS Ord, '2.Відповідальний співробітник комерційного відділу'  ::TVarChar AS Name
              UNION SELECT  3 ::Integer  AS Ord, '3.Відповідальний співробітник економічного відділу' ::TVarChar AS Name   --
              UNION SELECT  4 ::Integer  AS Ord, '4.Регіональний менеджер'     ::TVarChar AS Name
              UNION SELECT  5 ::Integer  AS Ord, '5.Керівник відділу продажу'                   ::TVarChar AS Name
              UNION SELECT  6 ::Integer  AS Ord, '6.Відповідальний співробітник відділу маркетингу'     ::TVarChar AS Name
              UNION SELECT  7 ::Integer  AS Ord, '7.Комерційний директор'                        ::TVarChar AS Name
                 )

  , tmpData AS (SELECT MovementLinkObject_Member1.ObjectId   AS Member1Id
                     , MovementLinkObject_Member2.ObjectId   AS Member2Id
                     , MovementLinkObject_Member3.ObjectId   AS Member3Id
                     , MovementLinkObject_Member4.ObjectId   AS Member4Id
                     , MovementLinkObject_Member5.ObjectId   AS Member5Id
                     , MovementLinkObject_Member6.ObjectId   AS Member6Id
                FROM Movement
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Member1
                                                  ON MovementLinkObject_Member1.MovementId = Movement.Id
                                                 AND MovementLinkObject_Member1.DescId = zc_MovementLinkObject_Member_1() 
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Member2
                                                  ON MovementLinkObject_Member2.MovementId = Movement.Id
                                                 AND MovementLinkObject_Member2.DescId = zc_MovementLinkObject_Member_2()
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Member3
                                                  ON MovementLinkObject_Member3.MovementId = Movement.Id
                                                 AND MovementLinkObject_Member3.DescId = zc_MovementLinkObject_Member_3() 
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Member4
                                                  ON MovementLinkObject_Member4.MovementId = Movement.Id
                                                 AND MovementLinkObject_Member4.DescId = zc_MovementLinkObject_Member_4() 
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Member5
                                                  ON MovementLinkObject_Member5.MovementId = Movement.Id
                                                 AND MovementLinkObject_Member5.DescId = zc_MovementLinkObject_Member_5() 
                     LEFT JOIN MovementLinkObject AS MovementLinkObject_Member6
                                                  ON MovementLinkObject_Member6.MovementId = Movement.Id
                                                 AND MovementLinkObject_Member6.DescId = zc_MovementLinkObject_Member_6() 
                WHERE Movement.Id = vbMovementId_PromoTradeSign
                )

    SELECT  tmpText.Ord              ::Integer
          , tmpText.Name             ::TVarChar
          , COALESCE (Object_Member.Id, Object_User.Id)                ::Integer  AS ValueId
          , COALESCE (Object_Member.ValueData, Object_User.ValueData)  ::TVarChar AS Value
    FROM tmpText
            LEFT JOIN MovementLinkObject AS MLO_User
                                         ON MLO_User.MovementId = inMovementId
                                        AND MLO_User.DescId     = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_User ON Object_User.Id     = MLO_User.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId = MLO_User.ObjectId
                                AND ObjectLink_User_Member.DescId   = zc_ObjectLink_User_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId
    WHERE tmpText.Ord = 1

 UNION
    SELECT  tmpText.Ord              ::Integer
          , tmpText.Name             ::TVarChar
          , Object_Member.Id         ::Integer  AS ValueId
          , Object_Member.ValueData  ::TVarChar AS Value
    FROM tmpText
         LEFT JOIN tmpData ON 1=1
         LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpData.Member1Id           
    WHERE tmpText.Ord = 2
 UNION
    SELECT  tmpText.Ord              ::Integer
          , tmpText.Name             ::TVarChar
          , Object_Member.Id         ::Integer  AS ValueId
          , Object_Member.ValueData  ::TVarChar AS Value
    FROM tmpText
         LEFT JOIN tmpData ON 1=1
         LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpData.Member2Id           
    WHERE tmpText.Ord = 3
 UNION
    SELECT  tmpText.Ord              ::Integer
          , tmpText.Name             ::TVarChar
          , Object_Member.Id         ::Integer  AS ValueId
          , Object_Member.ValueData  ::TVarChar AS Value
    FROM tmpText
         LEFT JOIN tmpData ON 1=1
         LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpData.Member3Id           
    WHERE tmpText.Ord = 4
  UNION
    SELECT  tmpText.Ord              ::Integer
          , tmpText.Name             ::TVarChar
          , Object_Member.Id         ::Integer  AS ValueId
          , Object_Member.ValueData  ::TVarChar AS Value
    FROM tmpText
         LEFT JOIN tmpData ON 1=1
         LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpData.Member4Id           
    WHERE tmpText.Ord = 5
   UNION
    SELECT  tmpText.Ord              ::Integer
          , tmpText.Name             ::TVarChar
          , Object_Member.Id         ::Integer  AS ValueId
          , Object_Member.ValueData  ::TVarChar AS Value
    FROM tmpText
         LEFT JOIN tmpData ON 1=1
         LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpData.Member5Id           
    WHERE tmpText.Ord = 6
    UNION
    SELECT  tmpText.Ord              ::Integer
          , tmpText.Name             ::TVarChar
          , Object_Member.Id         ::Integer  AS ValueId
          , Object_Member.ValueData  ::TVarChar AS Value
    FROM tmpText
         LEFT JOIN tmpData ON 1=1
         LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpData.Member6Id           
    WHERE tmpText.Ord = 7    
    ORDER by 1  
    ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.09.24         *
*/

-- SELECT * FROM gpSelect_Movement_PromoTradeSign (inMovementId:= 29197668 , inSession:= zfCalc_UserAdmin())
