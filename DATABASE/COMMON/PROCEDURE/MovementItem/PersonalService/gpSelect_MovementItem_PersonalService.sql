-- Function: gpSelect_MovementItem_PersonalService()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PersonalService (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PersonalService(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, PersonalId Integer, PersonalName TVarChar, INN TVarChar
             , Amount TFloat, Summ TFloat
             , Comment TVarChar
             , InfoMoneyId Integer, InfoMoneyName  TVarChar
             , UnitId Integer, UnitName TVarChar
             , PositionId Integer, PositionName TVarChar
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbInfoMoneyId Integer;
   DECLARE vbInfoMoneyName TVarChar;
   DECLARE vbInfoMoneyName_all TVarChar;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_PersonalService());
     vbUserId := inSession;

   -- определяется Дефолт
   SELECT View_InfoMoney.InfoMoneyId, View_InfoMoney.InfoMoneyName, View_InfoMoney.InfoMoneyName_all
          INTO vbInfoMoneyId, vbInfoMoneyName, vbInfoMoneyName_all
   FROM Object_InfoMoney_View AS View_InfoMoney
   WHERE View_InfoMoney.InfoMoneyId = zc_Enum_InfoMoney_60101(); -- 60101 Заработная плата + Заработная плата

   
     IF inShowAll THEN

     RETURN QUERY
     SELECT 
             PersonalData.Id
           
           , Object_Personal.Id                  AS PersonalId
           , Object_Personal.ValueData           AS PersonalName
           , ObjectString_Member_INN.ValueData   AS INN
           , PersonalData.Amount
           , PersonalData.Summ
           , PersonalData.Comment
          
           , COALESCE (Object_InfoMoney_View.InfoMoneyId, vbInfoMoneyId) AS InfoMoneyId      
           , COALESCE (Object_InfoMoney_View.InfoMoneyName_all, vbInfoMoneyName_all) AS InfoMoneyName
          
           , Object_Unit.Id                       AS UnitId
           , Object_Unit.ValueData                AS UnitName
           , Object_Position.Id                   AS PositionId
           , Object_Position.ValueData            AS PositionName
           , Object_Personal.isErased
         
     FROM 
        (SELECT
             Personal_Movement.Id
           , Personal_Movement.Amount 
           , Personal_Movement.Summ 
           , Personal_Movement.Comment
           , Personal_Movement.InfoMoneyId
         
           , COALESCE(Personal_Movement.PersonalId, Object_Personal_View.PersonalId) AS PersonalId     
           , COALESCE(Personal_Movement.PositionId, Object_Personal_View.PositionId) AS PositionId
           , COALESCE(Personal_Movement.UnitId, Object_Personal_View.UnitId)         AS UnitId
           , Personal_Movement.isErased
           
          FROM (
 
             SELECT
             Movement.Id
           , MovementItem.Amount 
           , MIFloat_Summ.ValueData AS Summ
           , MovementItem.ObjectId           AS PersonalId
 
           , MILinkObject_Position.ObjectId  AS PositionId
           , MILinkObject_InfoMoney.ObjectId AS InfoMoneyId
           , MILinkObject_Unit.ObjectId      AS UnitId 

           , MIString_Comment.ValueData      AS Comment
           , MovementItem.isErased
       FROM Movement
            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                         ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                        AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                        ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                       AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                             ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Position.DescId = zc_MILinkObject_Position()

            LEFT JOIN MovementItemString AS MIString_Comment 
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
                                        
            LEFT JOIN MovementItemFloat AS MIFloat_Summ 
                                        ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                       AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                                        
       WHERE Movement.Id = inMovementId
         --AND Movement.OperDate BETWEEN inStartDate AND inEndDate
        -- AND (MILinkObject_Unit.ObjectId = inUnitId OR COALESCE (inUnitId, 0) = 0)
          ) AS Personal_Movement 
           FULL JOIN 
            (SELECT * FROM Object_Personal_View
            --  WHERE (Object_Personal_View.UnitId = inUnitId OR COALESCE (inUnitId, 0) = 0)
         ) AS Object_Personal_View

       ON Object_Personal_View.Personalid = Personal_Movement.PersonalId
                              AND Object_Personal_View.UnitId = Personal_Movement.UnitId 
                              AND Object_Personal_View.PositionId = Personal_Movement.PositionId ) AS PersonalData

             LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = PersonalData.PersonalId
            
             LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = PersonalData.InfoMoneyId
             LEFT JOIN Object AS Object_Position ON Object_Position.Id = PersonalData.PositionId
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = PersonalData.UnitId
             
             LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                  ON ObjectLink_Personal_Member.ObjectId = Object_Personal.Id  
                                 AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()

             LEFT JOIN ObjectString AS ObjectString_Member_INN
                                    ON ObjectString_Member_INN.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                   AND ObjectString_Member_INN.DescId = zc_ObjectString_Member_INN()

            ;

     ELSE

 RETURN QUERY
         SELECT
             Movement.Id
  
           , MovementItem.ObjectId               AS PersonalId
           , Object_Personal.ValueData           AS PersonalName
           , ObjectString_Member_INN.ValueData   AS INN
           , MovementItem.Amount 
           , MIFloat_Summ.ValueData              AS Summ
           , MIString_Comment.ValueData          AS Comment

          , COALESCE (Object_InfoMoney_View.InfoMoneyId, vbInfoMoneyId)             AS InfoMoneyId      
          , COALESCE (Object_InfoMoney_View.InfoMoneyName_all, vbInfoMoneyName_all) AS InfoMoneyName
           --, MILinkObject_InfoMoney.ObjectId AS InfoMoneyId
           
           , MILinkObject_Unit.ObjectId          AS UnitId 
           , Object_Unit.ValueData               AS UnitName

           , MILinkObject_Position.ObjectId      AS PositionId
           , Object_Position.ValueData           AS PositionName
          
           , MovementItem.isErased

       FROM Movement
            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
            
            LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = MovementItem.ObjectId   

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                         ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                        AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MILinkObject_InfoMoney.ObjectId 

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                        ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                       AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId 

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                             ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = MILinkObject_Position.ObjectId
 
            LEFT JOIN MovementItemString AS MIString_Comment 
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
                                        
            LEFT JOIN MovementItemFloat AS MIFloat_Summ 
                                        ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                       AND MIFloat_Summ.DescId = zc_MIFloat_Summ()
                                       
             LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                  ON ObjectLink_Personal_Member.ObjectId = Object_Personal.Id  
                                 AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()

             LEFT JOIN ObjectString AS ObjectString_Member_INN
                                    ON ObjectString_Member_INN.ObjectId = ObjectLink_Personal_Member.ChildObjectId
                                   AND ObjectString_Member_INN.DescId = zc_ObjectString_Member_INN()
       WHERE Movement.Id = inMovementId


            ;

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_PersonalService (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 11.09.14         *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_PersonalService (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= FALSE, inSession:= '9818')
-- SELECT * FROM gpSelect_MovementItem_PersonalService (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
