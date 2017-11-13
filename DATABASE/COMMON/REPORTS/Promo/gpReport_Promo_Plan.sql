
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
  /*  WITH 
    tmpMovement AS (SELECT Movement_Promo.*
                         , MovementDate_StartSale.ValueData            AS StartSale
                         , MovementDate_EndSale.ValueData              AS EndSale
                         , MovementLinkObject_Unit.ObjectId            AS UnitId
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
     
                         LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                                      ON MovementLinkObject_Unit.MovementId = Movement_Promo.Id
                                                     AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                         LEFT JOIN Object AS Object_Unit 
                                         ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId
                              
                    WHERE Movement_Promo.DescId = zc_Movement_Promo()
                     AND ( ( Movement_Promo.StartSale BETWEEN inStartDate AND inEndDate
                            OR
                            inStartDate BETWEEN Movement_Promo.StartSale AND Movement_Promo.EndSale
                           )
                       AND (Movement_Promo.UnitId = inUnitId OR inUnitId = 0)
                       AND Movement_Promo.StatusId = zc_Enum_Status_Complete()
                       AND (  (Movement_Promo.isPromo = TRUE AND inIsPromo = TRUE) 
                           OR (COALESCE (Movement_Promo.isPromo, FALSE) = FALSE AND inIsTender = TRUE)
                           OR (inIsPromo = FALSE AND inIsTender = FALSE)
                           )
                          )
                   )
           , tmpMovement_PromoPartner AS (SELECT Movement_PromoPartner.Id                                          --�������������
                                               , Movement_PromoPartner.StatusId
                                               , Object_Status.ObjectCode               AS StatusCode
                                               , Object_Status.ValueData                AS StatusName 
                                               , Movement_PromoPartner.ParentId                                    --������ �� �������� �������� <�����> (zc_Movement_Promo)
                                               , Object_Partner.ValueData               AS PartnerName             --���������� ��� �����
                                               , ObjectDesc_Partner.ItemName            AS PartnerDescName         --��� ���������� ��� �����
                                               , Object_Contract.ValueData              AS ContractName            --������������ ���������
                                               , Object_ContractTag.ValueData           AS ContractTagName         --������� ���������
                                               
                                          FROM tmpMovement
                                               LEFT JOIN Movement AS Movement_PromoPartner ON Movement_PromoPartner.ParentId = tmpMovement.Id
                                                                                          AND Movement_PromoPartner.DescId = zc_Movement_PromoPartner()
                                                                                          AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
                                               LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement_PromoPartner.StatusId
                                               
                                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Partner
                                                                            ON MovementLinkObject_Partner.MovementId = Movement_PromoPartner.Id
                                                                           AND MovementLinkObject_Partner.DescId = zc_MovementLinkObject_Partner()
                                               LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = MovementLinkObject_Partner.ObjectId
                                               LEFT OUTER JOIN ObjectDesc AS ObjectDesc_Partner ON ObjectDesc_Partner.Id = Object_Partner.DescId
                                       
                                               LEFT JOIN MovementLinkObject AS MovementLinkObject_Contract
                                                                            ON MovementLinkObject_Contract.MovementId = Movement_PromoPartner.Id
                                                                           AND MovementLinkObject_Contract.DescId = zc_MovementLinkObject_Contract()
                                               LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MovementLinkObject_Contract.ObjectId
                                               
                                               LEFT JOIN ObjectLink AS ObjectLink_Contract_ContractTag
                                                                    ON ObjectLink_Contract_ContractTag.ObjectId = Object_Contract.Id
                                                                   AND ObjectLink_Contract_ContractTag.DescId = zc_ObjectLink_Contract_ContractTag()
                                               LEFT JOIN Object AS Object_ContractTag ON Object_ContractTag.Id = ObjectLink_Contract_ContractTag.ChildObjectId
                                          )*/
                                          
        SELECT
            Movement_Promo.Id                 --�� ��������� �����
          , MI_PromoGoods.Id                        AS MovementItemId
          , Movement_Promo.InvNumber          --� ��������� �����
          , Movement_Promo.UnitName           --�����
          , Movement_Promo.StartSale          --���� ������ �������� �� ��������� ����
          , Movement_Promo.EndSale            --���� ��������� �������� �� ��������� ����
          , Movement_Promo.StartPromo         --���� ������ �����
          , Movement_Promo.EndPromo           --���� ��������� �����
          , Movement_Promo.MonthPromo         --����� �����

          , (SELECT STRING_AGG (DISTINCT Object_Partner.ValueData,'; ')
             FROM
                Movement AS Movement_PromoPartner
                INNER JOIN MovementItem AS MI_PromoPartner
                                        ON MI_PromoPartner.MovementId = Movement_PromoPartner.Id
                                       AND MI_PromoPartner.DescId     = zc_MI_Master()
                                       AND MI_PromoPartner.IsErased   = FALSE
                INNER JOIN Object AS Object_Partner ON Object_Partner.Id = MI_PromoPartner.ObjectId
                
             WHERE Movement_PromoPartner.ParentId = Movement_Promo.Id
               AND Movement_PromoPartner.DescId   = zc_Movement_PromoPartner()
               AND Movement_PromoPartner.StatusId <> zc_Enum_Status_Erased()
            )::TBlob AS PartnerName
            
          , MI_PromoGoods.GoodsName
          , MI_PromoGoods.GoodsCode
          , MI_PromoGoods.Measure
          , MI_PromoGoods.GoodsKindName
          , MI_PromoGoods.TradeMark
          , Movement_Promo.isPromo                 AS isPromo
          , Movement_Promo.Checked                 AS Checked

          , CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE NULL END :: TFloat AS GoodsWeight
          
          , MIFloat_Plan1.ValueData                AS AmountPlan1
          , MIFloat_Plan2.ValueData                AS AmountPlan2
          , MIFloat_Plan3.ValueData                AS AmountPlan3
          , MIFloat_Plan4.ValueData                AS AmountPlan4
          , MIFloat_Plan5.ValueData                AS AmountPlan5
          , MIFloat_Plan6.ValueData                AS AmountPlan6
          , MIFloat_Plan7.ValueData                AS AmountPlan7 
           
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
-- select * from gpSelect_Report_Promo_Plan(inStartDate := ('01.09.2016')::TDateTime , inEndDate := ('30.06.2017')::TDateTime , inIsPromo := 'True' , inIsTender := 'False' , inUnitId := 0 ,  inSession := '5');



