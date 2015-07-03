-- Function: gpSelect_Movement_ProductionSeparate_Ceh_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_ProductionSeparate_Ceh_Print (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ProductionSeparate_Ceh_Print(
    IN inMovementId                 Integer  , -- ���� ���������
    IN inMovementId_Weighing        Integer  , -- ���� ��������� �����������
    IN inSession                    TVarChar    -- ������ ������������
)
RETURNS SETOF refcursor
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE Cursor1 refcursor;
    DECLARE Cursor2 refcursor;

    DECLARE vbGoodsPropertyId Integer;
    DECLARE vbGoodsPropertyId_basis Integer;

    DECLARE vbDescId Integer;
    DECLARE vbStatusId Integer;
    DECLARE vbPriceWithVAT Boolean;
    DECLARE vbVATPercent TFloat;
    DECLARE vbDiscountPercent TFloat;
    DECLARE vbExtraChargesPercent TFloat;
    DECLARE vbPaidKindId Integer;
    DECLARE vbOperDate TDateTime;

    DECLARE vbStoreKeeperName TVarChar;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_...());
     vbUserId:= lpGetUserBySession (inSession);


     -- ��������� �� ���������
     SELECT Movement.DescId
          , Movement.StatusId
          , Movement.OperDate                  AS OperDate
       INTO vbDescId, vbStatusId, vbOperDate
     FROM Movement
     WHERE Movement.Id = inMovementId
    ;

     -- ��������� �� �����������
     vbStoreKeeperName:= (SELECT Object_User.ValueData
                          FROM Movement
                               LEFT JOIN MovementLinkObject AS MovementLinkObject_User
                                                            ON MovementLinkObject_User.MovementId = Movement.Id
                                                           AND MovementLinkObject_User.DescId = zc_MovementLinkObject_User()
                               LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_User.ObjectId
                          WHERE Movement.ParentId = inMovementId AND Movement.DescId IN (zc_Movement_WeighingPartner(), zc_Movement_WeighingProduction())
                            AND Movement.StatusId = zc_Enum_Status_Complete()
                          LIMIT 1
                         );


    -- ����� ������ ��������
    IF COALESCE (vbStatusId, 0) = zc_Enum_Status_Erased()
    THEN
        IF vbStatusId = zc_Enum_Status_Erased()
        THEN
            RAISE EXCEPTION '������.�������� <%> � <%> �� <%> ������.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        IF vbStatusId = zc_Enum_Status_UnComplete()
        THEN
            RAISE EXCEPTION '������.�������� <%> � <%> �� <%> �� ��������.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId), (SELECT InvNumber FROM Movement WHERE Id = inMovementId), (SELECT DATE (OperDate) FROM Movement WHERE Id = inMovementId);
        END IF;
        -- ��� ��� �������� ������
        RAISE EXCEPTION '������.�������� <%>.', (SELECT ItemName FROM MovementDesc WHERE Id = vbDescId);
    END IF;



     --
    OPEN Cursor1 FOR
    
    WITH tmpMIMaster AS (SELECT MAX (MovementItem.ObjectId)                     AS GoodsId
                              , SUM (MovementItem.Amount)                       AS Count
                              , SUM (COALESCE (MIFloat_HeadCount.ValueData, 0)) AS HeadCount          
                         FROM MovementItem 
                              LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                          ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                         AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                         WHERE MovementItem.MovementId = inMovementId
                           AND MovementItem.DescId     = zc_MI_Master()
                           AND MovementItem.isErased   = FALSE
                        )
       , tmpMIChild AS (SELECT SUM (MovementItem.Amount)  AS Count_Child
                        FROM MovementItem 
                        WHERE MovementItem.MovementId = inMovementId
                          AND MovementItem.DescId     = zc_MI_Child()
                          AND MovementItem.isErased   = FALSE
                       )
       , tmpMovementWeighing AS (SELECT Movement.Id AS MovementId
                                      , MFloat_WeighingNumber.ValueData AS WeighingNumber 
                                 FROM Movement
                                      LEFT JOIN MovementFloat AS MFloat_WeighingNumber
                                                              ON MFloat_WeighingNumber.MovementId = Movement.Id
                                                             AND MFloat_WeighingNumber.DescId = zc_MovementFloat_WeighingNumber()
                                 WHERE Movement.ParentId = inMovementId
                                   AND Movement.StatusId = zc_Enum_Status_Complete()
                                ) 
      , tmpMIWeighing AS (SELECT CASE WHEN inMovementId_Weighing > 0 THEN tmpMovementWeighing.WeighingNumber ELSE 0 END AS WeighingNumber
                               , SUM (MovementItem.Amount) AS Count
                          FROM tmpMovementWeighing
                              LEFT JOIN MovementBoolean AS MovementBoolean_isIncome
                                      ON MovementBoolean_isIncome.MovementId = tmpMovementWeighing.MovementId
                                     AND MovementBoolean_isIncome.DescId = zc_MovementBoolean_isIncome()
                                     --AND MovementBoolean_isIncome.ValueData = FALSE
                              LEFT JOIN MovementItem ON MovementItem.MovementId = tmpMovementWeighing.MovementId
                                                     AND MovementItem.isErased  = FALSE
                                                     AND MovementBoolean_isIncome.ValueData = FALSE
                          WHERE tmpMovementWeighing.MovementId = inMovementId_Weighing 
                             OR COALESCE (inMovementId_Weighing, 0) = 0 
                          GROUP BY CASE WHEN inMovementId_Weighing > 0 THEN tmpMovementWeighing.WeighingNumber ELSE 0 END
                          ) 

        SELECT
           Movement.InvNumber                 AS InvNumber
         , Movement.OperDate                  AS OperDate

         , MovementString_PartionGoods.ValueData AS PartionGoods

         , Object_From.ValueData                AS FromName
         , Object_To.ValueData                  AS ToName

         , Object_Goods.ObjectCode                AS GoodsCode
         , Object_Goods.ValueData                 AS GoodsName
         , tmpMIMaster.Count 
         , tmpMIMaster.HeadCount 
         , CASE WHEN tmpMIMaster.Count <> 0 THEN tmpMIChild.Count_Child / tmpMIMaster.Count ELSE 0 END :: TFloat AS PersentVyhod
         , tmpCount.Count :: TFloat       AS TotalNumber
         , tmpMIWeighing.WeighingNumber   AS WeighingNumber
         , tmpMIWeighing.Count ::  TFloat AS CountWeighing

         , vbStoreKeeperName AS StoreKeeper -- ���������
     FROM Movement 
          LEFT JOIN (SELECT COUNT(*) AS Count from tmpMovementWeighing) AS tmpCount ON 1 = 1
          LEFT JOIN  tmpMIWeighing ON 1 = 1
         
          LEFT JOIN MovementString AS MovementString_PartionGoods
                                   ON MovementString_PartionGoods.MovementId =  Movement.Id
                                  AND MovementString_PartionGoods.DescId = zc_MovementString_PartionGoods()

          LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                       ON MovementLinkObject_From.MovementId = Movement.Id
                                      AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
          LEFT JOIN Object AS Object_From ON Object_From.Id = MovementLinkObject_From.ObjectId

          LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                       ON MovementLinkObject_To.MovementId = Movement.Id
                                      AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
          LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId

          LEFT JOIN tmpMIMaster ON 1 = 1
          LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = tmpMIMaster.GoodsId
          LEFT JOIN tmpMIChild ON 1 = 1

       WHERE Movement.Id = inMovementId
         AND Movement.StatusId <> zc_Enum_Status_Erased()
      ;


    RETURN NEXT Cursor1;
    OPEN Cursor2 FOR

   With   tmpWeighing AS (SELECT MovementItem.ObjectId AS GoodsId 
                                ,SUM (MovementItem.Amount) AS Count
                                ,SUM (COALESCE (MIFloat_HeadCount.ValueData, 0)) AS HeadCount
                          FROM  (SELECT Movement.Id AS MovementId
                                 FROM Movement
                                 WHERE Movement.ParentId = inMovementId
                                   AND Movement.StatusId = zc_Enum_Status_Complete()
                                 ) AS tmp
                              INNER JOIN MovementBoolean AS MovementBoolean_isIncome
                                      ON MovementBoolean_isIncome.MovementId = tmp.MovementId
                                     AND MovementBoolean_isIncome.DescId = zc_MovementBoolean_isIncome()
                                     AND MovementBoolean_isIncome.ValueData = TRUE
                              INNER JOIN MovementItem ON MovementItem.MovementId = tmp.MovementId
                                                     AND MovementItem.isErased   = FALSE
                              LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                                          ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                                         AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
                          WHERE tmp.MovementId = inMovementId_Weighing  
                             OR COALESCE (inMovementId_Weighing, 0) = 0 
                          GROUP BY MovementItem.ObjectId
                          ) 

       SELECT Object_Goods.ObjectCode  			 AS GoodsCode
           , Object_Goods.ValueData   			 AS GoodsName
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName
           , SUM (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN (MovementItem.Amount) ELSE 0 END) ::TFloat  AS Amount_Sh
           , SUM (MovementItem.Amount * (CASE WHEN Object_Measure.Id = zc_Measure_Sh() THEN ObjectFloat_Weight.ValueData ELSE 1 END) )  ::TFloat  AS Amount_Weight
           , SUM (MovementItem.Amount)::TFloat		 AS Amount
           , SUM (COALESCE (MIFloat_LiveWeight.ValueData, 0)) :: TFloat  AS LiveWeight
           , SUM (COALESCE (MIFloat_HeadCount.ValueData, 0))  :: TFloat	 AS HeadCount
           , tmpWeighing.Count :: TFloat	         AS WeighingCount
           , tmpWeighing.HeadCount :: TFloat	         AS HeadCount_item

       FROM MovementItem
                      
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_LiveWeight
                                        ON MIFloat_LiveWeight.MovementItemId = MovementItem.Id
                                       AND MIFloat_LiveWeight.DescId = zc_MIFloat_LiveWeight()
            LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = MovementItem.ObjectId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId 
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
     
            LEFT JOIN ObjectFloat AS ObjectFloat_Weight	
                                  ON ObjectFloat_Weight.ObjectId = Object_Goods.Id 
                                 AND ObjectFloat_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                                 
            LEFT JOIN tmpWeighing ON tmpWeighing.GoodsId = MovementItem.ObjectId
                              
        WHERE MovementItem.MovementId = inMovementId
          AND MovementItem.DescId     = zc_MI_Child()
          AND MovementItem.isErased   = FALSE
          AND MovementItem.Amount <> 0

            GROUP BY Object_Goods.ObjectCode
           , Object_Goods.ValueData
           , ObjectString_Goods_GoodsGroupFull.ValueData
           , Object_Measure.ValueData
           , Object_Measure.Id 
           , tmpWeighing.GoodsId
           , tmpWeighing.Count
           , tmpWeighing.HeadCount
          
      ;
      

    RETURN NEXT Cursor2;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_ProductionSeparate_Ceh_Print (Integer,Integer, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 15.06.15         *
*/
-- ����
-- SELECT * FROM gpSelect_Movement_ProductionSeparate_Ceh_Print (inMovementId := 597300, inMovementId_Weighing:= 0, inSession:= zfCalc_UserAdmin());
