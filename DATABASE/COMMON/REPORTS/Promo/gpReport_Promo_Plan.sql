
DROP FUNCTION IF EXISTS gpSelect_Report_Promo_Plan_Plan(
    TDateTime, --���� ������ �������
    TDateTime, --���� ��������� �������
    Integer,   --������������� 
    TVarChar   --������ ������������
);
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
    , UnitCode_PersonalTrade    Integer
    , UnitName_PersonalTrade    TVarChar
    , BranchCode_PersonalTrade  Integer
    , BranchName_PersonalTrade  TVarChar
    , PersonalName        TVarChar  --������������� ������������� �������������� ������	
    , DateStartSale       TDateTime --���� �������� �� ��������� �����
    , DeteFinalSale       TDateTime --���� �������� �� ��������� �����
    , DateStartPromo      TDateTime --���� ���������� �����
    , DateFinalPromo      TDateTime --���� ���������� �����
    , MonthPromo          TDateTime --����� �����
    , RetailName          TBlob     --�����������
    , PartnerName         TBlob     --�����������
    , GoodsName           TVarChar  --�������
    , GoodsCode           Integer   --��� �������
    , MeasureName         TVarChar  --������� ���������
    , GoodsKindName       TVarChar  --��� ��������
    , GoodsKindName_List  TVarChar  --��� ������ (���������)
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
     
    , isPlan1             Boolean
    , isPlan2             Boolean
    , isPlan3             Boolean
    , isPlan4             Boolean
    , isPlan5             Boolean
    , isPlan6             Boolean
    , isPlan7             Boolean
    )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbShowAll Boolean;
    DECLARE vbDayStart integer;
    DECLARE vbDayEnd integer;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
     vbUserId:= lpGetUserBySession (inSession);


     vbDayStart := CASE EXTRACT (DOW FROM inStartDate) WHEN 0 THEN 7 ELSE EXTRACT (DOW FROM inStartDate) END  ::integer;
     vbDayEnd   := CASE EXTRACT (DOW FROM inEndDate)   WHEN 0 THEN 7 ELSE EXTRACT (DOW FROM inEndDate) END  ::integer;
     
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
                           
        SELECT
            Movement_Promo.Id                 --�� ��������� �����
          , MI_PromoGoods.Id                        AS MovementItemId
          , Movement_Promo.InvNumber          --� ��������� �����
          , Movement_Promo.UnitName           --�����
          , Movement_Promo.PersonalTradeName  --������������� ������������� ������������� ������
          
          , Object_Unit.ObjectCode              AS UnitCode_PersonalTrade
          , Object_Unit.ValueData               AS UnitName_PersonalTrade
          , Object_Branch.ObjectCode            AS BranchCode_PersonalTrade
          , Object_Branch.ValueData             AS BranchName_PersonalTrade
          
          , Movement_Promo.PersonalName       --������������� ������������� �������������� ������
          , Movement_Promo.StartSale          --���� ������ �������� �� ��������� ����
          , Movement_Promo.EndSale            --���� ��������� �������� �� ��������� ����
          , Movement_Promo.StartPromo         --���� ������ �����
          , Movement_Promo.EndPromo           --���� ��������� �����
          , Movement_Promo.MonthPromo         --����� �����

          , COALESCE ((SELECT STRING_AGG (DISTINCT COALESCE (MovementString_Retail.ValueData, Object_Retail.ValueData),'; ')
                       FROM Movement AS Movement_PromoPartner
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
                ))::TBlob AS RetailName
            , RetailName AS PartnerName
 
          , MI_PromoGoods.GoodsName
          , MI_PromoGoods.GoodsCode
          , MI_PromoGoods.Measure
          , MI_PromoGoods.GoodsKindName

          , (SELECT STRING_AGG (DISTINCT tmpGoodsKind.GoodsKindName,'; ')
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
            
          , MI_PromoGoods.TradeMark
          , Movement_Promo.isPromo                 AS isPromo
          , Movement_Promo.Checked                 AS Checked

          , CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE NULL END :: TFloat AS GoodsWeight
          
                   
          , CASE WHEN vbDayStart  = 1 THEN MIFloat_Plan1.ValueData ELSE 0 END  ::TFloat   AS AmountPlan1
          , CASE WHEN vbDayStart <= 2 AND vbDayEnd >= 2 THEN MIFloat_Plan2.ValueData ELSE 0 END  ::TFloat  AS AmountPlan2
          , CASE WHEN vbDayStart <= 3 AND vbDayEnd >= 3 THEN MIFloat_Plan3.ValueData ELSE 0 END  ::TFloat  AS AmountPlan3
          , CASE WHEN vbDayStart <= 4 AND vbDayEnd >= 4 THEN MIFloat_Plan4.ValueData ELSE 0 END  ::TFloat  AS AmountPlan4
          , CASE WHEN vbDayStart <= 5 AND vbDayEnd >= 5 THEN MIFloat_Plan5.ValueData ELSE 0 END  ::TFloat  AS AmountPlan5
          , CASE WHEN vbDayStart <= 6 AND vbDayEnd >= 6 THEN MIFloat_Plan6.ValueData ELSE 0 END  ::TFloat  AS AmountPlan6
          , CASE WHEN vbDayStart <= 7 AND vbDayEnd  = 7 THEN MIFloat_Plan7.ValueData ELSE 0 END  ::TFloat  AS AmountPlan7
          
          , (CASE WHEN vbDayStart  = 1 THEN MIFloat_Plan1.ValueData ELSE 0 END  * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END)  ::TFloat AS AmountPlan1_Wh
          , (CASE WHEN vbDayStart <= 2 AND vbDayEnd >= 2 THEN MIFloat_Plan2.ValueData ELSE 0 END * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END)  ::TFloat AS AmountPlan2_Wh
          , (CASE WHEN vbDayStart <= 3 AND vbDayEnd >= 3 THEN MIFloat_Plan3.ValueData ELSE 0 END * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END)  ::TFloat AS AmountPlan3_Wh
          , (CASE WHEN vbDayStart <= 4 AND vbDayEnd >= 4 THEN MIFloat_Plan4.ValueData ELSE 0 END * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END)  ::TFloat AS AmountPlan4_Wh
          , (CASE WHEN vbDayStart <= 5 AND vbDayEnd >= 5 THEN MIFloat_Plan5.ValueData ELSE 0 END * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END)  ::TFloat AS AmountPlan5_Wh
          , (CASE WHEN vbDayStart <= 6 AND vbDayEnd >= 6 THEN MIFloat_Plan6.ValueData ELSE 0 END * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END)  ::TFloat AS AmountPlan6_Wh
          , (CASE WHEN vbDayStart <= 7 AND vbDayEnd  = 7 THEN MIFloat_Plan7.ValueData ELSE 0 END * CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN COALESCE (MI_PromoGoods.GoodsWeight, 0) ELSE 1 END)  ::TFloat AS AmountPlan7_Wh
           
          , CASE WHEN vbDayStart  = 1                   THEN TRUE ELSE FALSE END  ::Boolean  AS isPlan1
          , CASE WHEN vbDayStart <= 2 AND vbDayEnd >= 2 THEN TRUE ELSE FALSE END  ::Boolean  AS isPlan2
          , CASE WHEN vbDayStart <= 3 AND vbDayEnd >= 3 THEN TRUE ELSE FALSE END  ::Boolean  AS isPlan3
          , CASE WHEN vbDayStart <= 4 AND vbDayEnd >= 4 THEN TRUE ELSE FALSE END  ::Boolean  AS isPlan4
          , CASE WHEN vbDayStart <= 5 AND vbDayEnd >= 5 THEN TRUE ELSE FALSE END  ::Boolean  AS isPlan5
          , CASE WHEN vbDayStart <= 6 AND vbDayEnd >= 6 THEN TRUE ELSE FALSE END  ::Boolean  AS isPlan6
          , CASE WHEN vbDayStart <= 7 AND vbDayEnd  = 7 THEN TRUE ELSE FALSE END  ::Boolean  AS isPlan7
          
        FROM Movement_Promo_View AS Movement_Promo
            LEFT OUTER JOIN MovementItem_PromoGoods_View AS MI_PromoGoods
                                                         ON MI_PromoGoods.MovementId = Movement_Promo.Id
                                                        AND MI_PromoGoods.IsErASed = FALSE
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

            LEFT JOIN ObjectLink AS ObjectLink_Personal_Unit
                                 ON ObjectLink_Personal_Unit.ObjectId = Movement_Promo.PersonalTradeId
                                AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Personal_Unit.ChildObjectId
       
            LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                                 ON ObjectLink_Unit_Branch.ObjectId = Object_Unit.Id
                                AND ObjectLink_Unit_Branch.DescId = zc_ObjectLink_Unit_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = ObjectLink_Unit_Branch.ChildObjectId
                        
        WHERE ( Movement_Promo.StartSale BETWEEN inStartDate AND inEndDate
                OR
                inStartDate BETWEEN Movement_Promo.StartSale AND Movement_Promo.EndSale
               )
           AND (Movement_Promo.UnitId = inUnitId OR inUnitId = 0)
           AND Movement_Promo.StatusId = zc_Enum_Status_Complete()
           AND (  (Movement_Promo.isPromo = TRUE AND inIsPromo = TRUE)
               OR (COALESCE (Movement_Promo.isPromo, FALSE) = FALSE AND inIsTender = TRUE)
               OR (inIsPromo = FALSE AND inIsTender = FALSE)
               )
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
-- SELECT * FROM gpSelect_Report_Promo_Plan (inStartDate:= '01.09.2017', inEndDate:= '01.09.2017', inIsPromo:= True, inIsTender:= False, inUnitId:= 0, inSession:= zfCalc_UserAdmin());
