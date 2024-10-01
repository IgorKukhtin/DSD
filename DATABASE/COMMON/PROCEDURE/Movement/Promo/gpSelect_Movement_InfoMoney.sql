-- Function: gpSelect_Movement_InfoMoney()

DROP FUNCTION IF EXISTS gpSelect_Movement_InfoMoney (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_InfoMoney(
    IN inMovementId    Integer , -- Ключ документа <Акция>
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id                           Integer     --Идентификатор
             , ParentId                     Integer
             , InfoMoneyId_CostPromo        Integer     --
             , InfoMoneyCode_CostPromo      Integer     --
             , InfoMoneyName_CostPromo      TVarChar    --
             , InfoMoneyId_Market           Integer     --
             , InfoMoneyCode_Market         Integer     --
             , InfoMoneyName_Market         TVarChar    --
             , isErased                     Boolean     --Удален
      )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    RETURN QUERY
 SELECT       
        Movement.Id                                                 --Идентификатор
      , Movement.ParentId
      , Object_InfoMoney_CostPromo.Id          AS InfoMoneyId_CostPromo       
      , Object_InfoMoney_CostPromo.ObjectCode  AS InfoMoneyCode_CostPromo     
      , Object_InfoMoney_CostPromo.ValueData   AS InfoMoneyName_CostPromo     
      , Object_InfoMoney_Market.Id             AS InfoMoneyId_Market       
      , Object_InfoMoney_Market.ObjectCode     AS InfoMoneyCode_Market     
      , Object_InfoMoney_Market.ValueData      AS InfoMoneyName_Market
      , CASE  
            WHEN Movement.StatusId = zc_Enum_Status_Erased()
                THEN TRUE
        ELSE FALSE
        END                                    AS isErased                --Удален
    FROM Movement AS Movement 
        LEFT JOIN MovementLinkObject AS MLO_InfoMoney_CostPromo
                                     ON MLO_InfoMoney_CostPromo.MovementId = Movement.Id
                                    AND MLO_InfoMoney_CostPromo.DescId = zc_MovementLinkObject_InfoMoney_CostPromo()
        LEFT JOIN Object AS Object_InfoMoney_CostPromo ON Object_InfoMoney_CostPromo.Id = MLO_InfoMoney_CostPromo.ObjectId

        LEFT JOIN MovementLinkObject AS MLO_InfoMoney_Market
                                     ON MLO_InfoMoney_Market.MovementId = Movement.Id
                                    AND MLO_InfoMoney_Market.DescId = zc_MovementLinkObject_InfoMoney_Market()
        LEFT JOIN Object AS Object_InfoMoney_Market ON Object_InfoMoney_Market.Id = MLO_InfoMoney_Market.ObjectId
        
    WHERE Movement.DescId = zc_Movement_InfoMoney()
      AND Movement.ParentId = inMovementId
      AND (Movement.StatusId <> zc_Enum_Status_Erased() OR inIsErased = TRUE)
    ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.10.24         *
*/

--select * from gpSelect_Movement_InfoMoney(inMovementId := 27960939 , inIsErased := 'False' ,  inSession := '9457');