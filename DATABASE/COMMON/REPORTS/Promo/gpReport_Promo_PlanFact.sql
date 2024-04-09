

DROP FUNCTION IF EXISTS gpReport_Promo_PlanFact(
    TDateTime, --���� ������ �������
    TDateTime, --���� ��������� �������
    Boolean,   --�������� ������ �����
    Boolean,   --�������� ������ �������
    Boolean,   -- ������������ �� �����
    Integer,   --�������������
    Integer,   --��.����
    TVarChar   --������ ������������
);
CREATE OR REPLACE FUNCTION gpReport_Promo_PlanFact(
    IN inStartDate      TDateTime, --���� ������ �������
    IN inEndDate        TDateTime, --���� ��������� �������
    IN inIsPromo        Boolean,   --�������� ������ �����
    IN inIsTender       Boolean,   --�������� ������ �������
    IN inIsGoodsKind    Boolean,   --������������ �� �����
    IN inUnitId         Integer,   --�������������
    IN inJuridicalId    Integer,   --��.����
    IN inSession        TVarChar   --������ ������������
)
RETURNS TABLE(
     MovementId           Integer   --�� ��������� �����
    ,OperDate             TDateTime -- * ������ �������� � ����
    ,InvNumber            TVarChar   --� ��������� �����
    ,StatusCode Integer, StatusName TVarChar
    ,UnitName             TVarChar  --�����
    , DateStartSale   TDateTime       --���� ������ �������� �� ��������� ����
    , DateFinalSale     TDateTime       --���� ��������� �������� �� ��������� ����
    , DateStartPromo  TDateTime       --���� ������ �����
    , DateFinalPromo    TDateTime       --���� ��������� �����
    , MonthPromo  TDateTime       --����� �����

    ,RetailName           TBlob     --����, � ������� �������� �����
    ,JuridicalName_str    TBlob     --��.����
    ,GoodsName            TVarChar  --�������
    ,GoodsCode            Integer   --��� �������
    ,MeasureName          TVarChar  --������� ���������
    ,TradeMarkName        TVarChar  --�������� �����
    ,AmountPlanMin        TFloat    --����������� ����� ������ � ��������� ������, ��
    ,AmountPlanMinWeight  TFloat    --����������� ����� ������ � ��������� ������, ��
    ,AmountPlanMax        TFloat    --����������� ����� ������ � ��������� ������, ��
    ,AmountPlanMaxWeight  TFloat    --����������� ����� ������ � ��������� ������, ��

    ,AmountPlanAvg             TFloat    --����������� ����� ������ � ��������� ������, ��
    ,AmountPlanAvgWeight       TFloat    --����������� ����� ������ � ��������� ������, ��
    ,AmountPlanAvg_calc        TFloat    --����������� ����� ������ � ��������� ������, ��
    ,AmountPlanAvgWeight_calc  TFloat    --����������� ����� ������ � ��������� ������, ��

    ,AmountReal           TFloat    --����� ������ � ����������� ������, ��
    ,AmountRealWeight     TFloat    --����� ������ � ����������� ������, �� ���
    ,AmountOrder          TFloat    --���-�� ������ (����)
    ,AmountOrderWeight    TFloat    --���-�� ������ (����) ���
    ,AmountOut            TFloat    --���-�� ���������� (����)
    ,AmountOutWeight      TFloat    --���-�� ���������� (����) ���
    ,AmountIn             TFloat    --���-�� ������� (����)
    ,AmountInWeight       TFloat    --���-�� ������� (����) ���

    , CountDaySale TFloat
    , CountDay     TFloat
    ,AmountOut_fact            TFloat    --���-�� ���������� (����)
    ,AmountOutWeight_fact      TFloat    --���-�� ���������� (����) ���
    ,AmountIn_fact             TFloat    --���-�� ������� (����)
    ,AmountInWeight_fact       TFloat    --���-�� ������� (����) ���
    , PersentWeight            TFloat    -- % ���������� ����� ������� �� �����  - ������� ���� ������ ������ = ������� ���� ������ * ����� ���� � ���� ������ �� ������ = �������� �.3 �� ������ ������
    , PersentWeight_2          TFloat    -- % ���������� ����� ������� �� ����� (AmountPlanMin + AmountPlanMax) / 2 � zc_MIFloat_AmountOut - ��� ����� �� ���� ������
    ,GoodsKindName             TVarChar  --��� ��������
    ,GoodsKindCompleteName     TVarChar  --��� �������� ( ����������)
   -- ,GoodsKindName_List   TVarChar  --��� ������ (���������)
    ,GoodsWeight          TFloat    --���
    )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbShowAll Boolean;
    DECLARE vbCountDay TFloat;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!������ �������� �������!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

    -- �������� ���������� �������� �� ����� ����������� ���� �������
    --vbShowAll:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId IN (112322, 876016, 5473256, 296580, zc_Enum_Role_Admin())); -- ��������� ��������� + ����� ��������� + ��������� - ������������ + �������� ��� (����������)

    --���� ������
    vbCountDay := (DATE_PART ('DAY',(inEndDate - inStartDate) ) + 1) ::TFloat;
    
    
    -- ������� ��� ��������� ��� ������ (���������) �� GoodsListSale
    CREATE TEMP TABLE _tmpWord_Split_from (WordList TVarChar) ON COMMIT DROP;
    CREATE TEMP TABLE _tmpWord_Split_to (Ord Integer, Word TVarChar, WordList TVarChar) ON COMMIT DROP;

    INSERT INTO _tmpWord_Split_from (WordList)
            SELECT DISTINCT ObjectString_GoodsKind.ValueData AS WordList
            FROM ObjectString AS ObjectString_GoodsKind
            WHERE ObjectString_GoodsKind.DescId = zc_ObjectString_GoodsListSale_GoodsKind()
              AND ObjectString_GoodsKind.ValueData <> '';

    PERFORM zfSelect_Word_Split (inSep:= ',', inUserId:= vbUserId);
    --

    -- ���������
    RETURN QUERY
     WITH tmpGoodsKind AS (SELECT _tmpWord_Split_to.WordList, Object.ValueData :: TVarChar AS GoodsKindName
                           FROM _tmpWord_Split_to
                                LEFT JOIN Object ON Object.Id = _tmpWord_Split_to.Word :: Integer
                           GROUP BY _tmpWord_Split_to.WordList, Object.ValueData
                           )
        -- 1) ����� ��� ����� � ������� ������ �������� � .. �� ...  ������� �������� � ������ �����
        , tmpMovement AS (SELECT Movement_Promo.*
                               , MovementDate_StartSale.ValueData            AS StartSale          --���� ������ �������� �� ��������� ����
                               , MovementDate_EndSale.ValueData              AS EndSale            --���� ��������� �������� �� ��������� ����
                               , MovementLinkObject_Unit.ObjectId            AS UnitId
                               , COALESCE (MovementBoolean_Promo.ValueData, FALSE)   :: Boolean AS isPromo  -- ����� (��/���)

                               --������� ����� ������ ���������� ����� � ��������� ������� ������  
                               /*(����� ���� = ����_����_�����_� ������� / ���� ���� ����� �����, �.� ����� ���� ����� = 50, � �������� 22�� � � ������� 28��, ����� ��� ���� ����= 22/50)*/
                               , CASE WHEN MovementDate_StartSale.ValueData < inStartDate THEN inStartDate ELSE MovementDate_StartSale.ValueData END
                               , CASE WHEN MovementDate_EndSale.ValueData > inEndDate THEN inEndDate ELSE MovementDate_EndSale.ValueData END
                               , (DATE_PART ('DAY',(CASE WHEN MovementDate_EndSale.ValueData > inEndDate THEN inEndDate ELSE MovementDate_EndSale.ValueData END              --inEndDate
                                                  - CASE WHEN MovementDate_StartSale.ValueData < inStartDate THEN inStartDate ELSE MovementDate_StartSale.ValueData END)     --inStartDate
                                                   ) + 1) ::TFloat AS CountDay
                          FROM Movement AS Movement_Promo
                             LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                          ON MovementLinkObject_Unit.MovementId = Movement_Promo.Id
                                                         AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()

                             LEFT JOIN MovementDate AS MovementDate_StartSale
                                                    ON MovementDate_StartSale.MovementId = Movement_Promo.Id
                                                   AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                             LEFT JOIN MovementDate AS MovementDate_EndSale
                                                    ON MovementDate_EndSale.MovementId = Movement_Promo.Id
                                                   AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()
                             LEFT JOIN MovementBoolean AS MovementBoolean_Promo
                                                       ON MovementBoolean_Promo.MovementId = Movement_Promo.Id
                                                      AND MovementBoolean_Promo.DescId = zc_MovementBoolean_Promo()

                          WHERE Movement_Promo.DescId = zc_Movement_Promo()
                         AND (MovementDate_StartSale.ValueData BETWEEN inStartDate AND inEndDate
                         OR
                               inStartDate BETWEEN MovementDate_StartSale.ValueData AND MovementDate_EndSale.ValueData
                              )
                         AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
                         AND Movement_Promo.StatusId = zc_Enum_Status_Complete()
                         AND Movement_Promo.StatusId <> zc_Enum_Status_Erased()
                         AND (  (COALESCE (MovementBoolean_Promo.ValueData, FALSE) = TRUE AND inIsPromo = TRUE)
                             OR (COALESCE (MovementBoolean_Promo.ValueData, FALSE) = FALSE AND inIsTender = TRUE)
                             OR (inIsPromo = FALSE AND inIsTender = FALSE)
                             )
                          )

        , tmpMovement_Promo AS (SELECT
                                Movement_Promo.Id                                                --�������������
                              , Movement_Promo.OperDate
                              , Movement_Promo.InvNumber                                                --�������������
                              , Movement_Promo.UnitId
                              , Object_Unit.ValueData                       AS UnitName           --�������������
                              , MovementDate_StartPromo.ValueData           AS StartPromo         --���� ������ �����
                              , MovementDate_EndPromo.ValueData             AS EndPromo           --���� ��������� �����
                              , Movement_Promo.StartSale                    AS StartSale          --���� ������ �������� �� ��������� ����
                              , Movement_Promo.EndSale                      AS EndSale            --���� ��������� �������� �� ��������� ����
                              , DATE_TRUNC ('MONTH', MovementDate_Month.ValueData) :: TDateTime AS MonthPromo         -- ����� �����
                              , COALESCE (Movement_Promo.isPromo, FALSE)   :: Boolean AS isPromo  -- ����� (��/���)
                              , DATE_PART ('DAY', AGE (Movement_Promo.EndSale, Movement_Promo.StartSale) ) AS CountDaySale
                              --, DATE_PART ('DAY', AGE (MovementDate_EndPromo.ValueData, MovementDate_StartPromo.ValueData) ) AS CountDaySale
                              , Object_Status.ObjectCode                    AS StatusCode         --
                              , Object_Status.ValueData                     AS StatusName         --
                              , Movement_Promo.CountDay
                         FROM tmpMovement AS Movement_Promo
                             LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_Promo.StatusId
                             LEFT JOIN MovementDate AS MovementDate_StartPromo
                                                    ON MovementDate_StartPromo.MovementId = Movement_Promo.Id
                                                   AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
                             LEFT JOIN MovementDate AS MovementDate_EndPromo
                                                    ON MovementDate_EndPromo.MovementId =  Movement_Promo.Id
                                                   AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
                             LEFT JOIN MovementDate AS MovementDate_Month
                                                    ON MovementDate_Month.MovementId = Movement_Promo.Id
                                                   AND MovementDate_Month.DescId = zc_MovementDate_Month()
                             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement_Promo.UnitId
                        )

        , tmpMI AS (SELECT *
                    FROM MovementItem
                    WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement_Promo.Id FROM tmpMovement_Promo)
                      AND MovementItem.DescId = zc_MI_Master()
                      AND MovementItem.isErased = FALSE
                    )

        , tmpMovementItemFloat AS (SELECT *
                                   FROM MovementItemFloat
                                   WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                     AND MovementItemFloat.DescId IN (zc_MIFloat_AmountPlanMin()
                                                                    , zc_MIFloat_AmountPlanMax()
                                                                    , zc_MIFloat_AmountOrder()
                                                                    , zc_MIFloat_AmountOut()
                                                                    , zc_MIFloat_AmountIn()
                                                                    , zc_MIFloat_AmountReal() )
                                  )

        , tmpMovementItemLinkObject AS (SELECT *
                                        FROM MovementItemLinkObject
                                        WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                          AND MovementItemLinkObject.DescId IN (zc_MILinkObject_GoodsKind()
                                                                              , zc_MILinkObject_GoodsKindComplete()
                                                                                )
                                  )

        , tmpMI_PromoGoods AS (SELECT MovementItem.MovementId                AS MovementId          --�� ��������� <�����>
                                    , MovementItem.ObjectId                  AS GoodsId             --�� ������� <�����>
                                    , Object_Goods.ObjectCode::Integer       AS GoodsCode           --��� �������  <�����>
                                    , Object_Goods.ValueData                 AS GoodsName           --������������ ������� <�����>
                                    , Object_Measure.Id                      AS MeasureId             --������� ���������
                                    , Object_Measure.ValueData               AS MeasureName             --������� ���������
                                    , Object_TradeMark.ValueData             AS TradeMark           --�������� �����
                                    , Object_GoodsKind.ValueData             AS GoodsKindName       --������������ ������� <��� ������>
                                    , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END::TFloat as GoodsWeight -- ���
                                    , STRING_AGG (DISTINCT Object_GoodsKindComplete.ValueData, '; ') :: TVarChar  AS GoodsKindCompleteName         --������������ ������� <��� ������ (����������)>
                                    , STRING_AGG (DISTINCT (CAST (MIFloat_AmountPlanMin.ValueData * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END AS NUMERIC (16,0))) :: TVarChar ||' �� - '
                                                         ||(CAST (MIFloat_AmountPlanMax.ValueData* CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END AS NUMERIC (16,0))) :: TVarChar ||' �� - '
                                                         || Object_GoodsKindComplete.ValueData, ''||CHR(13)||'') :: TVarChar  AS GoodsKindCompleteName_byPrint --������������ ������� <��� ������ (����������)>


                                    , AVG (MovementItem.Amount)                    AS Amount              --% ������ �� �����

                                    , SUM (MIFloat_AmountReal.ValueData)           AS AmountReal          --����� ������ � ����������� ������, ��
                                    , SUM (MIFloat_AmountReal.ValueData
                                        * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountRealWeight    --����� ������ � ����������� ������, �� ���

                                    , SUM (MIFloat_AmountPlanMin.ValueData)        AS AmountPlanMin       --������� ������������ ������ ������ �� ��������� ������ (� ��)
                                    , SUM (MIFloat_AmountPlanMin.ValueData
                                        * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountPlanMinWeight --������� ������������ ������ ������ �� ��������� ������ (� ��) ���
                                    , SUM (MIFloat_AmountPlanMax.ValueData)        AS AmountPlanMax       --�������� ������������ ������ ������ �� ��������� ������ (� ��)
                                    , SUM (MIFloat_AmountPlanMax.ValueData
                                        * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountPlanMaxWeight --�������� ������������ ������ ������ �� ��������� ������ (� ��) ���

                                    , SUM (MIFloat_AmountOrder.ValueData)          AS AmountOrder         --���-�� ������ (����)
                                    , SUM (MIFloat_AmountOrder.ValueData
                                        * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountOrderWeight   --���-�� ������ (����) ���
                                    , SUM (MIFloat_AmountOut.ValueData)            AS AmountOut           --���-�� ���������� (����)
                                    , SUM (MIFloat_AmountOut.ValueData
                                        * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountOutWeight     --���-�� ���������� (����) ���
                                    , SUM (MIFloat_AmountIn.ValueData)             AS AmountIn            --���-�� ������� (����)
                                    , SUM (MIFloat_AmountIn.ValueData
                                        * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountInWeight      --���-�� ������� (����) ���

                                    --������� �������� ����
                                    , SUM ((COALESCE (MIFloat_AmountPlanMin.ValueData,0) + COALESCE (MIFloat_AmountPlanMax.ValueData,0)) / 2 ) :: TFloat AS AmountPlanAvg
                                    , SUM ((COALESCE (MIFloat_AmountPlanMin.ValueData,0) + COALESCE (MIFloat_AmountPlanMax.ValueData,0)) / 2
                                        * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END) :: TFloat AS AmountPlanAvgWeight 

                               FROM tmpMI AS MovementItem

                                      LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlanMin
                                                                     ON MIFloat_AmountPlanMin.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_AmountPlanMin.DescId = zc_MIFloat_AmountPlanMin()
                                      LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPlanMax
                                                                     ON MIFloat_AmountPlanMax.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_AmountPlanMax.DescId = zc_MIFloat_AmountPlanMax()
                                      LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountOrder
                                                                     ON MIFloat_AmountOrder.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()
                                      LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountOut
                                                                     ON MIFloat_AmountOut.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_AmountOut.DescId = zc_MIFloat_AmountOut()
                                      LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountIn
                                                                     ON MIFloat_AmountIn.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_AmountIn.DescId = zc_MIFloat_AmountIn()
                                      LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountReal
                                                                     ON MIFloat_AmountReal.MovementItemId = MovementItem.Id
                                                                    AND MIFloat_AmountReal.DescId = zc_MIFloat_AmountReal()

                                      LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

                                      LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_GoodsKind
                                                                          ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                                         AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                      LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

                                      LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_GoodsKindComplete
                                                                          ON MILinkObject_GoodsKindComplete.MovementItemId = MovementItem.Id
                                                                         AND MILinkObject_GoodsKindComplete.DescId = zc_MILinkObject_GoodsKindComplete()
                                      LEFT JOIN Object AS Object_GoodsKindComplete ON Object_GoodsKindComplete.Id = MILinkObject_GoodsKindComplete.ObjectId

                                      LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                           ON ObjectLink_Goods_Measure.ObjectId = MovementItem.ObjectId
                                                          AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                                      LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

                                      LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                                           ON ObjectLink_Goods_TradeMark.ObjectId = MovementItem.ObjectId
                                                          AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                                      LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = ObjectLink_Goods_TradeMark.ChildObjectId

                                      LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Weight
                                                                  ON ObjectFloat_Goods_Weight.ObjectId = MovementItem.ObjectId
                                                                 AND ObjectFloat_Goods_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                               GROUP BY MovementItem.MovementId
                                      , MovementItem.ObjectId
                                      , Object_Goods.ObjectCode
                                      , Object_Goods.ValueData
                                      , Object_Measure.ValueData
                                      , Object_Measure.Id
                                      , Object_TradeMark.ValueData
                                      , Object_GoodsKind.ValueData
                                      , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END
                               )

----������ ���� ��� ����� 
          -- �������� ��� ��� ������� � �������� �� ���. �����
        , tmpMovementSale AS (SELECT Movement.Id
                               , Movement.OperDate
                               , Movement.Invnumber
                               , Movement.DescId
                               , MovementItem.Id AS MovementItemId
                               , MovementItem.ObjectId            AS GoodsId
                               , MIFloat_PromoMovement.ValueData ::Integer AS MovementId_promo
                               , MovementItem.Amount
                          FROM MovementItemFloat AS MIFloat_PromoMovement
                               INNER JOIN MovementItem ON MovementItem.Id       = MIFloat_PromoMovement.MovementItemId
                                                      AND MovementItem.isErased = FALSE
                               INNER JOIN Movement ON Movement.Id = MovementItem.MovementId
                                                  AND Movement.StatusId = zc_Enum_Status_Complete()
                                                  AND Movement.DescId IN ( zc_Movement_Sale(), zc_Movement_ReturnIn())
                                                  AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                          WHERE MIFloat_PromoMovement.ValueData IN (SELECT DISTINCT tmpMovement_Promo.Id FROM tmpMovement_Promo)
                            AND MIFloat_PromoMovement.DescId = zc_MIFloat_PromoMovementId()
                        )

        , tmpMI_GoodsKind AS (SELECT *
                              FROM MovementItemLinkObject 
                              WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMovementSale.MovementItemId FROM tmpMovementSale)
                                AND MovementItemLinkObject.DescId         = zc_MILinkObject_GoodsKind()
                              )

        , tmpMovementItemFloat2 AS (SELECT *
                                   FROM MovementItemFloat 
                                   WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMovementSale.MovementItemId FROM tmpMovementSale)
                                     AND MovementItemFloat.DescId = zc_MIFloat_AmountPartner()
                                   )

        , tmpDataFact AS (SELECT tmpMovement.MovementId_promo
                               , tmpMovement.GoodsId
                               --, MILinkObject_GoodsKind.ObjectId AS GoodsKindId
                          
                               , SUM (CASE WHEN tmpMovement.DescId = zc_Movement_Sale()  THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END)          :: TFloat AS AmountOut
                               , SUM ( CASE WHEN tmpMovement.DescId = zc_Movement_Sale() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END
                                       * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END ) :: TFloat AS AmountOutWeight
                  
                               , SUM (CASE WHEN tmpMovement.DescId = zc_Movement_ReturnIn() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END)       :: TFloat AS AmountIn
                               , SUM (CASE WHEN tmpMovement.DescId = zc_Movement_ReturnIn() THEN COALESCE (MIFloat_AmountPartner.ValueData, 0) ELSE 0 END
                                      * CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE 1 END )  :: TFloat AS AmountInWeight
                          FROM tmpMovementSale AS tmpMovement
                  
                               LEFT JOIN tmpMI_GoodsKind AS MILinkObject_GoodsKind ON MILinkObject_GoodsKind.MovementItemId = tmpMovement.MovementItemId
                   
                               LEFT JOIN tmpMovementItemFloat2 AS MIFloat_AmountPartner
                                                               ON MIFloat_AmountPartner.MovementItemId = tmpMovement.MovementItemId
                                                              AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
                  
                              LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                                   ON ObjectLink_Goods_Measure.ObjectId = tmpMovement.GoodsId
                                                  AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                  
                              LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Weight
                                                          ON ObjectFloat_Goods_Weight.ObjectId = tmpMovement.GoodsId
                                                         AND ObjectFloat_Goods_Weight.DescId = zc_ObjectFloat_Goods_Weight()
                          GROUP BY tmpMovement.MovementId_promo
                                 , tmpMovement.GoodsId
                                -- , MILinkObject_GoodsKind.ObjectId
                           )
                        
        --
        SELECT
            Movement_Promo.Id                --�� ��������� �����
          , Movement_Promo.OperDate :: TDateTime AS OperDate
          , Movement_Promo.InvNumber          --� ��������� �����
          , Movement_Promo.StatusCode         --
          , Movement_Promo.StatusName         --

          , Movement_Promo.UnitName           --�����
          , Movement_Promo.StartSale    AS DateStartSale      --���� ������ �������� �� ��������� ����
          , Movement_Promo.EndSale      AS DateFinalSale      --���� ��������� �������� �� ��������� ����
          , Movement_Promo.StartPromo   AS DateStartPromo      --���� ������ �����
          , Movement_Promo.EndPromo     AS DateFinalPromo      --���� ��������� �����
          , Movement_Promo.MonthPromo         --����� �����
          ------------------------
          , COALESCE ((SELECT STRING_AGG (DISTINCT COALESCE (MovementString_Retail.ValueData, Object_Retail.ValueData),'; ')
                       FROM
                          Movement AS Movement_PromoPartner
                          /*INNER JOIN MovementLinkObject AS MLO_Partner
                                                        ON MLO_Partner.MovementId = Movement_PromoPartner.ID
                                                       AND MLO_Partner.DescId     = zc_MovementLinkObject_Partner()
                          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = MLO_Partner.ObjectId*/
                          INNER JOIN MovementItem AS MI_PromoPartner
                                                  ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                                 AND MI_PromoPartner.DescId     = zc_MI_Master()
                                                 AND MI_PromoPartner.IsErased   = FALSE
                          LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                               ON ObjectLink_Partner_Juridical.ObjectId = MI_PromoPartner.ObjectId
                                              AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                          LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                               ON ObjectLink_Juridical_Retail.ObjectId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MI_PromoPartner.ObjectId)
                                              AND ObjectLink_Juridical_Retail.DescId   = zc_ObjectLink_Juridical_Retail()
                          LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

                          LEFT OUTER JOIN MovementString AS MovementString_Retail
                                                         ON MovementString_Retail.MovementId = Movement_PromoPartner.Id
                                                        AND MovementString_Retail.DescId = zc_MovementString_Retail()
                                                        AND MovementString_Retail.ValueData <> ''

                       WHERE Movement_PromoPartner.ParentId = Movement_Promo.Id
                         AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
                         AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                      )
          , (SELECT STRING_AGG (DISTINCT Object.ValueData,'; ')
             FROM
                Movement AS Movement_PromoPartner
                INNER JOIN MovementLinkObject AS MLO_Partner
                                              ON MLO_Partner.MovementId = Movement_PromoPartner.ID
                                             AND MLO_Partner.DescId     = zc_MovementLinkObject_Partner()
                INNER JOIN Object ON Object.Id = MLO_Partner.ObjectId
             WHERE Movement_PromoPartner.ParentId = Movement_Promo.Id
               AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
               AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
              ) )::TBlob AS RetailName
            --------------------------------------
          , (SELECT STRING_AGG ( tmp.JuridicalName,'; ')
             FROM (SELECT DISTINCT Object_Juridical.ValueData AS JuridicalName
                        , CASE WHEN Object_Juridical.Id = inJuridicalId THEN 1 else 99 END AS ord
                   FROM
                      Movement AS Movement_PromoPartner

                      INNER JOIN MovementItem AS MI_PromoPartner
                                              ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                             AND MI_PromoPartner.DescId     = zc_MI_Master()
                                             AND MI_PromoPartner.IsErased   = FALSE
                      LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                           ON ObjectLink_Partner_Juridical.ObjectId = MI_PromoPartner.ObjectId
                                          AND ObjectLink_Partner_Juridical.DescId   = zc_ObjectLink_Partner_Juridical()
                      LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MI_PromoPartner.ObjectId)
                   WHERE Movement_PromoPartner.ParentId = Movement_Promo.Id
                     AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
                     AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                   ORDER BY CASE WHEN Object_Juridical.Id = inJuridicalId THEN 1 else 99 END 
                   ) AS tmp
            ) ::TBlob AS JuridicalName_str

          , MI_PromoGoods.GoodsName
          , MI_PromoGoods.GoodsCode
          , MI_PromoGoods.MeasureName
          , MI_PromoGoods.TradeMark
          , MI_PromoGoods.AmountPlanMin      ::TFloat --������� ������������ ������ ������ �� ��������� ������ (� ��)
          , MI_PromoGoods.AmountPlanMinWeight::TFloat --������� ������������ ������ ������ �� ��������� ������ (� ��) ���
          , MI_PromoGoods.AmountPlanMax      ::TFloat --�������� ������������ ������ ������ �� ��������� ������ (� ��)
          , MI_PromoGoods.AmountPlanMaxWeight::TFloat --�������� ������������ ������ ������ �� ��������� ������ (� ��) ���
          , MI_PromoGoods.AmountPlanAvg      ::TFloat --C������ ������������ ������ ������ �� ��������� ������ (� ��) ���
          , MI_PromoGoods.AmountPlanAvgWeight::TFloat --������� ������������ ������ ������ �� ��������� ������ (� ��) ���

          , CAST (CASE WHEN COALESCE (Movement_Promo.CountDaySale,0) <> 0 THEN MI_PromoGoods.AmountPlanAvg/Movement_Promo.CountDaySale * Movement_Promo.CountDay ELSE 0 END        AS NUMERIC (16,2))::TFloat AS AmountPlanAvg_calc--C������ ������������ ������ ������ �� ������ ������(� ��) ���
          , CAST (CASE WHEN COALESCE (Movement_Promo.CountDaySale,0) <> 0 THEN MI_PromoGoods.AmountPlanAvgWeight/Movement_Promo.CountDaySale * Movement_Promo.CountDay ELSE 0 END  AS NUMERIC (16,2))::TFloat AS AmountPlanAvgWeight_calc--C������ ������������ ������ ������ �� ������ ������(� ��) ���

          , MI_PromoGoods.AmountReal         ::TFloat --����� ������ � ����������� ������, ��
          , MI_PromoGoods.AmountRealWeight   ::TFloat --����� ������ � ����������� ������, �� ���
          , MI_PromoGoods.AmountOrder        ::TFloat --���-�� ������ (����)
          , MI_PromoGoods.AmountOrderWeight  ::TFloat --���-�� ������ (����) ���
          , MI_PromoGoods.AmountOut          ::TFloat --���-�� ���������� (����)
          , MI_PromoGoods.AmountOutWeight    ::TFloat --���-�� ���������� (����) ���
          , MI_PromoGoods.AmountIn           ::TFloat --���-�� ������� (����)
          , MI_PromoGoods.AmountInWeight     ::TFloat --���-�� ������� (����) ���

          , Movement_Promo.CountDaySale      ::TFloat
          , Movement_Promo.CountDay          ::TFloat

          , tmpDataFact.AmountOut          ::TFloat AS AmountOut_fact      --���-�� ���������� (����)
          , tmpDataFact.AmountOutWeight    ::TFloat AS AmountOutWeight_fact--���-�� ���������� (����) ���
          , tmpDataFact.AmountIn           ::TFloat AS AmountIn_fact       --���-�� ������� (����)
          , tmpDataFact.AmountInWeight     ::TFloat AS AmountInWeight_fact --���-�� ������� (����) ���

          /*, CAST (CASE WHEN (CASE WHEN COALESCE (Movement_Promo.CountDaySale,0) <> 0 THEN MI_PromoGoods.AmountPlanAvgWeight/Movement_Promo.CountDaySale * Movement_Promo.CountDay ELSE 0 END) <> 0 
                 THEN (COALESCE (tmpDataFact.AmountOutWeight,0) - (CASE WHEN COALESCE (Movement_Promo.CountDaySale,0) <> 0 THEN MI_PromoGoods.AmountPlanAvgWeight/Movement_Promo.CountDaySale * Movement_Promo.CountDay ELSE 0 END) ) * 100
                       / (CASE WHEN COALESCE (Movement_Promo.CountDaySale,0) <> 0 THEN MI_PromoGoods.AmountPlanAvgWeight/Movement_Promo.CountDaySale * Movement_Promo.CountDay ELSE 0 END)
                 ELSE 0
            END  AS NUMERIC (16,2)) ::TFloat AS PersentWeight
            */

          , CASE WHEN CAST (CASE WHEN COALESCE (Movement_Promo.CountDaySale,0) <> 0 THEN MI_PromoGoods.AmountPlanAvgWeight/Movement_Promo.CountDaySale * Movement_Promo.CountDay ELSE 0 END AS NUMERIC (16,2)) <> 0
                 THEN CAST( ( (tmpDataFact.AmountOutWeight * 100/ CAST (CASE WHEN COALESCE (Movement_Promo.CountDaySale,0) <> 0 THEN MI_PromoGoods.AmountPlanAvgWeight/Movement_Promo.CountDaySale * Movement_Promo.CountDay ELSE 0 END AS NUMERIC (16,2))) - 100) AS NUMERIC (16,2))
                 ELSE 0
            END ::TFloat AS PersentWeight

          , CASE WHEN MI_PromoGoods.AmountPlanAvgWeight <> 0
                 THEN CAST( ( (MI_PromoGoods.AmountOutWeight * 100/ MI_PromoGoods.AmountPlanAvgWeight) - 100) AS NUMERIC (16,2))
                 ELSE 0
            END ::TFloat AS PersentWeight_2        

          , MI_PromoGoods.GoodsKindName       --������������ ������� <��� ������>
          , MI_PromoGoods.GoodsKindCompleteName         ::TVarChar AS GoodsKindCompleteName

         /* , (SELECT STRING_AGG (DISTINCT tmpGoodsKind.GoodsKindName,'; ')
             FROM Movement AS Movement_PromoPartner
                INNER JOIN MovementItem AS MI_PromoPartner
                                        ON MI_PromoPartner.MovementId = Movement_PromoPartner.ID
                                       AND MI_PromoPartner.DescId     = zc_MI_Master()
                                       AND MI_PromoPartner.IsErased   = FALSE

                LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                                     ON ObjectLink_GoodsListSale_Partner.ChildObjectId = MI_PromoPartner.ObjectId
                                    AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()

                INNER JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods
                                     ON ObjectLink_GoodsListSale_Goods.ObjectId = ObjectLink_GoodsListSale_Partner.ObjectId
                                    AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
                                    AND ObjectLink_GoodsListSale_Goods.ChildObjectId = MI_PromoGoods.GoodsId
                INNER JOIN ObjectString AS ObjectString_GoodsKind
                                        ON ObjectString_GoodsKind.ObjectId = ObjectLink_GoodsListSale_Partner.ObjectId
                                       AND ObjectString_GoodsKind.DescId = zc_ObjectString_GoodsListSale_GoodsKind()

                LEFT JOIN tmpGoodsKind ON tmpGoodsKind.WordList = ObjectString_GoodsKind.ValueData

             WHERE Movement_PromoPartner.ParentId = Movement_Promo.Id
               AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
               AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
            )::TVarChar AS GoodsKindName_List
         */
          , CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE NULL END :: TFloat AS GoodsWeight

        FROM tmpMovement_Promo AS Movement_Promo
            LEFT JOIN tmpMI_PromoGoods AS MI_PromoGoods ON MI_PromoGoods.MovementId = Movement_Promo.Id
            LEFT JOIN tmpDataFact ON tmpDataFact.MovementId_promo = Movement_Promo.Id
                                 AND tmpDataFact.GoodsId = MI_PromoGoods.GoodsId
        WHERE MI_PromoGoods.AmountPlanMin <> 0
           OR MI_PromoGoods.AmountPlanMax <> 0
           OR tmpDataFact.AmountOut       <> 0
        ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 16.09.21         *
*/

-- ����
--  SELECT * FROM gpReport_Promo_PlanFact(inStartDate := ('01.08.2021')::TDateTime , inEndDate := ('05.08.2021')::TDateTime , inIsPromo := 'False'::Boolean , inIsTender := 'False' ::Boolean,inIsGoodsKind := 'False'::Boolean, inUnitId := 0 ,  inJuridicalId:=0, inSession := '5'::TVarchar) -- where invnumber = 6862


