-- Function: gpSelect_MovementItem_LossDebt (Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_MovementItem_LossDebt (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_LossDebt(
    IN inMovementId  Integer      , -- ключ Документа
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , JuridicalId Integer, JuridicalName TVarChar, OKPO TVarChar, JuridicalGroupName TVarChar
             , AmountDebet TFloat, AmountKredit TFloat
             , SummDebet TFloat, SummKredit TFloat
             , isCalculated Boolean
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_LossDebt());
     vbUserId:= inSession;

     -- Результат
     RETURN QUERY 

       SELECT 
              MovementItem.Id
            , MovementItem.JuridicalId
            , MovementItem.JuridicalName
            , MovementItem.OKPO
            , MovementItem.JuridicalGroupName
            , MovementItem.AmountDebet
            , MovementItem.AmountKredit
            , MovementItem.SummDebet
            , MovementItem.SummKredit
            , MovementItem.isCalculated
            , MovementItem.isErased
                  
       FROM  MovementItem_LossDebt_View AS MovementItem 
       WHERE MovementItem.MovementId = inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_LossDebt (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 30.01.15                         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_LossDebt (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItem_LossDebt (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
