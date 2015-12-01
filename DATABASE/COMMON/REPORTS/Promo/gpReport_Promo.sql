DROP FUNCTION IF EXISTS gpSelect_Report_Promo(
    TDateTime, --���� ������ �������
    TDateTime, --���� ��������� �������
    Integer,   --������������� 
    TVarChar   --������ ������������
);

CREATE OR REPLACE FUNCTION gpSelect_Report_Promo(
    IN inStartDate      TDateTime, --���� ������ �������
    IN inEndDate        TDateTime, --���� ��������� �������
    IN inUnitId         Integer,   --������������� 
    IN inSession        TVarChar   --������ ������������
)
RETURNS TABLE(
     DateStartSale        TDateTime --���� �������� �� ��������� �����
    ,DeteFinalSale        TDateTime --���� �������� �� ��������� �����
    ,DateStartPromo       TDateTime --���� ���������� �����
    ,DateFinalPromo       TDateTime --���� ���������� �����
    ,RetailName           TBlob     --����, � ������� �������� �����
    ,AreaName             TBlob     --������
    ,GoodsName            TVarChar  --�������
    ,GoodsCode            Integer   --��� �������
    ,MeasureName          TVarChar  --������� ���������
    ,TradeMarkName        TVarChar  --�������� �����
    ,AmountPlanMin        TFloat    --����������� ����� ������ � ��������� ������, ��
    ,AmountPlanMinWeight  TFloat    --����������� ����� ������ � ��������� ������, ��
    ,AmountPlanMax        TFloat    --����������� ����� ������ � ��������� ������, ��
    ,AmountPlanMaxWeight  TFloat    --����������� ����� ������ � ��������� ������, ��
    ,GoodsKindName        TVarChar  --��� ��������
    ,GoodsWeight          TFloat    --���
    ,Discount             TBlob     --������, %
    ,PriceWithOutVAT      TFloat    --����������� ��������� ���� ��� ����� ���, ���
    ,PriceWithVAT         TFloat    --����������� ��������� ���� � ������ ���, ���
    ,Price                TFloat    -- * ���� ������������ � ���, ���
    ,CostPromo            TFloat    -- * ��������� �������
    ,AdvertisingName      TBlob     -- * �������.���������
    ,OperDate             TDateTime -- * ������ �������� � ����
    ,PriceSale            TFloat    -- * ���� �� �����/������ ��� ����������
    ,Comment              TVarChar  --�����������
    ,ShowAll              Boolean   --���������� ��� ������
    )
AS
$BODY$
    DECLARE vbUserId Integer;
    DECLARE vbShowAll Boolean;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_SheetWorkTime());
     vbUserId:= lpGetUserBySession (inSession);

    -- �������� ���������� �������� �� ����� ����������� ���� �������
    vbShowAll:= EXISTS (SELECT 1 FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId IN (112322, 296580, zc_Enum_Role_Admin())); -- ����� ��������� + �������� ��� (����������)

    
    RETURN QUERY
        SELECT
            Movement_Promo.StartSale          --���� ������ �������� �� ��������� ����
          , Movement_Promo.EndSale            --���� ��������� �������� �� ��������� ����
          , Movement_Promo.StartPromo         --���� ������ �����
          , Movement_Promo.EndPromo           --���� ��������� �����
          , (SELECT STRING_AGG(Movement_PromoPartner.Retail_Name,'; ')
             FROM (SELECT DISTINCT Movement_PromoPartner_View.Retail_Name
                   FROM Movement_PromoPartner_View
                   WHERE Movement_PromoPartner_View.ParentId = Movement_Promo.Id
                     AND COALESCE(Movement_PromoPartner_View.Retail_Name,'')<>''
                     AND Movement_PromoPartner_View.isErased = FALSE
                  ) AS Movement_PromoPartner
            )::TBlob AS RetailName
          , (SELECT STRING_AGG(Movement_PromoPartner.AreaName,'; ')
             FROM (SELECT DISTINCT Movement_PromoPartner_View.AreaName
                   FROM Movement_PromoPartner_View
                   WHERE Movement_PromoPartner_View.ParentId = Movement_Promo.Id
                     AND COALESCE(Movement_PromoPartner_View.AreaName,'')<>''
                     AND Movement_PromoPartner_View.isErased = FALSE
                  ) AS Movement_PromoPartner
            )::TBlob AS AreaName
          , MI_PromoGoods.GoodsName
          , MI_PromoGoods.GoodsCode
          , MI_PromoGoods.Measure
          , MI_PromoGoods.TradeMark
          , MI_PromoGoods.AmountPlanMin    --������� ������������ ������ ������ �� ��������� ������ (� ��)
          , MI_PromoGoods.AmountPlanMinWeight --������� ������������ ������ ������ �� ��������� ������ (� ��) ���
          , MI_PromoGoods.AmountPlanMax       --�������� ������������ ������ ������ �� ��������� ������ (� ��)
          , MI_PromoGoods.AmountPlanMaxWeight --�������� ������������ ������ ������ �� ��������� ������ (� ��) ���
          , MI_PromoGoods.GoodsKindName    --������������ ������� <��� ������>
          , CASE WHEN MI_PromoGoods.MeasureId = zc_Measure_Sh() THEN MI_PromoGoods.GoodsWeight ELSE NULL END :: TFloat AS GoodsWeight
          , (REPLACE(TO_CHAR(MI_PromoGoods.Amount,'FM99990D99')||' ','. ','')||'  '||chr(13)||
              (SELECT STRING_AGG(MovementItem_PromoCondition.ConditionPromoName||': '||REPLACE(TO_CHAR(MovementItem_PromoCondition.Amount,'FM999990D09')||' ','.0 ',''), chr(13)) 
               FROM MovementItem_PromoCondition_View AS MovementItem_PromoCondition 
               WHERE MovementItem_PromoCondition.MovementId = Movement_Promo.Id
                 AND MovementItem_PromoCondition.IsErased = FALSE))::TBlob AS Discount
          , MI_PromoGoods.PriceWithOutVAT
          , MI_PromoGoods.PriceWithVAT
          , CASE WHEN vbShowAll THEN MI_PromoGoods.Price END::TFloat AS Price
          , CASE WHEN vbShowAll THEN Movement_Promo.CostPromo END::TFloat as CostPromo
          , CASE WHEN vbShowAll THEN 
                (SELECT STRING_AGG(Movement_PromoAdvertising.AdvertisingName,'; ')
                 FROM (SELECT DISTINCT Movement_PromoAdvertising_View.AdvertisingName
                       FROM Movement_PromoAdvertising_View
                       WHERE Movement_PromoAdvertising_View.ParentId = Movement_Promo.Id
                         AND COALESCE(Movement_PromoAdvertising_View.AdvertisingName,'')<>''
                         AND Movement_PromoAdvertising_View.isErased = FALSE
                      ) AS Movement_PromoAdvertising
                ) END::TBlob AS AdvertisingName
          , CASE WHEN vbShowAll THEN Movement_Promo.OperDate END::TDateTime AS OperDate
          , CASE WHEN vbShowAll THEN MI_PromoGoods.PriceSale END::TFloat AS PriceSale
          , Movement_Promo.Comment
          , vbShowAll as ShowAll
        FROM
            Movement_Promo_View AS Movement_Promo
            LEFT OUTER JOIN MovementItem_PromoGoods_View AS MI_PromoGoods
                                                         ON MI_PromoGoods.MovementId = Movement_Promo.Id
                                                        AND MI_PromoGoods.IsErased = FALSE
        WHERE
            (
                Movement_Promo.EndSale BETWEEN inStartDate AND inEndDate
                /*Movement_Promo.StartSale BETWEEN inStartDate AND inEndDate
                OR
                inStartDate BETWEEN Movement_Promo.StartSale AND Movement_Promo.EndSale*/
            )
            AND
            (
                Movement_Promo.UnitId = inUnitId
                OR
                COALESCE (inUnitId, 0) = 0
            );
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Report_Promo (TDateTime,TDateTime,Integer,TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ��������� �.�.
 01.12.15                                                          *
*/
--Select * from gpSelect_Report_Promo('20150101','20160101',0,'5');
