-- Function: gpReport_OrderExternal_WeighingPartner()

DROP FUNCTION IF EXISTS gpReport_OrderExternal_WeighingPartner (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_OrderExternal_WeighingPartner (Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpReport_OrderExternal_WeighingPartner (Integer, TVarChar, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_OrderExternal_WeighingPartner(
    IN inMovementId        Integer   , -- ключ Документа
    IN inMovementDesc      TVarChar  ,
    IN inGoodsId           Integer   ,
    IN inGoodsKindId       Integer   ,
    IN inWeighingNumber    TFloat    , 
    IN inSession           TVarChar       -- сессия пользователя
)
RETURNS TABLE (MovementId  Integer
             , OperDate                 TDateTime
             , InvNumber                TVarChar
             , StatusCode               Integer
             , MovementId_Parent        Integer 
             , OperDate_Parent          TDateTime
             , InvNumber_Parent         TVarChar
             , MovementDescName_Parent  TVarChar
             
             , WeighingNumber           TFloat--номер взвеш = номер поддона 
             , StartWeighing            TDateTime
             , EndWeighing              TDateTime
             , UserName                 TVarChar
              
             , GoodsId       Integer
             , GoodsCode     Integer
             , GoodsName     TVarChar
             , GoodsName_choice TVarChar
             , CodeSticker   TVarChar
             , GoodsKindId   Integer
             , GoodsKindName TVarChar 
             , GoodsGroupNameFull TVarChar
             , MeasureName   TVarChar
             , InsertDate_mi TDateTime
             , Amount               TFloat
             , Amount_sh            TFloat 
             , Amount_Weight        TFloat
             , AmountPartner        TFloat
             , AmountPartner_sh     TFloat
             , AmountPartner_Weight TFloat
             , Amount_order         TFloat
             , Amount_order_sh      TFloat
             , Amount_order_Weight  TFloat

              )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbGoodsPropertyId Integer;
    DECLARE vbGoodsPropertyId_basis Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_MI_OrderExternal());
     vbUserId:= lpGetUserBySession (inSession);

     -- параметры из документа
     SELECT CASE WHEN COALESCE (MovementLinkObject_GoodsProperty.ObjectId,0) <> 0 THEN MovementLinkObject_GoodsProperty.ObjectId
                 ELSE zfCalc_GoodsPropertyId (MovementLinkObject_Contract.ObjectId
                                            , COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementLinkObject_From.ObjectId)
                                            , COALESCE (MovementLinkObject_Partner.ObjectId, MovementLinkObject_From.ObjectId)
                                             )
            END AS GoodsPropertyId
          , zfCalc_GoodsPropertyId (0, zc_Juridical_Basis(), 0)      AS GoodsPropertyId_basis
         
            INTO vbGoodsPropertyId, vbGoodsPropertyId_basis
     FROM Movement
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                       ON MovementLinkObject_Contract.MovementId = Movement.Id
                                      AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId
          LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                       ON MovementLinkObject_Partner.MovementId = Movement.Id
                                      AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                      AND Object_From.DescId = zc_Object_Unit()
          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                               ON ObjectLink_Partner_Juridical.ObjectId = COALESCE (MovementLinkObject_Partner.ObjectId, MovementLinkObject_From.ObjectId)
                              AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_GoodsProperty
                                       ON MovementLinkObject_GoodsProperty.MovementId = Movement.Id
                                      AND MovementLinkObject_GoodsProperty.DescId = zc_MovementLinkObject_GoodsProperty()

     WHERE Movement.Id = inMovementId;


    -- Результат 
     RETURN QUERY
      WITH 
      tmpMovement_wp AS (SELECT Movement.* 
                         FROM MovementLinkMovement AS MovementLinkMovement_Order
                              INNER JOIN Movement ON Movement.Id = MovementLinkMovement_Order.MovementId 
                                                 AND Movement.DescId = zc_Movement_WeighingPartner()
                                                 AND Movement.StatusId <> zc_Enum_Status_Erased()
                              LEFT JOIN Movement AS Movement_parent
                                                 ON Movement_parent.Id = Movement.ParentId
                              -- Тип документа
                              INNER JOIN MovementFloat AS MovementFloat_MovementDesc
                                                       ON MovementFloat_MovementDesc.MovementId = Movement.Id
                                                      AND MovementFloat_MovementDesc.DescId     = zc_MovementFloat_MovementDesc()
                                                      AND MovementFloat_MovementDesc.ValueData  = zc_Movement_Send() :: TFloat
                         WHERE MovementLinkMovement_Order.MovementChildId = inMovementId --35131290
                           AND MovementLinkMovement_Order.DescId = zc_MovementLinkMovement_Order()
                           AND COALESCE (Movement_parent.StatusId, 0) <> zc_Enum_Status_Erased()
                        )
      --№ взвешивания, дата/время завершения, № главного док, дата главного док + вид главного док, № поддона(zc_MovementFloat_WeighingNumber)
    , tmpMovementFloat_wp AS (SELECT *
                              FROM MovementFloat
                              WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement_wp.Id FROM tmpMovement_wp)
                                AND MovementFloat.DescId IN (zc_MovementFloat_WeighingNumber())
                              )

    , tmpMovementDate_wp AS (SELECT *
                             FROM MovementDate
                             WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMovement_wp.Id FROM tmpMovement_wp)
                               AND MovementDate.DescId IN (zc_MovementDate_EndWeighing()
                                                         , zc_MovementDate_StartWeighing()
                                                          )
                             )

    , tmpLO_wp AS (SELECT *
                   FROM MovementLinkObject
                   WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMovement_wp.Id FROM tmpMovement_wp)
                     AND MovementLinkObject.DescId IN (zc_MovementLinkObject_User()
                                                )
                   )

    -- данный из док. взвешивания
    ,  tmpMI_wp AS (SELECT MovementItem.MovementId
                         , MovementItem.ObjectId                           AS GoodsId
                         , COALESCE (MILO_GoodsKind.ObjectId, 0)           AS GoodsKindId
                         , SUM (COALESCE (MovementItem.Amount,0))          AS Amount
                         , SUM (COALESCE (MIF_AmountPartner.ValueData, 0)) AS AmountPartner
                         , MAX (COALESCE (MIDate_Insert.ValueData, zc_DateStart()))  AS InsertDate
                    FROM tmpMovement_wp AS Movement
                         INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                AND MovementItem.DescId     = zc_MI_Master()
                                                AND MovementItem.isErased   = FALSE
                                                --огр. по товару и виду для печати
                                                AND (MovementItem.ObjectId = inGoodsId OR inGoodsId = 0)
                         LEFT JOIN MovementItemFloat AS MIF_AmountPartner
                                                     ON MIF_AmountPartner.MovementItemId = MovementItem.Id
                                                    AND MIF_AmountPartner.DescId         = zc_MIFloat_AmountPartner()
                         LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                          ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                         AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind() 
                         LEFT JOIN MovementItemDate AS MIDate_Insert
                                                    ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                   AND MIDate_Insert.DescId = zc_MIDate_Insert()
 
                    WHERE (COALESCE (MILO_GoodsKind.ObjectId, 0) = inGoodsKindId OR inGoodsKindId = 0)
                    GROUP BY MovementItem.MovementId
                           , MovementItem.ObjectId
                           , COALESCE (MILO_GoodsKind.ObjectId, 0)
                   )

    -- данный из док. заявка
    ,  tmpMI_order AS (SELECT MovementItem.ObjectId                  AS GoodsId
                            , COALESCE (MILO_GoodsKind.ObjectId, 0)  AS GoodsKindId
                            , SUM (COALESCE (MovementItem.Amount,0) + COALESCE (MIF_AmountSecond.ValueData, 0)) AS Amount
                       FROM MovementItem
                            LEFT JOIN MovementItemFloat AS MIF_AmountSecond
                                                        ON MIF_AmountSecond.MovementItemId = MovementItem.Id
                                                       AND MIF_AmountSecond.DescId         = zc_MIFloat_AmountSecond()
                            LEFT JOIN MovementItemLinkObject AS MILO_GoodsKind
                                                             ON MILO_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILO_GoodsKind.DescId         = zc_MILinkObject_GoodsKind() 
                       WHERE MovementItem.MovementId = inMovementId
                         AND MovementItem.DescId     = zc_MI_Master()
                         AND MovementItem.isErased   = FALSE
                         --огр. по товару и виду для печати
                         AND (MovementItem.ObjectId = inGoodsId OR inGoodsId = 0)
                         AND (COALESCE (MILO_GoodsKind.ObjectId, 0) = inGoodsKindId OR inGoodsKindId = 0)
                       GROUP BY MovementItem.ObjectId
                              , COALESCE (MILO_GoodsKind.ObjectId, 0)
                      )

    , tmpWeighingPartner AS (SELECT Movement.Id
                                  , Movement.OperDate
                                  , Movement.InvNumber
                                  , Object_Status.ObjectCode     AS StatusCode
                                  , Movement_Parent.Id           AS MovementId_Parent
                                  , Movement_Parent.OperDate     AS OperDate_Parent
                                  , Movement_Parent.InvNumber    AS InvNumber_Parent
                                  , MovementDesc_Parent.ItemName AS MovementDescName_Parent
                                  
                                  , MovementFloat_WeighingNumber.ValueData AS WeighingNumber --номер взвеш = номер поддона
                                  , MovementDate_StartWeighing.ValueData   AS StartWeighing
                                  , MovementDate_EndWeighing.ValueData     AS EndWeighing
                                  , Object_User.ValueData                  AS UserName 
                                   
                                  , MovementItem.GoodsId
                                  , MovementItem.GoodsKindId
                                  , MovementItem.Amount
                                  , MovementItem.AmountPartner
                                  , MovementItem.InsertDate AS InsertDate_mi
                                  --
                                  , ROW_NUMBER () OVER (PARTITION BY MovementItem.GoodsId, MovementItem.GoodsKindId ORDER BY MovementFloat_WeighingNumber.ValueData, MovementDate_EndWeighing.ValueData) AS Ord
                             FROM tmpMovement_wp AS Movement
                               LEFT JOIN Movement AS Movement_Parent ON Movement_Parent.Id = Movement.ParentId  --главный док 
                               LEFT JOIN MovementDesc AS MovementDesc_Parent ON MovementDesc_Parent.Id = Movement_Parent.DescId
                               LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

                               LEFT JOIN tmpMovementFloat_wp AS MovementFloat_WeighingNumber
                                                             ON MovementFloat_WeighingNumber.MovementId = Movement.Id
                                                            AND MovementFloat_WeighingNumber.DescId = zc_MovementFloat_WeighingNumber() 

                               LEFT JOIN tmpMovementDate_wp AS MovementDate_StartWeighing
                                                            ON MovementDate_StartWeighing.MovementId = Movement.Id
                                                           AND MovementDate_StartWeighing.DescId = zc_MovementDate_StartWeighing()

                               LEFT JOIN tmpMovementDate_wp AS MovementDate_EndWeighing
                                                            ON MovementDate_EndWeighing.MovementId = Movement.Id
                                                           AND MovementDate_EndWeighing.DescId = zc_MovementDate_EndWeighing() 
                                  
                               LEFT JOIN tmpLO_wp AS MovementLinkObject_User
                                                  ON MovementLinkObject_User.MovementId = Movement.Id
                                                 AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
                               LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId

                               INNER JOIN tmpMI_wp AS MovementItem ON MovementItem.MovementId = Movement.Id
                             WHERE MovementFloat_WeighingNumber.ValueData = inWeighingNumber OR inWeighingNumber = 0
                             )


    , tmpObject_GoodsPropertyValue AS (SELECT ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                            , ObjectLink_GoodsPropertyValue_Goods.ChildObjectId                    AS GoodsId
                                            , COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId, 0)  AS GoodsKindId
                                            , ObjectString_CodeSticker.ValueData                                   AS CodeSticker
                                       FROM (SELECT vbGoodsPropertyId AS GoodsPropertyId WHERE vbGoodsPropertyId <> 0
                                            ) AS tmpGoodsProperty
                                            INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                                  ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId = tmpGoodsProperty.GoodsPropertyId
                                                                 AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()
                                            LEFT JOIN Object AS Object_GoodsPropertyValue ON Object_GoodsPropertyValue.Id = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                            LEFT JOIN ObjectString AS ObjectString_CodeSticker
                                                                   ON ObjectString_CodeSticker.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                  AND ObjectString_CodeSticker.DescId = zc_ObjectString_GoodsPropertyValue_CodeSticker()

                                            LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                                 ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                            LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                                 ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()

                                            LEFT JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsBox
                                                                 ON ObjectLink_GoodsPropertyValue_GoodsBox.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                                AND ObjectLink_GoodsPropertyValue_GoodsBox.DescId   = zc_ObjectLink_GoodsPropertyValue_GoodsBox()
                                            LEFT JOIN ObjectString AS ObjectString_Goods_ShortName
                                                                   ON ObjectString_Goods_ShortName.ObjectId = ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId
                                                                  AND ObjectString_Goods_ShortName.DescId   = zc_ObjectString_Goods_ShortName()

                                       WHERE ObjectString_CodeSticker.ValueData     <> ''
                                      )

       -- Результат
       SELECT tmpWeighingPartner.Id                       ::Integer AS MovementId
            , tmpWeighingPartner.OperDate                 ::TDateTime
            , tmpWeighingPartner.InvNumber                ::TVarChar
            , tmpWeighingPartner.StatusCode               ::Integer
            , tmpWeighingPartner.MovementId_Parent        ::Integer 
            , tmpWeighingPartner.OperDate_Parent          ::TDateTime
            , tmpWeighingPartner.InvNumber_Parent         ::TVarChar
            , tmpWeighingPartner.MovementDescName_Parent  ::TVarChar
            
            , tmpWeighingPartner.WeighingNumber           ::TFloat--номер взвеш = номер поддона
            , tmpWeighingPartner.StartWeighing            ::TDateTime 
            , tmpWeighingPartner.EndWeighing              ::TDateTime
            , tmpWeighingPartner.UserName                 ::TVarChar
             
            , Object_Goods.Id            ::Integer  AS GoodsId        
            , Object_Goods.ObjectCode    ::Integer  AS GoodsCode
            , Object_Goods.ValueData     ::TVarChar AS GoodsName
            , (Object_Goods.ObjectCode::TVarChar ||' '||Object_Goods.ValueData) ::TVarChar AS GoodsName_choice
            , COALESCE (tmpObject_GoodsPropertyValue.CodeSticker, '') :: TVarChar  AS CodeSticker
            , Object_GoodsKind.Id        ::Integer  AS GoodsKindId
            , Object_GoodsKind.ValueData ::TVarChar AS GoodsKindName
            , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
            , Object_Measure.ValueData   ::TVarChar AS MeasureName
            , tmpWeighingPartner.InsertDate_mi ::TDateTime

            , tmpWeighingPartner.Amount                                                                                                ::TFloat AS Amount
            , (tmpWeighingPartner.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN 1 ELSE 0 END)                            ::TFloat AS Amount_Sh  
            , (tmpWeighingPartner.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS Amount_Weight   

            , tmpWeighingPartner.AmountPartner                                                                                                ::TFloat AS AmountPartner
            , (tmpWeighingPartner.AmountPartner * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN 1 ELSE 0 END)                            ::TFloat AS AmountPartner_sh
            , (tmpWeighingPartner.AmountPartner * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS AmountPartner_Weight
            
            , tmpMI_order.Amount                                                                                                ::TFloat AS Amount_order
            , (tmpMI_order.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN 1 ELSE 0 END)                            ::TFloat AS Amount_order_Sh 
            , (tmpMI_order.Amount * CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) ::TFloat AS Amount_order_Weight

       FROM tmpWeighingPartner
            LEFT JOIN tmpMI_order ON tmpMI_order.GoodsId = tmpWeighingPartner.GoodsId
                                 AND COALESCE (tmpMI_order.GoodsKindId,0) = COALESCE (tmpWeighingPartner.GoodsKindId,0)
                                 AND tmpWeighingPartner.Ord = 1

            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpWeighingPartner.GoodsId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpWeighingPartner.GoodsKindId

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            LEFT JOIN ObjectFloat AS ObjectFloat_Weight
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()

            LEFT JOIN tmpObject_GoodsPropertyValue ON tmpObject_GoodsPropertyValue.GoodsId = tmpWeighingPartner.GoodsId
                                                  AND tmpObject_GoodsPropertyValue.GoodsKindId = tmpWeighingPartner.GoodsKindId
       ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.08.26         *
*/

-- тест
--select * from gpReport_OrderExternal_WeighingPartner(inMovementId := 35125275 ,  inSession := '9457');
-- SELECT * FROM gpReport_OrderExternal_WeighingPartner (inMovementId:= 35125275 , inMovementDesc:= 'zc_Movement_Send', inGoodsId:=623864, inGoodsKindId:=0, inWeighingNumber:=0  , inSession:= zfCalc_UserAdmin())      -- номер док  1877714   заяаки от 26,08
