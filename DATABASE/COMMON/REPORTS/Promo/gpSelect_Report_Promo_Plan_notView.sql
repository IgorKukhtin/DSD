
DROP FUNCTION IF EXISTS gpSelect_Report_Promo_Plan(
    TDateTime, --���� ������ �������
    TDateTime, --���� ��������� �������
    Boolean,   --�������� ������ �����
    Boolean,   --�������� ������ �������
    Integer,   --������������� 
    TVarChar   --������ ������������
);

CREATE OR REPLACE FUNCTION gpSelect_Report_Promo_Plan(
    IN inStartDate      TDateTime, --���� ������ �������
    IN inEndDate        TDateTime, --���� ��������� �������
    IN inIsPromo        Boolean,   --�������� ������ �����
    IN inIsTender       Boolean,   --�������� ������ �������
    IN inUnitId         Integer,   --������������� 
    IN inSession        TVarChar   --������ ������������
)
RETURNS TABLE(
      MovementId          Integer   --�� ��������� �����
    , MovementItemId      Integer
    , InvNumber           Integer   --� ��������� �����
    , UnitName            TVarChar  --�����
    , DateStartSale       TDateTime --���� �������� �� ��������� �����
    , DeteFinalSale       TDateTime --���� �������� �� ��������� �����
    , DateStartPromo      TDateTime --���� ���������� �����
    , DateFinalPromo      TDateTime --���� ���������� �����
    , MonthPromo          TDateTime --����� �����
    , PartnerName         TBlob     --�����������
    , GoodsName           TVarChar  --�������
    , GoodsCode           Integer   --��� �������
    , MeasureName         TVarChar  --������� ���������
    , GoodsKindName       TVarChar  --��� ��������
    , TradeMarkName       TVarChar  --�������� �����
    , isPromo             Boolean   --����� (��/���)
    , Checked             Boolean   --����������� (��/���)
    , GoodsWeight         TFloat    --���
    
    , AmountPlan1         TFloat -- ���-�� ���� �������� �� ��.
    , AmountPlan2         TFloat -- ���-�� ���� �������� �� ��.
    , AmountPlan3         TFloat -- ���-�� ���� �������� �� ��.
    , AmountPlan4         TFloat -- ���-�� ���� �������� �� ��.
    , AmountPlan5         TFloat -- ���-�� ���� �������� �� ��.
    , AmountPlan6         TFloat -- ���-�� ���� �������� �� ��.
    , AmountPlan7         TFloat -- ���-�� ���� �������� �� ��.

    )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbShowAll Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
     vbUserId:= lpGetUserBySession (inSession);

    -- ���������
    RETURN QUERY
    WITH 
    tmpMovement AS (SELECT Movement_Promo.*
                         , MovementDate_StartSale.ValueData            AS StartSale
                         , MovementDate_EndSale.ValueData              AS EndSale
                         , MovementLinkObject_Unit.ObjectId            AS UnitId
                         , COALESCE (MovementBoolean_Promo.ValueData, FALSE)   :: Boolean AS isPromo  -- ����� (��/���)
                         , COALESCE (MovementBoolean_Checked.ValueData, FALSE) :: Boolean AS Checked  -- ����������� (��/���)
                    FROM Movement AS Movement_Promo 
                         LEFT JOIN MovementDate AS MovementDate_StartSale
                                                 ON MovementDate_StartSale.MovementId = Movement_Promo.Id
                                                AND MovementDate_StartSale.DescId = zc_MovementDate_StartSale()
                         LEFT JOIN MovementDate AS MovementDate_EndSale
                                                 ON MovementDate_EndSale.MovementId = Movement_Promo.Id
                                                AND MovementDate_EndSale.DescId = zc_MovementDate_EndSale()

                         LEFT JOIN MovementBoolean AS MovementBoolean_Checked
                                                   ON MovementBoolean_Checked.MovementId = Movement_Promo.Id
                                                  AND MovementBoolean_Checked.DescId = zc_MovementBoolean_Checked()
                 
                         LEFT JOIN MovementBoolean AS MovementBoolean_Promo
                                                   ON MovementBoolean_Promo.MovementId = Movement_Promo.Id
                                                  AND MovementBoolean_Promo.DescId = zc_MovementBoolean_Promo()

                         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                      ON MovementLinkObject_Unit.MovementId = Movement_Promo.Id
                                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                              
                    WHERE Movement_Promo.DescId = zc_Movement_Promo()
                     AND ( ( MovementDate_StartSale.ValueData BETWEEN inStartDate AND inEndDate
                            OR
                            inStartDate BETWEEN MovementDate_StartSale.ValueData AND MovementDate_EndSale.ValueData
                           )
                       AND (MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0)
                       AND Movement_Promo.StatusId = zc_Enum_Status_Complete()
                       AND (  (COALESCE (MovementBoolean_Promo.ValueData, FALSE) = TRUE AND inIsPromo = TRUE) 
                           OR (COALESCE (MovementBoolean_Promo.ValueData, FALSE) = FALSE AND inIsTender = TRUE)
                           OR (inIsPromo = FALSE AND inIsTender = FALSE)
                           )
                          )
                   )
  , tmpMovement_PromoPartner AS (SELECT Movement_PromoPartner.ParentId
                                      , STRING_AGG (DISTINCT Object_Partner.ValueData,'; ') AS PartnerName
                                 FROM tmpMovement
                                     LEFT JOIN  Movement AS Movement_PromoPartner
                                                         ON Movement_PromoPartner.ParentId = tmpMovement.Id
                                                          AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
                                                          AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                                     INNER JOIN MovementItem AS MI_PromoPartner
                                                             ON MI_PromoPartner.MovementId = Movement_PromoPartner.Id
                                                            AND MI_PromoPartner.DescId     = zc_MI_Master()
                                                            AND MI_PromoPartner.IsErased   = FALSE
                                     INNER JOIN Object AS Object_Partner ON Object_Partner.Id = MI_PromoPartner.ObjectId
                                 GROUP BY Movement_PromoPartner.ParentId
                               )

  , tmpMI AS (SELECT MI_PromoGoods.Id AS MovementItemId
                   , MI_PromoGoods.MovementId AS MovementId
                   , MI_PromoGoods.ObjectId AS GoodsId
                   , MILinkObject_GoodsKind.ObjectId   AS GoodsKindId
                   , ObjectLink_Goods_Measure.ChildObjectId AS MeasureId
                   , ObjectLink_Goods_TradeMark.ChildObjectId AS TradeMarkId
                   , CASE WHEN ObjectLink_Goods_Measure.ChildObjectId = zc_Measure_Sh() THEN ObjectFloat_Goods_Weight.ValueData ELSE NULL END :: TFloat AS GoodsWeight
                   , MIFloat_Plan1.ValueData                AS AmountPlan1
                   , MIFloat_Plan2.ValueData                AS AmountPlan2
                   , MIFloat_Plan3.ValueData                AS AmountPlan3
                   , MIFloat_Plan4.ValueData                AS AmountPlan4
                   , MIFloat_Plan5.ValueData                AS AmountPlan5
                   , MIFloat_Plan6.ValueData                AS AmountPlan6
                   , MIFloat_Plan7.ValueData                AS AmountPlan7 
              FROM tmpMovement
                   LEFT JOIN MovementItem AS MI_PromoGoods
                                          ON MI_PromoGoods.MovementId = tmpMovement.Id
                                         AND MI_PromoGoods.DescId = zc_MI_Master()
                                         AND MI_PromoGoods.IsErased = FALSE
                   LEFT JOIN MovementItemFloat AS MIFloat_Plan1
                                               ON MIFloat_Plan1.MovementItemId = MI_PromoGoods.Id 
                                              AND MIFloat_Plan1.DescId = zc_MIFloat_Plan1()
                   LEFT JOIN MovementItemFloat AS MIFloat_Plan2
                                               ON MIFloat_Plan2.MovementItemId = MI_PromoGoods.Id 
                                              AND MIFloat_Plan2.DescId = zc_MIFloat_Plan2()
                   LEFT JOIN MovementItemFloat AS MIFloat_Plan3
                                               ON MIFloat_Plan3.MovementItemId = MI_PromoGoods.Id 
                                              AND MIFloat_Plan3.DescId = zc_MIFloat_Plan3()
                   LEFT JOIN MovementItemFloat AS MIFloat_Plan4
                                               ON MIFloat_Plan4.MovementItemId = MI_PromoGoods.Id 
                                              AND MIFloat_Plan4.DescId = zc_MIFloat_Plan4()
                   LEFT JOIN MovementItemFloat AS MIFloat_Plan5
                                               ON MIFloat_Plan5.MovementItemId = MI_PromoGoods.Id 
                                              AND MIFloat_Plan5.DescId = zc_MIFloat_Plan5()
                   LEFT JOIN MovementItemFloat AS MIFloat_Plan6
                                               ON MIFloat_Plan6.MovementItemId = MI_PromoGoods.Id 
                                              AND MIFloat_Plan6.DescId = zc_MIFloat_Plan6()
                   LEFT JOIN MovementItemFloat AS MIFloat_Plan7
                                               ON MIFloat_Plan7.MovementItemId = MI_PromoGoods.Id 
                                              AND MIFloat_Plan7.DescId = zc_MIFloat_Plan7()                                             
           
                   LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind 
                                                    ON MILinkObject_GoodsKind.MovementItemId = MI_PromoGoods.Id
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind() and 1=0
                  
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                        ON ObjectLink_Goods_Measure.ObjectId = MI_PromoGoods.ObjectId
                                         AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
                   
                   LEFT JOIN ObjectLink AS ObjectLink_Goods_TradeMark
                                        ON ObjectLink_Goods_TradeMark.ObjectId = MI_PromoGoods.ObjectId
                                       AND ObjectLink_Goods_TradeMark.DescId = zc_ObjectLink_Goods_TradeMark()
                  
                   LEFT OUTER JOIN ObjectFloat AS ObjectFloat_Goods_Weight
                                               ON ObjectFloat_Goods_Weight.ObjectId = MI_PromoGoods.ObjectId
                                              AND ObjectFloat_Goods_Weight.DescId = zc_ObjectFloat_Goods_Weight()                                  
              )
                                          
        SELECT
            Movement_Promo.Id  
          , MI_PromoGoods.MovementItemId
          , Movement_Promo.InvNumber   ::integer
          , Object_Unit.ValueData                  AS UnitName 
          , Movement_Promo.StartSale                                     --���� ������ �������� �� ��������� ����
          , Movement_Promo.EndSale                                       --���� ��������� �������� �� ��������� ����
          , MovementDate_StartPromo.ValueData      AS StartPromo         --���� ������ �����
          , MovementDate_EndPromo.ValueData        AS EndPromo           --���� ��������� �����
          , MovementDate_Month.ValueData           AS MonthPromo         -- ����� �����

          , Movement_PromoPartner.PartnerName    ::TBlob AS PartnerName
            
          , Object_Goods.ValueData                 AS GoodsName 
          , Object_Goods.ObjectCode::Integer       AS GoodsCode
          , Object_Measure.ValueData               AS Measure
          , Object_GoodsKind.ValueData             AS GoodsKindName 
          , Object_TradeMark.ValueData             AS TradeMark
   
          , Movement_Promo.isPromo
          , Movement_Promo.Checked 

          , MI_PromoGoods.GoodsWeight   :: TFloat
          
          , MI_PromoGoods.AmountPlan1
          , MI_PromoGoods.AmountPlan2
          , MI_PromoGoods.AmountPlan3
          , MI_PromoGoods.AmountPlan4
          , MI_PromoGoods.AmountPlan5
          , MI_PromoGoods.AmountPlan6
          , MI_PromoGoods.AmountPlan7 
           
        FROM tmpMovement AS Movement_Promo
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = Movement_Promo.UnitId
             
             LEFT JOIN MovementDate AS MovementDate_StartPromo
                                     ON MovementDate_StartPromo.MovementId = Movement_Promo.Id
                                    AND MovementDate_StartPromo.DescId = zc_MovementDate_StartPromo()
             LEFT JOIN MovementDate AS MovementDate_EndPromo
                                     ON MovementDate_EndPromo.MovementId =  Movement_Promo.Id
                                    AND MovementDate_EndPromo.DescId = zc_MovementDate_EndPromo()
     
             LEFT JOIN MovementDate AS MovementDate_Month
                                    ON MovementDate_Month.MovementId = Movement_Promo.Id
                                   AND MovementDate_Month.DescId = zc_MovementDate_Month()
             LEFT JOIN tmpMovement_PromoPartner AS Movement_PromoPartner ON Movement_PromoPartner.ParentId = Movement_Promo.Id

             LEFT JOIN tmpMI AS MI_PromoGoods ON MI_PromoGoods.MovementId = Movement_Promo.Id
             LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MI_PromoGoods.GoodsId
             LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MI_PromoGoods.GoodsKindId
             LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = MI_PromoGoods.MeasureId
             LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = MI_PromoGoods.TradeMarkId
        ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
 11.11.17         *
*/

-- ����
-- select * from gpSelect_Report_Promo_Plan(inStartDate := ('01.09.2016')::TDateTime , inEndDate := ('30.06.2017')::TDateTime , inIsPromo := 'True' , inIsTender := 'False' , inUnitId := 0 ,  inSession := '5');



