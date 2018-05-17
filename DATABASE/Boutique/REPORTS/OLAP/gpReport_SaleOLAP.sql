-- Function:  gpReport_SalesOLAP()

DROP FUNCTION IF EXISTS gpReport_SaleOLAP (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpReport_SaleOLAP (TDateTime, TDateTime, Integer, Integer, Integer, Integer, Integer, Integer, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_SaleOLAP (
    IN inStartDate        TDateTime,  -- ���� ������
    IN inEndDate          TDateTime,  -- ���� ���������
    IN inUnitId           Integer  ,  -- �������������
    IN inPartnerId        Integer  ,  -- ����������
    IN inBrandId          Integer  ,  --
    IN inPeriodId         Integer  ,  --
    IN inStartYear        Integer  ,
    IN inEndYear          Integer  ,
    IN inIsYear           Boolean  , -- ����������� ��� �� (��/���) (����� ������)
    IN inIsPeriodAll      Boolean  , -- ����������� �� ���� ������ (��/���) (�������� �� ����������)
    IN inIsGoods          Boolean  , -- �������� ������ (��/���)
    IN inIsSize           Boolean  , -- �������� ������� (��/���)
    IN inIsClient_doc     Boolean  , -- �������� ���������� (��/���)
    IN inIsOperDate_doc   Boolean  , -- �������� ��� / ����� (��/���) (�������� �� ����������)
    IN inIsDay_doc        Boolean  , -- �������� ���� ������ (��/���) (�������� �� ����������)
    IN inIsOperPrice      Boolean  , -- �������� ���� ��. � ���. (��/���)
    IN inIsDiscount       Boolean  , -- �������� % ������ (��/���)
    IN inIsMark           Boolean  , -- �������� ������ ���������� ������(��/���)
    IN inSession          TVarChar   -- ������ ������������
)
RETURNS TABLE (BrandName             VarChar (100)
             , PeriodName            VarChar (25)
             , PeriodYear            Integer
             , PartnerId             Integer
             , PartnerName           VarChar (100)

             -- , GoodsGroupName_all TVarChar
             , GoodsGroupName        TVarChar
             , LabelName             VarChar (100)
             -- , CompositionGroupName  TVarChar
             , CompositionName       VarChar (50) -- TVarChar -- +

             , GoodsId               Integer
             , GoodsCode             Integer
             , GoodsName             VarChar (100)
             , GoodsInfoName         VarChar (100) -- TVarChar -- +
             , LineFabricaName       VarChar (50)  -- TVarChar -- +
             -- , FabrikaName        TVarChar
             , GoodsSizeId           Integer
             , GoodsSizeName         VarChar (50)

             , PeriodName_doc        VarChar (25)
             , PeriodYear_doc        Integer
             , MonthName_doc         VarChar (25)
             , DayName_doc           VarChar (3)
             , UnitName              VarChar (100)
             , ClientName            VarChar (100)
             , DiscountSaleKindName  VarChar (15)
             , ChangePercent         TFloat

             , UnitName_In           VarChar (100)
             , CurrencyName          VarChar (10)
             , OperPrice             TFloat

               -- ������, � ����� �������� ���� ���� �������� ��� ������� ����������
             , Income_Amount         TFloat
             , Income_Summ           TFloat

               -- ������� - ��� ����� "�����"
             , Remains_Amount        TFloat
             , Remains_Summ          TFloat
               -- ������� - � ������ "�����"
             , Remains_Amount_real   TFloat

               -- �����������
             , SendIn_Amount         TFloat
             , SendOut_Amount        TFloat
             , SendIn_Summ           TFloat
             , SendOut_Summ          TFloat

               -- ���-��: �������� + ������� �������.
             , Loss_Amount           TFloat

               -- ���-�� ������� - "����"
             , Debt_Amount           TFloat
               -- ����� ������� - "����"
             , Debt_Summ             TFloat

               -- ���-�� ������� - � ������ "�����"
             , Sale_Amount           TFloat
               -- ���-�� ������� - ��� ����� "�����"
             , Sale_Amount_real      TFloat

               -- ���-�� ������� - �� �������� �������
             , Sale_InDiscount       TFloat
               -- ���-�� ������� - �� �������� ������
             , Sale_OutDiscount      TFloat

               -- ����� ������� - ��� ����� "�����"
             , Sale_Summ             TFloat
             , Sale_Summ_curr        TFloat

               -- �\� ������� - ��� ����� "�����"
             , Sale_SummCost         TFloat -- calc �� ������ � ���
             , Sale_SummCost_curr    TFloat -- ������

               -- ����. ���� �������
             , Sale_SummCost_diff    TFloat
               -- ������� ������� � ������ �������� ������� - ��� ����� "�����"
             , Sale_Summ_prof        TFloat

             , Sale_Summ_10100       TFloat
             , Sale_Summ_10201       TFloat
             , Sale_Summ_10202       TFloat
             , Sale_Summ_10203       TFloat
             , Sale_Summ_10204       TFloat

               -- ������ �����
             , Sale_Summ_10200       TFloat
             , Sale_Summ_10200_curr  TFloat

             , Return_Amount         TFloat

               -- ����� �������
             , Return_Summ           TFloat
             , Return_Summ_curr      TFloat

               -- �\� �������
             , Return_SummCost        TFloat -- calc �� ������ � ���
             , Return_SummCost_curr   TFloat -- ������

               -- ����. ���� �������
             , Return_SummCost_diff   TFloat
               -- ������ �������
             , Return_Summ_prof       TFloat

               -- ������ �������
             , Return_Summ_10200      TFloat
             , Return_Summ_10200_curr TFloat

               -- ���. ���� - � ������ "�����"
             , Result_Amount         TFloat
               -- ���. ���� - ��� ����� "�����"
             , Result_Amount_real    TFloat

               -- ����� ���� - ��� ����� "�����"
             , Result_Summ           TFloat
             , Result_Summ_curr      TFloat
               -- �\� ���� - ��� ����� "�����"
             , Result_SummCost       TFloat -- calc �� ������ � ���
             , Result_SummCost_curr  TFloat -- ������
               -- ����. ����. ����
             , Result_SummCost_diff  TFloat
               -- ������� ���� � ������ �������� ������� - ��� ����� "�����"
             , Result_Summ_prof      TFloat
             , Result_Summ_prof_curr TFloat

               -- ������ ����
             , Result_Summ_10200      TFloat
             , Result_Summ_10200_curr TFloat

               -- % ������: ���-�� �������    / ���-�� ������
             , Tax_Amount            TFloat
             , Tax_Amount_real       TFloat
               -- % ������: ����� �/� ������� / ����� �/� ������
             , Tax_Summ_curr         TFloat
               -- % ��������������: ����� ������� / ����� �/�
             , Tax_Summ_prof         TFloat

             , GroupsName1           VarChar (50)
             , GroupsName2           VarChar (50)
             , GroupsName3           VarChar (50)
             , GroupsName4           VarChar (50)

             , isOLAP_Goods          Boolean
             , isOLAP_Partion        Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

    -- �������� ���� ������������ �� ����� ���������
    vbUserId:= lpGetUserBySession (inSession);

    -- !!!������!!!
    IF inIsYear = TRUE AND COALESCE (inEndYear, 0) = 0 THEN
       inEndYear:= 1000000;
    END IF;

    -- !!!������!!!
    IF COALESCE (inBrandId, 0) = 0
       AND COALESCE (inPartnerId, 0) = 0
       AND EXISTS (SELECT 1
                   FROM Object
                        INNER JOIN ObjectLink AS ObjectLink_Object
                                              ON ObjectLink_Object.ObjectId      = Object.Id
                                             AND ObjectLink_Object.DescId        = zc_ObjectLink_ReportOLAP_Object()
                        INNER JOIN ObjectLink AS ObjectLink_User
                                              ON ObjectLink_User.ObjectId      = Object.Id
                                             AND ObjectLink_User.DescId        = zc_ObjectLink_ReportOLAP_User()
                                             AND ObjectLink_User.ChildObjectId = vbUserId
                   WHERE Object.DescId      = zc_Object_ReportOLAP()
                     AND Object.ObjectCode  = 1
                     AND Object.isErased    = FALSE
                  )
    THEN
         inBrandId:= -1;
    END IF;


    -- ������� �������������
    CREATE TEMP TABLE _tmpUnit (UnitId Integer) ON COMMIT DROP;
    IF COALESCE (inUnitId, 0) <> 0
    THEN
        --
        INSERT INTO _tmpUnit (UnitId)
          SELECT lfSelect.UnitId FROM lfSelect_Object_Unit_byGroup (inUnitId) AS lfSelect
         ;
    ELSE
        --
        INSERT INTO _tmpUnit (UnitId)
          SELECT Object_Unit.Id FROM Object AS Object_Unit WHERE Object_Unit.DescId = zc_Object_Unit()
         ;
    END IF;


    -- ���������
    RETURN QUERY
      WITH 
           -- ������ / ������ ���������� ��� OLAP
          tmpReportOLAP AS (SELECT DISTINCT Object_PartionGoods.MovementItemId       AS PartionId
                                 , CASE WHEN Object.ObjectCode = 2 THEN 1 ELSE 0 END AS Olap_Goods
                                 , CASE WHEN Object.ObjectCode = 3 THEN 1 ELSE 0 END AS Olap_Partion
                            FROM Object
                                 INNER JOIN ObjectLink AS ObjectLink_User
                                                       ON ObjectLink_User.ObjectId      = Object.Id
                                                      AND ObjectLink_User.DescId        = zc_ObjectLink_ReportOLAP_User()
                                                      AND ObjectLink_User.ChildObjectId = vbUserId
               
                                 INNER JOIN ObjectLink AS ObjectLink_Object
                                                       ON ObjectLink_Object.ObjectId = Object.Id
                                                      AND ObjectLink_Object.DescId   = zc_ObjectLink_ReportOLAP_Object()
                                                      
                                 -- ����������� �� ������ � ������, ��� ������ ���������� ����� �����, ��� ������ ���������� ������
                                 INNER JOIN Object_PartionGoods ON ObjectLink_Object.ChildObjectId = CASE WHEN Object.ObjectCode = 3 THEN Object_PartionGoods.MovementItemId ELSE Object_PartionGoods.GoodsId END
                                                    
                            WHERE Object.DescId = zc_Object_ReportOLAP()
                              AND Object.ObjectCode IN (2,3)
                              AND Object.isErased = FALSE
                            )
        , tmpCurrency_all AS (SELECT Movement.Id                    AS MovementId
                                   , Movement.OperDate              AS OperDate
                                   , MovementItem.Id                AS MovementItemId
                                   , MovementItem.ObjectId          AS CurrencyFromId
                                   , MovementItem.Amount            AS Amount
                                   , CASE WHEN MIFloat_ParValue.ValueData > 0 THEN MIFloat_ParValue.ValueData ELSE 1 END AS ParValue
                                   , MILinkObject_Currency.ObjectId AS CurrencyToId
                                   , ROW_NUMBER() OVER (PARTITION BY MovementItem.ObjectId, MILinkObject_Currency.ObjectId ORDER BY Movement.OperDate, Movement.Id) AS Ord
                              FROM Movement
                                   INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                          AND MovementItem.DescId     = zc_MI_Master()
                                   INNER JOIN MovementItemLinkObject AS MILinkObject_Currency
                                                                     ON MILinkObject_Currency.MovementItemId = MovementItem.Id
                                                                    AND MILinkObject_Currency.DescId         = zc_MILinkObject_Currency()
                                   LEFT JOIN MovementItemFloat AS MIFloat_ParValue
                                                               ON MIFloat_ParValue.MovementItemId = MovementItem.Id
                                                              AND MIFloat_ParValue.DescId         = zc_MIFloat_ParValue()
                              WHERE Movement.DescId   = zc_Movement_Currency()
                                AND Movement.StatusId = zc_Enum_Status_Complete()
                             )
        , tmpCurrency AS (SELECT tmpCurrency_all.OperDate                           AS StartDate
                               , COALESCE (tmpCurrency_next.OperDate, zc_DateEnd()) AS EndDate
                               , tmpCurrency_all.Amount
                               , tmpCurrency_all.ParValue
                               , tmpCurrency_all.CurrencyFromId
                               , tmpCurrency_all.CurrencyToId
                               -- , ROW_NUMBER() OVER (PARTITION BY tmpCurrency_all.OperDate, tmpCurrency_all.CurrencyFromId, tmpCurrency_all.CurrencyToId) AS Ord
                          FROM tmpCurrency_all
                               LEFT JOIN tmpCurrency_all AS tmpCurrency_next
                                                         ON tmpCurrency_next.CurrencyFromId = tmpCurrency_all.CurrencyFromId
                                                        AND tmpCurrency_next.CurrencyToId   = tmpCurrency_all.CurrencyToId
                                                        AND tmpCurrency_next.Ord            = tmpCurrency_all.Ord + 1
                         )
        , tmpDiscountPeriod AS (SELECT ObjectLink_DiscountPeriod_Period.ChildObjectId AS PeriodId
                                     , ObjectDate_StartDate.ValueData                 AS StartDate
                                     , ObjectDate_EndDate.ValueData                   AS EndDate
                                FROM Object as Object_DiscountPeriod
                                     /*LEFT JOIN ObjectLink AS ObjectLink_DiscountPeriod_Unit
                                                          ON ObjectLink_DiscountPeriod_Unit.ObjectId = Object_DiscountPeriod.Id
                                                         AND ObjectLink_DiscountPeriod_Unit.DescId = zc_ObjectLink_DiscountPeriod_Unit()
                                     */
                                     LEFT JOIN ObjectLink AS ObjectLink_DiscountPeriod_Period
                                                          ON ObjectLink_DiscountPeriod_Period.ObjectId = Object_DiscountPeriod.Id
                                                         AND ObjectLink_DiscountPeriod_Period.DescId = zc_ObjectLink_DiscountPeriod_Period()
  
                                     LEFT JOIN ObjectDate AS ObjectDate_StartDate
                                                          ON ObjectDate_StartDate.ObjectId = Object_DiscountPeriod.Id
                                                         AND ObjectDate_StartDate.DescId = zc_ObjectDate_DiscountPeriod_StartDate()
                         
                                     LEFT JOIN ObjectDate AS ObjectDate_EndDate
                                                          ON ObjectDate_EndDate.ObjectId = Object_DiscountPeriod.Id
                                                         AND ObjectDate_EndDate.DescId = zc_ObjectDate_DiscountPeriod_EndDate()
  
                                WHERE Object_DiscountPeriod.DescId = zc_Object_DiscountPeriod()
                                  AND Object_DiscountPeriod.isErased = FALSE
                                )
         -- ����� ����������
        , tmpContainerDebt AS (SELECT Container.Id         AS ContainerId
                                    , CLO_Client.ObjectId  AS ClientId
                               FROM Container
                                    INNER JOIN ContainerLinkObject AS CLO_Client
                                                                   ON CLO_Client.ContainerId = Container.Id
                                                                  AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                               WHERE Container.DescId   = zc_Container_Count()
                              UNION ALL
                               SELECT Container.Id         AS ContainerId
                                    , 0                    AS ClientId
                               FROM Container
                               WHERE Container.DescId   = zc_Container_Summ()
                                 AND Container.ObjectId = zc_Enum_Account_100301 () -- ������� �������� �������
                              )
          -- �� - ���������, ���� �������� � ������ ��� ����
        , tmpBrand AS (SELECT ObjectLink_Object.ChildObjectId AS BrandId
                       FROM Object
                            INNER JOIN ObjectLink AS ObjectLink_Object
                                                  ON ObjectLink_Object.ObjectId      = Object.Id
                                                 AND ObjectLink_Object.DescId        = zc_ObjectLink_ReportOLAP_Object()
                            INNER JOIN ObjectLink AS ObjectLink_User
                                                  ON ObjectLink_User.ObjectId      = Object.Id
                                                 AND ObjectLink_User.DescId        = zc_ObjectLink_ReportOLAP_User()
                                                 AND ObjectLink_User.ChildObjectId = vbUserId
                       WHERE Object.DescId      = zc_Object_ReportOLAP()
                         AND Object.ObjectCode  = 1
                         AND Object.isErased    = FALSE
                         AND inBrandId          = -1
                      UNION ALL
                       SELECT inBrandId AS BrandId WHERE inBrandId > 0
                      )
                          
           -- ������ ������
        , tmpPartionGoods AS (SELECT Object_PartionGoods.*
                                   , tmpReportOLAP.Olap_Goods
                                   , tmpReportOLAP.Olap_Partion
                              FROM Object_PartionGoods
                                   LEFT JOIN tmpBrand ON tmpBrand.BrandId = Object_PartionGoods.BrandId
                                   LEFT JOIN tmpReportOLAP ON tmpReportOLAP.PartionId = Object_PartionGoods.MovementItemId
                              WHERE (Object_PartionGoods.PartnerId  = inPartnerId OR inPartnerId = 0)
                                AND (tmpBrand.BrandId               > 0           OR inBrandId   = 0)
                                AND (tmpReportOLAP.PartionId        > 0           OR inIsMark    = FALSE)
                                AND (Object_PartionGoods.PeriodId   = inPeriodId  OR inPeriodId  = 0)
                                AND ((Object_PartionGoods.PeriodYear BETWEEN inStartYear AND inEndYear) OR inIsYear = FALSE)
                                AND Object_PartionGoods.isErased    = FALSE
                             )
          -- ������ ������� ���������� + ����
        , tmpReturnOut AS (SELECT tmpPartionGoods.MovementItemId AS PartionId
                                , SUM (-1 * MIConatiner.Amount)  AS Amount
                           FROM tmpPartionGoods
                                INNER JOIN MovementItemContainer AS MIConatiner
                                                                ON MIConatiner.PartionId      = tmpPartionGoods.MovementItemId
                                                               AND MIConatiner.MovementDescId IN (zc_Movement_ReturnOut(), zc_Movement_Loss())
                                                               AND MIConatiner.DescId         = zc_MIContainer_Count()
                                -- �� ����� � ����� �������������, ������� - ������
                                INNER JOIN _tmpUnit ON _tmpUnit.UnitId = tmpPartionGoods.UnitId
                           GROUP BY tmpPartionGoods.MovementItemId
                          )
          -- ������ �����������
        , tmpSend AS (SELECT tmpPartionGoods.MovementItemId     AS PartionId
                           , MIConatiner.WhereObjectId_Analyzer AS UnitId
                           , SUM (MIConatiner.Amount)           AS Amount
                      FROM tmpPartionGoods
                           INNER JOIN MovementItemContainer AS MIConatiner
                                                            ON MIConatiner.PartionId      = tmpPartionGoods.MovementItemId
                                                           AND MIConatiner.MovementDescId = zc_Movement_Send()
                                                           AND MIConatiner.DescId         = zc_MIContainer_Count()
                           INNER JOIN _tmpUnit ON _tmpUnit.UnitId = MIConatiner.WhereObjectId_Analyzer
                      GROUP BY tmpPartionGoods.MovementItemId
                             , MIConatiner.WhereObjectId_Analyzer
                     )
            -- ������ �������
        , tmpRemains AS (SELECT tmpPartionGoods.MovementItemId                                              AS PartionId
                              , Container.WhereObjectId                                                     AS UnitId
                              , SUM (CASE WHEN CLO_Client.ContainerId > 0 THEN 0 ELSE Container.Amount END) AS Amount
                              , SUM (Container.Amount)                                                      AS Amount_real
                         FROM tmpPartionGoods
                              INNER JOIN Container ON Container.PartionId = tmpPartionGoods.MovementItemId
                                                  AND Container.DescId    = zc_Container_Count()
                                                  AND Container.Amount    <> 0
                              INNER JOIN _tmpUnit ON _tmpUnit.UnitId = Container.WhereObjectId
                              LEFT JOIN ContainerLinkObject AS CLO_Client
                                                            ON CLO_Client.ContainerId = Container.Id
                                                           AND CLO_Client.DescId      = zc_ContainerLinkObject_Client()
                         GROUP BY tmpPartionGoods.MovementItemId
                                , Container.WhereObjectId
                        )
          -- ������: ������� + ������ + ������� + ���������
        , tmpData_all AS (-- 1. ������� / ������� �� ����������
                          SELECT Object_PartionGoods.MovementItemId AS PartionId
                               , Object_PartionGoods.BrandId
                               , Object_PartionGoods.PeriodId
                               , Object_PartionGoods.PeriodYear
                               , Object_PartionGoods.PartnerId

                               , Object_PartionGoods.GoodsGroupId
                               , Object_PartionGoods.LabelId
                               , Object_PartionGoods.CompositionGroupId
                               , Object_PartionGoods.CompositionId

                               , Object_PartionGoods.GoodsId
                               , Object_PartionGoods.GoodsInfoId
                               , Object_PartionGoods.LineFabricaId
                               , Object_PartionGoods.GoodsSizeId

                               , MIConatiner.ObjectExtId_Analyzer AS UnitId
                               , CASE WHEN inIsOperDate_doc = TRUE THEN DATE_TRUNC ('MONTH', MIConatiner.OperDate) ELSE NULL :: TDateTime END AS OperDate_doc
                               , CASE WHEN inIsDay_doc      = TRUE THEN EXTRACT (DOW FROM MIConatiner.OperDate)    ELSE NULL :: Integer   END AS OrdDay_doc
                               , CASE WHEN inIsClient_doc   = TRUE THEN CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() THEN MIConatiner.WhereObjectId_Analyzer ELSE tmpContainerDebt.ClientId END ELSE 0 :: Integer END AS ClientId

                               , COALESCE (MIFloat_ChangePercent.ValueData, 0)         AS ChangePercent
                               , COALESCE (MILinkObject_DiscountSaleKind.ObjectId, 0)  AS DiscountSaleKindId

                               , Object_PartionGoods.UnitId     AS UnitId_in
                               , Object_PartionGoods.CurrencyId AS CurrencyId
                               , CASE WHEN inIsOperPrice    = TRUE THEN Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END ELSE 0 :: TFloat END AS OperPrice

                                 -- ���-�� ������ �� ���������� - ������ ��� UnitId
                               , 0 AS Income_Amount
                               , 0 AS Income_Summ

                                 -- ������� - ��� ����� "�����"
                               , 0 AS Remains_Amount
                               , 0 AS Remains_Summ
                                 -- ������� - � ������ "�����"
                               , 0 AS Remains_Amount_real

                                 -- �����������
                               , 0 AS SendIn_Amount
                               , 0 AS SendOut_Amount
                               , 0 AS SendIn_Summ
                               , 0 AS SendOut_Summ

                                 -- ���-��: �������� + ������� �������.
                               , 0 AS Loss_Amount

                                 -- ���-��: ����
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() THEN MIConatiner.Amount ELSE 0 END) AS Debt_Amount
                                 -- �����: ����
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() THEN MIConatiner.Amount * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END ELSE 0 END) AS Debt_Summ

                                 -- ���-��: ������ �������
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount < 0 AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIConatiner.Amount ELSE 0 END) :: TFloat AS Sale_Amount
                                 -- �\� ������� - calc �� ������ � ���
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount < 0 AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                THEN -1 * MIConatiner.Amount
                                                    * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END
                                                    * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 ELSE COALESCE (tmpCurrency.Amount, 0) END
                                                    / CASE WHEN tmpCurrency.ParValue > 0 THEN tmpCurrency.ParValue  ELSE 1 END
                                           ELSE 0
                                      END) AS Sale_SummCost_calc

                                 -- ����� �������
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND COALESCE (MIConatiner.AnalyzerId, 0) <> zc_Enum_AnalyzerId_SaleSumm_10300() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                THEN -1 * MIConatiner.Amount
                                           ELSE 0
                                      END) AS Sale_Summ
                                  -- ��������� � ������ 
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND COALESCE (MIConatiner.AnalyzerId, 0) <> zc_Enum_AnalyzerId_SaleSumm_10300() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                THEN -1 * MIConatiner.Amount
                                                   / CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 1 ELSE COALESCE (tmpCurrency.Amount, 0) END
                                                   * CASE WHEN tmpCurrency.ParValue > 0 THEN tmpCurrency.ParValue  ELSE 1 END
                                                   -- !!!�������� ���� ��� �����!!!
                                                   * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 0 ELSE 1 END
                                           ELSE 0
                                      END) AS Sale_Summ_curr

                                 -- �\� ������� - ���
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10300() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                THEN  1 * MIConatiner.Amount
                                           ELSE 0
                                      END) AS Sale_SummCost
                                 -- �\� ������� - ������
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount < 0 AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                THEN -1 * MIConatiner.Amount
                                                   * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END
                                           ELSE 0
                                      END) AS Sale_SummCost_curr

                                 -- ����� �����
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10100() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIConatiner.Amount ELSE 0 END) AS Sale_Summ_10100
                                 -- �������� ������
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10201() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN  1 * MIConatiner.Amount ELSE 0 END) AS Sale_Summ_10201
                                 -- ������ outlet
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10202() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN  1 * MIConatiner.Amount ELSE 0 END) AS Sale_Summ_10202
                                 -- ������ �������
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10203() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN  1 * MIConatiner.Amount ELSE 0 END) AS Sale_Summ_10203
                                 -- ������ ��������������
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_SaleSumm_10204() AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN  1 * MIConatiner.Amount ELSE 0 END) AS Sale_Summ_10204

                                 -- ������ �����
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND MIConatiner.AnalyzerId IN (zc_Enum_AnalyzerId_SaleSumm_10201(), zc_Enum_AnalyzerId_SaleSumm_10202(), zc_Enum_AnalyzerId_SaleSumm_10203(), zc_Enum_AnalyzerId_SaleSumm_10204()) AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                THEN 1 * MIConatiner.Amount
                                           ELSE 0
                                      END) AS Sale_Summ_10200
                                  -- ��������� � ������ 
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ()  AND MIConatiner.AnalyzerId IN (zc_Enum_AnalyzerId_SaleSumm_10201(), zc_Enum_AnalyzerId_SaleSumm_10202(), zc_Enum_AnalyzerId_SaleSumm_10203(), zc_Enum_AnalyzerId_SaleSumm_10204()) AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount())
                                                THEN 1 * MIConatiner.Amount
                                                   / CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 1 ELSE COALESCE (tmpCurrency.Amount, 0) END
                                                   * CASE WHEN tmpCurrency.ParValue > 0 THEN tmpCurrency.ParValue  ELSE 1 END
                                                   -- !!!�������� ���� ��� �����!!!
                                                   * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 0 ELSE 1 END
                                           ELSE 0
                                      END) AS Sale_Summ_10200_curr

                                 -- ���-��: ������ �������
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount > 0 AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn()) THEN 1 * MIConatiner.Amount ELSE 0 END) AS Return_Amount
                                 -- �\� ������� - calc �� ������ � ���
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount > 0 AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn())
                                                THEN 1 * MIConatiner.Amount
                                                   * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END
                                                   * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 ELSE COALESCE (tmpCurrency.Amount, 0) END
                                                   / CASE WHEN tmpCurrency.ParValue > 0 THEN tmpCurrency.ParValue  ELSE 1 END
                                           ELSE 0
                                      END) AS Return_SummCost_calc

                                 -- ����� �������
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() AND MIConatiner.AnalyzerId IN (zc_Enum_AnalyzerId_ReturnSumm_10501(), zc_Enum_AnalyzerId_ReturnSumm_10502()) AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn())
                                                THEN 1 * MIConatiner.Amount
                                           ELSE 0
                                      END) AS Return_Summ
                                  -- ��������� � ������ 
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() AND MIConatiner.AnalyzerId IN (zc_Enum_AnalyzerId_ReturnSumm_10501(), zc_Enum_AnalyzerId_ReturnSumm_10502()) AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn())
                                                THEN 1 * MIConatiner.Amount
                                                   / CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 1 ELSE COALESCE (tmpCurrency.Amount, 0) END
                                                   * CASE WHEN tmpCurrency.ParValue > 0 THEN tmpCurrency.ParValue  ELSE 1 END
                                                   -- !!!�������� ���� ��� �����!!!
                                                   * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 0 ELSE 1 END
                                           ELSE 0
                                      END) AS Return_Summ_curr

                                 -- �\� ������� - ���
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_ReturnSumm_10600() AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn())
                                                THEN -1 * MIConatiner.Amount
                                           ELSE 0
                                      END) AS Return_SummCost
                                 -- �\� ������� - ������
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount > 0 AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn())
                                                THEN 1 * MIConatiner.Amount
                                                   * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END
                                           ELSE 0
                                      END
                                     ) AS Return_SummCost_curr

                                 -- ������ �������
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_ReturnSumm_10502() AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn())
                                                THEN -1 * MIConatiner.Amount
                                           ELSE 0
                                      END) AS Return_Summ_10200
                                 -- ��������� � ������ 
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() AND MIConatiner.AnalyzerId = zc_Enum_AnalyzerId_ReturnSumm_10502() AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn())
                                                THEN -1 * MIConatiner.Amount
                                                   / CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 1 ELSE COALESCE (tmpCurrency.Amount, 0) END
                                                   * CASE WHEN tmpCurrency.ParValue > 0 THEN tmpCurrency.ParValue  ELSE 1 END
                                                   -- !!!�������� ���� ��� �����!!!
                                                   * CASE WHEN Object_PartionGoods.CurrencyId = zc_Currency_Basis() THEN 1 WHEN COALESCE (tmpCurrency.Amount, 0) = 0 THEN 0 ELSE 1 END
                                           ELSE 0
                                      END) AS Return_Summ_10200_curr

                                 -- ���-��: ������� - �������
                               , SUM (CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount < 0 AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIConatiner.Amount ELSE 0 END
                                    - CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount > 0 AND MIConatiner.MovementDescId IN (zc_Movement_ReturnIn()) THEN 1 * MIConatiner.Amount ELSE 0 END
                                     ) AS Result_Amount
                               -- , 0 AS Result_Summ
                               -- , 0 AS Result_SummCost
                               -- , 0 AS Result_Summ_10200

                                 --  � �/�
                               -- , ROW_NUMBER() OVER (PARTITION BY Object_PartionGoods.MovementItemId ORDER BY CASE WHEN Object_PartionGoods.UnitId = COALESCE (MIConatiner.ObjectExtId_Analyzer, Object_PartionGoods.UnitId) THEN 0 ELSE 1 END ASC) AS Ord
                               , 0 AS Ord

                                 -- ���-�� ������� (�� �������� �������)
                               , SUM (CASE WHEN COALESCE(tmpDiscountPeriod.PeriodId, 0) <> 0
                                           THEN CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount < 0 AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIConatiner.Amount ELSE 0 END
                                           ELSE 0
                                      END) AS Sale_Amount_InDiscount
                                 -- ���-�� ������� (�� �������� ������)
                               , SUM (CASE WHEN COALESCE(tmpDiscountPeriod.PeriodId, 0) = 0
                                           THEN CASE WHEN MIConatiner.DescId = zc_MIContainer_Count() AND MIConatiner.Amount < 0 AND MIConatiner.MovementDescId IN (zc_Movement_Sale(), zc_Movement_GoodsAccount()) THEN -1 * MIConatiner.Amount ELSE 0 END
                                           ELSE 0
                                      END) AS Sale_Amount_OutDiscount

                               --
                               -- , 1 as x1
                               
                               , Object_PartionGoods.Olap_Goods
                               , Object_PartionGoods.Olap_Partion

                          FROM tmpPartionGoods AS Object_PartionGoods
                               -- !!!��� �����!!!
                               -- INNER JOIN Object ON Object.Id = Object_PartionGoods.GoodsId AND Object.ObjectCode = 89373
                               INNER JOIN MovementItemContainer AS MIConatiner
                                                                ON MIConatiner.PartionId = Object_PartionGoods.MovementItemId
                                                               AND (MIConatiner.OperDate BETWEEN inStartDate AND inEndDate
                                                                 OR inIsPeriodAll = TRUE
                                                                   )
                               INNER JOIN tmpContainerDebt ON tmpContainerDebt.ContainerId   = MIConatiner.ContainerId
                               INNER JOIN _tmpUnit         ON _tmpUnit.UnitId                = MIConatiner.ObjectExtId_Analyzer

                               LEFT JOIN tmpCurrency      ON tmpCurrency.CurrencyFromId = zc_Currency_Basis()
                                                         AND tmpCurrency.CurrencyToId   = Object_PartionGoods.CurrencyId
                                                         -- AND tmpCurrency.Ord            = 1
                                                         AND MIConatiner.OperDate       >= tmpCurrency.StartDate
                                                         AND MIConatiner.OperDate       <  tmpCurrency.EndDate

                               LEFT JOIN MovementItemLinkObject AS MILinkObject_PartionMI
                                                                ON MILinkObject_PartionMI.MovementItemId = MIConatiner.MovementItemId
                                                               AND MILinkObject_PartionMI.DescId         = zc_MILinkObject_PartionMI()
                                                               AND inIsDiscount                          = TRUE
                               LEFT JOIN Object AS Object_PartionMI ON Object_PartionMI.Id = MILinkObject_PartionMI.ObjectId
                               LEFT JOIN MovementItemFloat AS MIFloat_ChangePercent
                                                           ON MIFloat_ChangePercent.MovementItemId = COALESCE (Object_PartionMI.ObjectCode, MIConatiner.MovementItemId)
                                                          AND MIFloat_ChangePercent.DescId         = zc_MIFloat_ChangePercent()
                                                          AND inIsDiscount                         = TRUE
                               LEFT JOIN MovementItemLinkObject AS MILinkObject_DiscountSaleKind
                                                                ON MILinkObject_DiscountSaleKind.MovementItemId = COALESCE (Object_PartionMI.ObjectCode, MIConatiner.MovementItemId)
                                                               AND MILinkObject_DiscountSaleKind.DescId         = zc_MILinkObject_DiscountSaleKind()
                                                               AND inIsDiscount                                 = TRUE

                               LEFT JOIN tmpDiscountPeriod ON tmpDiscountPeriod.PeriodId = Object_PartionGoods.PeriodId
                                                          AND MIConatiner.OperDate BETWEEN tmpDiscountPeriod.StartDate AND tmpDiscountPeriod.EndDate

                          -- WHERE (MIConatiner.ContainerId      > 0 OR inIsPeriodAll = TRUE)
                          --   AND (tmpContainerDebt.ContainerId > 0 OR MIConatiner.PartionId IS NULL)

                          GROUP BY Object_PartionGoods.MovementItemId
                                 , Object_PartionGoods.BrandId
                                 , Object_PartionGoods.PeriodId
                                 , Object_PartionGoods.PeriodYear
                                 , Object_PartionGoods.PartnerId

                                 , Object_PartionGoods.GoodsGroupId
                                 , Object_PartionGoods.LabelId
                                 , Object_PartionGoods.CompositionGroupId
                                 , Object_PartionGoods.CompositionId

                                 , Object_PartionGoods.GoodsId
                                 , Object_PartionGoods.GoodsInfoId
                                 , Object_PartionGoods.LineFabricaId
                                 , Object_PartionGoods.GoodsSizeId

                                 , MIConatiner.ObjectExtId_Analyzer
                                 , CASE WHEN inIsOperDate_doc = TRUE THEN DATE_TRUNC ('MONTH', MIConatiner.OperDate) ELSE NULL :: TDateTime END
                                 , CASE WHEN inIsDay_doc      = TRUE THEN EXTRACT (DOW FROM MIConatiner.OperDate)    ELSE NULL :: Integer   END
                                 , CASE WHEN inIsClient_doc   = TRUE THEN CASE WHEN MIConatiner.DescId = zc_MIContainer_Summ() THEN MIConatiner.WhereObjectId_Analyzer ELSE tmpContainerDebt.ClientId END ELSE 0 END

                                 , MIFloat_ChangePercent.ValueData
                                 , MILinkObject_DiscountSaleKind.ObjectId

                                 , Object_PartionGoods.UnitId
                                 , Object_PartionGoods.CurrencyId
                                 -- , Object_PartionGoods.Amount
                                 , CASE WHEN inIsOperPrice    = TRUE THEN Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END ELSE 0 :: TFloat END

                                 , Object_PartionGoods.Olap_Goods
                                 , Object_PartionGoods.Olap_Partion

                         UNION ALL
                          -- 2. ������ �� ����������
                          SELECT Object_PartionGoods.MovementItemId AS PartionId
                               , Object_PartionGoods.BrandId
                               , Object_PartionGoods.PeriodId
                               , Object_PartionGoods.PeriodYear
                               , Object_PartionGoods.PartnerId

                               , Object_PartionGoods.GoodsGroupId
                               , Object_PartionGoods.LabelId
                               , Object_PartionGoods.CompositionGroupId
                               , Object_PartionGoods.CompositionId

                               , Object_PartionGoods.GoodsId
                               , Object_PartionGoods.GoodsInfoId
                               , Object_PartionGoods.LineFabricaId
                               , Object_PartionGoods.GoodsSizeId

                               , Object_PartionGoods.UnitId AS UnitId
                               , CASE WHEN inIsOperDate_doc = TRUE THEN DATE_TRUNC ('MONTH', Object_PartionGoods.OperDate) ELSE NULL :: TDateTime END AS OperDate_doc
                               , CASE WHEN inIsDay_doc      = TRUE THEN EXTRACT (DOW FROM Object_PartionGoods.OperDate)    ELSE NULL :: Integer   END AS OrdDay_doc
                               , 0 AS ClientId

                               , 0 AS ChangePercent
                               , 0 AS DiscountSaleKindId

                               , Object_PartionGoods.UnitId     AS UnitId_in
                               , Object_PartionGoods.CurrencyId AS CurrencyId
                               , CASE WHEN inIsOperPrice    = TRUE THEN Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END ELSE 0 :: TFloat END AS OperPrice

                                 -- ���-�� ������ �� ���������� - ������ ��� UnitId
                               , CASE WHEN _tmpUnit.UnitId > 0 THEN (Object_PartionGoods.Amount - COALESCE (tmpReturnOut.Amount, 0)) ELSE 0 END AS Income_Amount
                               , CASE WHEN _tmpUnit.UnitId > 0 THEN (Object_PartionGoods.Amount - COALESCE (tmpReturnOut.Amount, 0)) * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END ELSE 0 END AS Income_Summ

                                 -- ������� - ��� ����� "�����"
                               , 0 AS Remains_Amount
                               , 0 AS Remains_Summ
                                 -- ������� - � ������ "�����"
                               , 0 AS Remains_Amount_real

                                 -- �����������
                               , 0 AS SendIn_Amount
                               , 0 AS SendOut_Amount
                               , 0 AS SendIn_Summ
                               , 0 AS SendOut_Summ

                                 -- ���-��: �������� + ������� �������.
                               , COALESCE (tmpReturnOut.Amount, 0) AS Loss_Amount

                                 -- ���-��: ����
                               , 0 AS Debt_Amount
                                 -- �����: ����
                               , 0 AS Debt_Summ

                                 -- ���-��: ������ �������
                               , 0 AS Sale_Amount
                                 -- �\� ������� - calc �� ������ � ���
                               , 0 AS Sale_SummCost_calc

                                 -- ����� �������
                               , 0 AS Sale_Summ
                                  -- ��������� � ������ 
                               , 0 AS Sale_Summ_curr

                                 -- �\� ������� - ���
                               , 0 AS Sale_SummCost
                                 -- �\� ������� - ������
                               , 0 AS Sale_SummCost_curr

                                 -- ����� �����
                               , 0 AS Sale_Summ_10100
                                 -- �������� ������
                               , 0 AS Sale_Summ_10201
                                 -- ������ outlet
                               , 0 AS Sale_Summ_10202
                                 -- ������ �������
                               , 0 AS Sale_Summ_10203
                                 -- ������ ��������������
                               , 0 AS Sale_Summ_10204

                                 -- ������ �����
                               , 0 AS Sale_Summ_10200
                                  -- ��������� � ������ 
                               , 0 AS Sale_Summ_10200_curr

                                 -- ���-��: ������ �������
                               , 0 AS Return_Amount
                                 -- �\� ������� - calc �� ������ � ���
                               , 0 AS Return_SummCost_calc

                                 -- ����� �������
                               , 0 AS Return_Summ
                                  -- ��������� � ������ 
                               , 0 AS Return_Summ_curr

                                 -- �\� ������� - ���
                               , 0 AS Return_SummCost
                                 -- �\� ������� - ������
                               , 0 AS Return_SummCost_curr

                                 -- ������ �������
                               , 0 AS Return_Summ_10200
                                 -- ��������� � ������ 
                               , 0 AS Return_Summ_10200_curr

                                 -- ���-��: ������� - �������
                               , 0 AS Result_Amount

                                 --  � �/�
                               , 1 AS Ord -- ROW_NUMBER() OVER (PARTITION BY Object_PartionGoods.MovementItemId ORDER BY CASE WHEN Object_PartionGoods.UnitId = COALESCE (MIConatiner.ObjectExtId_Analyzer, Object_PartionGoods.UnitId) THEN 0 ELSE 1 END ASC) AS Ord

                                 -- ���-�� ������� (�� �������� �������)
                               , 0 AS Sale_Amount_InDiscount
                                 -- ���-�� ������� (�� �������� ������)
                               , 0 AS Sale_Amount_OutDiscount

                               --
                               -- , 2 as x1

                               , Object_PartionGoods.Olap_Goods
                               , Object_PartionGoods.Olap_Partion

                          FROM tmpPartionGoods AS Object_PartionGoods
                               -- !!!��� �����!!!
                               -- INNER JOIN Object ON Object.Id = Object_PartionGoods.GoodsId AND Object.ObjectCode = 89373

                               LEFT JOIN tmpReturnOut ON tmpReturnOut.PartionId = Object_PartionGoods.MovementItemId
                               LEFT JOIN _tmpUnit     ON _tmpUnit.UnitId        = Object_PartionGoods.UnitId

                          WHERE (_tmpUnit.UnitId > 0 OR inPartnerId <> 0 OR inBrandId <> 0)

                         UNION ALL
                          -- 3. ������� + ���������
                          SELECT Object_PartionGoods.MovementItemId AS PartionId
                               , Object_PartionGoods.BrandId
                               , Object_PartionGoods.PeriodId
                               , Object_PartionGoods.PeriodYear
                               , Object_PartionGoods.PartnerId

                               , Object_PartionGoods.GoodsGroupId
                               , Object_PartionGoods.LabelId
                               , Object_PartionGoods.CompositionGroupId
                               , Object_PartionGoods.CompositionId

                               , Object_PartionGoods.GoodsId
                               , Object_PartionGoods.GoodsInfoId
                               , Object_PartionGoods.LineFabricaId
                               , Object_PartionGoods.GoodsSizeId

                                 -- !!!��������!!!
                               , tmp.UnitId AS UnitId

                               , CASE WHEN inIsOperDate_doc = TRUE THEN DATE_TRUNC ('MONTH', Object_PartionGoods.OperDate) ELSE NULL :: TDateTime END AS OperDate_doc
                               , CASE WHEN inIsDay_doc      = TRUE THEN EXTRACT (DOW FROM Object_PartionGoods.OperDate)    ELSE NULL :: Integer   END AS OrdDay_doc
                               , 0 AS ClientId

                               , 0 AS ChangePercent
                               , 0 AS DiscountSaleKindId

                               , Object_PartionGoods.UnitId     AS UnitId_in
                               , Object_PartionGoods.CurrencyId AS CurrencyId
                               , CASE WHEN inIsOperPrice    = TRUE THEN Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END ELSE 0 :: TFloat END AS OperPrice

                                 -- ���-�� ������ �� ���������� - ������ ��� UnitId
                               , 0 AS Income_Amount
                               , 0 AS Income_Summ

                                 -- ������� - ��� ����� "�����"
                               , tmp.Remains_Amount        AS Remains_Amount
                               , tmp.Remains_Amount * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END AS Remains_Summ
                                 -- ������� - � ������ "�����"
                               , tmp.Remains_Amount_real   Remains_Amount_real

                                 -- �����������
                               , CASE WHEN tmp.Send_Amount > 0 THEN  1 * tmp.Send_Amount ELSE 0 END AS SendIn_Amount
                               , CASE WHEN tmp.Send_Amount < 0 THEN -1 * tmp.Send_Amount ELSE 0 END AS SendOut_Amount
                               , CASE WHEN tmp.Send_Amount > 0 THEN  1 * tmp.Send_Amount * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END ELSE 0 END AS SendIn_Summ
                               , CASE WHEN tmp.Send_Amount < 0 THEN -1 * tmp.Send_Amount * Object_PartionGoods.OperPrice / CASE WHEN Object_PartionGoods.CountForPrice > 0 THEN Object_PartionGoods.CountForPrice ELSE 1 END ELSE 0 END AS SendOut_Summ

                                 -- ���-��: �������� + ������� �������.
                               , 0 AS Loss_Amount

                                 -- ���-��: ����
                               , 0 AS Debt_Amount
                                 -- �����: ����
                               , 0 AS Debt_Summ

                                 -- ���-��: ������ �������
                               , 0 AS Sale_Amount
                                 -- �\� ������� - calc �� ������ � ���
                               , 0 AS Sale_SummCost_calc

                                 -- ����� �������
                               , 0 AS Sale_Summ
                                  -- ��������� � ������ 
                               , 0 AS Sale_Summ_curr

                                 -- �\� ������� - ���
                               , 0 AS Sale_SummCost
                                 -- �\� ������� - ������
                               , 0 AS Sale_SummCost_curr

                                 -- ����� �����
                               , 0 AS Sale_Summ_10100
                                 -- �������� ������
                               , 0 AS Sale_Summ_10201
                                 -- ������ outlet
                               , 0 AS Sale_Summ_10202
                                 -- ������ �������
                               , 0 AS Sale_Summ_10203
                                 -- ������ ��������������
                               , 0 AS Sale_Summ_10204

                                 -- ������ �����
                               , 0 AS Sale_Summ_10200
                                  -- ��������� � ������ 
                               , 0 AS Sale_Summ_10200_curr

                                 -- ���-��: ������ �������
                               , 0 AS Return_Amount
                                 -- �\� ������� - calc �� ������ � ���
                               , 0 AS Return_SummCost_calc

                                 -- ����� �������
                               , 0 AS Return_Summ
                                  -- ��������� � ������ 
                               , 0 AS Return_Summ_curr

                                 -- �\� ������� - ���
                               , 0 AS Return_SummCost
                                 -- �\� ������� - ������
                               , 0 AS Return_SummCost_curr

                                 -- ������ �������
                               , 0 AS Return_Summ_10200
                                 -- ��������� � ������ 
                               , 0 AS Return_Summ_10200_curr

                                 -- ���-��: ������� - �������
                               , 0 AS Result_Amount

                                 --  � �/�
                               , 1 AS Ord -- ROW_NUMBER() OVER (PARTITION BY Object_PartionGoods.MovementItemId ORDER BY CASE WHEN Object_PartionGoods.UnitId = COALESCE (MIConatiner.ObjectExtId_Analyzer, Object_PartionGoods.UnitId) THEN 0 ELSE 1 END ASC) AS Ord

                                 -- ���-�� ������� (�� �������� �������)
                               , 0 AS Sale_Amount_InDiscount
                                 -- ���-�� ������� (�� �������� ������)
                               , 0 AS Sale_Amount_OutDiscount

                               --
                               -- , 3 as x1

                               , Object_PartionGoods.Olap_Goods
                               , Object_PartionGoods.Olap_Partion

                          FROM tmpPartionGoods AS Object_PartionGoods
                               -- !!!��� �����!!!
                               -- INNER JOIN Object ON Object.Id = Object_PartionGoods.GoodsId AND Object.ObjectCode = 89373

                               INNER JOIN (SELECT COALESCE (tmpRemains.PartionId,   tmpSend.PartionId) AS PartionId
                                                , COALESCE (tmpRemains.UnitId,      tmpSend.UnitId)    AS UnitId
                                                , COALESCE (tmpRemains.Amount,      0)                 AS Remains_Amount
                                                , COALESCE (tmpRemains.Amount_real, 0)                 AS Remains_Amount_real
                                                , COALESCE (tmpSend.Amount,         0)                 AS Send_Amount
                                           FROM tmpRemains
                                                FULL JOIN tmpSend ON tmpSend.PartionId = tmpRemains.PartionId
                                                                 AND tmpSend.UnitId    = tmpRemains.UnitId
                                          ) AS tmp ON tmp.PartionId = Object_PartionGoods.MovementItemId
                         )
         , tmpData AS (SELECT tmpData_all.BrandId
                            , tmpData_all.PeriodId
                            , tmpData_all.PeriodYear
                            , tmpData_all.PartnerId
   
                            , tmpData_all.GoodsGroupId
                            , tmpData_all.LabelId
                            , tmpData_all.CompositionGroupId
                            , CASE WHEN inIsGoods = TRUE THEN tmpData_all.CompositionId ELSE 0 END AS CompositionId
   
                            , CASE WHEN inIsGoods = TRUE THEN tmpData_all.GoodsId       ELSE 0 END AS GoodsId
                            , CASE WHEN inIsGoods = TRUE THEN tmpData_all.GoodsInfoId   ELSE 0 END AS GoodsInfoId
                            , CASE WHEN inIsGoods = TRUE THEN tmpData_all.LineFabricaId ELSE 0 END AS LineFabricaId
                            , CASE WHEN inIsSize  = TRUE THEN tmpData_all.GoodsSizeId   ELSE 0 END AS GoodsSizeId
                            -- , STRING_AGG (DISTINCT CASE WHEN LENGTH (Object_GoodsSize.ValueData) = 1 THEN '0' ELSE '' END || Object_GoodsSize.ValueData, ', ' ORDER BY CASE WHEN LENGTH (Object_GoodsSize.ValueData) = 1 THEN '0' ELSE '' END || Object_GoodsSize.ValueData) AS GoodsSizeName
                            , STRING_AGG (DISTINCT Object_GoodsSize.ValueData, ', ' ORDER BY Object_GoodsSize.ValueData) AS GoodsSizeName
   
                            , tmpData_all.OperDate_doc
                            , tmpData_all.OrdDay_doc
                            , tmpData_all.UnitId
                            , tmpData_all.ClientId
                            , tmpData_all.ChangePercent
                            , tmpData_all.DiscountSaleKindId
   
                            , tmpData_all.UnitId_in
                            , tmpData_all.CurrencyId
   
                            , tmpData_all.OperPrice
                            , SUM (CASE WHEN tmpData_all.Ord = 1 THEN tmpData_all.Income_Amount ELSE 0 END) AS Income_Amount
                            , SUM (CASE WHEN tmpData_all.Ord = 1 THEN tmpData_all.Income_Summ   ELSE 0 END) AS Income_Summ
   
                            , SUM (tmpData_all.Remains_Amount)      AS Remains_Amount
                            , SUM (tmpData_all.Remains_Summ)        AS Remains_Summ
                            , SUM (tmpData_all.Remains_Amount_real) AS Remains_Amount_real

                            , SUM (tmpData_all.SendIn_Amount)       AS SendIn_Amount
                            , SUM (tmpData_all.SendOut_Amount)      AS SendOut_Amount
                            , SUM (tmpData_all.SendIn_Summ)         AS SendIn_Summ
                            , SUM (tmpData_all.SendOut_Summ)        AS SendOut_Summ

                            , SUM (tmpData_all.Sale_Amount_InDiscount)  AS Sale_InDiscount
                            , SUM (tmpData_all.Sale_Amount_OutDiscount) AS Sale_OutDiscount

                            , SUM (tmpData_all.Loss_Amount)             AS Loss_Amount

                            , SUM (tmpData_all.Debt_Amount)             AS Debt_Amount
                            , SUM (tmpData_all.Debt_Summ)               AS Debt_Summ

                            , SUM (tmpData_all.Sale_Amount)             AS Sale_Amount

                              -- ����� �������
                            , SUM (tmpData_all.Sale_Summ)             AS Sale_Summ
                            , SUM (tmpData_all.Sale_Summ_curr)        AS Sale_Summ_curr

                              -- �\� �������
                            , SUM (tmpData_all.Sale_SummCost_calc)    AS Sale_SummCost_calc -- calc �� ������ � ���
                            , SUM (tmpData_all.Sale_SummCost)         AS Sale_SummCost      -- ���
                            , SUM (tmpData_all.Sale_SummCost_curr)    AS Sale_SummCost_curr -- ������

                            , SUM (tmpData_all.Sale_Summ_10100)       AS Sale_Summ_10100
                            , SUM (tmpData_all.Sale_Summ_10201)       AS Sale_Summ_10201
                            , SUM (tmpData_all.Sale_Summ_10202)       AS Sale_Summ_10202
                            , SUM (tmpData_all.Sale_Summ_10203)       AS Sale_Summ_10203
                            , SUM (tmpData_all.Sale_Summ_10204)       AS Sale_Summ_10204

                              -- ������ �����
                            , SUM (tmpData_all.Sale_Summ_10200)       AS Sale_Summ_10200
                            , SUM (tmpData_all.Sale_Summ_10200_curr)  AS Sale_Summ_10200_curr

                            , SUM (tmpData_all.Return_Amount)         AS Return_Amount

                              -- ����� �������
                            , SUM (tmpData_all.Return_Summ)           AS Return_Summ
                            , SUM (tmpData_all.Return_Summ_curr)      AS Return_Summ_curr

                              -- �\� �������
                            , SUM (tmpData_all.Return_SummCost_calc)  AS Return_SummCost_calc -- calc �� ������ � ���
                            , SUM (tmpData_all.Return_SummCost)       AS Return_SummCost      -- ���
                            , SUM (tmpData_all.Return_SummCost_curr)  AS Return_SummCost_curr -- ������

                              -- ������ �������
                            , SUM (tmpData_all.Return_Summ_10200)      AS Return_Summ_10200
                            , SUM (tmpData_all.Return_Summ_10200_curr) AS Return_Summ_10200_curr

                            , SUM (tmpData_all.Result_Amount)         AS Result_Amount
                            -- , SUM (tmpData_all.Result_Summ)         AS Result_Summ
                            -- , SUM (tmpData_all.Result_SummCost)     AS Result_SummCost
                            -- , SUM (tmpData_all.Result_Summ_10200)   AS Result_Summ_10200

                            , tmpData_all.Olap_Goods
                            , tmpData_all.Olap_Partion

                            , ObjectLink_Parent0.ChildObjectId AS GroupId1
                            , ObjectLink_Parent1.ChildObjectId AS GroupId1_parent
   
                            , ObjectLink_Parent1.ChildObjectId AS GroupId2
                            , ObjectLink_Parent2.ChildObjectId AS GroupId2_parent
   
                            , ObjectLink_Parent2.ChildObjectId AS GroupId3
                            , ObjectLink_Parent3.ChildObjectId AS GroupId3_parent
   
                            , ObjectLink_Parent3.ChildObjectId AS GroupId4
                            , ObjectLink_Parent4.ChildObjectId AS GroupId4_parent
   
                            , ObjectLink_Parent4.ChildObjectId AS GroupId5
                            , ObjectLink_Parent5.ChildObjectId AS GroupId5_parent
   
                            , ObjectLink_Parent5.ChildObjectId AS GroupId6
                            , ObjectLink_Parent6.ChildObjectId AS GroupId6_parent
   
                            , ObjectLink_Parent6.ChildObjectId AS GroupId7
                            , ObjectLink_Parent7.ChildObjectId AS GroupId7_parent
   
                            , ObjectLink_Parent7.ChildObjectId AS GroupId8
                            , ObjectLink_Parent8.ChildObjectId AS GroupId8_parent
   
                       FROM tmpData_all AS tmpData_all
                            LEFT JOIN Object AS Object_GoodsSize ON Object_GoodsSize.Id = tmpData_all.GoodsSizeId
                            LEFT JOIN ObjectLink AS ObjectLink_Parent0
                                                 ON ObjectLink_Parent0.ObjectId = tmpData_all.GoodsId
                                                AND ObjectLink_Parent0.DescId   = zc_ObjectLink_Goods_GoodsGroup()
   
                            LEFT JOIN ObjectLink AS ObjectLink_Parent1
                                                 ON ObjectLink_Parent1.ObjectId = ObjectLink_Parent0.ChildObjectId
                                                AND ObjectLink_Parent1.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                            LEFT JOIN ObjectLink AS ObjectLink_Parent2
                                                 ON ObjectLink_Parent2.ObjectId = ObjectLink_Parent1.ChildObjectId
                                                AND ObjectLink_Parent2.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                            LEFT JOIN ObjectLink AS ObjectLink_Parent3
                                                 ON ObjectLink_Parent3.ObjectId = ObjectLink_Parent2.ChildObjectId
                                                AND ObjectLink_Parent3.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                            LEFT JOIN ObjectLink AS ObjectLink_Parent4
                                                 ON ObjectLink_Parent4.ObjectId = ObjectLink_Parent3.ChildObjectId
                                                AND ObjectLink_Parent4.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                            LEFT JOIN ObjectLink AS ObjectLink_Parent5
                                                 ON ObjectLink_Parent5.ObjectId = ObjectLink_Parent4.ChildObjectId
                                                AND ObjectLink_Parent5.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                            LEFT JOIN ObjectLink AS ObjectLink_Parent6
                                                 ON ObjectLink_Parent6.ObjectId = ObjectLink_Parent5.ChildObjectId
                                                AND ObjectLink_Parent6.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                            LEFT JOIN ObjectLink AS ObjectLink_Parent7
                                                 ON ObjectLink_Parent7.ObjectId = ObjectLink_Parent6.ChildObjectId
                                                AND ObjectLink_Parent7.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                            LEFT JOIN ObjectLink AS ObjectLink_Parent8
                                                 ON ObjectLink_Parent8.ObjectId = ObjectLink_Parent7.ChildObjectId
                                                AND ObjectLink_Parent8.DescId   = zc_ObjectLink_GoodsGroup_Parent()
                       GROUP BY tmpData_all.BrandId
                              , tmpData_all.PeriodId
                              , tmpData_all.PeriodYear
                              , tmpData_all.PartnerId
   
                              , tmpData_all.GoodsGroupId
                              , tmpData_all.LabelId
                              , tmpData_all.CompositionGroupId
                              , CASE WHEN inIsGoods = TRUE THEN tmpData_all.CompositionId ELSE 0 END
   
                              , CASE WHEN inIsGoods = TRUE THEN tmpData_all.GoodsId       ELSE 0 END
                              , CASE WHEN inIsGoods = TRUE THEN tmpData_all.GoodsInfoId   ELSE 0 END
                              , CASE WHEN inIsGoods = TRUE THEN tmpData_all.LineFabricaId ELSE 0 END
                              , CASE WHEN inIsSize  = TRUE THEN tmpData_all.GoodsSizeId   ELSE 0 END
   
                              , tmpData_all.OperDate_doc
                              , tmpData_all.OrdDay_doc
                              , tmpData_all.UnitId
                              , tmpData_all.ClientId
                              , tmpData_all.ChangePercent
                              , tmpData_all.DiscountSaleKindId
   
                              , tmpData_all.UnitId_in
                              , tmpData_all.CurrencyId
                              , tmpData_all.OperPrice

                              -- , tmpData_all.x1
   
                              , tmpData_all.Olap_Goods
                              , tmpData_all.Olap_Partion

                              , ObjectLink_Parent0.ChildObjectId
                              , ObjectLink_Parent1.ChildObjectId
                              , ObjectLink_Parent1.ChildObjectId
                              , ObjectLink_Parent2.ChildObjectId
                              , ObjectLink_Parent2.ChildObjectId
                              , ObjectLink_Parent3.ChildObjectId
                              , ObjectLink_Parent3.ChildObjectId
                              , ObjectLink_Parent4.ChildObjectId
                              , ObjectLink_Parent4.ChildObjectId
                              , ObjectLink_Parent5.ChildObjectId
                              , ObjectLink_Parent5.ChildObjectId
                              , ObjectLink_Parent6.ChildObjectId
                              , ObjectLink_Parent6.ChildObjectId
                              , ObjectLink_Parent7.ChildObjectId
                              , ObjectLink_Parent7.ChildObjectId
                              , ObjectLink_Parent8.ChildObjectId
                       )
         , tmpDayOfWeek AS (SELECT zfCalc.Ord_dow, zfCalc.DayOfWeekName
                            FROM (SELECT GENERATE_SERIES (CURRENT_DATE, CURRENT_DATE + INTERVAL '6 DAY', '1 DAY' :: INTERVAL) AS OperDate) AS tmp
                                 CROSS JOIN zfCalc_DayOfWeekName_cross (tmp.OperDate) AS zfCalc
                           )

        -- ���������
        SELECT Object_Brand.ValueData        :: VarChar (100) AS BrandName
             , Object_Period.ValueData       :: VarChar (25)  AS PeriodName
             , tmpData.PeriodYear            :: Integer       AS PeriodYear
             , Object_Partner.Id                              AS PartnerId
             , Object_Partner.ValueData      :: VarChar (100) AS PartnerName

             -- , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupName_all
             , Object_GoodsGroup.ValueData                    AS GoodsGroupName
             , Object_Label.ValueData        :: VarChar (100) AS LabelName
             -- , Object_CompositionGroup.ValueData  AS CompositionGroupName
             , Object_Composition.ValueData  :: VarChar (50)  AS CompositionName

             , Object_Goods.Id                                AS GoodsId
             , Object_Goods.ObjectCode                        AS GoodsCode
             , Object_Goods.ValueData        :: VarChar (100) AS GoodsName
             , Object_GoodsInfo.ValueData    :: VarChar (100) AS GoodsInfoName
             , Object_LineFabrica.ValueData  :: VarChar (50)  AS LineFabricaName
             -- , Object_Fabrika.ValueData                    AS FabrikaName

             -- , Object_GoodsSize.Id                            AS GoodsSizeId
             -- , Object_GoodsSize.ValueData :: VarChar (50)  AS GoodsSizeName
             , tmpData.GoodsSizeId           :: Integer       AS GoodsSizeId
             , tmpData.GoodsSizeName         :: VarChar (50)  AS GoodsSizeName 

             , zfCalc_MonthYearName_cross (tmpData.OperDate_doc) :: VarChar (25) AS PeriodName_doc
             , EXTRACT (YEAR FROM tmpData.OperDate_doc)          :: Integer      AS PeriodYear_doc
             , zfCalc_MonthName_cross (tmpData.OperDate_doc)     :: VarChar (25) AS MonthName_doc
             , tmpDayOfWeek.DayOfWeekName                        :: VarChar (4)  AS DayName_doc

             , Object_Unit.ValueData        :: VarChar (100) AS UnitName
             , Object_Client.ValueData      :: VarChar (100) AS ClientName
             , Object_DiscountSaleKind.ValueData :: VarChar (15) AS DiscountSaleKindName
             , tmpData.ChangePercent        :: TFloat        AS ChangePercent
                                            
             , Object_Unit_In.ValueData     :: VarChar (100) AS UnitName_In
             , Object_Currency.ValueData    :: VarChar (10)  AS CurrencyName

             , CASE WHEN inIsOperPrice = TRUE      THEN tmpData.OperPrice
                    WHEN tmpData.Income_Amount > 0 THEN tmpData.Income_Summ        / tmpData.Income_Amount
                    WHEN tmpData.Sale_Amount   > 0 THEN tmpData.Sale_SummCost_curr / tmpData.Sale_Amount
                    WHEN tmpData.SendIn_Amount > 0 THEN tmpData.SendIn_Summ        / tmpData.SendIn_Amount
                    WHEN tmpData.Debt_Amount   > 0 THEN tmpData.Debt_Summ          / tmpData.Debt_Amount
                    
                    ELSE 0
               END                          :: TFloat AS OperPrice

               -- ������, � ����� �������� ���� ���� �������� ��� ������� ����������
             , tmpData.Income_Amount        :: TFloat AS Income_Amount
             , tmpData.Income_Summ          :: TFloat AS Income_Summ
                                            
               -- ������� - ��� ����� "�����"
             , tmpData.Remains_Amount       :: TFloat AS Remains_Amount
             , tmpData.Remains_Summ         :: TFloat AS Remains_Summ
               -- ������� - � ������ "�����"
             , tmpData.Remains_Amount_real  :: TFloat AS Remains_Amount_real

               -- �����������
             , tmpData.SendIn_Amount        :: TFloat AS SendIn_Amount
             , tmpData.SendOut_Amount       :: TFloat AS SendOut_Amount
             , tmpData.SendIn_Summ          :: TFloat AS SendIn_Summ
             , tmpData.SendIn_Summ          :: TFloat AS SendIn_Summ

               -- ���-��: �������� + ������� �������.
             , tmpData.Loss_Amount          :: TFloat

               -- ���-�� ������� - "����"
             , tmpData.Debt_Amount          :: TFloat
               -- ����� ������� - "����"
             , tmpData.Debt_Summ            :: TFloat

               -- ���-�� ������� - � ������ "�����"
             , (tmpData.Sale_Amount + tmpData.Debt_Amount) :: TFloat AS Sale_Amount
               -- ���-�� ������� - ��� ����� "�����"
             , tmpData.Sale_Amount          :: TFloat AS Sale_Amount_real

               -- ���-�� ������� - �� �������� �������
             , tmpData.Sale_InDiscount      :: TFloat
               -- ���-�� ������� - �� �������� ������
             , tmpData.Sale_OutDiscount     :: TFloat

               -- ����� ������� - ��� ����� "�����"
             , tmpData.Sale_Summ            :: TFloat
             , tmpData.Sale_Summ_curr       :: TFloat
                                            
               -- �\� ������� - ��� ����� "�����"
             , tmpData.Sale_SummCost_calc   :: TFloat AS Sale_SummCost      -- calc �� ������ � ���
             , tmpData.Sale_SummCost_curr   :: TFloat AS Sale_SummCost_curr -- ������

               -- ����. ���� �������
             , (tmpData.Sale_SummCost - tmpData.Sale_SummCost_calc) :: TFloat AS Sale_SummCost_diff
               -- ������� ������� � ������ �������� ������� - ��� ����� "�����"
             , (tmpData.Sale_Summ     - tmpData.Sale_SummCost_calc) :: TFloat AS Sale_Summ_prof

             , tmpData.Sale_Summ_10100      :: TFloat
             , tmpData.Sale_Summ_10201      :: TFloat
             , tmpData.Sale_Summ_10202      :: TFloat
             , tmpData.Sale_Summ_10203      :: TFloat
             , tmpData.Sale_Summ_10204      :: TFloat

               -- ������ �����
             , tmpData.Sale_Summ_10200      :: TFloat
             , tmpData.Sale_Summ_10200_curr :: TFloat
                                            
               -- ���-�� �������
             , tmpData.Return_Amount        :: TFloat

               -- ����� �������
             , tmpData.Return_Summ          :: TFloat
             , tmpData.Return_Summ_curr     :: TFloat

               -- �\� �������
             , tmpData.Return_SummCost_calc :: TFloat AS Return_SummCost      -- calc �� ������ � ���
             , tmpData.Return_SummCost_curr :: TFloat AS Return_SummCost_curr -- ������

               -- ����. ���� �������
             , (tmpData.Return_SummCost - tmpData.Return_SummCost_calc) :: TFloat AS Return_SummCost_diff
               -- ������ �������
             , (tmpData.Return_Summ     - tmpData.Return_SummCost_calc) :: TFloat AS Return_Summ_prof

               -- ������ �������
             , tmpData.Return_Summ_10200      :: TFloat
             , tmpData.Return_Summ_10200_curr :: TFloat

               -- ���. ���� - � ������ "�����"
             , (tmpData.Result_Amount + tmpData.Debt_Amount)     :: TFloat AS Result_Amount
               -- ���. ���� - ��� ����� "�����"
             , tmpData.Result_Amount                             :: TFloat AS Result_Amount_real

               -- ����� ���� - ��� ����� "�����"
             , (tmpData.Sale_Summ          - tmpData.Return_Summ)           :: TFloat AS Result_Summ
             , (tmpData.Sale_Summ_curr     - tmpData.Return_Summ_curr)      :: TFloat AS Result_Summ_curr

               -- �\� ���� - ��� ����� "�����"
             , (tmpData.Sale_SummCost_calc - tmpData.Return_SummCost_calc)  :: TFloat AS Result_SummCost
             , (tmpData.Sale_SummCost_curr - tmpData.Return_SummCost_curr)  :: TFloat AS Result_SummCost_curr

               -- ����. ����. ����
             , (tmpData.Sale_SummCost - tmpData.Sale_SummCost_calc - tmpData.Return_SummCost + tmpData.Return_SummCost_calc) :: TFloat AS Result_SummCost_diff

               -- ������� ���� � ������ �������� ������� - ��� ����� "�����"
             , (tmpData.Sale_Summ      - tmpData.Sale_SummCost_calc - tmpData.Return_Summ      + tmpData.Return_SummCost_calc)         :: TFloat AS Result_Summ_prof
             , (tmpData.Sale_Summ_curr - tmpData.Sale_SummCost_curr - tmpData.Return_Summ_curr + tmpData.Return_SummCost_curr)         :: TFloat AS Result_Summ_prof_curr

               -- ������ ����
             , (tmpData.Sale_Summ_10200      - tmpData.Return_Summ_10200)        :: TFloat AS Result_Summ_10200
             , (tmpData.Sale_Summ_10200_curr - tmpData.Return_Summ_10200_curr)   :: TFloat AS Result_Summ_10200_curr

               -- % ������: ���-�� �������    / ���-�� ������ - � ������ "�����"
             , CASE WHEN (tmpData.Result_Amount + tmpData.Debt_Amount) > 0 AND (tmpData.Income_Amount + tmpData.SendIn_Amount) > 0
                         THEN (tmpData.Result_Amount + tmpData.Debt_Amount) / (tmpData.Income_Amount + tmpData.SendIn_Amount) * 100
                    ELSE 0
               END :: TFloat AS Tax_Amount
               -- % ������: ���-�� �������    / ���-�� ������ - ��� ����� "�����"
             , CASE WHEN tmpData.Result_Amount > 0 AND tmpData.Income_Amount > 0
                         THEN tmpData.Result_Amount / tmpData.Income_Amount * 100
                    ELSE 0
               END :: TFloat AS Tax_Amount_real

               -- % ������: ����� �/� ������� / ����� �/� ������ - ��� ����� "�����"
             , CASE WHEN (tmpData.Sale_SummCost_curr - tmpData.Return_SummCost_curr) > 0 AND tmpData.Income_Summ > 0
                         THEN (tmpData.Sale_SummCost_curr - tmpData.Return_SummCost_curr) / tmpData.Income_Summ * 100
                    ELSE 0
               END :: TFloat AS Tax_Summ_curr

               -- % ��������������: ����� ������� / ����� �/� - ��� ����� "�����"
             , CASE WHEN (tmpData.Sale_Summ_curr     - tmpData.Return_Summ_curr) > 0 AND (tmpData.Sale_SummCost_curr - tmpData.Return_SummCost_curr) > 0
                         THEN (tmpData.Sale_Summ_curr     - tmpData.Return_Summ_curr) / (tmpData.Sale_SummCost_curr - tmpData.Return_SummCost_curr) * 100 - 100
                    ELSE 0
               END :: TFloat AS Tax_Summ_prof

               -- 1 - ����� ������� �������
             , CASE WHEN tmpData.GroupId1_parent IS NULL
                         THEN Object_GoodsGroup1.ValueData
                    WHEN tmpData.GroupId2_parent IS NULL
                         THEN Object_GoodsGroup2.ValueData
                    WHEN tmpData.GroupId3_parent IS NULL
                         THEN Object_GoodsGroup3.ValueData
                    WHEN tmpData.GroupId4_parent IS NULL
                         THEN Object_GoodsGroup4.ValueData
                    WHEN tmpData.GroupId5_parent IS NULL
                         THEN Object_GoodsGroup5.ValueData
                    WHEN tmpData.GroupId6_parent IS NULL
                         THEN Object_GoodsGroup6.ValueData
                    WHEN tmpData.GroupId7_parent IS NULL
                         THEN Object_GoodsGroup7.ValueData
                    WHEN tmpData.GroupId8_parent IS NULL
                         THEN Object_GoodsGroup8.ValueData
               END :: VarChar (50) AS GroupsName1

               -- 2 - ��������� ����� �.1. + !!!��� "�������" - ��� ���������!!!
             , CASE WHEN tmpData.GroupId2_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup1.ValueData)) = TRIM (LOWER ('�������'))
                                   THEN Object_GoodsGroup1.ValueData -- Object_Label.ValueData
                                   ELSE Object_GoodsGroup1.ValueData
                              END
                    WHEN tmpData.GroupId3_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup2.ValueData)) = TRIM (LOWER ('�������'))
                                   THEN Object_GoodsGroup2.ValueData -- Object_GoodsGroup1.ValueData
                                   ELSE Object_GoodsGroup2.ValueData
                              END
                    WHEN tmpData.GroupId4_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup3.ValueData)) = TRIM (LOWER ('�������'))
                                   THEN Object_GoodsGroup3.ValueData -- Object_GoodsGroup2.ValueData
                                   ELSE Object_GoodsGroup3.ValueData
                              END
                    WHEN tmpData.GroupId5_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup4.ValueData)) = TRIM (LOWER ('�������'))
                                   THEN Object_GoodsGroup4.ValueData -- Object_GoodsGroup3.ValueData
                                   ELSE Object_GoodsGroup4.ValueData
                              END
                    WHEN tmpData.GroupId6_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup5.ValueData)) = TRIM (LOWER ('�������'))
                                   THEN Object_GoodsGroup5.ValueData -- Object_GoodsGroup4.ValueData
                                   ELSE Object_GoodsGroup5.ValueData
                              END
                    WHEN tmpData.GroupId7_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup6.ValueData)) = TRIM (LOWER ('�������'))
                                   THEN Object_GoodsGroup6.ValueData -- Object_GoodsGroup5.ValueData
                                   ELSE Object_GoodsGroup6.ValueData
                              END
                    WHEN tmpData.GroupId8_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup7.ValueData)) = TRIM (LOWER ('�������'))
                                   THEN Object_GoodsGroup7.ValueData -- Object_GoodsGroup6.ValueData
                                   ELSE Object_GoodsGroup7.ValueData
                              END
               END :: VarChar (50) AS GroupsName2

               -- 3 - ��������� ����� �.2. + !!!��� "�������" - ��� ���������!!!
             , CASE WHEN tmpData.GroupId2_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup2.ValueData)) = TRIM (LOWER ('�������'))
                                   THEN Object_Label.ValueData
                                   ELSE Object_Label.ValueData
                              END
                    WHEN tmpData.GroupId3_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup2.ValueData)) = TRIM (LOWER ('�������'))
                                   THEN Object_GoodsGroup1.ValueData
                                   ELSE Object_GoodsGroup1.ValueData
                              END
                    WHEN tmpData.GroupId4_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup3.ValueData)) = TRIM (LOWER ('�������'))
                                   THEN Object_GoodsGroup2.ValueData -- Object_GoodsGroup1.ValueData
                                   ELSE Object_GoodsGroup2.ValueData
                              END
                    WHEN tmpData.GroupId5_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup4.ValueData)) = TRIM (LOWER ('�������'))
                                   THEN Object_GoodsGroup3.ValueData -- Object_GoodsGroup2.ValueData
                                   ELSE Object_GoodsGroup3.ValueData
                              END
                    WHEN tmpData.GroupId6_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup5.ValueData)) = TRIM (LOWER ('�������'))
                                   THEN Object_GoodsGroup4.ValueData -- Object_GoodsGroup3.ValueData
                                   ELSE Object_GoodsGroup4.ValueData
                              END
                    WHEN tmpData.GroupId7_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup6.ValueData)) = TRIM (LOWER ('�������'))
                                   THEN Object_GoodsGroup5.ValueData -- Object_GoodsGroup4.ValueData
                                   ELSE Object_GoodsGroup5.ValueData
                              END
                    WHEN tmpData.GroupId8_parent IS NULL
                         THEN CASE WHEN TRIM (LOWER (Object_GoodsGroup7.ValueData)) = TRIM (LOWER ('�������'))
                                   THEN Object_GoodsGroup6.ValueData -- Object_GoodsGroup5.ValueData
                                   ELSE Object_GoodsGroup6.ValueData
                              END
               END :: VarChar (50) AS GroupsName3

               -- 0 - ������ ������ �����
             , Object_GoodsGroup1.ValueData :: VarChar (50) AS GroupsName4 -- � ���� AnalyticaName1, � � GroupsName4 - ������ LabelName

             , CASE WHEN tmpData.Olap_Goods   > 0 THEN TRUE ELSE FALSE END AS isOLAP_Goods
             , CASE WHEN tmpData.Olap_Partion > 0 THEN TRUE ELSE FALSE END AS isOLAP_Partion
        FROM tmpData
            LEFT JOIN tmpDayOfWeek ON tmpDayOfWeek.Ord_dow = tmpData.OrdDay_doc

            LEFT JOIN Object AS Object_Client           ON Object_Client.Id           = tmpData.ClientId
            LEFT JOIN Object AS Object_Partner          ON Object_Partner.Id          = tmpData.PartnerId
            LEFT JOIN Object AS Object_Unit             ON Object_Unit.Id             = tmpData.UnitId
            LEFT JOIN Object AS Object_Unit_In          ON Object_Unit_In.Id          = tmpData.UnitId_in
            LEFT JOIN Object AS Object_Currency         ON Object_Currency.Id         = tmpData.CurrencyId
            LEFT JOIN Object AS Object_DiscountSaleKind ON Object_DiscountSaleKind.Id = tmpData.DiscountSaleKindId

            -- LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
            --                        ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpData.GoodsId
            --                       AND ObjectString_Goods_GoodsGroupFull.DescId   = zc_ObjectString_Goods_GroupNameFull()

            LEFT JOIN Object AS Object_Goods            ON Object_Goods.Id            = tmpData.GoodsId
            LEFT JOIN Object AS Object_GoodsGroup       ON Object_GoodsGroup.Id       = tmpData.GoodsGroupId
            LEFT JOIN Object AS Object_Label            ON Object_Label.Id            = tmpData.LabelId
            LEFT JOIN Object AS Object_Composition      ON Object_Composition.Id      = tmpData.CompositionId
            -- LEFT JOIN Object AS Object_CompositionGroup ON Object_CompositionGroup.Id = tmpData.CompositionGroupId
            LEFT JOIN Object AS Object_GoodsInfo        ON Object_GoodsInfo.Id        = tmpData.GoodsInfoId
            LEFT JOIN Object AS Object_LineFabrica      ON Object_LineFabrica.Id      = tmpData.LineFabricaId
            -- LEFT JOIN Object AS Object_GoodsSize        ON Object_GoodsSize.Id        = tmpData.GoodsSizeId
            LEFT JOIN Object AS Object_Brand            ON Object_Brand.Id            = tmpData.BrandId
            LEFT JOIN Object AS Object_Period           ON Object_Period.Id           = tmpData.PeriodId
            LEFT JOIN Object AS Object_Fabrika          ON Object_Fabrika.Id          = NULL -- tmpData.FabrikaId

            LEFT JOIN Object AS Object_GoodsGroup1 ON Object_GoodsGroup1.Id = tmpData.GroupId1
            LEFT JOIN Object AS Object_GoodsGroup2 ON Object_GoodsGroup2.Id = tmpData.GroupId2
            LEFT JOIN Object AS Object_GoodsGroup3 ON Object_GoodsGroup3.Id = tmpData.GroupId3
            LEFT JOIN Object AS Object_GoodsGroup4 ON Object_GoodsGroup4.Id = tmpData.GroupId4
            LEFT JOIN Object AS Object_GoodsGroup5 ON Object_GoodsGroup5.Id = tmpData.GroupId5
            LEFT JOIN Object AS Object_GoodsGroup6 ON Object_GoodsGroup6.Id = tmpData.GroupId6
            LEFT JOIN Object AS Object_GoodsGroup7 ON Object_GoodsGroup7.Id = tmpData.GroupId7
            LEFT JOIN Object AS Object_GoodsGroup8 ON Object_GoodsGroup8.Id = tmpData.GroupId8
           ;

 END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.  ��������� �.�.
 16.05.18         * add isOlap
 07.02.18         
*/

-- ����
-- SELECT LabelName, GroupsName4, GroupsName3, GroupsName2, GroupsName1 FROM gpReport_SaleOLAP (inStartDate:= '01.01.2017', inEndDate:= '31.12.2017', inUnitId:= 0, inPartnerId:= 2628, inBrandId:= 0, inPeriodId:= 0, inStartYear:= 2017, inEndYear:= 2017, inIsYear:= FALSE, inIsPeriodAll:= TRUE, inIsGoods:= FALSE, inIsSize:= FALSE, inIsClient_doc:= FALSE, inIsOperDate_doc:= FALSE, inIsDay_doc:= FALSE, inIsOperPrice:= FALSE, inIsDiscount:= FALSE, inSession:= zfCalc_UserAdmin());
-- SELECT * FROM gpReport_SaleOLAP (inStartDate:= '01.01.2017', inEndDate:= '31.12.2017', inUnitId:= 0, inPartnerId:= 2628, inBrandId:= 0, inPeriodId:= 0, inStartYear:= 2017, inEndYear:= 2017, inIsYear:= TRUE, inIsPeriodAll:= TRUE, inIsGoods:= FALSE, inIsSize:= FALSE, inIsClient_doc:= FALSE, inIsOperDate_doc:= FALSE, inIsDay_doc:= FALSE, inIsOperPrice:= FALSE, inIsDiscount:= FALSE, inSession:= zfCalc_UserAdmin());
