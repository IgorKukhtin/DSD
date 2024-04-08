
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
    , PersonalTradeName   TVarChar  --������������� ������������� ������������� ������
    , PersonalName        TVarChar  --������������� ������������� �������������� ������	
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
    , GoodsKindName_List  TVarChar  -- 
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
    
    , AmountPlan1_Wh      TFloat -- 
    , AmountPlan2_Wh      TFloat -- 
    , AmountPlan3_Wh      TFloat -- 
    , AmountPlan4_Wh      TFloat -- 
    , AmountPlan5_Wh      TFloat -- 
    , AmountPlan6_Wh      TFloat -- 
    , AmountPlan7_Wh      TFloat -- 
    )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbShowAll Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!������ �������� �������!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

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
    WITH 
    tmpMovement AS (SELECT Movement_Promo.*
                         , MovementDate_StartSale.ValueData            AS StartSale
                         , MovementDate_EndSale.ValueData              AS EndSale
                         , MovementLinkObject_Unit.ObjectId            AS UnitId
                         , COALESCE (MovementBoolean_Promo.ValueData, FALSE)   :: Boolean AS isPromo  -- ����� (��/���)
                         , COALESCE (MovementBoolean_Checked.ValueData, FALSE) :: Boolean AS Checked  -- ����������� (��/���)
                         , MovementLinkObject_PersonalTrade.ObjectId   AS PersonalTradeId
                         , MovementLinkObject_Personal.ObjectId        AS PersonalId
      
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

                         LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalTrade
                                                      ON MovementLinkObject_PersonalTrade.MovementId = Movement_Promo.Id
                                                     AND MovementLinkObject_PersonalTrade.DescId = zc_MovementLinkObject_PersonalTrade()
                 
                         LEFT JOIN MovementLinkObject AS MovementLinkObject_Personal
                                                      ON MovementLinkObject_Personal.MovementId = Movement_Promo.Id
                                                     AND MovementLinkObject_Personal.DescId = zc_MovementLinkObject_Personal()
                                                     
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
  , tmpMovement_PromoPartner_All AS (SELECT Movement_PromoPartner.ParentId
                                          , MI_PromoPartner.ObjectId  AS PartnerId
                                          , Object_Partner.ValueData  AS PartnerName   --STRING_AGG (DISTINCT Object_Partner.ValueData,'; ')   AS PartnerName
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
                                     )
  , tmpMovement_PromoPartner AS (SELECT tmp.ParentId
                                      , STRING_AGG (DISTINCT tmp.PartnerName,'; ')   AS PartnerName
                                 FROM tmpMovement_PromoPartner_All AS tmp
                                 GROUP BY tmp.ParentId
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
                                                   AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                  
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
              
  , tmpGoodsKind AS (SELECT _tmpWord_Split_to.WordList, Object.ValueData :: TVarChar AS GoodsKindName
                     FROM _tmpWord_Split_to 
                          LEFT JOIN Object ON Object.Id = _tmpWord_Split_to.Word :: Integer
                     GROUP BY _tmpWord_Split_to.WordList, Object.ValueData
                     )
                        
                                          
        SELECT
            Movement_Promo.Id  
          , MI_PromoGoods.MovementItemId
          , Movement_Promo.InvNumber   ::integer
          , Object_Unit.ValueData                  AS UnitName 
          , Object_PersonalTrade.ValueData         AS PersonalTradeName  --������������� ������������� ������������� ������
          , Object_Personal.ValueData              AS PersonalName       --������������� ������������� �������������� ������
          
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
          , (SELECT STRING_AGG (DISTINCT tmpGoodsKind.GoodsKindName,'; ')
             FROM tmpMovement_PromoPartner_All AS tmp
                                       
                LEFT JOIN ObjectLink AS ObjectLink_GoodsListSale_Partner
                                     ON ObjectLink_GoodsListSale_Partner.ChildObjectId = tmp.PartnerId
                                    AND ObjectLink_GoodsListSale_Partner.DescId = zc_ObjectLink_GoodsListSale_Partner()
                                     
                INNER JOIN ObjectLink AS ObjectLink_GoodsListSale_Goods
                                     ON ObjectLink_GoodsListSale_Goods.ObjectId = ObjectLink_GoodsListSale_Partner.ObjectId
                                    AND ObjectLink_GoodsListSale_Goods.DescId = zc_ObjectLink_GoodsListSale_Goods()
                                    AND ObjectLink_GoodsListSale_Goods.ChildObjectId = MI_PromoGoods.GoodsId 
                INNER JOIN ObjectString AS ObjectString_GoodsKind
                                        ON ObjectString_GoodsKind.ObjectId = ObjectLink_GoodsListSale_Partner.ObjectId
                                       AND ObjectString_GoodsKind.DescId = zc_ObjectString_GoodsListSale_GoodsKind()
                                       
                LEFT JOIN tmpGoodsKind ON tmpGoodsKind.WordList = ObjectString_GoodsKind.ValueData
             WHERE tmp.ParentId = Movement_Promo.Id
            )                           ::TVarChar AS GoodsKindName_List  
            
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
          
          , (MI_PromoGoods.AmountPlan1 * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END)  ::TFloat AS AmountPlan1_Wh
          , (MI_PromoGoods.AmountPlan2 * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END)  ::TFloat AS AmountPlan2_Wh
          , (MI_PromoGoods.AmountPlan3 * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END)  ::TFloat AS AmountPlan3_Wh
          , (MI_PromoGoods.AmountPlan4 * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END)  ::TFloat AS AmountPlan4_Wh
          , (MI_PromoGoods.AmountPlan5 * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END)  ::TFloat AS AmountPlan5_Wh
          , (MI_PromoGoods.AmountPlan6 * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END)  ::TFloat AS AmountPlan6_Wh
          , (MI_PromoGoods.AmountPlan7 * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END)  ::TFloat AS AmountPlan7_Wh
           
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
             LEFT JOIN Object AS Object_PersonalTrade ON Object_PersonalTrade.Id = Movement_Promo.PersonalTradeId
             LEFT JOIN Object AS Object_Personal ON Object_Personal.Id = Movement_Promo.PersonalId
            
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



