-- Function: gpSelect_MovementItem_MobileProductionUnionTop()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_MobileProductionUnionTop (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_MobileProductionUnionTop(
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, MovementId Integer

             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Article TVarChar, EAN TVarChar 
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureName TVarChar

             , Amount TFloat, TotalCount TFloat, AmountRemains TFloat
             
             , OperDate TDateTime, InvNumber TVarChar, StatusCode Integer, StatusName TVarChar
             , FromId Integer, FromCode Integer, FromName TVarChar
             , ToId Integer, ToCode Integer, ToName TVarChar
             
             , OrdUser Integer, OperDate_protocol TDateTime, UserName_protocol TVarChar
             , MovementId_OrderClient Integer, InvNumber_OrderClient TVarChar
             , OperDate_OrderInternal TDateTime, InvNumber_OrderInternal TVarChar, StatusCode_OrderInternal Integer, StatusName_OrderInternal TVarChar
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId    Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);
     
     -- Результат такой
     RETURN QUERY
       SELECT
             tmpMI.Id
           , tmpMI.MovementId  
           , tmpMI.GoodsId
           , tmpMI.GoodsCode
           , tmpMI.GoodsName
           , tmpMI.Article 
           , tmpMI.EAN
           , tmpMI.GoodsGroupId
           , tmpMI.GoodsGroupName
           , tmpMI.MeasureName

           , tmpMI.Amount
           , tmpMI.TotalCount
           , tmpMI.AmountRemains
           
           , tmpMI.OperDate
           , tmpMI.InvNumber
           , tmpMI.StatusCode
           , tmpMI.StatusName
           
           , tmpMI.FromId
           , tmpMI.FromCode
           , tmpMI.FromName
           , tmpMI.ToId
           , tmpMI.ToCode
           , tmpMI.ToName

           , tmpMI.OrdUser
           , tmpMI.OperDate_protocol
           , tmpMI.UserName_protocol

           , tmpMI.MovementId_OrderClient
           , tmpMI.InvNumber_OrderClient

           , tmpMI.OperDate_OrderInternal
           , tmpMI.InvNumber_OrderInternal
           , tmpMI.StatusCode_OrderInternal
           , tmpMI.StatusName_OrderInternal

           , tmpMI.isErased

       FROM gpSelect_MovementItem_MobileProductionUnion (inIsOrderBy := False, inIsAllUser := False, inIsErased := False, inLimit := 3, inFilter := '', inSession := inSession) AS tmpMI
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.04.24                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_MobileProductionUnionTop (inSession := zfCalc_UserAdmin());