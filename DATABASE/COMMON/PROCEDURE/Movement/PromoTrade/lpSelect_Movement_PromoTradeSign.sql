-- Function: lpSelect_Movement_PromoTradeSign (Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS lpSelect_Movement_PromoTradeSign (Integer);

CREATE OR REPLACE FUNCTION lpSelect_Movement_PromoTradeSign(
    IN inMovementId  Integer       -- ключ Документа
)
RETURNS TABLE (Num             Integer
             , MemberId        Integer
             , MemberName      TVarChar -- 
             , UserId          Integer
             , UserName        TVarChar -- 
             , ItemName        TVarChar -- 
              )
AS
$BODY$
BEGIN
   
     -- Результат
     RETURN QUERY 
       SELECT 1                    :: Integer AS Num
            , MLO.ObjectId                    AS MemberId
            , Object_Member.ValueData         AS MemberName
            , ObjectLink_User_Member.ObjectId AS UserId
            , Object_User.ValueData           AS UserName
            , '1.Автор документа'   :: TVarChar AS ItemName
       FROM MovementLinkObject AS MLO 
            LEFT JOIN Object AS Object_User ON Object_User.Id = MLO.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ObjectId      = MLO.ObjectId
                                AND ObjectLink_User_Member.DescId        = zc_ObjectLink_User_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId
            
       WHERE MLO.MovementId = inMovementId
         AND MLO.DescId     = zc_MovementLinkObject_Insert()

      UNION ALL
       SELECT CASE MLO.DescId
                   WHEN zc_MovementLinkObject_Member_1() THEN 2
                   WHEN zc_MovementLinkObject_Member_2() THEN 3
                   WHEN zc_MovementLinkObject_Member_3() THEN 4
                   WHEN zc_MovementLinkObject_Member_4() THEN 5
                   WHEN zc_MovementLinkObject_Member_5() THEN 6
                   WHEN zc_MovementLinkObject_Member_6() THEN 7
              END :: Integer AS Num
            , MLO.ObjectId                    AS MemberId
            , Object_Member.ValueData         AS MemberName
            , ObjectLink_User_Member.ObjectId AS UserId
            , Object_User.ValueData           AS UserName
            , CASE MLO.DescId
                   WHEN zc_MovementLinkObject_Member_1() THEN '2.Отвественный сотрудник коммерческого отдела'
                   WHEN zc_MovementLinkObject_Member_2() THEN '3.Отвественный сотрудник экономического отдела:' 
                   WHEN zc_MovementLinkObject_Member_3() THEN '4.Региональнай менеджер / Директор филиала:'     
                   WHEN zc_MovementLinkObject_Member_4() THEN '5.Руководитель отдела продаж:'                   
                   WHEN zc_MovementLinkObject_Member_5() THEN '6.Отвественный сотрудник отдела маркетинга:'     
                   WHEN zc_MovementLinkObject_Member_6() THEN '7.Коммерческий директор:'                        
              END :: TVarChar AS ItemName
       FROM Movement
            INNER JOIN Movement AS Movement_PromoTradeSign
                                ON Movement_PromoTradeSign.ParentId = Movement.Id
                               AND Movement_PromoTradeSign.DescId   = zc_Movement_PromoTradeSign()
            LEFT JOIN MovementLinkObject AS MLO 
                                         ON MLO.MovementId = Movement_PromoTradeSign.Id
                                        AND MLO.DescId     IN (zc_MovementLinkObject_Member_1()
                                                             , zc_MovementLinkObject_Member_2()
                                                             , zc_MovementLinkObject_Member_3()
                                                             , zc_MovementLinkObject_Member_4()
                                                             , zc_MovementLinkObject_Member_5()
                                                             , zc_MovementLinkObject_Member_6()
                                                              )
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MLO.ObjectId
            LEFT JOIN ObjectLink AS ObjectLink_User_Member
                                 ON ObjectLink_User_Member.ChildObjectId = MLO.ObjectId
                                AND ObjectLink_User_Member.DescId        = zc_ObjectLink_User_Member()
            LEFT JOIN Object AS Object_User ON Object_User.Id = ObjectLink_User_Member.ChildObjectId
            
       WHERE Movement.Id = inMovementId
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.09.24                                        * 

*/

-- тест
-- SELECT * FROM lpSelect_Movement_PromoTradeSign (inMovementId:= 29309489)
