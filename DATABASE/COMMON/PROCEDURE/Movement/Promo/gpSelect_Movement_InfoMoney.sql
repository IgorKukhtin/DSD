-- Function: gpSelect_Movement_InfoMoney()

DROP FUNCTION IF EXISTS gpSelect_Movement_InfoMoney (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_InfoMoney (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_InfoMoney(
    IN inMovementId    Integer , -- Ключ документа <Акция>
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Ord            Integer
             , Name           TVarChar    --
             , Id             Integer  
             , DescId         Integer
             , InfoMoneyId    Integer     --
             , InfoMoneyCode  Integer     --
             , InfoMoneyName  TVarChar    --
      )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
    RETURN QUERY
    WITH 
    tmpText AS (    SELECT  1 ::Integer  AS Ord, '1.Стоимость участия'  ::TVarChar AS Name
              UNION SELECT  2 ::Integer  AS Ord, '2.Сумма компенсации'  ::TVarChar AS Name
                 )

  , tmpData AS (SELECT MLO_InfoMoney_CostPromo.ObjectId   AS InfoMoneyId_CostPromo
                     , MLO_InfoMoney_Market.ObjectId      AS InfoMoneyId_Market 
                     , Movement.Id
                FROM Movement
                     LEFT JOIN MovementLinkObject AS MLO_InfoMoney_CostPromo
                                                  ON MLO_InfoMoney_CostPromo.MovementId = Movement.Id
                                                 AND MLO_InfoMoney_CostPromo.DescId = zc_MovementLinkObject_InfoMoney_CostPromo()
                     
                     LEFT JOIN MovementLinkObject AS MLO_InfoMoney_Market
                                                  ON MLO_InfoMoney_Market.MovementId = Movement.Id
                                                 AND MLO_InfoMoney_Market.DescId = zc_MovementLinkObject_InfoMoney_Market()
                     LEFT JOIN Object AS Object_InfoMoney_Market ON Object_InfoMoney_Market.Id = MLO_InfoMoney_Market.ObjectId

                WHERE Movement.DescId = zc_Movement_InfoMoney()
                  AND Movement.ParentId = inMovementId
                
                )
    --Результат
    SELECT  tmpText.Ord                 ::Integer
          , tmpText.Name                ::TVarChar
          , tmpData.Id                  ::Integer                  
          , zc_MovementLinkObject_InfoMoney_CostPromo() ::Integer AS DescId
          , Object_InfoMoney.Id         ::Integer  AS InfoMoneyId
          , Object_InfoMoney.ObjectCode ::Integer  AS InfoMoneyCode
          , Object_InfoMoney.ValueData  ::TVarChar AS InfoMoneyName
    FROM tmpText
           LEFT JOIN tmpData ON 1=1
           LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpData.InfoMoneyId_CostPromo
    WHERE tmpText.Ord = 1

 UNION
    SELECT  tmpText.Ord                 ::Integer
          , tmpText.Name                ::TVarChar
          , tmpData.Id                  ::Integer
          , zc_MovementLinkObject_InfoMoney_Market() ::Integer AS DescId
          , Object_InfoMoney.Id         ::Integer  AS InfoMoneyId
          , Object_InfoMoney.ObjectCode ::Integer  AS InfoMoneyCode
          , Object_InfoMoney.ValueData  ::TVarChar AS InfoMoneyName
    FROM tmpText
           LEFT JOIN tmpData ON 1=1
           LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = tmpData.InfoMoneyId_Market
    WHERE tmpText.Ord = 2
    ORDER BY 1;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.10.24         *
*/

--select * from gpSelect_Movement_InfoMoney(inMovementId := 27960939, inSession := '9457');