-- Function: gpReport_SaleTare_Gofro()

DROP FUNCTION IF EXISTS gpReport_SaleTare_Gofro (TDateTime, TDateTime, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpReport_SaleTare_Gofro (TDateTime, TDateTime, Integer, Integer,Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SaleTare_Gofro(
    IN inStartDate      TDateTime, -- дата начала периода
    IN inEndDate        TDateTime, -- дата окончания периода
    IN inUnitId         Integer  , -- подразделение
    IN inGoodsGroupId   Integer  , -- гофротара
    IN inisDetail       Boolean  ,
    IN inSession        TVarChar   -- сессия пользователя
)
RETURNS TABLE(OperDate TDateTime, OperDatePartner TDateTime
            , FromId Integer, FromCode Integer, FromName TVarChar
            , ToId Integer, ToCode Integer, ToName TVarChar 
            , ContractId Integer, ContractCode Integer, ContractName TVarChar 
            , InvNumberOrder TVarChar
            , isGoodsBox Boolean
            , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
            , GoodsGroupNameFull TVarChar
			, Amount TFloat, BoxCount TFloat, BoxCount_calc TFloat
			, MovementId Integer , InvNumber TVarChar
)
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- Результат
    RETURN QUERY
    --данные продаж по товарам
    WITH
      -- товары из группы Гофротара
      tmpGoods AS (SELECT lfSelect.GoodsId AS GoodsId
                   FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect
                   )
    , tmpMovement AS (SELECT Movement.*
                      FROM MovementDate AS MovementDate_OperDatePartner
                           INNER JOIN Movement
                                   ON Movement.Id = MovementDate_OperDatePartner.MovementId
                                  AND Movement.DescId = zc_Movement_Sale()
                                  AND Movement.StatusId = zc_Enum_Status_Complete()

                           INNER JOIN MovementLinkObject AS MovementLinkObject_From
                                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                                        AND MovementLinkObject_From.DescId     = zc_MovementLinkObject_From()
                                                        AND (MovementLinkObject_From.ObjectId  = inUnitId OR inUnitId = 0)
                      WHERE MovementDate_OperDatePartner.ValueData BETWEEN inStartDate AND inEndDate
                        AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                     )

   --все строки док. продаж
   , tmpMI_All AS (SELECT MovementItem.*
                   FROM MovementItem
                   WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                     AND MovementItem.DescId = zc_MI_Master()
                     AND MovementItem.isErased = FALSE
                  )

    -- zc_MILinkObject_Box.ObjectId
   , tmpMILO_Box AS (SELECT MovementItemLinkObject.*
                     FROM MovementItemLinkObject
                     WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI_All.Id FROM tmpMI_All)
                       AND MovementItemLinkObject.DescId = zc_MILinkObject_Box()
                     )
   , tmpMIF_Box AS (SELECT MovementItemFloat.*
                    FROM MovementItemFloat
                    WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI_All.Id FROM tmpMI_All)
                      AND MovementItemFloat.DescId = zc_MIFloat_BoxCount()
                    )

   , tmpMI AS (SELECT MovementItem.MovementId
                    , MovementItem.Id
                    , MovementItem.ObjectId AS GoodsId
                    , COALESCE (MovementItem.Amount,0) AS Amount
                    , 0                     AS BoxCount
               FROM tmpMI_All AS MovementItem
                    INNER JOIN tmpGoods ON tmpGoods.GoodsId = MovementItem.ObjectId
              UNION
               SELECT MovementItem.MovementId
                    , MovementItem.Id
                    --, MovementItem.ObjectId AS GoodsId
                    , MILinkObject_Box.ObjectId  AS GoodsId
                    , 0        AS Amount
                    , COALESCE (MIFloat_BoxCount.ValueData,0) AS BoxCount
               FROM tmpMI_All AS MovementItem
                    INNER JOIN tmpMIF_Box AS MIFloat_BoxCount
                                          ON MIFloat_BoxCount.MovementItemId = MovementItem.Id
                    LEFT JOIN tmpMILO_Box AS MILinkObject_Box
                                          ON MILinkObject_Box.MovementItemId = MovementItem.Id

               )
   , tmpMovementDate AS (SELECT MovementDate.*
                         FROM MovementDate
                         WHERE MovementDate.MovementId IN (SELECT DISTINCT tmpMI.MovementId FROM tmpMI)
                           AND MovementDate.DescId = zc_MovementDate_OperDatePartner()
                         )

   , tmpMovementString AS (SELECT MovementString.*
                           FROM MovementString
                           WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMI.MovementId FROM tmpMI)
                             AND MovementString.DescId = zc_MovementString_InvNumberOrder()
                           )

   , tmpMovementLinkObject AS (SELECT MovementLinkObject.*
                               FROM MovementLinkObject
                               WHERE MovementLinkObject.MovementId IN (SELECT DISTINCT tmpMI.MovementId FROM tmpMI)
                                 AND MovementLinkObject.DescId IN (zc_MovementLinkObject_To()
                                                                 , zc_MovementLinkObject_From()
                                                                 , zc_MovementLinkObject_GoodsProperty()
                                                                 , zc_MovementLinkObject_Contract()
                                                                 )
                               )

   , tmpMLO_GoodsKind AS (SELECT MovementItemLinkObject.*
                         FROM MovementItemLinkObject
                         WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                           AND MovementItemLinkObject.DescId = zc_MILinkObject_GoodsKind()
                         )


   , tmpGoodsPropertyValue AS (SELECT tmpMI.MovementId
                                    , tmpMI.Id
                                    , ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId AS GoodsBoxId
                               FROM tmpMI
                                     LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_GoodsProperty
                                                                     ON MovementLinkObject_GoodsProperty.MovementId = tmpMI.MovementId
                                                                    AND MovementLinkObject_GoodsProperty.DescId = zc_MovementLinkObject_GoodsProperty()

                                     LEFT JOIN tmpMLO_GoodsKind AS MILinkObject_GoodsKind
                                                                ON MILinkObject_GoodsKind.MovementItemId = tmpMI.Id

                                     INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsProperty
                                                           ON ObjectLink_GoodsPropertyValue_GoodsProperty.ChildObjectId =  MovementLinkObject_GoodsProperty.ObjectId
                                                          AND ObjectLink_GoodsPropertyValue_GoodsProperty.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsProperty()

                                     INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsBox
                                                           ON ObjectLink_GoodsPropertyValue_GoodsBox.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                          AND ObjectLink_GoodsPropertyValue_GoodsBox.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsBox()
                                                          and ObjectLink_GoodsPropertyValue_GoodsBox.ChildObjectId > 0

                                     INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_Goods
                                                           ON ObjectLink_GoodsPropertyValue_Goods.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                          AND ObjectLink_GoodsPropertyValue_Goods.DescId = zc_ObjectLink_GoodsPropertyValue_Goods()
                                                          AND tmpMI.GoodsId = ObjectLink_GoodsPropertyValue_Goods.ChildObjectId

                                     INNER JOIN ObjectLink AS ObjectLink_GoodsPropertyValue_GoodsKind
                                                           ON ObjectLink_GoodsPropertyValue_GoodsKind.ObjectId = ObjectLink_GoodsPropertyValue_GoodsProperty.ObjectId
                                                          AND ObjectLink_GoodsPropertyValue_GoodsKind.DescId = zc_ObjectLink_GoodsPropertyValue_GoodsKind()
                                                          AND COALESCE (MILinkObject_GoodsKind.ObjectId,0) = COALESCE (ObjectLink_GoodsPropertyValue_GoodsKind.ChildObjectId,0)
                               )

           --
           SELECT Movement.OperDate   ::TDateTime        AS OperDate
                , MovementDate_OperDatePartner.ValueData AS OperDatePartner
                , Object_From.Id                      AS FromId
                , Object_From.ObjectCode              AS FromCode
                , Object_From.ValueData               AS FromName
                , Object_To.Id                        AS ToId
                , Object_To.ObjectCode                AS ToCode
                , Object_To.ValueData                 AS ToName 
                , Object_Contract.Id                  AS ContractId
                , Object_Contract.ObjectCode          AS ContractCode
                , Object_Contract.ValueData           AS ContractName 
                , MovementString_InvNumberOrder.ValueData  ::TVarChar AS InvNumberOrder
                , COALESCE (ObjectBoolean_Partner_GoodsBox.ValueData, FALSE) :: Boolean AS isGoodsBox

                , Object_Goods.Id                     AS GoodsId
                , Object_Goods.ObjectCode             AS GoodsCode
                , Object_Goods.ValueData              AS GoodsName
                , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull

                , SUM (COALESCE (tmpMI.Amount,0))     :: TFloat    AS Amount
                , SUM (COALESCE (tmpMI.BoxCount,0))   :: TFloat    AS BoxCount
                , SUM (CASE WHEN COALESCE (ObjectBoolean_Partner_GoodsBox.ValueData, FALSE) = TRUE
                            THEN COALESCE (tmpMI.BoxCount,0)
                            ELSE 0
                       END)   :: TFloat  AS BoxCount_calc

                , CASE WHEN inisDetail = TRUE THEN Movement.Id ELSE 0 END         ::Integer AS MovementId
                , CASE WHEN inisDetail = TRUE THEN Movement.InvNumber ELSE '' END ::TVarChar AS InvNumber
           FROM tmpMI
                LEFT JOIN tmpMovement AS Movement ON Movement.Id = tmpMI.MovementId

                LEFT JOIN tmpMovementDate AS MovementDate_OperDatePartner
                                          ON MovementDate_OperDatePartner.MovementId = Movement.Id

                LEFT JOIN tmpMovementString AS MovementString_InvNumberOrder
                                            ON MovementString_InvNumberOrder.MovementId = Movement.Id
                                           AND MovementString_InvNumberOrder.DescId = zc_MovementString_InvNumberOrder() 
                                           AND inisDetail = True

                LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_From
                                                ON MovementLinkObject_From.MovementId = Movement.Id
                                               AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
                LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

                LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_To
                                                ON MovementLinkObject_To.MovementId = Movement.Id
                                               AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
                LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

                LEFT JOIN tmpMovementLinkObject AS MovementLinkObject_Contract
                                                ON MovementLinkObject_Contract.MovementId = Movement.Id
                                               AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                               AND inisDetail = True
                LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId

                LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                       ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpMI.GoodsId
                                      AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

                LEFT JOIN ObjectBoolean AS ObjectBoolean_Partner_GoodsBox
                                        ON ObjectBoolean_Partner_GoodsBox.ObjectId = MovementLinkObject_To.ObjectId
                                       AND ObjectBoolean_Partner_GoodsBox.DescId = zc_ObjectBoolean_Partner_GoodsBox()

                LEFT JOIN tmpGoodsPropertyValue ON tmpGoodsPropertyValue.MovementId = tmpMI.MovementId
                                               AND tmpGoodsPropertyValue.Id = tmpMI.Id
                --LEFT JOIN Object AS Object_GoodsBox ON Object_GoodsBox.Id = tmpGoodsPropertyValue.GoodsBoxId

                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = COALESCE (tmpGoodsPropertyValue.GoodsBoxId, tmpMI.GoodsId)

           GROUP BY  Movement.OperDate
                , MovementDate_OperDatePartner.ValueData
                , Object_From.Id
                , Object_From.ObjectCode
                , Object_From.ValueData
                , Object_To.Id
                , Object_To.ObjectCode
                , Object_To.ValueData
                , Object_Goods.Id
                , Object_Goods.ObjectCode
                , Object_Goods.ValueData
                , ObjectString_Goods_GoodsGroupFull.ValueData
                , COALESCE (ObjectBoolean_Partner_GoodsBox.ValueData, FALSE)
                , CASE WHEN inisDetail = TRUE THEN Movement.Id ELSE 0 END
                , CASE WHEN inisDetail = TRUE THEN Movement.InvNumber ELSE '' END
                , Object_Contract.Id
                , Object_Contract.ObjectCode
                , Object_Contract.ValueData
                , MovementString_InvNumberOrder.ValueData
           ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
08.07.22         *
*/

-- тест
-- SELECT * FROM gpReport_SaleTare_Gofro (inStartDate := '08.04.2022'::TDatetime, inEndDate := '08.04.2022'::TDatetime, inUnitId:=0, inGoodsGroupId:= 1960, inisDetail:= FALSE, inSession:='5'::TVarChar);
