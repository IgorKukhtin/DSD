-- Function: gpSelect_Movement_WeighingPartner_Item()

DROP FUNCTION IF EXISTS gpSelect_Movement_WeighingPartner_Item22 (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_WeighingPartner_Item22(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inGoodsGroupId       Integer   ,
    IN inGoodsId            Integer   ,
    IN inJuridicalBasisId   Integer ,
    IN inIsErased           Boolean ,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber Integer, OperDate TDateTime
           /*, StatusCode Integer, StatusName TVarChar
             , MovementId_parent Integer, OperDate_parent TDateTime, InvNumber_parent TVarChar
             , MovementId_TransportGoods Integer, InvNumber_TransportGoods TVarChar, OperDate_TransportGoods TDateTime
             , MovementId_Tax Integer, InvNumberPartner_Tax TVarChar, OperDate_Tax TDateTime
             , StartWeighing TDateTime, EndWeighing TDateTime 
             , MovementDescNumber Integer, MovementDescName TVarChar
             , WeighingNumber TFloat
             , InvNumberOrder TVarChar
             , MovementId_Transport Integer, InvNumber_Transport TVarChar, OperDate_Transport TDateTime
             , CarName TVarChar, CarModelName TVarChar, PersonalDriverName TVarChar
             , PriceWithVAT Boolean
             , VATPercent TFloat, ChangePercent TFloat
             , TotalCount TFloat, TotalCountPartner TFloat, TotalCountTare TFloat
             , TotalSummVAT TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , FromName TVarChar, ToName TVarChar
             , PaidKindName TVarChar
             , ContractName TVarChar, ContractTagName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , RouteSortingName TVarChar, RouteGroupName TVarChar, RouteName TVarChar
             , PersonalCode1 Integer, PersonalName1 TVarChar
             , PersonalCode2 Integer, PersonalName2 TVarChar
             , PersonalCode3 Integer, PersonalName3 TVarChar
             , PersonalCode4 Integer, PersonalName4 TVarChar
             , PositionCode1 Integer, PositionName1 TVarChar
             , PositionCode2 Integer, PositionName2 TVarChar
             , PositionCode3 Integer, PositionName3 TVarChar
             , PositionCode4 Integer, PositionName4 TVarChar
             , UserName TVarChar

             , GoodsCode Integer, GoodsName TVarChar, GoodsGroupNameFull TVarChar
             , MIAmount TFloat,  AmountPartner TFloat
             , RealWeight TFloat,CountTare TFloat, WeightTare TFloat
             , HeadCount TFloat, BoxCount TFloat, BoxNumber TFloat
             , LevelNumber TFloat, ChangePercentAmount TFloat, ChangePercent_mi TFloat
             , Price TFloat, CountForPrice TFloat
             , PartionGoodsDate  TDateTime
             , InsertDate TDateTime, UpdateDate TDateTime
             , GoodsKindName TVarChar
             , MeasureName TVarChar, BoxName TVarChar
             , PriceListName TVarChar
             , isBarCode Boolean
            -- , MovementPromo TVarChar
             , isErased Boolean
*/
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_WeighingPartner());
     vbUserId:= lpGetUserBySession (inSession);

     CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
     INSERT INTO _tmpGoods (GoodsId)
              SELECT lfSelect.GoodsId FROM  lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
              WHERE inGoodsGroupId <> 0 AND COALESCE (inGoodsId, 0) = 0
             UNION
              SELECT inGoodsId WHERE inGoodsId > 0
             UNION
              SELECT Object.Id FROM Object
              WHERE Object.DescId = zc_Object_Goods() AND (inStartDate + INTERVAL '3 DAY') >= inEndDate
                AND COALESCE (inGoodsGroupId, 0) = 0 AND COALESCE (inGoodsId, 0) = 0
             UNION
              SELECT Object.Id FROM Object
              WHERE Object.DescId = zc_Object_Goods() AND inIsErased = TRUE
                AND COALESCE (inGoodsGroupId, 0) = 0 AND COALESCE (inGoodsId, 0) = 0;

     CREATE TEMP TABLE _tmpData (Id Integer, InvNumber Integer, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , MovementId_parent Integer, OperDate_parent TDateTime, InvNumber_parent TVarChar
             , MovementId_TransportGoods Integer, InvNumber_TransportGoods TVarChar, OperDate_TransportGoods TDateTime
             , MovementId_Tax Integer, InvNumberPartner_Tax TVarChar, OperDate_Tax TDateTime
             , StartWeighing TDateTime, EndWeighing TDateTime
             , StartBegin TDateTime, EndBegin TDateTime, diffBegin_sec TFloat
             , MovementDescNumber Integer, MovementDescName TVarChar
             , WeighingNumber TFloat
             , InvNumberOrder TVarChar
             , MovementId_Transport Integer, InvNumber_Transport TVarChar, OperDate_Transport TDateTime
             , CarName TVarChar, CarModelName TVarChar, PersonalDriverName TVarChar
             , PriceWithVAT Boolean
             , VATPercent TFloat, ChangePercent TFloat
             , TotalCount TFloat, TotalCountPartner TFloat, TotalCountTare TFloat
             , TotalSummVAT TFloat, TotalSummMVAT TFloat, TotalSummPVAT TFloat, TotalSumm TFloat
             , FromName TVarChar, ToName TVarChar
             , PaidKindName TVarChar
             , ContractName TVarChar, ContractTagName TVarChar
             , InfoMoneyGroupName TVarChar, InfoMoneyDestinationName TVarChar, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , RouteSortingName TVarChar, RouteGroupName TVarChar, RouteName TVarChar
             , PersonalCode1 Integer, PersonalName1 TVarChar
             , PersonalCode2 Integer, PersonalName2 TVarChar
             , PersonalCode3 Integer, PersonalName3 TVarChar
             , PersonalCode4 Integer, PersonalName4 TVarChar
             , PositionCode1 Integer, PositionName1 TVarChar
             , PositionCode2 Integer, PositionName2 TVarChar
             , PositionCode3 Integer, PositionName3 TVarChar
             , PositionCode4 Integer, PositionName4 TVarChar
             , UserName TVarChar
             ) ON COMMIT DROP;
      INSERT INTO _tmpData 
     
       SELECT  tmp.Id
             , tmp.InvNumber
             , tmp.OperDate
             , tmp.StatusCode
             , tmp.StatusName

             , tmp.MovementId_parent
             , tmp.OperDate_parent
             , tmp.InvNumber_parent

             , tmp.MovementId_TransportGoods
             , tmp.InvNumber_TransportGoods
             , tmp.OperDate_TransportGoods

             , tmp.MovementId_Tax
             , tmp.InvNumberPartner_Tax
             , tmp.OperDate_Tax

             , tmp.StartWeighing
             , tmp.EndWeighing

             , tmp.StartBegin
             , tmp.EndBegin
             , tmp.diffBegin_sec

             , tmp.MovementDescNumber
             , tmp.MovementDescName
             , tmp.WeighingNumber

             , tmp.InvNumberOrder

             , tmp.MovementId_Transport
             , tmp.InvNumber_Transport
             , tmp.OperDate_Transport
             , tmp.CarName
             , tmp.CarModelName
             , tmp.PersonalDriverName

             , tmp.PriceWithVAT
             , tmp.VATPercent
             , tmp.ChangePercent
             , tmp.TotalCount
             , tmp.TotalCountPartner
             , tmp.TotalCountTare
             , tmp.TotalSummVAT
             , tmp.TotalSummMVAT
             , tmp.TotalSummPVAT
             , tmp.TotalSumm

             , tmp.FromName
             , tmp.ToName

             , tmp.PaidKindName
             , tmp.ContractName
             , tmp.ContractTagName

             , tmp.InfoMoneyGroupName
             , tmp.InfoMoneyDestinationName
             , tmp.InfoMoneyCode
             , tmp.InfoMoneyName

             , tmp.RouteSortingName
             , tmp.RouteGroupName
             , tmp.RouteName

             , tmp.PersonalCode1, tmp.PersonalName1
             , tmp.PersonalCode2, tmp.PersonalName2
             , tmp.PersonalCode3, tmp.PersonalName3
             , tmp.PersonalCode4, tmp.PersonalName4

             , tmp.PositionCode1, tmp.PositionName1
             , tmp.PositionCode2, tmp.PositionName2
             , tmp.PositionCode3, tmp.PositionName3
             , tmp.PositionCode4, tmp.PositionName4

             , tmp.UserName

      FROM gpSelect_Movement_WeighingPartner (inStartDate:= inStartDate, inEndDate:= inEndDate, inJuridicalBasisId:= inJuridicalBasisId, inIsErased:= inIsErased, inSession:= inSession) AS tmp
      --limit 1
           ;
      --ANALYZE _tmpData;
  CREATE INDEX idx_movement_movementid  ON _tmpData
  USING btree  (Id);
  ANALYZE _tmpData;
               
      CREATE TEMP TABLE _tmpMI (MovementId Integer
                  , GoodsCode Integer
                  , GoodsName TVarChar
                  , GoodsGroupNameFull TVarChar
                  , MIAmount TFloat
                  , AmountPartner TFloat
                  , RealWeight TFloat
                  , CountTare  TFloat
                  , WeightTare TFloat
                  , HeadCount  TFloat
                  , BoxCount   TFloat
                  , BoxNumber  TFloat
                  , LevelNumber TFloat
                  , ChangePercentAmount TFloat
                  , ChangePercent_mi    TFloat
                  , Price      TFloat
                  , CountForPrice TFloat
                  , PartionGoodsDate TDateTime
                  , InsertDate TDateTime
                  , UpdateDate TDateTime
                  , GoodsKindName TVarChar
                  , MeasureName   TVarChar
                  , BoxName       TVarChar
                  , PriceListName TVarChar
                  , isBarCode     Boolean
                  , MovementPromo TVarChar
                  , isErased Boolean) ON COMMIT DROP;
      INSERT INTO _tmpMI (MovementId 
                        , GoodsCode, GoodsName, GoodsGroupNameFull
                        , MIAmount 
                        , AmountPartner 
                        , RealWeight
                        , CountTare
                        , WeightTare
                        , HeadCount
                        , BoxCount
                        , BoxNumber
                        , LevelNumber
                        , ChangePercentAmount
                        , ChangePercent_mi
                        , Price
                        , CountForPrice
                        , PartionGoodsDate, InsertDate, UpdateDate 
                        , GoodsKindName, MeasureName, BoxName, PriceListName 
                        , isBarCode     
                       -- , MovementPromo 
                        , isErased) 
      WITH tmpMI AS (SELECT MovementItem.*
                     FROM  MovementItem
                     WHERE MovementItem.MovementId IN (SELECT DISTINCT _tmpData.Id FROM _tmpData)
                                    AND MovementItem.DescId     = zc_MI_Master()
                                    AND (MovementItem.isErased   = inIsErased
                                      OR inGoodsGroupId <> 0
                                      OR inGoodsId <> 0
                                      OR (inStartDate + INTERVAL '3 DAY') >= inEndDate
                                        ) 
                  -- and 1=0
                     )
         , tmpMI_PromoMovementId AS (SELECT MovementItemFloat.MovementItemId
                                          , MovementItemFloat.ValueData :: Integer
                                     FROM MovementItemFloat
                                     WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                       AND MovementItemFloat.DescId = zc_MIFloat_PromoMovementId()
                                     )
         , tmpMI_Float AS (SELECT MovementItemFloat.*
                           FROM MovementItemFloat
                           WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                             AND MovementItemFloat.DescId IN (zc_MIFloat_ChangePercentAmount()
                                                            , zc_MIFloat_ChangePercent()
                                                            , zc_MIFloat_AmountPartner()
                                                            , zc_MIFloat_RealWeight()
                                                            , zc_MIFloat_CountTare()
                                                            , zc_MIFloat_WeightTare()
                                                            , zc_MIFloat_HeadCount()
                                                            , zc_MIFloat_BoxCount()
                                                            , zc_MIFloat_BoxNumber()
                                                            , zc_MIFloat_LevelNumber()
                                                            , zc_MIFloat_Price()
                                                            , zc_MIFloat_CountForPrice()
                                                            )
                           )
         , tmpGoodsParam AS (SELECT _tmpGoods.*
                                  , ObjectLink_Goods_Measure.ChildObjectId      AS MeasureId
                                  , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
                             FROM _tmpGoods
                                  LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                       ON ObjectLink_Goods_Measure.ObjectId = _tmpGoods.GoodsId
                                                      AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                  LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
                      
                                  LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                                         ON ObjectString_Goods_GoodsGroupFull.ObjectId = _tmpGoods.GoodsId
                                                        AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()                             
                             )
                                             
             SELECT MovementItem.MovementId
                  , Object_Goods.ObjectCode          AS GoodsCode
                  , Object_Goods.ValueData           AS GoodsName
                  , tmpGoodsParam.GoodsGroupNameFull AS GoodsGroupNameFull

                  , MovementItem.Amount as MIAmount
                  , COALESCE (MIFloat_AmountPartner.ValueData, 0)::TFloat AS AmountPartner

                  , COALESCE (MIFloat_RealWeight.ValueData, 0)   ::TFloat       AS RealWeight
                  , COALESCE (MIFloat_CountTare.ValueData, 0) ::TFloat          AS CountTare
                  , (COALESCE (MIFloat_CountTare.ValueData, 0) * COALESCE (MIFloat_WeightTare.ValueData, 0)) ::TFloat          AS WeightTare

                  , MIFloat_HeadCount.ValueData                  AS HeadCount
                  , MIFloat_BoxCount.ValueData                   AS BoxCount
      
                  , MIFloat_BoxNumber.ValueData                  AS BoxNumber
                  , MIFloat_LevelNumber.ValueData                AS LevelNumber

                  , MIFloat_ChangePercentAmount.ValueData        AS ChangePercentAmount
                  , MIFloat_ChangePercent.ValueData              AS ChangePercent_mi
                  , MIFloat_Price.ValueData                      AS Price
                  , MIFloat_CountForPrice.ValueData              AS CountForPrice
           
                  , COALESCE (MIDate_PartionGoods.ValueData, zc_DateStart()):: TDateTime AS PartionGoodsDate

           
                  , COALESCE (MIDate_Insert.ValueData, zc_DateStart()):: TDateTime   AS InsertDate
                  , COALESCE (MIDate_Update.ValueData, zc_DateStart()):: TDateTime   AS UpdateDate
                  , Object_GoodsKind.ValueData      AS GoodsKindName
                  , Object_Measure.ValueData        AS MeasureName
                  , COALESCE (Object_Box.ValueData, '')::TVarChar              AS BoxName
                  , COALESCE (Object_PriceList.ValueData , '')::TVarChar       AS PriceListName

                  , COALESCE (MIBoolean_BarCode.ValueData, FALSE) :: Boolean AS isBarCode

                 /* , zfCalc_PromoMovementName (NULL, Movement_Promo_View.InvNumber :: TVarChar, Movement_Promo_View.OperDate, Movement_Promo_View.StartSale
                                            , CASE WHEN MovementFloat_MovementDesc.ValueData = zc_Movement_ReturnIn() 
                                                   THEN Movement_Promo_View.EndReturn 
                                                   ELSE Movement_Promo_View.EndSale
                                              END ) AS MovementPromo*/

                  , MovementItem.isErased    
             FROM tmpMI AS MovementItem
                  INNER JOIN tmpGoodsParam ON tmpGoodsParam.GoodsId = MovementItem.ObjectId
                  LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpGoodsParam.GoodsId
      
                  LEFT JOIN MovementItemDate AS MIDate_Insert
                                             ON MIDate_Insert.MovementItemId = MovementItem.Id
                                            AND MIDate_Insert.DescId = zc_MIDate_Insert()
                  LEFT JOIN MovementItemDate AS MIDate_Update
                                                   ON MIDate_Update.MovementItemId = MovementItem.Id
                                                  AND MIDate_Update.DescId = zc_MIDate_Update()

                  LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                                   ON MIDate_PartionGoods.MovementItemId = MovementItem.Id
                                                  AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

                  LEFT JOIN tmpMI_Float AS MIFloat_ChangePercentAmount
                                              ON MIFloat_ChangePercentAmount.MovementItemId = MovementItem.Id
                                             AND MIFloat_ChangePercentAmount.DescId = zc_MIFloat_ChangePercentAmount()
                  LEFT JOIN tmpMI_Float AS MIFloat_ChangePercent
                                              ON MIFloat_ChangePercent.MovementItemId = MovementItem.Id
                                             AND MIFloat_ChangePercent.DescId = zc_MIFloat_ChangePercent()

                  LEFT JOIN tmpMI_PromoMovementId AS MIFloat_PromoMovement
                                                  ON MIFloat_PromoMovement.MovementItemId = MovementItem.Id
                  LEFT JOIN Movement_Promo_View ON Movement_Promo_View.Id = MIFloat_PromoMovement.ValueData :: Integer
      
      
                  LEFT JOIN tmpMI_Float AS MIFloat_AmountPartner
                                                    ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                                   AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
             --and 1 = 0
                  LEFT JOIN tmpMI_Float AS MIFloat_RealWeight
                                                    ON MIFloat_RealWeight.MovementItemId = MovementItem.Id
                                                   AND MIFloat_RealWeight.DescId = zc_MIFloat_RealWeight()
            -- and 1 = 0
                  LEFT JOIN tmpMI_Float AS MIFloat_CountTare
                                                    ON MIFloat_CountTare.MovementItemId = MovementItem.Id
                                                   AND MIFloat_CountTare.DescId = zc_MIFloat_CountTare()
            -- and 1 = 0
                  LEFT JOIN tmpMI_Float AS MIFloat_WeightTare
                                                    ON MIFloat_WeightTare.MovementItemId = MovementItem.Id
                                                   AND MIFloat_WeightTare.DescId = zc_MIFloat_WeightTare()
      
                  LEFT JOIN tmpMI_Float AS MIFloat_HeadCount
                                                    ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                   AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
             --and 1 = 0
      
                  LEFT JOIN tmpMI_Float AS MIFloat_BoxCount
                                                    ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                                                   AND MIFloat_BoxCount.DescId = zc_MIFloat_BoxCount()
             --and 1 = 0
                  LEFT JOIN tmpMI_Float AS MIFloat_BoxNumber
                                                    ON MIFloat_BoxNumber.MovementItemId = MovementItem.Id
                                                   AND MIFloat_BoxNumber.DescId = zc_MIFloat_BoxNumber()
                  LEFT JOIN tmpMI_Float AS MIFloat_LevelNumber
                                                    ON MIFloat_LevelNumber.MovementItemId = MovementItem.Id
                                                   AND MIFloat_LevelNumber.DescId = zc_MIFloat_LevelNumber()
             --and 1 = 0
      
                  LEFT JOIN tmpMI_Float AS MIFloat_Price
                                                    ON MIFloat_Price.MovementItemId = MovementItem.Id
                                                   AND MIFloat_Price.DescId = zc_MIFloat_Price()
            -- and 1 = 0
                  LEFT JOIN tmpMI_Float AS MIFloat_CountForPrice
                                                    ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                                   AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()
                                                   AND MIFloat_Price.ValueData <> 0 -- !!!временно!!!
      
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                         ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            -- and 1 = 0
      
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Box
                                                         ON MILinkObject_Box.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_Box.DescId = zc_MILinkObject_Box()
      
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_PriceList
                                                         ON MILinkObject_PriceList.MovementItemId = MovementItem.Id
                                                        AND MILinkObject_PriceList.DescId = zc_MILinkObject_PriceList()
      
                  LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
                  LEFT JOIN Object AS Object_Box ON Object_Box.Id = MILinkObject_Box.ObjectId
                  LEFT JOIN Object AS Object_PriceList ON Object_PriceList.Id = MILinkObject_PriceList.ObjectId
                  LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = tmpGoodsParam.MeasureId
      
                  LEFT JOIN MovementItemBoolean AS MIBoolean_BarCode
                                                ON MIBoolean_BarCode.MovementItemId = MovementItem.Id
                                               AND MIBoolean_BarCode.DescId = zc_MIBoolean_BarCode()
   where  1= 0
                 ;                    

CREATE INDEX idx_movementitem_movementid  ON _tmpMI
  USING btree  (movementid);
ANALYZE _tmpMI;

     -- Результат
     RETURN QUERY 
     
       ---  результат
       SELECT  Movement.Id
             , Movement.InvNumber
             , Movement.OperDate
            /* , Movement.StatusCode
             , Movement.StatusName

             , Movement.MovementId_parent
             , Movement.OperDate_parent
             , Movement.InvNumber_parent

             , Movement.MovementId_TransportGoods
             , Movement.InvNumber_TransportGoods
             , Movement.OperDate_TransportGoods

             , Movement.MovementId_Tax
             , Movement.InvNumberPartner_Tax
             , Movement.OperDate_Tax

             , Movement.StartWeighing  
             , Movement.EndWeighing

             , Movement.MovementDescNumber
             , Movement.MovementDescName
             , Movement.WeighingNumber

             , Movement.InvNumberOrder

             , Movement.MovementId_Transport
             , Movement.InvNumber_Transport
             , Movement.OperDate_Transport
             , Movement.CarName
             , Movement.CarModelName
             , Movement.PersonalDriverName

             , Movement.PriceWithVAT
             , Movement.VATPercent
             , Movement.ChangePercent
             , Movement.TotalCount
             , Movement.TotalCountPartner
             , Movement.TotalCountTare
             , Movement.TotalSummVAT
             , Movement.TotalSummMVAT
             , Movement.TotalSummPVAT
             , Movement.TotalSumm

             , Movement.FromName
             , Movement.ToName

             , Movement.PaidKindName
             , Movement.ContractName
             , Movement.ContractTagName

             , Movement.InfoMoneyGroupName
             , Movement.InfoMoneyDestinationName
             , Movement.InfoMoneyCode
             , Movement.InfoMoneyName

             , Movement.RouteSortingName
             , Movement.RouteGroupName
             , Movement.RouteName

             , Movement.PersonalCode1, Movement.PersonalName1
             , Movement.PersonalCode2, Movement.PersonalName2
             , Movement.PersonalCode3, Movement.PersonalName3
             , Movement.PersonalCode4, Movement.PersonalName4

             , Movement.PositionCode1, Movement.PositionName1
             , Movement.PositionCode2, Movement.PositionName2
             , Movement.PositionCode3, Movement.PositionName3
             , Movement.PositionCode4, Movement.PositionName4

             , Movement.UserName

             , MovementItem.GoodsCode
             , MovementItem.GoodsName
             , MovementItem.GoodsGroupNameFull
             , MovementItem.MIAmount 
             , MovementItem.AmountPartner 
             , MovementItem.RealWeight
             , MovementItem.CountTare
             , MovementItem.WeightTare
             , MovementItem.HeadCount
             , MovementItem.BoxCount
             , MovementItem.BoxNumber
             , MovementItem.LevelNumber
             , MovementItem.ChangePercentAmount
             , MovementItem.ChangePercent_mi
             , MovementItem.Price
             , MovementItem.CountForPrice
             , MovementItem.PartionGoodsDate
             , MovementItem.InsertDate
             , MovementItem.UpdateDate 
             , MovementItem.GoodsKindName
             , MovementItem.MeasureName
             , MovementItem.BoxName
             , MovementItem.PriceListName 
             , MovementItem.isBarCode
             --, MovementItem.MovementPromo 
             , MovementItem.isErased
*/
       FROM _tmpData AS Movement
            --- строки
         --   INNER JOIN _tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Movement_WeighingPartner_Item (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
*/

-- тест
-- SELECT * FROM gpSelect_Movement_WeighingPartner_Item (inStartDate:= '01.08.2016', inEndDate:= '01.08.2016', inGoodsGroupId:= 0, inGoodsId:= 0, inJuridicalBasisId:= zc_Juridical_Basis(), inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
-- select * from gpSelect_Movement_WeighingPartner_Item22(inStartDate := ('16.11.2020')::TDateTime , inEndDate := ('16.11.2020')::TDateTime , inGoodsGroupId := 0 , inGoodsId := 0 , inJuridicalBasisId := 9399 , inIsErased := 'False' ,  inSession := '5');
