-- Function: gpSelect_MovementItem_MobileSendTop()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_MobileSendTop (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_MobileSendTop(
    IN inSession          TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, LocalId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Article TVarChar, EAN TVarChar 
             , GoodsGroupId Integer, GoodsGroupName TVarChar
             , MeasureName TVarChar, PartNumber TVarChar
             , PartionCellId Integer, PartionCellName TVarChar
             , Amount TFloat, TotalCount TFloat, AmountRemains TFloat
             , OperDate TDateTime, InvNumber TVarChar
             , FromId Integer, FromCode Integer, FromName TVarChar
             , ToId Integer, ToCode Integer, ToName TVarChar
             , OrdUser Integer, OperDate_protocol TDateTime, UserName_protocol TVarChar
             , MovementId_OrderClient Integer, InvNumber_OrderClient TVarChar
             , isErased Boolean, Error TVarChar
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
           , 0                                   AS LocalId  
           , tmpMI.GoodsId
           , tmpMI.GoodsCode
           , tmpMI.GoodsName
           , tmpMI.Article 
           , tmpMI.EAN
           , tmpMI.GoodsGroupId
           , tmpMI.GoodsGroupName
           , tmpMI.MeasureName
           , tmpMI.PartNumber
           
           , tmpMI.PartionCellId
           , tmpMI.PartionCellName

           , tmpMI.Amount
           , tmpMI.TotalCount
           , tmpMI.AmountRemains

           , tmpMI.OperDate
           , tmpMI.InvNumber
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

           , tmpMI.isErased
           , ''::TVarChar                        AS Error

       FROM gpSelect_MovementItem_MobileSend (inIsOrderBy := False, inIsAllUser := False, inIsErased := False, inLimit := 3, inFilter := '', inSession := inSession) AS tmpMI
       ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 14.04.24                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_MobileSendTop (inSession := zfCalc_UserAdmin());