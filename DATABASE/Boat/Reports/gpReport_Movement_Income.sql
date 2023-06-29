-- Function:  gpReport_MovementIncome()

DROP FUNCTION IF EXISTS gpReport_MovementIncome (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_MovementIncome(
    IN inStartDate        TDateTime,  -- ���� ������
    IN inEndDate          TDateTime,  -- ���� ���������
    IN inUnitId           Integer  ,  -- ������������� / ������
    IN inPartnerId        Integer  ,  -- ���������
    IN inGoodsGroupId     Integer  ,  -- ������ ������
    IN inIsPartion        Boolean  ,  -- �������� <�������� ������ �> (��/���)
    IN inIsPartner        Boolean  ,  -- �������� ���������� (��/���)
    IN inSession          TVarChar    -- ������ ������������
)
RETURNS TABLE (PartionId            Integer
             , MovementId_Partion   Integer
             , InvNumber_Partion    TVarChar
             , InvNumberAll_Partion TVarChar
             , InvNumberPack_Partion TVarChar
             , InvNumberInvoice_Partion TVarChar
             , InvNumberPartner_Partion TVarChar
             , OperDatePartner_Partion TDateTime
             , OperDate_Partion     TDateTime                
             , DescName_Partion     TVarChar 
             , UnitId               Integer
             , UnitName             TVarChar
             , UnitName_in          TVarChar
             , PartnerName          TVarChar
             --, BrandName            TVarChar
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Article TVarChar , Article_all TVarChar
             , GoodsGroupNameFull TVarChar, GoodsGroupName TVarChar, MeasureName TVarChar

             , GoodsTagName         TVarChar
             , GoodsTypeName        TVarChar
             , ProdColorName        TVarChar
             , TaxKindName          TVarChar
             , GoodsSizeId          Integer
             , GoodsSizeName        TVarChar
             , GoodsSizeName_real   TVarChar

             , Amount       TFloat
             , Summ         TFloat

             , Amount_in               TFloat -- ����� ���-�� ������ �� ����������
             , OperPrice               TFloat -- ���� ��. 
             , CountForPrice           TFloat -- ���. � ���� ��.
             , OperPriceList           TFloat -- ���� �� ������   
             , OperPrice_cost          TFloat -- ����� �������
             , CostPrice               TFloat -- ���� �� + �������
             , Remains                 TFloat -- ���-�� - �������
             , TotalSummEKPrice        TFloat -- ����� �� ������� �����
             , TotalSummPriceList      TFloat -- ����� �� ������
             , Summ_Cost               TFloat -- ����� ������
             , TotalSumm_Cost          TFloat -- ����� ��+ �������
             , PriceTax                TFloat -- % ������ !!!��!!! zc_DateEnd
                    
             , OperPrice_orig TFloat        -- ��. ���� ��� ������  
             , DiscountTax    TFloat    -- % ������             
             , SummIn                  TFloat    -- ����� ��., � ������ ������ � ��������
 
             , Comment_in       TVarChar
             , DiscountTax_in   TFloat
             , TotalDiscountTax_in TFloat
             , VATPercent_in    TFloat
           
              ) 
AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbIsOperPrice Boolean;
   DECLARE vbPriceListName_Basis TVarChar;
BEGIN
    -- �������� ���� ������������ �� ����� ���������
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_...());
    vbUserId:= lpGetUserBySession (inSession);

    -- �������� - ���������� �� ���� ��.
    --vbIsOperPrice:= lpCheckOperPrice_visible (vbUserId) OR vbUserId = 1078646;

    -- ��� ����������� ���������� ��� ��������� ����� ���� �����
    vbPriceListName_Basis := (SELECT Object.ValueData FROM Object WHERE Object.Id = zc_PriceList_Basis()) ::TVarChar;

    -- !!!������!!!
    IF inIsPartion = TRUE THEN
       inIsPartner:= TRUE;
    END IF;

    -- ������ �������������
    CREATE TEMP TABLE _tmpUnit (UnitId Integer) ON COMMIT DROP;
    IF COALESCE (inUnitId, 0) <> 0
    THEN
        --
        INSERT INTO _tmpUnit (UnitId)
          SELECT lfSelect.UnitId
          FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect;
    ELSE
        --
        INSERT INTO _tmpUnit (UnitId)
          SELECT Object_Unit.Id
          FROM Object AS Object_Unit
          WHERE Object_Unit.DescId = zc_Object_Unit()
            AND Object_Unit.isErased = FALSE;
    END IF;


    -- ����������� �� ������
    CREATE TEMP TABLE _tmpGoods (GoodsId Integer) ON COMMIT DROP;
    IF inGoodsGroupId <> 0 
    THEN 
        INSERT INTO _tmpGoods (GoodsId)
           SELECT lfSelect.GoodsId
           FROM lfSelect_Object_Goods_byGoodsGroup (inGoodsGroupId) AS lfSelect;
    ELSE 
        INSERT INTO _tmpGoods (GoodsId)
           SELECT Object_Goods.Id
           FROM Object AS Object_Goods
           WHERE Object_Goods.DescId = zc_Object_Goods()
            AND Object_Goods.isErased = FALSE;
    END IF;

    -- !!!!!!!!!!!!!!!!!!!!!!!
    ANALYZE _tmpGoods;
    ANALYZE _tmpUnit;

    -- ���������
    RETURN QUERY
    WITH 
     tmpPriceBasis AS (SELECT tmp.GoodsId
                            , tmp.ValuePrice
                       FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= zc_PriceList_Basis()
                                                                , inOperDate   := CURRENT_DATE) AS tmp
                            INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = tmp.GoodsId
                       )

   --������ �� �������� �� ��������
   , tmpMIContainer AS (SELECT MIContainer.MovementId
                             , MIContainer.PartionId
                             , MIContainer.ObjectId_Analyzer      AS GoodsId
                             , MIContainer.ObjectExtId_Analyzer   AS PartnerId
                             , MIContainer.WhereObjectId_Analyzer AS UnitId
                             , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Count() AND MIContainer.isActive = TRUE
                                              THEN MIContainer.Amount
                                         ELSE 0
                                    END) AS Amount
       
                             , SUM (CASE WHEN MIContainer.DescId = zc_MIContainer_Summ() AND MIContainer.isActive = TRUE
                                              THEN MIContainer.Amount
                                         ELSE 0
                                    END) AS Summ  
                              
                             -- ����� ��. � ������ ������ � ��������
                             , SUM (COALESCE (MIFloat_SummIn.ValueData, 0))   AS SummIn
                              
                              --���� ��� ������
                             , COALESCE (MIFloat_OperPrice_orig.ValueData, 0) AS OperPrice_orig 
                             -- % ������
                             , COALESCE (MIFloat_DiscountTax.ValueData, 0)    AS DiscountTax
                        FROM MovementItemContainer AS MIContainer
                             INNER JOIN _tmpUnit ON _tmpUnit.UnitId = MIContainer.WhereObjectId_Analyzer
                             INNER JOIN _tmpGoods ON _tmpGoods.GoodsId = MIContainer.ObjectId_analyzer   


                             LEFT JOIN MovementItemFloat AS MIFloat_OperPrice_orig
                                                         ON MIFloat_OperPrice_orig.MovementItemId = MIContainer.MovementItemId
                                                        AND MIFloat_OperPrice_orig.DescId = zc_MIFloat_OperPrice_orig()
                             LEFT JOIN MovementItemFloat AS MIFloat_DiscountTax
                                                         ON MIFloat_DiscountTax.MovementItemId = MIContainer.MovementItemId
                                                        AND MIFloat_DiscountTax.DescId = zc_MIFloat_DiscountTax()
                             LEFT JOIN MovementItemFloat AS MIFloat_SummIn
                                                         ON MIFloat_SummIn.MovementItemId = MIContainer.MovementItemId
                                                        AND MIFloat_SummIn.DescId = zc_MIFloat_SummIn()                             
                             
                        WHERE MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                          AND MIContainer.MovementDescId = zc_Movement_Income()
                          AND (MIContainer.ObjectExtId_Analyzer = inPartnerId OR inPartnerId = 0)
                        GROUP BY MIContainer.ObjectId_Analyzer
                               , MIContainer.WhereObjectId_Analyzer
                               , MIContainer.ObjectExtId_Analyzer
                               , MIContainer.MovementId
                               , MIContainer.PartionId
                               , COALESCE (MIFloat_OperPrice_orig.ValueData, 0)
                               , COALESCE (MIFloat_DiscountTax.ValueData, 0)
                       )
 
   --�������
   , tmpRemains AS (SELECT Container.ObjectId
                         , Container.PartionId
                         , Container.WhereObjectId AS UnitId
                         , COALESCE(Container.Amount,0) AS Amount
                    FROM Container
                         INNER JOIN _tmpUnit ON _tmpUnit.UnitId = Container.WhereObjectId
                     WHERE Container.DescId = zc_Container_Count()
                      AND COALESCE(Container.Amount,0) <> 0
                      AND Container.ObjectId IN (SELECT DISTINCT tmpMIContainer.GoodsId FROM tmpMIContainer)
                    )
    -- ����� 
   , tmpObject_PartionGoods AS (SELECT Object_PartionGoods.*
                                FROM Object_PartionGoods
                                WHERE Object_PartionGoods.ObjectId IN (SELECT DISTINCT tmpMIContainer.GoodsId FROM tmpMIContainer)
                                )

   -- ������ + ������� + ������
   , tmpData AS (SELECT tmpMIContainer.UnitId
                     , tmpMIContainer.PartionId
                     , tmpMIContainer.GoodsId
                     , tmpMIContainer.PartnerId

                     , Object_PartionGoods.GoodsSizeId
                     , Object_PartionGoods.MeasureId
                     , Object_PartionGoods.GoodsGroupId
                     , Object_PartionGoods.GoodsTagId
                     , Object_PartionGoods.GoodsTypeId
                     , Object_PartionGoods.ProdColorId
                     , Object_PartionGoods.TaxKindId
                     , Object_PartionGoods.TaxValue AS TaxKindValue
 
                     , tmpMIContainer.MovementId

                     , COALESCE (tmpMIContainer.Amount, 0) AS Amount  -- �� ��������
                     , COALESCE (tmpRemains.Amount, 0)     AS Remains
                     , COALESCE (tmpMIContainer.Summ, 0)   AS Summ    -- �� �������� 
                     , COALESCE (tmpMIContainer.OperPrice_orig, 0) AS OperPrice_orig
                     , COALESCE (tmpMIContainer.DiscountTax, 0)    AS DiscountTax
                     , COALESCE (tmpMIContainer.SummIn, 0)         AS SummIn

                     , Object_PartionGoods.EKPrice
                     , Object_PartionGoods.CountForPrice
 
                     , COALESCE (tmpPriceBasis.ValuePrice, Object_PartionGoods.OperPriceList) AS OperPriceList
 
                       -- ���� ��� ��� �������
                     , Object_PartionGoods.CostPrice     ::TFloat
                       -- ���� ��. � ��������� ��� ���
                     , (Object_PartionGoods.EKPrice / Object_PartionGoods.CountForPrice + COALESCE (Object_PartionGoods.CostPrice,0) ) ::TFloat AS OperPrice_cost
        
                     , Object_PartionGoods.Amount     AS Amount_in
                     , Object_PartionGoods.UnitId     AS UnitId_in
                     
                       --  � �/� - ������ ��� = 1 ������� Amount_in
                     , ROW_NUMBER() OVER (PARTITION BY tmpMIContainer.PartionId ORDER BY CASE WHEN tmpMIContainer.UnitId = Object_PartionGoods.UnitId THEN 0 ELSE 1 END ASC) AS Ord
 
                FROM tmpMIContainer
                     LEFT JOIN tmpRemains ON tmpRemains.PartionId = tmpMIContainer.PartionId
                                         AND tmpRemains.ObjectId  = tmpMIContainer.GoodsId
                                         AND tmpRemains.UnitId    = tmpMIContainer.UnitId
 
                     LEFT JOIN Object_PartionGoods ON Object_PartionGoods.MovementItemId = tmpMIContainer.PartionId
                                                  AND Object_PartionGoods.ObjectId       = tmpMIContainer.GoodsId
                                                  AND Object_PartionGoods.UnitId         = tmpMIContainer.UnitId
                                                  AND Object_PartionGoods.isErased       = FALSE

                      -- ���� �� �����-�����
                     LEFT JOIN tmpPriceBasis ON tmpPriceBasis.GoodsId = tmpMIContainer.GoodsId
                )
 --
       , tmpMovementString AS (SELECT MovementString.*
                               FROM MovementString
                               WHERE MovementString.MovementId IN (SELECT DISTINCT tmpData.MovementId FROM tmpData)
                                 AND MovementString.DescId = zc_MovementString_Comment()
                                 AND inisPartion = TRUE
                              )
       , tmpMovementFloat AS (SELECT MovementFloat.*
                               FROM MovementFloat
                               WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpData.MovementId FROM tmpData)
                                 AND MovementFloat.DescId IN (zc_MovementFloat_DiscountTax()
                                                            , zc_MovementFloat_VATPercent()
                                                            ,  zc_MovementFloat_TotalDiscountTax()
                                                            )
                                 AND inisPartion = TRUE
                               )

       , tmpData_All AS (SELECT tmpData.UnitId
                              , tmpData.GoodsId
                              , CASE WHEN inisPartion = TRUE THEN tmpData.PartionId        ELSE 0  END AS PartionId
                              , CASE WHEN inisPartion = TRUE THEN tmpData.MovementId       ELSE 0  END AS MovementId_Partion
                              , CASE WHEN inisPartion = TRUE THEN MovementDesc_Partion.ItemName ELSE '' END AS DescName_Partion
                              , CASE WHEN inisPartion = TRUE THEN Movement_Partion.InvNumber    ELSE '' END AS InvNumber_Partion 
                              , MovementString_InvNumberPack.ValueData                                      AS InvNumberPack_Partion
                              , MovementString_InvNumberInvoice.ValueData                                   AS InvNumberInvoice_Partion
                              , MovementString_InvNumberPartner.ValueData                                   AS InvNumberPartner_Partion
                              , CASE WHEN inisPartion = TRUE THEN Movement_Partion.OperDate     ELSE zc_DateStart() END AS OperDate_Partion
                              , MovementDate_OperDatePartner.ValueData                                      AS OperDatePartner_Partion 
                              
                              , CASE WHEN inisPartner = TRUE THEN tmpData.PartnerId        ELSE 0  END AS PartnerId
                              , tmpData.GoodsSizeId
                              --, tmpData.BrandId
                              , tmpData.MeasureId
                              , tmpData.GoodsGroupId
                              , tmpData.GoodsTagId
                              , tmpData.GoodsTypeId
                              , tmpData.ProdColorId
                              , tmpData.TaxKindId
                              , tmpData.TaxKindValue
                              , tmpData.EKPrice
                              , tmpData.OperPriceList
                              , tmpData.OperPrice_cost
                              , tmpData.CostPrice
                              , tmpData.CountForPrice
                              , tmpData.UnitId_in

                              , tmpData.OperPrice_orig
                              , tmpData.DiscountTax
                              , SUM (COALESCE (tmpData.SummIn, 0))  AS SummIn
                              
                              , SUM (COALESCE (tmpData.Amount, 0))  AS Amount  -- �� ��������
                              , SUM (COALESCE (tmpData.Summ, 0))    AS Summ    -- �� ��������

                          
                                --  ������ ��� Ord = 1
                              , SUM (CASE WHEN tmpData.Ord = 1 THEN tmpData.Amount_in ELSE 0 END) AS Amount_in
                              --, SUM (CASE WHEN tmpData.Ord = 1 THEN zfCalc_SummIn (tmpData.Amount_in, tmpData.EKPrice, tmpData.CountForPrice) ELSE 0 END) AS TotalSummEKPrice
                              , SUM (tmpData.Remains)         AS Remains
                              , SUM (zfCalc_SummIn        (tmpData.Amount, tmpData.EKPrice, tmpData.CountForPrice)) AS TotalSummEKPrice
                              , SUM (zfCalc_SummPriceList (tmpData.Amount, tmpData.OperPriceList))                  AS TotalSummPriceList

                              , MS_Comment.ValueData                        AS Comment_in
                              , COALESCE (MF_DiscountTax.ValueData, 0)      AS DiscountTax_in 
                              , COALESCE (MovementFloat_TotalDiscountTax.ValueData, 0)  :: TFloat AS TotalDiscountTax_in
                              , COALESCE (MF_VATPercent.ValueData, 0)       AS VATPercent_in  
                              
                         FROM tmpData
                              LEFT JOIN Movement AS Movement_Partion ON Movement_Partion.Id = tmpData.MovementId
                              LEFT JOIN MovementDesc AS MovementDesc_Partion ON MovementDesc_Partion.Id = Movement_Partion.DescId

                              LEFT JOIN tmpMovementString AS MS_Comment
                                                          ON MS_Comment.MovementId = tmpData.MovementId
                                                         AND MS_Comment.DescId = zc_MovementString_Comment()
                                                         AND inisPartion = TRUE
                              LEFT JOIN tmpMovementFloat AS MF_DiscountTax
                                                         ON MF_DiscountTax.MovementId = tmpData.MovementId
                                                        AND MF_DiscountTax.DescId     = zc_MovementFloat_DiscountTax()
                                                        AND inisPartion                 = TRUE
                              LEFT JOIN tmpMovementFloat AS MF_VATPercent
                                                         ON MF_VATPercent.MovementId = tmpData.MovementId
                                                        AND MF_VATPercent.DescId     = zc_MovementFloat_VATPercent()
                                                        AND inisPartion            = TRUE 

                              LEFT JOIN tmpMovementFloat AS MovementFloat_TotalDiscountTax
                                                      ON MovementFloat_TotalDiscountTax.MovementId = tmpData.MovementId
                                                     AND MovementFloat_TotalDiscountTax.DescId = zc_MovementFloat_TotalDiscountTax()
                                                     AND inisPartion            = TRUE
                              
                              LEFT JOIN MovementString AS MovementString_InvNumberPack
                                                       ON MovementString_InvNumberPack.MovementId = tmpData.MovementId
                                                      AND MovementString_InvNumberPack.DescId = zc_MovementString_InvNumberPack()
                                                      AND inisPartion = TRUE
                              LEFT JOIN MovementString AS MovementString_InvNumberInvoice 
                                                       ON MovementString_InvNumberInvoice.MovementId = tmpData.MovementId
                                                      AND MovementString_InvNumberInvoice.DescId = zc_MovementString_InvNumberInvoice()
                                                      AND inisPartion = TRUE
                              LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                                       ON MovementString_InvNumberPartner.MovementId = tmpData.MovementId
                                                      AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()
                                                      AND inisPartion = TRUE

                              LEFT JOIN MovementDate AS MovementDate_OperDatePartner    
                                                     ON MovementDate_OperDatePartner.MovementId = tmpData.MovementId
                                                    AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()
                                                    AND inisPartion = TRUE
                         GROUP BY tmpData.UnitId
                                , tmpData.GoodsId
                                , CASE WHEN inisPartion = TRUE THEN tmpData.PartionId        ELSE 0 END
                                , CASE WHEN inisPartion = TRUE THEN tmpData.MovementId       ELSE 0  END
                                , CASE WHEN inisPartion = TRUE THEN MovementDesc_Partion.ItemName ELSE '' END
                                , CASE WHEN inisPartion = TRUE THEN Movement_Partion.InvNumber    ELSE '' END
                                , CASE WHEN inisPartion = TRUE THEN Movement_Partion.OperDate     ELSE zc_DateStart() END
                                , CASE WHEN inisPartner = TRUE THEN tmpData.PartnerId        ELSE 0  END
                                , tmpData.GoodsSizeId
                                , tmpData.MeasureId
                                , tmpData.GoodsGroupId
                                , tmpData.GoodsTagId
                                , tmpData.GoodsTypeId
                                , tmpData.ProdColorId
                                , tmpData.TaxKindId
                                , tmpData.TaxKindValue
                                , tmpData.EKPrice
                                , tmpData.OperPriceList
                                , tmpData.UnitId_in
                                , MS_Comment.ValueData
                                , MF_DiscountTax.ValueData
                                , MF_VATPercent.ValueData
                                , tmpData.CountForPrice
                                , tmpData.OperPrice_cost
                                , tmpData.CostPrice 
                                , MovementString_InvNumberPack.ValueData   
                                , MovementString_InvNumberInvoice.ValueData
                                , MovementString_InvNumberPartner.ValueData
                                , MovementDate_OperDatePartner.ValueData
                                , COALESCE (MovementFloat_TotalDiscountTax.ValueData, 0) 
                                , tmpData.OperPrice_orig
                               , tmpData.DiscountTax
                         )

       , tmpData_Rez AS (SELECT tmpData_All.UnitId
                          , tmpData_All.GoodsId
                          , tmpData_All.PartionId
                          , tmpData_All.MovementId_Partion
                          , tmpData_All.DescName_Partion
                          , tmpData_All.InvNumber_Partion
                          , tmpData_All.InvNumberInvoice_Partion
                          , tmpData_All.InvNumberPack_Partion
                          , tmpData_All.InvNumberPartner_Partion
                          , tmpData_All.OperDatePartner_Partion
                          , tmpData_All.OperDate_Partion
                          , tmpData_All.PartnerId
                          , Object_GoodsSize.Id        AS GoodsSizeId
                          , Object_GoodsSize.ValueData AS GoodsSizeName_real
                          , STRING_AGG (Object_GoodsSize.ValueData, ', ' ORDER BY CASE WHEN LENGTH (Object_GoodsSize.ValueData) = 1 THEN '0' ELSE '' END || Object_GoodsSize.ValueData) AS GoodsSizeName
                          , tmpData_All.MeasureId
                          , tmpData_All.GoodsGroupId
                          , tmpData_All.GoodsTagId
                          , tmpData_All.GoodsTypeId
                          , tmpData_All.ProdColorId
                          , tmpData_All.TaxKindId
                          
                          , tmpData_All.EKPrice
                          , tmpData_All.OperPriceList
                          , tmpData_All.OperPrice_cost
                          , tmpData_All.CostPrice
                          , tmpData_All.CountForPrice

                          , tmpData_All.UnitId_in
                          , tmpData_All.Comment_in
                          , tmpData_All.DiscountTax_in
                          , tmpData_All.VATPercent_in
                          , tmpData_All.TotalDiscountTax_in

                          , tmpData_All.OperPrice_orig
                          , tmpData_All.DiscountTax
                          , SUM (COALESCE (tmpData_All.SummIn, 0))  AS SummIn

                          , SUM (COALESCE (tmpData_All.Amount, 0))  AS Amount  -- �� ��������
                          , SUM (COALESCE (tmpData_All.Summ, 0))    AS Summ    -- �� ��������

                          , SUM (tmpData_All.Amount_in)          AS Amount_in
                          , SUM (tmpData_All.Remains)            AS Remains
                          , SUM (tmpData_All.TotalSummEKPrice) AS TotalSummEKPrice
                          , SUM (tmpData_All.TotalSummPriceList) AS TotalSummPriceList
                     FROM tmpData_All
                          LEFT JOIN Object AS Object_GoodsSize ON Object_GoodsSize.Id = tmpData_All.GoodsSizeId
                     GROUP BY tmpData_All.UnitId
                            , tmpData_All.GoodsId
                            , tmpData_All.PartionId
                            , tmpData_All.MovementId_Partion
                            , tmpData_All.DescName_Partion
                            , tmpData_All.InvNumber_Partion
                            , tmpData_All.OperDate_Partion
                            , tmpData_All.PartnerId
                            , Object_GoodsSize.Id
                            , Object_GoodsSize.ValueData
                           -- , tmpData_All.BrandId
                            , tmpData_All.MeasureId
                            , tmpData_All.GoodsGroupId
                            , tmpData_All.GoodsTagId
                            , tmpData_All.GoodsTypeId
                            , tmpData_All.ProdColorId
                            , tmpData_All.TaxKindId
                            , tmpData_All.TaxKindValue
                            , tmpData_All.OperPriceList
                            , tmpData_All.UnitId_in
                            , tmpData_All.Comment_in
                            , tmpData_All.DiscountTax_in 
                            , tmpData_All.TotalDiscountTax_in
                            , tmpData_All.VATPercent_in
                            , tmpData_All.EKPrice
                            , tmpData_All.CountForPrice
                            , tmpData_All.OperPrice_cost
                            , tmpData_All.CostPrice
                            , tmpData_All.InvNumberInvoice_Partion
                            , tmpData_All.InvNumberPack_Partion
                            , tmpData_All.InvNumberPartner_Partion
                            , tmpData_All.OperDatePartner_Partion
                            , tmpData_All.OperPrice_orig
                            , tmpData_All.DiscountTax
              )


        -- ���������
        SELECT
             tmpData.PartionId                      AS PartionId
           , tmpData.MovementId_Partion             AS MovementId_Partion
           , tmpData.InvNumber_Partion :: TVarChar  AS InvNumber_Partion
           , zfCalc_PartionMovementName (0, '', tmpData.InvNumber_Partion, tmpData.OperDate_Partion) AS InvNumberAll_Partion 
           , tmpData.InvNumberInvoice_Partion    :: TVarChar
           , tmpData.InvNumberPack_Partion       :: TVarChar
           , tmpData.InvNumberPartner_Partion    :: TVarChar
           , tmpData.OperDatePartner_Partion
           , CASE WHEN tmpData.OperDate_Partion = zc_DateStart() THEN NULL ELSE tmpData.OperDate_Partion END  :: TDateTime AS OperDate_Partion
           , tmpData.DescName_Partion  :: TVarChar  AS DescName_Partion

           , Object_Unit.Id                 AS UnitId
           , Object_Unit.ValueData          AS UnitName
           , Object_Unit_in.ValueData       AS UnitName_in
           , Object_Partner.ValueData       AS PartnerName
           --, Object_Brand.ValueData         AS BrandName

           , Object_Goods.Id                AS GoodsId
           , Object_Goods.ObjectCode        AS GoodsCode
           , Object_Goods.ValueData         AS GoodsName
           , ObjectString_Article.ValueData AS Article
           , zfCalc_Article_all (ObjectString_Article.ValueData)::TVarChar AS Article_all
           , ObjectString_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_GoodsGroup.ValueData    AS GoodsGroupName
           , Object_Measure.ValueData       AS MeasureName

           , Object_GoodsTag.ValueData      AS GoodsTagName
           , Object_GoodsType.ValueData     AS GoodsTypeName
           , Object_ProdColor.ValueData     AS ProdColorName
           , Object_TaxKind.ValueData       AS TaxKindName

           , tmpData.GoodsSizeId            AS GoodsSizeId
           , tmpData.GoodsSizeName      ::TVarChar AS GoodsSizeName
           , tmpData.GoodsSizeName_real ::TVarChar AS GoodsSizeName_real

           , tmpData.Amount       ::TFloat AS Amount  -- �� ��������
           , tmpData.Summ         ::TFloat AS Summ    -- �� ��������

             -- ����� ���-�� ������ �� ����������
           , tmpData.Amount_in    :: TFloat AS Amount_in

           , CASE WHEN tmpData.Amount_in  <> 0 THEN tmpData.TotalSummEKPrice / tmpData.Amount_in
                  ELSE 0
             END :: TFloat AS OperPrice
           , COALESCE (tmpData.CountForPrice,1)   :: TFloat AS CountForPrice

             -- ���� �� ������
           , tmpData.OperPriceList :: TFloat

           , tmpData.OperPrice_cost   :: TFloat
           , tmpData.CostPrice        :: TFloat

             -- ���-�� - �������
           , tmpData.Remains                 :: TFloat AS Remains
             -- ����� �� ������� �����
           , tmpData.TotalSummEKPrice      :: TFloat AS TotalSummEKPrice
             -- ����� �� ������ - 
           , tmpData.TotalSummPriceList      :: TFloat AS TotalSummPriceList
           
           , (tmpData.Remains * tmpData.CostPrice ) :: TFloat AS Summ_Cost
           , (tmpData.Remains * tmpData.OperPrice_cost ) :: TFloat AS TotalSumm_cost

             -- % ������� 
           , CAST (CASE WHEN  tmpData.OperPrice_cost <> 0
                        THEN (100 * tmpData.OperPriceList / tmpData.OperPrice_cost - 100)
                        ELSE 0
                   END AS NUMERIC (16, 0)) :: TFloat AS PriceTax

           , tmpData.OperPrice_orig  :: TFloat
           , tmpData.DiscountTax     :: TFloat
           , tmpData.SummIn          :: TFloat


           , tmpData.Comment_in       :: TVarChar
           , tmpData.DiscountTax_in   :: TFloat
           , tmpData.TotalDiscountTax_in ::TFloat
           , tmpData.VATPercent_in    :: TFloat

        FROM tmpData_Rez AS tmpData
            LEFT JOIN Object AS Object_Unit    ON Object_Unit.Id    = tmpData.UnitId
            LEFT JOIN Object AS Object_Unit_in ON Object_Unit_in.Id = tmpData.UnitId_in
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = tmpData.PartnerId
            LEFT JOIN Object AS Object_Goods   ON Object_Goods.Id   = tmpData.GoodsId

            LEFT JOIN Object AS Object_GoodsGroup ON Object_GoodsGroup.Id = tmpData.GoodsGroupId
            LEFT JOIN Object AS Object_Measure    ON Object_Measure.Id    = tmpData.MeasureId
            LEFT JOIN Object AS Object_GoodsTag   ON Object_GoodsTag.Id   = tmpData.GoodsTagId
            LEFT JOIN Object AS Object_GoodsType  ON Object_GoodsType.Id  = tmpData.GoodsTypeId
            LEFT JOIN Object AS Object_ProdColor  ON Object_ProdColor.Id  = tmpData.ProdColorId
            LEFT JOIN Object AS Object_TaxKind    ON Object_TaxKind.Id    = tmpData.TaxKindId

            LEFT JOIN ObjectString AS ObjectString_GoodsGroupFull
                                   ON ObjectString_GoodsGroupFull.ObjectId = tmpData.GoodsId
                                  AND ObjectString_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Article
                                   ON ObjectString_Article.ObjectId = tmpData.GoodsId
                                  AND ObjectString_Article.DescId = zc_ObjectString_Article()
           ;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 29.06.23         *
 24.03.21         *
*/
-- ����
-- select * from gpReport_MovementIncome (inStartDate :='01.01.2021', inEndDate :='01.01.2124', inUnitId := 0 , inPartnerId := 0 ,inGoodsGroupId:=0, inIsPartion := 'true' , inIsPartner := 'true', inSession := '2');
