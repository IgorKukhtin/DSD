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
    tmpText AS (    SELECT  1 ::Integer  AS Ord, 'Отвественный сотрудник коммерческого отдела:'  ::TVarChar AS Name
              UNION SELECT  2 ::Integer  AS Ord, 'Отвественный сотрудник экономического отдела:' ::TVarChar AS Name   --
              UNION SELECT  3 ::Integer  AS Ord, 'Региональнай менеджер / Директор филиала:'     ::TVarChar AS Name
              UNION SELECT  4 ::Integer  AS Ord, 'Руководитель отдела продаж:'                   ::TVarChar AS Name
              UNION SELECT  5 ::Integer  AS Ord, 'Отвественный сотрудник отдела маркетинга:'     ::TVarChar AS Name
              UNION SELECT  6 ::Integer  AS Ord, 'Коммерческий директор:'                        ::TVarChar AS Name
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
          , Object_Member.Id         ::Integer  AS ValueId
          , Object_Member.ValueData  ::TVarChar AS Value
    FROM tmpText
         LEFT JOIN tmpData ON 1=1
         LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpData.Member1Id           
    WHERE tmpText.Ord = 1
 UNION
    SELECT  tmpText.Ord              ::Integer
          , tmpText.Name             ::TVarChar
          , Object_Member.Id         ::Integer  AS ValueId
          , Object_Member.ValueData  ::TVarChar AS Value
    FROM tmpText
         LEFT JOIN tmpData ON 1=1
         LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpData.Member2Id           
    WHERE tmpText.Ord = 2
 UNION
    SELECT  tmpText.Ord              ::Integer
          , tmpText.Name             ::TVarChar
          , Object_Member.Id         ::Integer  AS ValueId
          , Object_Member.ValueData  ::TVarChar AS Value
    FROM tmpText
         LEFT JOIN tmpData ON 1=1
         LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpData.Member3Id           
    WHERE tmpText.Ord = 3
  UNION
    SELECT  tmpText.Ord              ::Integer
          , tmpText.Name             ::TVarChar
          , Object_Member.Id         ::Integer  AS ValueId
          , Object_Member.ValueData  ::TVarChar AS Value
    FROM tmpText
         LEFT JOIN tmpData ON 1=1
         LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpData.Member4Id           
    WHERE tmpText.Ord = 4
   UNION
    SELECT  tmpText.Ord              ::Integer
          , tmpText.Name             ::TVarChar
          , Object_Member.Id         ::Integer  AS ValueId
          , Object_Member.ValueData  ::TVarChar AS Value
    FROM tmpText
         LEFT JOIN tmpData ON 1=1
         LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpData.Member5Id           
    WHERE tmpText.Ord = 5
    UNION
    SELECT  tmpText.Ord              ::Integer
          , tmpText.Name             ::TVarChar
          , Object_Member.Id         ::Integer  AS ValueId
          , Object_Member.ValueData  ::TVarChar AS Value
    FROM tmpText
         LEFT JOIN tmpData ON 1=1
         LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpData.Member6Id           
    WHERE tmpText.Ord = 6    
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
